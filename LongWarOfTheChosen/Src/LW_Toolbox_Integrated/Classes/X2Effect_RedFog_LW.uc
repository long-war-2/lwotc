//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_RedFog_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Implements Red Fog, which decreases stats based on damage taken 
//---------------------------------------------------------------------------------------
class X2Effect_RedFog_LW extends X2Effect_ModifyStats
	config(LW_Toolbox);

//

struct RedFogPenalty
{
	var ECharStatType Stat;
	var float InitialRate;
	var float MaxPenalty;
};

var config array<name> TypesImmuneToRedFog;
var config array<name> TypesHalfImmuneToRedFog;

var config array<RedFogPenalty> LinearRedFogPenalties;
var config array<RedFogPenalty> QuadraticRedFogPenalties;

var localized string RedFogEffectName;
var localized string RedFogEffectDesc;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	// allows activation/deactivation of effect
	`XEVENTMGR.RegisterForEvent(EffectObj, 'UpdateRedFogActivation', UpdateActivation, ELD_OnStateSubmitted,,UnitState,, EffectObj); 
}

static function EventListenerReturn UpdateActivation(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState, UpdatedUnitState;
	local XComGameState_Effect EffectState;
	local XComGameState NewGameState;
	local XComGameState_LWToolboxOptions ToolBoxOptions;

	`LOG("Red Fog UpdateActivation Listener: Started",, 'LW_Toolbox');

	ToolBoxOptions = XComGameState_LWToolboxOptions(EventData);
	if(ToolboxOptions == none)
		`REDSCREEN("RedFog UpdateActivation: No Toolbox Option data passed");
	EffectState = XComGameState_Effect(CallbackData);
	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
		UnitState = GetTargetUnit(EffectState);
	if (UnitState == none)
	{
		`REDSCREEN("RedFog UpdateActivation: No Valid Target");
		return ELR_NoInterrupt;
	}

	`LOG("ActivateForXCom Listener: Testing Activation");
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update RedFog Activation");
	UpdatedUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
	if((UpdatedUnitState.GetTeam() == eTeam_XCom && ToolboxOptions.bRedFogXComActive) || (UpdatedUnitState.GetTeam() == eTeam_Alien && ToolboxOptions.bRedFogAliensActive))
	{
		`LOG("ActivateForXCom Listener: Setting active, registering events");
		SetRedFogActive(UpdatedUnitState);
		UpdateRedFogPenalties(EffectState, UpdatedUnitState, NewGameState);
	}
	else 
	{
		`LOG("ActivateForXCom Listener: Setting inactive, unregistering events");
		ClearRedFogActive(UpdatedUnitState);
		UpdateRedFogPenalties(EffectState, UpdatedUnitState, NewGameState);
	}
		
	if( NewGameState.GetNumGameStateObjects() > 0 )
		`GAMERULES.SubmitGameState(NewGameState);
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);


	return ELR_NoInterrupt;
}

//add a component to XComGameState_Effect to track cumulative number of attacks
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_LWToolboxOptions ToolboxOptions;
	local XComGameState_Unit TargetUnit;

	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();
	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit == none)
	{
		`REDSCREEN("X2Effect_RedFog : No target unit");
		return;
	}

	if ((TargetUnit.GetTeam() == eTeam_XCom && ToolboxOptions.bRedFogXComActive) || (TargetUnit.GetTeam() == eTeam_Alien && ToolboxOptions.bRedFogAliensActive))
	{
		SetRedFogActive(TargetUnit);
	}
	else
	{
		ClearRedFogActive(TargetUnit);
	}
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectState, XComGameState_Unit TargetUnit)
{
	local bool Relevant;

	Relevant = (ComputePctHPLost(TargetUnit) > 0.0f) && IsRedFogActive(TargetUnit);
	return Relevant;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	TargetUnit.ClearUnitValue('RedFogActive_LW');

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}

static function UpdateRedFogPenalties(XComGameState_Effect EffectState, XComGameState_Unit UnitState, XComGameState GameState)
{
	local float PctHPLost;
	local RedFogPenalty Penalty;
	local StatChange NewChange;
	local array<RedFogPenalty> RFPenalties;
	local XComGameState_LWToolboxOptions ToolboxOptions;
	local array<StatChange>	aStatChanges;
	
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();
	EffectState = XComGameState_Effect(GameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));

	UnitState.UnApplyEffectFromStats(EffectState, GameState);
	`LOG("UpdateRedFogPenalties : Entering",, 'LW_Toolbox');

	//computed lost HP fraction
	PctHPLost = ComputePctHPLost(UnitState);

	if (IsRedFogActive(UnitState) && PctHPLost > 0.0f)
	{
		//`LOG("UpdateRedFogPenalties : IsActive=true",, 'LW_Toolbox');

		//retrieve array for linear/active penalties
		if(ToolboxOptions.bRedFogLinearPenalties)
			RFPenalties = class'X2Effect_RedFog_LW'.default.LinearRedFogPenalties;
		else
			RFPenalties = class'X2Effect_RedFog_LW'.default.QuadraticRedFogPenalties;

		//`LOG("UpdateRedFogPenalties : PctHPLost=" $ PctHPLost $ ", NumPenaltyStats=" $ RFPenalties.Length,, 'LW_Toolbox');
		//apply penalties
		foreach RFPenalties(Penalty)
		{
			NewChange.StatType = Penalty.Stat;
			NewChange.ModOp = ToolboxOptions.GetRedFogPenaltyType(); //class'X2Effect_RedFog_LW'.default.RedFogPenaltyType;
			switch(NewChange.ModOp)
			{
			case MODOP_Multiplication : 
				NewChange.StatAmount = 1.0 - ComputeStatLoss(PctHPLost, Penalty, ToolboxOptions.bRedFogLinearPenalties);
				break;
			default: // MODOP_Addition
				NewChange.StatAmount = -ComputeStatLoss(PctHPLost, Penalty, ToolboxOptions.bRedFogLinearPenalties);
				break;
			}

			//`LOG("UpdateRedFogPenalties : Stat=" $ NewChange.StatType $ ", Amount=" $ NewChange.StatAmount,, 'LW_Toolbox');

			aStatChanges.AddItem(NewChange);
		}
		EffectState.StatChanges = aStatChanges;
		UnitState.ApplyEffectToStats(EffectState, GameState);
	}
}

static function float ComputeStatLoss(float PctHPLost, RedFogPenalty Penalty, bool bLinear)
{
	local float StatLoss;
	local float QuadraticTerm;

	QuadraticTerm = Penalty.MaxPenalty - Penalty.InitialRate;

	if(bLinear)
		StatLoss = int(Penalty.MaxPenalty * PctHPLost);
	else
		StatLoss = int((QuadraticTerm * PctHPLost * PctHPLost) + (Penalty.InitialRate * PctHPLost)); 

	`LOG("XCGS_Effect_RedFog: PctHPLost=" $ PctHPLost $ ", Stat=" $ Penalty.Stat $ ", Amount=" $ StatLoss,, 'LW_Toolbox');
	return StatLoss;
}

static function float ComputePctHPLost(XComGameState_Unit UnitState)
{
	local float CalcHP, MaxHP, ReturnPct;
	local XComGameState_LWToolboxOptions ToolboxOptions;
	
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();

	if(class'X2Effect_RedFog_LW'.default.TypesImmuneToRedFog.Find(UnitState.GetMyTemplateName()) != -1)
		return 0.0f;

	switch(ToolboxOptions.GetRedFogHealingType())
	{
	case eRFHealing_CurrentHP:  CalcHP = UnitState.GetCurrentStat(eStat_HP); break; 
	case eRFHealing_LowestHP:  CalcHP = UnitState.LowestHP; break; 
	case eRFHealing_AverageHP:  CalcHP = (UnitState.GetCurrentStat(eStat_HP) + UnitState.LowestHP)/2.0; break; 
	default:  CalcHP = UnitState.GetCurrentStat(eStat_HP); break; 
	}

	MaxHP = UnitState.HighestHP;
	ReturnPct = 0.0;

	if(class'X2Effect_RedFog_LW'.default.TypesHalfImmuneToRedFog.Find(UnitState.GetMyTemplateName()) != -1)
		ReturnPct = 0.5 * (1.0 - (CalcHP/MaxHP));
	else
		ReturnPct = 1.0 - (CalcHP/MaxHP);

	return FClamp(ReturnPct, 0.0, 1.0);
}

static protected function XComGameState_Unit GetTargetUnit(XComGameState_Effect EffectState, optional XComGameState NewGameState)
{
	local XComGameState_Unit  TargetUnit;

	if (NewGameState != none)
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (TargetUnit == none)
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (TargetUnit == none)
		`REDSCREEN("LW_TOOLBOX : X2Effect_RedFog has no valid effect state");

	return TargetUnit;
}

static function bool IsRedFogActive(XComGameState_Unit UnitState)
{
	local UnitValue Temp;
	return UnitState.GetUnitValue('RedFogActive_LW', Temp);
}

static protected function SetRedFogActive(XComGameState_Unit UnitState)
{
	UnitState.SetUnitFloatValue('RedFogActive_LW', 1.0f, eCleanup_BeginTactical);
}

static protected function ClearRedFogActive(XComGameState_Unit UnitState)
{
	UnitState.ClearUnitValue('RedFogActive_LW');
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="RedFog_LW";
	bRemoveWhenSourceDies=true;
}
