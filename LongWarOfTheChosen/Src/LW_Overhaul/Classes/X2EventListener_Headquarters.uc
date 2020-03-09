// X2EventListener_Headquarters.uc
// 
// A listener template that handles events fired in relation to headquarters,
// be they XCOM, Resistance, or Alien.
//
class X2EventListener_Headquarters extends X2EventListener config(LW_Overhaul);

var config int LISTENER_PRIORITY;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateXComHQListeners());

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
