//---------------------------------------------------------------------------------------
//  FILE:    XMBValue.uc
//  AUTHOR:  xylthixlm
//
//  This is a base class for classes that provide dynamic values to other parts of the
//  XMB library, particularly XMBEffect_ConditionalBonus.
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
class XMBValue extends Object;

function float GetValue(XComGameState_Effect EffectState, XComGameState_Unit UnitState, XComGameState_Unit TargetState, XComGameState_Ability AbilityState);
