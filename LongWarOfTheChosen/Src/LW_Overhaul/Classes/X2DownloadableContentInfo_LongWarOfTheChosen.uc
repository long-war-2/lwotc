//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_LongWarOfTheChosen.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_LongWarOfTheChosen extends X2DownloadableContentInfo config(LW_Overhaul);

//----------------------------------------------------------------
// A random selection of data and data structures from LW Overhaul

struct MinimumInfilForConcealEntry
{
	var string MissionType;
	var float MinInfiltration;
};

var config array<MinimumInfilForConcealEntry> MINIMUM_INFIL_FOR_CONCEAL;

struct ArchetypeToHealth
{
	var string ArchetypeName;
	var int Health;
	var int Difficulty;
	structDefaultProperties
	{
		Difficulty = -1;
	}
};

struct PlotObjectiveMod
{
	var string MapName;
	var array<String> ObjectiveTags;
};

var config array<ArchetypeToHealth> DestructibleActorHealthOverride;
var config array<bool> DISABLE_REINFORCEMENT_FLARES;
var config array<float> SOUND_RANGE_DIFFICULTY_MODIFIER;

struct SocketReplacementInfo
{
	var name TorsoName;
	var string SocketMeshString;
	var bool Female;
};

var config array<SocketReplacementInfo> SocketReplacements;

var config bool ShouldCleanupObsoleteUnits;
var config array<name> CharacterTypesExemptFromCleanup;

var config array<name> CharacterTypesExceptFromInfiltrationModifiers;

var config array<PlotObjectiveMod> PlotObjectiveMods;

// Configurable list of parcels to remove from the game.
var config array<String> ParcelsToRemove;
var bool bDebugPodJobs;

// End data and data structures
//-----------------------------

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	`Log("*********************** Starting OnLoadedSavedGame *************************");
	//class'XComGameState_LWListenerManager'.static.CreateListenerManager();
	//class'X2DownloadableContentInfo_LWSMGPack'.static.OnLoadedSavedGame();
	//class'X2DownloadableContentInfo_LWLaserPack'.static.OnLoadedSavedGame();
	//class'X2DownloadableContentInfo_LWOfficerPack'.static.OnLoadedSavedGame();
//
	//UpdateUtilityItemSlotsForAllSoldiers();
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
	// WOTC TODO: Note that this method is called twice if you start a new campaign.
	// Make sure that's not causing issues.
	`Log("LWOTC: Installing a new campaign");
	class'XComGameState_LWListenerManager'.static.CreateListenerManager(StartState);
	class'XComGameState_LWSquadManager'.static.CreateSquadManager(StartState);

	class'XComGameState_LWOutpostManager'.static.CreateOutpostManager(StartState);
	class'XComGameState_LWAlienActivityManager'.static.CreateAlienActivityManager(StartState);
	class'XComGameState_WorldRegion_LWStrategyAI'.static.InitializeRegionalAIs(StartState);
	class'XComGameState_LWOverhaulOptions'.static.CreateModSettingsState_NewCampaign(class'XComGameState_LWOverhaulOptions', StartState);


	SetStartingLocationToStartingRegion(StartState);
	UpdateLockAndLoadBonus(StartState);  // update XComHQ and Continent states to remove LockAndLoad bonus if it was selected
	LimitStartingSquadSize(StartState); // possibly limit the starting squad size to something smaller than the maximum
	
	class'XComGameState_LWSquadManager'.static.CreateFirstMissionSquad(StartState);
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	`Log(">>>> LW_Overhaul OnPostTemplates");
	class'LWTemplateMods_Utilities'.static.UpdateTemplates();
	UpdateWeaponAttachmentsForCoilgun();
	UpdateFirstMissionTemplate();
	AddObjectivesToParcels();
}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
	local XComGameStateHistory History;
	local XComGameState_Objective ObjectiveState;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState, UpdatedUnitState;
	local XComGameState_MissionSite Mission, UpdatedMission;
	local string TemplateString, NewTemplateString;
	local name TemplateName;
	local bool bAnyClassNameChanged;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local XComGameState_HeadquartersAlien AlienHQ;
	local X2StrategyElementTemplateManager	StratMgr;
	local MissionDefinition MissionDef;

	//this method can handle case where RegionalAI components already exist
	class'XComGameState_WorldRegion_LWStrategyAI'.static.InitializeRegionalAIs();
	class'XComGameState_LWListenerManager'.static.RefreshListeners();
	if (`LWOVERHAULOPTIONS == none)
		class'XComGameState_LWOverhaulOptions'.static.CreateModSettingsState_ExistingCampaign(class'XComGameState_LWOverhaulOptions');

	RemoveDarkEventObjectives();

	//make sure that critical narrative moments are active
	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Objective', ObjectiveState)
	{
		if(ObjectiveState.GetMyTemplateName() == 'N_GPCinematics')
		{
			if (ObjectiveState.ObjState != eObjectiveState_InProgress)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Forcing N_GPCinematics active");
				ObjectiveState = XComGameState_Objective(NewGameState.CreateStateObject(class'XComGameState_Objective', ObjectiveState.ObjectID));
				NewGameState.AddStateObject(ObjectiveState);
				ObjectiveState.StartObjective(NewGameState, true);
				History.AddGameStateToHistory(NewGameState);
			}
			break;
		}
	}

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	//patch in new AlienAI actions if needed
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	if (AlienHQ != none && AlienHQ.Actions.Find('AlienAI_PlayerInstantLoss') == -1)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add new Alien AI Actions");
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		NewGameState.AddStateObject(AlienHQ);
		AlienHQ.Actions.AddItem('AlienAI_PlayerInstantLoss');
		History.AddGameStateToHistory(NewGameState);
	}

	//update for name changes
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update for name changes");

	//patch for changing class template names
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		TemplateString = string(UnitState.GetSoldierClassTemplateName());
		if (UnitState.GetSoldierClassTemplate() == none && Left(TemplateString, 2) == "LW")
		{
			bAnyClassNameChanged = true;
			UpdatedUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
			NewGameState.AddStateObject(UpdatedUnitState);

			NewTemplateString = "LWS_" $ GetRightMost(TemplateString);
			UpdatedUnitState.SetSoldierClassTemplate(name(NewTemplateString));
		}
	}

	foreach History.IterateByClassType(class'XComGameState_MissionSite', Mission)
	{
		TemplateName = Mission.Source;
		TemplateString = string(TemplateName);
		//patch for changing mission source template name
		if (StratMgr.FindStrategyElementTemplate(TemplateName) == none && Right(TemplateString, 20) == "GenericMissionSource")
		{
			UpdatedMission = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', Mission.ObjectID));
			NewGameState.AddStateObject(UpdatedMission);

			NewTemplateString = "MissionSource_LWSGenericMissionSource";
			UpdatedMission.Source = name(NewTemplateString);
		}
		//patch for mod adjustments made to final mission mid-campaign
		if (TemplateString == "MissionSource_Final")
		{
			UpdatedMission = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', Mission.ObjectID));
			NewGameState.AddStateObject(UpdatedMission);

			// refresh to current MissionDef
			`TACTICALMISSIONMGR.GetMissionDefinitionForType("GP_Fortress_LW", MissionDef);
			Mission.GeneratedMission.Mission = MissionDef;
		}
	}

	if (bAnyClassNameChanged)
	{
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', `XCOMHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
		XComHQ.SoldierClassDeck.Length = 0; // reset deck for selecting more soldiers
		XComHQ.SoldierClassDistribution.Length = 0; // reset class distribution
		XComHQ.BuildSoldierClassForcedDeck();

		ResistanceHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
		ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.CreateStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));
		NewGameState.AddStateObject(ResistanceHQ);
		ResistanceHQ.SoldierClassDeck.Length = 0; // reset class deck for selecting reward soldiers
		ResistanceHQ.BuildSoldierClassDeck();
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		History.AddGameStateToHistory(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	CleanupObsoleteTacticalGamestate();
}

static function SetStartingLocationToStartingRegion(XComGameState StartState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	foreach StartState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	XComHQ.CurrentLocation = XComHQ.StartingRegion;
}

static function RemoveDarkEventObjectives()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_ObjectivesList ObjListState;
	local int idx;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add items");
	foreach History.IterateByClassType(class'XComGameState_ObjectivesList', ObjListState)
	{
		break;
	}

	if (ObjListState != none)
	{
		ObjListState = XComGameState_ObjectivesList(NewGameState.CreateStateObject(ObjListState.class, ObjListState.ObjectID));
		NewGameState.AddStateObject(ObjListState);
		for (idx = ObjListState.ObjectiveDisplayInfos.Length - 1; idx >= 0; idx--)
		{
			if (ObjListState.ObjectiveDisplayInfos[idx].bIsDarkEvent)
				ObjListState.ObjectiveDisplayInfos.Remove(idx, 1);
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

static function UpdateLockAndLoadBonus(optional XComGameState StartState)
{
	// LWOTC: This implementation was copied from the Covert Infiltrations
	// mod. LockAndLoad is no longer a continent bonus.
	local XComGameState_HeadquartersXCom XComHQ;
	local bool bSubmitLocally;

	if (StartState == none)
	{
		bSubmitLocally = true;
		StartState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CI: Forcing Lock And Load");
	}

	XComHQ = XComGameState_HeadquartersXCom(StartState.ModifyStateObject(class'XComGameState_HeadquartersXCom', `XCOMHQ.ObjectID));
	XComHQ.bReuseUpgrades = true;

	if(bSubmitLocally)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(StartState);
	}
}

// use new infiltration loading screens when loading into tactical missions
static function bool LoadingScreenOverrideTransitionMap(optional out string OverrideMapName, optional XComGameState_Unit UnitState)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local XComGameState_MissionSite MissionSiteState;

	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionSiteState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));

	if (`LWSQUADMGR.IsValidInfiltrationMission(MissionSiteState.GetReference()) || class'Utilities_LW'.static.CurrentMissionType() == "Rendezvous_LW")
	{
		if (`TACTICALGRI != none )  // only pre tactical
		{
			switch (MissionSiteState.GeneratedMission.Plot.strType)
			{
				case "CityCenter" :
				case "Rooftops" :
				case "Slums" :
				case "Facility" :
					OverrideMapName = "CIN_Loading_Infiltration_CityCenter";
					break;
				case "Shanty" :
				case "SmallTown" :
				case "Wilderness" :
					OverrideMapName = "CIN_Loading_Infiltration_SmallTown";
					break;
				// WOTC TODO: Consider creating intros for these plot types
				case "Abandoned":
				case "Tunnels_Sewer":
				case "Stronghold":
				case "Tunnels_Subway":
				default :
					OverrideMapName = "CIN_Loading_Infiltration_CityCenter";
					break;
			}
			return true;
		}
	}

	return false;
}

// set up alternate Mission Intro for infiltration missions
static function bool UseAlternateMissionIntroDefinition(MissionDefinition ActiveMission, int OverrideType, string OverrideTag, out MissionIntroDefinition MissionIntro)
{
	local XComGameState_LWSquadManager SquadMgr;

	SquadMgr = `LWSQUADMGR;

	if(SquadMgr.IsValidInfiltrationMission(`XCOMHQ.MissionRef) || class'Utilities_LW'.static.CurrentMissionType() == "Rendezvous_LW")
	{
		MissionIntro = SquadMgr.default.InfiltrationMissionIntroDefinition;
		return true;
	}
	return false;
}

// *****************************************************
// XCOM tactical mission adjustments
//

static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{
	local XComGameStateHistory History;
	local XComGameState_PointOfInterest POIState;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_MissionCalendar CalendarState;

	`LWACTIVITYMGR.UpdatePreMission (StartGameState, MissionState);
	ResetDelayedEvac(StartGameState);
	ResetReinforcements(StartGameState);
	InitializePodManager(StartGameState);
	OverrideConcealmentAtStart(MissionState);
	OverrideDestructibleHealths(StartGameState);

	// Test Code to see if DLC POI replacement is working
	if (MissionState.POIToSpawn.ObjectID > 0)
	{
		POIState = XComGameState_PointOfInterest(StartGameState.GetGameStateForObjectID(MissionState.POIToSpawn.ObjectID));
		if (POIState == none)
		{
			POIState = XComGameState_PointOfInterest(`XCOMHISTORY.GetGameStateForObjectID(MissionState.POIToSpawn.ObjectID));
		}
	}
	`LWTRACE("PreMission : MissonPOI ObjectID = " $ MissionState.POIToSpawn.ObjectID);
	if (POIState != none)
	{
		`LWTRACE("PreMission : MissionPOI name = " $ POIState.GetMyTemplateName());
	}

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	CalendarState = XComGameState_MissionCalendar(History.GetSingleGameStateObjectForClass(class'XComGameState_MissionCalendar'));
	//log some info relating to the AH POI 2 replacement conditions to see what might be causing it to not spawn
	`LWTRACE("============= POI_AlienNest Debug Info ========================");
	`LWTRACE("Mission POI to Replace                  : " $ string(MissionState.POIToSpawn.ObjectID > 0));
	foreach History.IterateByClassType(class'XComGameState_PointOfInterest', POIState)
	{
	`LWTRACE("     XCGS_PointOfInterest found : " $ POIState.GetMyTemplateName());
		if (POIState.GetMyTemplateName() == 'POI_AlienNest')
		{
			break;
		}
	}
	if (POIState != none && POIState.GetMyTemplateName() == 'POI_AlienNest')
	{
		`LWTRACE("XCGS_PointOfInterest for POI_AlienNest  : found");
	}
	else
	{
		`LWTRACE("XCGS_PointOfInterest for POI_AlienNest  : NOT found");
	}
	`LWTRACE("DLC_HunterWeapons objective complete    : " $ string(`XCOMHQ.IsObjectiveCompleted('DLC_HunterWeapons')));
	`LWTRACE("Time Test Passed                        : " $ string(class'X2StrategyGameRulesetDataStructures'.static.LessThan(AlienHQ.ForceLevelIntervalEndTime, CalendarState.CurrentMissionMonth[0].SpawnDate)));
	`LWTRACE("     AlienHQ       ForceLevelIntervalEndTime        : " $ class'X2StrategyGameRulesetDataStructures'.static.GetDateString(AlienHQ.ForceLevelIntervalEndTime) $ ", " $ class'X2StrategyGameRulesetDataStructures'.static.GetTimeString(AlienHQ.ForceLevelIntervalEndTime));
	`LWTRACE("     CalendarState CurrentMissionMonth[0] SpawnDate : " $ class'X2StrategyGameRulesetDataStructures'.static.GetDateString(CalendarState.CurrentMissionMonth[0].SpawnDate) $ ", " $ class'X2StrategyGameRulesetDataStructures'.static.GetTimeString(CalendarState.CurrentMissionMonth[0].SpawnDate));
	`LWTRACE("ForceLevel Test Passed                  : " $ string(AlienHQ.GetForceLevel() + 1 >= 4));
	`LWTRACE("     AlienHQ ForceLevel  : " $ AlienHQ.GetForceLevel());
	`LWTRACE("     Required ForceLevel : 4");
	`LWTRACE("===============================================================");
}

/// <summary>
/// Called when the player completes a mission while this DLC / Mod is installed.
/// </summary>
static event OnPostMission()
{
	class'XComGameState_LWListenerManager'.static.RefreshListeners();

	`LWSQUADMGR.UpdateSquadPostMission(, true); // completed mission
	`LWOUTPOSTMGR.UpdateOutpostsPostMission();
}

// WOTC TODO: Determine whether this pod diversification is necessary still
// diversify pods, in particular all-alien pods of all the same type
/*
static function PostEncounterCreation(out name EncounterName, out PodSpawnInfo SpawnInfo, int ForceLevel, int AlertLevel, optional XComGameState_BaseObject SourceObject)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local name								CharacterTemplateName, FirstFollowerName;
	local int								idx, Tries, PodSize, k;
	local X2CharacterTemplateManager		TemplateManager;
	local X2CharacterTemplate				LeaderCharacterTemplate, FollowerCharacterTemplate, CurrentCharacterTemplate;
	local bool								Swap, Satisfactory;
	local XComGameState_MissionSite			MissionState;
	local XComGameState_AIReinforcementSpawner	RNFSpawnerState;
	local XComGameState_HeadquartersXCom XCOMHQ;

	`LWTRACE("Parsing Encounter : " $ EncounterName);

	History = `XCOMHISTORY;
	MissionState = XComGameState_MissionSite(SourceObject);
	if (MissionState == none)
	{
		BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData', true));
		if (BattleData == none)
		{
			`LWTRACE("Could not detect mission type. Aborting with no mission variations applied.");
			return;
		}
		else
		{
			MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));
		}
	}

	`LWTRACE("Mission type = " $ MissionState.GeneratedMission.Mission.sType $ " detected.");
	switch(MissionState.GeneratedMission.Mission.sType)
	{
		case "GP_Fortress":
		case "GP_Fortress_LW":
			`LWTRACE("Fortress mission detected. Aborting with no mission variations applied.");
			return;
		case "AlienNest":
		case "LastGift":
		case "LastGiftB":
		case "LastGiftC":
			`LWTRACE("DLC mission detected. Aborting with no mission variations applied.");
			return;
		default:
			break;
	}
	if (Left(string(EncounterName), 11) == "GP_Fortress")
	{
		`LWTRACE("Fortress mission detected. Aborting with no mission variations applied.");
		return;
	}
	switch (EncounterName)
	{
		case 'LoneAvatar':
		case 'LoneCodex':
			return;
		default:
			break;
	}

	if (InStr (EncounterName,"PROTECTED") != -1)
	{
		return;
	}

	//`LWTRACE("PE1");
	RNFSpawnerState = XComGameState_AIReinforcementSpawner(SourceObject);

	//	`LWTRACE ("PE2");
	if (RNFSpawnerState != none)
	{
		`LWTRACE("Called from AIReinforcementSpawner.OnReinforcementSpawnerCreated -- modifying reinforcement spawninfo");
	}
	else
	{
		if (MissionState != none)
		{
			`LWTRACE("Called from MissionSite.CacheSelectedMissionData -- modifying preplaced spawninfo");
		}
	}

	//`LWTRACE ("PE3");

	`LWTRACE("Encounter composition:");
	foreach SpawnInfo.SelectedCharacterTemplateNames (CharacterTemplateName, idx)
	{
		`LWTRACE("Character[" $ idx $ "] = " $ CharacterTemplateName);
	}

	PodSize = SpawnInfo.SelectedCharacterTemplateNames.length;

	TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	LeaderCharacterTemplate = TemplateManager.FindCharacterTemplate(SpawnInfo.SelectedCharacterTemplateNames[0]);

	swap = false;

	// override native insisting every mission have a codex while certain tactical options are active
	XCOMHQ = XComGameState_HeadquartersXCom(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

	// Swap out forced Codices on regular encounters
	if (SpawnInfo.SelectedCharacterTemplateNames[0] == 'Cyberus' && InStr (EncounterName,"PROTECTED") == -1 && EncounterName != 'LoneCodex')
	{
		swap = true;
		SpawnInfo.SelectedCharacterTemplateNames[0] = SelectNewPodLeader (SpawnInfo, ForceLevel, true, true, InStr(EncounterName,"TER") != -1);
		`LWTRACE ("Swapping Codex leader for" @ SpawnInfo.SelectedCharacterTemplateNames[0]);
	}

	// forces special conditions for avatar to pop
	if (SpawnInfo.SelectedCharacterTemplateNames[0] == 'AdvPsiWitchM3')
	{
		if (XCOMHQ.GetObjectiveStatus('T1_M5_SKULLJACKCodex') != eObjectiveState_Completed)
		{
			switch (EncounterName)
			{
				case 'LoneAvatar' :
				case 'GP_Fortress_AvatarGroup_First_LW' :
				case 'GP_Fortress_AvatarGroup_First' :
					break;
				default:
					swap = true;
					SpawnInfo.SelectedCharacterTemplateNames[0] = SelectNewPodLeader (SpawnInfo, ForceLevel, true, true, InStr(EncounterName,"TER") != -1);
					`LWTRACE ("Swapping Avatar leader for" @ SpawnInfo.SelectedCharacterTemplateNames[0]);
					break;
			}
		}
	}

	// reroll advent captains when the game is forcing captains
	if (RNFSpawnerState != none && InStr(SpawnInfo.SelectedCharacterTemplateNames[0],"Captain") != -1)
	{
		if (XCOMHQ.GetObjectiveStatus('T1_M3_KillCodex') == eObjectiveState_InProgress ||
			XCOMHQ.GetObjectiveStatus('T1_M5_SKULLJACKCodex') == eObjectiveState_InProgress ||
			XCOMHQ.GetObjectiveStatus('T1_M6_KillAvatar') == eObjectiveState_InProgress ||
			XCOMHQ.GetObjectiveStatus('T1_M2_S3_SKULLJACKCaptain') == eObjectiveState_InProgress)
		swap = true;
		SpawnInfo.SelectedCharacterTemplateNames[0] = SelectNewPodLeader (SpawnInfo, ForceLevel, true, true, InStr(EncounterName,"TER") != -1);
		`LWTRACE ("Swapping Reinf Captain leader for" @ SpawnInfo.SelectedCharacterTemplateNames[0]);
	}

	if (PodSize > 1)
	{
		TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
		LeaderCharacterTemplate = TemplateManager.FindCharacterTemplate(SpawnInfo.SelectedCharacterTemplateNames[0]);
		// Find whatever the pod has the most of
		FirstFollowerName = FindMostCommonMember (SpawnInfo.SelectedCharacterTemplateNames);
		FollowerCharacterTemplate = TemplateManager.FindCharacterTemplate(FirstFollowerName);

		`LWTRACE ("Pod Leader:" @ SpawnInfo.SelectedCharacterTemplateNames[0]);
		`LWTRACE ("Pod Follower:" @ FirstFollowerName);

		if (LeaderCharacterTemplate.bIsTurret)
			return;

		if (InStr(EncounterName,"LIST_BOSSx") != -1 && InStr(EncounterName,"_LW") == -1)
		{
			`LWTRACE ("Don't Edit certain vanilla Boss pods");
			return;
		}
		if (Instr(EncounterName,"Chryssalids") != -1)
		{
			`LWTRACE ("Don't edit Chryssypods");
			return;
		}

		// Handle vanilla pod construction of one type of alien follower;
		if (!swap && LeaderCharacterTemplate.bIsAlien && FollowerCharacterTemplate.bIsAlien && CountMembers (FirstFollowerName, SpawnInfo.SelectedCharacterTemplateNames) > 1)
		{
			`LWTRACE ("Mixing up alien-dominant pod");
			swap = true;
		}

		// Check for pod members that shouldn't appear yet for plot reaons
		if (CountMembers ('Cyberus', SpawnInfo.SelectedCharacterTemplateNames) >= 1 && XCOMHQ.GetObjectiveStatus('T1_M2_S3_SKULLJACKCaptain') != eObjectiveState_Completed)
		{
			`LWTRACE ("Removing Codex for objective reasons");
			swap = true;
		}

		if (CountMembers ('AdvPsiWitch', SpawnInfo.SelectedCharacterTemplateNames) >= 1 && XCOMHQ.GetObjectiveStatus('T1_M5_SKULLJACKCodex') != eObjectiveState_Completed)
		{
			`LWTRACE ("Exicising Avatar for objective reasons");
			swap = true;
		}

		if (!swap)
		{
			for (k = 0; k < SpawnInfo.SelectedCharacterTemplateNames.length; k++)
			{
				FollowerCharacterTemplate = TemplateManager.FindCharacterTemplate (SpawnInfo.SelectedCharacterTemplateNames[k]);
				if (CountMembers (SpawnInfo.SelectedCharacterTemplateNames[k], SpawnInfo.SelectedCharacterTemplateNames) > FollowerCharacterTemplate.default.MaxCharactersPerGroup)
				{
					swap = true;
				}
			}
			if (swap)
			{
				`LWTRACE ("Mixing up pod that violates MCPG setting");
			}
		}

		// if size 4 && at least 3 are the same
		if (!swap && (PodSize == 4 || PodSize == 5))
		{
			if (CountMembers (FirstFollowerName, SpawnInfo.SelectedCharacterTemplateNames) >= PodSize - 1)
			{
				`LWTRACE ("Mixing up undiverse 4/5-enemy pod");
				swap = true;
			}
		}

		// if larger && at least size - 2 are the same
		if (!swap && PodSize >= 6)
		{
			// if a max of one guy is different
			if (!swap && CountMembers (FirstFollowerName, SpawnInfo.SelectedCharacterTemplateNames) >= PodSize - 2)
			{
				`LWTRACE ("Mixing up undiverse 5+ enemy pod");
				swap = true;
			}
		}

		if (swap)
		{
			Satisfactory = false;
			Tries = 0;
			While (!Satisfactory && Tries < 12)
			{
				// let's look at
				foreach SpawnInfo.SelectedCharacterTemplateNames(CharacterTemplateName, idx)
				{
					if (idx <= 2)
						continue;

					if (SpawnInfo.SelectedCharacterTemplateNames[idx] != FirstFollowerName)
						continue;

					CurrentCharacterTemplate = TemplateManager.FindCharacterTemplate(SpawnInfo.SelectedCharacterTemplateNames[idx]);
					if (CurrentCharacterTemplate.bIsTurret)
						continue;

					SpawnInfo.SelectedCharacterTemplateNames[idx] = SelectRandomPodFollower (SpawnInfo, LeaderCharacterTemplate.SupportedFollowers, ForceLevel, InStr(EncounterName,"ADVx") == -1, InStr(EncounterName,"Alien") == -1 && InStr(EncounterName,"ALNx") == -1, InStr(EncounterName,"TER") != -1);
				}
				//`LWTRACE ("Try" @ string (tries) @ CountMembers (FirstFollowerName, SpawnInfo.SelectedCharacterTemplateNames) @ string (PodSize));
				// Let's look over our outcome and see if it's any better
				if ((PodSize == 4 || PodSize == 5) && CountMembers (FirstFollowerName, SpawnInfo.SelectedCharacterTemplateNames) >= Podsize - 1)
				{
					Tries += 1;
				}
				else
				{
					if (PodSize >= 6 && CountMembers (FirstFollowerName, SpawnInfo.SelectedCharacterTemplateNames) >= PodSize - 2)
					{
						Tries += 1;
					}
					else
					{
						Satisfactory = true;
					}
				}
			}
			`LWTRACE("Attempted to edit Encounter to add more enemy diversity! Satisfactory:" @ string(satisfactory) @ "New encounter composition:");
			foreach SpawnInfo.SelectedCharacterTemplateNames (CharacterTemplateName, idx)
			{
				`LWTRACE("Character[" $ idx $ "] = " $ CharacterTemplateName);
			}
		}
	}
	return;
}

static function int CountMembers (name CountItem, array<name> ArrayToScan)
{
	local int idx, k;

	k = 0;
	for (idx = 0; idx < ArrayToScan.Length; idx++)
	{
		if (ArrayToScan[idx] == CountItem)
		{
			k += 1;
		}
	}
	return k;
}

static function name FindMostCommonMember (array<name>ArrayToScan)
{
	local int idx, highest, highestidx;
	local array<int> kount;

	kount.length = 0;
	for (idx = 0; idx < ArrayToScan.Length; idx++)
	{
		kount.AddItem(CountMembers(ArrayToScan[idx], ArrayToScan));
	}
	highest = 1;
	for (idx = 0; idx < kount.length; idx ++)
	{
		if (kount[idx] > highest)
		{
			Highest = kount[idx];
			HighestIdx = Idx;
		}
	}
	return ArrayToScan[highestidx];
}


static function name SelectNewPodLeader (PodSpawnInfo SpawnInfo, int ForceLevel, bool AlienAllowed, bool AdventAllowed, bool TerrorAllowed)
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2DataTemplate Template;
	local X2CharacterTemplate CharacterTemplate;
	local array<name> PossibleChars, RestrictedChars;
	local array<float> PossibleWeights;
	local float TotalWeight, TestWeight, RandomWeight;
	local int k;
	local XComGameState_HeadquartersXCom XCOMHQ;

	`LWTRACE ("Initiating SelectNewPodLeader" @ ForceLevel @ AlienAllowed @ AdventAllowed @ TerrorAllowed);

	PossibleChars.length = 0;
	XCOMHQ = XComGameState_HeadquartersXCom(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	foreach CharacterTemplateMgr.IterateTemplates (Template, None)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if (CharacterTemplate == none)
			continue;
		if (!(CharacterTemplate.bIsAdvent || CharacterTemplate.bIsAlien))
			continue;
		if (CharacterTemplate.bIsTurret)
			continue;
		if (!AlienAllowed && CharacterTemplate.bIsAlien)
			continue;
		if (!AdventAllowed && CharacterTemplate.bIsAdvent)
			continue;
		if (CharacterTemplate.DataName == 'Cyberus' && XCOMHQ.GetObjectiveStatus('T1_M2_S3_SKULLJACKCaptain') != eObjectiveState_Completed)
			continue;
		if (CharacterTemplate.DataName == 'AdvPsiWitchM3' && XCOMHQ.GetObjectiveStatus ('T1_M5_SKULLJACKCodex') != eObjectiveState_Completed)
			continue;

		if (!TerrorAllowed)
		{
			for (k = 0; k < class'XComTacticalMissionManager'.default.InclusionExclusionLists.length; k++)
			{
				if (class'XComTacticalMissionManager'.default.InclusionExclusionLists[k].ListID == 'NoTerror_LW')
				{
					RestrictedChars = class'XComTacticalMissionManager'.default.InclusionExclusionLists[k].TemplateName;
				}
			}
			if (RestrictedChars.Find(CharacterTemplate.DataName) != -1)
			{
				continue;
			}
		}
		TestWeight = GetLeaderSpawnWeight(CharacterTemplate, ForceLevel);
		// this is a valid character type, so store off data for later random selection
		if (TestWeight > 0.0)
		{
			PossibleChars.AddItem (CharacterTemplate.DataName);
			PossibleWeights.AddItem (TestWeight);
			TotalWeight += TestWeight;
		}
	}

	if (PossibleChars.length == 0)
	{
		return 'AdvCaptainM1';
	}

	RandomWeight = `SYNC_FRAND_STATIC() * TotalWeight;
	TestWeight = 0.0;
	for (k = 0; k < PossibleChars.length; k++)
	{
		TestWeight += PossibleWeights[k];
		if (RandomWeight < TestWeight)
		{
			return PossibleChars[k];
		}
	}
	return PossibleChars[PossibleChars.length - 1];
}

static function float GetLeaderSpawnWeight(X2CharacterTemplate CharacterTemplate, int ForceLevel)
{
	local int k;
	local float ReturnWeight;
	for (k = 0; k < CharacterTemplate.default.LeaderLevelSpawnWeights.length; k++)
	{
		if (ForceLevel >= CharacterTemplate.default.LeaderLevelSpawnWeights[k].MinForceLevel && ForceLevel <= CharacterTemplate.default.LeaderLevelSpawnWeights[k].MaxForceLevel && CharacterTemplate.default.LeaderLevelSpawnWeights[k].SpawnWeight > 0)
		{
			ReturnWeight += CharacterTemplate.default.LeaderLevelSpawnWeights[k].SpawnWeight;
		}
	}
	return ReturnWeight;
}

static function name SelectRandomPodFollower (PodSpawnInfo SpawnInfo, array<name> SupportedFollowers, int ForceLevel, bool AlienAllowed, bool AdventAllowed, bool TerrorAllowed)
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2DataTemplate Template;
	local X2CharacterTemplate CharacterTemplate;
	local array<name> PossibleChars, RestrictedChars;
	local array<float> PossibleWeights;
	local float TotalWeight, TestWeight, RandomWeight;
	local int k;
	local XComGameState_HeadquartersXCom XCOMHQ;

	PossibleChars.length = 0;
	//`LWTRACE ("Initiating SelectRandomPodFollower" @ ForceLevel @ AlienAllowed @ AdventAllowed @ TerrorAllowed);
	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	foreach CharacterTemplateMgr.IterateTemplates (Template, None)
	{
		CharacterTemplate = X2CharacterTemplate(Template);
		if (CharacterTemplate == none)
			continue;
		if (!(CharacterTemplate.bIsAdvent || CharacterTemplate.bIsAlien))
			continue;
		if (CharacterTemplate.bIsTurret)
			continue;
		if (SupportedFollowers.Find(CharacterTemplate.DataName) == -1)
			continue;
		if (!AlienAllowed && CharacterTemplate.bIsAlien)
			continue;
		if (!AdventAllowed && CharacterTemplate.bIsAdvent)
			continue;

		if (!TerrorAllowed)
		{
			for (k = 0; k < class'XComTacticalMissionManager'.default.InclusionExclusionLists.length; k++)
			{
				if (class'XComTacticalMissionManager'.default.InclusionExclusionLists[k].ListID == 'NoTerror_LW')
				{
					RestrictedChars = class'XComTacticalMissionManager'.default.InclusionExclusionLists[k].TemplateName;
				}
			}
			if (RestrictedChars.Find(CharacterTemplate.DataName) != -1)
			{
				continue;
			}
		}

		if (CountMembers (CharacterTemplate.DataName, SpawnInfo.SelectedCharacterTemplateNames) >= CharacterTemplate.default.MaxCharactersPerGroup)
			continue;

		XCOMHQ = XComGameState_HeadquartersXCom(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

		// don't let cyberuses in yet
		if (CharacterTemplate.DataName == 'Cyberus' && XCOMHQ.GetObjectiveStatus('T1_M2_S3_SKULLJACKCaptain') != eObjectiveState_Completed)
			continue;

		// don't let Avatars in yet
		if (CharacterTemplate.DataName == 'AdvPsiWitchM3' && XCOMHQ.GetObjectiveStatus ('T1_M5_SKULLJACKCodex') != eObjectiveState_Completed)
			continue;

		TestWeight = GetCharacterSpawnWeight(CharacterTemplate, ForceLevel);
		if (TestWeight > 0.0)
		{
			// this is a valid character type, so store off data for later random selection
			PossibleChars.AddItem (CharacterTemplate.DataName);
			PossibleWeights.AddItem (TestWeight);
			TotalWeight += TestWeight;
		}
	}
	if (PossibleChars.length == 0)
	{
		return 'AdvTrooperM1';
	}
	RandomWeight = `SYNC_FRAND_STATIC() * TotalWeight;
	TestWeight = 0.0;
	for (k = 0; k < PossibleChars.length; k++)
	{
		TestWeight += PossibleWeights[k];
		if (RandomWeight < TestWeight)
		{
			return PossibleChars[k];
		}
	}
	return PossibleChars[PossibleChars.length - 1];
}

static function float GetCharacterSpawnWeight(X2CharacterTemplate CharacterTemplate, int ForceLevel)
{
	local int k;
	local float ReturnWeight;
	for (k = 0; k < CharacterTemplate.default.FollowerLevelSpawnWeights.length; k++)
	{
		if (ForceLevel >= CharacterTemplate.default.FollowerLevelSpawnWeights[k].MinForceLevel && ForceLevel <= CharacterTemplate.default.FollowerLevelSpawnWeights[k].MaxForceLevel  && CharacterTemplate.default.FollowerLevelSpawnWeights[k].SpawnWeight > 0)
		{
			ReturnWeight += CharacterTemplate.default.FollowerLevelSpawnWeights[k].SpawnWeight;
		}
	}
	return ReturnWeight;
}

static function PostReinforcementCreation(out name EncounterName, out PodSpawnInfo Encounter, int ForceLevel, int AlertLevel, optional XComGameState_BaseObject SourceObject, optional XComGameState_BaseObject ReinforcementState)
{
}
*/

static event OnExitPostMissionSequence()
{
	CleanupObsoleteTacticalGamestate();
}

static function CleanupObsoleteTacticalGamestate()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameState_BaseObject BaseObject;
	local int idx, idx2;
	local XComGameState ArchiveState;
	local int LastArchiveStateIndex;
	local XComGameInfo GameInfo;
	local array<XComGameState_Item> InventoryItems;
	local XComGameState_Item Item;

	History = `XCOMHISTORY;
	//mark all transient tactical gamestates as removed
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Test remove all ability gamestates");
	// grab the archived strategy state from the history and the headquarters object
	LastArchiveStateIndex = History.FindStartStateIndex() - 1;
	ArchiveState = History.GetGameStateFromHistory(LastArchiveStateIndex, eReturnType_Copy, false);
	GameInfo = `XCOMGAME;
	idx = 0;
	/* WOTC TODO: WOTC no longer seems to have TransientTacticalClassNames, so not sure whether
	   we need to do something here or not.
	foreach ArchiveState.IterateByClassType(class'XComGameState_BaseObject', BaseObject)
	{
		if (GameInfo.TransientTacticalClassNames.Find( BaseObject.Class.Name ) != -1)
		{
			NewGameState.RemoveStateObject(BaseObject.ObjectID);
			idx++;
		}
	}
	*/
	`LWTRACE("REMOVED " $ idx $ " tactical transient gamestates when loading into strategy");
	if (default.ShouldCleanupObsoleteUnits)
	{
		idx = 0;
		idx2 = 0;
		foreach ArchiveState.IterateByClassType(class'XComGameState_Unit', UnitState)
		{
			if (UnitTypeShouldBeCleanedUp(UnitState))
			{
				InventoryItems = UnitState.GetAllInventoryItems(ArchiveState);
				foreach InventoryItems (Item)
				{
					NewGameState.RemoveStateObject (Item.ObjectID);
					idx2++;
				}
				NewGameState.RemoveStateObject (UnitState.ObjectID);
				idx++;
			}
		}
	}
	`LWTRACE("REMOVED " $ idx $ " obsolete enemy unit gamestates when loading into strategy");
	`LWTRACE("REMOVED " $ idx2 $ " obsolete enemy item gamestates when loading into strategy");

	History.AddGameStateToHistory(NewGameState);
}

static function bool UnitTypeShouldBeCleanedUp(XComGameState_Unit UnitState)
{
	local X2CharacterTemplate CharTemplate;
	local name CharTemplateName;
	local int ExcludeIdx;

	CharTemplate = UnitState.GetMyTemplate();
	if (CharTemplate == none) { return false; }
	CharTemplateName = UnitState.GetMyTemplateName();
	if (CharTemplateName == '') { return false; }
	if (class'LWDLCHelpers'.static.IsAlienRuler(CharTemplateName)) { return false; }
	if (!CharTemplate.bIsSoldier)
	{
		if (CharTemplate.bIsAlien || CharTemplate.bIsAdvent || CharTemplate.bIsCivilian)
		{
			ExcludeIdx = default.CharacterTypesExemptFromCleanup.Find(CharTemplateName);
			if (ExcludeIdx == -1)
			{
				return true;
			}
		}
	}
	return false;
}

static function AddObjectivesToParcels()
{
	local XComParcelManager ParcelMgr;
	local PlotDefinition PlotDef;
	local int i, j, k;
	local string Tag; // WOTC DEBUGGING

	// Go over the plot list and add new objectives to certain plots.
	ParcelMgr = `PARCELMGR;
	if (ParcelMgr != none)
	{
		`LWTrace("Modding plot objectives");
		for (i = 0; i < default.PlotObjectiveMods.Length; ++i)
		{
			for (j = 0; j < ParcelMgr.arrPlots.Length; ++j)
			{
				if (ParcelMgr.arrPlots[j].MapName == default.PlotObjectiveMods[i].MapName)
				{
					for (k = 0; k < default.PlotObjectiveMods[i].ObjectiveTags.Length; ++k)
					{
						`LWTrace("Adding objective " $ default.PlotObjectiveMods[i].ObjectiveTags[k] $ " to plot " $ ParcelMgr.arrPlots[j].MapName);
						ParcelMgr.arrPlots[j].ObjectiveTags.AddItem(default.PlotObjectiveMods[i].ObjectiveTags[k]);
					}
					break;
				}
			}
		}

		// Remove a mod-specified set of parcels (e.g. to replace them with modded versions).
		for (i = 0; i < default.ParcelsToRemove.Length; ++i)
		{
			j = ParcelMgr.arrAllParcelDefinitions.Find('MapName', default.ParcelsToRemove[i]);
			if (j >= 0)
			{
				`LWTrace("Removing parcel definition " $ default.ParcelsToRemove[i]);
				ParcelMgr.arrAllParcelDefinitions.Remove(j, 1);
			}
		}
		
		// LWOTC: Add size-based objective tags using the plot name to infer the
		// appropriate tag ('LargePlot' or 'MediumPlot')
		//
		// Note that foreach uses pass-by-value, so we can't modify the objective
		// tags that way.
		for (i = 0; i < ParcelMgr.arrPlots.Length; ++i)
		{
			PlotDef = ParcelMgr.arrPlots[i];
			if ((InStr(PlotDef.MapName, "_LgObj_") != INDEX_NONE || InStr(PlotDef.MapName, "_vlgObj_") != INDEX_NONE)
					&& PlotDef.ObjectiveTags.Find("LargePlot") == INDEX_NONE)
			{
				`LWTrace("Adding 'LargePlot' objective tag to " $ PlotDef.MapName);
				ParcelMgr.arrPlots[i].ObjectiveTags.AddItem("LargePlot");
			}
			else if (InStr(PlotDef.MapName, "_MdObj_") != INDEX_NONE && PlotDef.ObjectiveTags.Find("MediumPlot") == INDEX_NONE)
			{
				`LWTrace("Adding 'MediumPlot' objective tag to " $ PlotDef.MapName);
				ParcelMgr.arrPlots[i].ObjectiveTags.AddItem("MediumPlot");
			}
		}
		
		i = 0;
	}
}

static function InitializePodManager(XComGameState StartGameState)
{
	local XComGameState_LWPodManager PodManager;

	PodManager = XComGameState_LWPodManager(StartGameState.CreateStateObject(class'XComGameState_LWPodManager'));
	`LWTrace("Created pod manager");
	StartGameState.AddStateObject(PodManager);
}

// Start missions unconcealed if infiltration is below 100% and the mission type
// is configured as such.
static function OverrideConcealmentAtStart(XComGameState_MissionSite MissionState)
{
	local XComGameState_LWPersistentSquad	SquadState;
	local XComGameState_BattleData			BattleData;
	local int k;

	// If within a configurable list of mission types, and infiltration below a set value, set it to true
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	for (k = 0; k < default.MINIMUM_INFIL_FOR_CONCEAL.length; k++)
	{
		if (MissionState.GeneratedMission.Mission.sType == default.MINIMUM_INFIL_FOR_CONCEAL[k].MissionType)
		{
			SquadState = `LWSQUADMGR.GetSquadOnMission(MissionState.GetReference());
			//`LWTRACE ("CheckForConcealOverride: Mission Type correct. Infiltration:" @ SquadState.CurrentInfiltration);
			If (SquadState.CurrentInfiltration < default.MINIMUM_INFIL_FOR_CONCEAL[k].MinInfiltration)
			{
				`LWTRACE ("OverrideConcealmentAtStart: Conditions met to start squad revealed");
				BattleData.bForceNoSquadConcealment = true;
			}
		}
	}
}

static function OverrideDestructibleHealths(XComGameState StartGameState)
{
	local XComContentManager ContentMgr;
	local ArchetypeToHealth DestructibleActorConfig;
	local XComDestructibleActor_Toughness Toughness;
	local int CurrentDifficulty;

	ContentMgr = `CONTENT;
	CurrentDifficulty = `TacticalDifficultySetting;
	foreach default.DestructibleActorHealthOverride(DestructibleActorConfig)
	{
		Toughness = XComDestructibleActor_Toughness(ContentMgr.RequestGameArchetype(DestructibleActorConfig.ArchetypeName));
		if (Toughness != none && (DestructibleActorConfig.Difficulty == CurrentDifficulty || DestructibleActorConfig.Difficulty == -1))
		{
			`LWTrace("Updating" @ DestructibleActorConfig.ArchetypeName @ "max health to" @ DestructibleActorConfig.Health);
			Toughness.Health = DestructibleActorConfig.Health;
		}
	}
}

// WOTC TODO: Perhaps this is supposed to honour the SpawnSizeOverride parameter somehow. Seems to work
// though (a 10-man squad on first mission spawned OK)
//enlarge the deployable area so can spawn more units
static function bool GetValidFloorSpawnLocations(out array<Vector> FloorPoints, float SpawnSizeOverride, XComGroupSpawn SpawnPoint)
{
	local TTile RootTile, Tile;
	local array<TTile> FloorTiles;
	local XComWorldData World;
	local int Length, Width, Height, NumSoldiers, Iters;
	local bool Toggle;

	Length = 3;
	Width = 3;
	Height = 1;
	Toggle = false;
	if(`XCOMHQ != none)
		NumSoldiers = `XCOMHQ.Squad.Length;
	else
		NumSoldiers = class'X2StrategyGameRulesetDataStructures'.static.GetMaxSoldiersAllowedOnMission();

	// For TQL, etc, where the soldier are coming from the Start State, always reserve space for 8 soldiers
	if (NumSoldiers == 0)
		NumSoldiers = 8;

	// On certain mission types we need to reserve space for more units in the spawn area.
	switch (class'Utilities_LW'.static.CurrentMissionType())
	{
	case "RecruitRaid_LW":
		// Recruit raid spawns rebels with the squad, so we need lots of space for the rebels + liaison.
		NumSoldiers += class'X2StrategyElement_DefaultAlienActivities'.default.RAID_MISSION_MAX_REBELS + 1;
		break;
	case "Terror_LW":
	case "Defend_LW":
	case "Invasion_LW":
	case "IntelRaid_LW":
	case "SupplyConvoy_LW":
	case "Rendezvous_LW":
		// Reserve space for the liaison
		++NumSoldiers;
		break;
	}

	if (NumSoldiers >= 6)
	{
		Length = 4;
		Iters--;
	}
	if (NumSoldiers >= 9)
	{
		Width = 4;
		Iters--;
	}
	if (NumSoldiers >= 12)
	{
		Length = 5;
		Width = 5;
	}
	World = `XWORLD;
	RootTile = SpawnPoint.GetTile();
	while(FloorPoints.Length < NumSoldiers && Iters++ < 8)
	{
		FloorPoints.Length = 0;
		FloorTiles.Length = 0;
		RootTile.X -= Length/2;
		RootTile.Y -= Width/2;

		World.GetSpawnTilePossibilities(RootTile, Length, Width, Height, FloorTiles);

		foreach FloorTiles(Tile)
		{
			// Skip any tile that is going to be destroyed on tactical start.
			if (IsTilePositionDestroyed(Tile))
				continue;
			FloorPoints.AddItem(World.GetPositionFromTileCoordinates(Tile));
		}
		if(Toggle)
			Width ++;
		else
			Length ++;

		Toggle = !Toggle;
	}

	`LWTRACE("GetValidFloorSpawnLocations called from : " $ GetScriptTrace());
	`LWTRACE("Found " $ FloorPoints.Length $ " Valid Tiles to place units around location : " $ string(SpawnPoint.Location));
	for (Iters = 0; Iters < FloorPoints.Length; Iters++)
	{
		`LWTRACE("Point[" $ Iters $ "] = " $ string(FloorPoints[Iters]));
	}

	return true;
}

// The XComTileDestructionActor contains a list of positions that it will destroy before the mission starts.
// These will report as valid floor tiles at the point we are searching for valid spawn tiles (because they
// are, now) but after the mission starts their tile will disappear and they will be unable to move.
//
// Given a potential spawn floor tile, check to see if this tile will be destroyed on mission start, so we
// can exclude them as candidates.
static function bool IsTilePositionDestroyed(TTile Tile)
{
	local XComTileDestructionActor TileDestructionActor;
	local Vector V;
	local IntPoint ParcelBoundsMin, ParcelBoundsMax;
	local XComGameState_BattleData BattleData;
	local XComParcelManager ParcelManager;
	local XComWorldData World;
	local XComParcel Parcel;
	local int i;
	local TTile DestroyedTile;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	ParcelManager = `PARCELMGR;
	World = `XWORLD;

	// Find the parcel containing this tile.
	for (i = 0; i < BattleData.MapData.ParcelData.Length; ++i)
	{
		Parcel = ParcelManager.arrParcels[BattleData.MapData.ParcelData[i].ParcelArrayIndex];

		// Find the parcel this tile is in.
		Parcel.GetTileBounds(ParcelBoundsMin, ParcelBoundsMax);
		if (Tile.X >= ParcelBoundsMin.X && Tile.X <= ParcelBoundsMax.X &&
			Tile.Y >= ParcelBoundsMin.Y && Tile.Y <= ParcelBoundsMax.Y)
		{
			break;
		}
	}

	foreach `BATTLE.AllActors(class'XComTileDestructionActor', TileDestructionActor)
	{
		foreach TileDestructionActor.PositionsToDestroy(V)
		{
			// The vectors within the XComTileDestructionActor are relative to the origin
			// of the associated parcel itself. So each destroyed position needs to be rotated
			// and translated based on the location of the destruction actor before we look up
			// the tile position to account for the particular map layout.
			V = V >> TileDestructionActor.Rotation;
			V += TileDestructionActor.Location;
			DestroyedTile = World.GetTileCoordinatesFromPosition(V);
			if (DestroyedTile == Tile)
			{
				return true;
			}
		}
	}

	return false;
}

// Clean up any stale delayed evac spawners that may be left over from a previous mission that ended while
// a counter was active.
static function ResetDelayedEvac(XComGameState StartGameState)
{
	local XComGameState_LWEvacSpawner EvacState;

	EvacState = XComGameState_LWEvacSpawner(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWEvacSpawner', true));

	if (EvacState != none && EvacState.GetCountdown() >= 0)
	{
		EvacState = XComGameState_LWEvacSpawner(StartGameState.CreateStateObject(class'XComGameState_LWEvacSpawner', EvacState.ObjectID));
		EvacState.ResetCountdown();
		StartGameState.AddStateObject(EvacState);
	}
}

// Reset the reinforcements system for the new mission.
static function ResetReinforcements(XComGameState StartGameState)
{
	local XComGameState_LWReinforcements Reinforcements;

	Reinforcements = XComGameState_LWReinforcements(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWReinforcements', true));

	if (Reinforcements == none)
	{
		Reinforcements = XComGameState_LWReinforcements(StartGameState.CreateStateObject(class'XComGameState_LWReinforcements'));
	}
	else
	{
		Reinforcements = XComGameState_LWReinforcements(StartGameState.CreateStateObject(class'XComGameState_LWReinforcements', Reinforcements.ObjectID));
	}

	Reinforcements.Reset();
	StartGameState.AddStateObject(Reinforcements);
}


// ******** Starting mission (Gate Crasher) ******** //

// The starting mission uses `X2StrategyGameRulesetDataStructures.m_iMaxSoldiersOnMission`
// for the starting squad size, but this is probably (the values are configurable) larger
// than the squad size we actually want to start with.
//
// This method truncates the active squad in XComGameState_HeadquartersXCom if it's too large.
static function LimitStartingSquadSize(XComGameState StartState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	`Log("Limiting starting squad size");

	if (class'XComGameState_LWSquadManager'.default.MAX_FIRST_MISSION_SQUAD_SIZE <= 0) // 0 or less means unlimited
	{
		return;
	}

	foreach StartState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}
	`Log("Current squad size = " $ XComHQ.Squad.Length);
	if (XComHQ.Squad.Length > class'XComGameState_LWSquadManager'.default.MAX_FIRST_MISSION_SQUAD_SIZE)
	{
		XComHQ.Squad.Length = class'XComGameState_LWSquadManager'.default.MAX_FIRST_MISSION_SQUAD_SIZE;
		`Log("After adjustment = " $ XComHQ.Squad.Length);
	}
}

static function UpdateFirstMissionTemplate()
{
	local X2StrategyElementTemplateManager TemplateMgr;
	local X2ObjectiveTemplate Template;

	TemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	Template = X2ObjectiveTemplate(TemplateMgr.FindStrategyElementTemplate('T1_M0_FirstMission'));
	if(Template == none)
		return;

	//Template.AddNarrativeTrigger("X2NarrativeMoments.Strategy.GP_WelcomeToTheLabsShort", NAW_OnCompletion, 'OnEnteredFacility_CommandersQuarters', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.AddNarrativeTrigger("LWNarrativeMoments_Bink.TACTICAL.CIN_WelcomeToTheResistance_LW", NAW_OnCompletion, 'OnEnteredFacility_CommandersQuarters', '', ELD_OnStateSubmitted, NPC_Once, '');
	Template.CompleteObjectiveFn = FirstMissionComplete;
}

// add TriggerNeedsAttention to Commander's quarters for the new WelcomeToResistance
static function FirstMissionComplete(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom CommandersQuarters;
	local int idx;

	class'X2StrategyElement_DefaultObjectives'.static.FirstMissionComplete(NewGameState, ObjectiveState);

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	for( idx = 0; idx < XComHQ.Facilities.Length; idx++ )
	{
		CommandersQuarters = XComGameState_FacilityXCom(History.GetGameStateForObjectID(XComHQ.Facilities[idx].ObjectID));

		if( CommandersQuarters.GetMyTemplateName() == 'CommandersQuarters' )
		{
			CommandersQuarters = XComGameState_FacilityXCom(NewGameState.CreateStateObject(class'XComGameState_FacilityXCom', CommandersQuarters.ObjectID));
			NewGameState.AddStateObject(CommandersQuarters);
			CommandersQuarters.TriggerNeedsAttention();
		}
	}
	`HQPRES.m_kFacilityGrid.UpdateData();
}

// ******** HANDLE CUSTOM WEAPON RESTRICTIONS ******** //

// Disable heavy weapons items based on soldier class
static function bool CanAddItemToInventory_CH_Improved(
	out int bCanAddItem,
	const EInventorySlot Slot,
	const X2ItemTemplate ItemTemplate,
	int Quantity,
	XComGameState_Unit UnitState,
	optional XComGameState CheckGameState,
	optional out string DisabledReason,
	optional XComGameState_Item ItemState)
{
	local X2SoldierClassTemplate SoldierClassTemplate;
	local X2WeaponTemplate WeaponTemplate;
	local int i;

	SoldierClassTemplate = UnitState.GetSoldierClassTemplate();

	// Ignore all slots other than HeavyWeapons and any units that don't have
	// a soldier class template (like ADVENT Rocketeers!)
	if (Slot != eInvSlot_HeavyWeapon || SoldierClassTemplate == none)
	{
		// We want this hook to be ignored from both the armory
		// screen and the unit's CanAddItemToInventory() method,
		// but they expect different return values to indicate
		// that. CheckGameState is the only way to distinguish
		// between them.
		return CheckGameState == none;
	}

	WeaponTemplate = X2WeaponTemplate(ItemTemplate);
	
	for (i = 0; i < SoldierClassTemplate.AllowedWeapons.Length; ++i)
	{
		if (WeaponTemplate.WeaponCat == SoldierClassTemplate.AllowedWeapons[i].WeaponType)
		{
			// We think the item can be added, but we should leave it to
			// the default base game logic to make the final determination.
			// Otherwise we would have to handle the case where a weapon is
			// already in the slot. We would also have to consider that the
			// highlander supports multiple heavy weapons on a soldier.
			return CheckGameState == none;
		}
	}
	
	// The soldier class isn't allowed to use this weapon
	DisabledReason = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(
		`XEXPAND.ExpandString(class'UIArmory_Loadout'.default.m_strUnavailableToClass));
	bCanAddItem = 0;
	return CheckGameState != none;  // false if called from armory, true if called from XCGS_Unit
}

// ******** HANDLE SECONDARY WEAPON VISUALS ******** //

// append sockets to the human skeletal meshes for the new secondary weapons
static function string DLCAppendSockets(XComUnitPawn Pawn)
{
	local SocketReplacementInfo SocketReplacement;
	local name TorsoName;
	local bool bIsFemale;
	local string DefaultString, ReturnString;
	local XComHumanPawn HumanPawn;

	HumanPawn = XComHumanPawn(Pawn);
	if (HumanPawn == none) { return ""; }

	TorsoName = HumanPawn.m_kAppearance.nmTorso;
	bIsFemale = HumanPawn.m_kAppearance.iGender == eGender_Female;

	//`LWTRACE("DLCAppendSockets: Torso= " $ TorsoName $ ", Female= " $ string(bIsFemale));

	foreach default.SocketReplacements(SocketReplacement)
	{
		if (TorsoName != 'None' && TorsoName == SocketReplacement.TorsoName && bIsFemale == SocketReplacement.Female)
		{
			ReturnString = SocketReplacement.SocketMeshString;
			break;
		}
		else
		{
			if (SocketReplacement.TorsoName == 'Default' && SocketReplacement.Female == bIsFemale)
			{
				DefaultString = SocketReplacement.SocketMeshString;
			}
		}
	}
	if (ReturnString == "")
	{
		// did not find, so use default
		ReturnString = DefaultString;
	}
	//`LWTRACE("Returning mesh string: " $ ReturnString);
	return ReturnString;
}

// ******** HANDLE UPDATING WEAPON ATTACHMENTS ************* //

// WOTC TODO: Called from highlander - check whether CHL does it
// always allow removal of weapon upgrades
static function bool CanRemoveWeaponUpgrade(XComGameState_Item Weapon, X2WeaponUpgradeTemplate UpgradeTemplate, int SlotIndex)
{
	if (UpgradeTemplate == none)
		return false;
	else
		return true;
}

// This provides the artwork/assets for weapon attachments for SMGs
static function UpdateWeaponAttachmentsForCoilgun()
{
	local X2ItemTemplateManager ItemTemplateManager;

	//get access to item template manager to update existing upgrades
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if (ItemTemplateManager == none) {
		`Redscreen("LW Coilguns : failed to retrieve ItemTemplateManager to configure upgrades");
		return;
	}

	AddCritUpgrade(ItemTemplateManager, 'CritUpgrade_Bsc');
	AddCritUpgrade(ItemTemplateManager, 'CritUpgrade_Adv');
	AddCritUpgrade(ItemTemplateManager, 'CritUpgrade_Sup');

	AddAimBonusUpgrade(ItemTemplateManager, 'AimUpgrade_Bsc');
	AddAimBonusUpgrade(ItemTemplateManager, 'AimUpgrade_Adv');
	AddAimBonusUpgrade(ItemTemplateManager, 'AimUpgrade_Sup');

	AddClipSizeBonusUpgrade(ItemTemplateManager, 'ClipSizeUpgrade_Bsc');
	AddClipSizeBonusUpgrade(ItemTemplateManager, 'ClipSizeUpgrade_Adv');
	AddClipSizeBonusUpgrade(ItemTemplateManager, 'ClipSizeUpgrade_Sup');

	AddFreeFireBonusUpgrade(ItemTemplateManager, 'FreeFireUpgrade_Bsc');
	AddFreeFireBonusUpgrade(ItemTemplateManager, 'FreeFireUpgrade_Adv');
	AddFreeFireBonusUpgrade(ItemTemplateManager, 'FreeFireUpgrade_Sup');

	AddReloadUpgrade(ItemTemplateManager, 'ReloadUpgrade_Bsc');
	AddReloadUpgrade(ItemTemplateManager, 'ReloadUpgrade_Adv');
	AddReloadUpgrade(ItemTemplateManager, 'ReloadUpgrade_Sup');

	AddMissDamageUpgrade(ItemTemplateManager, 'MissDamageUpgrade_Bsc');
	AddMissDamageUpgrade(ItemTemplateManager, 'MissDamageUpgrade_Adv');
	AddMissDamageUpgrade(ItemTemplateManager, 'MissDamageUpgrade_Sup');

	AddFreeKillUpgrade(ItemTemplateManager, 'FreeKillUpgrade_Bsc');
	AddFreeKillUpgrade(ItemTemplateManager, 'FreeKillUpgrade_Adv');
	AddFreeKillUpgrade(ItemTemplateManager, 'FreeKillUpgrade_Sup');
}


static function AddCritUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticB", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SMG
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticB", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Shotgun
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BeamShotgun.Meshes.SM_BeamShotgun_OpticB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticB", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Cannon
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "LWCannon_CG.Meshes.LW_CoilCannon_OpticB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

}

static function AddAimBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticC", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SMG
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticC", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Shotgun
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BeamShotgun.Meshes.SM_BeamShotgun_OpticC", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticC", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Cannon
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "LWCannon_CG.Meshes.LW_CoilCannon_OpticC", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

}

static function AddClipSizeBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagB", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	//SMG
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagB", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	// Shotgun
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	// Sniper Rifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagB", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	// Cannon
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

}

static function AddFreeFireBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	//SMG
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Shotgun
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Sniper
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Cannon
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_ReargripB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_ReargripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

}

static function AddReloadUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagC", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagD", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	//SMG
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagC", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagD", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Shotgun
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagC", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagC", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagD", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Sniper
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagC", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagD", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Cannon
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagC", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagC", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagD", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

}

static function AddMissDamageUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_StockB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	//SMG
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_StockB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Shotgun
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_StockB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockC", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_StockC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_StockC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Cannon
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "LWCannon_CG.Meshes.LW_CoilCannon_StockB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_StockB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('StockSupport', '', "LWCannon_CG.Meshes.LW_CoilCannon_StockSupportB", "", 'Cannon_CG');

}

static function AddFreeKillUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_Silencer", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	//SMG
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_Silencer", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Shotgun
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "LWShotgun_CG.Meshes.LW_CoilShotgun_Suppressor", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "LWSniperRifle_CG.Meshes.LW_CoilSniper_Suppressor", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Cannon
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Cannon_Suppressor', "LWCannon_CG.Meshes.LW_CoilCannon_Suppressor", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

}


// ******** HANDLE UPDATING STORAGE & TECH ************* //
// This handles updating storage in order to create new unlimited items of various flavors
static function UpdateStorage()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateMgr;
	local name ItemName;
	local bool bAddedAnyItem;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add items");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	bAddedAnyItem = false;

	foreach class'LWTemplateMods'.default.UnlimitedItemsAdded(ItemName)
	{
	if(AddItemToStorage(ItemName, ItemTemplateMgr, XComHQ, NewGameState))
		bAddedAnyItem = true;
	}

	if(bAddedAnyItem)
		History.AddGameStateToHistory(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);


	//schematics should be handled already, as the BuildItem UI draws from ItemTemplates, which are automatically loaded
}

static function bool AddItemToStorage(name ItemTemplateName, X2ItemTemplateManager ItemTemplateMgr, XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item NewItemState;

	`LWTRACE("Searching for item template:" @ ItemTemplateName);
	ItemTemplate = ItemTemplateMgr.FindItemTemplate(ItemTemplateName);
	if(ItemTemplate != none)
	{
		`LWTRACE("Found item template:" @ ItemTemplateName);
		if (!XComHQ.HasItem(ItemTemplate))
		{
			`LWTRACE(ItemTemplateName $ " not found, adding to inventory");
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);
			return true;
		} else {
			`LWTRACE(ItemTemplateName $ " found, skipping inventory add");
			return false;
		}
	}
}

// WOTC TODO: Is this necessary? Was called from `OnLoadSavedGame()` and still called
// from `UIScreenListener_AvengerHUD`
static function UpdateTechs()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local array<X2StrategyElementTemplate> arrTechTemplates;
	local XComGameState_Tech TechStateObject;
	local X2TechTemplate TechTemplate;
	local int idx;
	//local array<XComGameState_Tech> AllTechGameStates;
	local array<name> AllTechGameStateNames;
	local XComGameState_Tech TechState;
	local bool bUpdatedAnyTech;

	History = `XCOMHISTORY;

	// Grab all existing tech gamestates
	foreach History.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		//AllTechGameStates.AddItem(TechState);
		AllTechGameStateNames.AddItem(TechState.GetMyTemplateName());
	}

	// Grab all Tech Templates
	arrTechTemplates = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().GetAllTemplatesOfClass(class'X2TechTemplate');

	if(arrTechTemplates.Length == AllTechGameStateNames.Length)
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding new tech gamestates");

	// Iterate through the templates and build each Tech State Object, if it hasn't been already built
	for(idx = 0; idx < arrTechTemplates.Length; idx++)
	{
		TechTemplate = X2TechTemplate(arrTechTemplates[idx]);

		if(AllTechGameStateNames.Find(TechTemplate.DataName) != -1)
			continue;

		if (TechTemplate.RewardDeck != '')
		{
			class'XComGameState_Tech'.static.SetUpTechRewardDeck(TechTemplate);
		}

		bUpdatedAnyTech = true;

		`LOG("Adding new tech gamestate: " $ TechTemplate.DataName);

		TechStateObject = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
		TechStateObject.OnCreation(X2TechTemplate(arrTechTemplates[idx]));
		NewGameState.AddStateObject(TechStateObject);
	}

	if(bUpdatedAnyTech)
		History.AddGameStateToHistory(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

//=========================================================================================
//================= BEGIN LONG WAR ABILITY TAG HANDLER ====================================
//=========================================================================================

// PLEASE LEAVE THIS FUNCTION AT THE BOTTOM OF THE FILE FOR EASY FINDING - JL

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;
	local UITacticalHUD TacticalHUD;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local int NumTiles;

	Type = name(InString);
	switch(Type)
	{
		case 'EVACDELAY_LW':
			OutString = string(class'X2Ability_PlaceDelayedEvacZone'.static.GetEvacDelay());
			return true;
		case 'INDEPENDENT_TRACKING_BONUS_TURNS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.INDEPENDENT_TARGETING_NUM_BONUS_TURNS);
			return true;
		case 'HOLO_CV_AIM_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HOLO_CV_AIM_BONUS);
			return true;
		case 'HOLO_MG_AIM_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HOLO_MG_AIM_BONUS);
			return true;
		case 'HOLO_BM_AIM_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HOLO_BM_AIM_BONUS);
			return true;
		case 'HDHOLO_CV_CRIT_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HDHOLO_CV_CRIT_BONUS);
			return true;
		case 'HDHOLO_MG_CRIT_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HDHOLO_MG_CRIT_BONUS);
			return true;
		case 'HDHOLO_BM_CRIT_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HDHOLO_BM_CRIT_BONUS);
			return true;
		case 'VITAL_POINT_CV_BONUS_DMG_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_BASEDAMAGE.Damage);
			if (class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_BASEDAMAGE.PlusOne > 0)
			{
				Outstring $= ".";
				Outstring $= string (class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_BASEDAMAGE.PlusOne);
			}
			return true;
		case 'VITAL_POINT_MG_BONUS_DMG_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_BASEDAMAGE.Damage);
			if (class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_BASEDAMAGE.PlusOne > 0)
			{
				Outstring $= ".";
				Outstring $= string (class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_BASEDAMAGE.PlusOne);
			}
			return true;
		case 'VITAL_POINT_BM_BONUS_DMG_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_BASEDAMAGE.Damage);
			if (class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_BASEDAMAGE.PlusOne > 0)
			{
				Outstring $= ".";
				Outstring $= string (class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_BASEDAMAGE.PlusOne);
			}
			return true;
		case 'MULTI_HOLO_CV_RADIUS_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_RADIUS);
			return true;
		case 'MULTI_HOLO_MG_RADIUS_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_RADIUS);
			return true;
		case 'MULTI_HOLO_BM_RADIUS_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_RADIUS);
			return true;
		case 'RAPID_TARGETING_COOLDOWN_LW':
			OutString = string(class'X2Ability_LW_SharpshooterAbilitySet'.default.RAPID_TARGETING_COOLDOWN);
			return true;
		case 'MULTI_TARGETING_COOLDOWN_LW':
			OutString = string(class'X2Ability_LW_SharpshooterAbilitySet'.default.MULTI_TARGETING_COOLDOWN);
			return true;
		case 'HIGH_PRESSURE_CHARGES_LW':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.FLAMETHROWER_HIGH_PRESSURE_CHARGES);
			return true;
		case 'FLAMETHROWER_CHARGES_LW':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.FLAMETHROWER_CHARGES);
			return true;
		case 'FIRESTORM_DAMAGE_BONUS_LW':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.FIRESTORM_DAMAGE_BONUS);
			return true;
		case 'NANOFIBER_HEALTH_BONUS_LW':
			Outstring = string(class'X2Ability_ItemGrantedAbilitySet'.default.NANOFIBER_VEST_HP_BONUS);
			return true;
		case 'NANOFIBER_CRITDEF_BONUS_LW':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.NANOFIBER_CRITDEF_BONUS);
			return true;
		case 'ALPHA_MIKE_FOXTROT_DAMAGE_LW':
			Outstring = string(class'X2Ability_LW_SharpshooterAbilitySet'.default.ALPHAMIKEFOXTROT_DAMAGE);
			return true;
		case 'ROCKETSCATTER':
			TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
			if (TacticalHUD != none)
				UnitRef = XComTacticalController(TacticalHUD.PC).GetActiveUnitStateRef();
			if (UnitRef.ObjectID > 0)
				UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

			if (TacticalHUD != none && TacticalHUD.GetTargetingMethod() != none && UnitState != none)
			{
				NumTiles = class'X2Ability_LW_TechnicalAbilitySet'.static.GetNumAimRolls(UnitState);
				Outstring = class'X2Ability_LW_TechnicalAbilitySet'.default.strMaxScatter $ string(NumTiles);
			}
			else
			{
				Outstring = "";
			}
			return true;
		case 'FORTIFY_DEFENSE_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.FORTIFY_DEFENSE);
			return true;
		case 'FORTIFY_COOLDOWN_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.FORTIFY_COOLDOWN);
			return true;
		case 'COMBAT_FITNESS_HP_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_HP);
			return true;
		case 'COMBAT_FITNESS_OFFENSE_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_OFFENSE);
			return true;
		case 'COMBAT_FITNESS_MOBILITY_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_MOBILITY);
			return true;
		case 'COMBAT_FITNESS_DODGE_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_DODGE);
			return true;
		case 'COMBAT_FITNESS_WILL_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_WILL);
			return true;
		case 'COMBAT_FITNESS_DEFENSE_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_DEFENSE);
			return true;
		case 'COMBATIVES_DODGE_LW':
			Outstring = string(class'X2Ability_LW_GunnerAbilitySet'.default.COMBATIVES_DODGE);
			return true;
		case 'SPRINTER_MOBILITY_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.SPRINTER_MOBILITY);
			return true;
		default:
			return false;
	}
}

//=========================================================================================
//================== BEGIN EXEC LONG WAR CONSOLE EXEC =====================================
//=========================================================================================

// this spawns a debug activity with a specified mission
exec function LWForceMission(String ForcedMissionType, optional name PrimaryRegionName)
{
	local StateObjectReference PrimaryRegionRef;
	local XComGameState_LWAlienActivity NewActivityState;
	local int MissionIndex;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local X2StrategyElementTemplateManager StrategyElementTemplateMgr;
	local XComGameState NewGameState;
	local MissionDefinition ForceMission;

	missionIndex = -1;
	if (Len(ForcedMissionType) > 0)
	{
		MissionIndex = `TACTICALMISSIONMGR.arrMissions.Find('sType', ForcedMissionType);
		`Log("ForcedMissionType " $ ForcedMissionType $ " = " $ MissionIndex);
	}

	StrategyElementTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	ActivityTemplate = X2LWAlienActivityTemplate(StrategyElementTemplateMgr.FindStrategyElementTemplate(class'X2StrategyElement_DefaultAlienActivities'.default.DebugMissionName));
	if (ActivityTemplate == none)
	{
		`Log("LWForceMission: Failed to find debug activity template");
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Spawn Activity for Mission");
	if(PrimaryRegionName == '')
		PrimaryRegionRef = GetRandomContactedRegion().GetReference();
	else
		PrimaryRegionRef = FindRegionByName(PrimaryRegionName).GetReference();

	if(PrimaryRegionRef.ObjectID > 0)
	{
		if (MissionIndex >= 0)
		{
			ForceMission = `TACTICALMISSIONMGR.arrMissions[MissionIndex];
			NewActivityState = ActivityTemplate.CreateInstanceFromTemplate(PrimaryRegionRef, NewGameState, ForceMission);
		}
		else
		{
			NewActivityState = ActivityTemplate.CreateInstanceFromTemplate(PrimaryRegionRef, NewGameState);
		}
		NewGameState.AddStateObject(NewActivityState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}
}

function XComGameState_WorldRegion GetRandomContactedRegion()
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local array<XComGameState_WorldRegion> ValidRegions, AllRegions;

	History = `XCOMHISTORY;

		foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
			AllRegions.AddItem(RegionState);

			if(RegionState.ResistanceLevel >= eResLevel_Contact)
			{
				ValidRegions.AddItem(RegionState);
			}
		}

	if(ValidRegions.Length > 0)
	{
		return ValidRegions[`SYNC_RAND(ValidRegions.Length)];
	}

	return AllRegions[`SYNC_RAND(AllRegions.Length)];
}

// this force-spawns a designated activity by name, with option to force a primary region
exec function LWSpawnActivity(name TemplateName, optional name PrimaryRegionName, optional bool ForceDetect)
{
	local StateObjectReference PrimaryRegionRef;
	local XComGameState_LWAlienActivity NewActivityState;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local X2StrategyElementTemplateManager StrategyElementTemplateMgr;
	local XComGameState NewGameState;

	StrategyElementTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	ActivityTemplate = X2LWAlienActivityTemplate(StrategyElementTemplateMgr.FindStrategyElementTemplate(TemplateName));
	if (ActivityTemplate == none)
	{
		`Log("SpawnActivity: Failed to find activity template" @ TemplateName);
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Spawn Activity");
	if(PrimaryRegionName == '')
	{
		ActivityTemplate.ActivityCreation.InitActivityCreation(ActivityTemplate, NewGameState);
		ActivityTemplate.ActivityCreation.GetNumActivitiesToCreate(NewGameState);
		PrimaryRegionRef = ActivityTemplate.ActivityCreation.GetBestPrimaryRegion(NewGameState);
	}
	else
		PrimaryRegionRef = FindRegionByName(PrimaryRegionName).GetReference();

	if(PrimaryRegionRef.ObjectID > 0)
	{
		NewActivityState = ActivityTemplate.CreateInstanceFromTemplate(PrimaryRegionRef, NewGameState);
		NewGameState.AddStateObject(NewActivityState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		`Log("SpawnActivity: Failed to valid Primary Region");
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}

	if (ForceDetect)
	{
		LWForceActivityDetection(TemplateName, PrimaryRegionName);
	}
}

function XComGameState_WorldRegion FindRegionByName(name RegionName)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionState.GetMyTemplateName() == RegionName)
			return RegionState;
	}
	return none;
}

// this method auto-advances an activity to the next mission
exec function LWAdvanceActivity(Name ActivityTemplateName, name PrimaryRegion, optional bool bWin = true)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	//local XComGameState_LWAlienActivityManager ActivityMgr;
	local XComGameState_LWAlienActivity ActivityState, UpdatedActivity;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_MissionSite MissionState;
	local X2MissionSourceTemplate MissionSource;
	local bool bFound;

	History = `XCOMHISTORY;
	//ActivityMgr = class'XComGameState_LWAlienActivityManager'.static.GetAlienActivityManager();
	//find the specified activity in the specified region
	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if(ActivityState.GetMyTemplateName() == ActivityTemplateName)
		{
			RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
			if(RegionState.GetMyTemplateName() == PrimaryRegion)
			{
				bFound = true;
				break;
			}
		}
	}
	if(!bFound)
	{
		`LOG("LWAdvanceActivity : could not find Activity" @ ActivityTemplateName @ "in region" @  PrimaryRegion);
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Advance Activity");

	//clean up the existing mission
	if(ActivityState.CurrentMissionRef.ObjectID > 0)
	{
		MissionState = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', ActivityState.CurrentMissionRef.ObjectID));
		NewGameState.AddStateObject(MissionState);
	}

	//Update Activity
	UpdatedActivity = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', ActivityState.ObjectID));
	NewGameState.AddStateObject(UpdatedActivity);

	//advance the activity
	MissionSource = MissionState.GetMissionSource();
	if(bWin)
	{
		MissionSource.OnSuccessFn(NewGameState, MissionState);
	}
	else
	{
		MissionSource.OnFailureFn(NewGameState, MissionState);
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

//this overrides the usual detection mechanism to force an activity to be immediately detected
exec function LWForceActivityDetection(name ActivityName, name RegionName)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_LWAlienActivity ActivityState, UpdatedActivity;
	local XComGameState_WorldRegion RegionState;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Force Activity Detection");

	//find the specified activity in the specified region
	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if(ActivityState.GetMyTemplateName() == ActivityName)
		{
			RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
			if(RegionState.GetMyTemplateName() == RegionName)
			{

				UpdatedActivity = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', ActivityState.ObjectID));
				NewGameState.AddStateObject(UpdatedActivity);

				//mark the activity to be detected the next time geoscape update runs
				UpdatedActivity.bNeedsUpdateDiscovery = true;
				break;
			}
		}
	}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

// this dumps activities to the log
exec function LWDumpActivityLog(optional name Region)
{
	local XComGameStateHistory History;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_WorldRegion RegionState;

	History = `XCOMHISTORY;
	//ActivityMgr = class'XComGameState_LWAlienActivityManager'.static.GetAlienActivityManager();
	//find the specified activity in the specified region
	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if(Region != '')
		{
			RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
			if(RegionState.GetMyTemplateName() != Region)
			{
				continue;
			}
		}
		//either we matched the region, or didn't specify one, so dump out Activity Info
		DumpActivityInfo(ActivityState);
	}
}

function DumpActivityInfo(XComGameState_LWAlienActivity ActivityState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local string MissionString;
	local XComGameState_DarkEvent DarkEventState;

	History = `XCOMHISTORY;
	RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);

	MissionString = "None";
	if(ActivityState.CurrentMissionRef.ObjectID > 0)
	{
		MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
		MissionString = string(MissionState.GeneratedMission.Mission.MissionName);
	}

	`LOG("=========================================================");
	`LOG("Activity Template: " $ ActivityState.GetMyTemplateName() $ " -- Primary Region: " $ RegionState.GetMyTemplateName());
	`LOG("Started: " $ GetDateTimeString(ActivityState.DateTimeStarted) $ " -- Ending: " $ GetDateTimeString(ActivityState.DateTimeActivityComplete));
	`LOG("Current Mission: " $ MissionString);
	`LOG("Regional AI -- Force:" @ RegionalAI.LocalForceLevel @ "; Alert:" @ RegionalAI.LocalAlertLevel @ "; Vigilance:" @ RegionalAI.LocalVigilanceLevel);
	if(ActivityState.DarkEvent.ObjectID > 0)
	{
		DarkEventState = XComGameState_DarkEvent(History.GetGameStateForObjectID(ActivityState.DarkEvent.ObjectID));
		`LOG("Dark Event: " $ DarkEventState.GetDisplayName() $ ", DataName=" $ DarkEventState.GetMyTemplate().DataName $ ", Secret=" $ DarkEventState.bSecretEvent $ ", Cost=" $ DarkEventState.GetCost());

	}
	if(MissionState != none)
	{

	}
}

exec function LWDumpRegionInfo()
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local int TotalForce, TotalAlert, TotalVigilance;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
		if(RegionalAI != none)
		{
			`LOG("Regional AI (" $ RegionState.GetMyTemplateName() $ ") -- Force:" @ RegionalAI.LocalForceLevel @ "; Alert:" @ RegionalAI.LocalAlertLevel @ "; Vigilance:" @ RegionalAI.LocalVigilanceLevel);
			TotalForce += RegionalAI.LocalForceLevel;
			TotalAlert += RegionalAI.LocalAlertLevel;
			TotalVigilance += RegionalAI.LocalVigilanceLevel;
		}
		else
			`LOG("ERROR -- unable to find RegionalAI info for region " $ RegionState.GetMyTemplateName());
	}
	`LOG("Regional AI (Totals) -- Force:" @ TotalForce @ "; Alert:" @ TotalAlert @ "; Vigilance:" @ TotalVigilance);
}

function string GetDateTimeString(TDateTime DateTime)
{
	local string DateTimeString;
	DateTimeString = class'X2StrategyGameRulesetDataStructures'.static.GetDateString(DateTime);
	DateTimeString $= " / " $ class'X2StrategyGameRulesetDataStructures'.static.GetTimeString(DateTime);
	return DateTimeString;
}

// this sets the regional force level -- if no Primary Region is specified, it sets for all regions
exec function LWSetForceLevel(int NewLevel, optional name RegionName)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState, UpdatedRegionalAI;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Set ForceLevel");

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionName == '' || RegionState.GetMyTemplateName() == RegionName)
		{
			RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
			UpdatedRegionalAI = XComGameState_WorldRegion_LWStrategyAI(NewGameState.CreateStateObject(class'XComGameState_WorldRegion_LWStrategyAI', RegionalAIState.ObjectID));
			NewGameState.AddStateObject(UpdatedRegionalAI);

			UpdatedRegionalAI.LocalForceLevel = NewLevel;
		}
	}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

// this sets the regional alert level -- if no Primary Region is specified, it sets for all regions
exec function LWSetAlertLevel(int NewLevel, optional name RegionName)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState, UpdatedRegionalAI;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Set AlertLevel");

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionName == '' || RegionState.GetMyTemplateName() == RegionName)
		{
			RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
			UpdatedRegionalAI = XComGameState_WorldRegion_LWStrategyAI(NewGameState.CreateStateObject(class'XComGameState_WorldRegion_LWStrategyAI', RegionalAIState.ObjectID));
			NewGameState.AddStateObject(UpdatedRegionalAI);

			UpdatedRegionalAI.LocalAlertLevel = NewLevel;
		}
	}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

// this sets the regional vigilance level -- if no Primary Region is specified, it sets for all regions
exec function LWSetVigilanceLevel(int NewLevel, optional name RegionName)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState, UpdatedRegionalAI;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Set VigilanceLevel");

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionName == '' || RegionState.GetMyTemplateName() == RegionName)
		{
			RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
			UpdatedRegionalAI = XComGameState_WorldRegion_LWStrategyAI(NewGameState.CreateStateObject(class'XComGameState_WorldRegion_LWStrategyAI', RegionalAIState.ObjectID));
			NewGameState.AddStateObject(UpdatedRegionalAI);

			UpdatedRegionalAI.LocalVigilanceLevel = NewLevel;
		}
	}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

exec function LWPlayStrategyMovie(string Movie)
{
	local XComNarrativeMoment Moment;
	local string MoviePath;
	MoviePath = "LWNarrativeMoments_Bink.Strategy." $ Movie;
	Moment = XComNarrativeMoment(DynamicLoadObject(MoviePath, class'XComNarrativeMoment'));
	`HQPRES.UINarrative(Moment);
}

exec function LWPlayTacticalMovie(string Movie)
{
	local XComNarrativeMoment Moment;
	local string MoviePath;
	MoviePath = "LWNarrativeMoments_Bink.TACTICAL." $ Movie;
	Moment = XComNarrativeMoment(DynamicLoadObject(MoviePath, class'XComNarrativeMoment'));
	`HQPRES.UINarrative(Moment);
}


exec function LWForceRecruitRoll(int Roll, optional name RegionName)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_LWOutpost OutpostState;
	local XComGameState_LWOutpostManager OutpostManager;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: ForceRecruitRoll");
	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionName == '' || RegionState.GetMyTemplateName() == RegionName)
		{
			OutpostState = OutpostManager.GetOutpostForRegion(RegionState);
			OutpostState = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutpostState.ObjectID));
			NewGameState.AddStateObject(OutpostState);
			OutpostState.ForceRecruitRoll = Roll;
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

exec function LWToggleShowFaceless()
{
	local UIOutpostManagement OutpostUI;

	if (`SCREENSTACK.IsCurrentScreen('UIOutpostManagement'))
	{
		OutpostUI = UIOutpostManagement(`SCREENSTACK.GetCurrentScreen());
		OutpostUI.ToggleShowFaceless();
	}
}

exec function LWAddRebel(optional bool IsFaceless = false, optional Name RegionName)
{
	local XComGameState_LWOutpost OutpostState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_LWOutpostManager OutpostManager;

	History = `XCOMHISTORY;
	OutpostManager = `LWOUTPOSTMGR;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: LWAddRebel");

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionName == '' || RegionState.GetMyTemplateName() == RegionName)
		{
			OutpostState = OutpostManager.GetOutpostForRegion(RegionState);
			OutpostState = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutpostState.ObjectID));
			NewGameState.AddStateObject(OutpostState);
			OutpostState.AddRebel(OutpostState.CreateRebel(NewGameState, RegionState, true, IsFaceless), NewGameState);
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

exec function LWAddResistanceMec(optional name RegionName)
{
	local XComGameState_LWOutpost OutpostState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_LWOutpostManager OutpostManager;

	History = `XCOMHISTORY;
	OutpostManager = `LWOUTPOSTMGR;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: LWAddResistanceMEC");

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionName == '' || RegionState.GetMyTemplateName() == RegionName)
		{
			OutpostState = OutpostManager.GetOutpostForRegion(RegionState);
			OutpostState = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutpostState.ObjectID));
			NewGameState.AddStateObject(OutpostState);
			OutpostState.AddResistanceMec(OutpostState.CreateResistanceMec(NewGameState), NewGameState);
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

exec function LWSetEvacCounter(int Turns)
{
	local XComGameState_LWEvacSpawner EvacState;
	local XComGameState NewGameState;

	EvacState = XComGameState_LWEvacSpawner(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWEvacSpawner', true));

	if (EvacState != none && EvacState.GetCountdown() >= 0)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: LWSetEvacCounter");
		EvacState = XComGameState_LWEvacSpawner(NewGameState.CreateStateObject(class'XComGameState_LWEvacSpawner', EvacState.ObjectID));
		EvacState.SetCountdown(Turns);
		NewGameState.AddStateObject(EvacState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}

function static XComGameState_LWOutpost FindCurrentOutpostFromScreenStack()
{
	local UIOutpostManagement OutpostScreen;
	local StateObjectReference OutpostRef;
	//local XComGameState_LWOutpost OutpostState;

	if (!`SCREENSTACK.IsInStack(class'UIOutpostManagement'))
	{
		`Redscreen("LWLevelUpRebel: Not in outpost management screen");
		return none;
	}

	OutpostScreen = UIOutpostManagement(`SCREENSTACK.GetScreen(class'UIOutpostManagement'));
	OutpostRef = OutpostScreen.OutpostRef;
	return XComGameState_LWOutpost(`XCOMHISTORY.GetGameStateForObjectID(OutpostRef.ObjectID));
}

exec function LWLevelUpRebel(string FirstName, string LastName)
{
	local XComGameState_LWOutpost OutpostState;
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local StateObjectReference RebelRef;
	local int i;

	History = `XCOMHISTORY;

	OutpostState = FindCurrentOutpostFromScreenStack();
	if (OutpostState == none)
	{
		return;
	}

	RebelRef = OutpostState.GetRebelByName(FirstName, LastName);
	if (RebelRef.ObjectID <= 0)
	{
		return;
	}

	i = OutpostState.GetRebelLevel(RebelRef);
	if (i >= 2)
	{
		`Redscreen("LWLevelUpRebel: Rebel at max level");
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: LWLevelUpRebel");
	OutpostState = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutpostState.ObjectID));
	NewGameState.AddStateObject(OutpostState);
	OutpostState.PromoteRebel(RebelRef, NewGameState);

	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

exec function LWRenameRebel(String OldFirstName, String OldLastName, String NewFirstName, String NewLastName)
{
	local XComGameState_LWOutpost OutpostState;
	local XComGameState NewGameState;
	local XComGameState_Unit Unit;
	local StateObjectReference RebelRef;

	OutpostState = FindCurrentOutpostFromScreenStack();
	if (OutpostState == none)
	{
		return;
	}
	RebelRef = OutpostState.GetRebelByName(OldFirstName, OldLastName);
	if (RebelRef.ObjectID <= 0)
	{
		`Log("LWRenameRebel: No such rebel found");
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: LWRenameRebel");
	Unit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', RebelRef.ObjectID));
	NewGameState.AddStateObject(Unit);
	Unit.SetUnitName(NewFirstName, NewLastName, "");
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

exec function LWDumpHavenIncome(optional Name RegionName)
{
	local XComGameState_LWOutpost Outpost;
	local XComGameState_WorldRegion Region;
	local XComGameStateHistory History;
	local int i;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
	{
		Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(Outpost.Region.ObjectID));
		if (RegionName != '' && RegionName != Region.GetMyTemplateName())
			continue;

		`Log("Dumping Haven info for " $ Region.GetDisplayName());

		for (i = 0; i < Outpost.IncomePools.Length; ++i)
		{
			`Log("Income pool for " $ Outpost.IncomePools[i].Job $ ": " $ Outpost.IncomePools[i].Value);
		}
	}
}

exec function LWDebugPodJobs()
{
	bDebugPodJobs = !bDebugPodJobs;
}

exec function LWActivatePodJobs()
{
	local XComGameState NewGameState;
	local XComGameState_LWPodManager PodMgr;
	local XGAIPlayer AIPlayer;
	local Vector XComLocation;
	local float Rad;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: LWActivatePodJobs");
	PodMgr = XComGameState_LWPodManager(NewGameState.CreateStateObject(class'XComGameState_LWPodManager', `LWPODMGR.ObjectID));
	NewGameState.AddStateObject(PodMgr);
	PodMgr.AlertLevel = `ALERT_LEVEL_RED;

	AIPlayer = XGAIPlayer(XGBattle_SP(`BATTLE).GetAIPlayer());
	AIPlayer.GetSquadLocation(XComLocation, Rad);
	PodMgr.LastKnownXComPosition = XComLocation;
	`TACTICALRULES.SubmitGameState(NewGameState);
}

exec function LWPrintHistory()
{
	local int HistoryIndex;
	local XComGameState AssociatedGameStateFrame;
	local string ContextString;
	local XComGameStateHistory History;
	local XComGameState_BaseObject Obj;

	History = `XCOMHISTORY;

	for( HistoryIndex = History.GetCurrentHistoryIndex(); HistoryIndex > -1; --HistoryIndex )
	{
		AssociatedGameStateFrame = History.GetGameStateFromHistory(HistoryIndex, eReturnType_Reference);
		if (AssociatedGameStateFrame != none)
		{
			if (AssociatedGameStateFrame.GetContext() != none)
			{
				ContextString = AssociatedGameStateFrame.GetContext().SummaryString();
				`Log("History Frame"@HistoryIndex@" : "@ContextString@"\n");
			}
			else
			{
				foreach AssociatedGameStateFrame.IterateByClassType(class'XComGameState_BaseObject', Obj)
				{
					`Log("Sub-object " $ Obj.ToString());
				}
				`Log("History Frame"@HistoryIndex@" : No associated context found!!\n");
			}
		}
	}
}

exec function LWForceEvac()
{
	local XComGameState_LWEvacSpawner Spawner;
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: LWForceEvac");
	Spawner = XComGameState_LWEvacSpawner(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWEvacSpawner', true));
	if (Spawner == none || Spawner.GetCountdown() <= 0)
	{
		`Log("No spawner");
		return;
	}
	Spawner = XComGameState_LWEvacSpawner(NewGameState.CreateStateObject(class'XComGameState_LWEvacSpawner', Spawner.ObjectID));
	NewGameState.AddStateObject(Spawner);
	Spawner.SetCountdown(0);
	`TACTICALRULES.SubmitGameState(NewGameState);
	Spawner.SpawnEvacZone();
}

exec function LWPrintVersion()
{
	`Log("LongWar2 Version: " $ class'LWVersion'.static.GetVersionString());
}

exec function LWAddFortressDoom(optional int DoomToAdd = 1)
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersAlien AlienHQ;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LWCHEAT : Add Doom To Fortress");

	if (DoomToAdd < 0)
	{
		AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		NewGameState.AddStateObject(AlienHQ);
		AlienHQ.RemoveDoomFromFortress(NewGameState, -DoomToAdd, , false);
	}
	else
	{
		`LWACTIVITYMGR.AddDoomToFortress(NewGameState, DoomToAdd, , false);
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

exec function LWAddDoomToRegion(name RegionName, int DoomToAdd = 1)
{
	local XComGameStateHistory History;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion Region;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;
	Region = FindRegionByName(RegionName);
	if (Region == none)
	{
		`Log("No region found: " $ RegionName);
		return;
	}
	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if(ActivityState.GetMyTemplateName() == class'X2StrategyElement_DefaultAlienActivities'.default.RegionalAvatarResearchName)
		{
			if (ActivityState.PrimaryRegion.ObjectID == Region.ObjectID)
			{
				break;
			}
		}
	}

	if (ActivityState == none || ActivityState.PrimaryRegion.ObjectID != Region.ObjectID)
	{
		`Log("No facility in region.");
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Add facility doom");

	if(ActivityState.CurrentMissionRef.ObjectID > 0) // is detected and has a mission
	{
		MissionState = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', ActivityState.CurrentMissionRef.ObjectID));
		NewGameState.AddStateObject(MissionState);
		MissionState.Doom += DoomToAdd;
	}
	else
	{
		ActivityState = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', ActivityState.ObjectID));
		NewGameState.AddStateObject(ActivityState);
		ActivityState.Doom += DoomToAdd;
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

exec function LWPrintScreenStack()
{
	local UIScreenStack ScreenStack;
	local int i;
	local UIScreen Screen;
	local string inputType;
	local string prefix;

	ScreenStack = `SCREENSTACK;

	`LWDEBUG("============================================================");
	`LWDEBUG("---- BEGIN UIScreenStack.PrintScreenStack() -------------");

	`LWDEBUG("");

	`LWDEBUG("---- Stack: General Information ----------------");
	`LWDEBUG("Stack.GetCurrentScreen() = " $ ScreenStack.GetCurrentScreen());
	`LWDEBUG("Stack.IsInputBlocked = " $ ScreenStack.IsInputBlocked);

	`LWDEBUG("");
	`LWDEBUG("---- Screens[]:  Classes and Instance Names ---");
	for( i = 0; i < ScreenStack.Screens.Length; i++)
	{
		Screen = ScreenStack.Screens[i];
		if ( Screen == none )
		{
			`LWDEBUG(i $": NONE ");
			continue;
		}
		`LWDEBUG(i $": " $Screen.Class $", " $ Screen);
	}
	if( ScreenStack.Screens.Length == 0)
		`LWDEBUG("Nothing to show because Screens.Length = 0,");
	`LWDEBUG("");

	`LWDEBUG("---- Screen.MCPath ----------------------------");
	for( i = 0; i < ScreenStack.Screens.Length; i++)
	{
		Screen = ScreenStack.Screens[i];
		if ( Screen == none )
		{
			`LWDEBUG(i $": NONE ");
			continue;
		}
		`LWDEBUG(i $": " $Screen.MCPath);
	}
	if( ScreenStack.Screens.Length == 0)
		`LWDEBUG("Nothing to show because Screens.Length = 0,");
	`LWDEBUG("");

	`LWDEBUG("---- Unreal Visibility -----------------------");
	for( i = 0; i < ScreenStack.Screens.Length; i++)
	{
		Screen = ScreenStack.Screens[i];
		if ( Screen == none )
		{
			`LWDEBUG(i $": NONE ");
			continue;
		}
		`LWDEBUG(i $": " $"bIsVisible = " $Screen.bIsVisible @ Screen);
	}
	if( ScreenStack.Screens.Length == 0)
		`LWDEBUG("Nothing to show because Screens.Length = 0,");
	`LWDEBUG("");

	`LWDEBUG("---- Owned by 2D vs. 3D movies --------------");
	for( i = 0; i < ScreenStack.Screens.Length; i++)
	{
		Screen = ScreenStack.Screens[i];
		if ( Screen == none )
		{
			`LWDEBUG(i $": NONE ");
			continue;
		}
		if( Screen.bIsIn3D )
			`LWDEBUG(i $": 3D " $ Screen);
		else
			`LWDEBUG(i $": 2D " $ Screen);
	}
	if( ScreenStack.Screens.Length == 0)
		`LWDEBUG("Nothing to show because Screens.Length = 0,");
	`LWDEBUG("");

	`LWDEBUG("---- ScreensHiddenForCinematic[] -------------");
	for( i = 0; i < ScreenStack.ScreensHiddenForCinematic.Length; i++)
	{
		Screen = ScreenStack.ScreensHiddenForCinematic[i];
		if ( Screen == none )
		{
			`LWDEBUG(i $": NONE ");
			continue;
		}
		`LWDEBUG(i $": " $Screen);
	}
	if( ScreenStack.ScreensHiddenForCinematic.Length == 0)
		`LWDEBUG("Nothing to show because ScreensHiddenForCinematic.Length = 0,");
	`LWDEBUG("");

	`LWDEBUG("---- UI Input information --------------------");

	prefix = ScreenStack.IsInputBlocked ? "INPUT GATED " : "      ";
	for( i = 0; i < ScreenStack.Screens.Length; i++)
	{
		Screen = ScreenStack.Screens[i];
		if ( Screen == none )
		{
			`LWDEBUG("      " $ "        " $ " " $ i $ ": ?none?");
			continue;
		}

		if( Screen.ConsumesInput() )
		{
			inputType = "CONSUME ";
			prefix = "XXX   ";
		}
		else if( Screen.EvaluatesInput() )
			inputType = "eval    ";
		else
			inputType = "-       ";

		`LWDEBUG(prefix $ inputType $ " " $ i $ ": '" @ Screen.class $ "'");
	}
	if( ScreenStack.Screens.Length == 0)
		`LWDEBUG("Nothing to show because Screens.Length = 0,");
	`LWDEBUG("");

	`LWDEBUG("*** Movie.Screens are what the movie has loaded: **");
	ScreenStack.Pres.Get2DMovie().PrintCurrentScreens();
	`LWDEBUG("****************************************************");
	`LWDEBUG("");

	`LWDEBUG("---- END PrintScreenStack --------------------");

	`LWDEBUG("========================================================");
}

exec function LWValidatePendingDarkEvents()
{
	`LWACTIVITYMGR.ValidatePendingDarkEvents();
}

exec function LWSetUnitValue(Name ValueName, float Value)
{
	local StateObjectReference ActiveUnitRef;
	local UITacticalHUD TacticalHUD;
	local XComGameState_Unit Unit;
	local XComGameState NewGameState;

	TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
	if (TacticalHUD != none)
	{
		ActiveUnitRef = XComTacticalController(TacticalHUD.PC).GetActiveUnitStateRef();
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LWCHEAT : SetUnitValue");
		Unit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', ActiveUnitRef.ObjectID));
		NewGameState.AddStateObject(Unit);
		Unit.SetUnitFloatValue(ValueName, Value, eCleanup_BeginTactical);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}

exec function LWForceSquadPostMissionCleanup(string SquadName)
{
	local XComGameState_LWPersistentSquad SquadState, UpdatedSquadState;
	local XComGameState UpdateState;
	local XComGameState_LWSquadManager SquadMgr, UpdatedSquadMgr;
	local StateObjectReference NullRef;

	SquadMgr = `LWSQUADMGR;
	SquadState = SquadMgr.GetSquadByName(SquadName);
	if (SquadState == none)
	{
		return;
	}

	UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("DEBUG:Persistent Squad Cleanup");

	UpdatedSquadMgr = XComGameState_LWSquadManager(UpdateState.CreateStateObject(SquadMgr.Class, SquadMgr.ObjectID));
	UpdateState.AddStateObject(UpdatedSquadMgr);

	UpdatedSquadState = XComGameState_LWPersistentSquad(UpdateState.CreateStateObject(SquadState.Class, SquadState.ObjectID));
	UpdateState.AddStateObject(UpdatedSquadState);

	UpdatedSquadMgr.LaunchingMissionSquad = NullRef;
	UpdatedSquadState.PostMissionRevertSoldierStatus(UpdateState, UpdatedSquadMgr);
	UpdatedSquadState.ClearMission();
	`XCOMGAME.GameRuleset.SubmitGameState(UpdateState);

	if(SquadState.bTemporary)
	{
		`LWSQUADMGR.RemoveSquadByRef(SquadState.GetReference());
	}
}
