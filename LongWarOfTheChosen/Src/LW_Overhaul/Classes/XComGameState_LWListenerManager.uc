//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWListenerManager.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This singleton object manages general persistent listeners that should live for both strategy and tactical play
//---------------------------------------------------------------------------------------
class XComGameState_LWListenerManager extends XComGameState_BaseObject config(LW_Overhaul) dependson(XComGameState_LWPersistentSquad);

struct MinimumInfilForConcealEntry
{
	var string MissionType;
	var float MinInfiltration;
};

var localized string CannotModifyOnMissionSoldierTooltip;

var config int DEFAULT_LISTENER_PRIORITY;

var config int RENDEZVOUS_EVAC_DELAY; // deprecated
var config int SNARE_EVAC_DELAY; // deprecated

var int OverrideNumUtilitySlots;

var localized string ResistanceHQBodyText;


var config bool TIERED_RESPEC_TIMES;
var config bool AI_PATROLS_WHEN_SIGHTED_BY_HIDDEN_XCOM;

var config array<MinimumInfilForConcealEntry> MINIMUM_INFIL_FOR_CONCEAL;
var config array<float> MINIMUM_INFIL_FOR_GREEN_ALERT;

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

	//end of month and reward soldier handling of new soldiers
	EventMgr.RegisterForEvent(ThisObj, 'SoldierCreatedEvent', OnSoldierCreatedEvent, ELD_OnStateSubmitted,,,true);
	
	// WOTC TODO: Requires change to CHL XComGameState_Unit
	EventMgr.RegisterForEvent(ThisObj, 'ShouldShowPromoteIcon', OnCheckForPsiPromotion, ELD_Immediate,,,true);
	EventMgr.RegisterForEvent(ThisObj, 'OverrideCollectorActivation', OverrideCollectorActivation, ELD_Immediate,,,true);
	EventMgr.RegisterForEvent(ThisObj, 'OverrideScavengerActivation', OverrideScavengerActivation, ELD_Immediate,,,true);
	
	// Mission summary civilian counts
	// WOTC TODO: Requires change to CHL Helpers and UIMissionSummary
	EventMgr.RegisterForEvent(ThisObj, 'GetNumCiviliansKilled', OnNumCiviliansKilled, ELD_Immediate,,,true);
		
	// listener for turn change
	EventMgr.RegisterForEvent(ThisObj, 'PlayerTurnBegun', LW2OnPlayerTurnBegun);

	// WOTC TODO: This disables buttons in the armory main menu based on soldier
	// status. See issue https://github.com/pledbrook/lwotc/issues/40 for an alternative
	// approach.
	//override disable flags
	// EventMgr.RegisterForEvent(ThisObj, 'OverrideSquadSelectDisableFlags', OverrideSquadSelectDisableFlags,,,,true);

	// WOTC TODO: See issue above for alternative approach. Although we may need it
	// to handle Haven liaisons and those in psi training. Perhaps officer training
	// as well? Need to check all of those.
	// Armory Main Menu - disable buttons for On-Mission soldiers
	EventMgr.RegisterForEvent(ThisObj, 'OnArmoryMainMenuUpdate', UpdateArmoryMainMenuItems, ELD_Immediate,,,true);



	// WOTC TODO: Get this done! Need it for early missions.
	//Special First Mission Icon handling -- only for replacing the Resistance HQ icon functionality
	EventMgr.RegisterForEvent(ThisObj, 'OnInsertFirstMissionIcon', OnInsertFirstMissionIcon, ELD_Immediate,,,true);

	//listener to interrupt OnSkyrangerArrives to not play narrative event -- we will manually trigger it when appropriate in screen listener
	EventMgr.RegisterForEvent(ThisObj, 'OnSkyrangerArrives', OnSkyrangerArrives, ELD_OnStateSubmitted, 100,,true);

	// Override KilledbyExplosion variable to conditionally allow loot to survive
	EventMgr.RegisterForEvent(ThisObj, 'KilledbyExplosion', OnKilledbyExplosion,,,,true);

	// Recalculate respec time so it goes up with soldier rank
	EventMgr.RegisterForEvent(ThisObj, 'SoldierRespecced', OnSoldierRespecced,,,,true);

	//PCS Images
	EventMgr.RegisterForEvent(ThisObj, 'OnGetPCSImage', GetPCSImage,,,,true);

    // Tactical mission cleanup hook
    EventMgr.RegisterForEvent(ThisObj, 'CleanupTacticalMission', OnCleanupTacticalMission, ELD_Immediate,,, true);

    // Outpost built
    EventMgr.RegisterForEvent(ThisObj, 'RegionBuiltOutpost', OnRegionBuiltOutpost, ELD_OnStateSubmitted,,, true);

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

	// listener for when squad conceal is set
	EventMgr.RegisterForEvent(ThisObj, 'OnSetMissionConceal', CheckForConcealOverride, ELD_Immediate,,, true);

	// listener for when an enemy unit's alert status is set -- not working
	//EventMgr.RegisterForEvent(ThisObj, 'OnSetUnitAlert', CheckForUnitAlertOverride, ELD_Immediate,,, true);

	//General Use, currently used for alert change to red
	EventMgr.RegisterForEvent(ThisObj, 'AbilityActivated', OnAbilityActivated, ELD_OnStateSubmitted,,, true);

	/* WOTC TODO: Might be a while before these events are available
	// Attempt to tame Serial
	EventMgr.RegisterForEvent(ThisObj, 'SerialKiller', OnSerialKill, ELD_OnStateSubmitted);

	// initial psi training time override
	EventMgr.RegisterForEvent(ThisObj, 'PsiTrainingBegun', OnOverrideInitialPsiTrainingTime, ELD_Immediate,,, true);

	//Help for some busted objective triggers
	EventMgr.RegisterForEvent(ThisObj, 'OnGeoscapeEntry', OnGeoscapeEntry, ELD_Immediate,,, true);
	*/
}

function EventListenerReturn OnSkyrangerArrives(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	return ELR_InterruptListeners;
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

function EventListenerReturn OverrideCollectorActivation(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple OverrideActivation;

	OverrideActivation = XComLWTuple(EventData);

	if(OverrideActivation != none && OverrideActivation.Id == 'OverrideCollectorActivation' && OverrideActivation.Data[0].kind == XComLWTVBool)
	{
		OverrideActivation.Data[0].b = class'Utilities_LW'.static.KillXpIsCapped();
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn OverrideScavengerActivation(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple OverrideActivation;

	OverrideActivation = XComLWTuple(EventData);

	if(OverrideActivation != none && OverrideActivation.Id == 'OverrideScavengerActivation' && OverrideActivation.Data[0].kind == XComLWTVBool)
	{
		OverrideActivation.Data[0].b = class'Utilities_LW'.static.KillXpIsCapped();
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

function EventListenerReturn UpdateArmoryMainMenuItems(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local UIList List;
	local XComGameState_Unit Unit;
	local UIArmory_MainMenu ArmoryMainMenu;
	//local array<string> ButtonsToDisableStrings;
	local array<name> ButtonToDisableMCNames;
	local int idx;
	local UIListItemString CurrentButton;
	local XComGameState_StaffSlot StaffSlotState;

	`LOG("AWCPack / UpdateArmoryMainMenuItems: Starting.");

	List = UIList(EventData);
	if(List == none)
	{
		`REDSCREEN("Update Armory MainMenu event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	ArmoryMainMenu = UIArmory_MainMenu(EventSource);
	if(ArmoryMainMenu == none)
	{
		`REDSCREEN("Update Armory MainMenu event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ArmoryMainMenu.UnitReference.ObjectID));
	if (class'LWDLCHelpers'.static.IsUnitOnMission(Unit))
	{
		//ButtonToDisableMCNames.AddItem('ArmoryMainMenu_LoadoutButton'); // adding ability to view loadout, but not modifiy it

		// If this unit isn't a haven adviser, or is a haven adviser that is locked, disable loadout
		// changing. (Allow changing equipment on haven advisers in regions where you can change the
		// adviser to save some clicks).
		if (!`LWOUTPOSTMGR.IsUnitAHavenLiaison(Unit.GetReference()) ||
			`LWOUTPOSTMGR.IsUnitALockedHavenLiaison(Unit.GetReference()))
		{
			ButtonToDisableMCNames.AddItem('ArmoryMainMenu_PCSButton');
			ButtonToDisableMCNames.AddItem('ArmoryMainMenu_WeaponUpgradeButton');

			//update the Loadout button handler to one that locks all of the items
			CurrentButton = FindButton(0, 'ArmoryMainMenu_LoadoutButton', ArmoryMainMenu);
			CurrentButton.ButtonBG.OnClickedDelegate = OnLoadoutLocked;
		}

		// Dismiss is still disabled for all on-mission units, including liaisons.
		ButtonToDisableMCNames.AddItem('ArmoryMainMenu_DismissButton');


		// -------------------------------------------------------------------------------
		// Disable Buttons:
		for (idx = 0; idx < ButtonToDisableMCNames.Length; idx++)
		{
			CurrentButton = FindButton(idx, ButtonToDisableMCNames[idx], ArmoryMainMenu);
			if(CurrentButton != none)
			{
				CurrentButton.SetDisabled(true, default.CannotModifyOnMissionSoldierTooltip);
			}
		}

		return ELR_NoInterrupt;
	}
	switch(Unit.GetStatus())
	{
		case eStatus_PsiTraining:
		case eStatus_PsiTesting:
		case eStatus_Training:
			CurrentButton = FindButton(idx, 'ArmoryMainMenu_DismissButton', ArmoryMainMenu);
			if (CurrentButton != none)
			{
				StaffSlotState = Unit.GetStaffSlot();
				if (StaffSlotState != none)
				{
					CurrentButton.SetDisabled(true, StaffSlotState.GetBonusDisplayString());
				}
				else
				{
					CurrentButton.SetDisabled(true, "");
				}
			}
			break;
		default:
			break;
	}
	return ELR_NoInterrupt;
}

function UIListItemString FindButton(int DefaultIdx, name ButtonName, UIArmory_MainMenu MainMenu)
{
	if(ButtonName == '')
		return none;

	return UIListItemString(MainMenu.List.GetChildByName(ButtonName, false));
}

simulated function OnLoadoutLocked(UIButton kButton)
{
	local XComHQPresentationLayer HQPres;
	local array<EInventorySlot> CannotEditSlots;
	local UIArmory_MainMenu MainMenu;

	CannotEditSlots.AddItem(eInvSlot_Utility);
	CannotEditSlots.AddItem(eInvSlot_Armor);
	CannotEditSlots.AddItem(eInvSlot_GrenadePocket);
	CannotEditSlots.AddItem(eInvSlot_GrenadePocket);
	CannotEditSlots.AddItem(eInvSlot_PrimaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_SecondaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_HeavyWeapon);
	CannotEditSlots.AddItem(eInvSlot_TertiaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_QuaternaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_QuinaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_SenaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_SeptenaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_AmmoPocket);

	MainMenu = UIArmory_MainMenu(GetScreenOrChild('UIArmory_MainMenu'));
	if (MainMenu == none) { return; }

	if( UIListItemString(kButton.ParentPanel) != none && UIListItemString(kButton.ParentPanel).bDisabled )
	{
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_MenuClickNegative");
		return;
	}

	HQPres = `HQPRES;
	if( HQPres != none )
		HQPres.UIArmory_Loadout(MainMenu.UnitReference, CannotEditSlots);
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

function EventListenerReturn OnSoldierCreatedEvent(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit Unit, UpdatedUnit;
	local XComGameState NewGameState;

	Unit = XComGameState_Unit(EventData);
	if(Unit == none)
	{
		`REDSCREEN("OnSoldierCreatedEvent with no UnitState EventData");
		return ELR_NoInterrupt;
	}

	//Build NewGameState change container
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update newly created soldier");
	UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
	NewGameState.AddStateObject(UpdatedUnit);
	class'Utilities_LW'.static.GiveDefaultUtilityItemsToSoldier(UpdatedUnit, NewGameState);
	`GAMERULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}

function UIScreen GetScreenOrChild(name ScreenType)
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

// add restrictions on when units can be editted, have loadout changed, or dismissed, based on status
//function EventListenerReturn OverrideSquadSelectDisableFlags(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
//{
	//local XComLWTuple				OverrideTuple;
	//local UISquadSelect			SquadSelect;
	//local XComGameState_Unit	UnitState;
	//local XComLWTValue				Value;
//
	//`LWTRACE("DisableAutoFillSquad : Starting listener.");
	//OverrideTuple = XComLWTuple(EventData);
	//if(OverrideTuple == none)
	//{
		//`REDSCREEN("OverrideSquadSelectDisableFlags event triggered with invalid event data.");
		//return ELR_NoInterrupt;
	//}
//
	//SquadSelect = UISquadSelect(EventSource);
	//if(SquadSelect == none)
	//{
		//`REDSCREEN("OverrideSquadSelectDisableFlags event triggered with invalid source data.");
		//return ELR_NoInterrupt;
	//}
//
	//if(OverrideTuple.Id != 'OverrideSquadSelectDisableFlags')
		//return ELR_NoInterrupt;
//
	//if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M3_WelcomeToHQ') == eObjectiveState_InProgress)
	//{
		////retain this just in case
		//OverrideTuple.Data[0].b = true; // bDisableEdit
		//OverrideTuple.Data[1].b = true; // bDisableDismiss
		//OverrideTuple.Data[2].b = false; // bDisableLoadout
		//return ELR_NoInterrupt;
	//}
	//UnitState = XComGameState_Unit(OverrideTuple.Data[3].o);
	//if (UnitState == none) { return ELR_NoInterrupt; }
//
	///* WOTC TODO: Requires LWDLCHelpers
	//if (class'LWDLCHelpers'.static.IsUnitOnMission(UnitState))
	//{
		//OverrideTuple.Data[0].b = false; // bDisableEdit
		//OverrideTuple.Data[1].b = true; // bDisableDismiss
		//OverrideTuple.Data[2].b = true; // bDisableLoadout
//
		//Value.Kind = XComLWTVInt;
		//Value.i = eInvSlot_Utility;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_Armor;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_GrenadePocket;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_GrenadePocket;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_PrimaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_SecondaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_HeavyWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_TertiaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_QuaternaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_QuinaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_SenaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_SeptenaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//`LWTRACE("OverrideSquadSelectDisableFlags : Disabling Dismiss/Loadout for Status OnMission soldier");
	//}
	//*/
	//`LWTRACE("OverrideSquadSelectDisableFlags : Reached end of event handler.");
//
	//return ELR_NoInterrupt;
//}

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

function EventListenerReturn OnKilledByExplosion(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Unit		Killer, Target;

	//`LOG ("Firing OnKilledByExplosion");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OnKilledByExplosion event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverrideTuple : Parsed XComLWTuple.");

	Target = XComGameState_Unit(EventSource);
	if(Target == none)
		return ELR_NoInterrupt;
	//`LOG("OverrideTuple : EventSource valid.");

	if(OverrideTuple.Id != 'OverrideKilledbyExplosion')
		return ELR_NoInterrupt;

	Killer = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(OverrideTuple.Data[1].i));

	if (OverrideTuple.Data[0].b && Killer.HasSoldierAbility('NeedleGrenades', true))
	{
		OverrideTuple.Data[0].b = false;
		//`LOG ("Converting to non explosive kill");
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn OnShouldUnitPatrol (Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Unit		UnitState;
	local XComGameState_AIUnitData	AIData;
	local int						AIUnitDataID, idx;
	local XComGameState_Player		ControllingPlayer;
	local bool						bHasValidAlert;

	//`LOG ("Firing OnShouldUnitPatrol");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OnShouldUnitPatrol event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	UnitState = XComGameState_Unit(OverrideTuple.Data[1].o);
	if (default.AI_PATROLS_WHEN_SIGHTED_BY_HIDDEN_XCOM)
	{
		if (UnitState.GetCurrentStat(eStat_AlertLevel) <= `ALERT_LEVEL_YELLOW)
		{
			if (UnitState.GetCurrentStat(eStat_AlertLevel) == `ALERT_LEVEL_YELLOW)
			{
				// don't do normal patrolling if the unit has current AlertData
				AIUnitDataID = UnitState.GetAIUnitDataID();
				if (AIUnitDataID > 0)
				{
					if (NewGameState != none)
						AIData = XComGameState_AIUnitData(NewGameState.GetGameStateForObjectID(AIUnitDataID));

					if (AIData == none)
					{
						AIData = XComGameState_AIUnitData(`XCOMHISTORY.GetGameStateForObjectID(AIUnitDataID));
					}
					if (AIData != none)
					{
						if (AIData.m_arrAlertData.length == 0)
						{
							OverrideTuple.Data[0].b = true;
						}
						else // there is some alert data, but how old ?
						{
							ControllingPlayer = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));
							for (idx = 0; idx < AIData.m_arrAlertData.length; idx++)
							{
								if (ControllingPlayer.PlayerTurnCount - AIData.m_arrAlertData[idx].PlayerTurn < 3)
								{
									bHasValidAlert = true;
									break;
								}
							}
							if (!bHasValidAlert)
							{
								OverrideTuple.Data[0].b = true;
							}
						}
					}
				}
			}
			OverrideTuple.Data[0].b = true;
		}
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn GetPCSImage(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple			OverridePCSImageTuple;
	local string				ReturnImagePath;
	local XComGameState_Item	ItemState;
	//local UIUtilities_Image		Utility;

	OverridePCSImageTuple = XComLWTuple(EventData);
	if(OverridePCSImageTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverridePCSImageTuple : Parsed XComLWTuple.");

	ItemState = XComGameState_Item(EventSource);
	if(ItemState == none)
		return ELR_NoInterrupt;
	//`LOG("OverridePCSImageTuple : EventSource valid.");

	if(OverridePCSImageTuple.Id != 'OverrideGetPCSImage')
		return ELR_NoInterrupt;

	switch (ItemState.GetMyTemplateName())
	{
		case 'DepthPerceptionPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_depthperception"; break;
		case 'HyperReactivePupilsPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hyperreactivepupils"; break;
		case 'CombatAwarenessPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_threatassessment"; break;
		case 'DamageControlPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_damagecontrol"; break;
		case 'AbsorptionFieldsPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_impactfield"; break;
		case 'BodyShieldPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_bodyshield"; break;
		case 'EmergencyLifeSupportPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_emergencylifesupport"; break;
		case 'IronSkinPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_ironskin"; break;
		case 'SmartMacrophagesPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_smartmacrophages"; break;
		case 'CombatRushPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_combatrush"; break;
		case 'CommonPCSDefense': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_defense"; break;
		case 'RarePCSDefense': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_defense"; break;
		case 'EpicPCSDefense': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_defense"; break;
		case 'CommonPCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_dodge"; break;
		case 'RarePCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_dodge"; break;
		case 'EpicPCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_dodge"; break;
		case 'CommonPCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hacking"; break;
		case 'RarePCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hacking"; break;
		case 'EpicPCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hacking"; break;
		case 'FireControl25PCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_firecontrol"; break;
		case 'FireControl50PCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_firecontrol"; break;
		case 'FireControl75PCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_firecontrol"; break;

		default:  OverridePCSImageTuple.Data[0].b = false;
	}
	ReturnImagePath = OverridePCSImageTuple.Data[1].s;  // anything set by any other listener that went first
	ReturnImagePath = ReturnImagePath;

	//`LOG("GetPCSImage Override : working!.");

	return ELR_NoInterrupt;
}

function EventListenerReturn OnCleanupTacticalMission(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
    local XComGameState_BattleData BattleData;
    local XComGameState_Unit Unit;
    local XComGameStateHistory History;
	local XComGameState_Effect EffectState;
	local StateObjectReference EffectRef;
	local bool AwardWrecks;

    History = `XCOMHISTORY;
    BattleData = XComGameState_BattleData(EventData);
    BattleData = XComGameState_BattleData(NewGameState.GetGameStateForObjectID(BattleData.ObjectID));

	// If we completed this mission with corpse recovery, you get the wreck/loot from any turret
	// left on the map as well as any Mastered unit that survived but is not eligible to be
	// transferred to a haven.
	AwardWrecks = BattleData.AllTacticalObjectivesCompleted();

    if (AwardWrecks)
    {
        // If we have completed the tactical objectives (e.g. sweep) we are collecting corpses.
        // Generate wrecks for each of the turrets left on the map that XCOM didn't kill before
        // ending the mission.
        foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
        {
            if (Unit.IsTurret() && !Unit.IsDead())
            {
                // We can't call the RollForAutoLoot() function here because we have a pending
                // gamestate with a modified BattleData already. Just add a corpse to the list
                // of pending auto loot.
                BattleData.AutoLootBucket.AddItem('CorpseAdventTurret');
            }
        }
    }

	// Handle effects that can only be performed at mission end:
	//
	// Handle full override mecs. Look for units with a full override effect that are not dead
	// or captured. This is done here instead of in an OnEffectRemoved hook, because effect removal
	// isn't fired when the mission ends on a sweep, just when they evac. Other effect cleanup
	// typically happens in UnitEndedTacticalPlay, but since we need to update the haven gamestate
	// we can't use that: we don't get a reference to the current XComGameState being submitted.
	// This works because the X2Effect_TransferMecToOutpost code sets up its own UnitRemovedFromPlay
	// event listener, overriding the standard one in XComGameState_Effect, so the effect won't get
	// removed when the unit is removed from play and we'll see it here.
	//
	// Handle Field Surgeon. We can't let the effect get stripped on evac via OnEffectRemoved because
	// the surgeon themself may die later in the mission. We need to wait til mission end and figure out
	// which effects to apply.
	//
	// Also handle units that are still living but are affected by mind-control - if this is a corpse
	// recovering mission, roll their auto-loot so that corpses etc. are granted despite them not actually
	// being killed.

	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if(Unit.IsAlive() && !Unit.bCaptured)
		{
			foreach Unit.AffectedByEffects(EffectRef)
			{
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
				if (EffectState.GetX2Effect().EffectName == class'X2Effect_TransferMecToOutpost'.default.EffectName)
				{
					X2Effect_TransferMecToOutpost(EffectState.GetX2Effect()).AddMECToOutpostIfValid(EffectState, Unit, NewGameState, AwardWrecks);
				}
				else if (EffectState.GetX2Effect().EffectName == class'X2Effect_FieldSurgeon'.default.EffectName)
				{
					X2Effect_FieldSurgeon(EffectState.GetX2Effect()).ApplyFieldSurgeon(EffectState, Unit, NewGameState);
				}
				else if (EffectState.GetX2Effect().EffectName == class'X2Effect_MindControl'.default.EffectName && AwardWrecks)
				{
					Unit.RollForAutoLoot(NewGameState);

					// Super hacks for andromedon, since only the robot drops a corpse.
					if (Unit.GetMyTemplateName() == 'Andromedon')
					{
						BattleData.AutoLootBucket.AddItem('CorpseAndromedon');
					}
				}
			}
		}
	}

    return ELR_NoInterrupt;
}

function EventListenerReturn OnRegionBuiltOutpost(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComGameStateHistory History;
    local XComGameState_WorldRegion Region;
    local XComGameState NewGameState;

    History = `XCOMHISTORY;
    foreach History.IterateByClassType(class'XComGameState_WorldRegion', Region)
    {
        // Look for regions that have an outpost built, which have their "bScanforOutpost" flag reset
        // (this is cleared by XCGS_WorldRegion.Update() when the scan finishes) and the scan has begun.
        // For these regions, reset the scan. This will reset the scanner UI to "empty". The reset
        // call will reset the scan started flag so subsequent triggers will not redo this change
        // for this region.
        if (Region.ResistanceLevel == eResLevel_Outpost &&
            !Region.bCanScanForOutpost &&
            Region.GetScanPercentComplete() > 0)
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Reset outpost scanner");
            Region = XComGameState_WorldRegion(NewGameState.CreateStateObject(class'XComGameState_WorldRegion', Region.ObjectID));
            NewGameState.AddStateObject(Region);
            Region.ResetScan();
            `GAMERULES.SubmitGameState(NewGameState);
        }
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


// return true to override XComSquadStartsConcealed=true setting in mission schedule and have the game function as if it was false
function EventListenerReturn CheckForConcealOverride(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
	local XComLWTuple						OverrideTuple;
	local XComGameState_MissionSite			MissionState;
	local XComGameState_LWPersistentSquad	SquadState;
	local XComGameState_BattleData			BattleData;
	local int k;

	//`LWTRACE("CheckForConcealOverride : Starting listener.");

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("CheckForConcealOverride event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	OverrideTuple.Data[0].b = false;

	// If within a configurable list of mission types, and infiltration below a set value, set it to true
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(BattleData.m_iMissionID));

    if (MissionState == none)
    {
        return ELR_NoInterrupt;
    }

	//`LWTRACE ("CheckForConcealOverride: Found MissionState");

	for (k = 0; k < default.MINIMUM_INFIL_FOR_CONCEAL.length; k++)
    if (MissionState.GeneratedMission.Mission.sType == MINIMUM_INFIL_FOR_CONCEAL[k].MissionType)
	{
		SquadState = `LWSQUADMGR.GetSquadOnMission(MissionState.GetReference());
		//`LWTRACE ("CheckForConcealOverride: Mission Type correct. Infiltration:" @ SquadState.CurrentInfiltration);
		If (SquadState.CurrentInfiltration < MINIMUM_INFIL_FOR_CONCEAL[k].MinInfiltration)
		{
			//`LWTRACE ("CheckForConcealOverride: Conditions met to start squad revealed");
			OverrideTuple.Data[0].b = true;
		}
	}
	*/
	return ELR_NoInterrupt;
}

function EventListenerReturn CheckForUnitAlertOverride(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
	local XComLWTuple						OverrideTuple;
	local XComGameState_MissionSite			MissionState;
	local XComGameState_LWPersistentSquad	SquadState;
	local XComGameState_BattleData			BattleData;

	//`LWTRACE("CheckForUnitAlertOverride : Starting listener.");

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("CheckForUnitAlertOverride event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	// If within a configurable list of mission types, and infiltration below a set value, set it to true
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(BattleData.m_iMissionID));

    if (MissionState == none)
    {
        return ELR_NoInterrupt;
    }

	SquadState = `LWSQUADMGR.GetSquadOnMission(MissionState.GetReference());

	if (`LWSQUADMGR.IsValidInfiltrationMission(MissionState.GetReference()))
	{
		if (SquadState.CurrentInfiltration < default.MINIMUM_INFIL_FOR_GREEN_ALERT[`STRATEGYDIFFICULTYSETTING])
		{
			if (OverrideTuple.Data[0].i == `ALERT_LEVEL_GREEN)
			{
				OverrideTuple.Data[0].i = `ALERT_LEVEL_YELLOW;
				`LWTRACE ("Changing unit alert to yellow");
			}
		}
	}
	*/
	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
    local XComGameState_Ability ActivatedAbilityState;
	local XComGameState_LWReinforcements Reinforcements;
	local XComGameState NewGameState;

	//ActivatedAbilityStateContext = XComGameStateContext_Ability(GameState.GetContext());
	ActivatedAbilityState = XComGameState_Ability(EventData);
	if (ActivatedAbilityState.GetMyTemplate().DataName == 'RedAlert')
	{
		Reinforcements = XComGameState_LWReinforcements(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWReinforcements', true));
		if (Reinforcements == none)
			return ELR_NoInterrupt;

		if (Reinforcements.RedAlertTriggered)
			return ELR_NoInterrupt;

		Reinforcements.RedAlertTriggered = true;

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Check for reinforcements");
		Reinforcements = XComGameState_LWReinforcements(NewGameState.CreateStateObject(class'XComGameState_LWReinforcements', Reinforcements.ObjectID));
		NewGameState.AddStateObject(Reinforcements);
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	*/
	return ELR_NoInterrupt;
}

//function EventListenerReturn OnSerialKill(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
//{
	//local XComGameState_Unit ShooterState;
    //local UnitValue UnitVal;
//
	//ShooterState = XComGameState_Unit (EventSource);
	//If (ShooterState == none)
	//{
		//return ELR_NoInterrupt;
	//}
	//ShooterState.GetUnitValue ('SerialKills', UnitVal);
	//ShooterState.SetUnitFloatValue ('SerialKills', UnitVal.fValue + 1.0, eCleanup_BeginTurn);
	//return ELR_NoInterrupt;
//}
//

function EventListenerReturn LW2OnPlayerTurnBegun(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComGameState_Player PlayerState;

	PlayerState = XComGameState_Player (EventData);
	if (PlayerState == none)
	{
		`LOG ("LW2OnPlayerTurnBegun: PlayerState Not Found");
		return ELR_NoInterrupt;
	}

	if(PlayerState.GetTeam() == eTeam_XCom)
	{
		`XEVENTMGR.TriggerEvent('XComTurnBegun', PlayerState, PlayerState);
	}
	if(PlayerSTate.GetTeam() == eTeam_Alien)
	{
		`XEVENTMGR.TriggerEvent('AlienTurnBegun', PlayerState, PlayerState);
	}

	return ELR_NoInterrupt;
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


defaultproperties
{
	OverrideNumUtilitySlots = 3;
}
