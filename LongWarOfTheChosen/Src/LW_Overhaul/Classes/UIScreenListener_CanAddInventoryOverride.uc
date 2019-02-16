//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_CanAddInventoryOverride.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Uses new XComGame TriggerEvent to override logic to add items to inventory
//---------------------------------------------------------------------------------------

// DEPRECATED

class UIScreenListener_CanAddInventoryOverride extends UIScreenListener config(LW_Overhaul) deprecated;

var bool bCreated;
var int OverrideNumUtilitySlots;

// This event is triggered after a screen is initialized
//event OnInit(UIScreen Screen)
//{
	//if(!bCreated)
	//{
		//InitListeners();
		//bCreated = true;
	//}
//}

function InitListeners()
{
	local X2EventManager EventMgr;
	local Object ThisObj;

	ThisObj = self;
	EventMgr = `XEVENTMGR;
	EventMgr.RegisterForEvent(ThisObj, 'OnCanAddItemToInventory', CheckOverrideAddItemToInventory,,,,true);
	EventMgr.RegisterForEvent(ThisObj, 'GetNumUtilitySlotsOverride', GetNumUtilitySlotsOverride,,,,true);
	EventMgr.RegisterForEvent(ThisObj, 'OnUpdateSquadSelect_ListItem', UpdateSquadSelectUtilitySlots,,,,true);
}

function EventListenerReturn UpdateSquadSelectUtilitySlots(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	//reference to the list item
	local UISquadSelect_ListItem ListItem;

	//variables from list item Update
	//local bool bCanPromote;
	//local string ClassStr;
	local int i, NumUtilitySlots, UtilityItemIndex;
	local float UtilityItemWidth, UtilityItemHeight;
	local UISquadSelect_UtilityItem UtilityItem;
	local array<XComGameState_Item> EquippedItems;
	local XComGameState_Unit Unit;
	//local XComGameState_Item PrimaryWeapon, HeavyWeapon;
	//local X2WeaponTemplate PrimaryWeaponTemplate, HeavyWeaponTemplate;
	//local X2AbilityTemplate HeavyWeaponAbilityTemplate;
	//local X2AbilityTemplateManager AbilityTemplateManager;

	ListItem = UISquadSelect_ListItem(EventSource);

	if(ListItem == none)
		return ELR_NoInterrupt;

	if(ListItem.bDisabled)
		return ELR_NoInterrupt;

	// -------------------------------------------------------------------------------------------------------------

	// empty slot
	if(ListItem.GetUnitRef().ObjectID <= 0)
		return ELR_NoInterrupt;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ListItem.GetUnitRef().ObjectID));

	NumUtilitySlots = OverrideNumUtilitySlots;

	if(Unit.HasGrenadePocket()) NumUtilitySlots++;
	if(Unit.HasAmmoPocket()) NumUtilitySlots++;
		
	UtilityItemWidth = (ListItem.UtilitySlots.GetTotalWidth() - (ListItem.UtilitySlots.ItemPadding * (NumUtilitySlots - 1))) / NumUtilitySlots;
	UtilityItemHeight = ListItem.UtilitySlots.Height;

	//if(ListItem.UtilitySlots.ItemCount != NumUtilitySlots)
		ListItem.UtilitySlots.ClearItems();

	for(i = 0; i < NumUtilitySlots; ++i)
	{
		if(i >= ListItem.UtilitySlots.ItemCount)
		{
			UtilityItem = UISquadSelect_UtilityItem(ListItem.UtilitySlots.CreateItem(class'UISquadSelect_UtilityItem_LW').InitPanel());
			UtilityItem.SetSize(UtilityItemWidth, UtilityItemHeight);
			ListItem.UtilitySlots.OnItemSizeChanged(UtilityItem);
		}
	}

	UtilityItemIndex = 0;

	EquippedItems = class'UIUtilities_Strategy'.static.GetEquippedItemsInSlot(Unit, eInvSlot_Utility);

	UtilityItem = UISquadSelect_UtilityItem(ListItem.UtilitySlots.GetItem(UtilityItemIndex++));
	UtilityItem.SetAvailable(EquippedItems.Length > 0 ? EquippedItems[0] : none, eInvSlot_Utility, 0, NumUtilitySlots);

	if(class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M5_EquipMedikit') == eObjectiveState_InProgress)
	{
		// spawn the attention icon externally so it draws on top of the button and image 
		ListItem.Spawn(class'UIPanel', UtilityItem).InitPanel('attentionIconMC', class'UIUtilities_Controls'.const.MC_AttentionIcon)
		.SetPosition(2, 4)
		.SetSize(70, 70); //the animated rings count as part of the size. 
	} else if(ListItem.GetChildByName('attentionIconMC', false) != none) {
		ListItem.GetChildByName('attentionIconMC').Remove();
	}

	UtilityItem = UISquadSelect_UtilityItem(ListItem.UtilitySlots.GetItem(UtilityItemIndex++));
	UtilityItem.SetAvailable(EquippedItems.Length > 1 ? EquippedItems[1] : none, eInvSlot_Utility, 1, NumUtilitySlots);

	UtilityItem = UISquadSelect_UtilityItem(ListItem.UtilitySlots.GetItem(UtilityItemIndex++));
	UtilityItem.SetAvailable(EquippedItems.Length > 2 ? EquippedItems[2] : none, eInvSlot_Utility, 2, NumUtilitySlots);

	if(Unit.HasGrenadePocket())
	{
		UtilityItem = UISquadSelect_UtilityItem(ListItem.UtilitySlots.GetItem(UtilityItemIndex++));
		EquippedItems = class'UIUtilities_Strategy'.static.GetEquippedItemsInSlot(Unit, eInvSlot_GrenadePocket);
		UtilityItem.SetAvailable(EquippedItems.Length > 0 ? EquippedItems[0] : none, eInvSlot_GrenadePocket, 0, NumUtilitySlots);
	}

	if(Unit.HasAmmoPocket())
	{
		UtilityItem = UISquadSelect_UtilityItem(ListItem.UtilitySlots.GetItem(UtilityItemIndex++));
		EquippedItems = class'UIUtilities_Strategy'.static.GetEquippedItemsInSlot(Unit, eInvSlot_AmmoPocket);
		UtilityItem.SetAvailable(EquippedItems.Length > 0 ? EquippedItems[0] : none, eInvSlot_AmmoPocket, 0, NumUtilitySlots);
	}
		
	return ELR_NoInterrupt;
}

function EventListenerReturn GetNumUtilitySlotsOverride(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple			OverrideTuple;
	local XComGameState_Item	Item;
	local int					NumSlots;  // -1 indicates no override
	local XComGameState_Unit	UnitState;

	`LOG("GetNumUtilitySlotsOverride : Starting listener.");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OverrideAddItem event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	`LOG("GetNumUtilitySlotsOverride : Parsed XComLWTuple.");

	UnitState = XComGameState_Unit(EventSource);
	if(UnitState == none)
	{
		`REDSCREEN("OverrideAddItem event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}
	`LOG("GetNumUtilitySlotsOverride : EventSource valid.");

	if(OverrideTuple.Id != 'GetNumUtilitySlots')
		return ELR_NoInterrupt;

	NumSlots = OverrideTuple.Data[0].i;
	NumSlots = NumSlots;
	Item = XComGameState_Item(OverrideTuple.Data[1].o);  // item is optional
	Item = Item;

	OverrideTuple.Data[0].i = OverrideNumUtilitySlots;

	//`LOG("GetNumUtilitySlotsOverride Override : working!.");

	return ELR_NoInterrupt;
}

function EventListenerReturn CheckOverrideAddItemToInventory(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple			OverrideTuple;
	local EInventorySlot		Slot;
	local X2ItemTemplate		ItemTemplate;
	local int					Quantity;
	local XComGameState_Unit	UnitState;

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OverrideAddItem event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverrideTuple : Parsed XComLWTuple.");

	UnitState = XComGameState_Unit(EventSource);
	if(UnitState == none)
	{
		`REDSCREEN("OverrideAddItem event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverrideTuple : EventSource valid.");

	if(OverrideTuple.Id != 'OverrideCanAddItemToInventory')
		return ELR_NoInterrupt;

	Slot = EInventorySlot(OverrideTuple.Data[2].i);
	Slot = Slot;
	ItemTemplate = X2ItemTemplate(OverrideTuple.Data[3].o);
	ItemTemplate = ItemTemplate;
	Quantity = OverrideTuple.Data[4].i;
	Quantity = Quantity;

	if(ItemTemplate == none)
		return ELR_NoInterrupt;

	//`LOG("CanAddItemToInventory Override : working!.");

	return ELR_NoInterrupt;
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIAvengerHUD;
	OverrideNumUtilitySlots = 3;
}
