

//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_XMBPerkAbilitySet
//  AUTHOR:  Grobobobo
//  PURPOSE: Checks whether the source weapon can use ammo
//--------------------------------------------------------------------------------------- 
class X2Condition_WeaponCanUseAmmo extends X2Condition;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget) 
{
	local XComGameState_Item SourceWeapon;

	SourceWeapon = kAbility.GetSourceWeapon();

	if (SourceWeapon != none && SourceWeapon.HasLoadedAmmo())
	{
		return 'AA_Success'; 
	}

	return 'AA_WeaponIncompatible';
}

