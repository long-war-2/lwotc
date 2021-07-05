//---------------------------------------------------------------------------------------
//  FILE:    Utilities_LW
//  AUTHOR:  tracktwo (Pavonis Interactive)
//
//  PURPOSE: Miscellaneous helper routines.
//---------------------------------------------------------------------------------------

class Utilities_LW extends Object dependson(X2StrategyElement_DefaultAlienActivities) config(LW_Overhaul);

var config array<float> REFLEX_ACTION_CHANCE_YELLOW;
var config array<float> REFLEX_ACTION_CHANCE_GREEN;
var config float REFLEX_ACTION_CHANCE_REDUCTION;

var config array<float> LOW_INFILTRATION_MODIFIER_ON_REFLEX_ACTIONS;
var config array<float> HIGH_INFILTRATION_MODIFIER_ON_REFLEX_ACTIONS;

const CA_FAILURE_RISK_MARKER = "CovertActionRisk_Failure";

const OffensiveReflexAction = 'OffensiveReflexActionPoint_LW';
const DefensiveReflexAction = 'DefensiveReflexActionPoint_LW';
const NoReflexActionUnitValue = 'NoReflexAction_LW';

function static XComGameState_Unit CreateProxyUnit(XComGameState_Unit OriginalUnit, Name ProxyTemplateName, bool GiveAbilities, XComGameState NewGameState, optional Name Loadout)
{
    local XComGameState_Unit ProxyUnit;
	local X2CharacterTemplate ProxyTemplate;
    local X2CharacterTemplateManager TemplateManager;
	local XComGameState_LWToolboxOptions ToolboxOptions;
	local bool bEnabled;

    TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	ProxyTemplate = TemplateManager.FindCharacterTemplate(ProxyTemplateName);

	ProxyUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit'));
	NewGameState.AddStateObject(ProxyUnit);
	ProxyUnit.OnCreation(ProxyTemplate);
	ProxyUnit.SetTAppearance(OriginalUnit.kAppearance);
	ProxyUnit.SetUnitName(OriginalUnit.GetFirstName(), OriginalUnit.GetLastName(), OriginalUnit.GetNickName());
    if (Loadout != '')
        ProxyUnit.ApplyInventoryLoadout(NewGameState, Loadout);
    if (GiveAbilities)
        ProxyUnit.AWCAbilities = OriginalUnit.AWCAbilities;

    // Apply NCE if necessary
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();
	if (ToolboxOptions != none)
	{
		bEnabled = ToolboxOptions.bRandomizedInitialStatsEnabled;
	}
	if (bEnabled)
	{
		ApplyRandomizedInitialStatsToProxyUnit (bEnabled, ProxyUnit, OriginalUnit, NewGameState);
	}

	return ProxyUnit;
}

function static ApplyRandomizedInitialStatsToProxyUnit (bool bEnabled, XComGameState_Unit ProxyUnit, XComGameState_Unit OriginalUnit , XComGameState NewGameState)
{
	local XComGameState_Unit_LWRandomizedStats RandomizedStatsState, SearchRandomizedStats, ProxyRandomizedStatsState;
    local XComGameState_Unit UpdatedOriginalUnit;

	//first look in the supplied gamestate
	foreach NewGameState.IterateByClassType(class'XComGameState_Unit_LWRandomizedStats', SearchRandomizedStats)
	{
		if(SearchRandomizedStats.OwningObjectID == OriginalUnit.ObjectID)
		{
			RandomizedStatsState = SearchRandomizedStats;
			break;
		}
	}
	if(RandomizedStatsState == none)
	{
		//try and pull it from the history
		RandomizedStatsState = XComGameState_Unit_LWRandomizedStats(OriginalUnit.FindComponentObject(class'XComGameState_Unit_LWRandomizedStats'));
		if(RandomizedStatsState != none)
		{
			//if found in history, create an update copy for submission
			RandomizedStatsState = XComGameState_Unit_LWRandomizedStats(NewGameState.CreateStateObject(RandomizedStatsState.Class, RandomizedStatsState.ObjectID));
			NewGameState.AddStateObject(RandomizedStatsState);
		}
	}
	if(RandomizedStatsState == none)
	{
		//first time randomizing, create component gamestate and attach it
		RandomizedStatsState = XComGameState_Unit_LWRandomizedStats(NewGameState.CreateStateObject(class'XComGameState_Unit_LWRandomizedStats'));
		NewGameState.AddStateObject(RandomizedStatsState);

		UpdatedOriginalUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(OriginalUnit.ObjectID));
		if (UpdatedOriginalUnit == none)
		{
			UpdatedOriginalUnit = XComGameState_Unit(NewGameState.CreateStateObject(OriginalUnit.Class, OriginalUnit.ObjectID));
			NewGameState.AddStateObject (UpdatedOriginalUnit);
			UpdatedOriginalUnit.AddComponentObject(RandomizedStatsState);
		}
	}
	ProxyRandomizedStatsState = XComGameState_Unit_LWRandomizedStats(NewGameState.CreateStateObject(RandomizedStatsState.Class, RandomizedStatsState.ObjectID));
	NewGameState.AddStateObject (ProxyRandomizedStatsState);
	ProxyUnit.AddComponentObject (ProxyRandomizedStatsState);
	ProxyRandomizedStatsState.bInitialStatsApplied = false; // hardwire here to avoid the compatibility checking used for regular units
	ProxyRandomizedStatsState.ApplyRandomInitialStats(ProxyUnit, bEnabled);

	ProxyUnit.HighestHP = ProxyUnit.GetCurrentStat(eStat_HP);
}

function static string CurrentMissionType()
{
    local XComGameStateHistory History;
    local XComGameState_BattleData BattleData;
    local GeneratedMissionData GeneratedMission;
    local XComGameState_HeadquartersXCom XComHQ;

    History = `XCOMHISTORY;
    XComHQ = `XCOMHQ;

    BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    GeneratedMission = XComHQ.GetGeneratedMissionData(BattleData.m_iMissionID);
    if (GeneratedMission.Mission.sType == "")
    {
        // No mission type set. This is probably a tactical quicklaunch.
        return `TACTICALMISSIONMGR.arrMissions[BattleData.m_iMissionType].sType;
    }

    return GeneratedMission.Mission.sType;
}

// Is this an evac-only mission? All mission types except 'no evac' and 'escape' missions are.
function static bool IsEvacMission()
{
	return class'UIUtilities_LW'.default.EvacFlareEscapeMissions.Find(Name(class'Utilities_LW'.static.CurrentMissionType())) == -1 &&
			 class'UIUtilities_LW'.default.NoEvacMissions.Find(Name(class'Utilities_LW'.static.CurrentMissionType())) == -1;
}

function static string CurrentMissionFamily()
{
    local XComGameStateHistory History;
    local XComGameState_BattleData BattleData;
    local GeneratedMissionData GeneratedMission;
    local XComGameState_HeadquartersXCom XComHQ;

    History = `XCOMHISTORY;
    XComHQ = `XCOMHQ;

    BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    GeneratedMission = XComHQ.GetGeneratedMissionData(BattleData.m_iMissionID);
    if (GeneratedMission.Mission.MissionFamily == "")
    {
        // No mission type set. This is probably a tactical quicklaunch.
        return `TACTICALMISSIONMGR.arrMissions[BattleData.m_iMissionType].MissionFamily;
    }

    return GeneratedMission.Mission.MissionFamily;
}

function static bool GetMissionSettings(XComGameState_MissionSite MissionSite, out MissionSettings_LW Settings)
{
    local name MissionName;
	local string MissionFamilyName;
	local int idx;

    // Retreive the mission type and family names.
	MissionName = MissionSite.GeneratedMission.Mission.MissionName;
	MissionFamilyName = MissionSite.GeneratedMission.Mission.MissionFamily;
	if(MissionFamilyName == "")
		MissionFamilyName = MissionSite.GeneratedMission.Mission.sType;

    // First look for a settings match using the mission name.
    idx = class'X2StrategyElement_DefaultAlienActivities'.default.MissionSettings.Find('MissionOrFamilyName', MissionName);
	if(idx != -1)
    {
		Settings = class'X2StrategyElement_DefaultAlienActivities'.default.MissionSettings[idx];
        return true;
    }

    // Failing that, look for the family name.
	idx = class'X2StrategyElement_DefaultAlienActivities'.default.MissionSettings.Find('MissionOrFamilyName', name(MissionFamilyName));
	if(idx != -1)
	{
		Settings = class'X2StrategyElement_DefaultAlienActivities'.default.MissionSettings[idx];
        return true;
    }

    // Neither
    `redscreen("GetMissionSettings: No entry for " $ MissionName $ " / " $ MissionFamilyName);
    return false;
}


function static bool CurrentMissionIsRetaliation()
{
    local String MissionType;

    MissionType = CurrentMissionType();
    return (MissionType == "Terror_LW" || MissionType == "Invasion_LW" || MissionType=="Defend_LW");
}

// Delegates to `X2StrategyGameRulesetDataStructures.GetMaxSoldiersAllowedOnMission()`, but
// overrides the value for Shen's Last Gift mission if the number of soldiers is too high
static function int GetMaxSoldiersAllowedOnMission(optional XComGameState_MissionSite MissionSite)
{
	local int Max;

	Max = class'X2StrategyGameRulesetDataStructures'.static.GetMaxSoldiersAllowedOnMission(MissionSite);

	// Limit total squad size to 8 on "LastGift" DLC mission to prevent issues with XComSpawnPoint limitations
	if (MissionSite.GeneratedMission.Mission.MissionFamily == "LastGift")
	{
		Max = Min(8, Max);
	}

	return Max;
}

// Attempt to find a tile near the given tile to spawn a unit. Will attempt one within "FirstRange"
// radius first, and then "SecondRange" if it fails to locate one. Returns false if we can't find a tile.
function static bool GetSpawnTileNearTile(out TTile Tile, int FirstRange, int SecondRange)
{
    local XComWorldData WorldData;
    local array<TTile> TilePossibilities;

    WorldData = `XWORLD;
    // Try to find a valid tile near the randomly chosen tile, and spawn there.
    WorldData.GetSpawnTilePossibilities(Tile, FirstRange, FirstRange, FirstRange, TilePossibilities);
    class'Utilities_LW'.static.RemoveInvalidTiles(TilePossibilities);

    if (TilePossibilities.Length == 0)
    {
        // Try again, widening the search quite a bit
        WorldData.GetSpawnTilePossibilities(Tile, SecondRange, SecondRange, SecondRange, TilePossibilities);
        class'Utilities_LW'.static.RemoveInvalidTiles(TilePossibilities);
    }

    if (TilePossibilities.Length != 0)
    {
        Tile = TilePossibilities[`SYNC_RAND_STATIC(TilePossibilities.Length)];
        return true;
    }

    // Still no good!
    `LWDebug("*** Failed to find a valid position for unit");
    return false;
}


function static RemoveInvalidTiles(out array<TTile> Tiles)
{
    local XComWorldData WorldData;
    local TTile Tile;
    local int i;

    WorldData = `XWORLD;
    i = 0;
    while (i < Tiles.Length)
    {
        Tile = Tiles[i];
        if (WorldData.IsTileOutOfRange(Tile))
        {
            Tiles.Remove(i, 1);
        }
        else
        {
            ++i;
        }
    }
}

function static XComGameState_Player FindPlayer(ETeam team)
{
    local XComGameState_Player PlayerState;

    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Player', PlayerState)
    {
        if(PlayerState.GetTeam() == team)
        {
            return PlayerState;
        }
    }

    return none;
}

static function ApplyLoadout(XComGameState_Unit Unit, name UseLoadoutName, XComGameState ModifyGameState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local InventoryLoadout Loadout;
	local InventoryLoadoutItem LoadoutItem;
	local bool bFoundLoadout;
	local X2EquipmentTemplate EquipmentTemplate;
	local XComGameState_Item NewItem;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	foreach ItemTemplateManager.Loadouts(Loadout)
	{
		if (Loadout.LoadoutName == UseLoadoutName)
		{
			bFoundLoadout = true;
			break;
		}
	}

	if (bFoundLoadout)
	{
		foreach Loadout.Items(LoadoutItem)
		{
			EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(LoadoutItem.Item));
			if (EquipmentTemplate != none)
			{
				NewItem = EquipmentTemplate.CreateInstanceFromTemplate(ModifyGameState);

				//Transfer settings that were configured in the character pool with respect to the weapon. Should only be applied here
				//where we are handing out generic weapons.
				if(EquipmentTemplate.InventorySlot == eInvSlot_PrimaryWeapon || EquipmentTemplate.InventorySlot == eInvSlot_SecondaryWeapon)
				{
					NewItem.WeaponAppearance.iWeaponTint = Unit.kAppearance.iWeaponTint;
					NewItem.WeaponAppearance.nmWeaponPattern = Unit.kAppearance.nmWeaponPattern;
				}

				Unit.AddItemToInventory(NewItem, EquipmentTemplate.InventorySlot, ModifyGameState);
				ModifyGameState.AddStateObject(NewItem);
			}
		}
	}
}

static function GiveDefaultUtilityItemsToSoldier(XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local array<XComGameState_Item> CurrentInventory;
	local XComGameState_Item InventoryItem;
	local array<X2EquipmentTemplate> DefaultEquipment;
	local X2EquipmentTemplate EquipmentTemplate;
	local XComGameState_Item ItemState;
	local X2ItemTemplateManager ItemTemplateManager;
	local InventoryLoadout RequiredLoadout;
	local array<name> RequiredNames;
	local InventoryLoadoutItem LoadoutItem;
	local bool bRequired;
	local int idx;

	UnitState.bIgnoreItemEquipRestrictions = true;

	//first remove any existing utility slot items the unit has, that aren't on the RequiredLoadout
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	idx = ItemTemplateManager.Loadouts.Find('LoadoutName', UnitState.GetMyTemplate().RequiredLoadout);
	if(idx != -1)
	{
		RequiredLoadout = ItemTemplateManager.Loadouts[idx];
		foreach RequiredLoadout.Items(LoadoutItem)
		{
			RequiredNames.AddItem(LoadoutItem.Item);
		}
	}
	CurrentInventory = UnitState.GetAllInventoryItems(NewGameState);
	foreach CurrentInventory(InventoryItem)
	{
		bRequired = RequiredNames.Find(InventoryItem.GetMyTemplateName()) != -1;
		if(!bRequired && InventoryItem.InventorySlot == eInvSlot_Utility)
		{
			UnitState.RemoveItemFromInventory(InventoryItem, NewGameState);
		}
	}

	//equip the default loadout
	DefaultEquipment = GetCompleteDefaultLoadout(UnitState);
	foreach DefaultEquipment(EquipmentTemplate)
	{
		if(EquipmentTemplate.InventorySlot == eInvSlot_Utility)
		{
			ItemState = EquipmentTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(ItemState);
			UnitState.AddItemToInventory(ItemState, eInvSlot_Utility, NewGameState);
		}
	}
	UnitState.bIgnoreItemEquipRestrictions = false;
}

// combines rookie and squaddie loadouts so that things like kevlar armor and grenades are included
// but without the silliness of "only one item per slot type"
static function array<X2EquipmentTemplate> GetCompleteDefaultLoadout(XComGameState_Unit UnitState)
{
	local x2itemtemplatemanager itemtemplatemanager;
	local x2soldierclasstemplate soldierclasstemplate;
	local inventoryloadout loadout;
	local inventoryloadoutitem loadoutitem;
	local x2equipmenttemplate equipmenttemplate;
	local array<x2equipmenttemplate> completedefaultloadout;
	local int idx;

	itemtemplatemanager = class'x2itemtemplatemanager'.static.getitemtemplatemanager();

	// first grab squaddie loadout if possible
	soldierclasstemplate = UnitState.getsoldierclasstemplate();

	if(soldierclasstemplate != none && soldierclasstemplate.squaddieloadout != '')
	{
		idx = itemtemplatemanager.loadouts.find('loadoutname', soldierclasstemplate.squaddieloadout);
		if(idx != -1)
		{
			loadout = itemtemplatemanager.loadouts[idx];
			foreach loadout.items(loadoutitem)
			{
				equipmenttemplate = x2equipmenttemplate(itemtemplatemanager.finditemtemplate(loadoutitem.item));
				if(equipmenttemplate != none)
					completedefaultloadout.additem(equipmenttemplate);
			}
		}
		return completedefaultloadout;
	}

	// grab default loadout
	idx = itemtemplatemanager.loadouts.find('loadoutname', UnitState.getmytemplate().defaultloadout);
	if(idx != -1)
	{
		loadout = itemtemplatemanager.loadouts[idx];
		foreach loadout.items(loadoutitem)
		{
			equipmenttemplate = x2equipmenttemplate(itemtemplatemanager.finditemtemplate(loadoutitem.item));
			if(equipmenttemplate != none)
					completedefaultloadout.additem(equipmenttemplate);
		}
	}

	return completedefaultloadout;
}

// Create a soldier proxy for the given rebel, set them as on-mission, and give them a loadout. All done within the
// provided game state.
function static XComGameState_Unit CreateRebelSoldier(StateObjectReference RebelRef, StateObjectReference OutpostRef, XComGameState NewGameState, optional name Loadout)
{
    local XComGameState_LWOutpost Outpost;
    local XComGameState_Unit Proxy;
    local Name TemplateName;
	local int LaserChance, MagChance, CoilChance, iRand;
	local string LoadoutStr;

    Outpost = XComGameState_LWOutpost(`XCOMHISTORY.GetGameStateForObjectID(OutpostRef.ObjectID));
    switch(Outpost.GetRebelLevel(RebelRef))
    {
        case 0:
            TemplateName = 'RebelSoldierProxy';
            break;
        case 1:
            TemplateName = 'RebelSoldierProxyM2';
            break;
        case 2:
            TemplateName = 'RebelSoldierProxyM3';
            break;
        default:
            `Redscreen("CreateRebelSoldier: Unsupported rebel level " $ Outpost.GetRebelLevel(RebelRef));
            TemplateName = 'RebelSoldierProxy';
    }

    Proxy = CreateRebelProxy(RebelRef, OutpostRef, TemplateName, true, NewGameState);
    Proxy.SetSoldierClassTemplate('LWS_RebelSoldier');

	LaserChance = 0;
	MagChance = 0;
	CoilChance = 0;

    if (Loadout == '')
	{
        LoadoutStr = "RebelSoldier";
		if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('MagnetizedWeapons') && class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('AdvancedLasers'))
		{
			LaserChance += (20 + 10 * (Outpost.GetRebelLevel(RebelRef) + 1)); // 30/40/50
		}
		if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('GaussWeapons') && class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('AdvancedLasers'))
		{
			LaserChance += (20 + 10 * (Outpost.GetRebelLevel(RebelRef) + 1)); // 60/80/100
		}
		if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('Coilguns') && class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('GaussWeapons'))
		{
			if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('AdvancedLasers'))
			{
				LaserChance = 100;
			}
			MagChance += (20 + 10 * (Outpost.GetRebelLevel(RebelRef) + 1)); //30/40/50
		}
		if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('AdvancedCoilguns') && class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('GaussWeapons'))
		{
			MagChance += (20 + 10 * (Outpost.GetRebelLevel(RebelRef) + 1)); //60/80/100
		}
		if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('PlasmaRifle'))
		{
			if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('GaussWeapons'))
			{	
				MagChance = 100;
			}
			CoilChance += (20 + 10 * (Outpost.GetRebelLevel(RebelRef) + 1)); //30/40/50
		}
		// All plasma weapon related research
		if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('HeavyPlasma') && 
			class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('AlloyCannon') && 
			class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('PlasmaSniper') && 
			class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('AdvancedCoilguns'))
		{
			CoilChance += (20 + 10 * (Outpost.GetRebelLevel(RebelRef) + 1)); //60/80/100
		}
		
		if (`SYNC_RAND_STATIC(100) < CoilChance)
		{
			LoadoutStr $= "4";
		}
		else if (`SYNC_RAND_STATIC(100) < MagChance)
		{
			LoadoutStr $= "3";
		}
		else
		{
			if (`SYNC_RAND_STATIC(100) < LaserChance)
			{
				LoadoutStr $= "2";
			}
		}
		iRand = `SYNC_RAND_STATIC(100);
		if (iRand < 20)
		{
			LoadoutStr $= "SMG";
		}
		else if (iRand < 40)
		{
			LoadoutStr $= "Shotgun";
		}
			
		//`LWTRACE ("Rebel Loadout" @ LoadoutStr);
		Loadout = name(LoadOutStr);
	}
		
    ApplyLoadout(Proxy, Loadout, NewGameState);

    return Proxy;
}

// Create a rebel proxy for the given unit and set them on mission in the given
// game state. Does not copy over abilities, so this can be used to create
// civilian rebels in the required missions
// (retaliations/invasions/jailbreaks/defends/recruitraids) without redscreens
// regarding trying to add abilities without a primary weapon equipped.
function static XComGameState_Unit CreateRebelProxy(StateObjectReference RebelRef,
                                                    StateObjectReference OutpostRef,
                                                    Name TemplateName,
                                                    bool GiveAbilities,
                                                    XComGameState NewGameState)
{
    local XComGameStateHistory History;
    local XComGameState_LWOutpost Outpost;
    local XComGameState_Unit Unit;
	local XComGameState_Unit Proxy;

    History = `XCOMHISTORY;
    Outpost = XComGameState_LWOutpost(NewGameState.GetGameStateForObjectID(OutpostRef.ObjectID));
    if (Outpost == none)
    {
        Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutpostRef.ObjectID));
        NewGameState.AddStateObject(Outpost);
    }

    Unit = XComGameState_Unit(History.GetGameStateForObjectID(RebelRef.ObjectID));
	`LWTrace("Creating proxy for " $ Unit.GetFullName() $ " with template " $ TemplateName);
	
	Proxy = CreateProxyUnit(Unit, TemplateName, GiveAbilities, NewGameState);
	
    NewGameState.AddStateObject(Proxy);
    Outpost.SetRebelProxy(Unit.GetReference(), Proxy.GetReference());
    Outpost.SetRebelOnMission(Unit.GetReference());

    return Proxy;
}

// Create a soldier proxy for the given rebel, set them as on-mission, and give them a loadout. Must be called from within
// a tactical mission: this function will add them to the mission via a UnitAdded tactical change.
function static XComGameState_Unit AddRebelSoldierToMission(StateObjectReference RebelRef, StateObjectReference OutpostRef, out TTile Tile, optional name Loadout)
{
    local XComGameStateContext_TacticalGameRule NewGameStateContext;
    local XComGameState NewGameState;
    local XComGameState_Unit Proxy;
    local XComGameState_Player Player;
    local X2TacticalGameRuleset Rules;
    local XComGameStateHistory History;

    Rules = `TACTICALRULES;
    History = `XCOMHISTORY;
    NewGameStateContext = class'XComGameStateContext_TacticalGameRule'.static.BuildContextFromGameRule(eGameRule_UnitAdded);
    NewGameState = History.CreateNewGameState(true, NewGameStateContext);
    Proxy = CreateRebelSoldier(RebelRef, OutpostRef, NewGameState, Loadout);
    Proxy.SetVisibilityLocation(Tile);
    Player = FindPlayer(eTeam_XCom);
    Proxy.SetControllingPlayer(Player.GetReference());
    class'Helpers_LW'.static.AddUnitToXComGroup(NewGameState, Proxy, Player, History);

    Rules.InitializeUnitAbilities(NewGameState, Proxy);
    class'XGUnit'.static.CreateVisualizer(NewGameState, Proxy, Player, none);
    XComGameStateContext_TacticalGameRule(NewGameState.GetContext()).UnitRef = Proxy.GetReference();
	Rules.SubmitGameState(NewGameState);
    Proxy.OnBeginTacticalPlay(NewGameState);
    return Proxy;
}

// Create a (usually civilian) proxy for the given rebel, set them as
// on-mission. Must be called from within a tactical mission. This function
// will add them to the given game state (if provided), which should be within
// a XComGameStateContext_TacticalGameRule context for eGameRule_UnitAdded. If
// no game state is provided one is created and submitted internal to this
// function.
//
// May provide both a template to use for the proxy (generally 'Rebel' or
// 'FacelessRebelProxy'), and optionally can provide a team to assign them to.
function static XComGameState_Unit AddRebelToMission(StateObjectReference RebelRef,
                                                     StateObjectReference OutpostRef,
                                                     Name TemplateName,
                                                     out TTile Tile,
                                                     optional ETeam team = eTeam_XCom,
                                                     optional XComGameState NewGameState)
{
    local XComGameStateContext_TacticalGameRule NewGameStateContext;
    local XComGameState_Unit Proxy;
    local XComGameState_Player Player;
    local X2TacticalGameRuleset Rules;
    local XComGameStateHistory History;
    local bool SubmitGameState;

    Rules = `TACTICALRULES;
    History = `XCOMHISTORY;

    if (NewGameState == none)
    {
        NewGameStateContext = class'XComGameStateContext_TacticalGameRule'.static.BuildContextFromGameRule(eGameRule_UnitAdded);
        NewGameState = History.CreateNewGameState(true, NewGameStateContext);
        SubmitGameState = true;
    }

    // These rebels are civvies, but give them their abilities anyway (some are defensive).
    Proxy = CreateRebelProxy(RebelRef, OutpostRef, TemplateName, true, NewGameState);
    Proxy.SetVisibilityLocation(Tile);
    Player = FindPlayer(Team);
    Proxy.SetControllingPlayer(Player.GetReference());
    class'Helpers_LW'.static.AddUnitToXComGroup(NewGameState, Proxy, Player, History);

    if (Team == eTeam_Alien)
    {
        XGAIPlayer(XGBattle_SP(`BATTLE).GetAIPlayer()).AddNewSpawnAIData(NewGameState);
    }

    Rules.InitializeUnitAbilities(NewGameState, Proxy);
    class'XGUnit'.static.CreateVisualizer(NewGameState, Proxy, Player, none);
    XComGameStateContext_TacticalGameRule(NewGameState.GetContext()).UnitRef = Proxy.GetReference();

    if (SubmitGameState)
    {
	    Rules.SubmitGameState(NewGameState);
    }
    Proxy.OnBeginTacticalPlay(NewGameState);
    return Proxy;
}

/* Find the number of enemies that were on the original mission schedule.
 * If the mission was an RNF-only mission then it returns 8 + the region alert
 * the mission is in.
 */
 static function int GetNumEnemiesOnMission(XComGameState_MissionSite MissionState)
{
	local int OrigMissionAliens;
	local array<X2CharacterTemplate> UnitTemplatesThatWillSpawn;
	local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionAI;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	MissionState.GetShadowChamberMissionInfo(OrigMissionAliens, UnitTemplatesThatWillSpawn);

	// Handle missions built primarily around RNFs by granting a minimum alien count
	if (OrigMissionAliens <= 6)
	{
		Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(MissionState.Region.ObjectID));
		RegionAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);
		OrigMissionAliens = 7 + RegionAI.LocalAlertLevel;
	}

	return OrigMissionAliens;
}

static function bool KillXpIsCapped()
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_BattleData BattleState;
	local XComGameState_MissionSite MissionState;
	local int MissionKillXp, MaxKillXp;

	History = `XCOMHISTORY;

	BattleState = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if(BattleState == none)
		return false;

	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleState.m_iMissionID));
	if(MissionState == none)
		return false;

	MaxKillXp = GetNumEnemiesOnMission(MissionState);

	// Get the sum of xp kills so far this mission
	MissionKillXp = 0;
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if(UnitState.IsSoldier() && UnitState.IsPlayerControlled())
			MissionKillXp += int(GetUnitValue(UnitState, 'MissionKillXp'));
	}

	return MissionKillXp >= MaxKillXp;
}

static function bool DidCovertActionFail(XComGameState_CovertAction CAState)
{
	local CovertActionRisk Risk;

	foreach CAState.Risks(Risk)
	{
		if (InStr(Caps(Risk.RiskTemplateName), Caps(CA_FAILURE_RISK_MARKER)) == 0)
		{
			if (Risk.bOccurs)
			{
				// The failure risk has triggered, so yes, the covert action failed.
				return true;
			}
		}
	}

	// Check whether the covert action was ambushed, and if so, whether the mission
	// was successful.
	if (CAState.bAmbushed)
	{
		return class'XComGameState_CovertActionTracker'.static.CreateOrGetCovertActionTracker().LastAmbushMissionFailed;
	}

	return CAState.RewardsNotGivenOnCompletion;
}

// Finds out what the alert level of a given unit was before the current one.
// Mostly useful for finding out whether a unit entered red alert from green
// or yellow.
//
// Returns -1 if there is no prior alert level that's different from the unit's
// current one. Otherwise returns the previous alert level.
static function int GetPreviousAlertLevel(XComGameState_Unit UnitState)
{
	local XComGameStateHistory History;
	local float CurrentAlert;

	History = `XCOMHISTORY;
	CurrentAlert = UnitState.GetCurrentStat(eStat_AlertLevel);

	// Walk backwards through history for this unit until we find a state in which this unit wasn't in
	// its current alert to see what the previous alert level was.
	while (UnitState != none && UnitState.GetCurrentStat(eStat_AlertLevel) == CurrentAlert)
	{
		UnitState = XComGameState_Unit(History.GetPreviousGameStateForObject(UnitState));
	}

	return UnitState != none ? int(UnitState.GetCurrentStat(eStat_AlertLevel)) : -1;
}

static function float GetUnitValue(XComGameState_Unit UnitState, Name ValueName)
{
	local UnitValue Value;

	Value.fValue = 0.0;
	UnitState.GetUnitValue(ValueName, Value);
	return Value.fValue;
}

// Implements the rules for ability icon colors depending on action point cost,
// whether it's an objective ability, etc.
static function GetAbilityIconColor(
	bool IsObjective,
	bool IsFree,
	bool IsPsionic,
	bool IsTurnEnding,
	int ActionPointCost,
	out string BackgroundColor,
	out string ForegroundColor)
{
	if (IsObjective)
	{
		BackgroundColor = class'LWTemplateMods'.default.ICON_COLOR_OBJECTIVE; // orange
	}
	else if (IsPsionic)
	{
		if (ActionPointCost >= 2)
		{
			BackgroundColor = class'LWTemplateMods'.default.ICON_COLOR_PSIONIC_2;
		}
		else if (IsTurnEnding)
		{
			BackgroundColor = class'LWTemplateMods'.default.ICON_COLOR_PSIONIC_END;
		}
		else if (!IsFree)
		{
			BackgroundColor = class'LWTemplateMods'.default.ICON_COLOR_PSIONIC_1; // light lavender
		}
		else
		{
			BackgroundColor = class'LWTemplateMods'.default.ICON_COLOR_PSIONIC_FREE; // lavender-white
		}
	}
	else if (ActionPointCost >= 2)
	{
		BackgroundColor = class'LWTemplateMods'.default.ICON_COLOR_2; // yellow
	}
	// Takes precedence over free-action costs mostly for Overwatch
	// (which is a "free" action but ends the turn).
	else if (IsTurnEnding)
	{
		BackgroundColor = class'LWTemplateMods'.default.ICON_COLOR_END; // cyan
	}
	else if (IsFree)
	{
		BackgroundColor = class'LWTemplateMods'.default.ICON_COLOR_FREE; //green
	}
	else
	{
		BackgroundColor = class'LWTemplateMods'.default.ICON_COLOR_1; // white
	}
}

// Returns the force level maintained by LWOTC rather than the one from
// the alien HQ, since those two force levels may differ.
static function int GetLWForceLevel()
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	
	History = `XCOMHISTORY;

	// Get the first region since all regions have the same force level
	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		break;
	}

	return class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState).LocalForceLevel;
}

static function bool IsOnStrategyMap()
{
	// KDM : If you are on the strategy map return true; if you are in the Avenger return false.
	if (`HQGAME == none || `HQPRES == none || `HQPRES.StrategyMap2D == none)
	{
		return false;
	}
	else
	{
		return true;
	}
}
