//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ApplyHarborWaveDamage.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Fires an event when weapon damage is applied, which is used
//           to link Harbor Wave to Blood Thirst.
//--------------------------------------------------------------------------------------- 

class X2Effect_ApplyHarborWaveDamage extends X2Effect_ApplyWeaponDamage config(GameCore);

//Grobo: This Feels like a heresy but I want THIS specific effect to trigger RIGHT NOW
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit;
    
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	`XEVENTMGR.TriggerEvent('HarborWaveDealtDamage', SourceUnit, SourceUnit, NewGameState);
}
