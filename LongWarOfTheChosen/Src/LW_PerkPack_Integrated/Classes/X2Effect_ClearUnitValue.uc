//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_ClearUnitValue
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Clears a configured unit value when applied.
//---------------------------------------------------------------------------------------
class X2Effect_ClearUnitValue extends X2Effect;

var name UnitValueName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;

	TargetUnitState = XComGameState_Unit(kNewTargetState);
	TargetUnitState.ClearUnitValue(UnitValueName);
}
