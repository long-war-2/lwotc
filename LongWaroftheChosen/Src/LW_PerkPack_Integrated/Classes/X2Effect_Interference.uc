//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Interference
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Removes overwatch action points from target
//--------------------------------------------------------------------------------------- 

class X2Effect_Interference extends X2Effect;

protected simulated function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	
	TargetUnit = XComGameState_Unit(kNewTargetState);
	TargetUnit.ReserveActionPoints.Length = 0;
}