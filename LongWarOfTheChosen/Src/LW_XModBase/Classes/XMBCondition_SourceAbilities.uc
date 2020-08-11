//---------------------------------------------------------------------------------------
//  FILE:    XMBCondition_SourceAbilities.uc
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
//  None.
//---------------------------------------------------------------------------------------
class XMBCondition_SourceAbilities extends X2Condition;

struct AbilityReason
{
	var name AbilityName;
	var name Reason;
};

var array<AbilityReason> ExcludeAbilities;     //Units affected by any Ability will be rejected with the given reason
var array<AbilityReason> RequireAbilities;     //Condition will fail unless every Ability in this list is on the unit

function AddExcludeAbility(name AbilityName, name Reason)
{
	local AbilityReason Exclude;
	Exclude.AbilityName = AbilityName;
	Exclude.Reason = Reason;
	ExcludeAbilities.AddItem(Exclude);
}

function AddRequireAbility(name AbilityName, name Reason)
{
	local AbilityReason Require;
	Require.AbilityName = AbilityName;
	Require.Reason = Reason;
	RequireAbilities.AddItem(Require);
}


event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnitState;
	local AbilityReason Ability;

	SourceUnitState = XComGameState_Unit(kSource);
	if (SourceUnitState == none)
		return 'AA_NotAUnit';

	foreach ExcludeAbilities(Ability)
	{
		if (SourceUnitState.HasSoldierAbility(Ability.AbilityName))
			return Ability.Reason;
	}
	foreach RequireAbilities(Ability)
	{
		if (!SourceUnitState.HasSoldierAbility(Ability.AbilityName))
			return Ability.Reason;
	}

	return 'AA_Success';
}