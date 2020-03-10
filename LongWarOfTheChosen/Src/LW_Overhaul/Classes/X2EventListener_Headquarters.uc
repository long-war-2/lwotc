// X2EventListener_Headquarters.uc
// 
// A listener template that handles events fired in relation to headquarters,
// be they XCOM, Resistance, or Alien.
//
class X2EventListener_Headquarters extends X2EventListener config(LW_Overhaul);

var config string CA_FAILURE_RISK_MARKER;
var config array<float> CA_RISK_REDUCTION_PER_RANK;
var config int LISTENER_PRIORITY;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateXComHQListeners());
	Templates.AddItem(CreateCovertActionListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateXComHQListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'XComHQListeners');
	Template.AddCHEvent('OverrideScienceScore', OverrideScienceScore, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CanTechBeInspired', CanTechBeInspired, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('UIAvengerShortcuts_ShowCQResistanceOrders', ShowOrHideResistanceOrdersButton, ELD_Immediate, GetListenerPriority());

	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateCovertActionListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'CovertActionListeners');
	Template.AddCHEvent('CovertAction_PreventGiveRewards', CAPreventRewardOnFailure, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CovertAction_AllowResActivityRecord', CAPreventRecordingOnFailure, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CovertActionRisk_AlterChanceModifier', CAAdjustRiskChance, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CovertAction_OverrideRiskStrings', CAOverrideRiskStrings, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('StaffUpdated', CARecalculateRisksForUI, ELD_OnStateSubmitted, GetListenerPriority());

	Template.RegisterInStrategy = true;

	return Template;
}

static protected function int GetListenerPriority()
{
	return default.LISTENER_PRIORITY != -1 ? default.LISTENER_PRIORITY : class'XComGameState_LWListenerManager'.default.DEFAULT_LISTENER_PRIORITY;
}

static function EventListenerReturn OverrideScienceScore(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit Scientist;
	local XComGameState_StaffSlot StaffSlot;
	local XComLWTuple Tuple;
	local int CurrScienceScore;
	local int idx;
	local bool AddLabBonus;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
	{
		`LWTrace("OverrideScienceScore event not fired with a Tuple as its data");
		return ELR_NoInterrupt;
	}

	CurrScienceScore = Tuple.Data[0].i;
	AddLabBonus = Tuple.Data[1].b;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	// If AddLabBonus is true, we're computing science scores, so we should remove the contribution from any scientist assigned
	// to a facility that isn't the lab. If it's false, we're checking a science gate and should consider all scientists regardless
	// of their location.
	if (AddLabBonus)
	{
		for (idx = 0; idx < XComHQ.Crew.Length; ++idx)
		{
			Scientist = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));

			// Only worry about living scientists, and skip Tygan. LWOTC: Scientists on covert actions
			// (which includes haven advisers) are handled by the base game, so ignore those too.
			if (Scientist.IsScientist() && !Scientist.IsDead() && !Scientist.IsOnCovertAction() &&
				Scientist.GetMyTemplateName() != 'HeadScientist')
			{
				// This scientist was counted by the base game. If they are in a staff slot that is not the lab,
				// remove their score.
				StaffSlot = Scientist.GetStaffSlot();
				if (StaffSlot != none && StaffSlot.GetMyTemplateName() != 'LaboratoryStaffSlot')
				{
					CurrScienceScore -= Scientist.GetSkillLevel(AddLabBonus);
				}
			}
		}
	}

	Tuple.Data[0].i = CurrScienceScore;
	return ELR_NoInterrupt;
}

// Prevent repeatable research from being inspired.
static function EventListenerReturn CanTechBeInspired(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Tech TechState;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
	{
		`LWTrace("CanTechBeInspired event not fired with a Tuple as its data");
		return ELR_NoInterrupt;
	}

	// Exclude repeatable research from inspiration
	TechState = XComGameState_Tech(EventSource);
	Tuple.Data[0].b = !TechState.GetMyTemplate().bRepeatable;

	return ELR_NoInterrupt;
}

static function EventListenerReturn ShowOrHideResistanceOrdersButton(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComLWTuple Tuple;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	// The event expects `true` if the button should be shown, or
	// `false` if it should be hidden.
	Tuple.Data[0].b = class'Helpers_LW'.static.AreResistanceOrdersEnabled();

	return ELR_NoInterrupt;
}

// Don't give the rewards if the covert action failed.
static function EventListenerReturn CAPreventRewardOnFailure(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState_CovertAction CAState;
	local XComLWTuple Tuple;
	local CovertActionRisk Risk;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	CAState = XComGameState_CovertAction(EventSource);
	if (CAState == none) return ELR_NoInterrupt;

	// Find the failure risk and check whether it occurs.
	foreach CAState.Risks(Risk)
	{
		if (InStr(Caps(Risk.RiskTemplateName), Caps(default.CA_FAILURE_RISK_MARKER)) == 0)
		{
			if (Risk.bOccurs)
			{
				// The failure risk has triggered, so prevent covert action
				// completion code from giving the rewards.
				Tuple.Data[0].b = true;
				break;
			}
		}
	}

	return ELR_NoInterrupt;
}

// Don't record the resistance activity if the covert action failed.
static function EventListenerReturn CAPreventRecordingOnFailure(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState_CovertAction CAState;
	local XComLWTuple Tuple;
	local CovertActionRisk Risk;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	CAState = XComGameState_CovertAction(EventSource);
	if (CAState == none) return ELR_NoInterrupt;

	// Find the failure risk and check whether it occurs.
	foreach CAState.Risks(Risk)
	{
		if (InStr(Caps(Risk.RiskTemplateName), Caps(default.CA_FAILURE_RISK_MARKER)) == 0)
		{
			if (Risk.bOccurs)
			{
				// The failure risk has triggered, so prevent covert action
				// completion code from recording this resistance activity.
				// Note that this is `false` because `true` means the listener
				// is *allowing* the recording of this action.
				Tuple.Data[0].b = false;
				break;
			}
		}
	}

	return ELR_NoInterrupt;
}

// The chance of a covert action failure is adjusted by the ranks of the
// soldiers on the covert action. The higher the rank, the lower the chance
// of failure.
static function EventListenerReturn CAAdjustRiskChance(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState_CovertAction CAState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit UnitState;
	local XComLWTuple Tuple;
	local CovertActionRisk Risk;
	local int i, RiskIndex, RiskReduction;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	CAState = XComGameState_CovertAction(EventSource);
	if (CAState == none) return ELR_NoInterrupt;

	// We're only interested in altering the risk chance for the failure
	// risk right now.
	if (InStr(Caps(Tuple.Data[0].n), Caps(default.CA_FAILURE_RISK_MARKER)) == INDEX_NONE)
		return ELR_NoInterrupt;

	// Go through all the soldier slots, building up the failure risk
	// reduction based on the soldiers' ranks.
	RiskReduction = 0;
	for (i = 0; i < CAState.StaffSlots.Length; i++)
	{
		SlotState = CAState.GetStaffSlot(i);
		if (SlotState.IsSlotFilled())
		{
			UnitState = SlotState.GetAssignedStaff();
			if (UnitState.IsSoldier())
			{
				RiskReduction += UnitState.GetRank() * `ScaleStrategyArrayFloat(default.CA_RISK_REDUCTION_PER_RANK);
			}
		}
	}

	// Adjust risk reduction by number of soldiers (we don't want risk reduction scaling
	// by number of soldiers, just the relative ranks of those soldiers).
	RiskReduction = Round(RiskReduction * 2 / CAState.StaffSlots.Length);

	// Make sure we don't go negative on the risk chance.
	RiskIndex = CAState.Risks.Find('RiskTemplateName', Tuple.Data[0].n);
	if (RiskIndex != INDEX_NONE)
	{
		Risk = CAState.Risks[RiskIndex];
		RiskReduction = Min(RiskReduction, Risk.ChanceToOccur);
	}
	else
	{
		`REDSCREEN("Cannot find covert action risk " $ Tuple.Data[0].n $ " in this CA's list of risks");
	}

	// Modify the current risk chance modifier by the risk reduction
	// we just calculated.
	Tuple.Data[4].i -= RiskReduction;

	return ELR_NoInterrupt;
}

// Called when a staff slot is updated, this function will force a
// recalculation of the current covert action's risks (if the
// Covert Actions screen is open when the event is fired).
static function EventListenerReturn CARecalculateRisksForUI(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local UICovertActions CAScreen;
	local XComGameState_CovertAction CAState;

	CAScreen = UICovertActions(`SCREENSTACK.GetFirstInstanceOf(class'UICovertActions'));
	if (CAScreen == none)
	{
		// We're not in the Covert Actions screen, so we don't care about the
		// 'StaffUpdated' event.
		return ELR_NoInterrupt;
	}

	CAState = CAScreen.GetAction();
	CAState.RecalculateRiskChanceToOccurModifiers();

	return ELR_NoInterrupt;
}

static function EventListenerReturn CAOverrideRiskStrings(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState_CovertAction CAState;
	local CovertActionRisk Risk;
	local XComLWTuple Tuple;
	local string RiskChanceString, NewChanceString;
	local int i;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	CAState = XComGameState_CovertAction(EventSource);
	if (CAState == none) return ELR_NoInterrupt;

	for (i = 0; i < Tuple.Data[0].as.Length; i++)
	{
		Risk = CAState.Risks[i];

		RiskChanceString = class'X2StrategyGameRulesetDataStructures'.default.CovertActionRiskLabels[Risk.Level];
		NewChanceString = string(Risk.ChanceToOccur + Risk.ChanceToOccurModifier) $ "%";

		// This is replacing the risk value with the percentage chance to occur.
		Tuple.Data[1].as[i] = Repl(Tuple.Data[1].as[i], RiskChanceString, NewChanceString);
	}
	return ELR_NoInterrupt;
}
