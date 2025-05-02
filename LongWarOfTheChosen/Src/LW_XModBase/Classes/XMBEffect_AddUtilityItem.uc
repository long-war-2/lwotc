//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_AddUtilityItem.uc
//  AUTHOR:  xylthixlm
//
//  Adds a utility item to a unit's inventory. The utility item granted only lasts for
//  the duration of the battle. Optionally, can also grant bonus charges to any equipped
//  items of the same kind already in the unit's inventory.
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  Pyromaniac
//  Scout
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
class XMBEffect_AddUtilityItem extends X2Effect_Persistent config(GameCore);

struct AbilityBonusAmmo {
	var name AbilityName;
	var int AmmoBonus;
};

///////////////////////
// Effect properties //
///////////////////////

var name DataName;							// The name of the item template to grant.
var int BaseCharges;						// Number of charges of the item to add.
var int BonusCharges;						// Number of extra charges of the item to add for each item of that type already in the inventory.
var bool bUseHighestAvailableUpgrade;		// If true, grant the highest available upgraded version of the item.
var array<name> SkipAbilities;				// List of abilities to not add
var EInventorySlot InvSlotEnum;				//which slot to put it in.

var config array<name> GrenadeLauncherCats;

var array<AbilityBonusAmmo> AbilityForBonusAmmo;
var int MaxCharges;
var name UnitValueName;

////////////////////
// Implementation //
////////////////////

function AddBonusAmmoAbility(name AbilityName, int Ammo)
{
	local AbilityBonusAmmo	BonusAmmo;

	BonusAmmo.AbilityName = AbilityName;
	BonusAmmo.AmmoBonus = Ammo;

	AbilityForBonusAmmo.AddItem(BonusAmmo);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2ItemTemplate ItemTemplate;
	local X2ItemTemplateManager ItemTemplateMgr;
	local XComGameState_Unit NewUnit;

	NewUnit = XComGameState_Unit(kNewTargetState);
	if (NewUnit == none)
		return;

	if (class'XMBEffectUtilities'.static.SkipForDirectMissionTransfer(ApplyEffectParameters))
		return;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateMgr.FindItemTemplate(DataName);
	
	// Use the highest upgraded available version of the item
	if (bUseHighestAvailableUpgrade)
		`XCOMHQ.UpdateItemTemplateToHighestAvailableUpgrade(ItemTemplate);

	AddUtilityItem(NewUnit, ItemTemplate, NewGameState, NewEffectState);
}
simulated function AddUtilityItem(XComGameState_Unit NewUnit, X2ItemTemplate ItemTemplate, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2EquipmentTemplate		EquipmentTemplate;
	local X2WeaponTemplate			WeaponTemplate;
	local XComGameState_Item		ItemState, GrenadeLauncherItem;
	local X2AbilityTemplateManager	AbilityTemplateMan;
	local X2AbilityTemplate			AbilityTemplate;
	local X2GrenadeTemplate			GrenadeTemplate;
	local XComGameStateHistory		History;
	local name						AbilityName;
	local array<SoldierClassAbilityType> EarnedSoldierAbilities;
	local XGUnit					UnitVisualizer;
	local int						idx;
	local int						AmmoCount;
	local AbilityBonusAmmo			BonusAmmo;

	History = `XCOMHISTORY;

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	EquipmentTemplate = X2EquipmentTemplate(ItemTemplate);
	if (EquipmentTemplate == none)
	{
		`RedScreen(`location $": Missing equipment template for" @ DataName);
		return;
	}

	AmmoCount = BaseCharges;
	foreach AbilityForBonusAmmo(BonusAmmo)
	{
		if ( NewUnit.HasSoldierAbility(BonusAmmo.AbilityName, true) )
		{
			AmmoCount += BonusAmmo.AmmoBonus;
		}
	}

	if (AmmoCount <= 0) { return; }
	if ( MaxCharges > 0 && AmmoCount > MaxCharges ) { AmmoCount = MaxCharges; }

	// Check for items that can be merged
	WeaponTemplate = X2WeaponTemplate(EquipmentTemplate);
	if (WeaponTemplate != none && WeaponTemplate.bMergeAmmo)
	{
		for (idx = 0; idx < NewUnit.InventoryItems.Length; idx++)
		{
			ItemState = XComGameState_Item(NewGameState.GetGameStateForObjectID(NewUnit.InventoryItems[idx].ObjectID));
			if (ItemState == none)
			{
				ItemState = XComGameState_Item(History.GetGameStateForObjectID(NewUnit.InventoryItems[idx].ObjectID));
			}

			if (ItemState != none && !ItemState.bMergedOut && ItemState.GetMyTemplate() == WeaponTemplate)
			{
				ItemState = XComGameState_Item(NewGameState.ModifyStateObject(ItemState.class, ItemState.ObjectID));
				ItemState.Ammo += AmmoCount + ItemState.MergedItemCount * BonusCharges;
				return;
			}

			// Flag whether the unit has a Grenade Launcher to apply any Grenade items to it
			if (ItemState != none && default.GrenadeLauncherCats.find(X2WeaponTemplate(ItemState.GetMyTemplate()).WeaponCat) != INDEX_NONE)
			{
				GrenadeLauncherItem = ItemState;
			}
		}
	}
	
	// No items to merge with, so create the item
	ItemState = EquipmentTemplate.CreateInstanceFromTemplate(NewGameState);
	ItemState.Ammo = AmmoCount;
	ItemState.Quantity = 0;  // Flag as not a real item

	// Temporarily turn off equipment restrictions so we can add the item to the unit's inventory
	NewUnit.bIgnoreItemEquipRestrictions = true;
	NewUnit.AddItemToInventory(ItemState, InvSlotEnum, NewGameState);
	NewUnit.bIgnoreItemEquipRestrictions = false;

	NewUnit.SetUnitFloatValue(GetUnitValueName(EffectName), ItemState.ObjectID, eCleanup_BeginTacticalChain);

	// Update the unit's visualizer to include the new item
	// Note: Normally this should be done in an X2Action, but since this effect is normally used in
	// a PostBeginPlay trigger, we just apply the change immediately.
	UnitVisualizer = XGUnit(NewUnit.GetVisualizer());
	UnitVisualizer.ApplyLoadoutFromGameState(NewUnit, NewGameState);

	NewEffectState.CreatedObjectReference = ItemState.GetReference();

	// Add equipment-dependent soldier abilities
	EarnedSoldierAbilities = NewUnit.GetEarnedSoldierAbilities();
	for (idx = 0; idx < EarnedSoldierAbilities.Length; ++idx)
	{
		AbilityName = EarnedSoldierAbilities[idx].AbilityName;
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);

		if (SkipAbilities.Find(AbilityName) != INDEX_NONE)
			continue;

		// Add utility-item abilities
		if (EarnedSoldierAbilities[idx].ApplyToWeaponSlot == InvSlotEnum &&
			EarnedSoldierAbilities[idx].UtilityCat == ItemState.GetWeaponCategory())
		{
			InitAbility(AbilityTemplate, NewUnit, NewGameState, ItemState.GetReference());
		}

		// Add grenade abilities. but not launch grenade - we handle it after this to handle a different case at the same time.
		if (AbilityTemplate.bUseLaunchedGrenadeEffects && AbilityName != 'LaunchGrenade' && X2GrenadeTemplate(EquipmentTemplate) != none)
		{
			InitAbility(AbilityTemplate, NewUnit, NewGameState, NewUnit.GetItemInSlot(EarnedSoldierAbilities[idx].ApplyToWeaponSlot, NewGameState).GetReference(), ItemState.GetReference());
		}
	}

	// Add launch grenade for grenades if the soldier has a launcher. we do it here to also catch when the ability is coming form the launcher instead of class abilities.
	GrenadeTemplate = X2GrenadeTemplate(EquipmentTemplate);
	if (GrenadeTemplate != none && GrenadeTemplate.LaunchedGrenadeEffects.Length > 0 && GrenadeLauncherItem != none)
	{
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('LaunchGrenade');
		//AbilityRef = `TACTICALRULES.InitAbilityForUnit(LaunchGrenadeTemplate, TargetUnit, NewGameState, GrenadeLauncherItem.GetReference(), InventoryItem.GetReference());
		InitAbility(AbilityTemplate, NewUnit, NewGameState, GrenadeLauncherItem.GetReference(), ItemState.GetReference());
	}

	// Add abilities from the equipment item itself. Add these last in case they're overridden by soldier abilities.
	foreach EquipmentTemplate.Abilities(AbilityName)
	{
		if (SkipAbilities.Find(AbilityName) != INDEX_NONE)
			continue;

		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
		InitAbility(AbilityTemplate, NewUnit, NewGameState, ItemState.GetReference());
	}
}

simulated function InitAbility(X2AbilityTemplate AbilityTemplate, XComGameState_Unit NewUnit, XComGameState NewGameState, optional StateObjectReference ItemRef, optional StateObjectReference AmmoRef)
{
	local XComGameState_Ability OtherAbility;
	local StateObjectReference AbilityRef;
	local XComGameStateHistory History;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local name AdditionalAbility;

	History = `XCOMHISTORY;
	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	// Check for ability overrides
	foreach NewUnit.Abilities(AbilityRef)
	{
		OtherAbility = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));

		if (OtherAbility.GetMyTemplate().OverrideAbilities.Find(AbilityTemplate.DataName) != INDEX_NONE)
			return;
	}

	AbilityRef = `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, NewUnit, NewGameState, ItemRef, AmmoRef);

	// Add additional abilities
	foreach AbilityTemplate.AdditionalAbilities(AdditionalAbility)
	{
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AdditionalAbility);

		// Check for overrides of the additional abilities
		foreach NewUnit.Abilities(AbilityRef)
		{
			OtherAbility = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));

			if (OtherAbility.GetMyTemplate().OverrideAbilities.Find(AbilityTemplate.DataName) != INDEX_NONE)
				return;
		}

		AbilityRef = `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, NewUnit, NewGameState, ItemRef, AmmoRef);
	}
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local UnitValue ItemUnitValue;
	local XComGameState_Unit UnitState;
	local XComGameState_Item ItemState;

	if (RemovedEffectState.CreatedObjectReference.ObjectID > 0)
		NewGameState.RemoveStateObject(RemovedEffectState.CreatedObjectReference.ObjectID);
	else
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		UnitState.GetUnitValue(GetUnitValueName(EffectName), ItemUnitValue);

		if(ItemUnitValue.fValue > 0)
		{
			ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemUnitValue.fValue));
			UnitState.RemoveItemFromInventory(ItemState);
			NewGameState.RemoveStateObject(ItemState.ObjectID);
		}
	}

}

function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local XComGameState NewGameState;
	local UnitValue ItemUnitValue;
	local XComGameState_Item ItemState;

	NewGameState = UnitState.GetParentGameState();

	if (EffectState.CreatedObjectReference.ObjectID > 0)
		NewGameState.RemoveStateObject(EffectState.CreatedObjectReference.ObjectID);
	else
	{
		UnitState.GetUnitValue(GetUnitValueName(EffectName), ItemUnitValue);

		if(ItemUnitValue.fValue > 0)
		{
			ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemUnitValue.fValue));
			UnitState.RemoveItemFromInventory(ItemState);
			NewGameState.RemoveStateObject(ItemState.ObjectID);
		}
	}
	
}

static function name GetUnitValueName(name ThisEffectName)
{
	return name(ThisEffectName $ default.UnitValueName);
}

defaultproperties
{
	BaseCharges = 1
	bUseHighestAvailableUpgrade = true
	InvSlotEnum = eInvSlot_Utility
	UnitValueName = "_XMBItemEffectUnitValue";
}