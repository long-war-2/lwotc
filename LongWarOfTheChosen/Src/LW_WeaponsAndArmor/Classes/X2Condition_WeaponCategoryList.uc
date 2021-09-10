//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_WeaponCategoryList.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Condition that checks whether a source weapon is of a certain category.
//--------------------------------------------------------------------------------------- 
class X2Condition_WeaponCategoryList extends X2Condition;

var array<name> IncludeWeaponCategories;
var array<name> ExcludeWeaponCategories;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;
	local name WeaponCat;

	SourceWeapon = kAbility.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	WeaponCat = WeaponTemplate.WeaponCat;


	if (IncludeWeaponCategories.Length > 0)
	{
		if (IncludeWeaponCategories.Find(WeaponCat) == INDEX_NONE)
			return 'AA_WeaponIncompatible';
	}
	if (ExcludeWeaponCategories.Length > 0)
	{
		if (ExcludeWeaponCategories.Find(WeaponCat) != INDEX_NONE)
			return 'AA_WeaponIncompatible';
	}

	return 'AA_Success';
}

defaultproperties
{
}