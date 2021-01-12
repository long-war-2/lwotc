//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_KismetVariableModifier
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Stores a numeric modifier for a Kismet variable. Initially designed
//           to be used by `X2SitRepEffect_ModifyTacticalStartState` as an alternative
//           to `X2SitRepEffect_ModifyKismetVariable` because that effect can't stack
//           modifiers for a single variable: one of the effects' values wins.
//--------------------------------------------------------------------------------------- 

class XComGameState_KismetVariableModifier extends XComGameState_BaseObject;

// The Kismet variable to modify
var name VarName;

// The numerical value to add to the variable (may be negative)
var float Delta;
