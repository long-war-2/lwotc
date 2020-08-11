//---------------------------------------------------------------------------------------
//  FILE:    XMBCondition_HeightAdvantage.uc
//  AUTHOR:  xylthixlm
//
//  A condition that restricts the height of the target of an ability relative to the
//  height of the shooter.
//
//  USAGE
//
//  XMBAbility provides default instances of this class for common cases:
//
//  default.HeightAdvantageCondition		The target is higher than the shooter
//  default.HeightDisadvantageCondition		The target is lower than the shooter
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  DamnGoodGround
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
class XMBCondition_HeightAdvantage extends X2Condition;

var bool bRequireHeightAdvantage, bRequireHeightDisadvantage;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit TargetState, SourceState;

	TargetState = XComGameState_Unit(kTarget);
	if (TargetState == none)
		return 'AA_NotAUnit';

	SourceState = XComGameState_Unit(kSource);
	if (SourceState == none)
		return 'AA_NotAUnit';

	if (bRequireHeightDisadvantage && !SourceState.HasHeightAdvantageOver(TargetState, true))
		return 'AA_InvalidTargetHeight';  // NOTE: Nonstandard AA code

	if (bRequireHeightAdvantage && !TargetState.HasHeightAdvantageOver(SourceState, false))
		return 'AA_InvalidTargetHeight';  // NOTE: Nonstandard AA code

	return 'AA_Success';
}