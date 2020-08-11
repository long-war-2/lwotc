//---------------------------------------------------------------------------------------
//  FILE:    XMBCondition_AbilityName.uc
//  AUTHOR:  xylthixlm
//
//  A condition that either only matches certain named abilities, or excludes certain
//  named abilities. This is intended for use with persistent effects that check
//  conditions, such as XMBEffect_ConditionalBonus.
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  CloseAndPersonal
//  Fastball
//  HitAndRun
//  PowerShot
//  Saboteur
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
class XMBCondition_AbilityName extends X2Condition;

var array<name> IncludeAbilityNames;
var array<name> ExcludeAbilityNames;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local name DataName;

	DataName = kAbility.GetMyTemplate().DataName;

	if (IncludeAbilityNames.Length > 0 && IncludeAbilityNames.Find(DataName) == INDEX_NONE)
		return 'AA_InvalidAbilityName';  // NOTE: Nonstandard AA code
	if (ExcludeAbilityNames.Length > 0 && ExcludeAbilityNames.Find(DataName) != INDEX_NONE)
		return 'AA_InvalidAbilityName';  // NOTE: Nonstandard AA code

	return 'AA_Success';
}