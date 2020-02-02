//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DisablingShotStunned
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: This is a special stun effect that grants bonus stun duration if
//           an ability caused a critical hit.
//--------------------------------------------------------------------------------------- 

class X2Effect_DisablingShotStunned extends X2Effect_Stunned;

var int BonusStunActionsOnCrit;

simulated protected function OnEffectAdded(
	const out EffectAppliedData ApplyEffectParameters,
	XComGameState_BaseObject kNewTargetState,
	XComGameState NewGameState,
	XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local UnitValue UnitValue;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none && UnitState.GetUnitValue(class'X2Effect_CritRemoval'.default.CritRemovedValueName, UnitValue))
	{
		UnitState.ClearUnitValue(class'X2Effect_CritRemoval'.default.CritRemovedValueName);
		UnitState.StunnedActionPoints += BonusStunActionsOnCrit;
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

defaultProperties
{
	GameStateEffectClass = class'XComGameState_Effect_AbilityTrigger';
	bInfiniteDuration = true;
}
