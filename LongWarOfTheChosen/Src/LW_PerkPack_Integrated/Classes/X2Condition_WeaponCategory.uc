//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_WeaponCategory.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Condition that checks whether a unit has a weapon equipped that matches
//           any of a given set of weapon categories. This is primarily so that
//           abilities that require a specific type of weapon (for example pistol
//           abilities) can be disabled if no weapon of that type is available.
//           (Shamelessly copied from an example Iridar posted in Discord so I
//            don't have to think)
//--------------------------------------------------------------------------------------- 
class X2Condition_WeaponCategory extends X2Condition;

var array<name> WeaponCats;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget) 
{
	local XComGameState_Item SourceWeapon;

	SourceWeapon = kAbility.GetSourceWeapon();

	if (SourceWeapon != none && WeaponCats.Find(SourceWeapon.GetWeaponCategory()) != INDEX_NONE)
	{
		return 'AA_Success'; 
	}

	return 'AA_WeaponIncompatible';
}

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
	local array<XComGameState_Item> InventoryItems;
	local XComGameState_Item InventoryItem;

	InventoryItems = SourceUnit.GetAllInventoryItems();

	// Check whether any of the unit's inventory items matches any of the
	// supported weapon categories.
	foreach InventoryItems(InventoryItem)
	{
		if (WeaponCats.Find(InventoryItem.GetWeaponCategory()) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}
