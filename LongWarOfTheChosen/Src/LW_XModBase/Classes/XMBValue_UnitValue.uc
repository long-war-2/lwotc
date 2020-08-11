//---------------------------------------------------------------------------------------
//  FILE:    XMBValue_Visibility.uc
//  AUTHOR:  xylthixlm
//
//  An XMBValue that returns the value of a unit value. Use X2Effect_SetUnitValue and
//  X2Effect_IncrementUnitValue to manipulate unit values.
//
//  USAGE
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//	ZeroIn
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
class XMBValue_UnitValue extends XMBValue;

var name UnitValueName;

function float GetValue(XComGameState_Effect EffectState, XComGameState_Unit UnitState, XComGameState_Unit TargetState, XComGameState_Ability AbilityState)
{
	local UnitValue Value;

	if (UnitState.GetUnitValue(UnitValueName, Value))
		return Value.fValue;
	else
		return 0;
}