class X2StrategyElement_CosmeticRocketSlot extends CHItemSlotSet;

//Adds hidden inventory slots to all soldiers which is used to store cosmetic items that represent rockets on the soldier's body

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	//	eInvSlot_ExtraRocket1 is used by Disposable Rocket Launchers mod
	Templates.AddItem(CreateSlotTemplate(eInvSlot_ExtraRocket2, 'CosmeticRocketSlot2'));
	Templates.AddItem(CreateSlotTemplate(eInvSlot_ExtraRocket3, 'CosmeticRocketSlot3'));
	Templates.AddItem(CreateSlotTemplate(eInvSlot_ExtraRocket4, 'CosmeticRocketSlot4'));
	return Templates;
}

static function X2DataTemplate CreateSlotTemplate(EInventorySlot InventorySlot, name TemplateName)
{
	local CHItemSlot Template;

	`CREATE_X2TEMPLATE(class'CHItemSlot', Template, TemplateName);

	Template.InvSlot = InventorySlot;
	Template.SlotCatMask = Template.SLOT_WEAPON | Template.SLOT_ITEM;

	Template.IsUserEquipSlot = false;
	Template.IsEquippedSlot = false;
	Template.SlotCatMask = 0;
	Template.BypassesUniqueRule = true;
	Template.IsMultiItemSlot = false;

	Template.IsSmallSlot = false;
	Template.NeedsPresEquip = true;
	Template.ShowOnCinematicPawns = true;

	Template.UnitShowSlotFn = ShowSlot;
	Template.CanAddItemToSlotFn = CanAddItemToSlot;
	Template.UnitHasSlotFn = HasSlot;
	Template.GetPriorityFn = SlotGetPriority;
	Template.ShowItemInLockerListFn = ShowItemInLockerList;
	Template.ValidateLoadoutFn = ValidateLoadout;
	Template.GetSlotUnequipBehaviorFn = SlotGetUnequipBehavior;

	return Template;
}

static function bool CanAddItemToSlot(CHItemSlot Slot, XComGameState_Unit Unit, X2ItemTemplate Template, optional XComGameState CheckGameState, optional int Quantity = 1, optional XComGameState_Item ItemState)
{
    return true;
}

static function bool HasSlot(CHItemSlot Slot, XComGameState_Unit UnitState, out string LockedReason, optional XComGameState CheckGameState)
{
	return UnitState.IsSoldier();
}

static function int SlotGetPriority(CHItemSlot Slot, XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	return 53;	//	arbitrary value
}

static function bool ShowItemInLockerList(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_Item ItemState, X2ItemTemplate ItemTemplate, XComGameState CheckGameState)
{
	return true;
}

static function bool ShowSlot(CHItemSlot Slot, XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	return false;
}

static function ValidateLoadout(CHItemSlot Slot, XComGameState_Unit Unit, XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
	local XComGameState_Item EquippedItem;
	local string strDummy;
	local bool HasSlot;
	
	EquippedItem = Unit.GetItemInSlot(Slot.InvSlot, NewGameState);
	HasSlot = Slot.UnitHasSlot(Unit, strDummy, NewGameState);

	//	if the soldier has an item in the templateed slot AND
	//	(he's not supposed to have the slot in the first place OR if the soldier has a slot but on DRL in utility / secondary / heavy slots
	//	then unequip the item from the templated slot and destroy it
	if(EquippedItem != none && !HasSlot)
	{
		EquippedItem = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', EquippedItem.ObjectID));
		Unit.RemoveItemFromInventory(EquippedItem, NewGameState);
		NewGameState.PurgeGameStateForObjectID(EquippedItem.ObjectID);
		EquippedItem = none;
	}
}

function ECHSlotUnequipBehavior SlotGetUnequipBehavior(CHItemSlot Slot, ECHSlotUnequipBehavior DefaultBehavior, XComGameState_Unit Unit, XComGameState_Item ItemState, optional XComGameState CheckGameState)
{
	return eCHSUB_AllowEmpty;
}