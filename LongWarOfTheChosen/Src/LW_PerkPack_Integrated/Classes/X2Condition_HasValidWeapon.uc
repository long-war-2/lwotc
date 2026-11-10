class X2Condition_HasValidWeapon extends X2Condition;

var array<name>     AllowedWeaponCategories;
var array<name>     AllowedWeaponTemplates;
var bool            bCheckCanEverBeValid;
var bool            bCannotEverBeValid;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
    local XComGameState_Item    ItemState;
    local X2WeaponTemplate      WeaponTemplate;

    if (AllowedWeaponCategories.Length == 0 && AllowedWeaponTemplates.Length == 0)
        return 'AA_Success';

    ItemState = kAbility.GetSourceWeapon();
    if (ItemState == none)
        return 'AA_WeaponIncompatible';

    WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
    if (WeaponTemplate == none)
        return 'AA_WeaponIncompatible';

    if (AllowedWeaponCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE || AllowedWeaponTemplates.Find(WeaponTemplate.DataName) != INDEX_NONE)
    {
        return 'AA_Success';
    }
    
    return 'AA_WeaponIncompatible';
}

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
    local array<XComGameState_Item> CurrentInventory;
    local XComGameState_Item        InventoryItem;
    local X2WeaponTemplate          WeaponTemplate;

    if (!bCheckCanEverBeValid)
        return true;

    if (bCannotEverBeValid)
        return false;

    if (AllowedWeaponCategories.Length == 0 && AllowedWeaponTemplates.Length == 0)
        return true;

    CurrentInventory = SourceUnit.GetAllInventoryItems(, true);
    foreach CurrentInventory(InventoryItem)
    {
        WeaponTemplate = X2WeaponTemplate(InventoryItem.GetMyTemplate());
        if (WeaponTemplate != none)
        {
            if (AllowedWeaponCategories.Find(WeaponTemplate.WeaponCat) != INDEX_NONE || AllowedWeaponTemplates.Find(WeaponTemplate.DataName) != INDEX_NONE)
            {
                return true;
            }
        }
    }

    return false;
}