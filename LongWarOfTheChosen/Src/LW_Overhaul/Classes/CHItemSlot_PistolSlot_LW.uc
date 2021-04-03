//---------------------------------------------------------------------------------------
//  FILE:    CHItemSlot_PistolSlot_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Adds a pistol slot to most soldier classes. Mostly copied from
//           Veehementia's Dedicated Pistol Slot mod, with permission.
//---------------------------------------------------------------------------------------

class CHItemSlot_PistolSlot_LW extends CHItemSlotSet config(LW_Overhaul);

var config array<name> EXCLUDE_FROM_PISTOL_SLOT_CLASSES;
var config array<name> LWOTC_PISTOL_SLOT_WEAPON_CAT;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreatePistolSlotTemplate());

	return Templates;
}

static function X2DataTemplate CreatePistolSlotTemplate()
{
	local CHItemSlot Template;

	`CREATE_X2TEMPLATE(class'CHItemSlot', Template, 'PistolSlot');

	Template.InvSlot = eInvSlot_Pistol;
	Template.SlotCatMask = Template.SLOT_WEAPON | Template.SLOT_ITEM;
	// Unused for now
	Template.IsUserEquipSlot = true;
	// Uses unique rule
	Template.IsEquippedSlot = false;
	// Does not bypass unique rule
	Template.BypassesUniqueRule = false;
	Template.IsMultiItemSlot = false;
	Template.IsSmallSlot = false;
	Template.NeedsPresEquip = true;
	Template.ShowOnCinematicPawns = true;

	Template.CanAddItemToSlotFn = CanAddItemToPistolSlot;   // Overridden by CanAddItemToInventory_CH_Improved apparently
	Template.UnitHasSlotFn = HasPistolSlot;
	Template.GetPriorityFn = PistolGetPriority;
	Template.ShowItemInLockerListFn = ShowPistolItemInLockerList;
	Template.GetSlotUnequipBehaviorFn = PistolGetUnequipBehavior;

	return Template;
}

static function bool CanAddItemToPistolSlot(
    CHItemSlot Slot,
    XComGameState_Unit UnitState,
    X2ItemTemplate Template,
    optional XComGameState CheckGameState,
    optional int Quantity = 1,
    optional XComGameState_Item ItemState)
{    
    local X2WeaponTemplate WeaponTemplate;
//in theory: if not found in the LWOTC_PISTOL_SLOT_WEAPON_CAT, it´s not added to the slot.
//Not sure if I put this correctly. Also added small failsafe to prevent multiple pistols equipped as per issue 1006 (again, I have no idea)
    WeaponTemplate = X2WeaponTemplate(Template);
       if (WeaponTemplate != none && UnitState.GetItemInSlot(Slot.InvSlot, CheckGameState) == none)
    {
         return default.LWOTC_PISTOL_SLOT_WEAPON_CAT.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
    }
    return false;
}

static function bool HasPistolSlot(
    CHItemSlot Slot,
    XComGameState_Unit UnitState,
    out string LockedReason,
    optional XComGameState CheckGameState)
{
    return default.EXCLUDE_FROM_PISTOL_SLOT_CLASSES.Find(UnitState.GetSoldierClassTemplateName()) == INDEX_NONE;
}

static function int PistolGetPriority(CHItemSlot Slot, XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	return 45; // Ammo Pocket is 110 
}

static function bool ShowPistolItemInLockerList(
    CHItemSlot Slot,
    XComGameState_Unit Unit,
    XComGameState_Item ItemState,
    X2ItemTemplate ItemTemplate,
    XComGameState CheckGameState)
{
    local X2WeaponTemplate WeaponTemplate;
//UI check to show in armory. 
    WeaponTemplate = X2WeaponTemplate(ItemTemplate);
    if (WeaponTemplate != none)
    {
         return default.LWOTC_PISTOL_SLOT_WEAPON_CAT.Find(WeaponTemplate.WeaponCat) != INDEX_NONE;
    }
    return false;
}

function ECHSlotUnequipBehavior PistolGetUnequipBehavior(CHItemSlot Slot, ECHSlotUnequipBehavior DefaultBehavior, XComGameState_Unit Unit, XComGameState_Item ItemState, optional XComGameState CheckGameState)
{
	return eCHSUB_AllowEmpty;
}
