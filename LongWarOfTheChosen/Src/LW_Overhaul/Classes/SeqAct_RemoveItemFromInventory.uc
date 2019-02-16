//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_RemoveItemFromInventory
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: Kismet action to remove item(s) from a unit's inventory and optionally drop
//           them as loot.
//--------------------------------------------------------------------------------------- 

class SeqAct_RemoveItemFromInventory extends SequenceAction;

var() String ItemTemplateName;
var() EInventorySlot RequiredInventorySlot;
var() bool CreateLootDrop;
var XComGameState_Unit Unit;

event Activated()
{
	local XComGameState_Item Item;
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local StateObjectReference ItemRef;
	local array<XComGameState_Item> ItemsToDrop;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SeqAct_RemoveItemFromInventory");
	Unit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
	NewGameState.AddStateObject(Unit);
	foreach Unit.InventoryItems(ItemRef)
	{
		Item = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
		if (Item != none && Item.GetMyTemplateName() == Name(ItemTemplateName) &&
				(RequiredInventorySlot == eInvSlot_Unknown || RequiredInventorySlot == Item.InventorySlot))
		{
			Unit.RemoveItemFromInventory(Item, NewGameState);
			ItemsToDrop.AddItem(Item);
		}
	}

	if (CreateLootDrop && ItemsToDrop.Length > 0)
	{
		class'XComGameState_LootDrop'.static.CreateLootDrop(NewGameState, ItemsToDrop, Unit, false);
	}
	
	if (ItemsToDrop.Length > 0)
	{
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	else
	{
		NewGameState.PurgeGameStateForObjectID(Unit.ObjectID);
		History.CleanupPendingGameState(NewGameState);
	}
}

defaultproperties
{
	ObjCategory="LWOverhaul"
	ObjName="Remove Item from Unit"
	bConvertedForReplaySystem=true
	bAutoActivateOutputLinks=true
	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit', LinkDesc="Unit", PropertyName=Unit, bWriteable=false)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String', LinkDesc="Item Template", PropertyName=ItemTemplateName, bWriteable=false)
}
