//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWListenerManager.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This singleton object manages general persistent listeners that should live for both strategy and tactical play
//---------------------------------------------------------------------------------------
class XComGameState_LWListenerManager extends XComGameState_BaseObject config(LW_Overhaul) dependson(XComGameState_LWPersistentSquad);

var config int DEFAULT_LISTENER_PRIORITY;

var localized string ResistanceHQBodyText;


var config bool TIERED_RESPEC_TIMES;

var config array<int>INITIAL_PSI_TRAINING;

static function XComGameState_LWListenerManager GetListenerManager(optional bool AllowNULL = false)
{
	return XComGameState_LWListenerManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWListenerManager', AllowNULL));
}

static function CreateListenerManager(optional XComGameState StartState)
{
	local XComGameState_LWListenerManager ListenerMgr;
	local XComGameState NewGameState;
	`Log("Creating LW Listener Manager --------------------------------");

	//first check that there isn't already a singleton instance of the listener manager
	if(GetListenerManager(true) != none)
	{
		`Log("LW listener manager already exists");
		return;
	}

	if(StartState != none)
	{
		ListenerMgr = XComGameState_LWListenerManager(StartState.CreateNewStateObject(class'XComGameState_LWListenerManager'));
	}
	else
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating LW Listener Manager Singleton");
		ListenerMgr = XComGameState_LWListenerManager(NewGameState.CreateNewStateObject(class'XComGameState_LWListenerManager'));
	}

	ListenerMgr.InitListeners();
}

static function RefreshListeners()
{
	local XComGameState_LWListenerManager ListenerMgr;
	local XComGameState_LWSquadManager    SquadMgr;
	`Log("Refreshing listeners --------------------------------");

	ListenerMgr = GetListenerManager(true);
	if(ListenerMgr == none)
		CreateListenerManager();
	else
		ListenerMgr.InitListeners();
		
	SquadMgr = class'XComGameState_LWSquadManager'.static.GetSquadManager(true);
	if (SquadMgr != none)
		SquadMgr.InitSquadManagerListeners();
}

function InitListeners()
{
	local X2EventManager EventMgr;
	local Object ThisObj;

	`LWTrace ("Init Listeners Firing!");

	ThisObj = self;
	EventMgr = `XEVENTMGR;
	EventMgr.UnregisterFromAllEvents(ThisObj); // clear all old listeners to clear out old stuff before re-registering
	
	// WOTC TODO: Requires change to CHL XComGameState_Unit
	EventMgr.RegisterForEvent(ThisObj, 'ShouldShowPromoteIcon', OnCheckForPsiPromotion, ELD_Immediate,,,true);
	
	// Mission summary civilian counts
	// WOTC TODO: Requires change to CHL Helpers and UIMissionSummary
	EventMgr.RegisterForEvent(ThisObj, 'GetNumCiviliansKilled', OnNumCiviliansKilled, ELD_Immediate,,,true);

	// WOTC TODO: Don't think this is needed as the game seems to work fine without it.
	//Special First Mission Icon handling -- only for replacing the Resistance HQ icon functionality
	// EventMgr.RegisterForEvent(ThisObj, 'OnInsertFirstMissionIcon', OnInsertFirstMissionIcon, ELD_Immediate,,,true);

	// Recalculate respec time so it goes up with soldier rank
	EventMgr.RegisterForEvent(ThisObj, 'SoldierRespecced', OnSoldierRespecced,,,,true);

    // VIP Recovery screen
    EventMgr.RegisterForEvent(ThisObj, 'GetRewardVIPStatus', OnGetRewardVIPStatus, ELD_Immediate,,, true);

    // Version check
    EventMgr.RegisterForEvent(ThisObj, 'GetLWVersion', OnGetLWVersion, ELD_Immediate,,, true);

    // Async rebel photographs
    EventMgr.RegisterForEvent(ThisObj, 'RefreshCrewPhotographs', OnRefreshCrewPhotographs, ELD_Immediate,,, true);

    // Override UFO interception time (since base-game uses Calendar, which no longer works for us)
    EventMgr.RegisterForEvent(ThisObj, 'PostUFOSetInterceptionTime', OnUFOSetInfiltrationTime, ELD_Immediate,,, true);

	// listeners for weapon mod stripping
	EventMgr.RegisterForEvent(ThisObj, 'OnCheckBuildItemsNavHelp', AddSquadSelectStripWeaponsButton, ELD_Immediate);
	EventMgr.RegisterForEvent(ThisObj, 'ArmoryLoadout_PostUpdateNavHelp', AddArmoryStripWeaponsButton, ELD_Immediate);

	/* WOTC TODO: Might be a while before these events are available
	// initial psi training time override (this DOES require a change to the highlander)
	EventMgr.RegisterForEvent(ThisObj, 'PsiTrainingBegun', OnOverrideInitialPsiTrainingTime, ELD_Immediate,,, true);

	//Help for some busted objective triggers (may not be needed?)
	EventMgr.RegisterForEvent(ThisObj, 'OnGeoscapeEntry', OnGeoscapeEntry, ELD_Immediate,,, true);
	*/
}

function EventListenerReturn OnCheckForPsiPromotion(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Unit UnitState;

	Tuple = XComLWTuple(EventData);
	if(Tuple == none)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(EventSource);
	if(UnitState == none)
	{
		`REDSCREEN("OnCheckForPsiPromotion event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	if (Tuple.Data[0].kind != XComLWTVBool)
		return ELR_NoInterrupt;

	if (UnitState.IsPsiOperative())
	{
		if (class'Utilities_PP_LW'.static.CanRankUpPsiSoldier(UnitState))
		{
			Tuple.Data[0].B = true;
		}
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn OnInsertFirstMissionIcon(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local UIStrategyMap_MissionIcon MissionIcon;
	local UIStrategyMap StrategyMap;

	Tuple = XComLWTuple(EventData);
	if(Tuple == none)
		return ELR_NoInterrupt;

	StrategyMap = UIStrategyMap(EventSource);
	if(StrategyMap == none)
	{
		`REDSCREEN("OnInsertFirstMissionIcon event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	MissionIcon = StrategyMap.MissionItemUI.MissionIcons[0];
	MissionIcon.LoadIcon("img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_ResHQ");
	MissionIcon.OnClickedDelegate = SelectOutpostManager;
	MissionIcon.HideTooltip();
	MissionIcon.SetMissionIconTooltip(StrategyMap.m_ResHQLabel, ResistanceHQBodyText);

	MissionIcon.Show();

	Tuple.Data[0].b = true; // skip to the next mission icon

	return ELR_NoInterrupt;
}

function SelectOutpostManager()
{
    //local XComGameState_LWOutpostManager OutpostMgr;
	local UIResistanceManagement_LW TempScreen;
    local XComHQPresentationLayer HQPres;

    HQPres = `HQPRES;

    //OutpostMgr = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	//OutpostMgr.GoToResistanceManagement();

    if(HQPres.ScreenStack.IsNotInStack(class'UIResistanceManagement_LW'))
    {
        TempScreen = HQPres.Spawn(class'UIResistanceManagement_LW', HQPres);
		TempScreen.EnableCameraPan = false;
        HQPres.ScreenStack.Push(TempScreen, HQPres.Get3DMovie());
    }
}

function EventListenerReturn OnNumCiviliansKilled(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local XGBattle_SP Battle;
    local XComGameState_BattleData BattleData;
    local array<XComGameState_Unit> arrUnits;
    local bool RequireEvac;
    local bool PostMission;
	local bool RequireTriadObjective;
    local int i, Total, Killed;
	local array<Name> TemplateFilter;

    Tuple = XComLWTuple(EventData);
    if (Tuple == none || Tuple.Id != 'GetNumCiviliansKilled' || Tuple.Data.Length > 1)
    {
        return ELR_NoInterrupt;
    }

    PostMission = Tuple.Data[0].b;

    switch(class'Utilities_LW'.static.CurrentMissionType())
    {
        case "Terror_LW":
            // For terror, all neutral units are interesting, and we save anyone
            // left on the map if we win the triad objective (= sweep). Rebels left on
			// the map if sweep wasn't completed are lost.
			RequireTriadObjective = true;
            break;
        case "Defend_LW":
            // For defend, all neutral units are interesting, but we don't count
            // anyone left on the map, regardless of win.
            RequireEvac = true;
            break;
        case "Invasion_LW":
            // For invasion, we only want to consider civilians with the 'Rebel' or
            // 'FacelessRebelProxy' templates.
			TemplateFilter.AddItem('Rebel');
            break;
        case "Jailbreak_LW":
            // For jailbreak we only consider evac'd units as 'saved' regardless of whether
            // we have won or not. We also only consider units with the template 'Rebel' or
			// 'Soldier_VIP', and don't count any regular civvies in the mission.
            RequireEvac = true;
            TemplateFilter.AddItem('Rebel');
			TemplateFilter.AddItem('Soldier_VIP');
            break;
        default:
            return ELR_NoInterrupt;
    }

    Battle = XGBattle_SP(`BATTLE);
    BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

    if (Battle != None)
    {
        Battle.GetCivilianPlayer().GetOriginalUnits(arrUnits);
    }

    for (i = 0; i < arrUnits.Length; ++i)
    {
        if (arrUnits[i].GetMyTemplateName() == 'FacelessRebelProxy')
        {
            // A faceless rebel proxy: we only want to count this guy if it isn't removed from play: they can't
            // be evac'd so if they're removed they must have been revealed so we don't want to count them.
            if (arrUnits[i].bRemovedFromPlay)
            {
                arrUnits.Remove(i, 1);
                --i;
                continue;
            }
        }
        else if (TemplateFilter.Length > 0 && TemplateFilter.Find(arrUnits[i].GetMyTemplateName()) == -1)
        {
            arrUnits.Remove(i, 1);
            --i;
            continue;
        }
    }

    // Compute the number killed
    Total = arrUnits.Length;

    for (i = 0; i < Total; ++i)
    {
        if (arrUnits[i].IsDead())
        {
            ++Killed;
        }
        else if (PostMission && !arrUnits[i].bRemovedFromPlay)
        {
			// If we require the triad objective, units left behind on the map
			// are lost unless it's completed.
			if (RequireTriadObjective && !BattleData.AllTriadObjectivesCompleted())
			{
				++Killed;
			}
            // If we lose or require evac, anyone left on map is killed.
            else if (!BattleData.bLocalPlayerWon || RequireEvac)
			{
                ++Killed;
			}
        }
    }

    Value.Kind = XComLWTVInt;
    Value.i = Killed;
    Tuple.Data.AddItem(Value);

    Value.i = Total;
    Tuple.Data.AddItem(Value);
    return ELR_NoInterrupt;
}

function EventListenerReturn OnSoldierRespecced (Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple OverrideTuple;

	//`LOG ("Firing OnSoldierRespecced");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("On Soldier Respecced event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverrideTuple : Parsed XComLWTuple.");

	if(OverrideTuple.Id != 'OverrideRespecTimes')
		return ELR_NoInterrupt;

	//`LOG ("Point 2");

	if (default.TIERED_RESPEC_TIMES)
	{
		//Respec days = rank * difficulty setting
		OverrideTuple.Data[1].i = OverrideTuple.Data[0].i * class'XComGameState_HeadquartersXCom'.default.XComHeadquarters_DefaultRespecSoldierDays[`STRATEGYDIFFICULTYSETTING] * 24;
		//`LOG ("Point 3" @ OverrideTuple.Data[1].i @ OverrideTuple.Data[0].i);
	}

	return ELR_NoInterrupt;

}

function EventListenerReturn OnGetRewardVIPStatus(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local XComGameState_Unit Unit;
    local XComGameState_MissionSite MissionSite;

    Tuple = XComLWTuple(EventData);
    // Not a tuple or already filled out?
    if (Tuple == none || Tuple.Data.Length != 1 || Tuple.Data[0].Kind != XComLWTVObject)
    {
        return ELR_NoInterrupt;
    }

    // Make sure we have a unit
    Unit = XComGameState_Unit(Tuple.Data[0].o);
    if (Unit == none)
    {
        return ELR_NoInterrupt;
    }

    // Make sure we have a mission site
    MissionSite = XComGameState_MissionSite(EventSource);
    if (MissionSite == none)
    {
        return ELR_NoInterrupt;
    }

    if (MissionSite.GeneratedMission.Mission.sType == "Jailbreak_LW")
    {
        // Jailbreak mission: Only evac'd units are considered rescued.
        // (But dead ones are still dead!)
        Value.Kind = XComLWTVInt;
        if (Unit.IsDead())
        {
            Value.i = eVIPStatus_Killed;
        }
        else
        {
            Value.i = Unit.bRemovedFromPlay ? eVIPStatus_Recovered : eVIPStatus_Lost;
        }
        Tuple.Data.AddItem(Value);
    }

    return ELR_NoInterrupt;
}

// Allow mods to query the LW version number. Trigger the 'GetLWVersion' event with an empty tuple as the eventdata and it will
// return a 3-tuple of ints with Data[0]=Major, Data[1]=Minor, and Data[2]=Build.
function EventListenerReturn OnGetLWVersion(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local int Major, Minor, Build;
    Tuple = XComLWTuple(EventData);
    if (Tuple == none)
    {
        return ELR_NoInterrupt;
    }

    class'LWVersion'.static.GetVersionNumber(Major, Minor, Build);
    Tuple.Data.Add(3);
    Tuple.Data[0].Kind = XComLWTVInt;
    Tuple.Data[0].i = Major;
    Tuple.Data[1].Kind = XComLWTVInt;
    Tuple.Data[1].i = Minor;
    Tuple.Data[2].Kind = XComLWTVInt;
    Tuple.Data[2].i = Build;

    return ELR_NoInterrupt;
}

// It's school picture day. Add all the rebels.
function EventListenerReturn OnRefreshCrewPhotographs(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local XComGameState_LWOutpost Outpost;
    local XComGameState_WorldRegion Region;
    local int i;

    Tuple = XComLWTuple(EventData);
    if (Tuple == none)
    {
        return ELR_NoInterrupt;
    }

    Value.Kind = XComLWTVInt;
    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
    {
        Region = Outpost.GetWorldRegionForOutPost();
        if (!Region.HaveMadeContact())
            continue;

        for (i = 0; i < Outpost.Rebels.Length; ++i)
        {
            Value.i = Outpost.Rebels[i].Unit.ObjectID;
            Tuple.Data.AddItem(Value);
        }
    }
	*/
    return ELR_NoInterrupt;
}

// Override how the UFO interception works, since we don't use the calendar
function EventListenerReturn OnUFOSetInfiltrationTime(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComGameState_UFO UFO;
	local int HoursUntilIntercept;

    UFO = XComGameState_UFO(EventData);
    if (UFO == none)
    {
        return ELR_NoInterrupt;
    }

	if (UFO.bDoesInterceptionSucceed)
	{
		UFO.InterceptionTime == UFO.GetCurrentTime();

		HoursUntilIntercept = (UFO.MinNonInterceptDays * 24) + `SYNC_RAND((UFO.MaxNonInterceptDays * 24) - (UFO.MinNonInterceptDays * 24) + 1);
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(UFO.InterceptionTime, HoursUntilIntercept);
	}

    return ELR_NoInterrupt;
}

//listener that adds an extra NavHelp button
function EventListenerReturn AddSquadSelectStripWeaponsButton (Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.AddCenterHelp(class'UIUtilities_LW'.default.m_strStripWeaponUpgrades, "", OnStripUpgrades, false, class'UIUtilities_LW'.default.m_strTooltipStripWeapons);
	
	return ELR_NoInterrupt;
}

function EventListenerReturn AddArmoryStripWeaponsButton (Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	// Add a button to make upgrades available.
	NavHelp.AddLeftHelp(class'UIUtilities_LW'.default.m_strStripWeaponUpgrades, "", OnStripUpgrades, false, class'UIUtilities_LW'.default.m_strTooltipStripWeapons);
	// Add a button to strip just the upgrades from this weapon.
	NavHelp.AddLeftHelp(Caps(class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradesButton), "", OnStripWeaponClicked, false, class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradesTooltip);
	
	return ELR_NoInterrupt;
}

simulated function OnStripWeaponClicked()
{
	local XComPresentationLayerBase Pres;
	local TDialogueBoxData DialogData;

	Pres = `PRESBASE;
	Pres.PlayUISound(eSUISound_MenuSelect);

	DialogData.eType = eDialog_Warning;
	DialogData.strTitle = class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradeDialogueTitle;
	DialogData.strText = class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradeDialogueText;
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNO;
	DialogData.fnCallback = ConfirmStripSingleWeaponUpgradesCallback;
	Pres.UIRaiseDialog(DialogData);
}

simulated function ConfirmStripSingleWeaponUpgradesCallback(Name eAction)
{
	local XComGameState_Item ItemState;
	local UIArmory_Loadout LoadoutScreen;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit Soldier;
	local XComGameState UpdateState;

	if (eAction == 'eUIAction_Accept')
	{
		LoadoutScreen = UIArmory_Loadout(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory_Loadout'));
		if (LoadoutScreen != none)
		{
			Soldier = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LoadoutScreen.GetUnitRef().ObjectID));
			ItemState = Soldier.GetItemInSlot(eInvSlot_PrimaryWeapon);
			if (ItemState != none && ItemState.HasBeenModified())
			{
				UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Strip Weapon Upgrades");
				XComHQ = `XCOMHQ;
				XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
				UpdateState.AddStateObject(XComHQ);
				StripWeaponUpgradesFromItem(ItemState, XComHQ, UpdateState);
				`GAMERULES.SubmitGameState(UpdateState);
				LoadoutScreen.UpdateData(true);
			}
		}
	}
}

simulated function OnStripUpgrades()
{
	local TDialogueBoxData DialogData;
	DialogData.eType = eDialog_Normal;
	DialogData.strTitle = class'UIUtilities_LW'.default.m_strStripWeaponUpgradesConfirm;
	DialogData.strText = class'UIUtilities_LW'.default.m_strStripWeaponUpgradesConfirmDesc;
	DialogData.fnCallback = OnStripUpgradesDialogCallback;
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	DialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
	`HQPRES.UIRaiseDialog(DialogData);
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

simulated function OnStripUpgradesDialogCallback(Name eAction)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState UpdateState;
	local array<StateObjectReference> Inventory;
	local array<XComGameState_Unit> Soldiers;
	local int idx;
	local StateObjectReference ItemRef;
	local XComGameState_Item ItemState;
	local X2EquipmentTemplate EquipmentTemplate;
	local TWeaponUpgradeAvailabilityData WeaponUpgradeAvailabilityData;
	local XComGameState_Unit OwningUnitState;
	local UIArmory_Loadout LoadoutScreen;

	LoadoutScreen = UIArmory_Loadout(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory_Loadout'));

	if (eAction == 'eUIAction_Accept')
	{
		History = `XCOMHISTORY;
		XComHQ =`XCOMHQ;

		//strip upgrades from weapons that aren't equipped to any soldier. We need to fetch, strip, and put the items back in the HQ inventory,
		// which will involve de-stacking and re-stacking items, so do each one in an individual gamestate submission.
		Inventory = class'UIUtilities_Strategy'.static.GetXComHQ().Inventory;
		foreach Inventory(ItemRef)
		{
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
			if (ItemState != none)
			{
				OwningUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.OwnerStateObject.ObjectID));
				if (OwningUnitState == none) // only if the item isn't owned by a unit
				{
					EquipmentTemplate = X2EquipmentTemplate(ItemState.GetMyTemplate());
					if(EquipmentTemplate != none && EquipmentTemplate.InventorySlot == eInvSlot_PrimaryWeapon && ItemState.HasBeenModified()) // primary weapon that has been modified
					{
						UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Strip Unequipped Upgrades");
						XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
						UpdateState.AddStateObject(XComHQ);

						// If this is the only instance of this weapon in the inventory we'll just get back a non-updated state.
						// That's ok, StripWeaponUpgradesFromItem will create/add it if it's not already in the update state. If it
						// is, we'll use that one directly to do the stripping.
						XComHQ.GetItemFromInventory(UpdateState, ItemState.GetReference(), ItemState);
						StripWeaponUpgradesFromItem(ItemState, XComHQ, UpdateState);
						ItemState = XComGameState_Item(UpdateState.GetGameStateForObjectID(ItemState.ObjectID));
						XComHQ.PutItemInInventory(UpdateState, ItemState);
						`GAMERULES.SubmitGameState(UpdateState);
					}
				}
			}
		}

		// strip upgrades from weapons on soldiers that aren't active. These can all be batched in one state because
		// soldiers maintain their equipped weapon, so there is no stacking of weapons to consider.
		UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Strip Unequipped Upgrades");
		XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		UpdateState.AddStateObject(XComHQ);
		Soldiers = GetSoldiersToStrip(XComHQ, UpdateState);
		for (idx = 0; idx < Soldiers.Length; idx++)
		{
			class'UIUtilities_Strategy'.static.GetWeaponUpgradeAvailability(Soldiers[idx], WeaponUpgradeAvailabilityData);
			if (!WeaponUpgradeAvailabilityData.bCanWeaponBeUpgraded)
			{
				continue;
			}

			ItemState = Soldiers[idx].GetItemInSlot(eInvSlot_PrimaryWeapon, UpdateState);
			if (ItemState != none && ItemState.HasBeenModified())
			{
				StripWeaponUpgradesFromItem(ItemState, XComHQ, UpdateState);
			}
		}

		`GAMERULES.SubmitGameState(UpdateState);
	}
	if (LoadoutScreen != none)
	{
		LoadoutScreen.UpdateNavHelp();
	}
}

simulated function array<XComGameState_Unit> GetSoldiersToStrip(XComGameState_HeadquartersXCom XComHQ, XComGameState UpdateState)
{
	local array<XComGameState_Unit> Soldiers;
	local int idx;
	local UIArmory ArmoryScreen;
	local UISquadSelect SquadSelectScreen;

	// Look for an armory screen. This will tell us what soldier we're looking at right now, we never want
	// to strip this one.
	ArmoryScreen = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));

	// Look for a squad select screen. This will tell us which soldiers we shouldn't strip because they're
	// in the active squad.
	SquadSelectScreen = UISquadSelect(`SCREENSTACK.GetFirstInstanceOf(class'UISquadSelect'));

	// Start with all soldiers: we only want to selectively ignore the ones in XComHQ.Squad if we're
	// in squad select. Otherwise it contains stale unit refs and we can't trust it.
	Soldiers = XComHQ.GetSoldiers(false);

	// LWS : revamped loop to remove multiple soldiers
	for(idx = Soldiers.Length - 1; idx >= 0; idx--)
	{

		// Don't strip items from the guy we're currently looking at (if any)
		if (ArmoryScreen != none)
		{
			if(Soldiers[idx].ObjectID == ArmoryScreen.GetUnitRef().ObjectID)
			{
				Soldiers.Remove(idx, 1);
				continue;
			}
		}
		//LWS: prevent stripping of gear of soldier with eStatus_CovertAction
		if(Soldiers[idx].GetStatus() == eStatus_CovertAction)
		{
			Soldiers.Remove(idx, 1);
			continue;
		}
		// prevent stripping of soldiers in current XComHQ.Squad if we're in squad
		// select. Otherwise ignore XComHQ.Squad as it contains stale unit refs.
		if (SquadSelectScreen != none)
		{
			if (XComHQ.Squad.Find('ObjectID', Soldiers[idx].ObjectID) != -1)
			{
				Soldiers.Remove(idx, 1);
				continue;
			}
		}
	}

	return Soldiers;
}

function StripWeaponUpgradesFromItem(XComGameState_Item ItemState, XComGameState_HeadquartersXCom XComHQ, XComGameState UpdateState)
{
	local int k;
	local array<X2WeaponUpgradeTemplate> UpgradeTemplates;
	local XComGameState_Item UpdateItemState, UpgradeItemState;

	UpdateItemState = XComGameState_Item(UpdateState.GetGameStateForObjectID(ItemState.ObjectID));
	if (UpdateItemState == none)
	{
		UpdateItemState = XComGameState_Item(UpdateState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
		UpdateState.AddStateObject(UpdateItemState);
	}

	UpgradeTemplates = ItemState.GetMyWeaponUpgradeTemplates();
	for (k = 0; k < UpgradeTemplates.length; k++)
	{
		UpgradeItemState = UpgradeTemplates[k].CreateInstanceFromTemplate(UpdateState);
		UpdateState.AddStateObject(UpgradeItemState);
		XComHQ.PutItemInInventory(UpdateState, UpgradeItemState);
	}

	UpdateItemState.NickName = "";
	UpdateItemState.WipeUpgradeTemplates();
}

//function EventListenerReturn OnOverrideInitialPsiTrainingTime(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
//{
	//local XComLWTuple Tuple;
//
	//Tuple = XComLWTuple(EventData);
	//if (Tuple == none)
	//{
		//return ELR_NoInterrupt;
	//}
	//Tuple.Data[0].i=default.INITIAL_PSI_TRAINING[`STRATEGYDIFFICULTYSETTING];
	//return ELR_NoInterrupt;
//}
//
//// This sets a flag that skips the automatic alert placed on the squad when reinfs land.
//function EventListenerReturn OnOverrideReinforcementsAlert(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
//{
	///* WOTC TODO: Restore this
	//local XComLWTuple Tuple;
	//local XComGameState_Player PlayerState;
//
	//Tuple = XComLWTuple(EventData);
	//if (Tuple == none)
	//{
		//return ELR_NoInterrupt;
	//}
//
	//PlayerState = class'Utilities_LW'.static.FindPlayer(eTeam_XCom);
	//Tuple.Data[0].b = PlayerState.bSquadIsConcealed;
	//*/
	//return ELR_NoInterrupt;
//}
//
//// this function cleans up some weird objective states by firing specific events
//function EventListenerReturn OnGeoscapeEntry(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
//{
	//local XComGameState_MissionSite					MissionState;
//
	//if (`XCOMHQ.GetObjectiveStatus('T2_M1_S1_ResearchResistanceComms') <= eObjectiveState_InProgress)
	//{
		//if (`XCOMHQ.IsTechResearched ('ResistanceCommunications'))
		//{
			//foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_MissionSite', MissionState)
			//{
				//if (MissionState.GetMissionSource().DataName == 'MissionSource_Blacksite')
				//{
					//`XEVENTMGR.TriggerEvent('ResearchCompleted',,, NewGameState);
					//break;
				//}
			//}
		//}
	//}
//
	//if (`XCOMHQ.GetObjectiveStatus('T2_M1_S2_MakeContactWithBlacksiteRegion') <= eObjectiveState_InProgress)
	//{
		//foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_MissionSite', MissionState)
		//{
			//if (MissionState.GetMissionSource().DataName == 'MissionSource_Blacksite')
			//{
				//if (MissionState.GetWorldRegion().ResistanceLevel >= eResLevel_Contact)
				//{
					//`XEVENTMGR.TriggerEvent('OnBlacksiteContacted',,, NewGameState);
					//break;
				//}
			//}
		//}
	//}
//
	//return ELR_NoInterrupt;
//}

// TechState, TechState
