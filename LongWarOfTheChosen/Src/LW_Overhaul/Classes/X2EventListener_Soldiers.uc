class X2EventListener_Soldiers extends X2EventListener;

var localized string OnLiaisonDuty;
var localized string OnInfiltrationMission;
var localized string UnitAlreadyInSquad;
var localized string UnitInSquad;
var localized string RankTooLow;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateUtilityItemListeners());
	Templates.AddItem(CreateStatusListeners());
	Templates.AddItem(CreateTacticalListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateUtilityItemListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'SoldierUtilityItems');
	Template.AddCHEvent('OverrideItemUnequipBehavior', OnOverrideItemUnequipBehavior, ELD_Immediate);
	Template.AddCHEvent('OverrideItemMinEquipped', OnOverrideItemMinEquipped, ELD_Immediate);
	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateStatusListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'SoldierStatus');
	Template.AddCHEvent('CustomizeStatusStringsSeparate', OnCustomizeStatusStringsSeparate, ELD_Immediate);
	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateTacticalListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'TacticalEvents');
	Template.AddCHEvent('OverrideAbilityIconColor', OnOverrideAbilityIconColor, ELD_Immediate);
	Template.RegisterInTactical = true;

	return Template;
}

// allows overriding of unequipping items, allowing even infinite utility slot items to be unequipped
static protected function EventListenerReturn OnOverrideItemUnequipBehavior(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple			OverrideTuple;
	local XComGameState_Item	ItemState;
	local X2EquipmentTemplate	EquipmentTemplate;

	`LWTRACE("OverrideItemUnequipBehavior : Starting listener.");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OverrideItemUnequipBehavior event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideItemUnequipBehavior : Parsed XComLWTuple.");

	ItemState = XComGameState_Item(EventSource);
	if(ItemState == none)
	{
		`REDSCREEN("OverrideItemUnequipBehavior event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideItemUnequipBehavior : EventSource valid.");

	if(OverrideTuple.Id != 'OverrideItemUnequipBehavior')
		return ELR_NoInterrupt;

	//check if item is a utility slot item
	EquipmentTemplate = X2EquipmentTemplate(ItemState.GetMyTemplate());
	if(EquipmentTemplate != none)
	{
		if(EquipmentTemplate.InventorySlot == eInvSlot_Utility)
		{
			OverrideTuple.Data[0].i = eCHSUB_AllowEmpty;  // item can be unequipped
		}
	}

	return ELR_NoInterrupt;
}

// Allows for completely empty utility slots for soldiers
static protected function EventListenerReturn OnOverrideItemMinEquipped(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple			OverrideTuple;
	local XComGameState_Unit	UnitState;
	local X2EquipmentTemplate	EquipmentTemplate;

	`LWTRACE("OverrideItemMinEquipped : Starting listener.");
	OverrideTuple = XComLWTuple(EventData);
	if (OverrideTuple == none)
	{
		`REDSCREEN("OverrideItemMinEquipped event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideItemMinEquipped : Parsed XComLWTuple.");

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
	{
		`REDSCREEN("OverrideItemMinEquipped event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideItemMinEquipped : EventSource valid.");

	if (OverrideTuple.Id != 'OverrideItemMinEquipped')
	{
		return ELR_NoInterrupt;
	}

	switch (OverrideTuple.Data[1].i)
	{
		case eInvSlot_Utility:
		case eInvSlot_GrenadePocket:
			OverrideTuple.Data[0].i = 0;
			break;
			
		default:
			break;
	}

	return ELR_NoInterrupt;
}

// Sets the status string for liaisons and soldiers on missions.
static protected function EventListenerReturn OnCustomizeStatusStringsSeparate(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Unit		UnitState;
    local XComGameState_WorldRegion	WorldRegion;
	local XComGameState_LWPersistentSquad Squad;
	local XComGameState_LWSquadManager SquadMgr;

	OverrideTuple = XComLWTuple(EventData);
	if (OverrideTuple == none)
	{
		`REDSCREEN("CustomizeStatusStringsSeparate event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
	{
		`REDSCREEN("CustomizeStatusStringsSeparate event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}

	if (OverrideTuple.Id != 'CustomizeStatusStringsSeparate')
	{
		return ELR_NoInterrupt;
	}

	
	if (class'LWDLCHelpers'.static.IsUnitOnMission(UnitState))
	{
		// Check if the unit is a liaison or a soldier on a mission.
		if (`LWOUTPOSTMGR.IsUnitAHavenLiaison(UnitState.GetReference()))
		{
			WorldRegion = `LWOUTPOSTMGR.GetRegionForLiaison(UnitState.GetReference());
			SetTupleData(OverrideTuple, default.OnLiaisonDuty @ "-" @ WorldRegion.GetDisplayName(), "", 0);
		}
		else if (`LWSQUADMGR.UnitIsOnMission(UnitState.GetReference()))
		{
			SetTupleData(OverrideTuple, default.OnInfiltrationMission, "", 0);
		}
	}
	else if (GetScreenOrChild('UIPersonnel_SquadBarracks') == none)
	{
		SquadMgr = `LWSQUADMGR;
		if (`XCOMHQ.IsUnitInSquad(UnitState.GetReference()) && GetScreenOrChild('UISquadSelect') != none)
		{
			SetTupleData(OverrideTuple, class'UIUtilities_Strategy'.default.m_strOnMissionStatus, "", 0);
			// TextState = eUIState_Highlight;
		}
		else if (SquadMgr != none && SquadMgr.UnitIsInAnySquad(UnitState.GetReference(), Squad))
		{
			if (SquadMgr.LaunchingMissionSquad.ObjectID != Squad.ObjectID)
			{
				if (UnitState.GetStatus() != eStatus_Healing && UnitState.GetStatus() != eStatus_Training)
				{
					if (GetScreenOrChild('UISquadSelect') != none)
					{
						SetTupleData(OverrideTuple, default.UnitAlreadyInSquad, "", 0);
						// TextState = eUIState_Warning;
					}
					else if (GetScreenOrChild('UIPersonnel_Liaison') != none)
					{
						SetTupleData(OverrideTuple, default.UnitInSquad, "", 0);
						// TextState = eUIState_Warning;
					}
				}
			}
		}
		else if (UnitState.GetRank() < class'XComGameState_LWOutpost'.default.REQUIRED_RANK_FOR_LIAISON_DUTY)
		{
			if (GetScreenOrChild('UIPersonnel_Liaison') != none)
			{
				SetTupleData(OverrideTuple, default.RankTooLow, "", 0);
				// TextState = eUIState_Bad;
			}
		}
	}

	return ELR_NoInterrupt;
}

static private function UIScreen GetScreenOrChild(name ScreenType)
{
	local UIScreenStack ScreenStack;
	local int Index;
	ScreenStack = `SCREENSTACK;
	for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(ScreenStack.Screens[Index].IsA(ScreenType))
			return ScreenStack.Screens[Index];
	}
	return none;
}

static private function SetTupleData(XComLWTuple Tuple, string Status, string TimeLabel, int TimeValue)
{
	Tuple.Data[0].b = true;
	Tuple.Data[1].s = Status;
	Tuple.Data[2].s = TimeLabel;
	Tuple.Data[3].i = TimeValue;
}

// This takes on a bunch of exceptions to color ability icons
static function EventListenerReturn OnOverrideAbilityIconColor(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local Name						AbilityName;
	local XComGameState_Ability		AbilityState;
	local X2AbilityTemplate			AbilityTemplate;
	local XComGameState_Unit		UnitState;
	local string					IconColor;
	local XComGameState_Item		WeaponState;
	local array<X2WeaponUpgradeTemplate> WeaponUpgrades;
	local int k, k2;
	local bool Changed;
	local UnitValue FreeReloadValue;
	local X2AbilityCost_ActionPoints		ActionPoints;

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OnOverrideAbilityIconColor event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	AbilityState = XComGameState_Ability(EventSource);
	if (AbilityState == none)
	{
		`LWTRACE ("No ability state fed to OnOverrideAbilityIconColor");
		return ELR_NoInterrupt;
	}

	// Easy handling of abilities that target objectives
	if (OverrideTuple.Data[0].b && class'LWTemplateMods'.default.USE_ACTION_ICON_COLORS)
	{
		OverrideTuple.Data[1].s = class'LWTemplateMods'.default.ICON_COLOR_OBJECTIVE;
		return ELR_NoInterrupt;
	}

	// Drop out if the existing icon color is not "Variable"
	if (OverrideTuple.Data[1].s != "Variable")
	{
		return ELR_NoInterrupt;
	}

	// Now deal with the "Variable" ability icons
	Changed = false;
	AbilityTemplate = AbilityState.GetMyTemplate();
	AbilityName = AbilityState.GetMyTemplateName();
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	WeaponState = AbilityState.GetSourceWeapon();

	if (UnitState == none)
	{
		`LWTRACE ("No UnitState found for OnOverrideAbilityIconColor");
		return ELR_NoInterrupt;
	}

	// Salvo, Quickburn, Holotarget
	for (k = 0; k < AbilityTemplate.AbilityCosts.Length; k++)
	{
		ActionPoints = X2AbilityCost_ActionPoints(AbilityTemplate.AbilityCosts[k]);
		if (ActionPoints != none)
		{
			if (ActionPoints.bConsumeAllPoints)
			{
				for (k2 = 0; k2 < ActionPoints.DoNotConsumeAllSoldierAbilities.Length; k2++)
				{
					if (UnitState.HasSoldierAbility(ActionPoints.DoNotConsumeAllSoldierAbilities[k2], true))
					{
						IconColor = class'LWTemplateMods'.default.ICON_COLOR_1;
						Changed = true;
						break;
					}
				}
			}
			if (ActionPoints.bAddWeaponTypicalCost)
			{
				if (X2WeaponTemplate(WeaponState.GetMyTemplate()).iTypicalActionCost >= 2)
				{
					IconColor = class'LWTemplateMods'.default.ICON_COLOR_2; // yellow
					Changed = true;
					break;
				}
				else
				{
					if (ActionPoints.bConsumeAllPoints)
					{
						IconColor = class'LWTemplateMods'.default.ICON_COLOR_END; // cyan
						Changed = true;
						break;
					}
					else
					{
						IconColor = class'LWTemplateMods'.default.ICON_COLOR_1;
						Changed = true;
						break;
					}
				}
			}
		}
	}

	switch (AbilityName)
	{
		case 'ThrowGrenade':
			if (UnitState.AffectedByEffectNames.Find('RapidDeploymentEffect') != -1)
			{
				if (class'X2Effect_RapidDeployment'.default.VALID_GRENADE_TYPES.Find(WeaponState.GetMyTemplateName()) != -1)
				{
					IconColor = class'LWTemplateMods'.default.ICON_COLOR_FREE;
					Changed = true;
				}
			}
			break;
		case 'LaunchGrenade':
			if (UnitState.AffectedByEffectNames.Find('RapidDeploymentEffect') != -1)
			{
				if (class'X2Effect_RapidDeployment'.default.VALID_GRENADE_TYPES.Find(WeaponState.GetLoadedAmmoTemplate(AbilityState).DataName) != -1)
				{
					IconColor = class'LWTemplateMods'.default.ICON_COLOR_FREE;
					Changed = true;
				}
			}
			break;
		case 'LWFlamethrower':
		case 'Roust':
		case 'Firestorm':
			if (UnitState.AffectedByEffectNames.Find('QuickburnEffect') != -1)
			{
					IconColor = class'LWTemplateMods'.default.ICON_COLOR_FREE;
					Changed = true;
			}
			break;
		case 'Reload':
			WeaponUpgrades = WeaponState.GetMyWeaponUpgradeTemplates();
			for (k = 0; k < WeaponUpgrades.Length; k++)
			{
				if (WeaponUpgrades[k].NumFreeReloads > 0)
				{
					UnitState.GetUnitValue ('FreeReload', FreeReloadValue);
					if (FreeReloadValue.fValue < WeaponUpgrades[k].NumFreeReloads)
					{
						IconColor = class'LWTemplateMods'.default.ICON_COLOR_FREE;
						Changed = true;
					}
					break;
				}
			}
			break;
		case 'PistolStandardShot':
		case 'ClutchShot':
			if (UnitState.HasSoldierAbility('Quickdraw'))
			{
				IconColor = class'LWTemplateMods'.default.ICON_COLOR_1;
				Changed = true;
			}
			break;
		case 'PlaceEvacZone':
		case 'PlaceDelayedEvacZone':
			`LWTRACE ("Attempting to change EVAC color");
			class'XComGameState_BattleData'.static.HighlightObjectiveAbility(AbilityName, true);
			return ELR_NoInterrupt;
			break;
		default: break;
	}

	if (Changed)
	{
		OverrideTuple.Data[1].s = IconColor;
	}
	else
	{
		OverrideTuple.Data[1].s = class'LWTemplateMods'.static.GetIconColorByActionPoints(AbilityTemplate);
	}

	return ELR_NoInterrupt;
}