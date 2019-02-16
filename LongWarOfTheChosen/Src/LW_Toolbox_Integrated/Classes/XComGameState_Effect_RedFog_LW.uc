//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_RedFog_LW.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is a component extension for Effect GameStates, containing 
//				additional data used for RedFog.
//---------------------------------------------------------------------------------------
class XComGameState_Effect_RedFog_LW extends XComGameState_BaseObject
	config(LW_Toolbox)
	dependson(X2Effect_RedFog_LW);

//

var bool bIsActive;

function XComGameState_Effect_RedFog_LW InitComponent()
{
	return self;
}

function XComGameState_Effect GetOwningEffect(optional XComGameState GameState)
{
	local XComGameState_Effect EffectState;

	if (GameState != none)
		EffectState = XComGameState_Effect(GameState.GetGameStateForObjectID(OwningObjectId));

	if (EffectState != none)
		return EffectState;
	else
		return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

function OnEndTacticalPlay(XComGameState NewGameState)
{
	local X2EventManager EventManager;
	local Object ThisObj;

	super.OnEndTacticalPlay(NewGameState);

	EventManager = `XEVENTMGR;
	ThisObj = self;

	EventManager.UnRegisterFromEvent(ThisObj, 'UpdateRedFogActivation');
}

function RegisterEvent(optional XComGameState_Unit TargetUnit)
{
	local Object ListenerObj;

	if (TargetUnit == none)
		TargetUnit == GetTargetUnit();

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = self;
	if (ListenerObj == none)
	{
		`Redscreen("RedFog_LW: Failed to find RedFog Component when registering listener");
		return;
	}

	// allows activation/deactivation of effect
	`XEVENTMGR.RegisterForEvent(ListenerObj, 'UpdateRedFogActivation', UpdateActivation, ELD_OnStateSubmitted,,TargetUnit); 
}

function EventListenerReturn UpdateActivation(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState, UpdatedUnitState;
	local XComGameState_Effect_RedFog_LW UpdatedEffectState;
	local XComGameState NewGameState;
	local XComGameState_LWToolboxOptions ToolBoxOptions;

	`LOG("Red Fog UpdateActivation Listener: Started",, 'LW_Toolbox');

	ToolBoxOptions = XComGameState_LWToolboxOptions(EventData);
	if(ToolboxOptions == none)
		`REDSCREEN("RedFog UpdateActivation: No Toolbox Option data passed");
	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
		UnitState = GetTargetUnit();
	if (UnitState == none)
	{
		`REDSCREEN("RedFog UpdateActivation: No Valid Target");
		return ELR_NoInterrupt;
	}

	`LOG("ActivateForXCom Listener: Testing Activation");
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update RedFog Activation");
	UpdatedEffectState = XComGameState_Effect_RedFog_LW(NewGameState.CreateStateObject(Class, ObjectID));
	NewGameState.AddStateObject(UpdatedEffectState);
	UpdatedUnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
	NewGameState.AddStateObject(UpdatedUnitState);
	if((UpdatedUnitState.GetTeam() == eTeam_XCom && ToolboxOptions.bRedFogXComActive) || (UpdatedUnitState.GetTeam() == eTeam_Alien && ToolboxOptions.bRedFogAliensActive))
	{
		`LOG("ActivateForXCom Listener: Setting active, registering events");
		UpdatedEffectState.bIsActive = true;
		UpdatedEffectState.UpdateRedFogPenalties(UpdatedUnitState, NewGameState);
	}
	else 
	{
		`LOG("ActivateForXCom Listener: Setting inactive, unregistering events");
		UpdatedEffectState.bIsActive = false;
		UpdatedEffectState.UpdateRedFogPenalties(UpdatedUnitState, NewGameState);
	}
	SubmitNewGameState(NewGameState);

	return ELR_NoInterrupt;
}

function XComGameState_Unit GetTargetUnit(optional XComGameState NewGameState)
{
	local XComGameState_Unit  TargetUnit;
	local XComGameState_Effect OwningEffect;

	OwningEffect = GetOwningEffect(NewGameState);

	if (NewGameState != none)
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(OwningEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (TargetUnit == none)
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(OwningEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (TargetUnit == none)
		`REDSCREEN("LW_TOOLBOX : X2Effect_RedFog has no valid owning effect state");

	return TargetUnit;
}

private function SubmitNewGameState(out XComGameState NewGameState)
{
	local X2TacticalGameRuleset TacticalRules;
	local XComGameStateHistory History;

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		TacticalRules = `TACTICALRULES;
		TacticalRules.SubmitGameState(NewGameState);

		//  effects may have changed action availability - if a unit died, took damage, etc.
	}
	else
	{
		History = `XCOMHISTORY;
		History.CleanupPendingGameState(NewGameState);
	}
}

simulated function UpdateRedFogPenalties(XComGameState_Unit UnitState, XComGameState GameState)
{
	local float PctHPLost;
	local RedFogPenalty Penalty;
	local StatChange NewChange;
	local XComGameState_Effect OwningEffect;
	local array<RedFogPenalty> RFPenalties;
	local XComGameState_LWToolboxOptions ToolboxOptions;
	local array<StatChange>	aStatChanges;
	
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();
	OwningEffect = GetOwningEffect(GameState);
	OwningEffect = XComGameState_Effect(GameState.CreateStateObject(OwningEffect.Class, OwningEffect.ObjectID));
	GameState.AddStateObject(OwningEffect);

	UnitState.UnApplyEffectFromStats(OwningEffect, GameState);
	`LOG("UpdateRedFogPenalties : Entering",, 'LW_Toolbox');

	//computed lost HP fraction
	PctHPLost = ComputePctHPLost(UnitState);

	if(bIsActive && PctHPLost > 0.0f)
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
		OwningEffect.StatChanges = aStatChanges;
		UnitState.ApplyEffectToStats(OwningEffect, GameState);
	}
}

simulated function float ComputeStatLoss(float PctHPLost, RedFogPenalty Penalty, bool bLinear)
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

simulated function float ComputePctHPLost(XComGameState_Unit UnitState)
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