//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_GrantReserveActionPoint.uc
//  AUTHOR:  xylthixlm
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  CoverMe
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  None.
//---------------------------------------------------------------------------------------
class XMBEffect_GrantReserveActionPoint extends X2Effect;

var name ImmediateActionPoint;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none && ImmediateActionPoint != '')
	{
		TargetUnit.ReserveActionPoints.AddItem(ImmediateActionPoint);
	}
}