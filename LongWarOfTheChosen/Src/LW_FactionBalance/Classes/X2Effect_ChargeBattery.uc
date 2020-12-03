//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ChargeBattery
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Extends Shadow duration by 1 turn.
//---------------------------------------------------------------------------------------

class X2Effect_ChargeBattery extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect ShadowEffectState;
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kNewTargetState);
	ShadowEffectState = UnitState.GetUnitAffectedByEffectState('TemporaryShadowConcealment');
	if (ShadowEffectState != none)
	{
		ShadowEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(class'XComGameState_Effect', ShadowEffectState.ObjectID));
		ShadowEffectState.iTurnsRemaining++;
	}
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
