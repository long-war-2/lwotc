//---------------------------------------------------------------------------------------
//  FILE:   X2Condition_ArcthrowerAbilities_LW.uc
//  AUTHOR:  BStar (modified slightly by Peter Ledbrook)
//  PURPOSE: Condition that allows modifying arc thrower abilities only
//---------------------------------------------------------------------------------------
class X2Condition_ArcthrowerAbilities_LW extends X2Condition config(LW_SoldierSkills);

var config array<name> ARCTHROWER_ABILITIES;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local name						AbilityName;
	local XComGameState_Item		SourceWeapon;
	local array<name>				ValidArcthrowerAbilities;

	if (kAbility == none)
		return 'AA_InvalidAbilityName';

	ValidArcthrowerAbilities = default.ARCTHROWER_ABILITIES;

	SourceWeapon = kAbility.GetSourceWeapon();
	AbilityName = kAbility.GetMyTemplateName();

	if (SourceWeapon == none)
		return 'AA_InvalidAbilityName';

	if (ValidArcthrowerAbilities.Find(AbilityName) != INDEX_NONE)
		return 'AA_Success';

	return 'AA_InvalidAbilityName';
}
