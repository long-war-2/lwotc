//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TemporaryItem
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Effect for adding temporary items to a unit
//--------------------------------------------------------------------------------------- 

class X2Effect_TemporaryItem extends X2Effect_Persistent;

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

struct ResearchConditional
{
	var name ResearchProjectName;
	var name ItemName;
};

var name ItemName;
var array<name> AlternativeItemNames;
var array<ResearchConditional> ResearchOptionalItems;
var array<name> AdditionalAbilities;
var array<name> ForceCheckAbilities;
var bool bIgnoreItemEquipRestrictions;
var bool bReplaceExistingItemOnly;
var name ExistingItemName;
var bool bOverrideInventorySlot;
var EInventorySlot InventorySlotOverride;

var name UnitValueName;

// Deprecated - now using OnEffectRemoved and UnitEndedTacticalPlay instead.
/* 
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;
	local XComGameState_Unit EffectTargetUnit;

	EffectObj = EffectGameState;

	EffectTargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	//`XEVENTMGR.RegisterForEvent(EffectObj, 'TacticalGameEnd', OnTacticalGameEnd, ELD_OnStateSubmitted,,,, EffectTargetUnit);
}
*/

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_HeadquartersXCom		XComHQ;
	local ResearchConditional					Conditional;
	local name									UseItemName, AltItemName;
	local XComGameState_Unit					UnitState; 
	local XComGameState_Item					OldItemState, UpdatedItemState, NewItemState;
	local X2EquipmentTemplate					EquipmentTemplate;
	local X2WeaponTemplate						WeaponTemplate;
	local XComGameState_Effect_TemporaryItem	EffectState;
	local EInventorySlot						InventorySlot;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState == none)
		return;
	
	EffectState = XComGameState_Effect_TemporaryItem(NewEffectState);
	if (EffectState == none)
		return;

	// Don't add temp stuff twice.
	if (SkipForDirectMissionTransfer(ApplyEffectParameters))
		return;

	XComHQ = `XCOMHQ;
	UseItemName = ItemName;
	//check if we meet any of the optional research conditions to add a better item

	if(XComHQ != NONE)
	{
		foreach ResearchOptionalItems(Conditional)
		{
			if(XComHQ.IsTechResearched(Conditional.ResearchProjectName))
			{
				UseItemName = Conditional.ItemName;
				break;
			}
		}
	}
	
	EquipmentTemplate = X2WeaponTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(UseItemName));
	if(bOverrideInventorySlot)
		InventorySlot = InventorySlotOverride;
	else
		InventorySlot = EquipmentTemplate.InventorySlot;

	if(bReplaceExistingItemOnly)
		OldItemState = GetItem(UnitState, ExistingItemName);
	else
		OldItemState = GetItem(UnitState, UseItemName);

	if(OldItemState == none && !bReplaceExistingItemOnly)
	{
		//check and see if any of the alternative options are available to replace before adding a new item
		foreach AlternativeItemNames(AltItemName)
		{
			OldItemState = GetItem(UnitState, AltItemName);
			if(OldItemState != none)
			{
				UseItemName = AltItemName;
				EquipmentTemplate = X2WeaponTemplate(class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(UseItemName));
				if(EquipmentTemplate != none)
					break;
			}
		}
	}

	if (EquipmentTemplate == none)
		return;

	if(OldItemState == none && bReplaceExistingItemOnly)
		return;

	if (OldItemState != none && !bReplaceExistingItemOnly)
	{
		// The unit has this item already, so add ammo/charges if appropriate, otherwise silently ignore
		WeaponTemplate = X2WeaponTemplate(EquipmentTemplate);
		if (WeaponTemplate != none && WeaponTemplate.bMergeAmmo)
		{
			UpdatedItemState = XComGameState_Item(NewGameState.ModifyStateObject(OldItemState.Class, OldItemState.ObjectID));
			UpdatedItemState.Ammo += WeaponTemplate.iClipSize;
		}
	}
	else // Unit either doesn't have item, or it has it and it has to be replaced
	{
		// Create a new XCGS_Item instance
		NewItemState = AddNewItemToUnit(EquipmentTemplate, UnitState, InventorySlot, NewGameState);

		if(bReplaceExistingItemOnly)
		{
			//transfer ammo information over
			NewItemState.Ammo = OldItemState.Ammo;
			NewItemState.MergedItemCount = OldItemState.MergedItemCount;

			//mark old item as having no ammo -- this hides grenades and the like
			OldItemState.Ammo = 0;
			OldItemState.MergedItemCount = 0;
			OldItemState.bMergedOut = true;
		}

		EffectState.TemporaryItems.AddItem(NewItemState.GetReference());
		//`LWTrace("Added TemporaryItem to EffectState:" @NewItemState @EffectState);
	}

	//`LWTrace("Temporary Items length:" @ EffectState.TemporaryItems.Length);
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function XComGameState_Item AddNewItemToUnit(X2EquipmentTemplate EquipmentTemplate, XComGameState_Unit UnitState, EInventorySlot InventorySlot, XComGameState NewGameState)
{
	local XComGameStateHistory			History;
	local XGUnit						Visualizer;
	local XComGameState_Item			ItemState, TempItem;
	local X2AbilityTemplateManager		AbilityManager;
	local X2AbilityTemplate				AbilityTemplate;
	local bool							bCachedIgnoredItemEquipRestrictions;
	local array<name>					EquipmentAbilities;
	local name							AbilityName;
	local StateObjectReference			AbilityRef;
	local XComGameState_Ability			AbilityState;

	History = `XCOMHISTORY;
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	Visualizer = XGUnit(UnitState.GetVisualizer());

	// Create a new XCGS_Item instance
	ItemState = EquipmentTemplate.CreateInstanceFromTemplate(NewGameState);
	NewGameState.AddStateObject(ItemState);
	NewGameState.AddStateObject(UnitState);

	bCachedIgnoredItemEquipRestrictions = UnitState.bIgnoreItemEquipRestrictions;
	UnitState.bIgnoreItemEquipRestrictions = bIgnoreItemEquipRestrictions;

	// Add the temporary item to the unit's inventory, adding the new state object to the NewGameState container
	if(!UnitState.AddItemToInventory(ItemState, InventorySlot, NewGameState))
		`REDSCREEN("TempItem : Failed to add Item" @ ItemState.GetMyTemplateName() @ "to inventory.");

	UnitState.bIgnoreItemEquipRestrictions = bCachedIgnoredItemEquipRestrictions;

	// Store it in a UnitValue too.
	UnitState.SetUnitFloatValue(GetItemUnitValueName_Static(EffectName), ItemState.ObjectID, eCleanup_BeginTacticalChain);
	
	// At this point the item has been created and added to the unit's inventory, but any item (or additional) abilities have yet to be added
	EquipmentAbilities = GatherAbilitiesForItem(EquipmentTemplate);

	//first, create any abilities that are missing
	foreach EquipmentAbilities(AbilityName)
	{
		`PPTRACE("TempItem: Testing to add" @ AbilityName);
		AbilityRef = UnitState.FindAbility(AbilityName, ItemState.GetReference());
		if(AbilityRef.ObjectID == 0)
		{
			`PPTRACE("TempItem:" @ AbilityName @ "/Item combo not found, adding.");
			AddAbilityToUnit(AbilityName, UnitState, ItemState.GetReference(), NewGameState);
		}
		AbilityRef = UnitState.FindAbility(AbilityName, ItemState.GetReference());
		if(AbilityRef.ObjectID > 0) {
			`PPTRACE("TempItem : Post AddAbilityToUnit -- Ability + Item combo found");
		} else {
			`PPTRACE("TempItem : Post AddAbilityToUnit -- Ability + Item combo NOT found");
		}
	}

	//special handling for LaunchGrenade and maybe some other stuff
	foreach ForceCheckAbilities(AbilityName)
	{
		`PPTRACE("TempItem : Checking ability" @ AbilityName @ "on unit:" @ UnitState.GetFullName());
		AbilityRef = UnitState.FindAbility(AbilityName);
		if(AbilityRef.ObjectID > 0)
		{
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
			`PPTRACE("TempItem :" @ AbilityName @ "found, adding for new ammo type.");
			if(AbilityState.SourceWeapon.ObjectId > 0)
			{
				TempItem = XComGameState_Item(History.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));
				`PPTRACE("TempItem : Adding" @ ItemState.GetMyTemplate().GetItemFriendlyName() @ "as ammo to" @ TempItem.GetMyTemplate().GetItemFriendlyName());

				//AddAbilityToUnit(AbilityName, UnitState, ItemState.GetReference(), NewGameState, ItemState.GetReference());	// try and use AddToAbility helper to add item as weapon/ammo for launch grenade
				//AddAbilityToUnit(AbilityName, UnitState, AbilityState.SourceWeapon, NewGameState, ItemState.GetReference());  // try and use AddToAbility helper to add launcher/ammo ability mapping

				AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
				`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState, AbilityState.SourceWeapon, ItemState.GetReference());
			}
			else
			{
				`REDSCREEN("TempItem : No source weapon found for AbilityName=" $ AbilityName);
			}
		} else {
			if(UnitState.HasSoldierAbility(AbilityName)) {
				AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
				`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState, UnitState.GetSecondaryWeapon().GetReference(), ItemState.GetReference());
			}
		}
		AbilityRef = UnitState.FindAbility(AbilityName, ItemState.GetReference());
		if(AbilityRef.ObjectID > 0) {
			`PPTRACE("TempItem : Post AddAbilityToUnit -- Ability + Item combo found");
		} else {
			`PPTRACE("TempItem : Post AddAbilityToUnit -- Ability + Item combo NOT found");
		}
	}

	//Create the visualizer for the new item, and attach it if needed
	Visualizer.ApplyLoadoutFromGameState(UnitState, NewGameState);

	return ItemState;
}

static function XComGameState_Item GetItem(XComGameState_Unit Unit, name TemplateName, optional XComGameState CheckGameState)
{
	local array<XComGameState_Item> Items;
	local XComGameState_Item Item;

	Items = Unit.GetAllInventoryItems(CheckGameState);
	foreach Items(Item)
	{
		if(Item.GetMyTemplateName() == TemplateName && !Item.bMergedOut)
			return Item;
	}
	return none;
} 

function array<name> GatherAbilitiesForItem(X2EquipmentTemplate EquipmentTemplate)
{
	local name AbilityName, AdditionalAbilityName;
	local array<name> EquipmentAbilities;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local X2AbilityTemplate AbilityTemplate, AdditionalAbilityTemplate;

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	EquipmentAbilities = AdditionalAbilities;

	if (EquipmentTemplate != none)
	{
		foreach EquipmentTemplate.Abilities(AbilityName)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
			if (AbilityTemplate != none && AbilityName != 'SmallItemWeight' && EquipmentAbilities.Find(AbilityName) == INDEX_NONE) // add ability if not duplicate
			{
				EquipmentAbilities.AddItem(AbilityName);
				foreach AbilityTemplate.AdditionalAbilities(AdditionalAbilityName)  // handle any additional abilities
				{
					AdditionalAbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AdditionalAbilityName);
					if (AdditionalAbilityTemplate != none && EquipmentAbilities.Find(AdditionalAbilityName) == INDEX_NONE)
					{
						EquipmentAbilities.AddItem(AdditionalAbilityName);
					}
					else if (AdditionalAbilityTemplate == none)
					{
						`RedScreen("Equipment template" @ EquipmentTemplate.DataName @ "specifies unknown additional ability:" @ AdditionalAbilityName);
					}
				}
			}
			else if (AbilityTemplate == none)
			{
				`RedScreen("Equipment template" @ EquipmentTemplate.DataName @ "specifies unknown ability:" @ AbilityName);
			}
		}
	}
	return EquipmentAbilities;
}

function array<X2AbilityTemplate> AddAbilityToUnit(name AbilityName, XComGameState_Unit AbilitySourceUnitState, StateObjectReference ItemRef, XComGameState NewGameState, optional StateObjectReference AmmoRef)
{
	local X2AbilityTemplate RootAbilityTemplate, AbilityTemplate;
	local array<X2AbilityTemplate> AllAbilityTemplates, ReturnAbilityTemplates;
	local X2AbilityTemplateManager AbilityManager;
	local StateObjectReference AbilityRef;
	local Name AdditionalAbilityName;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	RootAbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);

	if( RootAbilityTemplate != none )
	{
		AllAbilityTemplates.AddItem(RootAbilityTemplate);
		foreach RootAbilityTemplate.AdditionalAbilities(AdditionalAbilityName)
		{
			AbilityTemplate = AbilityManager.FindAbilityTemplate(AdditionalAbilityName);
			if( AbilityTemplate != none )
			{
				AllAbilityTemplates.AddItem(AbilityTemplate);
			}
		}
	}

	foreach AllAbilityTemplates(AbilityTemplate)
	{
		AbilityRef = AbilitySourceUnitState.FindAbility(AbilityTemplate.DataName, ItemRef);
		if( AbilityRef.ObjectID == 0 )
		{
			AbilityRef = `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, AbilitySourceUnitState, NewGameState, ItemRef, AmmoRef);
			ReturnAbilityTemplates.AddItem(AbilityTemplate);
		}

		// WOTC TODO: Don't know if this is doing anything useful.
		NewGameState.ModifyStateObject(class'XComGameState_Ability', AbilityRef.ObjectID);
	}
	return ReturnAbilityTemplates;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Effect_TemporaryItem EffectState;
	local XComGameState_Unit UnitState;

	//`LWTrace("OnEffectRemoved called for TemporaryItems");

	EffectState = XComGameState_Effect_TemporaryItem(RemovedEffectState);
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	ClearTemporaryItems(EffectState, NewGameState, UnitState);

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}

// Deprecated function
static function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState				NewGameState;
	local XComGameState_Effect_TemporaryItem EffectState;
	local XComGameState_Unit UnitState;

	//`LWTrace("OnTacticalGameEnd called for TemporaryItems");
	
	EffectState = XComGameState_Effect_TemporaryItem(CallbackData);
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(XComGameState_BaseObject(EventSource).ObjectID));
	//`LWTrace("Effect State returned:" @EffectState);
	//`LWTrace("Unit:" @UnitState.GetFullName());
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Temporary Item Cleanup");
	ClearTemporaryItems(EffectState, NewGameState, UnitState);

	if( NewGameState.GetNumGameStateObjects() > 0 )
		`GAMERULES.SubmitGameState(NewGameState);
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);

	return ELR_NoInterrupt;
}

// let's handle this function too so we can cover all possible things
function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local XComGameState NewGameState;
	local XComGameState_Effect_TemporaryItem TemporaryEffectState;

	//`LWTrace("UnitEndedTacticalPlay called on TemporaryItemEffect");
	
	TemporaryEffectState = XComGameState_Effect_TemporaryItem(EffectState);
	NewGameState = UnitState.GetParentGameState();

	if (TemporaryEffectState != none)
	{
		//`LWTrace("Effect state found, entering ClearTemporaryItems");
		ClearTemporaryItems(TemporaryEffectState, NewGameState, UnitState);
	}
	else
	{
		`LWTrace("EffectState not found from UnitEndedTacticalPlay");
	}
}


static function ClearTemporaryItems(XComGameState_Effect_TemporaryItem EffectState, XComGameState NewGameState, XComGameState_Unit OriginalUnitState)
{
	local XComGameStateHistory		History;
	local StateObjectReference		ItemRef;
	local XComGameState_Item		ItemState;
	local XComGameState_Unit		UnitState;
	local UnitValue					ItemUnitValue;

	History = `XCOMHISTORY;

	//`LWTrace("ClearTemporaryItems called, TemporaryItems length:" @ EffectState.TemporaryItems.length);

	foreach EffectState.TemporaryItems(ItemRef)
	{
		//`LWTrace("Checking item" @ItemRef.ObjectId);
		if (ItemRef.ObjectID > 0)
		{
			//`LWTrace("ItemRef Found");
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
			if (ItemState != none)
			{
				//`LWTrace("ItemState Found in History");
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.OwnerStateObject.ObjectID));
				if (UnitState != none)
				{
					//`LWTrace("Unit owner found, removing");
					UnitState.RemoveItemFromInventory(ItemState); // Remove the item from the unit's inventory
				}
				else
				{
					`LWTrace("TemporaryItem: Owner not found");
				}
		
				// Remove the temporary item's gamestate object from history
				NewGameState.RemoveStateObject(ItemRef.ObjectID);
			}
		}
	}

	// catch multi phase missions
	if(EffectState.TemporaryItems.length == 0)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(OriginalUnitState.ObjectID));

		UnitState.GetUnitValue(GetItemUnitValueName_Static(EffectState.GetX2Effect().EffectName), ItemUnitValue);

		//`LWTrace("Item found from UnitValue:" @ItemUnitValue.fValue);

		if(ItemUnitValue.fValue > 0)
		{
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemUnitValue.fValue));
			UnitState.RemoveItemFromInventory(ItemState);
			NewGameState.RemoveStateObject(ItemState.ObjectID);
		}
	}

	// Remove this gamestate object from history
	NewGameState.RemoveStateObject(EffectState.ObjectID);
}

// borrowed from XMB
static function bool SkipForDirectMissionTransfer(const out EffectAppliedData ApplyEffectParameters)
{
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local int Priority;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (!BattleData.DirectTransferInfo.IsDirectMissionTransfer)
		return false;

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (!AbilityState.IsAbilityTriggeredOnUnitPostBeginTacticalPlay(Priority))
		return false;

	return true;
}

static function name GetItemUnitValueName_Static(name AbilityName)
{
	return name(AbilityName $ default.UnitValueName);
}

defaultProperties
{
	bInfiniteDuration = true;
	GameStateEffectClass=class'XComGameState_Effect_TemporaryItem';
	DuplicateResponse = eDupe_Ignore;
	UnitValueName = "_LWTemporaryItemEffectUnitValue";
}
