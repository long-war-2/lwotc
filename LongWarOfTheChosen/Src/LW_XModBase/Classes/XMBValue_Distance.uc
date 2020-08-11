//---------------------------------------------------------------------------------------
//  FILE:    XMBValue_Distance.uc
//  AUTHOR:  xylthixlm
//
//  USAGE
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  XMBValue.uc
//---------------------------------------------------------------------------------------
class XMBValue_Distance extends XMBValue;

function float GetValue(XComGameState_Effect EffectState, XComGameState_Unit UnitState, XComGameState_Unit TargetState, XComGameState_Ability AbilityState)
{
	return UnitState.TileDistanceBetween(TargetState);
}