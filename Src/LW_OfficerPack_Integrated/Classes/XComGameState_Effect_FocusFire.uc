//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_FocusFire.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is a component extension for Effect GameStates, containing 
//				additional data used for FocusFire.
//---------------------------------------------------------------------------------------
class XComGameState_Effect_FocusFire extends XComGameState_BaseObject config(LW_OfficerPack);

var int CumulativeAttacks;

function XComGameState_Effect_FocusFire InitComponent()
{
	CumulativeAttacks = 1;
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

simulated function EventListenerReturn FocusFireCheck(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Effect EffectState;
	local XComGameState_Effect_FocusFire CurrentFFEffect, UpdatedFFEffect;
	local XComGameState_Unit AttackingUnit, AbilityTargetUnit, FocussedUnit;
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Item SourceWeapon;
	//local bool bValidTarget;

	AbilityState = XComGameState_Ability (EventData);
	if (AbilityState == none)
	{
		`RedScreen("FocusFireCheck: no ability");
		return ELR_NoInterrupt;
	}
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
	{
		`RedScreen("FocusFireCheck: no context");
		return ELR_NoInterrupt;
	}

	//  non-pre emptive, so don't process during the interrupt step
	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if ((SourceWeapon == none) || (class'X2Effect_FocusFire'.default.VALIDWEAPONCATEGORIES.Find(SourceWeapon.GetWeaponCategory()) == -1))
	{
		//`RedScreen("FocusFireCheck: no or invalid weapon");
		return ELR_NoInterrupt;
	}

	EffectState = GetOwningEffect();
	if (EffectState == none)
	{
		`Redscreen("GameState_Effect_FocusFire: Unable to find owning GameState_Effect\n" $ GetScriptTrace());
		return ELR_NoInterrupt;
	}
	if (EffectState.bReadOnly) // this indicates that this is a stale effect from a previous battle
		return ELR_NoInterrupt;

	History = `XCOMHISTORY;
	AbilityTargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (AbilityTargetUnit == none)
		AbilityTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	AttackingUnit = XComGameState_Unit(EventSource);
	FocussedUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (FocussedUnit == none)
		FocussedUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (AttackingUnit == none)
	{
		`RedScreen("FocusFireCheck: no attacking unit");
		return ELR_NoInterrupt;
	}
	if (AbilityTargetUnit == none)
	{
		`RedScreen("FocusFireCheck: no target unit");
		return ELR_NoInterrupt;
	}
	if (FocussedUnit == none) 
	{
		//`RedScreen("FocusFireCheck: no focussed unit");
		return ELR_NoInterrupt;
	}
	if (FocussedUnit != AbilityTargetUnit)
	{
		//`RedScreen("FocusFireCheck: focussed unit != target unit");
		return ELR_NoInterrupt;
	}

	CurrentFFEffect = XComGameState_Effect_FocusFire(History.GetGameStateForObjectID(ObjectID));
	//`Log("FocusFireCheck: Previous CumulativeAttacks=" $ CurrentFFEffect.CumulativeAttacks);
	
	//`Log("FocusFire: 'AbilityActivated' event triggered, gates passed");

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	UpdatedFFEffect = XComGameState_Effect_FocusFire(NewGameState.CreateStateObject(class'XComGameState_Effect_FocusFire', ObjectID));
	UpdatedFFEffect.CumulativeAttacks = CurrentFFEffect.CumulativeAttacks+1;
	NewGameState.AddStateObject(UpdatedFFEffect);
	`TACTICALRULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}