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

// Conditional MCOs depending on whether another mod has overridden
// the base class or not.
var config array<ModClassOverrideEntry> ModClassOverrides;

//----------------------------------------------------------------
// A random selection of data and data structures from LW Overhaul
struct MinimumInfilForConcealEntry
{
	var string MissionType;
	var float MinInfiltration;
};

struct ChosenStrengthWeighted
{
	var name Strength;
	var float Weight;
};

struct PodSizeConversion
{
	var int Podsize;
	var int SameUnitMaxLimit;
	var int SameUnitMaxLimitAliens;
};

var config array<PodSizeConversion> PodSizeConversions;

var config array<ChosenStrengthWeighted> ASSASSIN_STRENGTHS_T1;
var config array<ChosenStrengthWeighted> ASSASSIN_STRENGTHS_T2;
var config array<ChosenStrengthWeighted> ASSASSIN_STRENGTHS_T3;

var config array<ChosenStrengthWeighted> WARLOCK_STRENGTHS_T1;
var config array<ChosenStrengthWeighted> WARLOCK_STRENGTHS_T2;
var config array<ChosenStrengthWeighted> WARLOCK_STRENGTHS_T3;

var config array<ChosenStrengthWeighted> HUNTER_STRENGTHS_T1;
var config array<ChosenStrengthWeighted> HUNTER_STRENGTHS_T2;
var config array<ChosenStrengthWeighted> HUNTER_STRENGTHS_T3;

var config int ENCRYPTION_SERVER_CHANCE;
var config int ENCRYPTION_SERVER_MONTH;

var config bool bNerfFrostLegion;

var config bool bDisableDiversitySystem;

var config array<MissionDefinition> ReplacementMissionDefs;
var config array<EncounterBucket> ReplacementEncounterBuckets;

var config array<string> MissionsToNotDiversify;

var config array<name> NoReinforcementEnemies;


// An array of mission types where we should just let vanilla do its
// thing with regard to the Chosen rather than try to override its
// behaviour.
var config array<string> SKIP_CHOSEN_OVERRIDE_MISSION_TYPES;

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
var config int CHOSEN_RETRIBUTION_DURATION;

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

// Configurable list of abilities that should apply to the primary
// weapon. This is necessary because character template abilities
// can't be configured for a weapon slot, but some of those abilities
// need to be tied to a weapon slot to work.
//
// This is used in FinalizeUnitAbilitiesForInit() to patch existing
// abilities for non-XCOM units.
var config array<name> PrimaryWeaponAbilities;
var config array<name> SecondaryWeaponAbilities;

// Configurable list of parcels to remove from the game.
var config array<String> ParcelsToRemove;
var bool bDebugPodJobs;

// Minimum force level that needs to be reached before The Lost
// can start to appear.
var config array<int> MIN_FL_FOR_LOST;

// Thresholds for region strength translating to larger Alien Ruler pod size.
var config array<int> RULER_POD_SIZE_ALERT_THRESHOLDS;

// Scaling multiplier for the Brute's pawn
var config float BRUTE_SIZE_MULTIPLIER;

// List of sitreps to remove
var config array<Name> SitrepsToDisable;

// disable patching Templars

var config bool bDisableRespeccingTemplars;

var config bool bSewersToSubway;
var config bool bEnableCityHQs;

var config array<string> MapsToDisable;

var config array<Name> EncountersToExclude;

var config array<Name> ROCKET_ABILITIES_TO_UPDATE;

var config bool bUpdateWaterworldLW;

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
	local XComGameState_WorldRegion StartingRegionState;
	local XComGameState_ResistanceFaction StartingFactionState;

	//short circuit if in shell:
	//if(class'WorldInfo'.static.GetWorldInfo().GRI.GameClass.name == 'XComShell')
	//{
	//	`LWTrace("InstallNewCampaign called in Shell, aborting.");
	//	return;
	//}

	// WOTC TODO: Note that this method is called twice if you start a new campaign.
	// Make sure that's not causing issues.
	`Log("LWOTC: Installing a new campaign");
	class'XComGameState_LWListenerManager'.static.CreateListenerManager(StartState);
	class'XComGameState_LWSquadManager'.static.CreateSquadManager(StartState);

	class'XComGameState_LWOutpostManager'.static.CreateOutpostManager(StartState);
	class'XComGameState_LWAlienActivityManager'.static.CreateAlienActivityManager(StartState);
	class'XComGameState_WorldRegion_LWStrategyAI'.static.InitializeRegionalAIs(StartState);
	class'XComGameState_LWOverhaulOptions'.static.CreateModSettingsState_NewCampaign(class'XComGameState_LWOverhaulOptions', StartState);

	// Save the second wave options, but only if we've actually started a new
	// campaign (hence the check for UIShellDifficulty being open).
	if (`SCREENSTACK != none && UIShellDifficulty(`SCREENSTACK.GetFirstInstanceOf(class'UIShellDifficulty')) != none)
	{
		SaveSecondWaveOptions();
	}

	StartingRegionState = SetStartingLocationToStartingRegion(StartState);
	UpdateLockAndLoadBonus(StartState);  // update XComHQ and Continent states to remove LockAndLoad bonus if it was selected
	LimitStartingSquadSize(StartState); // possibly limit the starting squad size to something smaller than the maximum
	DisableUnwantedObjectives(StartState);

	`LWOVERHAULOPTIONS.StartingChosen = StartingRegionState.GetControllingChosen().GetMyTemplateName();

	`LWOVERHAULOptions.InitChosenKnowledge();

	// Mark the chosen as defeated if the SWO is enabled.
	if (`SecondWaveEnabled('DisableChosen'))
	{
		MarkAllChosenDefeated(StartState);
	}

	class'XComGameState_LWSquadManager'.static.CreateFirstMissionSquad(StartState);

	// Clear starting resistance modes because we don't actually start
	// at the faction HQ, unlike vanilla WOTC.
	StartingFactionState = StartingRegionState.GetResistanceFaction();
	class'X2StrategyElement_DefaultResistanceModes'.static.OnXCOMLeavesIntelMode(StartState, StartingFactionState.GetReference());
	class'X2StrategyElement_DefaultResistanceModes'.static.OnXCOMLeavesMedicalMode(StartState, StartingFactionState.GetReference());
	class'X2StrategyElement_DefaultResistanceModes'.static.OnXCOMLeavesBuildMode(StartState, StartingFactionState.GetReference());
}

static function MarkAllChosenDefeated(XComGameState StartState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(, true);

	foreach AllChosen (ChosenState)
	{
		ChosenState.bDefeated = true;
	}
}

static function OnPreCreateTemplates()
{
	`Log("Long War of the Chosen (LWOTC) version: " $ class'LWVersion'.static.GetVersionString());
	PatchModClassOverrides();
	CacheInstalledMods();
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
	UpdateChosenActivities();
	UpdateChosenSabotages();
	UpdateSitreps();
	UpdateEncounterLists();
	ModifyYellAbility();
	ModifyMissionSchedules();
	ModifyEncountersForFL21();
	UpdateWaterworldRNF();
	ModCompatibilityConfig();
	EditModdedRocketAbilities();
	UpdateSkulljackAllShooterEffectExclusions();
	class'X2Ability_PerkPackAbilitySet2'.static.AddEffectsToGrenades();
}

static function ModCompatibilityConfig()
{
	local int idx;
	if(class'Helpers_LW'.default.bKirukaSparkActive)
	{
		`LWTrace("Patching Kiruka Spark.");
		idx = class'NPSBDP_UIArmory_PromotionHero'.default.ClassAbilitiesPerRank.Find('ClassName','Spark');

		if(idx != INDEX_NONE)
		{
			`LWTrace("Entry in Communty Promotion Screen config found.");
			class'NPSBDP_UIArmory_PromotionHero'.default.ClassAbilitiesPerRank[idx].AbilitiesPerRank = 4;
		}

	}

}

static function EditModdedRocketAbilities()
{
	local X2AbilityTemplateManager							AbilityManager;
	local X2AbilityTemplate									AbilityTemplate;
	local name AbilityName;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach default.ROCKET_ABILITIES_TO_UPDATE(AbilityName)
	{
		AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);

		if(AbilityTemplate != none)
		{
			`LWTrace("Patching Rocket launcher ability" @AbilityTemplate.DataName);
			AbilityTemplate.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';
		}
	}
}

// Vanilla Skulljack and Skullmine can be used while burning
// In LW, burning disables a lot more abilities, so might as well disable these too
static function UpdateSkulljackAllShooterEffectExclusions()
{
	local X2AbilityTemplateManager AbilityManager;
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplate('SKULLJACKAbility').AddShooterEffectExclusions();
	AbilityManager.FindAbilityTemplate('SKULLMINEAbility').AddShooterEffectExclusions();
}

// Uses OPTC to update mission schedules instead of minus config
static function ModifyMissionSchedules()
{
	local XComTacticalMissionManager MissionManager;
	local int MissionIdx;
	local name MissionName;
	local MissionDefinition CurrentMissionDef;
	local MissionSchedule MissionSchedule;
	local int i;

	MissionManager = `TACTICALMISSIONMGR;

	foreach default.ReplacementMissionDefs (CurrentMissionDef)
	{
		MissionName = CurrentMissionDef.MissionName;
		MissionIdx = MissionManager.arrMissions.Find('MissionName', MissionName);
		if(MissionIdx != -1)
		{
			if(MissionManager.arrMissions[MissionIdx].sType == CurrentMissionDef.sType &&  MissionManager.arrMissions[MissionIdx].MissionName == MissionName)
			{
				MissionManager.arrMissions[MissionIdx] = CurrentMissionDef;
				`LWTrace("Replacing mission def for mission " @CurrentMissionDef.MissionName @"Mission sType" @ CurrentMissionDef.sType);
			}
			else
			{
				`LWTrace("replacement Mission sType didn't match for mission Name" @CurrentMissionDef.MissionName); 
			}
		}
		else
		{
			`LWTrace("Couldn't find base missiondef to replace for mission name" @CurrentMissionDef.MissionName);
		}
	}

	// Patch for FL21-99

	for (i = 0; i < MissionManager.MissionSchedules.Length; i++)
	{
		MissionSchedule = MissionManager.MissionSchedules[i];

		if (MissionSchedule.MaxRequiredForceLevel >= 20)
		{
			MissionSchedule.MaxRequiredForceLevel = 99;

			MissionManager.MissionSchedules[i] = MissionSchedule;
		}
	}


}

static function ModifyEncountersForFL21()
{
	local XComTacticalMissionManager MissionManager;
	local int i;

	MissionManager = `TACTICALMISSIONMGR;

	for (i = 0; i < MissionManager.ConfigurableEncounters.Length; i++)
	{
		if (MissionManager.ConfigurableEncounters[i].MaxRequiredForceLevel >= 20)
		{
			MissionManager.ConfigurableEncounters[i].MaxRequiredForceLevel = 99;
    	}
	}

}

static function UpdateWaterworldRNF()
{
	local XComTacticalMissionManager MissionManager;
	local EncounterBucket EncounterBucket;
	local int idx;

	MissionManager = `TACTICALMISSIONMGR;

	foreach default.ReplacementEncounterBuckets (EncounterBucket)
	{
		idx = MissionManager.EncounterBuckets.Find('EncounterBucketID', EncounterBucket.EncounterBucketID);
		if(idx != INDEX_NONE)
		{
			MissionManager.EncounterBuckets[idx] = EncounterBucket;
			`LWTrace("Replacing EncounterBucket" @EncounterBucket.EncounterBucketId);
		}
	}
}

static function UpdateEncounterLists()
{
	local XComTacticalMissionManager MissionManager;
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate TestTemplate;
	local int i, j;

	MissionManager = `TACTICALMISSIONMGR;
	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	// Loop over all encounter lists
	for(i = MissionManager.SpawnDistributionLists.length-1; i >= 0; i--)
	{
		//CurrentList = MissionManager.SpawnDistributionLists[i];

		// Loop over all entries in each list
		for(j = MissionManager.SpawnDistributionLists[i].SpawnDistribution.Length-1; j >= 0; j--) 
		{
			//CurrentListEntry= CurrentList.SpawnDistribution[j];
			TestTemplate = CharacterTemplateMgr.FindCharacterTemplate(MissionManager.SpawnDistributionLists[i].SpawnDistribution[j].Template);

			// remove entry if invaid
			if(TestTemplate == none)
			{
				`LWTrace("Removing nonexistant unit" @MissionManager.SpawnDistributionLists[i].SpawnDistribution[j].Template @ "From encounter list" @MissionManager.SpawnDistributionLists[i].ListID);
				MissionManager.SpawnDistributionLists[i].SpawnDistribution.Remove(j, 1);
			}

			// new udpate for max FL extension
			else if(MissionManager.SpawnDistributionLists[i].SpawnDistribution[j].MaxForceLevel == 20)
			{
				MissionManager.SpawnDistributionLists[i].SpawnDistribution[j].MaxForceLevel = 99;
			}
		}
	}

	// Handle pre-made encounters
	for(i = MissionManager.ConfigurableEncounters.Length-1; i >= 0; i--)
	{

		for(j = MissionManager.ConfigurableEncounters[i].ForceSpawnTemplateNames.Length - 1; j >= 0; j--)
		{
			// Try to find the character template
			TestTemplate = CharacterTemplateMgr.FindCharacterTemplate(MissionManager.ConfigurableEncounters[i].ForceSpawnTemplateNames[j]);

			// Remove if invalid
			if(TestTemplate == none)
			{
				`LWTrace("Removing nonexistant unit" @MissionManager.ConfigurableEncounters[i].ForceSpawnTemplateNames[j] @ "From fixed encounter" @MissionManager.ConfigurableEncounters[i].EncounterID);
				MissionManager.ConfigurableEncounters[i].ForceSpawnTemplateNames.Remove(j,1);
			}
		}
	}
}

// Remove the red alert affect from the yell ability since it cause AI units to go into red alert
// Credit to RedDobe for this function.
static function ModifyYellAbility()
{
    local X2AbilityTemplateManager        AbilityMgr;
    local array<X2AbilityTemplate>        arrTemplate;
    local int                            i;
	local X2Effect_YellowAlert              YellowAlertStatus;

	YellowAlertStatus = new class 'X2Effect_YellowAlert';
	YellowAlertStatus.BuildPersistentEffect(1,true,true /*Remove on Source Death*/,,eGameRule_PlayerTurnBegin);


    // Access Ability Template Manager
    AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    // Access Template for all difficulties
    AbilityMgr.FindAbilityTemplateAllDifficulties('Yell', arrTemplate);
    for (i = 0; i < arrTemplate.Length; i++)
    {
        arrTemplate[i].AbilityMultiTargetEffects.length = 0;
        `Log("Removing Yell Red Alert effects");

		if (class'Helpers_LW'.static.YellowAlertEnabled())
		{
			X2AbilityMultiTarget_Radius(arrTemplate[i].AbilityMultiTargetStyle).fTargetRadius = 18;
			`LWTrace("Adding Yellow Alert effects to Yell");
			arrTemplate[i].AbilityMultiTargetEffects.AddItem(YellowAlertStatus);
		}
    }
}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_Objective ObjectiveState;
	local XComGameState_LWOutpostManager OutpostManager;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_LWOutpost OutpostState;
	local XComGameState_LWToolboxOptions ToolboxOptions;
	local XComGameState_LWOverhaulOptions OverhaulOptions;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;
	local int i;

	
	History = `XCOMHISTORY;

	// TODO: Remove these post 1.0 - START

	// LWOTC beta 2: Remove the 'OnMonthlyReportAlert' listener as it's no
	// longer needed (Not Created Equally is handled by the 'UnitRandomizedStats'
	// event now).
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();
	`XEVENTMGR.UnRegisterFromEvent(ToolboxOptions, 'OnMonthlyReportAlert');

	// Make sure pistol abilities apply to the new pistol slot
	// Tedster: Yeeted
	//LWMigratePistolAbilities();

	// If there are rebels that have already ranked up, make sure they have some abilities
	OutpostManager = `LWOUTPOSTMGR;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Patching existing campaign data");
	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if (RegionState.HaveMadeContact())
		{
			OutpostState = OutpostManager.GetOutpostForRegion(RegionState);
			OutpostState.UpdateRebelAbilities(NewGameState);
		}
	}
		
	if (`LWOVERHAULOPTIONS == none)
		class'XComGameState_LWOverhaulOptions'.static.CreateModSettingsState_ExistingCampaign(class'XComGameState_LWOverhaulOptions');

	`LWTrace("Chosen Knowledge array length:" @ `LWOVERHAULOPTIONS.GetChosenKnowledgeGains_Randomized().length);
	OverhaulOptions = `LWOVERHAULOPTIONS;
	if(OverhaulOptions.GetChosenKnowledgeGains_Randomized().length == 0)
	{
		OverhaulOptions = XComGameState_LWOverhaulOptions(NewGameState.ModifyStateObject(class'XComGameState_LWOverhaulOptions', OverhaulOptions.ObjectID));
		OverhaulOptions.StartingChosen = XComGameState_WorldRegion(History.GetGameStateForObjectID(`XCOMHQ.StartingRegion.ObjectID)).GetControllingChosen().GetMyTemplateName();
		OverhaulOptions.InitChosenKnowledge();
	}
	

	
	// Patch chosen if enabled:
	if (!`SecondWaveEnabled('DisableChosen'))
	{

		AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
		AllChosen = AlienHQ.GetAllChosen(, true);


		foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
		{
			// check we're above the minimum FL to activate chosen
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
			if(RegionalAI.LocalForceLevel >= class'X2StrategyElement_DefaultAlienActivities'.default.CHOSEN_ACTIVATE_AT_FL)
			{	
				// loop over each chosen
				foreach AllChosen (ChosenState)
				{
					// Only activate chosen that aren't already active
					if (!ChosenState.bMetXCom)
					{

						if(!ALienHQ.bChosenActive) //mark chosen as active on HQ if they weren't active yet.
						{
							AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
							AlienHQ.OnChosenActivation(NewGameState);
						}

						ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
						ChosenState.Strengths.length = 0;
						ChosenState.NumEncounters++; 

						// Activate this chosen if they aren't active yet
						ChosenState.bMetXCom = true;

						for (i = ChosenState.Weaknesses.length - 1; i >= 0; i--)
						{
							if (ChosenState.Weaknesses[i] != 'ChosenSkirmisherAdversary' && 
								ChosenState.Weaknesses[i] != 'ChosenTemplarAdversary' &&
								ChosenState.Weaknesses[i] != 'ChosenReaperAdversary')
							{
								ChosenState.Weaknesses.Remove(i,1);
							}
						}
						
					}
					//patch the chosen level if needed
					class'X2StrategyElement_DefaultAlienActivities'.static.TryIncreasingChosenLevelWithGameState(RegionalAI.LocalForceLevel, NewGameState, ChosenState);
				}			
			// only do the outer loop once since only one region is needed
			break;
			}
		}
	}
	// Auto grant vulture if needed
	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		// check we're above the minimum FL to activate chosen
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
		if(class'X2StrategyElement_DefaultAlienActivities'.default.bENABLE_AUTO_VULTURE && RegionalAI.LocalForceLevel >= class'X2StrategyElement_DefaultAlienActivities'.default.VULTURE_UNLOCK_AT_FL)
		{
			if(!`XCOMHQ.HasSoldierUnlockTemplate('VultureUnlock'))
			{
				class'X2StrategyElement_DefaultAlienActivities'.static.AddSoldierUnlock(NewGameState,'VultureUnlock');
			}
		}
		break;
	}

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	//make sure that critical narrative moments are active
	foreach History.IterateByClassType(class'XComGameState_Objective', ObjectiveState)
	{
		if (ObjectiveState.GetMyTemplateName() == 'N_GPCinematics')
		{
			if (ObjectiveState.ObjState != eObjectiveState_InProgress)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Forcing N_GPCinematics active");
				ObjectiveState = XComGameState_Objective(NewGameState.ModifyStateObject(class'XComGameState_Objective', ObjectiveState.ObjectID));
				ObjectiveState.StartObjective(NewGameState, true);
				History.AddGameStateToHistory(NewGameState);
			}
			break;
		}
	}

	CleanupObsoleteTacticalGamestate();
	CacheInfiltration_Static();
	//PatchTemplarShieldsIfNeeded();
	RespecTemplarsIfNeeded();
}

static function RespecTemplarsIfNeeded()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference CrewReference;
	local XComGameState_Unit UnitState;

	XComHQ = `XCOMHQ;

	if(default.bDisableRespeccingTemplars)
	{
		return;	
	}

	`LWTrace("Respeccing Templars if needed");
	foreach XComHQ.Crew (CrewReference)
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(CrewReference.ObjectID));
		//`LWTrace("UnitState:" @UnitState);
		if(UnitState != none)
		{
			//`LWTrace("Unit Class:" @UnitState.GetSoldierClassTemplate().DataName);
			if(UnitState.GetSoldierClassTemplate().DataName == 'Templar')
			{
				`LWTrace("Templar Status: " @ UnitState.GetStatus());
				// Covert Action status used for infiltrating units.
				if(UnitState.GetStatus() == eStatus_CovertAction)
				{
					continue;
				}

				//Account for Kiruka's overhaul
				//if(class'Helpers_LW'.default.bKirukaFactionOverhaulActive && !class'Helpers_LW'.default.bNewTemplarModJamActive)
				//{
				//	`LWTrace("Kiruka overhaul found, aborting respec");
				//	return;
				//}

			`LWTrace("Templar abilities at squaddie pos 0:" @UnitState.AbilityTree[0].Abilities[0].AbilityName);
			`LWTrace("Templar abilities at squaddie pos 1:" @UnitState.AbilityTree[0].Abilities[1].AbilityName);
			`LWTrace("Templar abilities at squaddie pos 2:" @UnitState.AbilityTree[0].Abilities[2].AbilityName);
			`LWTrace("Templar abilities at squaddie pos 3:" @UnitState.AbilityTree[0].Abilities[3].AbilityName);
			`LWTrace("Templar abilities at squaddie pos 4:" @UnitState.AbilityTree[0].Abilities[4].AbilityName);
			 if(UnitState.AbilityTree[0].Abilities.Find('AbilityName','IRI_TemplarShield') == INDEX_NONE)
			 {
				`LWTrace("New Templar Shield not found on the unit, respeccing.");
				RespecSoldier(UnitState, true);
			 }
			}
		}
	}
}


static function PatchTemplarShieldsIfNeeded()
{
	local X2SoldierClassTemplateManager ClassMGR;
	local array<X2DataTemplate> DifficultyVariants;
	local X2DataTemplate DifficultyVariant;
	local X2SoldierClassTemplate TemplarTemplate;
	local SoldierClassWeaponType SoldierWeaponType;

	`LWTrace("Patching Templar Class Template if needed");
	if(class'Helpers_LW'.default.bKirukaFactionOverhaulActive && !class'Helpers_LW'.default.bNewTemplarModJamActive)
	{
		`LWTrace("Kiruka overhaul found, adding shields back to Templar");

		ClassMGR = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
		ClassMGR.FindDataTemplateAllDifficulties('Templar', DifficultyVariants);
		foreach DifficultyVariants (DifficultyVariant)
		{
			TemplarTemplate = X2SoldierClassTemplate(DifficultyVariant);
			`LWTrace("Templar Template Found:" @TemplarTemplate);

			if(TemplarTemplate != none)
			{
				TemplarTemplate.bNoSecondaryWeapon=false;

				SoldierWeaponType.WeaponType = 'templarshield';
				SoldierWeaponType.SlotType = eInvSlot_SecondaryWeapon;

				TemplarTemplate.AllowedWeapons.AddItem(SoldierWeaponType);
			}
		}
	}
	return;
}

// Make sure we're not overriding classes already overridden by another
// mod, such as Detailed Soldier List. Thanks to Musashi for the basic
// code (as used in RPGO).
static function PatchModClassOverrides()
{
	local Engine LocalEngine;
	local ModClassOverrideEntry MCO;

	LocalEngine = class'Engine'.static.GetEngine();
	foreach default.ModClassOverrides(MCO)
	{
		if (LocalEngine.ModClassOverrides.Find('BaseGameClass', MCO.BaseGameClass) != INDEX_NONE)
		{
			`LWTrace(GetFuncName() @ "Found existing MCO for base class" @ MCO.BaseGameClass @ " - SKIPPING");
			continue;
		}
		LocalEngine.ModClassOverrides.AddItem(MCO);
		`LWTrace(GetFuncName() @ "Adding Mod Class Override -" @ MCO.BaseGameClass @ MCO.ModClass);
	}
}

static function SaveSecondWaveOptions()
{	
	local UIShellDifficulty ShellDifficultyUI;
	local UIShellDifficultySW NewShellDifficultyUI;
	local SecondWaveOption SWOption;
	local SecondWaveOptionObject NewSWOption;
	local SecondWavePersistentData PersistentData;
	local PersistentSecondWaveOption PersistentOption;
	local XComGameState_CampaignSettings CampaignSettingsState;

	
	ShellDifficultyUI = UIShellDifficulty(class'Engine'.static.FindClassDefaultObject("XComGame.UIShellDifficulty"));
	NewShellDifficultyUI = UIShellDifficultySW(class'Engine'.static.FindClassDefaultObject("BetterSecondWaveSupport.UIShellDifficultySW"));
	CampaignSettingsState = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	PersistentData = new class'SecondWavePersistentData';

	// Clear existing data from INI first
	PersistentData.SecondWaveOptionList.Length = 0;
	PersistentData.SaveConfig();

	// Save difficulty and beginner VO settings
	PersistentData.IsDifficultySet = true;
	PersistentData.Difficulty = CampaignSettingsState.DifficultySetting;
	PersistentData.DisableBeginnerVO = CampaignSettingsState.bSuppressFirstTimeNarrative;

	// Add base-game second wave options
	foreach ShellDifficultyUI.SecondWaveOptions(SWOption)
	{
		PersistentOption.ID = SWOption.ID;
		PersistentOption.IsChecked = CampaignSettingsState.SecondWaveOptions.Find(PersistentOption.ID) != INDEX_NONE;
		PersistentData.SecondWaveOptionList.AddItem(PersistentOption);
	}

	// Add extra second wave options
	foreach NewShellDifficultyUI.SecondWaveOptionsReal(NewSWOption)
	{
		PersistentOption.ID = NewSWOption.OptionData.ID;
		PersistentOption.IsChecked = CampaignSettingsState.SecondWaveOptions.Find(PersistentOption.ID) != INDEX_NONE;
		PersistentData.SecondWaveOptionList.AddItem(PersistentOption);
	}

	// Save the new second wave settings
	`LWTrace("Saving second wave options");
	PersistentData.SaveConfig();
}

static function XComGameState_WorldRegion SetStartingLocationToStartingRegion(XComGameState StartState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	foreach StartState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	XComHQ.CurrentLocation = XComHQ.StartingRegion;
	return XComGameState_WorldRegion(StartState.GetGameStateForObjectID(XComHQ.StartingRegion.ObjectID));
}

// TODO: This function is only needed for players that want to upgrade
// from a version of LW prior to beta 2 and want access to the pistol
// abilities.

// Tedster: beta is old, yeeting this.

/*
static function LWMigratePistolAbilities()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local int i, j;
	local bool UnitHasPistolAbilities;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update unit pistol abilities for pistol slot");

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (!UnitState.IsSoldier() || UnitState.IsResistanceHero())
		{
			// Faction soldiers and non-soldiers don't have the Pistol ability row
			continue;
		}

		// Iterate over the whole ability tree looking for pistol abilities. For
		// those that are found, change the `ApplyToWeaponSlot` property to the
		// new pistol slot.
		UnitHasPistolAbilities = false;
		for (i = 0; i < UnitState.AbilityTree.Length; i++)
		{
			for (j = 0; j < UnitState.AbilityTree[i].Abilities.Length; j++)
			{
				// If any of the abilities are already configured for the pistol slot, skip them
				if (UnitState.AbilityTree[i].Abilities[j].ApplyToWeaponSlot == eInvSlot_Pistol)
				{
					break;
				}

				switch (UnitState.AbilityTree[i].Abilities[j].AbilityName)
				{
				case 'ReturnFire':
				case 'Quickdraw':
				case 'ClutchShot':
				case 'Gunslinger':
				case 'LightningHands':
				case 'Faceoff':
				case 'FanFire':
					if (!UnitHasPistolAbilities)
					{
						UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
						UnitHasPistolAbilities = true;
					}
					UnitState.AbilityTree[i].Abilities[j].ApplyToWeaponSlot = eInvSlot_Pistol;
					break;
				default:
					break;
				}
			}
		}
	}
		
	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

*/

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

/// <summary>
/// Called when viewing mission blades, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool UpdateMissionSpawningInfo(StateObjectReference MissionRef)
{
	local XComGameState_MissionSite MissionState;
	local MissionDefinition MissionDef;
	local XComGameState NewGameState;
	local bool bUpdated;

	// We need to clear up the mess that the Alien Rulers DLC leaves in its wake.
	// In this case, it clears all the alien ruler gameplay tags from XComHQ, just
	// before the schedules are picked (which rely on those tags). And of course it
	// may apply the ruler tags itself when we don't want them. Bleh.
	if (class'XComGameState_AlienRulerManager' != none)
	{
		bUpdated = FixAlienRulerTags(MissionRef);
	}

	// Patching waterworld hardcoded stuff
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));

	// Waterworld hardcoded here.
	if(MissionState.GetMissionSource().DataName == 'MissionSource_Final' && default.bUpdateWaterworldLW)
	{

		// LW waterworld hardcode here:
		`TACTICALMISSIONMGR.GetMissionDefinitionForType("GP_Fortress_LW", MissionDef);


		if(instr(MissionState.GeneratedMission.Mission.MapNames[0], "_LW") != -1)
		{
			return bUpdated;
		}

		`Log("Mission Def mapname:" @MissionDef.MapNames[0],, 'TedLog');

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Mission Data");

		MissionState = XComGameState_MissionSite(NewGameState.ModifyStateObject(class'XComGameState_MissionSite', MissionState.ObjectID));
		MissionState.GeneratedMission.Mission.MapNames[0]="Obj_FortressLeadup_LW";
	
		`Log("Updating waterworld cached missiondef.",,'TedLog');

		`GAMERULES.SubmitGameState(NewGameState);

		return true;
	}

	// Psi Gate here:

	if(MissionState.GetMissionSource().DataName == 'MissionSource_PsiGate' && default.bUpdateWaterworldLW)
	{

		// LW waterworld hardcode here:
		`TACTICALMISSIONMGR.GetMissionDefinitionForType("GP_PsiGate_LW", MissionDef);

		
		if(instr(MissionState.GeneratedMission.Mission.MapNames[0], "_LW") != -1)
		{
			return bUpdated;
		}

		`Log("Mission Def mapname:" @MissionDef.MapNames[0],, 'TedLog');

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Mission Data");

		MissionState = XComGameState_MissionSite(NewGameState.ModifyStateObject(class'XComGameState_MissionSite', MissionState.ObjectID));
		MissionState.GeneratedMission.Mission.MapNames[0]="Obj_PsiGate_LW";
	
		`Log("Updating PsiGate cached missiondef.",,'TedLog');

		`GAMERULES.SubmitGameState(NewGameState);

		return true;
	}


	return bUpdated;
}

static function bool FixAlienRulerTags(StateObjectReference MissionRef)
{
	local XComGameState_AlienRulerManager RulerMgr;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_MissionSite MissionState;
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local name CurrentTag;
	local bool bUpdated;

	History = `XCOMHISTORY;
	bUpdated = false;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LWOTC: Fix Alien Ruler gameplay tags");
	RulerMgr = XComGameState_AlienRulerManager(History.GetSingleGameStateObjectForClass(class'XComGameState_AlienRulerManager'));
	RulerMgr = XComGameState_AlienRulerManager(NewGameState.ModifyStateObject(class'XComGameState_AlienRulerManager', RulerMgr.ObjectID));
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(MissionRef.ObjectID));

	// Check whether DLC has added active ruler tags to XComHQ. We don't want
	// them if there are any.
	if (class'LWDLCHelpers'.static.TagArrayHasActiveRulerTag(XComHQ.TacticalGameplayTags))
	{
		// Clear existing active tags out so we can replace them.
		RulerMgr.ClearActiveRulerTags(XComHQ);
		bUpdated = true;
	}

	// Add back any mission active ruler tags that DLC 2 will have kindly
	// removed from XComHQ for us. This is important to ensure that the
	// alien rulers are added to the mission schedule if it's possible.
	if (class'LWDLCHelpers'.static.IsAlienRulerOnMission(MissionState))
	{
		foreach MissionState.TacticalGameplayTags(CurrentTag)
		{
			if (class'LWDLCHelpers'.default.AlienRulerTags.Find(CurrentTag) != INDEX_NONE)
			{
				// Found an active Ruler tag, so add it to XComHQ.
				XComHQ.TacticalGameplayTags.AddItem(CurrentTag);
				AddRulerAdditionalTags(MissionState, XComHQ, CurrentTag);
				bUpdated = true;
			}
		}
	}

	if (bUpdated)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	return bUpdated;
}

static function AddRulerAdditionalTags(
	XComGameState_MissionSite MissionState,
	XComGameState_HeadquartersXCom XComHQ,
	name RulerActiveTacticalTag)
{
	local int i, RulerIndex;

	for (i = 0; i < class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates.Length; i++)
	{
		if (class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[i].ActiveTacticalTag == RulerActiveTacticalTag)
		{
			RulerIndex = i;
			break;
		}
	}

	// Check the mission alert level against the thresholds for Alien Ruler
	// pod size. If the alert level is below the first threshold, then we
	// don't add any additional tags. Otherwise we pull the required additional
	// tag from the Alien Ruler template config.
	for (i = 0; i < default.RULER_POD_SIZE_ALERT_THRESHOLDS.Length; i++)
	{
		if (MissionState.SelectedMissionData.AlertLevel < default.RULER_POD_SIZE_ALERT_THRESHOLDS[i])
		{
			if (i > 0)
			{
				XComHQ.TacticalGameplayTags.AddItem(
						class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[RulerIndex].AdditionalTags[i - 1].TacticalTag);
			}
			break;
		}
	}
}

private static function int SortNames(name NameA, name NameB)
{
	local string StringA, StringB;

	StringA = string(NameA);
	StringB = string(NameB);

	if (StringA < StringB)
	{
		return 1;
	}
	else if (StringA > StringB)
	{
		return -1;
	}
	else
	{
		return 0;
	}
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
	local name TacticalTag;

	History = `XCOMHISTORY;

	`LWACTIVITYMGR.UpdatePreMission (StartGameState, MissionState);
	ResetDelayedEvac(StartGameState);
	ResetReinforcements(StartGameState);
	InitializePodManager(StartGameState);
	OverrideConcealmentAtStart(MissionState);
	OverrideDestructibleHealths(StartGameState);
	MaybeAddChosenToMission(StartGameState, MissionState);
	if (class'XComGameState_AlienRulerManager' != none)
	{
		OverrideAlienRulerSpawning(StartGameState, MissionState);
	}

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

	foreach MissionState.TacticalGameplayTags (TacticalTag)
	{
		`LWTrace("Tactical Tag on mission:" @TacticalTag);
	}

	foreach `XCOMHQ.TacticalGameplayTags (TacticalTag)
	{
		`LWTrace("Tactical Tag on HQ:" @TacticalTag);
	}

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
	CacheInfiltration_Static();
}

// Disable the Lost if we don't meet certain conditions. This is also
// called for the creation of Gatecrasher.
static function PostSitRepCreation(out GeneratedMissionData GeneratedMission, optional XComGameState_BaseObject SourceObject)
{
	//local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_WorldRegion Region;
	local XComGameState_MissionSite Mission;
	local XComGameState_LWAlienActivity Activity;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	//AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	Activity = XComGameState_LWAlienActivity(SourceObject);
	Mission = XComGameState_MissionSite(SourceObject);

	if(Activity != none)
	{
		Region = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(Activity.PrimaryRegion.ObjectID));
	}

	if(Mission != none)
	{
		Region = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(Mission.Region.ObjectID));
	}

	if(Region != none)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);

		// Disable TheLost SitRep if we haven't reached the appropriate force level yet.
		if (RegionalAI.LocalForceLevel < default.MIN_FL_FOR_LOST[`TACTICALDIFFICULTYSETTING])
		{
		GeneratedMission.SitReps.RemoveItem('TheLost');
		GeneratedMission.SitReps.RemoveItem('TheHorde');
		}
	}
	// If we don't have a region, also disable it so you don't get them on CAD.
	else
	{
		GeneratedMission.SitReps.RemoveItem('TheLost');
		GeneratedMission.SitReps.RemoveItem('TheHorde');
	}
}

// Diversify pod makeup, especially with all-alien pods which typically consist
// of the same alien unit. This also makes a few other adjustments to pods.
static function PostEncounterCreation(out name EncounterName, out PodSpawnInfo SpawnInfo, int ForceLevel, int AlertLevel, optional XComGameState_BaseObject SourceObject)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local name								CharacterTemplateName, FirstFollowerName, NewMostCommonMember;
	local int								idx, Tries, PodSize, k, numAttempts, iNumCommonUnits, j, ProperPodLength;
	local X2CharacterTemplateManager		TemplateManager;
	local X2CharacterTemplate				LeaderCharacterTemplate, FollowerCharacterTemplate, CurrentCharacterTemplate, NewCommonTemplate;
	local bool								Swap, Satisfactory, bKeepTrying, bIsRNF;
	local XComGameState_MissionSite			MissionState;
	local XComGameState_AIReinforcementSpawner	RNFSpawnerState;
	local XComGameState_HeadquartersXCom XCOMHQ;
	local array<SpawnDistributionListEntry>	LeaderSpawnList;
	local array<SpawnDistributionListEntry>	FollowerSpawnList;
	local PodSizeConversion PodConversion;
	local array<name> GoodUnits;
	local array<name> BadUnits;

	`LWDiversityTrace("LWotC Diversity System Started during PostEncounterCreation");

	`LWTrace("PostEncounterCreation called with FL" @ForceLevel @" and Alert" @AlertLevel);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	

	//INSTANT BAILOUTS THAT NEED NO FURTHER INVESTIGATIONS
	if(default.bDisableDiversitySystem)
	{
		`LWTrace("LWotC Diversity System Disabled by Config");
		return;
	}

	if(class'Helpers_LW'.default.bDABFLActive)
	{
		`LWDiversityTrace("DABFL Detected, aborting.");
		return;
	}

	//BAILOUTS THAT REQUIRE SOME INVESTIGATION
	History = `XCOMHISTORY;
	MissionState = XComGameState_MissionSite(SourceObject);
	if (MissionState == none)
	{
		BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData', true));
		if (BattleData == none)
		{
			//NO BATTLE DATA
			`LWDiversityTrace("Could not detect mission type. Aborting with no mission variations applied.");
			return;
		}
		else
		{
			//UPDATE MISSION STATE TO THE ONE FROM BATTLE DATA - WHY ?
			MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));
		}
	}

	// filter out dummy missions used by squad select infiltration calcs
	if(MissionState.Source == 'LWInfilListDummyMission')
	{
		`LWTrace("Dummy mission for squad select detected, aborting diversity algorithm");
		return;
	}

	// Ignore the final and any DLC missions, AND ANY EXCLUDED BY CONFIG
	`LWDiversityTrace("Mission type = " $ MissionState.GeneratedMission.Mission.sType $ " detected.");
	switch(MissionState.GeneratedMission.Mission.sType)
	{
		case "GP_Fortress":
		case "GP_Fortress_LW":
			`LWDiversityTrace("Fortress mission detected. Aborting with no mission variations applied.");
			return;
		case "AlienNest":
		case "LastGift":
		case "LastGiftB":
		case "LastGiftC":
			`LWDiversityTrace("DLC mission detected. Aborting with no mission variations applied.");
			return;
		default:
			if (default.MissionsToNotDiversify.Find(MissionState.GeneratedMission.Mission.sType) != INDEX_NONE)
			{
				`LWDiversityTrace("CONFIG Excluded mission detected. Aborting with no mission variations applied.");
				return;
			}
			break;
	}

	`LWDiversityTrace("ENCOUNTER NAME:" @EncounterName);

	// Double check for the final mission. [PAL Not sure this is necessary as the original
	// code had no comment explaining why both the mission type and the encounter name are
	// checked]
	if (Left(string(EncounterName), 11) == "GP_Fortress")
	{
		`LWDiversityTrace("Fortress mission detected. Aborting with no mission variations applied.");
		return;
	}

	// Ignore STORY STUFF BY ENCOUNTER NAME
	switch (EncounterName)
	{
		case 'LoneAvatar':
		case 'LoneCodex':
			`LWDiversityTrace("Story Encounter detected. Aborting.");
			return;
		default:
			break;
	}

	// Ignore explicitly protected encounters
	if (InStr (EncounterName, "PROTECTED") != INDEX_NONE 
  		|| default.EncountersToExclude.Find(EncounterName) != INDEX_NONE)
	{
		`LWDiversityTrace("PROTECTED Encounter detected. Aborting.");
		return;
	}

	// Ignore vanilla boss pods
	if (InStr(EncounterName, "LIST_BOSSx") != INDEX_NONE && InStr(EncounterName, "_LW") == INDEX_NONE)
	{
		`LWDiversityTrace("Don't Edit certain vanilla Boss pods");
		return;
	}

	// Ignore chryssy pods
	if (Instr(EncounterName, "Chryssalids") != INDEX_NONE)
	{
		`LWDiversityTrace("Don't edit Chryssypods");
		return;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//CONTINUE TO PROCESS ENCOUNTER
	`LWTrace("Pod Diversity System processing this pod.");
	`LWTrace("Parsing Encounter : " $ EncounterName);

	`LWTrace("Encounter composition:");
	foreach SpawnInfo.SelectedCharacterTemplateNames(CharacterTemplateName, idx)
	{
		`LWTrace("Character[" $ idx $ "] = " $ CharacterTemplateName);
	}

	// Get the corresponding spawn distribution lists for this mission.
	`LWDiversityTrace("Getting Leader Spawn Distribution List: ");
	GetLeaderSpawnDistributionList(EncounterName, MissionState, ForceLevel, LeaderSpawnList, GoodUnits, BadUnits);

	`LWDiversityTrace("Getting Follower Spawn Distribution List: ");
	GetFollowerSpawnDistributionList(EncounterName, MissionState, ForceLevel, FollowerSpawnList, GoodUnits, Badunits);

	//`LWTRACE("PE1");
	RNFSpawnerState = XComGameState_AIReinforcementSpawner(SourceObject);

	//	`LWTRACE ("PE2");
	if (RNFSpawnerState != none)
	{
		bIsRNF = true;
		`LWDiversityTrace("Called from AIReinforcementSpawner.OnReinforcementSpawnerCreated -- modifying reinforcement spawninfo");
	}
	else
	{
		if (MissionState != none)
		{
			`LWDiversityTrace("Called from MissionSite.CacheSelectedMissionData -- modifying preplaced spawninfo");
		}
	}

	//`LWTRACE ("PE3");

	//UPDATE XCOMHQ
	XCOMHQ = XComGameState_HeadquartersXCom(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

	PodSize = SpawnInfo.SelectedCharacterTemplateNames.length;

	TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	LeaderCharacterTemplate = TemplateManager.FindCharacterTemplate(SpawnInfo.SelectedCharacterTemplateNames[0]);

	swap = false;

	// Tedster - none check leader Character template
	if(LeaderCharacterTemplate == none)
	{
		`LWDiversityTrace("Nonexistant Pod Leader found.");
		swap = true;
		SpawnInfo.SelectedCharacterTemplateNames[0] = SelectNewPodLeader(SpawnInfo, ForceLevel, LeaderSpawnList);
		`LWDiversityTrace("Swapping Nonexistant leader for" @ SpawnInfo.SelectedCharacterTemplateNames[0] @ "and rerolling followers");
	}
	// override native insisting every mission have a codex while certain tactical options are active

	// Swap out forced Codices on regular encounters
	if (SpawnInfo.SelectedCharacterTemplateNames[0] == 'Cyberus' && InStr (EncounterName,"PROTECTED") == INDEX_NONE && EncounterName != 'LoneCodex' && EncounterName != 'GP_PsiGate_CodexGuards')
	{
		swap = true;
		SpawnInfo.SelectedCharacterTemplateNames[0] = SelectNewPodLeader(SpawnInfo, ForceLevel, LeaderSpawnList);
		`LWDiversityTrace("Swapping Codex leader for" @ SpawnInfo.SelectedCharacterTemplateNames[0]);
	}

	if ( RNFSpawnerState != none && default.NoReinforcementEnemies.Find(SpawnInfo.SelectedCharacterTemplateNames[0]) != INDEX_NONE)
	{
		swap = true;
		SpawnInfo.SelectedCharacterTemplateNames[0] = SelectNewPodLeader(SpawnInfo, ForceLevel, LeaderSpawnList, true);
		`LWDiversityTrace("Swapping Banned RNF leader for" @ SpawnInfo.SelectedCharacterTemplateNames[0]);
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
					SpawnInfo.SelectedCharacterTemplateNames[0] = SelectNewPodLeader(SpawnInfo, ForceLevel, LeaderSpawnList);
					`LWDiversityTrace("Swapping Avatar leader for" @ SpawnInfo.SelectedCharacterTemplateNames[0]);
					break;
			}
		}
	}

	// reroll advent captains when the game is forcing captains
	if (RNFSpawnerState != none && InStr(SpawnInfo.SelectedCharacterTemplateNames[0],"Captain") != INDEX_NONE)
	{
		if (   XCOMHQ.GetObjectiveStatus('T1_M3_KillCodex') == eObjectiveState_InProgress
			|| XCOMHQ.GetObjectiveStatus('T1_M5_SKULLJACKCodex') == eObjectiveState_InProgress
			|| XCOMHQ.GetObjectiveStatus('T1_M6_KillAvatar') == eObjectiveState_InProgress
			|| XCOMHQ.GetObjectiveStatus('T1_M2_S3_SKULLJACKCaptain') == eObjectiveState_InProgress)
		swap = true;
		SpawnInfo.SelectedCharacterTemplateNames[0] = SelectNewPodLeader(SpawnInfo, ForceLevel, LeaderSpawnList);
		`LWDiversityTrace("Swapping Reinf Captain leader for" @ SpawnInfo.SelectedCharacterTemplateNames[0]);
	}

	//UPDATE THE NEWLY SELECTED LEADER TEMPLATE
	LeaderCharacterTemplate = TemplateManager.FindCharacterTemplate(SpawnInfo.SelectedCharacterTemplateNames[0]);
	`LWDiversityTrace("Pod Leader:" @ SpawnInfo.SelectedCharacterTemplateNames[0]);

	//MORE BAILOUTS
	if (LeaderCharacterTemplate.bIsTurret)
	{
		`LWDiversityTrace("Pod Leader was TURRET. Aborting.");
		return;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// Now deal with followers, podsize greater than 1 ensures we have a leader and at least one follower
	// THIS excludes single-unit pods such as Turrets, Chosen, Story-pods, cocoons etc
	if (PodSize > 1)
	{
		// Find whatever the pod has the most of
		FirstFollowerName = FindMostCommonMember(SpawnInfo.SelectedCharacterTemplateNames);
		FollowerCharacterTemplate = TemplateManager.FindCharacterTemplate(FirstFollowerName);
		`LWDiversityTrace("Main Pod Follower:" @ FirstFollowerName);

		// handle bad pod size stuff
		if(CheckPodSize(EncounterName, SpawnInfo, ForceLevel, AlertLevel, ProperPodLength, SourceObject))
		{
			// Fill out the pod as is then pass into the normal system.
			for(j = 1; j < ProperPodLength; j++)
			{
				SpawnInfo.SelectedCharacterTemplateNames[j] = SelectRandomPodFollower_Improved(SpawnInfo, LeaderCharacterTemplate.SupportedFollowers, ForceLevel, FollowerSpawnList);
			}
			swap = true;
		}

		// Handle vanilla pod construction of one type of alien follower;
		if (LeaderCharacterTemplate.bIsAlien && FollowerCharacterTemplate.bIsAlien && CountMembers(FirstFollowerName, SpawnInfo.SelectedCharacterTemplateNames) > 1)
		{
			`LWDiversityTrace("Mixing up alien-dominant pod");
			swap = true;
		}

		// Check for pod members that shouldn't appear yet for plot reaons
		// DO OBJECTIVE CHECK FIRST BECAUSE IF IT DOESNT PASS THERE, IT'LL SHORT CIRCUIT AND ONLY DO THE COUNT IF ITS NEEDED TOO
		if (XCOMHQ.GetObjectiveStatus('T1_M2_S3_SKULLJACKCaptain') != eObjectiveState_Completed && CountMembers('Cyberus', SpawnInfo.SelectedCharacterTemplateNames) >= 1 )
		{
			`LWDiversityTrace("Removing Codex for objective reasons");
			swap = true;
		}

		if (XCOMHQ.GetObjectiveStatus('T1_M5_SKULLJACKCodex') != eObjectiveState_Completed && CountMembers ('AdvPsiWitch', SpawnInfo.SelectedCharacterTemplateNames) >= 1 )
		{
			`LWDiversityTrace("Exicising Avatar for objective reasons");
			swap = true;
		}

		//STILL NOT FOUND SOMETHING TO SWAP FROM LEADERS AND COMMON, CHECK EVERYTHING ELSE
		if (!swap)
		{
			for (k = 1; k < SpawnInfo.SelectedCharacterTemplateNames.Length; k++)
			{
				//GET THIS FOLLOWER AT THIS POSITION
				FollowerCharacterTemplate = TemplateManager.FindCharacterTemplate(SpawnInfo.SelectedCharacterTemplateNames[k]);
				if(FollowerCharacterTemplate == none)
				{
					`LWDiversityTrace("Detected nonexistant follower" @ SpawnInfo.SelectedCharacterTemplateNames[k]);
					swap = true;
				}

				// Tedster - add check for plot gating here:
				if(!XCOMHQ.MeetsObjectiveRequirements(FollowerCharacterTemplate.SpawnRequirements.RequiredObjectives))
				{
					// reroll the unit instead of shuffling all pods to allow codex to to be added to pods as defined followers.
					SpawnInfo.SelectedCharacterTemplateNames[k] = SelectRandomPodFollower_Improved(SpawnInfo, LeaderCharacterTemplate.SupportedFollowers, ForceLevel, FollowerSpawnList);

					//GET THIS 'NEW' FOLLOWER AT THIS POSITION
					FollowerCharacterTemplate = TemplateManager.FindCharacterTemplate(SpawnInfo.SelectedCharacterTemplateNames[k]);
					if(FollowerCharacterTemplate == none)
					{
						`LWDiversityTrace("Detected nonexistant follower" @ SpawnInfo.SelectedCharacterTemplateNames[k]);
						swap = true;
					}
				}

				// Tedster - nerf frost legion
				if(default.bNerfFrostLegion 
					&& (InStr(CAPS(SpawnInfo.SelectedCharacterTemplateNames[k]), "FROST") != INDEX_NONE || InStr(CAPS(SpawnInfo.SelectedCharacterTemplateNames[k]), "CRYO")!= INDEX_NONE) 
					&& MissionState.TacticalGameplayTags.Find('SITREP_FrostPurge') == INDEX_NONE)
				{
					`LWDiversityTrace("Found Frost Legion in Encounter");
					swap = true;
				}

				// Tedster - fix below check to check spawn entry and not character template MCPG setting.
				if (CountMembers(SpawnInfo.SelectedCharacterTemplateNames[k], SpawnInfo.SelectedCharacterTemplateNames) 
					> GetCharacterSpawnEntry(FollowerSpawnList, FollowerCharacterTemplate, ForceLevel).MaxCharactersPerGroup)
				{
					`LWDiversityTrace("Too many" @SpawnInfo.SelectedCharacterTemplateNames[k] @"; Max specified:" @ GetCharacterSpawnEntry(FollowerSpawnList, FollowerCharacterTemplate, ForceLevel).MaxCharactersPerGroup);
					swap = true;
				}
				// Ban certain enemies from RNF pods.
				if(bIsRNF && default.NoReinforcementEnemies.find(SpawnInfo.SelectedCharacterTemplateNames[k]) != INDEX_NONE)
				{
					swap = true;
				}
			}
			if (swap)
			{
				`LWDiversityTrace("Mixing up pod that violates MCPG setting or contains nonexistant units.");
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//STILL NOT FOUND SOMETHING TO SWAP FROM ABOVE, CHECK AGINST POD SIZES
	if (!swap)
	{
		//THIS IS NOT THE FIRST FOLLOWER, BUT THE MOST COMMON FOLLOWER, THE VALUE NAME IS A BIT AMBIGUOUS!
		FollowerCharacterTemplate = TemplateManager.FindCharacterTemplate(FirstFollowerName);
		iNumCommonUnits = CountMembers(FirstFollowerName, SpawnInfo.SelectedCharacterTemplateNames);

		if (PodSize >= 3)
		{
			foreach default.PodSizeConversions(PodConversion)
			{
				if (!swap && (Podsize == PodConversion.PodSize || PodConversion.PodSize == -1)) 
				{
					if ( iNumCommonUnits > PodConversion.SameUnitMaxLimit)
					{
						`LWDiversityTrace("Mixing up undiverse enemy pod of size" @Podsize);
						swap = true;
					}

					// more strignant for Aliens
					if ( iNumCommonUnits > PodConversion.SameUnitMaxLimitAliens && FollowerCharacterTemplate.bIsAlien)
					{
						`LWDiversityTrace("Mixing up undiverse alien enemy pod of size" @Podsize);
						swap = true;
					}
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//FOUND SOMETHING TO SWAP! WOO HOO
	if (swap)
	{
		// Re-roll the follower character templates
		Satisfactory = false;
		Tries = 0;
		
		While (!Satisfactory && Tries < 16)
		{
			foreach SpawnInfo.SelectedCharacterTemplateNames(CharacterTemplateName, idx)
			{
				`LWDiversityTrace("Rerolling Position" @idx);
				CurrentCharacterTemplate = TemplateManager.FindCharacterTemplate(SpawnInfo.SelectedCharacterTemplateNames[idx]);
				//`LWTrace("Looking at" @CurrentCharacterTemplate.DataName);
				//Tedster - add none check here as well:
				if(CurrentCharacterTemplate == none)
				{
					`LWDiversityTrace("Rerolling nonexistant Character Template.");
					SpawnInfo.SelectedCharacterTemplateNames[idx] = SelectRandomPodFollower_Improved(SpawnInfo, LeaderCharacterTemplate.SupportedFollowers, ForceLevel, FollowerSpawnList, bIsRNF);
				}

				//BAIL CONDITIONS, Tedster - fix off by one error 2 -> 1
				if (idx <= 1
					|| (SpawnInfo.SelectedCharacterTemplateNames[idx] != FirstFollowerName)
					|| CurrentCharacterTemplate.bIsTurret)
				{
					continue;
				}

				SpawnInfo.SelectedCharacterTemplateNames[idx] = SelectRandomPodFollower_Improved(SpawnInfo, LeaderCharacterTemplate.SupportedFollowers, ForceLevel, FollowerSpawnList, bIsRNF);
				`LWDiversityTrace("Selected new follower for position" @idx @":" @ SpawnInfo.SelectedCharacterTemplateNames[idx]);
				if(CurrentCharacterTemplate == none)
				{
					`LWDiversityTrace("Rerolling nonexistant Character Template.");
					continue;
				}

				if(default.bNerfFrostLegion 
					&& (InStr(CAPS(SpawnInfo.SelectedCharacterTemplateNames[k]), "FROST") != INDEX_NONE || InStr(CAPS(SpawnInfo.SelectedCharacterTemplateNames[k]), "CRYO") != INDEX_NONE))
				{
					// 80% chance to reroll frost legion, FRAND IS A VALUE BETWEEN 1.00 AND 0.00
					if(`SYNC_FRAND_STATIC() < 0.8)
					{
						`LWDiversityTrace("Nerfing Frost Legion roll succeeded");
						bKeeptrying = true;
						numAttempts = 0;
						while (numAttempts < 12 && bKeepTrying)
						{
							SpawnInfo.SelectedCharacterTemplateNames[idx] = SelectRandomPodFollower_Improved(SpawnInfo, LeaderCharacterTemplate.SupportedFollowers, ForceLevel, FollowerSpawnList, bIsRNF);

							if((InStr(CAPS(SpawnInfo.SelectedCharacterTemplateNames[k]), "FROST") != INDEX_NONE || InStr(CAPS(SpawnInfo.SelectedCharacterTemplateNames[k]), "CRYO") != INDEX_NONE))
							{
								numAttempts++;
							}
							else
							{
								bKeeptrying = false;
							}
						}
					}
				
				}
				//`LWTrace("Changed to" @SpawnInfo.SelectedCharacterTemplateNames[idx] );
			}

			//`LWTRACE ("Try" @ string (tries) @ CountMembers (FirstFollowerName, SpawnInfo.SelectedCharacterTemplateNames) @ string (PodSize));
			// Let's look over our outcome and see if it's any better
			NewMostCommonMember = FindMostCommonMember(SpawnInfo.SelectedCharacterTemplateNames);
			NewCommonTemplate = TemplateManager.FindCharacterTemplate(NewMostCommonMember);
			iNumCommonUnits = CountMembers(NewMostCommonMember, SpawnInfo.SelectedCharacterTemplateNames);

			//skip? chryssie pods
			if(  SpawnInfo.SelectedCharacterTemplateNames[0] == 'Chryssalid' 
			  || SpawnInfo.SelectedCharacterTemplateNames[0] == 'ChryssalidSoldier' 
			  || SpawnInfo.SelectedCharacterTemplateNames[0] == 'HiveQueen')
			{
				Satisfactory = true;
			}

			// Failsafe to avoid crashing if it's empty
			`LWDiversityTrace("PodSizeConversions length:" @default.PodSizeConversions.Length);
			if(default.PodSizeConversions.Length == 0)
			{
				`LWTrace("WARNING: Somebody screwed up the PodSizeConversions array and it's empty, Pod Diversity system DEFINITELY won't work correctly.");
				Satisfactory = true;
			}

			foreach default.PodSizeConversions(PodConversion)
			{
				
				if (PodSize == PodConversion.PodSize || PodConversion.PodSize == -1)
				{
					`LWDiversityTrace("Checking PodSize" @Podsize);
					if (   (iNumCommonUnits > PodConversion.SameUnitMaxLimit) 
						|| ((iNumCommonUnits > PodConversion.SameUnitMaxLimitAliens) && NewCommonTemplate.bIsAlien)
						)
					{
						`LWDiversityTrace("Condition failed for PodSize" @Podsize);
						Tries++;
						break;
					}
					else
					{
						`LWDiversityTrace("Setting Satisfactory to True; Tries:" @Tries);
						Satisfactory = true;
					}
				}
				
			}

		} //END WHILE LOOP

		//FINALLY LOG THE RESULTS
		`LWTrace("Attempted to edit Encounter to add more enemy diversity! Satisfactory:" @ satisfactory);
		foreach SpawnInfo.SelectedCharacterTemplateNames (CharacterTemplateName, idx)
		{
			`LWTrace("Character[" $ idx $ "] = " $ CharacterTemplateName);
		}

	}
	else
	{
		`LWTrace("No changes needed to pod.");
	}
	return;
}

static function GetLeaderSpawnDistributionList(name EncounterName, XComGameState_MissionSite MissionState, int ForceLevel, out array<SpawnDistributionListEntry> SpawnList,out array<name> GoodUnits, out array<name> BadUnits )
{
	GetSpawnDistributionList(EncounterName, MissionState, ForceLevel, SpawnList, true, GoodUnits, BadUnits);
}

static function GetFollowerSpawnDistributionList(name EncounterName, XComGameState_MissionSite MissionState, int ForceLevel, out array<SpawnDistributionListEntry> SpawnList, out array<name> GoodUnits, out array<name> BadUnits)
{
	GetSpawnDistributionList(EncounterName, MissionState, ForceLevel, SpawnList, false, GoodUnits, BadUnits);
}

static function GetSpawnDistributionList(
	name EncounterName,
	XComGameState_MissionSite MissionState,
	int ForceLevel,
	out array<SpawnDistributionListEntry> SpawnList,
	bool IsLeaderList,
	out array<name> GoodUnits,
	out array<name> BadUnits)
{
	local SpawnDistributionList CurrentList;
	local SpawnDistributionListEntry CurrentListEntry;
	local XComTacticalMissionManager MissionManager;
	local name SpawnListID, SitrepName;
	local array<name> SitrepListNames;
	local int idx, index;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2CharacterTemplateManager TemplateManager;
	local X2CharacterTemplate CharacterTemplate;

	
	TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

	MissionManager = `TACTICALMISSIONMGR;

	idx = MissionManager.ConfigurableEncounters.Find('EncounterID', EncounterName);
	if (IsLeaderList)
	{
		if (MissionManager.ConfigurableEncounters[idx].EncounterLeaderSpawnList != '')
		{
			SpawnListID = MissionManager.ConfigurableEncounters[idx].EncounterLeaderSpawnList;
		}
	}
	else
	{
		if (MissionManager.ConfigurableEncounters[idx].EncounterFollowerSpawnList != '')
		{
			SpawnListID = MissionManager.ConfigurableEncounters[idx].EncounterFollowerSpawnList;
		}
	}

	// LWOTC TODO: Support SitRep overrides

	// Fall back to using the schedule's default spawn distribution list
	if (SpawnListID == '')
	{
		idx = MissionManager.MissionSchedules.Find('ScheduleID', MissionState.SelectedMissionData.SelectedMissionScheduleName);
		if (IsLeaderList)
		{
			SpawnListID = MissionManager.default.MissionSchedules[idx].DefaultEncounterLeaderSpawnList;
		}
		else
		{
			SpawnListID = MissionManager.MissionSchedules[idx].DefaultEncounterFollowerSpawnList;
		}
	}

	SitRepListNames = GetSitRepListNames(MissionState);


	`LWDiversityTrace("Using spawn distribution list " $ SpawnListID);

	foreach SitrepListNames (SitrepName)
	{
		`LWDiversityTrace("Adding Sitrep Spawn List" @SitrepName);
	}
	
	// Build a merged list of all spawn distribution list entries that satisfy the selected
	// list ID and force level.
	foreach MissionManager.SpawnDistributionLists(CurrentList)
	{
		if (CurrentList.ListID == SpawnListID || SitrepListNames.Find(CurrentList.ListID) != INDEX_NONE)
		{
			foreach CurrentList.SpawnDistribution(CurrentListEntry)
			{
				if (ForceLevel >= CurrentListEntry.MinForceLevel && ForceLevel <= CurrentListEntry.MaxForceLevel)
				{
					
					if(GoodUnits.Find(CurrentListEntry.Template) == INDEX_NONE)
					{
						if(BadUnits.Find(CurrentListEntry.Template) == INDEX_NONE)
						{
							CharacterTemplate = TemplateManager.FindCharacterTemplate(CurrentListEntry.Template);

							if(CharacterTemplate != none)
							{
									// Add check for tech requirements
								if(XComHQ.MeetsObjectiveRequirements(CharacterTemplate.SpawnRequirements.RequiredObjectives) == true && XCOMHQ.MeetsTechRequirements(CharacterTemplate.SpawnRequirements.RequiredTechs))
								{
									//`LWDiversityTrace("Adding " $ CurrentListEntry.Template $ " to the merged spawn distribution list with spawn weight " $ CurrentListEntry.SpawnWeight);
									SpawnList.AddItem(CurrentListEntry);
									GoodUnits.AddItem(CurrentListEntry.Template);
								}
								else
								{
									BadUnits.AddItem(CurrentListEntry.Template);
								}
							}
							else
							{
								BadUnits.AddItem(CurrentListEntry.Template);
							}
						}
					}
					else
					{
						//`LWDiversityTrace("Adding " $ CurrentListEntry.Template $ " to the merged spawn distribution list with spawn weight " $ CurrentListEntry.SpawnWeight);

						// check if unit already present  - duplicate combination
						index = SpawnList.find('Template', CurrentListEntry.Template);

						while(index != INDEX_NONE)
						{
							CurrentListEntry.SpawnWeight += SpawnList[index].SpawnWeight;
							SpawnList.remove(index, 1);
							index = SpawnList.find('Template', CurrentListEntry.Template);

						}

						SpawnList.AddItem(CurrentListEntry);
					}
				}
			}
		}
	}
}

// Returns true if the pod is undersized
static final function bool CheckPodSize(out name EncounterName, out PodSpawnInfo SpawnInfo, int ForceLevel, int AlertLevel, out int ProperPodLength, optional XComGameState_BaseObject SourceObject)
{
	local XComTacticalMissionManager MissionManager;
	local int idx;

	MissionManager = `TACTICALMISSIONMGR;

	idx = MissionManager.ConfigurableEncounters.Find('EncounterID', EncounterName);

	if(idx != INDEX_NONE)
	{
		// If the encounter defines a MaxSpawnCount AND the current length is not the same as the max spawn count.
		if(MissionManager.ConfigurableEncounters[idx].MaxSpawnCount > 0 && SpawnInfo.SelectedCharacterTemplateNames.length != MissionManager.ConfigurableEncounters[idx].MaxSpawnCount)
		{
			ProperPodLength = MissionManager.ConfigurableEncounters[idx].MaxSpawnCount;
			return true;
		}
	}
	
	return false;
}

// Borrowed from DABFL code thanks to H4ilst0rm

static final function array<name> GetSitRepListNames(XComGameState_MissionSite Mission)
{
	local X2SitRepTemplateManager SitRepMgr;
	local X2SitRepTemplate SitRepTemplate;
	local array<name> PositiveListOverrides, NegativeListOverrides;
	local name entry;

	//PositiveListOverrides.length = 0;
	//NegativeListOverrides.length = 0;

	// no sitreps, return empty array
	if (Mission.GeneratedMission.SitReps.Length == 0)
	{
		return PositiveListOverrides;
	}

	SitRepMgr = class'X2SitRepTemplateManager'.static.GetSitRepTemplateManager();

	// parse sitrep list effects
	foreach Mission.GeneratedMission.SitReps(entry)
	{
		SitRepTemplate = SitRepMgr.FindSitRepTemplate(entry);
		ParseListOverrideEffects(PositiveListOverrides, SitRepTemplate.PositiveEffects);
		ParseListOverrideEffects(NegativeListOverrides, SitRepTemplate.NegativeEffects);
	}

	if(PositiveListOverrides.length > 0)
	{
		`LWDiversityTrace("Positive SitRep list override(s):" @ names_to_str(PositiveListOverrides));
	}

	if(NegativeListOverrides.length > 0)
	{
		`LWDiversityTrace("Negative SitRep list override(s):" @ names_to_str(NegativeListOverrides));
	}

	// append negatives to the end of positives to return all at once
	// we can read the last of array for the final negative override
	foreach NegativeListOverrides(entry)
	{
		PositiveListOverrides.addItem(entry);
	}

	return PositiveListOverrides;
}

static final function ParseListOverrideEffects(out array<name> result,  array<name> EffectNames)
{
	local X2SitRepEffectTemplateManager SitRepEffectMgr;
	local name Effect;
	local X2SitRepEffect_ModifyDefaultEncounterLists EncounterListEffect;
	
	SitRepEffectMgr = class'X2SitRepEffectTemplateManager'.static.GetSitRepEffectTemplateManager();

	foreach EffectNames(Effect)
	{
		EncounterListEffect = X2SitRepEffect_ModifyDefaultEncounterLists(SitRepEffectMgr.FindSitRepEffectTemplate(Effect));
		if(EncounterListEffect != none)
		{
			// separate ifs to avoid accessed none
			if(EncounterListEffect.DefaultFollowerListOverride != '')
			{
				result.additem(EncounterListEffect.DefaultFollowerListOverride);
			}
		}
	}
}

static final function string names_to_str(array<name> arr)
{
	local string result;
	local name entry;

	foreach arr(entry) result @= entry;

	return result == "" ? "None" : result;
}

// End code borrowed from DABFL

static final function int CountMembers(name CountItem, array<name> ArrayToScan)
{
	local int idx, k;

	//`LWDiversityTrace("CountMembers called" @CountItem);
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

static final function name FindMostCommonMember(array<name> ArrayToScan)
{
	local int idx, highest, highestidx;
	local array<int> kount;

	//`LWDiversityTrace("FindMostCommonMember called");

	highestidx = 1; // Start with first follower rather than the leader
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

static function SpawnDistributionListEntry GetCharacterSpawnEntry(out array<SpawnDistributionListEntry> SpawnList, X2CharacterTemplate CharacterTemplate, int ForceLevel)
{
	local SpawnDistributionListEntry SpawnEntry, NullEntry;

	foreach SpawnList(SpawnEntry)
	{
		if (SpawnEntry.Template == CharacterTemplate.DataName && ForceLevel >= SpawnEntry.MinForceLevel && ForceLevel <= SpawnEntry.MaxForceLevel)
		{
			return SpawnEntry;
		}
	}

	return NullEntry;
}

static function float GetCharacterSpawnWeight(out array<SpawnDistributionListEntry> SpawnList, X2CharacterTemplate CharacterTemplate, int ForceLevel)
{
	local SpawnDistributionListEntry SpawnEntry;

	SpawnEntry = GetCharacterSpawnEntry(SpawnList, CharacterTemplate, ForceLevel);
	if (SpawnEntry.Template != '')
	{
		return SpawnEntry.SpawnWeight;
	}
	else
	{
		return 0.0;
	}
}

static function name SelectNewPodLeader(PodSpawnInfo SpawnInfo, int ForceLevel, out array<SpawnDistributionListEntry> SpawnList, optional bool bReinforcement)
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2DataTemplate Template;
	local X2CharacterTemplate CharacterTemplate;
	local array<name> PossibleChars;
	local array<float> PossibleWeights;
	local float TotalWeight, TestWeight, RandomWeight;
	local int k;
	local XComGameState_HeadquartersXCom XCOMHQ;

	`LWTRACE ("Initiating SelectNewPodLeader" @ ForceLevel);

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
		if (CharacterTemplate.DataName == 'Cyberus' && XCOMHQ.GetObjectiveStatus('T1_M2_S3_SKULLJACKCaptain') != eObjectiveState_Completed)
			continue;
		if (CharacterTemplate.DataName == 'AdvPsiWitchM3' && XCOMHQ.GetObjectiveStatus ('T1_M5_SKULLJACKCodex') != eObjectiveState_Completed)
			continue;

		if (bReinforcement && default.NoReinforcementEnemies.Find(CharacterTemplate.DataName) != INDEX_NONE)
			continue;

		if(XCOMHQ.MeetsObjectiveRequirements(CharacterTemplate.SpawnRequirements.RequiredObjectives) == false)
		{
			continue;
		}
		
			// Chose Your Aliens uses required tech, so implement that.
		if(XCOMHQ.MeetsTechRequirements(CharacterTemplate.SpawnRequirements.RequiredTechs) == false)
		{
			continue;
		}

		TestWeight = GetCharacterSpawnWeight(SpawnList, CharacterTemplate, ForceLevel);
		// this is a valid character type, so store off data for later random selection
		if (TestWeight > 0.0)
		{
			PossibleChars.AddItem(CharacterTemplate.DataName);
			PossibleWeights.AddItem(TestWeight);
			TotalWeight += TestWeight;
		}
	}

	`LWDiversityTrace("PossibleChars.Length:" @ PossibleChars.length);

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

static function name SelectRandomPodFollower(PodSpawnInfo SpawnInfo, array<name> SupportedFollowers, int ForceLevel, out array<SpawnDistributionListEntry> SpawnList)
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2DataTemplate Template;
	local X2CharacterTemplate CharacterTemplate;
	local SpawnDistributionListEntry SpawnEntry;
	local array<name> PossibleChars;
	local array<float> PossibleWeights;
	local float TotalWeight, TestWeight, RandomWeight;
	local int k;
	local XComGameState_HeadquartersXCom XCOMHQ;

	PossibleChars.Length = 0;
	//`LWTRACE ("Initiating SelectRandomPodFollower" @ ForceLevel @ AlienAllowed @ AdventAllowed @ TerrorAllowed);
	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	foreach CharacterTemplateMgr.IterateTemplates(Template, None)
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

		SpawnEntry = GetCharacterSpawnEntry(SpawnList, CharacterTemplate, ForceLevel);
		if (SpawnEntry.Template == '')
			continue;

		if (CountMembers(CharacterTemplate.DataName, SpawnInfo.SelectedCharacterTemplateNames) >= SpawnEntry.MaxCharactersPerGroup)
			continue;

		XCOMHQ = XComGameState_HeadquartersXCom(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

		// don't let cyberuses in yet
		if (CharacterTemplate.DataName == 'Cyberus' && XCOMHQ.GetObjectiveStatus('T1_M2_S3_SKULLJACKCaptain') != eObjectiveState_Completed)
			continue;

		// don't let Avatars in yet
		if (CharacterTemplate.DataName == 'AdvPsiWitchM3' && XCOMHQ.GetObjectiveStatus ('T1_M5_SKULLJACKCodex') != eObjectiveState_Completed)
			continue;

		TestWeight = SpawnEntry.SpawnWeight;
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

// improved version that doesn't have nested loops
static final function name SelectRandomPodFollower_Improved(PodSpawnInfo SpawnInfo, array<name> SupportedFollowers, int ForceLevel, out array<SpawnDistributionListEntry> SpawnList, optional bool bReinforcement)
{
//	local X2CharacterTemplateManager CharacterTemplateMgr;
//	local X2CharacterTemplate CharacterTemplate;
	local SpawnDistributionListEntry SpawnEntry;
	local array<name> PossibleChars;
	local array<float> PossibleWeights;
	local float TotalWeight, TestWeight, RandomWeight;
	local int k;
	local XComGameState_HeadquartersXCom XCOMHQ;

	local bool bCodexObjective, bAvatarObjective;

	`LWDiversityTrace("SelectRandomPodFollower_Improved called with the following FL" @Forcelevel);
	`LWDiversityTrace("SpawnList Length:" @SpawnList.Length);
	`LWDiversityTrace("Supported Followers Length:" @SupportedFollowers.Length);
	// setup
	PossibleChars.Length = 0;
//	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	XCOMHQ = XComGameState_HeadquartersXCom(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

	bCodexObjective = (XCOMHQ.GetObjectiveStatus('T1_M2_S3_SKULLJACKCaptain') != eObjectiveState_Completed);
	bAvatarObjective = (XCOMHQ.GetObjectiveStatus ('T1_M5_SKULLJACKCodex') != eObjectiveState_Completed);
	`LWDiversityTrace("Passed Codex/Avatar Objective");

	foreach SpawnList(SpawnEntry)
	{
		// if entry doesn't have a unit
		if(SpawnEntry.Template == '')
		{
			continue;
		}

		/*
		This has been moved to the code that compiles the spawn distribution list instead.
		// short circuit if unit template doesn't exist.
		CharacterTemplate = CharacterTemplateMgr.FindCharacterTemplate(SpawnEntry.Template);
		if(CharacterTemplate == none)
		{
			continue;
		}
		*/
		if (bReinforcement && default.NoReinforcementEnemies.Find(SpawnEntry.Template) != INDEX_NONE)
			continue;

		// if entry out of force level range.
		if (ForceLevel < SpawnEntry.MinForceLevel && ForceLevel > SpawnEntry.MaxForceLevel)
		{
			continue;
		}

		// if entry not in unit's supported follower list
		if (SupportedFollowers.Find(SpawnEntry.Template) == -1)
		{
			continue;
		}

		// don't let cyberuses in yet
		if (SpawnEntry.Template == 'Cyberus' && bCodexObjective)
			continue;

		// don't let Avatars in yet
		if (SpawnEntry.Template == 'AdvPsiWitchM3' && bAvatarObjective)
			continue;

		
		// if too many of the unit already exist
		if (CountMembers(SpawnEntry.Template, SpawnInfo.SelectedCharacterTemplateNames) >= SpawnEntry.MaxCharactersPerGroup)
		{
			continue;
		}
		
		TestWeight = SpawnEntry.SpawnWeight;
		if (TestWeight > 0.0)
		{
			// this is a valid character type, so store off data for later random selection
			PossibleChars.AddItem (SpawnEntry.Template);
			PossibleWeights.AddItem (TestWeight);
			TotalWeight += TestWeight;
			//`LWDiversityTrace("Unit" @SpawnEntry.Template @"Added to follower selection list");
		}
	}

	//failsafe
	if (PossibleChars.length == 0)
	{
		`LWTrace("Select new Follower Failed, returning M1 Trooper");
		return 'AdvTrooperM1';
	}

	// roll a unit
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


static function PostReinforcementCreation(out name EncounterName, out PodSpawnInfo Encounter, int ForceLevel, int AlertLevel, optional XComGameState_BaseObject SourceObject, optional XComGameState_BaseObject ReinforcementState)
{
	 `LWTrace("PostReinforcementCreation called. Current Force Level:" @ ForceLevel);

	// M5 chosen handling:
	if(Encounter.SelectedCharacterTemplateNames[0] == 'ChosenWarlockM4' || Encounter.SelectedCharacterTemplateNames[0] == 'ChosenSniperM4' || Encounter.SelectedCharacterTemplateNames[0] == 'ChosenAssassinM4')
	{
		if (class'X2StrategyElement_DefaultAlienActivities'.default.CHOSEN_LEVEL_FL_THRESHOLDS.length < 4)
			return;

	    if (ForceLevel >= class'X2StrategyElement_DefaultAlienActivities'.default.CHOSEN_LEVEL_FL_THRESHOLDS[3])
	    {
	        `LWTrace("Swapping M4 Chosen" @Encounter.SelectedCharacterTemplateNames[0] @"...");  //PREVIOUS CHOSEN FOR LOGGING

	        switch (Encounter.SelectedCharacterTemplateNames[0])
	        {
	            case 'ChosenWarlockM4'  : Encounter.SelectedCharacterTemplateNames[0] = 'ChosenWarlockM5';    break;
	            case 'ChosenSniperM4'   : Encounter.SelectedCharacterTemplateNames[0] = 'ChosenSniperM5';     break;
	            case 'ChosenAssassinM4' : Encounter.SelectedCharacterTemplateNames[0] = 'ChosenAssassinM5';   break;
	            default:
	                //selected template isn't one we care about
	                break;
	        }

	        `LWTrace("... for M5 Chosen" @Encounter.SelectedCharacterTemplateNames[0]); //POST SWAP FOR LOGGING

		 	return; 
	    }
	}
	// Send into normal PostEncounterCreation otherwise.
	PostEncounterCreation(EncounterName, Encounter, ForceLevel, AlertLevel, ReinforcementState);
}

// Increase the size of Lost Brutes (unless WWL is installed)
static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	if (Left(UnitState.GetMyTemplateName(), Len("TheLostBrute")) != "TheLostBrute")
		return;

	// No need to scale the Brute's pawn size if World War Lost is installed
	// because we'll be using its dedicated Brute model.
	if (class'Helpers_LW'.default.bWorldWarLostActive)
		return;

	Pawn.Mesh.SetScale(default.BRUTE_SIZE_MULTIPLIER);
}

// Use SLG hook to add infiltration modifiers to alien units
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local name AbilityName;
	local AbilitySetupData Data, EmptyData;
	local X2CharacterTemplate CharTemplate;
	local int i;
	local int index;

	if (`XENGINE.IsMultiplayerGame()) { return; }

	`LWTrace("FinalizeUnitAbilitiesForInit:" @UnitState.Name @"-" @ UnitState.GetSoldierClassTemplateName());

	CharTemplate = UnitState.GetMyTemplate();
	if (CharTemplate == none)
		return;

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	if (ShouldApplyInfiltrationModifierToCharacter(CharTemplate))
	{
		AbilityName = 'InfiltrationTacticalModifier_LW';
		if (SetupData.Find('TemplateName', AbilityName) == -1)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);

			if(AbilityTemplate != none)
			{
				Data = EmptyData;
				Data.TemplateName = AbilityName;
				Data.Template = AbilityTemplate;
				SetupData.AddItem(Data);  // return array -- we don't have to worry about additional abilities for this simple ability
			}
		}
	}

	switch(CharTemplate.DataName)
	{
		case 'Engineer':
		case 'Scientist':
		case 'Soldier_VIP':
		case 'Scientist_VIP':
		case 'Engineer_VIP':
		case 'Rebel':
		case 'RebelSoldierProxy':
		case 'RebelSoldierProxyM2':
		case 'RebelSoldierProxyM3':

			if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('PoweredArmor'))
			{
				AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('RebelHPUpgrade_T2');

				Data = EmptyData;
				Data.TemplateName = 'RebelHPUpgrade_T2';
				Data.Template = AbilityTemplate;
				SetupData.AddItem(Data);
			}
			else if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('PlatedArmor'))
			{
				AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('RebelHPUpgrade_T1');
				Data = EmptyData;
				Data.TemplateName = 'RebelHPUpgrade_T1';
				Data.Template = AbilityTemplate;
				SetupData.AddItem(Data);
			}
			
			if (class'UIUtilities_Strategy'.static.GetXComHQ().IsTechResearched('AdvancedGrenades'))
			{
				AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('RebelGrenadeUpgrade');
				Data = EmptyData;
				Data.TemplateName = 'RebelGrenadeUpgrade';
				Data.Template = AbilityTemplate;
				SetupData.AddItem(Data);
				}

		break;
		default:
		break;
	}

	// Fix enemy unit abilities that need to be tied to a weapon, since abilities
	// attached to character templates can't be configured for a particular weapon slot.
	for (i = 0; i < SetupData.Length; i++)
	{
		if (default.PrimaryWeaponAbilities.Find(SetupData[i].TemplateName) != INDEX_NONE && SetupData[i].SourceWeaponRef.ObjectID == 0)
		{
			`LWTrace(" >>> Binding ability '" $ SetupData[i].TemplateName $ "' to primary weapon for unit " $ UnitState.GetMyTemplateName());
			SetupData[i].SourceWeaponRef = UnitState.GetPrimaryWeapon().GetReference();
		}

		if (default.SecondaryWeaponAbilities.Find(SetupData[i].TemplateName) != INDEX_NONE && SetupData[i].SourceWeaponRef.ObjectID == 0)
		{
			`LWTrace(" >>> Binding ability '" $ SetupData[i].TemplateName $ "' to Secondary weapon for unit " $ UnitState.GetMyTemplateName());
			SetupData[i].SourceWeaponRef = UnitState.GetSecondaryWeapon().GetReference();
		}	
	}
	/*
	// Prevent units summoned by the Chosen from dropping loot and corpses
	if (StartState.GetContext().IsA(class'XComGameStateContext_Ability'.Name))
	{
		if (XComGameStateContext_Ability(StartState.GetContext()).InputContext.AbilityTemplateName == 'ChosenSummonFollowers')
		{
			AbilityName = 'FollowerDefeatedEscape';
			if (SetupData.Find('TemplateName', AbilityName) == -1)
			{
				AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);

				if (AbilityTemplate != none)
				{
					Data = EmptyData;
					Data.TemplateName = AbilityName;
					Data.Template = AbilityTemplate;
					SetupData.AddItem(Data);  // return array -- we don't have to worry about additional abilities for this simple ability
				}
			}
				
			AbilityName = 'NoLootAndCorpse';
			if (SetupData.Find('TemplateName', AbilityName) == -1)
			{
				AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);

				if (AbilityTemplate != none)
				{
					Data = EmptyData;
					Data.TemplateName = AbilityName;
					Data.Template = AbilityTemplate;
					SetupData.AddItem(Data);  // return array -- we don't have to worry about additional abilities for this simple ability
				}
			}
		}
	}
	*/

	if(UnitState.HasItemOfTemplateType('EvacFlare') && SetupData.Find('TemplateName', 'GrantEvacFlare') == -1)
	{
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('GrantEvacFlare');
		if (AbilityTemplate != none)
			{
				Data = EmptyData;
				Data.TemplateName = 'GrantEvacFlare';
				Data.Template = AbilityTemplate;
				SetupData.AddItem(Data);  // return array -- we don't have to worry about additional abilities for this simple ability
			}
	}

	// Swap KnifeEncounters for KnifeEncountersExtendedRange if present.

	if(UnitState.HasAbilityFromAnySource('TheBanisher_LW'))
	{
		index = SetupData.Find('TemplateName', 'KnifeEncounters');
		if (index != -1)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('KnifeEncountersExtendedRange');

			if(AbilityTemplate != none)
			{
				Data = EmptyData;
				Data.TemplateName = AbilityName;
				Data.Template = AbilityTemplate;
				Data.SourceWeaponRef = UnitState.GetSecondaryWeapon().GetReference();
				SetupData[index]=(Data);  // swap the ability
			}
		}
	}

	// New Rocket stuff

	if(UnitState.HasItemOfTemplateType('LWGauntlet_BM'))
	{
		// This assumes secondary gauntlet!

		// Concussion Rocket
		index = SetupData.Find('TemplateName', 'ConcussionRocket');
		if (index != -1)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('BlasterConcussionRocket');

			if(AbilityTemplate != none)
			{
				Data = EmptyData;
				Data.TemplateName = AbilityName;
				Data.Template = AbilityTemplate;
				Data.SourceWeaponRef = UnitState.GetSecondaryWeapon().GetReference();
				SetupData[index]=(Data);  // swap the ability
			}
		}

		// Shredder Rocket
		index = SetupData.Find('TemplateName', 'ShredderRocket_LW');
		if (index != -1)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('BlasterShredderRocket_LW');

			if(AbilityTemplate != none)
			{
				Data = EmptyData;
				Data.TemplateName = AbilityName;
				Data.Template = AbilityTemplate;
				Data.SourceWeaponRef = UnitState.GetSecondaryWeapon().GetReference();
				SetupData[index]=(Data);  // swap the ability
			}
		}

		// EMP Rocket
		index = SetupData.Find('TemplateName', 'EMPRocket_LW');
		if (index != -1)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate('BlasterEMPRocket_LW');

			if(AbilityTemplate != none)
			{
				Data = EmptyData;
				Data.TemplateName = AbilityName;
				Data.Template = AbilityTemplate;
				Data.SourceWeaponRef = UnitState.GetSecondaryWeapon().GetReference();
				SetupData[index]=(Data);  // swap the ability
			}
		}

	}

	`LWTrace("FinalizeUnitAbilitiesForInit: complete");
}

static function bool ShouldApplyInfiltrationModifierToCharacter(X2CharacterTemplate CharTemplate)
{
	// Specific character types should never have an infiltration modifier applied.
	if (default.CharacterTypesExceptFromInfiltrationModifiers.Find(CharTemplate.DataName) >= 0)
	{
		return false;
	}

	// Otherwise anything that's alien or advent gets one
	return CharTemplate.bIsAdvent || CharTemplate.bIsAlien;
}

static event OnExitPostMissionSequence()
{
	CleanupObsoleteTacticalGamestate();
	RespecTemplarsIfNeeded();
}

static function CleanupObsoleteTacticalGamestate()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local int idx, idx2;
	local XComGameState ArchiveState;
	local int LastArchiveStateIndex;
	local array<XComGameState_Item> InventoryItems;
	local XComGameState_Item Item;

	History = `XCOMHISTORY;
	//mark all transient tactical gamestates as removed
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Test remove all ability gamestates");
	// grab the archived strategy state from the history and the headquarters object
	LastArchiveStateIndex = History.FindStartStateIndex() - 1;
	ArchiveState = History.GetGameStateFromHistory(LastArchiveStateIndex, eReturnType_Copy, false);
	idx = 0;

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

    if (class'LWDLCHelpers'.static.IsAlienRuler(CharTemplateName, CharTemplate.bDontClearRemovedFromPlay)) 
	{ 
		return false; 
	}

    if(HasSpecialUnitValue(UnitState)) 
	{ 
		return false; 
	}

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

static function bool HasSpecialUnitValue(XComGameState_Unit UnitState)
{
    local UnitValue SpecialUnitValue;

    if(UnitState.GetUnitValue('TacticalCleaner_DoNotDeleteMe', SpecialUnitValue)) // if a unit has this value set on them at all, assume we do not touch it
    {
        if(SpecialUnitValue.fValue > 0.0)
            return true;
    }

    return false;
}


static function AddObjectivesToParcels()
{
	local XComParcelManager ParcelMgr;
	local PlotDefinition PlotDef;
	local WeightedPlotType PlotTypeDef;
	local int i, j, k;

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

			if(default.MapsToDisable.Find(PlotDef.MapName) != INDEX_NONE)
			{
				`LWTrace("Disabling map" @PlotDef.MapName @"from strategy due to config disable list.");
				ParcelMgr.arrPlots[i].ExcludeFromStrategy = true;
				continue;
			}

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

			// Quick hack to enable Rendezvous maps for Ambush mission
			if (ParcelMgr.arrPlots[i].ObjectiveTags.Length > 0 && ParcelMgr.arrPlots[i].ObjectiveTags[0] == "AvengerDefense")
			{
				ParcelMgr.arrPlots[i].ObjectiveTags.AddItem("CovertEscape");
			}

			// Exclude Sewer maps so that Tunnels don't dominate the map pool quite so hard.
			if (PlotDef.strType == "Tunnels_Sewer")
			{
				//Convert them to Subway instead to group them together in one category if the player wants.
				if(default.bSewersToSubway)
				{
					ParcelMgr.arrPlots[i].strType = "Tunnels_Subway";
					`LWTrace("Converting Map" @PlotDef.MapName @"from Sewer to Subway");
				}
				else
				{
					ParcelMgr.arrPlots[i].ExcludeFromStrategy = true;
				}
			}

			if (!default.bEnableCityHQs)
			{
				if (PlotDef.strType == "CityCenter" && PlotDef.ObjectiveTags[0] == "AssaultAlienBase_LW")
				{
					ParcelMgr.arrPlots[i].ExcludeFromStrategy = true;
					`LWTrace("Removing Map" @PlotDef.MapName @"from Mission Generation");
				}
			}
		}

		i = 0;

		if(default.bSewersToSubway)
		{
			PlotTypeDef.strPlotType = "Tunnels_Subway";

			for(i = 0; i < ParcelMgr.arrAllParcelDefinitions.Length; i++)
			{
				if(ParcelMgr.arrAllParcelDefinitions[i].arrPlotTypes.Find('strPlotType', "Tunnels_Sewer") != INDEX_NONE && ParcelMgr.arrAllParcelDefinitions[i].arrPlotTypes.Find('strPlotType', "Tunnels_Subway") == INDEX_NONE)
				{
					ParcelMgr.arrAllParcelDefinitions[i].arrPlotTypes.AddItem(PlotTypeDef);
					`LWTrace("Converting Parcel" @ParcelMgr.arrAllParcelDefinitions[i].MapName @"from Sewer to Subway");
				}
			}

			i = 0;

			for(i = 0; i < class'XComPlotCoverParcelManager'.default.arrAllPCPDefs.Length; i++)
			{
				if(class'XComPlotCoverParcelManager'.default.arrAllPCPDefs[i].arrPlotTypes.Find("Tunnels_Sewer") != INDEX_NONE && class'XComPlotCoverParcelManager'.default.arrAllPCPDefs[i].arrPlotTypes.Find("Tunnels_Subway") == INDEX_NONE)
				{
					class'XComPlotCoverParcelManager'.default.arrAllPCPDefs[i].arrPlotTypes.AddItem("Tunnels_Subway");
					`LWTrace("Converting PCP" @class'XComPlotCoverParcelManager'.default.arrAllPCPDefs[i].MapName @ "from Sewers to Subway");
				}
			}
		}
	}
}

static function InitializePodManager(XComGameState StartGameState)
{
	StartGameState.CreateNewStateObject(class'XComGameState_LWPodManager');
	`LWTrace("Created pod manager");
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

// The base Alien Rulers DLC will do its own thing with regard to spawning
// Rulers on missions, so we potentially need to override the current Ruler
// and mission state to fit with our use of sit reps for the Rulers.
//
// *WARNING* This function should not be called unless the Alien Rulers DLC
// has first been confirmed to be installed.
static function OverrideAlienRulerSpawning(XComGameState StartState, XComGameState_MissionSite MissionState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_AlienRulerManager RulerMgr;
	local XComGameState_Unit RulerState;
	local StateObjectReference EmptyRef;
	local bool RulerOnMission;

	History = `XCOMHISTORY;

	RulerMgr = XComGameState_AlienRulerManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_AlienRulerManager'));
	if (!RulerMgr.bContentActivated) return;

	// Leave the Alien Nest mission alone
	if (MissionState.Source == 'MissionSource_AlienNest')
		return;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(StartState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	RulerMgr = XComGameState_AlienRulerManager(StartState.ModifyStateObject(class'XComGameState_AlienRulerManager', RulerMgr.ObjectID));

	// Check whether the DLC has placed a Ruler on this mission
	RulerOnMission = RulerMgr.RulerOnCurrentMission.ObjectID != 0;
	if (RulerOnMission)
	{
		RulerMgr.ClearActiveRulerTags(XComHQ);
		RulerMgr.RulerOnCurrentMission = EmptyRef;
	}

	if (class'LWDLCHelpers'.static.IsAlienRulerOnMission(MissionState))
	{
		RulerState = class'LWDLCHelpers'.static.GetAlienRulerForMission(MissionState);
		class'LWDLCHelpers'.static.PutRulerOnCurrentMission(StartState, RulerState, XComHQ);
	}
}

// (Based on code from XCGS_HeadquartersAlien.AddChosenTacticalTagsToMission())
//
// Add the Chosen tactical tags to the mission if the LWOTC versions of those
// tags are in the mission's tactical tags. The actual decision about whether
// to add a Chosen to the mission is made by XCGS_LWAlienActivityManager.
// ModifyAlertByMaybeAddingChosenToMission().
//
// The main purpose of this function is to ensure that any attempts by vanilla
// to add Chosen to the mission are blocked and Chosen are added to the HQ
// tactical tags if the alien activity manager has set them up.
static function MaybeAddChosenToMission(XComGameState StartState, XComGameState_MissionSite MissionState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;
	local name ChosenSpawningTag, ChosenSpawningTagLWOTC, ChosenSpawningTagRemove;
	local bool HasRulerOnMission;
	local array <name> SpawningTags;

	// Certain missions should just use vanilla Chosen behaviour, like the Chosen
	// Avenger Defense
	if (default.SKIP_CHOSEN_OVERRIDE_MISSION_TYPES.Find(MissionState.GeneratedMission.Mission.sType) != INDEX_NONE)
	{
		`LWTrace("MaybeAddChosenToMission: Using Vanilla Chosen Behavior");
		return;
	}

	// Don't allow Chosen on the mission if there is already a Ruler
	if (class'XComGameState_AlienRulerManager' != none && class'LWDLCHelpers'.static.IsAlienRulerOnMission(MissionState))
	{
		HasRulerOnMission = true;
	}

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_HeadquartersAlien', AlienHQ)
	{
		break;
	}

	// Move the chosen removal checks outside of the check to see if they're active.
	XComHQ = `XCOMHQ;
	AllChosen = ALienHQ.GetAllChosen();

		//remove all chosen tags regardless of if chosen are defeated.
	forEach AllChosen(ChosenState)
	{
		ChosenSpawningTag = ChosenState.GetMyTemplate().GetSpawningTag(ChosenState.Level);

		// Remove All vanilla chosen tags if they are attached to this mission. This is the only
		// place that should add Chosen tactical mission tags to the XCOM HQ. This
		// basically prevents the base game and other mods from adding Chosen to missions.
		SpawningTags = ChosenState.GetMyTemplate().ChosenProgressionData.SpawningTags;
		foreach SpawningTags(ChosenSpawningTagRemove)
		{
			`LWTrace("removing Chosen Spawning tag"@ChosenSpawningTagRemove);
			XComHQ.TacticalGameplayTags.RemoveItem(ChosenSpawningTagRemove);
		}
	}

	if (AlienHQ.bChosenActive && !`SecondWaveEnabled('DisableChosen'))
	{
		// now grab the undefeated chosen
		AllChosen = AlienHQ.GetAllChosen(, true);

		foreach AllChosen(ChosenState)
		{
			ChosenSpawningTag = ChosenState.GetMyTemplate().GetSpawningTag(ChosenState.Level);
			ChosenSpawningTagLWOTC = class'Helpers_LW'.static.GetChosenActiveMissionTag(ChosenState);


			// Now add the appropriate tactical gameplay tag for this Chosen if the
			// corresponding LWOTC-specific one is in the mission's tactical tags.
			if (!HasRulerOnMission && !ChosenState.bDefeated &&
				MissionState.TacticalGameplayTags.Find(ChosenSpawningTagLWOTC) != INDEX_NONE)
			{
				XComHQ.TacticalGameplayTags.AddItem(ChosenSpawningTag);
				`LWTrace("Adding Chosen Spawning Tag" @ChosenSpawningTag);
			}
		}
	}

	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		if (ChosenState.bDefeated)
		{
			ChosenState.PurgeMissionOfTags(MissionState);
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
	while(FloorPoints.Length < NumSoldiers && Iters++ < 25)
	{
		FloorPoints.Length = 0;
		FloorTiles.Length = 0;
		RootTile.X -= Length/2;
		RootTile.Y -= Width/2;

		World.GetSpawnTilePossibilities(RootTile, Length, Width, Height, FloorTiles);
		`LWTrace("Potential valid # of tiles:" @FloorTiles.Length);
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
	`LWTRACE("Took" @ Iters @ "Iterations.");
	`LWTRACE("Found " $ FloorPoints.Length $ " Valid Tiles to place units around location : " $ string(SpawnPoint.Location));
	for (Iters = 0; Iters < FloorPoints.Length; Iters++)
	{
		`LWTRACE("Point[" $ Iters $ "] = " $ string(FloorPoints[Iters]));
	}

	if(FloorPoints.Length == 0)
	{
		return false;
		// Adjust height and try again.
		//SpawnPoint.GetValidFloorLocations(FloorPoints, max(Width, Length))
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

static function DisableUnwantedObjectives(XComGameState StartState)
{
	local XComGameState_Objective ObjectiveState;

	foreach StartState.IterateByClassType(class'XComGameState_Objective', ObjectiveState)
	{
		switch (ObjectiveState.GetMyTemplateName())
		{
		case 'XP2_M0_FirstCovertActionTutorial':
		case 'XP2_M1_SecondCovertActionTutorial':
			ObjectiveState.CompleteObjective(StartState);
			break;
		default:
			break;
		}
	}
}

// ******** HANDLE CUSTOM WEAPON RESTRICTIONS ******** //

// Disable heavy weapons items based on soldier class and also
// control who can have pistols.
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

	// Handle the pistol slot first
	WeaponTemplate = X2WeaponTemplate(ItemTemplate);
	if (WeaponTemplate == none)
	{
		// We want this hook to be ignored from both the armory
		// screen and the unit's CanAddItemToInventory() method,
		// but they expect different return values to indicate
		// that. CheckGameState is the only way to distinguish
		// between them.
		return CheckGameState == none;
	}

	if (Slot == eInvSlot_Pistol && !class'CHItemSlot_PistolSlot_LW'.default.DISABLE_LW_PISTOL_SLOT &&
			class'CHItemSlot_PistolSlot_LW'.static.IsWeaponAllowedInPistolSlot(WeaponTemplate))
	{
		// Allow the weapon to be equipped.
		DisabledReason = "";

		// added none check based on CHL issue # 1056
		if (CheckGameState != none && UnitState.GetItemInSlot(Slot, CheckGameState) == none)
		{
    		bCanAddItem = 1;
		}
		
		// Override normal behavior.
		return CheckGameState != none;
	}

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
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticB", "", 'AssaultRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_OpticB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SMG
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticB", "", 'SMG_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSMG_OpticB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Shotgun
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BeamShotgun.Meshes.SM_BeamShotgun_OpticB", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_OpticB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticB", "", 'SniperRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_OpticB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilSniperRifle_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Cannon
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "LWCannon_CG.Meshes.LW_CoilCannon_OpticB", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_OpticB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SparkRifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_LaserSight", "", 'SparkRifle_CG', , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_LaserSight", "img:///IRI_Sparkgun_CG_LW.UI.laserLight", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

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
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticC", "", 'AssaultRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_OpticC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SMG
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticC", "", 'SMG_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSMG_OpticC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Shotgun
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BeamShotgun.Meshes.SM_BeamShotgun_OpticC", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_OpticC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticC", "", 'SniperRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_OpticC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilSniperRifle_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Cannon
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "LWCannon_CG.Meshes.LW_CoilCannon_OpticC", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_OpticC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SparkRifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_Scope", "", 'SparkRifle_CG', , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_scope", "img:///IRI_Sparkgun_CG_LW.UI.Scope", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
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
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagB", "", 'AssaultRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_MagB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	//SMG
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagB", "", 'SMG_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSMG_MagB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	// Shotgun
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagB", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_MagB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagB", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_MagB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	// Sniper Rifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagB", "", 'SniperRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_MagB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilSniperRifle_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	// Cannon
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagB", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_MagB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagB", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_MagB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	//SparkRifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_ExtendedMag", "", 'SparkRifle_CG', , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_MagB", "img:///IRI_Sparkgun_CG_LW.UI.magB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

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
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'AssaultRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_ReargripB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	//SMG
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'SMG_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSMG_ReargripB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Shotgun
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_ReargripB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Sniper
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'SniperRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_ReargripB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Cannon
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_ReargripB", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_ReargripB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_ReargripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	//SparkRifle
	Template.AddUpgradeAttachment('Trigger', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_TriggerB", "", 'SparkRifle_CG', , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_TriggerB", "img:///IRI_Sparkgun_CG_LW.UI.Trigger", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

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
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagC", "", 'AssaultRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_MagC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagD", "", 'AssaultRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_MagD", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	//SMG
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagC", "", 'SMG_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSMG_MagC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagD", "", 'SMG_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSMG_MagD", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Shotgun
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagC", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_MagC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagC", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_MagC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagD", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_MagD", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Sniper
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagC", "", 'SniperRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_MagC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilSniperRifle_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagD", "", 'SniperRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_MagD", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilSniperRifle_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Cannon
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagC", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_MagC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagC", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_MagC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagD", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_MagD", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	//SparkRifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_MagA_AL", "", 'SparkRifle_CG', , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_autoloader", "img:///IRI_Sparkgun_CG_LW.UI.autoloaderA", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
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
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'AssaultRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_StockB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	//SMG
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'SMG_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSMG_StockB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Shotgun
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_StockB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockC", "", 'SniperRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_StockC", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilSniperRifle_StockC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Cannon
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "LWCannon_CG.Meshes.LW_CoilCannon_StockB", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_StockB", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('StockSupport', '', "LWCannon_CG.Meshes.LW_CoilCannon_StockSupportB", "", 'Cannon_CG');

	//SparkRifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_StockB", "", 'SparkRifle_CG', , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_StockB", "img:///IRI_Sparkgun_CG_LW.UI.Stock", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

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
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_Silencer", "", 'AssaultRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_Suppressor", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	//SMG
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_Silencer", "", 'SMG_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSMG_Suppressor", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilRifleSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Shotgun
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "LWShotgun_CG.Meshes.LW_CoilShotgun_Suppressor", "", 'Shotgun_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilShotgun_Suppressor", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilShotgun_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "LWSniperRifle_CG.Meshes.LW_CoilSniper_Suppressor", "", 'SniperRifle_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_Suppressor", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilSniperRifle_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Cannon
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Cannon_Suppressor', "LWCannon_CG.Meshes.LW_CoilCannon_Suppressor", "", 'Cannon_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilCannon_Suppressor", "img:///UILibrary_LWOTC.InventoryArt.Inv_CoilCannon_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	//SparkRifle
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Cannon_Suppressor', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_Suppressor", "", 'SparkRifle_CG', , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_suppressor", "img:///IRI_Sparkgun_CG_LW.UI.Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

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

static function UpdateChosenActivities()
{
	UpdateTraining();
	UpdateRetribution();
}

static function UpdateChosenSabotages()
{
	UpdateWeaponLockers();
	UpdateLabStorage();
	UpdateSecureStorage();
	UpdateEncryptionServer();
}


static function UpdateWeaponLockers()
{
	local X2SabotageTemplate Template;

	Template = X2SabotageTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate('Sabotage_WeaponLockers'));
	Template.CanActivateFn = CanActivateWeaponLockers;
}

static function UpdateLabStorage()
{
	local X2SabotageTemplate Template;

	Template = X2SabotageTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate('Sabotage_LabStorage'));
	Template.CanActivateFn = CanActivateLabStorage;
}
static function UpdateSecureStorage()
{
	local X2SabotageTemplate Template;

	Template = X2SabotageTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate('Sabotage_SecureStorage'));
	Template.CanActivateFn = CanActivateSecureStorage;
}

static function UpdateEncryptionServer()
{
	local X2SabotageTemplate Template;

	Template = X2SabotageTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate('Sabotage_EncryptionServer'));
	Template.CanActivateFn = CanActivateEncryptionServer;

}

function bool CanActivateEncryptionServer()
{
	local XComGameStateHistory History;
	local XComGameState_BlackMarket MarketState;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	History = `XCOMHISTORY;
	MarketState = XComGameState_BlackMarket(History.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));

	if (ResistanceHQ.NumMonths <= default.ENCRYPTION_SERVER_MONTH)
		return false;

	if(`SYNC_RAND_STATIC(100) < default.ENCRYPTION_SERVER_CHANCE)
	{
		return (MarketState.bIsOpen && MarketState.ForSaleItems.Length > 0);
	}
	else return false;
}

function bool CanActivateWeaponLockers()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item ItemState;
	local StateObjectReference ItemRef;
	local X2WeaponUpgradeTemplate UpgradeTemplate;
	local int NumUpgrades, MinMods;

	MinMods = `ScaleStrategyArrayInt(class'X2StrategyElement_DefaultSabotages'.default.MinWeaponLockersMods);
	
	NumUpgrades = 0;
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	foreach XComHQ.Inventory(ItemRef)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));

		if(ItemState != none)
		{
			UpgradeTemplate = X2WeaponUpgradeTemplate(ItemState.GetMyTemplate());

			if(UpgradeTemplate != none)
			{
				NumUpgrades++;
				if(NumUpgrades >= MinMods)
				{
					return true;
				}
			}
		}
	}
	return false;
}
function bool CanActivateLabStorage()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item ItemState;
	local StateObjectReference ItemRef;
	local int NumPads, MinPads;
	NumPads = 0;
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	MinPads = `ScaleStrategyArrayInt(class'X2StrategyElement_DefaultSabotages'.default.LabStorageMinDatapads);
	foreach XComHQ.Inventory(ItemRef)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));

		if(ItemState != none && (ItemState.GetMyTemplateName() == 'AdventDatapad' || ItemState.GetMyTemplateName() == 'AlienDatapad'))
		{
			NumPads++;
			if(NumPads >= MinPads)
			{
				return true;
			}
		}
	}

	return false;
}

static function bool CanActivateSecureStorage()
{
	return (class'UIUtilities_Strategy'.static.GetResource('EleriumCore') >= `ScaleStrategyArrayInt(class'X2StrategyElement_DefaultSabotages'.default.MinSecureStorageCores) && class'X2StrategyElement_DefaultSabotages'.static.ExistsValidStaffForWounding());
}
static function UpdateTraining()
{
	local X2ChosenActionTemplate Template;

	Template = X2ChosenActionTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate('ChosenAction_Training'));
	Template.OnActivatedFn = ActivateTraining;
	Template.CanBePlayedFn = TrainingCanBePlayed;
}

static function ActivateTraining(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_ChosenAction ActionState;
	local XComGameState_AdventChosen ChosenState;

	ActionState = class'X2StrategyElement_XpackChosenActions'.static.GetAction(InRef, NewGameState);
	ChosenState = class'X2StrategyElement_XpackChosenActions'.static.GetChosen(ActionState.ChosenRef, NewGameState);

	// Only met, active chosen trigger the just leveled up popup
	if (ChosenState.bMetXCom && !ChosenState.bDefeated)
	{
		ChosenState.bJustLeveledUp = true;
	}

	// Gain New Traits
	GainNewStrengths(NewGameState, class'XComGameState_AdventChosen'.default.NumStrengthsPerLevel, ChosenState);

}

static function	GainNewStrengths(XComGameState NewGameState, int NumStrengthsPerLevel, XComGameState_AdventChosen ChosenState)
{
	local X2CharacterTemplate ChosenTemplate;
	local array<ChosenStrengthWeighted> ChosenStrengths , ValidChosenStrengths;	
	local array<ChosenStrengthWeighted> BackupChosenStrengths, FurtherBackupChosenStrengths;	
	local ChosenStrengthWeighted WStrength;
	local float finder, selection, TotalWeight;
	local int i;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	ChosenTemplate = ChosenState.GetChosenTemplate();
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	if(ChosenTemplate.CharacterGroupName == 'ChosenSniper')
	{

		if(AlienHQ.GetForceLevel() > 14)
		{
			ChosenStrengths = default.HUNTER_STRENGTHS_T3;
			BackupChosenStrengths = default.HUNTER_STRENGTHS_T2;
			FurtherBackupChosenStrengths = default.HUNTER_STRENGTHS_T1;
		}
		else if(AlienHQ.GetForceLevel() > 9)
		{
			ChosenStrengths = default.HUNTER_STRENGTHS_T2;
			BackupChosenStrengths = default.HUNTER_STRENGTHS_T1;
		}
		else 
		{
			ChosenStrengths = default.HUNTER_STRENGTHS_T1;
		}
	}
	if(ChosenTemplate.CharacterGroupName == 'ChosenWarlock')
	{
		if(AlienHQ.GetForceLevel() > 14)
		{
			ChosenStrengths = default.WARLOCK_STRENGTHS_T3;
			BackupChosenStrengths = default.WARLOCK_STRENGTHS_T2;
			FurtherBackupChosenStrengths = default.WARLOCK_STRENGTHS_T1;
		}
		else if(AlienHQ.GetForceLevel() > 9)
		{
			ChosenStrengths = default.WARLOCK_STRENGTHS_T2;
			BackupChosenStrengths = default.WARLOCK_STRENGTHS_T1;
		}
		else 
		{
			ChosenStrengths = default.WARLOCK_STRENGTHS_T1;
		}	
	}
	if(ChosenTemplate.CharacterGroupName == 'ChosenAssassin')
	{
		if(AlienHQ.GetForceLevel() > 14)
		{
			ChosenStrengths = default.ASSASSIN_STRENGTHS_T3;
			BackupChosenStrengths = default.ASSASSIN_STRENGTHS_T2;
			FurtherBackupChosenStrengths = default.ASSASSIN_STRENGTHS_T1;
		}
		else if(AlienHQ.GetForceLevel() > 9)
		{
			ChosenStrengths = default.ASSASSIN_STRENGTHS_T2;
			BackupChosenStrengths = default.ASSASSIN_STRENGTHS_T1;
		}
		else 
		{
			ChosenStrengths = default.ASSASSIN_STRENGTHS_T1;
		}		
	}
	ValidChosenStrengths = ChosenStrengths;

	//Remove Strengths Are already added, and those that are excluded by already added strengths
	ValidateStrengthList(ValidChosenStrengths, ChosenState);
	if(ValidChosenStrengths.Length == 0)
	{
		ValidChosenStrengths = BackupChosenStrengths;
		ValidateStrengthList(ValidChosenStrengths, ChosenState);
		if(ValidChosenStrengths.Length == 0)
		{
			ValidChosenStrengths = FurtherBackupChosenStrengths;
			ValidateStrengthList(ValidChosenStrengths, ChosenState);
		}
	}

		TotalWeight = 0.0f;
		foreach ValidChosenStrengths(WStrength)
		{
			TotalWeight+=WStrength.Weight;
		}
		for(i=0; i<NumStrengthsPerLevel; i++)
		{
			finder = 0.0f;
			selection = `SYNC_FRAND_STATIC() * TotalWeight;
			foreach ValidChosenStrengths(WStrength)
			{
				finder += WStrength.Weight;
				if(finder > selection)
				{
					break;
				}
			}
			ChosenState.Strengths.AddItem(WStrength.Strength);
		}
}

static function ValidateStrengthList(out array<ChosenStrengthWeighted> ValidChosenStrengths, XComGameState_AdventChosen ChosenState)
{
	local name Traitname, ExcludeTraitName;
	local X2AbilityTemplate TraitTemplate;
	local X2AbilityTemplateManager AbilityMgr;
	local int i;
	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach ChosenState.Strengths(Traitname)
	{
		TraitTemplate = AbilityMgr.FindAbilityTemplate(Traitname);

		for(i = ValidChosenStrengths.length -1; i>= 0; i--)
		{
			if(ValidChosenStrengths[i].Strength == Traitname)
			{
				ValidChosenStrengths.Remove(i, 1);
			}
		}
		
		foreach TraitTemplate.ChosenExcludeTraits(ExcludeTraitName)
		{
			for(i = ValidChosenStrengths.length -1; i>= 0; i--)
			{
				if(ValidChosenStrengths[i].Strength == ExcludeTraitName)
				{
					ValidChosenStrengths.Remove(i, 1);
				}
			}
		}
	}
	//Remove Strengths That are excluded by weaknesses
	foreach ChosenState.Weaknesses(Traitname)
	{
		TraitTemplate = AbilityMgr.FindAbilityTemplate(Traitname);

		foreach TraitTemplate.ChosenExcludeTraits(ExcludeTraitName)
		{
			for(i = ValidChosenStrengths.length -1; i>= 0; i--)
			{
				if(ValidChosenStrengths[i].Strength == ExcludeTraitName)
				{
					ValidChosenStrengths.Remove(i, 1);
				}

			}
		}
	}
}

static function UpdateRetribution()
{
	local X2ChosenActionTemplate Template;

	Template = X2ChosenActionTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate('ChosenAction_Retribution'));
	Template.OnActivatedFn = ActivateRetribution;
	Template.OnChooseActionFn = OnChooseRetribution;
}

static function ActivateRetribution(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_ChosenAction ActionState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_LWOutpost Outpost;

	ActionState = class'X2StrategyElement_XpackChosenActions'.static.GetAction(InRef, NewGameState);
	RegionState = XComGameState_WorldRegion(NewGameState.ModifyStateObject(class'XComGameState_WorldRegion', ActionState.StoredReference.ObjectID));
	
	Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(RegionState);
	Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutPost.ObjectID));
	NewGameState.AddStateObject(Outpost);
	OutPost.AddChosenRetribution(default.CHOSEN_RETRIBUTION_DURATION);
}

//---------------------------------------------------------------------------------------
static function bool TrainingCanBePlayed(StateObjectReference InRef, optional XComGameState NewGameState = none)
{
	return true;
}

static function OnChooseRetribution(XComGameState NewGameState, XComGameState_ChosenAction ActionState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_HeadquartersXCom XComHQ;

	ChosenState = class'X2StrategyElement_XpackChosenActions'.static.GetChosen(ActionState.ChosenRef, NewGameState);
	RegionState = ChooseRetributionRegion(ChosenState);
	ActionState.StoredReference = RegionState.GetReference();
	
	XComHQ = `XCOMHQ;
	XComHQ.NumChosenRetributions++;
}

static function XComGameState_WorldRegion ChooseRetributionRegion(XComGameState_AdventChosen ChosenState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local StateObjectReference RegionRef;
	local int i;

	History = `XCOMHISTORY;

	// For target deck, get Chosen territories and then remove the uncontacted ones.
	// That way it will select a region that's both this Chosen's region AND contacted.
	// There will always be at least one because you need to have at least one
	// territory contacted to meet the chosen, and you can't lose contact to regions in
	// LWOTC.
	ChosenState.RegionAttackDeck = ChosenState.TerritoryRegions;
	for (i = ChosenState.RegionAttackDeck.length - 1; i >= 0 ; i--)
	{
		if (XComGameState_WorldRegion(History.GetGameStateForObjectID(ChosenState.RegionAttackDeck[i].ObjectID)).ResistanceLevel < eResLevel_Contact)
		ChosenState.RegionAttackDeck.Remove(i, 1);
	}
	RegionRef = ChosenState.RegionAttackDeck[`SYNC_RAND_STATIC(ChosenState.RegionAttackDeck.Length)];
	RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));

	return RegionState;
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
	local XComGameState_HeadquartersXCom XComHQ;

	Type = name(InString);
	switch(Type)
	{
		case 'EVACDELAY_LW':
			OutString = string(class'X2Ability_PlaceDelayedEvacZone'.static.GetEvacDelay());
			return true;
		case 'SHREDDER_ROUNDS_SHRED':
			OutString = string(class'X2Item_LWUtilityItems'.default.SHREDDER_ROUNDS_SHRED);
			return true;
		case 'STILETTO_DMGMOD': // Stiletto Rounds
			OutString = string(class'X2Item_LWUtilityItems'.default.STILETTO_DMGMOD);
			return true;
		case 'STILETTO_ALIEN_DMG': // Stiletto Rounds
			OutString = string(class'X2Item_LWUtilityItems'.default.STILETTO_ALIEN_DMG);
			return true;
		case 'NEEDLE_DMGMOD': // Needle Rounds
			OutString = string(class'X2Item_LWUtilityItems'.default.NEEDLE_DMGMOD);
			return true;
		case 'NEEDLE_ADVENT_DMG': // Needle Rounds
			OutString = string(class'X2Item_LWUtilityItems'.default.NEEDLE_ADVENT_DMG);
			return true;
		case 'FLECHETTE_DMGMOD':
			OutString = string(class'X2Item_LWUtilityItems'.default.FLECHETTE_DMGMOD);
			return true;
		case 'FLECHETTE_BONUS_DMG':
			OutString = string(class'X2Item_LWUtilityItems'.default.FLECHETTE_BONUS_DMG);
			return true;
		case 'NEUROWHIP_PSI_BONUS':
			OutString = string(class'X2Item_LWUtilityItems'.default.NEUROWHIP_PSI_BONUS);
			return true;
		case 'NEUROWHIP_WILL_MALUS':
			OutString = string(class'X2Item_LWUtilityItems'.default.NEUROWHIP_WILL_MALUS);
			return true;
		case 'DRAGON_ROUNDS_APPLY_CHANCE':
			OutString = string(class'LWTemplateMods'.default.DRAGON_ROUNDS_APPLY_CHANCE);
			return true;
		case 'VENOM_ROUNDS_APPLY_CHANCE':
			OutString = string(class'LWTemplateMods'.default.VENOM_ROUNDS_APPLY_CHANCE);
			return true;
		case 'BLUESCREEN_DMGMOD':
			OutString = string(class'X2Item_DefaultAmmo'.default.BLUESCREEN_DMGMOD);
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
		case 'CONCUSSION_ROCKET_STUN_CHANCE':
			OutString = string(class'X2Ability_LW_TechnicalAbilitySet'.default.CONCUSSION_ROCKET_STUN_CHANCE);
			return true;
		case 'BURNOUT_RADIUS_LW':
			OutString = Repl(string(class'X2Ability_LW_TechnicalAbilitySet'.default.BURNOUT_RADIUS), "0", "");
			return true;
		case 'HIGH_PRESSURE_CHARGES_LW':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.FLAMETHROWER_HIGH_PRESSURE_CHARGES);
			return true;
		case 'FLAMETHROWER_CHARGES_LW':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.FLAMETHROWER_CHARGES);
			return true;
		case 'FIRESTORM_DAMAGE_BONUS_LW':
			Outstring = string(int(class'X2Ability_LW_TechnicalAbilitySet'.default.FIRESTORM_DAMAGE_BONUS));
			return true;
		case 'CERAMIC_PLATING_HP':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.CERAMIC_PLATING_HP);
			return true;
		case 'ALLOY_PLATING_HP':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.ALLOY_PLATING_HP);
			return true;
		case 'CHITIN_PLATING_HP':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.CHITIN_PLATING_HP);
			return true;
		case 'CARAPACE_PLATING_HP':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.CARAPACE_PLATING_HP);
			return true;
		case 'NANOFIBER_HEALTH_BONUS_LW':
			Outstring = string(class'X2Ability_ItemGrantedAbilitySet'.default.NANOFIBER_VEST_HP_BONUS);
			return true;
		case 'NANOFIBER_CRITDEF_BONUS_LW':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.NANOFIBER_CRITDEF_BONUS);
			return true;
		case 'PLATED_CRITDEF_BONUS':
			Outstring = string(class'X2LWAbilitiesModTemplate'.default.PLATED_CRITDEF_BONUS);
			return true;
		case 'HAZMAT_VEST_HP_BONUS':
			Outstring = string(class'X2Ability_ItemGrantedAbilitySet'.default.HAZMAT_VEST_HP_BONUS);
			return true;
		case 'RESILIENCE_BONUS_LW':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.RESILIENCE_CRITDEF_BONUS);
			return true;
		case 'ALPHA_MIKE_FOXTROT_DAMAGE_LW':
			Outstring = string(class'X2Ability_LW_SharpshooterAbilitySet'.default.ALPHAMIKEFOXTROT_DAMAGE);
			return true;
		case 'ALPHA_MIKE_FOXTROT_CRIT_DAMAGE_LW':
			Outstring = string(class'X2Ability_LW_SharpshooterAbilitySet'.default.ALPHAMIKEFOXTROT_DAMAGE / 2);
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
		case 'RUPTURE_CRIT_BONUS_LW':
			Outstring = string(class'LWTemplateMods'.default.RUPTURE_CRIT_BONUS);
			return true;
		case 'SCANNING_PROTOCOL_INITIAL_CHARGES_LW':
			Outstring = string(class'X2LWAbilitiesModTemplate'.default.SCANNING_PROTOCOL_INITIAL_CHARGES);
			return true;
		case 'COMBATIVES_DODGE_LW':
			Outstring = string(class'X2Ability_LW_GunnerAbilitySet'.default.COMBATIVES_DODGE);
			return true;
		case 'COUNTERATTACK_DODGE_AMOUNT_LW':
			Outstring = string(class'X2Ability_LW_GunnerAbilitySet'.default.COUNTERATTACK_DODGE_AMOUNT);
			return true;
		case 'SPRINTER_MOBILITY_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.SPRINTER_MOBILITY);
			return true;
		case 'HEAT_WARHEADS_PIERCE_LW':
			Outstring = string(class'X2Ability_LW_GrenadierAbilitySet'.default.HEAT_WARHEADS_PIERCE);
			return true;
		case 'HEAT_WARHEADS_SHRED_LW':
			Outstring = string(class'X2Ability_LW_GrenadierAbilitySet'.default.HEAT_WARHEADS_SHRED);
			return true;
		case 'TANDEMHEAT_WARHEADS_PIERCE_LW':
			Outstring = string(class'X2Ability_LW_GrenadierAbilitySet'.default.TANDEMHEAT_WARHEADS_PIERCE);
			return true;
		case 'TANDEMHEAT_WARHEADS_SHRED_LW':
			Outstring = string(class'X2Ability_LW_GrenadierAbilitySet'.default.TANDEMHEAT_WARHEADS_SHRED);
			return true;
		case 'NEEDLE_BONUS_UNARMORED_DMG_LW': // Needle Grenades
			Outstring = string(class'X2Ability_LW_GrenadierAbilitySet'.default.NEEDLE_BONUS_UNARMORED_DMG);
			return true;
		case 'BOMBARD_BONUS_RANGE_TILES': // Needle Grenades
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.BOMBARD_BONUS_RANGE_TILES);
			return true;
		case 'BLUESCREENBOMB_HACK_DEFENSE_CHANGE_LW':
			Outstring = string(-class'X2Ability_LW_GrenadierAbilitySet'.default.BLUESCREENBOMB_HACK_DEFENSE_CHANGE);
			return true;
		case 'REDSCREEN_EFFECT_LW':
			Outstring = string(-class'X2Item_LWUtilityItems'.default.REDSCREEN_HACK_DEFENSE_CHANGE);
			return true;
		case 'SCOPE_BSC_AIM_BONUS':
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
			if (XComHQ != none) {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.SCOPE_BSC_AIM_BONUS + (XComHQ.bEmpoweredUpgrades ? class'X2Ability_LW_GearAbilities'.default.SCOPE_EMPOWER_BONUS : 0));
			} else {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.SCOPE_BSC_AIM_BONUS);
			}
			return true;
		case 'SCOPE_ADV_AIM_BONUS':
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
			if (XComHQ != none) {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.SCOPE_ADV_AIM_BONUS + (XComHQ.bEmpoweredUpgrades ? class'X2Ability_LW_GearAbilities'.default.SCOPE_EMPOWER_BONUS : 0));
			} else {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.SCOPE_ADV_AIM_BONUS);
			}
			return true;
		case 'SCOPE_SUP_AIM_BONUS':
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
			if (XComHQ != none) {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.SCOPE_SUP_AIM_BONUS + (XComHQ.bEmpoweredUpgrades ? class'X2Ability_LW_GearAbilities'.default.SCOPE_EMPOWER_BONUS : 0));
			} else {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.SCOPE_SUP_AIM_BONUS);
			}
			return true;
		case 'TRIGGER_BSC_AIM_BONUS':
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
			if (XComHQ != none) {
				Outstring = string(round((class'X2Ability_LW_GearAbilities'.default.TRIGGER_BSC_AIM_BONUS + (XComHQ.bEmpoweredUpgrades ? class'X2Ability_LW_GearAbilities'.default.TRIGGER_EMPOWER_BONUS : 0)) 
				* (1.0f - class'X2AbilityToHitCalc_StandardAim'.default.REACTION_FINALMOD)));
			} else {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.TRIGGER_BSC_AIM_BONUS);
			}
			return true;
		case 'TRIGGER_ADV_AIM_BONUS':
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
			if (XComHQ != none) {
				Outstring = string(round((class'X2Ability_LW_GearAbilities'.default.TRIGGER_ADV_AIM_BONUS + (XComHQ.bEmpoweredUpgrades ? class'X2Ability_LW_GearAbilities'.default.TRIGGER_EMPOWER_BONUS : 0)) 
				* (1.0f - class'X2AbilityToHitCalc_StandardAim'.default.REACTION_FINALMOD)));
			} else {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.TRIGGER_ADV_AIM_BONUS);
			}
			return true;
		case 'TRIGGER_SUP_AIM_BONUS':
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
			if (XComHQ != none) {
				Outstring = string(round((class'X2Ability_LW_GearAbilities'.default.TRIGGER_SUP_AIM_BONUS + (XComHQ.bEmpoweredUpgrades ? class'X2Ability_LW_GearAbilities'.default.TRIGGER_EMPOWER_BONUS : 0)) 
				* (1.0f - class'X2AbilityToHitCalc_StandardAim'.default.REACTION_FINALMOD)));
			} else {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.TRIGGER_SUP_AIM_BONUS);
			}
			return true;
		case 'STOCK_BSC_SW_AIM_BONUS':
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
			if (XComHQ != none) {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.STOCK_BSC_SW_AIM_BONUS + (XComHQ.bEmpoweredUpgrades ? class'X2Ability_LW_GearAbilities'.default.STOCK_EMPOWER_BONUS : 0));
			} else {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.STOCK_BSC_SW_AIM_BONUS);
			}
			return true;
		case 'STOCK_ADV_SW_AIM_BONUS':
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
			if (XComHQ != none) {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.STOCK_ADV_SW_AIM_BONUS + (XComHQ.bEmpoweredUpgrades ? class'X2Ability_LW_GearAbilities'.default.STOCK_EMPOWER_BONUS : 0));
			} else {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.STOCK_ADV_SW_AIM_BONUS);
			}
			return true;
		case 'STOCK_SUP_SW_AIM_BONUS':
			XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));
			if (XComHQ != none) {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.STOCK_SUP_SW_AIM_BONUS + (XComHQ.bEmpoweredUpgrades ? class'X2Ability_LW_GearAbilities'.default.STOCK_EMPOWER_BONUS : 0));
			} else {
				Outstring = string(class'X2Ability_LW_GearAbilities'.default.STOCK_SUP_SW_AIM_BONUS);
			}
			return true;
		case 'STOCK_BSC_GF_CHANCE':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.STOCK_BSC_SUCCESS_CHANCE);
			return true;
		case 'STOCK_ADV_GF_CHANCE':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.STOCK_ADV_SUCCESS_CHANCE);
			return true;
		case 'STOCK_SUP_GF_CHANCE':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.STOCK_SUP_SUCCESS_CHANCE);
			return true;
		case 'FLUSH_DEFENSE_REDUCTION':
			Outstring = string(class'X2Ability_LW_GunnerAbilitySet'.default.FLUSH_DEFENSE_REDUCTION);
			return true;
		case 'FLUSH_DODGE_REDUCTION':
			Outstring = string(class'X2Ability_LW_GunnerAbilitySet'.default.FLUSH_DODGE_REDUCTION);
			return true;
		case 'FLUSH_STATEFFECT_DURATION':
			Outstring = string(class'X2Ability_LW_GunnerAbilitySet'.default.FLUSH_STATEFFECT_DURATION);
			return true;
		case 'FLUSH_AIM_BONUS':
			Outstring = string(class'X2Ability_LW_GunnerAbilitySet'.default.FLUSH_AIM_BONUS);
			return true;
		case 'FLUSH_DAMAGE_PENALTY':
			Outstring = string(int(class'X2Ability_LW_GunnerAbilitySet'.default.FLUSH_DAMAGE_PENALTY * 100));
			return true;
		case 'MIND_SCORCH_BURN_CHANCE':
			Outstring = string(class'X2LWAbilitiesModTemplate'.default.MIND_SCORCH_BURN_CHANCE);
			return true;
		case 'SUSTAIN_WOUND_HP_REDUCTTION':
			Outstring = string(class'X2LWAbilitiesModTemplate'.default.SUSTAIN_WOUND_HP_REDUCTTION);
			return true;
		case 'NULL_WARD_BASE_SHIELD':
			Outstring = string(class'X2Ability_LW_PsiOperativeAbilitySet'.default.NULL_WARD_BASE_SHIELD);
			return true;
		case 'NULL_WARD_RADIUS_TILES':
			Outstring = string(int(`METERSTOTILES(class'X2Ability_LW_PsiOperativeAbilitySet'.default.NULLWARD_CAST_RADIUS_METERS)));
			return true;
		case 'SOULSTORM_CAST_RADIUS_TILES':
			Outstring = string(int(`METERSTOTILES(class'X2Ability_LW_PsiOperativeAbilitySet'.default.SOULSTORM_CAST_RADIUS_METERS)));
			return true;
		case 'PHASEWALK_CAST_RANGE_TILES':
			Outstring = string(class'X2Ability_LW_PsiOperativeAbilitySet'.default.PHASEWALK_CAST_RANGE_TILES);
			return true;
		case 'SMOKEGRENADE_HITMOD_LW':
			Outstring = string(-class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_HITMOD);
			return true;
		case 'STREET_SWEEPER2_UNARMORED_DAMAGE_BONUS_LW':
			Outstring = string(class'X2Ability_LW_AssaultAbilitySet'.default.STREET_SWEEPER2_UNARMORED_DAMAGE_BONUS);
			return true;
		case 'CHAIN_LIGHTNING_AIM_MOD_LW':
			Outstring = string(class'X2Ability_LW_AssaultAbilitySet'.default.CHAIN_LIGHTNING_AIM_MOD);
			return true;
		case 'CHAIN_LIGHTNING_TARGETS':
			Outstring = string(class'X2Ability_LW_AssaultAbilitySet'.default.CHAIN_LIGHTNING_TARGETS);
			return true;
		case 'CHAIN_LIGHTNING_CHAIN_RANGE_TILES':
			Outstring = string(int(`UNITSTOTILES(sqrt(class'X2AbilityMultiTarget_Volt'.default.DistanceBetweenTargets))));
			return true;
		case 'STUNGUNNER_BONUS_CV_LW':
			Outstring = string(class'X2Effect_StunGunner'.default.STUNGUNNER_BONUS_CV);
			return true;
		case 'STUNGUNNER_BONUS_BM_LW':
			Outstring = string(class'X2Effect_StunGunner'.default.STUNGUNNER_BONUS_BM);
			return true;
		case 'EMPULSER_HACK_DEFENSE_CHANGE_LW':
			Outstring = string(-class'X2Ability_LW_AssaultAbilitySet'.default.EMPULSER_HACK_DEFENSE_CHANGE);
			return true;
		case 'RESCUE_BONUS_DODGE':
			Outstring = string(class'X2Ability_LW_SpecialistAbilitySet'.default.RESCUE_BONUS_DODGE);
			return true;
		case 'RESCUE_BONUS_MOBILITY':
			Outstring = string(class'X2Ability_LW_SpecialistAbilitySet'.default.RESCUE_BONUS_MOBILITY);
			return true;
		case 'RESCUE_CV_CHARGES':
			Outstring = string(class'X2Ability_LW_SpecialistAbilitySet'.default.RESCUE_CV_CHARGES);
			return true;
		case 'IMPACT_COMPENSATION_PCT_DR':
			Outstring = string(int(class'X2Ability_LW_ChosenAbilities'.default.IMPACT_COMPENSATION_PCT_DR * 100));
			return true;
		case 'IMPACT_COMPENSATION_MAX_STACKS':
			Outstring = string(class'X2Ability_LW_ChosenAbilities'.default.IMPACT_COMPENSATION_MAX_STACKS);
			return true;
		case 'IMPACT_V2_DAMAGE_CAP':
			Outstring = string(int(class'X2Ability_LW_ChosenAbilities'.default.IMPACT_V2_DAMAGE_CAP[`TACTICALDIFFICULTYSETTING] * 100));
			return true;
		case 'IMPACT_V2_PCT_DR':
			Outstring = string(int(class'X2Ability_LW_ChosenAbilities'.default.IMPACT_V2_PCT_DR[`TACTICALDIFFICULTYSETTING] * 100));
			return true;
		case 'IMPACT_V2XCOM_DAMAGE_CAP':
			Outstring = string(int(class'X2Ability_LW_ChosenAbilities'.default.IMPACT_V2XCOM_DAMAGE_CAP[`TACTICALDIFFICULTYSETTING] * 100));
			return true;
		case 'IMPACT_V2XCOM_PCT_DR':
			Outstring = string(int(class'X2Ability_LW_ChosenAbilities'.default.IMPACT_V2XCOM_PCT_DR[`TACTICALDIFFICULTYSETTING] * 100));
			return true;
		case 'SHIELD_ALLY_PCT_DR':
			Outstring = string(int(class'X2Ability_LW_ChosenAbilities'.default.SHIELD_ALLY_PCT_DR * 100));
			return true;
		case 'CHOSEN_RETRIBUTION_DURATION':
			OutString = string(default.CHOSEN_RETRIBUTION_DURATION);
			return true;
		case 'UNSTOPPABLE_MIN_MOB':
			Outstring = string(class'X2Ability_LW_ChosenAbilities'.default.UNSTOPPABLE_MIN_MOB);
			return true;
		case 'ROUST_DIRECT_APPLY_CHANCE':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.ROUST_DIRECT_APPLY_CHANCE);
			return true;
		case 'ROUST_DAMAGE_PENALTY':
			Outstring = string(int(class'X2Ability_LW_TechnicalAbilitySet'.default.ROUST_DAMAGE_PENALTY * 100));
			return true;
		case 'ROUST_MOB_REDUCTION':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.ROUST_MOB_REDUCTION);
			return true;
		case 'ROUST_DEF_REDUCTION':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.ROUST_DEF_REDUCTION);
			return true;
		case 'ROUST_STATEFFECT_DURATION':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.ROUST_STATEFFECT_DURATION);
			return true;
		case 'NAPALM_X_BASEVALUE':
			Outstring = string(class'X2AbilityToHitCalc_StatCheck_LWFlamethrower'.default.BaseValue);
			return true;
		case 'GAUNTLET_CONVENTIONAL_OPPOSED_STAT_STRENTH':
			Outstring = string(class'X2Item_LWGauntlet'.default.Gauntlet_Secondary_CONVENTIONAL_OPPOSED_STAT_STRENTH);
			return true;
		case 'GAUNTLET_MAG_OPPOSED_STAT_STRENTH':
			Outstring = string(class'X2Item_LWGauntlet'.default.Gauntlet_Secondary_MAG_OPPOSED_STAT_STRENTH);
			return true;
		case 'GAUNTLET_BEAM_OPPOSED_STAT_STRENTH':
			Outstring = string(class'X2Item_LWGauntlet'.default.Gauntlet_Secondary_BEAM_OPPOSED_STAT_STRENTH);
			return true;
		case 'COMBATREADINESS_DEF':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.COMBATREADINESS_DEF);
			return true;
		case 'COMBATREADINESS_AIM':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.COMBATREADINESS_AIM);
			return true;
		case 'COMBAT_READINESS_EXPLOSIVE_DR':
			Outstring = string(int(class'X2Ability_XMBPerkAbilitySet'.default.COMBAT_READINESS_EXPLOSIVE_DR * 100));
			return true;
		case 'BLOODTHIRST_T1_DMG':
			Outstring = string(class'X2Effect_BloodThirst'.default.BLOODTHIRST_T1_DMG);
			return true;
		case 'BLOODTHIRST_T2_DMG':
			Outstring = string(class'X2Effect_BloodThirst'.default.BLOODTHIRST_T2_DMG);
			return true;
		case 'BLOODTHIRST_T3_DMG':
			Outstring = string(class'X2Effect_BloodThirst'.default.BLOODTHIRST_T3_DMG);
			return true;
		case 'BLOODTHIRST_T4_DMG':
			Outstring = string(class'X2Effect_BloodThirst'.default.BLOODTHIRST_T4_DMG);
			return true;
		case 'BLOODTHIRST_T5_DMG':
			Outstring = string(class'X2Effect_BloodThirst'.default.BLOODTHIRST_T5_DMG);
			return true;
		case 'DISRUPTOR_RIFLE_PSI_CRIT':
			Outstring = string(class'X2Ability_XPackAbilitySet'.default.DISRUPTOR_RIFLE_PSI_CRIT);
			return true;
		case 'FATALITY_THRESHOLD':
			Outstring = string(int(class'X2Ability_XMBPerkAbilitySet'.default.FATALITY_THRESHOLD * 100));
			return true;
		case 'TEMPLAR_SHIELD_CRIT_RESIST':
			Outstring = string(class'X2Effect_TemplarShieldCritDefense'.default.CritReduction);
			return true;
		case 'CRUSADER_RAGE_HEAL':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.CRUSADER_WOUND_HP_REDUCTTION);
			return true;
		default:
			return false;
	}
}

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
	local name Type;
	local XComGameState_Ability AbilityState;
	local XComGameState_Effect EffectState;
	local XComGameState_Unit UnitState;
	local X2AbilityTemplate AbilityTemplate;
	local int ImpactCompensationStacks;
	local int k;

	Type = name(InString);
	switch(Type)
	{
	case 'SELFCOOLDOWN_LW':
		OutString = "0";
		AbilityTemplate = X2AbilityTemplate(ParseObj);
		if (AbilityTemplate == none)
		{
			AbilityState = XComGameState_Ability(ParseObj);
			if (AbilityState != none)
				AbilityTemplate = AbilityState.GetMyTemplate();
		}
		if (AbilityTemplate != none)
		{
			if (AbilityTemplate.AbilityCooldown != none)
			{
				// LW2 doesn't subtract 1 from cooldowns as a general rule, so to keep it consistent
				// there is substitute tag
				OutString = string(AbilityTemplate.AbilityCooldown.iNumTurns);
			}
		}
		return true;
	case 'IMPACT_COMPENSATION_CURRENT_DR':
		OutString = "0";
		AbilityState = XComGameState_Ability(ParseObj);
		if (AbilityState != none)
		{
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
		}
		else
		{
			EffectState = XComGameState_Effect(ParseObj);
			if (EffectState != none)
			{
				UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			}
		}

		if (UnitState != none)
		{
			ImpactCompensationStacks = int(class'Utilities_LW'.static.GetUnitValue(UnitState, class'X2Ability_PerkPackAbilitySet2'.const.DAMAGED_COUNT_NAME));
			if (ImpactCompensationStacks > 0)
			{
				OutString = string(int((1 - (1 - class'X2Ability_LW_ChosenAbilities'.default.IMPACT_COMPENSATION_PCT_DR) **
						Min(ImpactCompensationStacks, class'X2Ability_LW_ChosenAbilities'.default.IMPACT_COMPENSATION_MAX_STACKS)) * 100));
			}
		}
		return true;
	case 'FLASHBANG_RESIST_VALUE':
		OutString = "0";
		AbilityState = XComGameState_Ability(ParseObj);
		if (AbilityState != none)
		{
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
		}
		else
		{
			EffectState = XComGameState_Effect(ParseObj);
			if (EffectState != none)
			{
				UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			}
		}

		if (UnitState != none)
		{
			for (k = 0; k < class'LWTemplateMods'.default.ENEMY_FLASHBANG_RESIST.length; k++)
			{
				if (class'LWTemplateMods'.default.ENEMY_FLASHBANG_RESIST[k].UnitName == UnitState.GetMyTemplateName())
				{
					OutString = string(class'LWTemplateMods'.default.ENEMY_FLASHBANG_RESIST[k].Chance);
					break;
				}
			}
		}
		return true;
	default:
		return false;
	}
}

// Stuff for updating the 
static function bool ShouldUpdateMissionSpawningInfo(StateObjectReference MissionRef)
{
	local XComGameState_MissionSite MissionState;

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));

	// Waterworld hardcode here
	if(MissionState.GetMissionSource().DataName == 'MissionSource_Final' || MissionState.GetMissionSource().DataName == 'MissionSource_PsiGate')
	{
		if(instr(MissionState.GeneratedMission.Mission.MapNames[0], "_LW") != -1)
		{
			return false;
		}
		`Log("Updating waterworld / psi gate caching.",,'TedLog');
		
		return true;
	}

	return false;
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
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: Set ForceLevel");

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionName == '' || RegionState.GetMyTemplateName() == RegionName)
		{
			RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
			UpdatedRegionalAI = XComGameState_WorldRegion_LWStrategyAI(NewGameState.ModifyStateObject(class'XComGameState_WorldRegion_LWStrategyAI', RegionalAIState.ObjectID));
			NewGameState.AddStateObject(UpdatedRegionalAI);

			UpdatedRegionalAI.LocalForceLevel = NewLevel;
		}
	}

	//patch the chosen level if needed
	
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	//AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	AllChosen = AlienHQ.GetAllChosen(, true);

	foreach AllChosen(ChosenState)
	{
		class'X2StrategyElement_DefaultAlienActivities'.static.TryIncreasingChosenLevelWithGameState(NewLevel, NewGameState, ChosenState);
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
	`Log("Long War of the Chosen Version: " $ class'LWVersion'.static.GetVersionString());
	class'Helpers'.static.OutputMsg("Long War of the Chosen Version: " $ class'LWVersion'.static.GetVersionString());
}

exec function LWOTC_RevealAvatarProject()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	if(AlienHQ != none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Console Command Activate Avatar Project");
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		NewGameState.AddStateObject(AlienHQ);

	// Complete the Avatar reveal project as soon as doom is added to the fortress so players know what they're up against.
	`LWTrace("Triggering Avatar Project reveal...");
	class'XComGameState_Objective'.static.StartObjectiveByName(NewGameState, 'LW_T2_M1_N2_RevealAvatarProject');
	`XEVENTMGR.TriggerEvent('StartAvatarProjectReveal');

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
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

// Rebuild ability tree and XCOM abilities for the soldier selected
// in the armory.
exec function RespecSelectedSoldier()
{
	local UIArmory							Armory;
	local StateObjectReference				UnitRef;
	local XComGameState_Unit				UnitState;
	
	Armory = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));
	if (Armory == none)
	{
		class'Helpers'.static.OutputMsg("No unit selected - cannot respec soldier");
		return;
	}

	UnitRef = Armory.GetUnitRef();
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	if (UnitState == none)
	{
		class'Helpers'.static.OutputMsg("No unit selected - cannot respec soldier");
		return;
	}

	RespecSoldier(UnitState);
	Armory.PopulateData();
}

exec function RespecAllSoldiers()
{
	local XComGameState_HeadquartersXCom	XComHQ;
	local XComGameState_Unit				UnitState;
	local array<XComGameState_Unit>			Soldiers;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Soldiers = XComHQ.GetSoldiers();
	foreach Soldiers(UnitState)
	{
		// Skip Psi Operatives as they're ranking up requires training
		if (!UnitState.IsPsiOperative())
			RespecSoldier(UnitState);
	}
}

static function RespecSoldier(XComGameState_Unit UnitState, optional bool bResetLoadout = false)
{
	local XComGameStateHistory				History;
	local XComGameState						NewGameState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local name								ClassName;
	local int								i, NumRanks, iXP;
	local array<XComGameState_Item>			EquippedImplants;

	History = `XCOMHISTORY;

	ClassName = UnitState.GetSoldierClassTemplateName();
	NumRanks = UnitState.GetRank();

	iXP = UnitState.GetXPValue();
	iXP -= class'X2ExperienceConfig'.static.GetRequiredXp(NumRanks);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Respec Soldier");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
	
	if (ClassName == 'Random' || ClassName == 'Rookie')
	{
		ClassName = XComHQ.SelectNextSoldierClass();
	}

	// Remove PCSes because they mess up the base stats after the reset.
	EquippedImplants = UnitState.GetAllItemsInSlot(eInvSlot_CombatSim);
	for (i = 0; i < EquippedImplants.Length; i++)
	{
		UnitState.RemoveItemFromInventory(EquippedImplants[i], NewGameState);
	}

	UnitState.AbilityPoints = 0; // Reset Ability Points
	UnitState.SpentAbilityPoints = 0; // And reset the spent AP tracker
	UnitState.ResetSoldierRank(); // Clear their rank
	ApplyRandomizedInitialStats(UnitState, NewGameState);
	UnitState.ResetSoldierAbilities(); // Clear their current abilities
	UnitState.ClearUnitValue('LWOTC_AbilityCostModifier'); // Reset the ability cost multiplier
	for (i = 0; i < NumRanks; ++i) // Rank soldier back up to previous level
	{
		UnitState.RankUpSoldier(NewGameState, ClassName);
	}
	if(bResetLoadout)
	 {
	 	UnitState.ApplySquaddieLoadout(NewGameState, XComHQ);
	 }

	// Reapply Stat Modifiers (Beta Strike HP, etc.)
	UnitState.bEverAppliedFirstTimeStatModifiers = false;
	if (UnitState.GetMyTemplate().OnStatAssignmentCompleteFn != none)
	{
		UnitState.GetMyTemplate().OnStatAssignmentCompleteFn(UnitState);
	}
	UnitState.ApplyFirstTimeStatModifiers();

	// Restore any partial XP the soldier had
	if (iXP > 0)
	{
		UnitState.AddXp(iXP);
	}

	// Restore the PCSes.
	for (i = 0; i < EquippedImplants.Length; i++)
	{
		UnitState.AddItemToInventory(EquippedImplants[i], eInvSlot_CombatSim, NewGameState);
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

static function ApplyRandomizedInitialStats(XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XComGameState_LWToolboxOptions ToolboxOptions;
	
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();
	ToolboxOptions.UpdateOneSoldier_RandomizedInitialStats(UnitState, NewGameState, true);
}

exec function MeetFaction(string FactionName, optional bool bIgnoreRevealSequence)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_ResistanceFaction FactionState;
	local X2StrategyElementTemplateManager StratMgr;
	local XComGameState_Reward RewardState;
	local X2RewardTemplate RewardTemplate;

	History = `XCOMHISTORY;
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_FactionSoldier'));

	if (InStr(FactionName, "Faction_") != 0)
		FactionName = "Faction_" $ FactionName;

	if (FactionName != "Faction_Skirmishers" && FactionName != "Faction_Reapers" && FactionName != "Faction_Templars")
	{
		`Log("No faction found for name '" $ FactionName $ "'");
		return;
	}

	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		if (FactionState.GetMyTemplateName() == name(FactionName))
			break;
	}

	if (!FactionState.bMetXCom)
	{
		// Generate a Faction Soldier reward and give it to the player
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: MeetFaction");

		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		RewardState.GenerateReward(NewGameState, , FactionState.GetReference());
		RewardState.GiveReward(NewGameState);

		FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(class'XComGameState_ResistanceFaction', FactionState.ObjectID));
		FactionState.MeetXCom(NewGameState);
		FactionState.bSeenFactionHQReveal = bIgnoreRevealSequence;

		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}

	`HQPRES.DisplayNewStaffPopupIfNeeded();
}

// This is a DLCInfo hook added by the Community Highlander
static function WeaponInitialized(XGWeapon WeaponArchetype, XComWeapon Weapon, optional XComGameState_Item ItemState = none)
{
	local X2WeaponTemplate		WeaponTemplate;
	local XComGameState_Item	InternalWeaponState;
	local X2UnifiedProjectile	Proj;

	//`Log("IRIDAR Weapon Initialized triggered.", class'X2DownloadableContentInfo_WOTCUnderbarrelAttachments'.default.ENABLE_LOGGING, 'WOTCUnderbarrelAttachments');

	InternalWeaponState = ItemState;
	if (InternalWeaponState == none)
	{
		//`Log("IRIDAR InternalWeaponState is none.", class'X2DownloadableContentInfo_WOTCUnderbarrelAttachments'.default.ENABLE_LOGGING, 'WOTCUnderbarrelAttachments');
		InternalWeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponArchetype.ObjectID));
	}

	WeaponTemplate = X2WeaponTemplate(InternalWeaponState.GetMyTemplate());

	if (WeaponTemplate.WeaponCat == 'psiamp')
	{
		Proj = X2UnifiedProjectile(`CONTENT.RequestGameArchetype("LW_PsiOverhaul.PJ_PsiPinion"));

		if (!IsProjectileElementPresent(Weapon.DefaultProjectileTemplate.ProjectileElements, Proj.ProjectileElements[0]))
		{
			//`Log("IRIDAR Adding projectiles to: " @ WeaponTemplate.DataName, class'X2DownloadableContentInfo_WOTCUnderbarrelAttachments'.default.ENABLE_LOGGING, 'WOTCUnderbarrelAttachments');
			Weapon.DefaultProjectileTemplate.ProjectileElements.AddItem(Proj.ProjectileElements[0]);
		}
		if (!IsProjectileElementPresent(Weapon.DefaultProjectileTemplate.ProjectileElements, Proj.ProjectileElements[1]))
		{
			//`Log("IRIDAR Adding projectiles to: " @ WeaponTemplate.DataName, class'X2DownloadableContentInfo_WOTCUnderbarrelAttachments'.default.ENABLE_LOGGING, 'WOTCUnderbarrelAttachments');
			Weapon.DefaultProjectileTemplate.ProjectileElements.AddItem(Proj.ProjectileElements[1]);
		}
	}
}
		
static function bool IsProjectileElementPresent(array<X2UnifiedProjectileElement> Haystack, X2UnifiedProjectileElement Needle)	// Thanks, Musashi-san!
{
    local X2UnifiedProjectileElement Element;
    
    foreach Haystack(Element)
    {
        if (Element.Comment == Needle.Comment)
        {
            return true;
        }
    }
    return false;
}

exec function DumpObjectInfo(int ObjectID)
{
	local XComGameStateHistory History;
	local XComGameState_BaseObject DumpObject;

	History = `XCOMHISTORY;

	DumpObject = History.GetGameStateForObjectID(ObjectID);
	class'Helpers'.static.OutputMsg("Object class: " $ DumpObject.Class $ ", template: " $ DumpObject.GetMyTemplateName());
	class'Helpers'.static.OutputMsg("Parent object ID: " $ DumpObject.OwningObjectId);
}

exec function DumpUnitInfo()
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState, eReturnType_Reference, true)
	{
		`LWTrace("=== Unit " $ UnitState.ObjectID $ " ===");
		`LWTrace("  Name: " $ UnitState.GetFullName());
		`LWTrace("  Unit template: " $ UnitState.GetMyTemplateName());
		`LWTrace("  Unit class: " $ UnitState.GetSoldierClassTemplateName());
	}

	class'Helpers'.static.OutputMsg("Unit information dumped to log");
}


exec function CacheInfiltration()
{
	CacheInfiltration_Static();
}

static function CacheInfiltration_Static()
{
	local XComGameStateHistory History;
	local XComGameState_LWSquadManager SquadMgr;
	local StateObjectReference Squad;
	local XComGameState_LWPersistentSquad SquadState;
	local XComGameState NewGameState;

	SquadMgr = `LWSQUADMGR;
	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Cache covertness values");
	
	foreach SquadMgr.Squads (Squad)
	{
		SquadState = XComGameState_LWPersistentSquad(History.GetGameStateForObjectID(Squad.ObjectID));

		if(SquadState != none)
		{
			if(SquadState.bOnMission)
			{
				SquadState = XComGameState_LWPersistentSquad(NewGameState.ModifyStateObject(class'XComGameState_LWPersistentSquad', SquadState.ObjectID));
				SquadState.SquadCovertnessCached = SquadState.GetSquadCovertness(SquadState.SquadSoldiersOnMission);
				`LWTrace("caching Covertness value" @SquadState.SquadCovertnessCached @"for" @SquadState);
			}
		}
	}


	`GAMERULES.SubmitGameState(NewGameState);
}

static function UpdateSitreps()
{
	local X2SitRepTemplateManager SitRepMgr;
	local name SitRepName;
	local X2SitRepTemplate Sitrep;

	SitRepMgr = class'X2SitRepTemplateManager'.static.GetSitRepTemplateManager();

	foreach default.SitrepsToDisable(SitRepName)
	{
		Sitrep = SitRepMgr.FindSitRepTemplate(SitRepName);
		if(Sitrep != none)
		{
			`LWTrace("Disabling Sitrep" @SitRepName @"From appearing normally on missions");
			Sitrep.StrategyReqs.SpecialRequirementsFn = class'Helpers_LW'.static.AlwaysFail;
		}
	}
}

static function CacheInstalledMods()
{
	class'Helpers_LW'.default.bSmokeStopsFlanksActive = class'Helpers_LW'.static.IsModInstalled("SmokeStopsFlanks");
	class'Helpers_LW'.default.bImprovedSmokeDefenseActive = class'Helpers_LW'.static.IsModInstalled("ImprovedSmokeDefense");

	class'Helpers_LW'.default.bWOTCRevertOverwatchRulesActive = class'Helpers_LW'.static.IsModInstalled("WOTCRevertOverwatchRules");
	class'Helpers_LW'.default.bWOTCCostBasedAbilityColorsActive = class'Helpers_LW'.static.IsModInstalled("WOTC_CostBasedAbilityColors");
	class'Helpers_LW'.default.bWorldWarLostActive = class'Helpers_LW'.static.IsModInstalled("WorldWarLost");
	class'Helpers_LW'.default.XCOM2RPGOverhaulActive = class'Helpers_LW'.static.IsModInstalled("XCOM2RPGOverhaul");
	class'Helpers_LW'.default.bKirukaFactionOverhaulActive = class'Helpers_LW'.static.IsModInstalled("KirukasFactionSoldiersLWOTC");
	class'Helpers_LW'.default.bNewTemplarModJamActive = class'Helpers_LW'.static.IsModInstalled("NewTemplarModJam");
	class'Helpers_LW'.default.bDABFLActive = class'Helpers_LW'.static.IsModInstalled("DiverseAliensByForceLevelWOTC");
	class'Helpers_LW'.default.bKirukaSparkActive = class'Helpers_LW'.static.IsModInstalled("KirukasSparkLWOTC_M2");
	class'Helpers_LW'.default.bDSLReduxActive = class'Helpers_LW'.static.IsModInstalled("WOTC_DSL_Rusty");

	`LWTrace("cached bSmokeStopsFlanksActive: " @ class'Helpers_LW'.default.bSmokeStopsFlanksActive );
	`LWTrace("cached bImprovedSmokeDefenseActive: " @class'Helpers_LW'.default.bImprovedSmokeDefenseActive);
	`LWTrace("cached bWOTCRevertOverwatchRulesActive: " @class'Helpers_LW'.default.bWOTCRevertOverwatchRulesActive);
	`LWTrace("cached bWOTCCostBasedAbilityColorsActive: " @class'Helpers_LW'.default.bWOTCCostBasedAbilityColorsActive);
	`LWTrace("cached bWorldWarLostActive: " @class'Helpers_LW'.default.bWorldWarLostActive);
	`LWTrace("cached XCOM2RPGOverhaulActive: " @class'Helpers_LW'.default.XCOM2RPGOverhaulActive);
	`LWTrace("cached bKirukaFactionOverhaulActive: " @class'Helpers_LW'.default.bKirukaFactionOverhaulActive);
	`LWTrace("cached bNewTemplarModJamActive: " @class'Helpers_LW'.default.bNewTemplarModJamActive);
	`LWTrace("cached bDABFLActive: " @class'Helpers_LW'.default.bDABFLActive);
	`LWTrace("cached bKirukaSparkActive: " @class'Helpers_LW'.default.bKirukaSparkActive);
	`LWTrace("cached bDSLReduxActive: " @class'Helpers_LW'.default.bDSLReduxActive);
}

exec function LWOTC_SetSelectedUnitActive()
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local StateObjectReference				UnitRef;
	local XComGameState_Unit				UnitState;
	local XComGameState						NewGameState;
	local XComGameState_HeadquartersXCom	XComHQ;

	History = `XCOMHISTORY;

		Armory = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));
	if (Armory == none)
	{
		class'Helpers'.static.OutputMsg("Error: Not in Armory");
		return;
	}

	UnitRef = Armory.GetUnitRef();
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
	if (UnitState == none)
	{
		class'Helpers'.static.OutputMsg("Error: No Unit Selected");
		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Force unit active");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

	UnitState.SetStatus(eStatus_Active);

	class'Helpers'.static.OutputMsg("Unit marked as active" @ `SHOWVAR(UnitState.GetFullName() ));

	if( NewGameState.GetNumGameStateObjects() > 0 )
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}

	Armory.PopulateData();
}



exec function LWOTC_Fix_HealSelectedUnit()
{
	local XComGameStateHistory				History;
	local UIArmory							Armory;
	local StateObjectReference				UnitRef;
	local XComGameState_Unit				UnitState;
	local XComGameState_HeadquartersProjectHealSoldier HealProject;

	History = `XCOMHISTORY;

	Armory = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));

	if (Armory == none)
	{
		class'Helpers'.static.OutputMsg("Error: Not in Armory");
		return;
	}

	UnitRef = Armory.GetUnitRef();
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

	if (UnitState == none)
	{
		class'Helpers'.static.OutputMsg("Error: No Unit Selected");
		return;
	}


	foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectHealSoldier', HealProject)
	{
		if(HealProject.ProjectFocus.ObjectID == UnitRef.ObjectID)
		{
			HealProject.OnProjectCompleted();
			class'Helpers'.static.OutputMsg("Unit healed" @ `SHOWVAR(UnitState.GetFullName()));
			break;
		}
	}
}

exec function LWOTC_ForceAllUnitsActive()
{
	local XComGameStateHistory 		History;
	local XComGameState_Unit 		UnitState;
	local XComGameState				NewGameState;
	local StateObjectReference		UnitReference;
	local XComGameState_HeadquartersXCom		XComHQ;

	History = `XCOMHISTORY;
	
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Force all units active");

	foreach XComHQ.Crew(UnitReference)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitReference.ObjectID));
		if (UnitState != none)
		{
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
			UnitState.SetStatus(eStatus_Active);
		}
	}

	if( NewGameState.GetNumGameStateObjects() > 0 )
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

exec function LWOTC_ShowChosenKnowledgeRandomValues()
{
	local XComGameState_LWOverhaulOptions LWOverhaulOptions;

	local array<int> chosenKnowledge;

	LWOverhaulOptions = `LWOVERHAULOPTIONS;

	chosenKnowledge = LWOverhaulOptions.GetChosenKnowledgeGains_Randomized();
	class'Helpers'.static.OutputMsg(`SHOWVAR(LWOverhaulOptions.StartingChosen));
	class'Helpers'.static.OutputMsg(`SHOWVAR(class'X2EventListener_ChosenEndOfMonth'.default.STARTING_CHOSEN_KNOWLEDGE_GAIN));
	class'Helpers'.static.OutputMsg(`SHOWVAR(LWOverhaulOptions.ChosenNames[0]));
	class'Helpers'.static.OutputMsg(`SHOWVAR(chosenKnowledge[0]));
	class'Helpers'.static.OutputMsg(`SHOWVAR(LWOverhaulOptions.ChosenNames[1]));	
	class'Helpers'.static.OutputMsg(`SHOWVAR(chosenKnowledge[1]));
}

exec function LWOTC_ShowChosenLevels()
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(, true);

		foreach AllChosen(ChosenState)
		{
			class'Helpers'.static.OutputMsg(`SHOWVAR(ChosenState.GetMyTemplateName()));
			class'Helpers'.static.OutputMsg("Chosen Level:" @`SHOWVAR(ChosenState.Level));
		}
}

exec function LWOTC_ShowChosenStrengths()
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;
	local name ChosenStrength;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(, true);

		foreach AllChosen(ChosenState)
		{
			class'Helpers'.static.OutputMsg(`SHOWVAR(ChosenState.GetMyTemplateName()));
			foreach ChosenState.Strengths (ChosenStrength)
			{
				class'Helpers'.static.OutputMsg("Chosen strengths:" @ ChosenStrength);
			}
		}
}

exec function LWOTC_ShowChosenStrongholdMissions()
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(, true);

		foreach AllChosen(ChosenState)
		{
			class'Helpers'.static.OutputMsg(`SHOWVAR(ChosenState.GetMyTemplateName()));
			class'Helpers'.static.OutputMsg("Chosen Stronghold Mission ID:" @ ChosenState.StrongholdMission.ObjectID);
		}
}

exec function LWOTC_SpawnChosenStrongholdMission(name ChosenName)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_Reward RewardState;
	local X2RewardTemplate RewardTemplate;
	local X2StrategyElementTemplateManager StratMgr;
	local X2MissionSourceTemplate MissionSource;
	local array<XComGameState_Reward> MissionRewards;
	local bool bFound;

	History = `XCOMHISTORY;
	bFound = false;

	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		if(ChosenState.GetMyTemplateName() == ChosenName)
		{
			bFound = true;
			break;
		}
	}

	if(!bFound)
	{
		return;
	}
	`LWTrace("Found Chosen" @ChosenState.GetMyTemplateName());
	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: New Chosen Stronghold stuff");
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	RegionState = ChosenState.GetHomeRegion();

	MissionRewards.Length = 0;
	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_None'));
	RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	MissionRewards.AddItem(RewardState);

	MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_ChosenStronghold'));
	MissionState = XComGameState_MissionSite(NewGameState.CreateNewStateObject(class'XComGameState_MissionSite'));
	MissionState.BuildMission(MissionSource, RegionState.GetRandom2DLocationInRegion(), RegionState.GetReference(), MissionRewards);
	`LWTrace("New Chosen Stronghold Mission Object ID:" @MissionState.GetReference().ObjectID);
	MissionState.ResistanceFaction = ChosenState.RivalFaction;
	ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
	ChosenState.StrongholdMission = MissionState.GetReference();
	
	MissionState.SetMissionData(MissionRewards[0].GetMyTemplate(), false, 0);
	

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

exec function FindObjectiveSpawnInfo(name MissionName)
{
	local XComTacticalMissionManager MissionMgr;
    local int idx,ObjectiveIdx;

    MissionMgr = `TACTICALMISSIONMGR;
    for(idx = 0; idx < MissionMgr.arrMissions.Length; idx++)
    {
       `LWTrace("arr missions idx" @ string(idx) @": mission name is" @ MissionMgr.arrMissions[idx].MissionName);
    }
    for(idx = 0; idx < MissionMgr.arrObjectiveSpawnInfo.Length;idx++)
    {
        `LWTrace("arr objective spawn info idx" @ string(idx) @": mission stype is" @ MissionMgr.arrObjectiveSpawnInfo[idx].sMissionType);
    }
    
        idx = FindMissionIndex(MissionMgr.arrMissions,MissionName);
        if(idx != INDEX_NONE)
        {
            `LWTrace("found mission at arrmissions with index" @ string(idx));
            ObjectiveIdx = FindObjectiveSpawnInfoIndex(MissionMgr.arrObjectiveSpawnInfo,MissionMgr.arrMissions[idx].sType);
            if(ObjectiveIdx != INDEX_NONE)
            {
                `LWTrace("found objective spawn info at index" @ string(ObjectiveIdx));
				`LWTrace("Mission stuff:");
				`LWTrace("Mission Name:"@MissionMgr.arrMissions[idx].MissionName);
				`LWTrace("Mission Type:"@MissionMgr.arrMissions[idx].sType);
				`LWTrace("Objective sType:"@MissionMgr.arrObjectiveSpawnInfo[ObjectiveIdx].sMissionType);
				`LWTrace("iMinObjectives:"@MissionMgr.arrObjectiveSpawnInfo[ObjectiveIdx].iMinObjectives);
				`LWTrace("iMaxObjectives:"@MissionMgr.arrObjectiveSpawnInfo[ObjectiveIdx].iMaxObjectives);
            }
            else
            {
                `LWTrace("error: did not find objective spawn info");
            }  
        }
        else
        {
            `LWTrace("error: did not find this mission");
        }
    
}

static final function int FindMissionIndex(array<MissionDefinition> MissionDefs,name MissionName)
{
    return MissionDefs.Find('MissionName',MissionName);
}

static final function int FindObjectiveSpawnInfoIndex(array<ObjectiveSpawnInfo> SpawnInfo,String MissionType)
{
    return SpawnInfo.Find('sMissionType',MissionType);
}

exec function PrintKismetVariables(optional bool bAllVars)
{
    //local array<SequenceVariable> OutVariables;
    local array<SequenceObject> OutObjects;
    local SequenceObject SeqObj;
    local SequenceVariable SeqVar;
    local SeqVar_Int SeqVarTimer;
	local SeqVar_Vector SeqVarVector;
    local Sequence CurrentSequence;

    CurrentSequence = `XWORLDINFO.GetGameSequence();
    if(CurrentSequence == none)
    {
        return;
    }

    CurrentSequence.FindSeqObjectsByClass(class'SequenceVariable', true, OutObjects);

    foreach OutObjects(SeqObj)
    {
        SeqVar = SequenceVariable(SeqObj);
        if(SeqVar != none)
        {
            SeqVarTimer = SeqVar_Int(SeqVar);
            if(SeqVarTimer != none)
            {
                if(bAllVars)
                {
                    class'Helpers'.static.OutputMsg("Found KismetVariable: " $ SeqVarTimer.VarName $ ", Value= " $ SeqVarTimer.IntValue);
                }


                    //class'Helpers'.static.OutputMsg("KismetVariable: " $ SeqVar.VarName $ ", Value= " $ SeqVarTimer.IntValue);
                    //class'Helpers'.static.OutputMsg("Found KismetVariable To Adjust: " $ Adjustment);
                    //SeqVarTimer.IntValue = SeqVarTimer.IntValue + Adjustment;
                    `LWTrace("Named KismetVariable: " $ SeqVarTimer.VarName $ ", Value= " $ SeqVarTimer.IntValue);
                    class'Helpers'.static.OutputMsg("Named KismetVariable: " $ SeqVarTimer.VarName $ ", Value= " $ SeqVarTimer.IntValue);
                
            }
        }
		SeqVarVector = SeqVar_Vector(SeqObj);
		if(SeqVarVector != none)
		{
			class'Helpers'.static.OutputMsg("Named KismetVariable: " $ SeqVarVector.VarName $ ", X Value= " $ SeqVarVector.VectValue.x);
			class'Helpers'.static.OutputMsg("Named KismetVariable: " $ SeqVarVector.VarName $ ", Y Value= " $ SeqVarVector.VectValue.y);
			class'Helpers'.static.OutputMsg("Named KismetVariable: " $ SeqVarVector.VarName $ ", Z Value= " $ SeqVarVector.VectValue.z);
		}
    }
}

exec function PrintCurrentMissionDef()
{
	local XComGameState_HeadquartersXCom XComHQ;
//	local XComGameState_MissionSite MissionState;
	local GeneratedMissionData MissionData;
	local string CurrentMap;

	XComHQ = `XCOMHQ;

	foreach XComHQ.arrGeneratedMissionData (MissionData)
	{
		if(MissionData.Mission.stype != "GP_Fortress_LW")
			continue;

		class'Helpers'.static.OutputMsg("Found MissionDef" @ MissionData.Mission.MissionName);

		foreach MissionData.Mission.MapNames (CurrentMap)
		{
			class'Helpers'.static.OutputMsg("Found map" @CurrentMap);
		}
		class'Helpers'.static.OutputMsg("\n");
	}

}

// borrowed from Rusty and modified for all healing project, not card
exec function LWOTC_CheckHealingProjects()
{
	local XComGameState_Unit	                        UnitState;
	
    local XComGameStateHistory                          History;
	local XComGameState_HeadquartersProjectHealSoldier			HealSoldierProject;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectHealSoldier', HealSoldierProject)
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(HealSoldierProject.ProjectFocus.ObjectID));

		class'Helpers'.static.OutputMsg("==============================================");
		class'Helpers'.static.OutputMsg("HealProject found for" @UnitState.GetFullName());
		class'Helpers'.static.OutputMsg(`SHOWVAR(UnitState.GetCurrentStat(eStat_HP)));
		class'Helpers'.static.OutputMsg(`SHOWVAR(UnitState.GetMaxStat(eStat_HP)));

		class'Helpers'.static.OutputMsg(`SHOWVAR(HealSoldierProject.ProjectPointsRemaining));
		class'Helpers'.static.OutputMsg(`SHOWVAR(HealSoldierProject.BlocksRemaining));
		class'Helpers'.static.OutputMsg(`SHOWVAR(HealSoldierProject.PointsPerBlock));
		class'Helpers'.static.OutputMsg(`SHOWVAR(HealSoldierProject.BlockPointsRemaining));
		//class'Helpers'.static.OutputMsg(`SHOWVAR(HealSoldierProject.bForcePaused));
		class'Helpers'.static.OutputMsg(`SHOWVAR(HealSoldierProject.GetProjectedNumHoursRemaining()));
		class'Helpers'.static.OutputMsg(`SHOWVAR(HealSoldierProject.GetCurrentNumHoursRemaining()));

		class'Helpers'.static.OutputMsg(`SHOWVAR(HealSoldierProject.GetCurrentWorkPerHour()));
	}

}

exec function LWOTC_CheckWillProjects()
{
	local XComGameState_Unit	                        UnitState;
    local XComGameStateHistory                          History;
	local XComGameState_HeadquartersProjectRecoverWill	WillProject;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectRecoverWill', WillProject)
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(WillProject.ProjectFocus.ObjectID));

		class'Helpers'.static.OutputMsg("==============================================");
		class'Helpers'.static.OutputMsg("WillProject found for" @UnitState.GetFullName());
		class'Helpers'.static.OutputMsg(`SHOWVAR(UnitState.GetCurrentStat(eStat_Will)));
		class'Helpers'.static.OutputMsg(`SHOWVAR(UnitState.GetMaxStat(eStat_Will)));

		class'Helpers'.static.OutputMsg(`SHOWVAR(WillProject.ProjectPointsRemaining));
		class'Helpers'.static.OutputMsg(`SHOWVAR(WillProject.BlocksRemaining));
		class'Helpers'.static.OutputMsg(`SHOWVAR(WillProject.PointsPerBlock));
		class'Helpers'.static.OutputMsg(`SHOWVAR(WillProject.BlockPointsRemaining));
		//class'Helpers'.static.OutputMsg(`SHOWVAR(HealSoldierProject.bForcePaused));
		class'Helpers'.static.OutputMsg(`SHOWVAR(WillProject.GetProjectedNumHoursRemaining()));
		class'Helpers'.static.OutputMsg(`SHOWVAR(WillProject.GetCurrentNumHoursRemaining()));

		class'Helpers'.static.OutputMsg(`SHOWVAR(WillProject.GetCurrentWorkPerHour()));

	}

}

exec function LWOTC_CheckPsiProjects()
{
	local XComGameState_Unit	                        UnitState;
    local XComGameStateHistory                          History;
	local XComGameState_HeadquartersProjectPsiTraining	PsiTrainingProject;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectPsiTraining', PsiTrainingProject)
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(PsiTrainingProject.ProjectFocus.ObjectID));

		class'Helpers'.static.OutputMsg("==============================================");
		class'Helpers'.static.OutputMsg("PsiTrainingProject found for" @UnitState.GetFullName());

		class'Helpers'.static.OutputMsg(`SHOWVAR(PsiTrainingProject.ProjectPointsRemaining));

		class'Helpers'.static.OutputMsg(`SHOWVAR(PsiTrainingProject.bForcePaused));
		class'Helpers'.static.OutputMsg(`SHOWVAR(PsiTrainingProject.GetProjectedNumHoursRemaining()));
		class'Helpers'.static.OutputMsg(`SHOWVAR(PsiTrainingProject.GetCurrentNumHoursRemaining()));

		class'Helpers'.static.OutputMsg(`SHOWVAR(PsiTrainingProject.GetCurrentWorkPerHour()));

	}

}

exec function LWOTC_CheckCapturedSoldiers()
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	local StateObjectReference CapturedSoldierRef;
	local XComGameState_Unit UnitState;
	local array<XComGameState_AdventChosen> AllChosen;
	
	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen();

	// First collect any soldiers captured "normally", i.e. not by the Chosen
	foreach AlienHQ.CapturedSoldiers(CapturedSoldierRef)
	{
		class'Helpers'.static.OutputMsg("Found captured soldier ID:" @ CapturedSoldierRef.ObjectID);
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(CapturedSoldierRef.ObjectID));
		class'Helpers'.static.OutputMsg("Captured Soldier Name " @ UnitState.GetFirstName() @ UnitState.GetLastName());
		class'Helpers'.static.OutputMsg("Captured Soldier Class:" @ UnitState.GetSoldierClassTemplateName());
		// Check whether the soldier is already attached as a mission or covert action reward
		if (!class'Helpers_LW'.static.IsRescueMissionAvailableForSoldier(CapturedSoldierRef))
		{
			`LWTrace("[RescueSoldier] Captured soldier (normal) available for rescue " $ CapturedSoldierRef.ObjectID);
			class'Helpers'.static.OutputMsg("No current rescue mission for this soldier.");
		}
		else
		{
			class'Helpers'.static.OutputMsg("There's a mission somewhere for this unit.");
		}
	}

	// Now collect any soldiers captured by the Chosen
	foreach AllChosen(ChosenState)
	{
		foreach ChosenState.CapturedSoldiers(CapturedSoldierRef)
		{
			class'Helpers'.static.OutputMsg("Found captured soldier ID:" @ CapturedSoldierRef.ObjectID);
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(CapturedSoldierRef.ObjectID));
			class'Helpers'.static.OutputMsg("Captured Soldier Name " @ UnitState.GetFirstName() @ UnitState.GetLastName());
			class'Helpers'.static.OutputMsg("Captured Soldier Class:" @ UnitState.GetSoldierClassTemplateName());
			// Check whether the soldier is already attached as a mission or covert action reward
			if (!class'Helpers_LW'.static.IsRescueMissionAvailableForSoldier(CapturedSoldierRef))
			{
				`LWTrace("[RescueSoldier] Captured soldier (Chosen - " $ ChosenState.GetMyTemplateName() $ ") available for rescue " $ CapturedSoldierRef.ObjectID);
				class'Helpers'.static.OutputMsg("No current rescue mission for this soldier.");
			}
			else
			{
				class'Helpers'.static.OutputMsg("There's a mission somewhere for this unit.");
			}
		}
	}

}


//------------ Hybrid Difficulty Stuff -------------

// InstallNewCampaign part called in LW_SMGPack_Integrated because it loads first

exec function Ted_SetNewCustomDifficulty()
{
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings CampaignSettingsStateObject;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("set new custom difficulty");

	CampaignSettingsStateObject = XComGameState_CampaignSettings(NewGameState.ModifyStateObject(class'XComGameState_CampaignSettings', CampaignSettingsStateObject.ObjectID));

	CampaignSettingsStateObject.SetDifficulty(4);

	`GAMERULES.SubmitGameState(NewGameState);
}

exec function Ted_CheckCurrentDifficulty()
{
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings CampaignSettingsStateObject;

	History = `XCOMHISTORY;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));

	`LWTrace("Current Tactical Difficulty:" @CampaignSettingsStateObject.GetTacticalDifficultyFromSettings());
	`LWTrace("Current Strategy Difficulty:" @CampaignSettingsStateObject.GetStrategyDifficultyFromSettings());

}

exec function LWOTC_TestSetForceLevelTuple()
{
	local XComLWTuple Tuple;
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Test LW FL tuple");

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'SetLWRegionalForceLevel';
	Tuple.Data.Add(4);
	
	Tuple.Data[0].kind = XComLWTVBool;
	Tuple.Data[0].b = true;

	Tuple.Data[1].kind = XComLWTVInt;
	Tuple.Data[1].i = 2;

	Tuple.Data[2].kind = XComLWTVBool;
	Tuple.Data[2].b = false;

	`XEVENTMGR.TriggerEvent('SetLWRegionalForceLevel', Tuple, , NewGameState);

	`GAMERULES.SubmitGameState(NewGameState);
}

exec function LWOTC_TestSetForceLevelTupleLocal()
{
	local XComLWTuple Tuple;
	local XComGameState NewGameState;
	local XComGameState_WorldRegion RegionState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Test LW FL tuple");

	RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.StartingRegion.ObjectID));

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'SetLWRegionalForceLevel';
	Tuple.Data.Add(4);
	
	Tuple.Data[0].kind = XComLWTVBool;
	Tuple.Data[0].b = false;

	Tuple.Data[1].kind = XComLWTVInt;
	Tuple.Data[1].i = 1;

	Tuple.Data[2].kind = XComLWTVBool;
	Tuple.Data[2].b = false;

	`XEVENTMGR.TriggerEvent('SetLWRegionalForceLevel', Tuple, RegionState, NewGameState);

	`GAMERULES.SubmitGameState(NewGameState);
}

exec function LWOTC_TestGetForceLevelTuple()
{
	local XComLWTuple Tuple;
	local int i;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'GetLWRegionalForceLevel';
	Tuple.Data.Add(2);

	`XEVENTMGR.TriggerEvent('GetLWRegionalForceLevel', Tuple);

	for(i=0; i < Tuple.Data[0].ao.Length; i++)
	{
		class'Helpers'.Static.OutputMsg("Region" @ `SHOWVAR(Tuple.Data[0].ao[i]));
		class'Helpers'.Static.OutputMsg("FL"@ `SHOWVAR(Tuple.Data[1].ai[i]));
	}
}

exec function LWOTC_AdvanceRNG(optional int numRolls = 1)
{
	local int i;

	for(i=0; i<numrolls; i++)
	{
		`SYNC_FRAND_STATIC();
	}
}

exec function LWOTC_Test_PrintPCPDefs()
{
	local XComPlotCoverParcelManager PCPManager;
	local PCPDefinition PCPDef;
	local string PCPPlotType;

	PCPManager = new class'XComPlotCoverParcelManager';

	foreach PCPManager.arrAllPCPDefs (PCPDef)
	{
		`LWTrace("PCP Def:" @PCPDef.MapName);
		foreach PCPDef.arrPlotTypes (PCPPlotType)
		{
			`LWTrace("PCP plot type:" @PCPPlotType);
		}
	}

}

exec function LWOTC_ViewMissionDef(name MissionDefName)
{
	local MissionDefinition MissionDefinition;
	local XComTacticalMissionManager MissionManager;
	local int MissionIdx;
	local name MissionSchedule;
	local string MapName;

	MissionManager = `TACTICALMISSIONMGR;

		MissionIdx = MissionManager.arrMissions.Find('MissionName', MissionDefName);
		if(MissionIdx != -1)
		{
			MissionDefinition = MissionManager.arrMissions[MissionIdx];

			`LWTrace("Mission Def name:" @ MissionDefinition.MissionName);

			`LWTrace("stype:" @MissionDefinition.sType);

			foreach MissionDefinition.MapNames (MapName)
			{
				`LWTrace("MapName:" @MapName);
			}

			foreach MissionDefinition.MissionSchedules (MissionSchedule)
			{
				`LWTrace("Schedule:" @MissionSchedule);
			}
		}
		else
		{
			`LWTrace("Couldn't find  missiondef for" @MissionDefName,, 'TedLog');
		}
	

}

exec function LWOTC_ChosenMonthsSinceReinforce()
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(, false);

		foreach AllChosen(ChosenState)
		{
			class'Helpers'.static.OutputMsg("Chosen Name:" @ChosenState.GetMyTemplateName());
			class'Helpers'.static.OutputMsg("Months since Chosen Reinforce:" @ChosenState.GetMonthsSinceAction('ChosenAction_ReinforceRegion'));
		}
}

exec function LWOTC_SortRebels()
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_LWOutpost	OutPostState;
	local XComGameState NewGameState;
	
	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Sort Outposts");

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		OutPostState = `LWOUTPOSTMGR.GetOutpostForRegion(RegionState);

		OutPostState = XComGameState_LWOutpost(NewGameState.ModifyStateObject(class'XComGameState_LWOutpost', OutPostState.ObjectID));

		OutpostState.SortRebels();
	}

	`GAMERULES.SubmitGameState(NewGameState);
}

exec function LWOTC_ShowPastChosenActions()
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_ChosenAction ActionState;
	local XComGameStateHistory History;
	local int idx, ICooldown;

	History = `XCOMHISTORY;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(, false);

		foreach AllChosen(ChosenState)
		{
			`LWTrace("Chosen:" @ ChosenState.GetMyTemplateName());
			for(idx = (ChosenState.PreviousMonthActions.Length - 1); idx >= 0; idx--)
			{

				ActionState = XComGameState_ChosenAction(History.GetGameStateForObjectID(ChosenState.PreviousMonthActions[idx].ObjectID));
				
				`LWTrace("Action" @idx $":" @ActionState.GetMyTemplateName());
			}

		}

		foreach AllChosen(ChosenState)
	{
        // The fix is the below line, ChosenState changed to Chosen
		ICooldown = ChosenState.GetMonthsSinceAction('ChosenAction_ReinforceRegion');

		`LWTrace(ChosenState.GetMyTemplateName() @ "Months since Reinforce:" @ICooldown);
	}
}

exec function LWOTC_ForceGenerateMap()
{
	//local XComParcelManager ParcelMgr;

	//ParcelMgr = `PARCELMGR;

	//ParcelMgr.GenerateMap(`SYNC_FRAND_STATIC()*100000);

	`TACTICALRULES.StartNewGame();
}

// This will murder/abandon all soldiers that are captured, intended for bugfixing/clearing dead bugged units.
exec function LWOTC_NukeCapturedSoldiers()
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;
	local XComGameStateHistory History;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(, false);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Nuking captured soldiers");

	AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	AlienHQ.CapturedSoldiers.Length = 0;

	foreach AllChosen(ChosenState)
	{
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
		ChosenState.CapturedSoldiers.Length = 0;
	}

	`GAMERULES.SubmitGameState(NewGameState);
}

exec function LWOTC_ShowChosenRegions()
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		class'Helpers'.static.OutputMsg(RegionState.GetMyTemplateName() @ RegionState.GetControllingChosen().GetMyTemplateName());
	}
}

// only use this once
exec function LWOTC_FixChosenKnowledgeForNewScaling()
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;
	local XComGameStateHistory History;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(, false);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Fix chosen knowledge levels");

	foreach AllChosen(ChosenState)
	{
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
		ChosenState.ModifyKnowledgeScore(NewGameState, ChosenState.GetKnowledgeScore(true) * 9, true, true);
		ChosenState.HandleKnowledgeLevelChange(NewGameState, ChosenState.GetKnowledgeLevel(), ChosenState.CalculateKnowledgeLevel());
	}

	`GAMERULES.SubmitGameState(NewGameState);
}

exec function Ted_CheckUnlockStatus(name TemplateName)
{
	class'Helpers'.static.OutputMsg(string(`XCOMHQ.HasSoldierUnlockTemplate(TemplateName)));
}

exec function Ted_CheckUnitValue()
{
	local XComGameState_Unit Unit;
	local XComTacticalController    TacticalController;
	local UnitValue DamageUnitValue;

	TacticalController = XComTacticalController(`BATTLE.GetALocalPlayerController());
	Unit = XComTacticalCheatManager(TacticalController.CheatManager).GetClosestUnitToCursor();

	if (Unit != none)
	{
		Unit.GetUnitValue('DamageThisTurn', DamageUnitValue);
		class'Helpers'.static.OutputMsg(string(DamageUnitValue.fValue));
	}
}

exec function Ted_ClearWaterworldCache()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_MissionSite		MissionState;
	local XComGameState NewGameState;
	local int i;

	XComHQ = `XCOMHQ;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if(MissionState.GetMissionSource().DataName == 'MissionSource_Final')
			break;
	}

	if(MissionState != None)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clear waterworld info");

		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

		i = XComHQ.arrGeneratedMissionData.Find('MissionID', MissionState.ObjectID);
		if (i != INDEX_NONE)
		{
			XComHQ.arrGeneratedMissionData.Remove(i, 1);
		}

		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}

}

exec function Ted_CheckWeaponDamageValues(name ItemName)
{
	local X2ItemTemplateManager ItemMgr;
	local X2ItemTemplate ItemTemplate;
	local int i;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemMgr.FindItemTemplate(ItemName);

	if(ItemTemplate != none)
	{
		class'Helpers'.static.OutputMsg("Extra damage length" @`SHOWVAR(X2WeaponTemplate(ItemTemplate).ExtraDamage.length));

		for(i = 0; i < X2WeaponTemplate(ItemTemplate).ExtraDamage.length; i++)
		{
			class'Helpers'.static.OutputMsg("Extra damage length" @`SHOWVAR(X2WeaponTemplate(ItemTemplate).ExtraDamage[i].Tag));
		}

	}
}