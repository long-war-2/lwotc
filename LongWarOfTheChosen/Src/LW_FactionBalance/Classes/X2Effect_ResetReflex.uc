//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ResetReflex
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Clears the "total" counter for Skirmisher's Reflex ability so
//           that it can trigger more than once per mission.
//--------------------------------------------------------------------------------------- 

class X2Effect_ResetReflex extends X2Effect;

simulated protected function OnEffectAdded(
	const out EffectAppliedData ApplyEffectParameters,
	XComGameState_BaseObject kNewTargetState,
	XComGameState NewGameState,
	XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		UnitState.ClearUnitValue(class'X2Effect_SkirmisherReflex'.default.TotalEarnedValue);
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
