//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_AddItemCharges.uc
//  AUTHOR:  xylthixlm
//
//  Adds extra charges to equipped items based on the slots those items are in.
//
//  USAGE
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  Packmaster
//  Rocketeer
//  SmokeAndMirrors
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  XMBEffectUtilities.uc
//---------------------------------------------------------------------------------------
class XMBEffect_AddItemCharges extends X2Effect;


//////////////////////
// Bonus properties //
//////////////////////

var int PerItemBonus;						// The number of charges to add for each item in the right slot.


//////////////////////////
// Condition properties //
//////////////////////////

var array<name> ApplyToNames;				// The names of items to add charges to.
var array<EInventorySlot> ApplyToSlots;		// The slot, or slots, to add charges to items in.


////////////////////////////
// Overrideable functions //
////////////////////////////

// This effect adds additional charges to inventory items, similar to how Heavy Ordnance gives an
// extra use of the grenade in the grenade-only slot. You can either set the ApplyToSlots and 
// PerItemBonus for simple uses, or override GetItemChargeModifier() to do more complex things like
// only give extra uses to certain items.
function int GetItemChargeModifier(XComGameState NewGameState, XComGameState_Unit NewUnit, XComGameState_Item ItemIter)
{
	if (ItemIter.Quantity == 0)
		return 0;

	if (ApplyToNames.Length > 0 && ApplyToNames.Find(ItemIter.GetMyTemplateName()) == INDEX_NONE)
		return 0;

	if (ApplyToSlots.Length > 0 && ApplyToSlots.Find(ItemIter.InventorySlot) == INDEX_NONE)
		return 0;

	return PerItemBonus;
}


////////////////////
// Implementation //
////////////////////

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit NewUnit;
	local XComGameState_Item ItemState, InnerItemState;
	local XComGameStateHistory History;
	local int i, j, modifier;

	NewUnit = XComGameState_Unit(kNewTargetState);
	if (NewUnit == none)
		return;

	History = `XCOMHISTORY;

	if (class'XMBEffectUtilities'.static.SkipForDirectMissionTransfer(ApplyEffectParameters))
		return;

	for (i = 0; i < NewUnit.InventoryItems.Length; ++i)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(NewUnit.InventoryItems[i].ObjectID));
		if (ItemState != none && !ItemState.bMergedOut)
		{
			modifier = GetItemChargeModifier(NewGameState, NewUnit, ItemState);

			// Add in the charges for merged items. We can't just multiply by MergedItemCount
			// because GetItemChargeModifier might give different results if the merged items
			// were in different slots.
			for (j = 0; j < NewUnit.InventoryItems.Length; ++j)
			{
				InnerItemState = XComGameState_Item(History.GetGameStateForObjectID(NewUnit.InventoryItems[j].ObjectID));
				if (InnerItemState.bMergedOut && InnerItemState.GetMyTemplate() == ItemState.GetMyTemplate())
				{
					modifier += GetItemChargeModifier(NewGameState, NewUnit, InnerItemState);
				}
			}

			if (modifier != 0)
			{
				ItemState = XComGameState_Item(NewGameState.ModifyStateObject(ItemState.class, ItemState.ObjectID));
				ItemState.Ammo += modifier;
			}
		}
	}
	
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

defaultproperties
{
	PerItemBonus = 1;
}
