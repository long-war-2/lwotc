//---------------------------------------------------------------------------------------
//  FILE:    XMBCondition_Concealed.uc
//  AUTHOR:  xylthixlm
//
//  USAGE
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  Stalker
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
class XMBCondition_Concealed extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	if (!TargetUnit.IsConcealed())
		return 'AA_UnitAlreadySpotted';

	return 'AA_Success';
}