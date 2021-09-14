class X2RocketTemplate extends X2GrenadeTemplate config(RocketLaunchers);

var bool RequireArming;	//	whether a rocket must be armed before it can be fired
var float MobilityPenalty;	//	mobility penalty applied by each rocket
var localized string GiveRocketAbilityName;
var localized string GiveArmedRocketAbilityName;
var localized string ArmRocketAbilityName;
var localized string ArmRocketFlyover;

//	Used by X2TargetingMethod_PierceBehindTarget
var int PierceDistance;

var name PairedTemplateName;

var array<name> COMPATIBLE_LAUNCHERS;
/*
static function string GetMyRocketArmedFlyoverText()
{
	return ArmRocketFlyover;
}*/

static function EInventorySlot GetFreeRocketSlot(XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XComGameState_Item TestState;

	TestState = UnitState.GetItemInSlot(eInvSlot_ExtraRocket2, NewGameState);
	if (TestState == none)
	{
		return eInvSlot_ExtraRocket2;
	}

	TestState = UnitState.GetItemInSlot(eInvSlot_ExtraRocket3, NewGameState);
	if (TestState == none) 
	{
		return eInvSlot_ExtraRocket3;
	}

	TestState = UnitState.GetItemInSlot(eInvSlot_ExtraRocket4, NewGameState);
	if (TestState == none)
	{
		return eInvSlot_ExtraRocket4;
	}

	return eInvSlot_Unknown;
}

static function int CountRocketsOnSoldier(XComGameState_Unit UnitState, optional XComGameState CheckGameState = none)
{
	local StateObjectReference	Ref;
	local XComGameStateHistory	History;
	local XComGameState_Item	ItemState;
	local int iRockets;

	iRockets = 0;

	if (CheckGameState != none)
	{
		foreach UnitState.InventoryItems(Ref)
		{
			ItemState = XComGameState_Item(CheckGameState.GetGameStateForObjectID(Ref.ObjectID));
			if (ItemState != none && 
				ItemState.Ammo > 0 && 
				X2RocketTemplate(ItemState.GetMyTemplate()) != none)
			{
				iRockets++;
			}
		}
	}
	else
	{
		History = `XCOMHISTORY;

		foreach UnitState.InventoryItems(Ref)
		{
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(Ref.ObjectID));
			////`LOG("Cycling through: " @ ItemState.GetMyTemplateName() @ ItemState.Ammo @ X2RocketTemplate(ItemState.GetMyTemplate()) != none,, 'IRIDARROCK');
			if (ItemState != none && 
				ItemState.Ammo > 0 && 
				X2RocketTemplate(ItemState.GetMyTemplate()) != none)
			{
				iRockets++;
			}
		}
	}
	//`redscreen(`showvar(iRockets));
	return iRockets;
}

static function name GetRocketSocketByInventorySlot(EInventorySlot TestInventorySlot)
{
	switch (TestInventorySlot)
	{
		case eInvSlot_ExtraRocket2:
			return 'RocketClip1';

		case eInvSlot_ExtraRocket3:
			return 'RocketClip2';

		case eInvSlot_ExtraRocket4:
			return 'RocketClip3';

		default:
			return 'nosocket';
	}
}

function PairEquipped(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local X2ItemTemplate PairedItemTemplate;
	local EInventorySlot PairedSlot;
	local XComGameState_Item PairedItem, RemoveItem;

	PairedSlot = GetFreeRocketSlot(UnitState, NewGameState);

	if (PairedSlot != eInvSlot_Unknown)
	{
		if (PairedTemplateName != '')
		{
			RemoveItem = UnitState.GetItemInSlot(PairedSlot, NewGameState);
			if (RemoveItem != none)
			{
				if (UnitState.RemoveItemFromInventory(RemoveItem, NewGameState))
				{
					NewGameState.RemoveStateObject(RemoveItem.ObjectID);
				}
				else
				{
					`RedScreen("Unable to remove item" @ RemoveItem.GetMyTemplateName() @ "in PairedSlot" @ PairedSlot @ "so paired item equip will fail -jbouscher / @gameplay");
				}
			}
			PairedItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(PairedTemplateName);

			if (PairedItemTemplate != none)
			{
				PairedItem = PairedItemTemplate.CreateInstanceFromTemplate(NewGameState);
				PairedItem.WeaponAppearance = ItemState.WeaponAppearance; // Copy appearance data

				//	creating a link between the rocket in the utility slot and its visual representation in the cosmetic rocket slot
				ItemState.SoldierKitOwner = PairedItem.GetReference();
				PairedItem.Nickname = string(GetRocketSocketByInventorySlot(PairedSlot));

				UnitState.AddItemToInventory(PairedItem, PairedSlot, NewGameState);

				////`LOG("Equipping" @ PairedTemplateName @ "on" @ UnitState.GetFullName() @ " into slot " @ `showvar(PairedSlot) @ "and socket:" @ PairedItem.Nickname @ ", ObjectID: " @ ItemState.SoldierKitOwner.ObjectID,, 'IRIDAR');

				if (UnitState.GetItemInSlot(PairedSlot, NewGameState, true).ObjectID != PairedItem.ObjectID)
				{
					`RedScreen("Created a paired item ID" @ PairedItem.ObjectID @ "but we could not add it to the unit's inventory, destroying it instead -jbouscher / @gameplay");
					NewGameState.PurgeGameStateForObjectID(PairedItem.ObjectID);
				}

				/*
				if (XComPresentationLayer(`PRESBASE) != none)
				{
					if (PairedItem.GetVisualizer() == none) `redscreen("no visualizer!");

					PairedItem = UnitState.GetItemInSlot(PairedSlot, NewGameState, true);
					XComWeapon(XGWeapon(PairedItem.GetVisualizer()).m_kEntity).Mesh.SetHidden(true);
				}*/
			}
		
		}
	}
	else `redscreen("X2RocketTemplate -> Tried to equip more rockets than soldier can carry" @ UnitState.GetFullName() @ ".-Iridar");
}

function PairUnEquipped(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XComGameState_Item PairedItem;
	local XGWeapon VisWeapon;

	PairedItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ItemState.SoldierKitOwner.ObjectID));

	if (PairedItem == none) `redscreen("X2RocketTemplate -> could not find the Item State for the cosmetic rocket to unequip. -Iridar");

	if (PairedItem != none && PairedItem.GetMyTemplateName() == PairedTemplateName)
	{
		if (UnitState.RemoveItemFromInventory(PairedItem, NewGameState))
		{
			VisWeapon = XGWeapon(PairedItem.GetVisualizer());
			if (VisWeapon != none && VisWeapon.UnitPawn != none)
			{
				VisWeapon.UnitPawn.DetachItem(VisWeapon.GetEntity().Mesh);
			}
			NewGameState.RemoveStateObject(PairedItem.ObjectID);
		}
		else
		{
			`RedScreen("X2RocketTemplate -> Failed to unequip item:" @ PairedItem.GetMyTemplateName() @ " from " @ UnitState.GetFullName @ ".-Iridar");
		}
	}
}

DefaultProperties
{
	//PairedSlot = eInvSlot_Unknown
	StowedLocation = eSlot_None

	OnEquippedFn = PairEquipped
	OnUnequippedFn = PairUnEquipped

	ItemCat="weapon"
	WeaponCat="rocket"
	
	bMergeAmmo = false;	//"true" breaks the link between cosmetic rocket and the actual rocket if the soldier has more than 1 of the same rocket equipped.
}


/*
DefaultProperties
{
	bAllowVolatileMix=true
	WeaponCat="grenade"
	ItemCat="grenade"
	InventorySlot=eInvSlot_Utility
	StowedLocation=eSlot_BeltHolster
	bMergeAmmo=true
	bSoundOriginatesFromOwnerLocation=false
	bFriendlyFire=true
	bFriendlyFireWarning=true
	bHideWithNoAmmo=true
}*/


/*
function PairEquipped(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XGWeapon		kWeapon;
	local XComUnitPawn	UnitPawn;
	local XComGameState_Unit	OldUnitState;
	//local XGUnit		Visualizer;

	//Visualizer = XGUnit(UnitState.GetVisualizer());
	//UnitPawn = Visualizer.GetPawn();

	OldUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitState.ObjectID));

	UnitPawn = XGUnit(OldUnitState.GetVisualizer()).GetPawn();

	if (UnitPawn != none)
	{
		kWeapon = XGWeapon(class'XGItem'.static.CreateVisualizer(ItemState, true, UnitPawn));

		if(kWeapon.m_kOwner != none)
		{
			kWeapon.m_kOwner.GetInventory().PresRemoveItem(kWeapon);
		}
		else //`LOG("kWeapon.m_kOwner is none",, 'IRIROCKET');

		`HQPRES.GetUIPawnMgr().AssociateWeaponPawn(eInvSlot_Utility, ItemState.GetVisualizer(), UnitState.GetReference().ObjectID, UnitPawn, false);

		kWeapon.UnitPawn = UnitPawn;
		kWeapon.m_eSlot = eSlot_LeftBack; // right hand slot is for Primary weapons
		UnitPawn.EquipWeapon(kWeapon.GetEntity(), true, false);
		//`LOG("Success, equipping rocket weapon",, 'IRIROCKET');
	}
	else //`LOG("XComUnitPawn is none",, 'IRIROCKET');
}*/
/*
{
	local X2ItemTemplate PairedItemTemplate;
	local XComGameState_Item PairedItem, RemoveItem;

	if (PairedTemplateName != '')
	{
		RemoveItem = UnitState.GetItemInSlot(PairedSlot, NewGameState);
		if (RemoveItem != none)
		{
			if (UnitState.RemoveItemFromInventory(RemoveItem, NewGameState))
			{
				NewGameState.RemoveStateObject(RemoveItem.ObjectID);
			}
			else
			{
				`RedScreen("Unable to remove item" @ RemoveItem.GetMyTemplateName() @ "in PairedSlot" @ PairedSlot @ "so paired item equip will fail -jbouscher / @gameplay");
			}
		}
		PairedItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(PairedTemplateName);
		if (PairedItemTemplate != none)
		{
			PairedItem = PairedItemTemplate.CreateInstanceFromTemplate(NewGameState);
			PairedItem.WeaponAppearance = ItemState.WeaponAppearance; // Copy appearance data
			UnitState.AddItemToInventory(PairedItem, PairedSlot, NewGameState);
			if (UnitState.GetItemInSlot(PairedSlot, NewGameState, true).ObjectID != PairedItem.ObjectID)
			{
				`RedScreen("Created a paired item ID" @ PairedItem.ObjectID @ "but we could not add it to the unit's inventory, destroying it instead -jbouscher / @gameplay");
				NewGameState.PurgeGameStateForObjectID(PairedItem.ObjectID);
			}
		}
	}
}
*//*
function PairUnEquipped(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XComGameState_Item PairedItem;
	local XGWeapon VisWeapon;

	PairedItem = UnitState.GetItemInSlot(PairedSlot, NewGameState);
	if (PairedItem != none && PairedItem.GetMyTemplateName() == PairedTemplateName)
	{
		if (UnitState.RemoveItemFromInventory(PairedItem, NewGameState))
		{
			VisWeapon = XGWeapon(PairedItem.GetVisualizer());
			if (VisWeapon != none && VisWeapon.UnitPawn != none)
			{
				VisWeapon.UnitPawn.DetachItem(VisWeapon.GetEntity().Mesh);
			}
			NewGameState.RemoveStateObject(PairedItem.ObjectID);
		}
		else
		{
			`assert(false);
		}
	}
}*/
/*
function PairEquipped(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local X2ItemTemplate PairedItemTemplate;
	local XComGameState_Item PairedItem, RemoveItem;

	if (PairedTemplateName != '')
	{
		RemoveItem = UnitState.GetItemInSlot(PairedSlot, NewGameState);
		if (RemoveItem != none)
		{
			if (UnitState.RemoveItemFromInventory(RemoveItem, NewGameState))
			{
				NewGameState.RemoveStateObject(RemoveItem.ObjectID);
			}
			else
			{
				`RedScreen("Unable to remove item" @ RemoveItem.GetMyTemplateName() @ "in PairedSlot" @ PairedSlot @ "so paired item equip will fail -jbouscher / @gameplay");
			}
		}
		PairedItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(PairedTemplateName);
		if (PairedItemTemplate != none)
		{
			PairedItem = PairedItemTemplate.CreateInstanceFromTemplate(NewGameState);
			PairedItem.WeaponAppearance = ItemState.WeaponAppearance; // Copy appearance data
			UnitState.AddItemToInventory(PairedItem, PairedSlot, NewGameState);
			if (UnitState.GetItemInSlot(PairedSlot, NewGameState, true).ObjectID != PairedItem.ObjectID)
			{
				`RedScreen("Created a paired item ID" @ PairedItem.ObjectID @ "but we could not add it to the unit's inventory, destroying it instead -jbouscher / @gameplay");
				NewGameState.PurgeGameStateForObjectID(PairedItem.ObjectID);
			}
		}
	}
}

function PairUnEquipped(XComGameState_Item ItemState, XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XComGameState_Item PairedItem;
	local XGWeapon VisWeapon;

	PairedItem = UnitState.GetItemInSlot(PairedSlot, NewGameState);
	if (PairedItem != none && PairedItem.GetMyTemplateName() == PairedTemplateName)
	{
		if (UnitState.RemoveItemFromInventory(PairedItem, NewGameState))
		{
			VisWeapon = XGWeapon(PairedItem.GetVisualizer());
			if (VisWeapon != none && VisWeapon.UnitPawn != none)
			{
				VisWeapon.UnitPawn.DetachItem(VisWeapon.GetEntity().Mesh);
			}
			NewGameState.RemoveStateObject(PairedItem.ObjectID);
		}
		else
		{
			`assert(false);
		}
	}
}

DefaultProperties
{
	//StowedLocation=eSlot_BeltHolster
	//eSlot_LowerBack
	//	Template.StowedLocation = eSlot_RearBackPack;
	//WeaponCat="rocket"
	//ItemCat="rocket"
	StowedLocation=eSlot_None
	bMergeAmmo=false

	OnEquippedFn = PairEquipped;
	OnUnequippedFn = PairUnEquipped;
}*/