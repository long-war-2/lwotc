//---------------------------------------------------------------------------------------
//  FILE:    XMBEffectInterface.uc
//  AUTHOR:  xylthixlm
//
//  This file contains internal implementation of XModBase. You don't need to, and
//  shouldn't, use it directly.
//
//  DEPENDENCIES
//
//  This doesn't depend on anything, but the provided functions will not function
//  without the classes in XModBase/Classes/ installed.
//---------------------------------------------------------------------------------------
interface XMBOverrideInterface;

// Returns the base class replaced by this override, e.g. class'X2AbilityToHitCalc_StandardAim'.
function class GetOverrideBaseClass();

// Gets the version number of this override. Newer overrides will replace older ones.
function GetOverrideVersion(out int Major, out int Minor, out int Patch);

// Provided for future extensibility.
function bool GetExtValue(LWTuple Data);
function bool SetExtValue(LWTuple Data);
