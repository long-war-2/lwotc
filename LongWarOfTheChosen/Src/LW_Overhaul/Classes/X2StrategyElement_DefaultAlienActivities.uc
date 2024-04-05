//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultAlienActivies.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Defines all Alien Activity templates
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultAlienActivities extends X2StrategyElement config(LW_Activities) dependson(UIMission_LWCustomMission, X2LWAlienActivityTemplate);



struct MissionSettings_LW
{
    var name MissionOrFamilyName;
    var name AlertName;
    var string MissionSound;
    var name EventTrigger;
    var EMissionUIType MissionUIType;
    var String OverworldMeshPath;
    var String MissionIconPath;
    var String MissionImagePath;
    var bool RestrictsLiaison;
};

//---------------------------------------------------------------------------------------
//      Careful, these objects should NEVER be modified - only constructed by default.
//      They can be freely used by any activity template, but NEVER modified by them.
var protected X2LWActivityCondition_NumberActivities	SingleActivityInRegion, SingleActivityInWorld, TwoActivitiesInWorld;
var protected X2LWActivityCondition_RegionStatus		ContactedAlienRegion, AnyAlienRegion;
var protected X2LWActivityCondition_ResearchFacility	ResearchFacilityInRegion;
var protected X2LWActivityCondition_AlertVigilance		AlertGreaterThanVigilance, AlertAtLeastEqualtoVigilance;
var protected X2LWActivityCondition_RestrictedActivity	GeneralOpsCondition;
var protected X2LWActivityCondition_RestrictedActivity  RetalOpsCondition;
var protected X2LWActivityCondition_RestrictedActivity  LiberationCondition;
var config array<MissionSettings_LW> MissionSettings;

var config int XCOM_WIN_VIGILANCE_GAIN;
var config int XCOM_LOSE_VIGILANCE_GAIN;

var config int COIN_MIN_COOLDOWN_HOURS;									// OK
var config int COIN_MAX_COOLDOWN_HOURS;									// OK
var config int ATTEMPT_COUNTERINSURGENCY_MIN_REBELS;
var config int ATTEMPT_COUNTERINSURGENCY_MIN_WORKING_REBELS;

var config int PROTECTREGION_RESET_LEVEL;
var config int LIBERATE_ADJACENT_VIGILANCE_INCREASE_BASE;
var config int LIBERATE_ADJACENT_VIGILANCE_INCREASE_RAND;
var config int LIBERATION_ALERT_LEVELS_KILLED;							// Number of ADVENT strength destroyed when liberating a region
var config int LIBERATION_ALERT_LEVELS_KILLED_RAND;

var config int REINFORCE_DIFFERENCE_REQ_FOR_FORCELEVEL_TRANSFER;
var config int REINFORCEMENTS_STOPPED_ORIGIN_VIGILANCE_INCREASE;
var config int REINFORCEMENTS_STOPPED_ADJACENT_VIGILANCE_BASE;
var config int REINFORCEMENTS_STOPPED_ADJACENT_VIGILANCE_RAND;

var config int OFFWORLD_REINFORCEMENTS_GLOBAL_VIG;
var config int EMERGENCY_REINFORCEMENT_PRIMARY_REGION_ALERT_BONUS;
var config int EMERGENCY_REINFORCEMENT_ADJACENT_REGION_ALERT_BONUS;
var config int ADJACENT_REGIONS_REINFORCED_BY_REGULAR_ALERT_UFO;

var config array<int> FORCE_UFO_LAUNCH;

var config int SUPEREMERGENCY_REINFORCEMENT_PRIMARY_REGION_ALERT_BONUS;		//OK
var config int ADJACENT_REGIONS_REINFORCED_BY_SUPEREMERGENCY_ALERT_UFO;
var config int SUPEREMERGENCY_REINFORCEMENT_ADJACENT_REGION_ALERT_BONUS;//OK
var config int SUPEREMERGENCY_ALERT_UFO_GLOBAL_COOLDOWN_DAYS;			//OK
var config int SUPER_EMERGENCY_GLOBAL_VIG;								//OK

var config int REPRESSION_REGIONAL_COOLDOWN_HOURS_MIN;					//OK
var config int REPRESSION_REGIONAL_COOLDOWN_HOURS_MAX;					//OK
var config int REPRESSION_ADVENT_LOSS_CHANCE;
var config int REPRESSION_RECRUIT_REBEL_CHANCE;
var config int REPRESSION_VIGILANCE_INCREASE_CHANCE;
var config int REPRESSION_REBEL_LOST_CHANCE;
var config int REPRESSION_CLONES_RELEASED_CHANCE;
var config int REPRESSION_2ND_REBEL_LOST_CHANCE;

var config int XCOM_WIN_PROPAGANDA_VIGILANCE_GAIN;
var config int PROPAGANDA_REGIONAL_COOLDOWN_HOURS_MIN;
var config int PROPAGANDA_REGIONAL_COOLDOWN_HOURS_MAX;
var config int PROP_REBEL_WEIGHT;
var config int PROP_ROOKIE_WEIGHT;
var config int PROPAGANDA_ADJACENT_VIGILANCE_BASE;
var config int PROPAGANDA_ADJACENT_VIGILANCE_RAND;

var config int PROTECT_RESEARCH_REGIONAL_COOLDOWN_HOURS_MIN;
var config int PROTECT_RESEARCH_REGIONAL_COOLDOWN_HOURS_MAX;
var config int PROTECT_RESEARCH_FIRST_MONTH_POSSIBLE;

var config int PROTECT_DATA_REGIONAL_COOLDOWN_HOURS_MIN;
var config int PROTECT_DATA_REGIONAL_COOLDOWN_HOURS_MAX;

var config int TROOP_MANEUVERS_VIGILANCE_GAIN;
var config int TROOP_MANEUVERS_NEIGHBOR_VIGILANCE_BASE;
var config int TROOP_MANEUVERS_NEIGHBOR_VIGILANCE_RAND;

var config float TROOP_MANEUVERS_BONUS_DETECTION_PER_DAY_PER_ALERT;
var config int TROOP_MANEUVERS_REGIONAL_COOLDOWN_HOURS_MIN;
var config int TROOP_MANEUVERS_REGIONAL_COOLDOWN_HOURS_MAX;
var config array<int> TROOP_MANEUVERS_CHANCE_KILL_ALERT;

var config int HIGH_VALUE_PRISONER_REGIONAL_COOLDOWN_HOURS_MIN;
var config int HIGH_VALUE_PRISONER_REGIONAL_COOLDOWN_HOURS_MAX;
var config int RESCUE_SCIENTIST_WEIGHT;
var config int RESCUE_ENGINEER_WEIGHT;
var config int RESCUE_SOLDIER_WEIGHT;
var config int RESCUE_REBEL_CONDITIONAL_WEIGHT;

var config int POLITICAL_PRISONERS_REGIONAL_COOLDOWN_HOURS_MIN;
var config int POLITICAL_PRISONERS_REGIONAL_COOLDOWN_HOURS_MAX;
var config int POLITICAL_PRISONERS_REBEL_REWARD_MIN;
var config int POLITICAL_PRISONERS_REBEL_REWARD_MAX;
var config int MAX_CAPTURED_SOLDIER_REWARDS;

var config int INTEL_RAID_REGIONAL_COOLDOWN_HOURS_MIN;
var config int INTEL_RAID_REGIONAL_COOLDOWN_HOURS_MAX;
var config int MIN_REBELS_TO_TRIGGER_INTEL_RAID;

var config int SUPPLY_RAID_REGIONAL_COOLDOWN_HOURS_MIN;
var config int SUPPLY_RAID_REGIONAL_COOLDOWN_HOURS_MAX;
var config int MIN_REBELS_TO_TRIGGER_SUPPLY_RAID;

var config int RECRUIT_RAID_REGIONAL_COOLDOWN_HOURS_MIN;
var config int RECRUIT_RAID_REGIONAL_COOLDOWN_HOURS_MAX;
var config int MIN_REBELS_TO_TRIGGER_RECRUIT_RAID;

var config int INVASION_REGIONAL_COOLDOWN_HOURS_MIN;
var config int INVASION_REGIONAL_COOLDOWN_HOURS_MAX;
var config int INVASION_MIN_LIBERATED_DAYS;

var config int SNARE_GLOBAL_COOLDOWN_HOURS_MIN;
var config int SNARE_GLOBAL_COOLDOWN_HOURS_MAX;

var config int FOOTHOLD_GLOBAL_COOLDOWN_HOURS_MIN;
var config int FOOTHOLD_GLOBAL_COOLDOWN_HOURS_MAX;
var config int ATTEMPT_FOOTHOLD_MAX_ALIEN_REGIONS;

var config int RENDEZVOUS_GLOBAL_COOLDOWN_HOURS_MIN;
var config int RENDEZVOUS_GLOBAL_COOLDOWN_HOURS_MAX;
var config float RENDEZVOUS_FL_MULTIPLIER;

var config array<int> REGIONAL_AVATAR_RESEARCH_TIME_MIN;
var config array<int> REGIONAL_AVATAR_RESEARCH_TIME_MAX;
var config array<float> CHANCE_PER_LOCAL_DOOM_TRANSFER_TO_ALIEN_HQ;
var config array<float> CHANCE_TO_GAIN_DOOM_IN_SUPER_EMERGENCY;

var config int LOGISTICS_REGIONAL_COOLDOWN_HOURS_MIN;
var config int LOGISTICS_REGIONAL_COOLDOWN_HOURS_MAX;

var config int COIN_OPS_GLOBAL_COOLDOWN;
var config int COIN_RESEARCH_GLOBAL_COOLDOWN;

var config array<float> INFILTRATION_BONUS_ON_LIBERATION;

var config bool ACTIVITY_LOGGING_ENABLED;

var config int RAID_MISSION_MIN_REBELS;
var config int RAID_MISSION_MAX_REBELS;
var config int PROHIBITED_JOB_DURATION;

var config int VIGILANCE_DECREASE_ON_ADVENT_RAID_WIN;
var config int VIGILANCE_DECREASE_ON_ADVENT_RETAL_WIN;

var config int VIGILANCE_CHANGE_ON_XCOM_RAID_WIN;
var config int VIGILANCE_CHANGE_ON_XCOM_RETAL_WIN;

var config int COIN_BUCKET;
var config int SUPPLY_RAID_BUCKET;
var config int INTEL_RAID_BUCKET;
var config int RECRUIT_RAID_BUCKET;

var config int ALIEN_BASE_DOOM_REMOVAL;

var config int CHOSEN_KNOWLEDGE_GAIN_MISSIONS;
var config int CHOSEN_ACTIVATE_AT_FL;
var config array<int> CHOSEN_LEVEL_FL_THRESHOLDS;

var protected name RebelMissionsJob;

var localized string m_strInsufficientRebels;

var config int COINOPS_MIN_VIGILANCE;
var config int COINOPS_MIN_ALERT;

var config int BIGSUPPLYEXTRACTION_MAX_ALERT;

//helpers for checking for name typos
var name ProtectRegionEarlyName;
var name ProtectRegionMidName;
var name ProtectRegionName;
var name CounterinsurgencyName;
var name ReinforceName;
var name COINResearchName;
var name COINOpsName;
var name BuildResearchFacilityName;
var name RegionalAvatarResearchName;
var name ScheduledOffworldReinforcementsName;
var name EmergencyOffworldReinforcementsName;
var name SuperEmergencyOffworldReinforcementsName;
var name RepressionName;
var name InvasionName;
var name PropagandaName;
var name ProtectResearchName;
var name ProtectDataName;
var name TroopManeuversName;
var name HighValuePrisonerName;
var name PoliticalPrisonersName;
var name IntelRaidName;
var name SupplyConvoyName;
var name RecruitRaidName;
var name SnareName;
var name FootholdName;
var name RendezvousName;
var name DebugMissionName;
var name LogisticsName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> AlienActivities;

	`LWTrace("  >> X2StrategyElement_DefaultAlienActivities.CreateTemplates()");
	
	AlienActivities.AddItem(CreateProtectRegionEarlyTemplate());
	AlienActivities.AddItem(CreateProtectRegionMidTemplate());
	AlienActivities.AddItem(CreateProtectRegionTemplate());
	AlienActivities.AddItem(CreateCounterinsurgencyTemplate());
	AlienActivities.AddItem(CreateReinforceTemplate());
	AlienActivities.AddItem(CreateCOINResearchTemplate());
	AlienActivities.AddItem(CreateCOINOpsTemplate());
	AlienActivities.AddItem(CreateBuildResearchFacilityTemplate());
	AlienActivities.AddItem(CreateRegionalAvatarResearchTemplate());

	AlienActivities.AddItem(CreateScheduledOffworldReinforcementsTemplate());
	AlienActivities.AddItem(CreateEmergencyOffworldReinforcementsTemplate());
	AlienActivities.AddItem(CreateSuperEmergencyOffworldReinforcementsTemplate());
	AlienActivities.AddItem(CreateRepressionTemplate());
	AlienActivities.AddItem(CreateInvasionTemplate());
	AlienActivities.AddItem(CreatePropagandaTemplate());
	AlienActivities.AddItem(CreateProtectResearchTemplate());
	AlienActivities.AddItem(CreateProtectDataTemplate());
	AlienActivities.AddItem(CreateTroopManeuversTemplate());
	AlienActivities.AddItem(CreateHighValuePrisonerTemplate());
	AlienActivities.AddItem(CreatePoliticalPrisonersTemplate());
	AlienActivities.AddItem(CreateIntelRaidTemplate());
	AlienActivities.AddItem(CreateSupplyConvoyTemplate());
	AlienActivities.AddItem(CreateRecruitRaidTemplate());
	AlienActivities.AddItem(CreateSnareTemplate());
	AlienActivities.AddItem(CreateFootholdTemplate());
    AlienActivities.AddItem(CreateRendezvousTemplate());
	AlienActivities.AddItem(CreateLogisticsTemplate());

    // Cheaty activity for mission test.
    AlienActivities.AddItem(CreateDebugMissionTemplate());

	//New Big Supply Extraction activity test:
	AlienActivities.AddItem(CreateBigSupplyExtractionTemplate());
	AlienActivities.AddItem(CreateCovertOpsTroopManeuversTemplate());

	return AlienActivities;
}

//#############################################################################################
//----------------   PROTECT REGION EARLY ACTIVITY   ------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateProtectRegionEarlyTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_LiberationStage LiberationStageCondition;
	local X2LWActivityCondition_Month MonthRestriction;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.ProtectRegionEarlyName);
	Template.ActivityCategory = 'LiberationSequence';

	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.AnyAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.LiberationCondition);

	LiberationStageCondition = new class 'X2LWActivityCondition_LiberationStage';
	LiberationStageCondition.NoStagesComplete = true;
	LiberationStageCondition.Stage1Complete = false;
	LiberationStageCondition.Stage2Complete = false;
	Template.ActivityCreation.Conditions.AddItem(LiberationStageCondition);

	MonthRestriction = new class'X2LWActivityCondition_Month';
	MonthRestriction.UseLiberateDifficultyTable = true;
	Template.ActivityCreation.Conditions.AddItem(MonthRestriction);

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	Template.OnMissionSuccessFn = TypicalAdvanceActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = none;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = ProtectRegionMissionRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnLiberateStage1Complete;

	return Template;
}

static function OnLiberateStage1Complete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion PrimaryRegionState;
	local XComGameState_WorldRegion_LWStrategyAI PrimaryRegionalAI;

	if(!bAlienSuccess)
	{
		PrimaryRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if(PrimaryRegionState == none)
			PrimaryRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

		if(PrimaryRegionState == none)
		{
			`REDSCREEN("OnProtectRegionActivityComplete -- no valid primary region");
			return;
		}

		PrimaryRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(PrimaryRegionState, NewGameState, true);
		PrimaryRegionalAI.LiberateStage1Complete = true;

		`XEVENTMGR.TriggerEvent('LiberateStage1Complete', , , NewGameState); // this is needed to advance objective LW_T2_M0_S2
	}
}

//#############################################################################################
//----------------   PROTECT REGION MID ACTIVITY   --------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateProtectRegionMidTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_LiberationStage LiberationStageCondition;
	local X2LWActivityCondition_Month MonthRestriction;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.ProtectRegionMidName);
	Template.ActivityCategory = 'LiberationSequence';

	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.AnyAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.LiberationCondition);

	LiberationStageCondition = new class 'X2LWActivityCondition_LiberationStage';
	LiberationStageCondition.NoStagesComplete = false;
	LiberationStageCondition.Stage1Complete = true;
	LiberationStageCondition.Stage2Complete = false;
	Template.ActivityCreation.Conditions.AddItem(LiberationStageCondition);

	MonthRestriction = new class'X2LWActivityCondition_Month';
	MonthRestriction.UseLiberateDifficultyTable = true;
	Template.ActivityCreation.Conditions.AddItem(MonthRestriction);

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	Template.OnMissionSuccessFn = TypicalAdvanceActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = none;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = ProtectRegionMissionRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnLiberateStage2Complete;

	return Template;
}

static function OnLiberateStage2Complete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion PrimaryRegionState;
	local XComGameState_WorldRegion_LWStrategyAI PrimaryRegionalAI;

	if(!bAlienSuccess)
	{
		PrimaryRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if(PrimaryRegionState == none)
			PrimaryRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

		if(PrimaryRegionState == none)
		{
			`REDSCREEN("OnProtectRegionActivityComplete -- no valid primary region");
			return;
		}

		PrimaryRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(PrimaryRegionState, NewGameState, true);
		PrimaryRegionalAI.LiberateStage2Complete = true;
		`LWTRACE("ProtectRegionMid Complete");
		`LWTRACE("PrimaryRegionalAI.LiberateStage1Complete = " $ PrimaryRegionalAI.LiberateStage1Complete);
		`LWTRACE("PrimaryRegionalAI.LiberateStage2Complete = " $ PrimaryRegionalAI.LiberateStage2Complete);

		`XEVENTMGR.TriggerEvent('LiberateStage2Complete', , , NewGameState); // this is needed to advance objective LW_T2_M0_S3
	}
}


//#############################################################################################
//----------------   PROTECT REGION ACTIVITY   ------------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateProtectRegionTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_LiberationStage LiberationStageCondition;
	local X2LWActivityCondition_Month MonthRestriction;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.ProtectRegionName);
	Template.ActivityCategory = 'LiberationSequence';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.AnyAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.LiberationCondition);

	LiberationStageCondition = new class 'X2LWActivityCondition_LiberationStage';
	LiberationStageCondition.NoStagesComplete = false;
	LiberationStageCondition.Stage1Complete = true;
	LiberationStageCondition.Stage2Complete = true;
	Template.ActivityCreation.Conditions.AddItem(LiberationStageCondition);

	MonthRestriction = new class'X2LWActivityCondition_Month';
	MonthRestriction.UseLiberateDifficultyTable = true;
	Template.ActivityCreation.Conditions.AddItem(MonthRestriction);

	//these define the requirements for discovering each activity, based on the RebelJob "Missions"
	//they can be overridden by template config values
	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	// required delegates
	Template.OnMissionSuccessFn = TypicalAdvanceActivityOnMissionSuccess;
	Template.OnMissionFailureFn = ProtectRegionMissionFailure;  //  Reset activity if one of the first PROTECTREGION_RESET_LEVEL missions is failed

	//optional delegates
	Template.OnActivityStartedFn = none;   // nothing special on startup

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel;
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel; // use regional AlertLevel

	Template.GetTimeUpdateFn = none;		// never updates
	Template.OnMissionExpireFn = none;  // nothing special, just remove mission and trigger failure
	Template.OnActivityUpdateFn = none;  // never updates
	Template.GetMissionRewardsFn = ProtectRegionMissionRewards;

	Template.CanBeCompletedFn = none;  // can't ever complete
	Template.OnActivityCompletedFn = OnProtectRegionActivityComplete;  // mark liberated, grant rewards, adjust Force/AlertLevel

	return Template;
}

//adds extra logic so that chain is reset if one of the first PROTECTREGION_RESET_LEVEL missions is failed
static function ProtectRegionMissionFailure(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	local StateObjectReference EmptyRef;

	if (ActivityState.CurrentMissionLevel < default.PROTECTREGION_RESET_LEVEL)
	{
		// failed an early mission, hide the activity and reset it back to beginning
		ActivityState.CurrentMissionLevel = 0; // reset mission level back to beginning
		ActivityState.bDiscovered = false;  // hide the activity so it has to be discovered again
		ActivityState.bNeedsUpdateDiscovery = false;
		ActivityState.MissionResourcePool = 0; // reset the mission resource pool so it isn't instantly discovered again
		ActivityState.bNeedsUpdateMissionFailure = false;
		ActivityState.CurrentMissionRef = EmptyRef;

		if(MissionState != none)
		{
			RecordResistanceActivity(false, ActivityState, MissionState, NewGameState);  //record failure
			MissionState.RemoveEntity(NewGameState);		// remove the mission
		}
	}
	else
	{
		//missions higher up in the chain just don't advance
		TypicalNoActionOnMissionFailure (ActivityState, MissionState, NewGameState);
	}
}

static function array<name> ProtectRegionMissionRewards (XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> RewardArray;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local XComGameState_WorldRegion PrimaryRegionState;
	local XComGameState_ResistanceFaction FactionState;
	local int k;

	PrimaryRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));


	Switch (MissionFamily)
	{
		case 'Recover_LW':
		case 'Hack_LW': RewardArray[0] = 'Reward_Intel'; break;
		case 'Extract_LW':
		case 'Rescue_LW': RewardArray[0] = RescueReward(false, false, NewGameState); break;
		case 'DestroyObject_LW':
			RewardArray[0] = 'Reward_Intel';
			break;
		case 'Neutralize_LW':
			RewardArray[0] = 'Reward_AvengerResComms'; // give if capture
			RewardArray[1] = 'Reward_Intel'; // given if success (kill or capture)
			break;
		case 'AssaultNetworkTower_LW':
			RewardArray[0] = 'Reward_Dummy_RegionalTower';
			k = 1;
			if (PrimaryRegionState.ResistanceLevel < eResLevel_Outpost && !PrimaryRegionState.IsStartingRegion())
			{
				RewardArray[k] = 'Reward_Radio_Relay';
				k += 1;
			}
			RewardArray[k] = 'Reward_Intel';
			break;
		case 'AssaultAlienBase_LW':
			RewardArray[0] = 'Reward_Dummy_Materiel';
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(PrimaryRegionState, NewGameState, true);
			if (RegionalAI.NumTimesLiberated == 0)
			{
				FactionState = class'Helpers_LW'.static.GetFactionFromRegion(PrimaryRegionState.GetReference());
				if (`SecondWaveEnabled('DisableChosen') &&
					FactionState.bMetXCom && FactionState.GetInfluence() < eFactionInfluence_MAX)
				{
					RewardArray.AddItem('Reward_FactionInfluence_LW');
				}

				if (CanAddPOI())
				{
					RewardArray.AddItem('Reward_POI_LW');
					RewardArray.AddItem('Reward_Dummy_POI'); // The first POI rewarded on any mission doesn't display in rewards, so this corrects for that
				}
			}
			break;
		default: break;
	}
	return RewardArray;
}

static function RemoveLiberatedDoom(int DoomToRemove, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AlienHQ = XComGameState_HeadquartersAlien(NewGameState.GetGameStateForObjectID(AlienHQ.ObjectID));
	if (AlienHQ == none)
	{
		AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		NewGameState.AddStateObject(AlienHQ);
	}

	AlienHQ.RemoveDoomFromFortress(NewGameState, DoomToRemove, class'UIStrategyMapItem_Region_LW'.default.m_strLiberatedRegion);
}


static function OnProtectRegionActivityComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion PrimaryRegionState, RegionState;
	local XComGameState_WorldRegion_LWStrategyAI PrimaryRegionalAI, RegionalAI;
	local XComGameState_WorldRegion_LWStrategyAI AdjacentRegionalAI;
	local int AlertLevelsKilled, RemainderAlertLevel, idx;
	local StateObjectReference LinkedRegionRef;
	local array<XComGameState_WorldRegion> ControlledLinkedRegions;
	local array<int> ControlledLinkedAlertLevelIncreases;
	local XComGameState_LWOutpost Outpost;
	local int k;

	if(!bAlienSuccess)
	{
		PrimaryRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if(PrimaryRegionState == none)
			PrimaryRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

		if(PrimaryRegionState == none)
		{
			`REDSCREEN("OnProtectRegionActivityComplete -- no valid primary region");
			return;
		}

		RemoveOrAdjustExistingActivitiesFromRegion(PrimaryRegionState, NewGameState);

		PrimaryRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(PrimaryRegionState, NewGameState, true);
		PrimaryRegionalAI.bLiberated = true;

		if (PrimaryRegionalAI.NumTimesLiberated == 0)
		{
			RemoveLiberatedDoom(default.ALIEN_BASE_DOOM_REMOVAL, NewGameState);
		}

		PrimaryRegionalAI.NumTimesLiberated += 1;
		PrimaryRegionalAI.LastLiberationTime = GetCurrentTime();
		`XEVENTMGR.TriggerEvent('RegionLiberatedFlagSet', ActivityState, ActivityState, NewGameState); // this is needed to advance objective LW_T2_M0_S3_CompleteActivity
		PrimaryRegionalAI.LocalVigilanceLevel = 1;

		AlertLevelsKilled = default.LIBERATION_ALERT_LEVELS_KILLED + `SYNC_RAND_STATIC (default.LIBERATION_ALERT_LEVELS_KILLED_RAND);
		RemainderAlertLevel = Max (0, PrimaryRegionalAI.LocalAlertLevel - AlertLevelsKilled);
		PrimaryRegionalAI.LocalAlertLevel = 1;

		//Removing prohibitions on jobs
		Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(PrimaryRegionState);
		Outpost = XComGameState_LWOutpost(NewGameState.ModifyStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
		for (k = 0; k < Outpost.ProhibitedJobs.Length; k++)
		{
			Outpost.ProhibitedJobs[k].DaysLeft = 0;
		}

		for (k = 0; k < Outpost.CurrentRetributions.Length; k++)
		{
			Outpost.CurrentRetributions[k].DaysLeft = 0;
		}		

		//distribute the RemainderAlertLevel amongst adjacent regions that haven't been liberated
		foreach PrimaryRegionState.LinkedRegions(LinkedRegionRef)
		{
			RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
			if(RegionState == none)
				RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
			if(RegionState != none && !RegionIsLiberated(RegionState, NewGameState))
			{
				ControlledLinkedRegions.AddItem(RegionState);
			}
		}

		if(ControlledLinkedRegions.Length > 0)
			AddVigilanceNearby (NewGameState, PrimaryRegionState, default.LIBERATE_ADJACENT_VIGILANCE_INCREASE_BASE, default.LIBERATE_ADJACENT_VIGILANCE_INCREASE_RAND);

		foreach `XCOMHistory.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
		{
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
			if (!RegionalAI.bLiberated)
			{
				RegionalAI.AddVigilance(NewGameState, 1);
			}
		}

		if(ControlledLinkedRegions.Length > 0 && RemainderAlertLevel > 0)
		{
			ControlledLinkedAlertLevelIncreases.Add(ControlledLinkedRegions.Length);

			//determine which adjacent regions are getting the AlertLevel increases
			for(idx = 0; idx < RemainderAlertLevel; idx++)
			{
				ControlledLinkedAlertLevelIncreases[`SYNC_RAND_STATIC(ControlledLinkedRegions.Length)] += 1;
			}

			//update the regional AI states with the AlertLevel increases
			for(idx = 0; idx < ControlledLinkedAlertLevelIncreases.Length; idx++)
			{
				if(ControlledLinkedAlertLevelIncreases[idx] > 0)
				{
					RegionState = ControlledLinkedRegions[idx];
					AdjacentRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
					AdjacentRegionalAI.LocalAlertLevel += ControlledLinkedAlertLevelIncreases[idx];
				}
			}
		}
	}
}

static function RemoveOrAdjustExistingActivitiesFromRegion(XComGameState_WorldRegion RegionState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_LWAlienActivity ActivityState, UpdatedActivity;
	local array<XComGameState_LWAlienActivity> ActivitiesToDelete, InfiltratedActivities;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_LWPersistentSquad SquadState;
	local XComGameState_MissionSite MissionState;

	History = `XCOMHISTORY;
	SquadMgr = `LWSQUADMGR;

	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if (ActivityState.GetMyTemplateName() == default.ProtectRegionName || ActivityState.PrimaryRegion.ObjectID != RegionState.ObjectID || ActivityState.GetMyTemplate().CanOccurInLiberatedRegion)
			continue;

		if (ActivityState.CurrentMissionRef.ObjectID == 0)
			ActivitiesToDelete.AddItem(ActivityState);
		else if (SquadMgr.GetSquadOnMission(ActivityState.CurrentMissionRef) == none)
			ActivitiesToDelete.AddItem(ActivityState);
		else
			InfiltratedActivities.AddItem(ActivityState);
	}

	foreach ActivitiesToDelete(ActivityState)
	{
		MissionState = XComGameState_MissionSite(NewGameState.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
		if (MissionState == none)
			MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));

		if (MissionState != none)
		{
			if (MissionState.POIToSpawn.ObjectID > 0)
			{
				class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
			}
			MissionState.RemoveEntity(NewGameState);
		}
		NewGameState.RemoveStateObject(ActivityState.ObjectID);
	}
	foreach InfiltratedActivities(ActivityState)
	{
		UpdatedActivity = XComGameState_LWAlienActivity(NewGameState.GetGameStateForObjectID(ActivityState.ObjectID));
		if (UpdatedActivity == none)
		{
			UpdatedActivity = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', ActivityState.ObjectID));
			NewGameState.AddStateObject(UpdatedActivity);
		}
		SquadState = SquadMgr.GetSquadOnMission(ActivityState.CurrentMissionRef);
		SquadState = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', SquadState.ObjectID));
		NewGameState.AddStateObject(SquadState);

		SquadState.CurrentInfiltration += default.INFILTRATION_BONUS_ON_LIBERATION[`STRATEGYDIFFICULTYSETTING] / 100.0;
		If (SquadState.CurrentInfiltration > 2.0)
			SquadState.CurrentInfiltration=2.0;

		SquadState.GetAlertnessModifierForCurrentInfiltration(NewGameState, true); // force an update on the alertness modifier

		UpdatedActivity.DateTimeActivityComplete = GetCurrentTime();

		MissionState = XComGameState_MissionSite(NewGameState.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
		if (MissionState == none)
		{
			MissionState = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', ActivityState.CurrentMissionRef.ObjectID));
			NewGameState.AddStateObject(MissionState);
		}
		MissionState.ExpirationDateTime = GetCurrentTime();
	}
}

//#############################################################################################
//----------------   COUNTERINSURGENCY ACTIVITY   ---------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateCounterinsurgencyTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown Cooldown;
	local X2LWActivityCondition_MinRebels RebelCondition1;
	local X2LWActivityCondition_MinWorkingRebels RebelCondition2;
	local X2LWActivityCondition_FullOutpostJobBuckets BucketFill;
	local X2LWActivityCondition_RetalMixer RetalMixer;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.CounterinsurgencyName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier
	Template.ActivityCategory = 'RetalOps';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_RetalMixer');

	RetalMixer = new class'X2LWActivityCondition_RetalMixer';
	RetalMixer.UseSpecificJob = false;
	Template.ActivityCreation.Conditions.AddItem(RetalMixer);

	// This makes sure there are enough warm bodies for the mission to be meaningful
	RebelCondition1 = new class 'X2LWActivityCondition_MinRebels';
	RebelCondition1.MinRebels = default.ATTEMPT_COUNTERINSURGENCY_MIN_REBELS;
	Template.ActivityCreation.Conditions.AddItem(RebelCondition1);

	// This lets you hide rebels to avoid the mission
	RebelCondition2 = new class 'X2LWActivityCondition_MinWorkingRebels';
	RebelCondition2.MinWorkingRebels = default.ATTEMPT_COUNTERINSURGENCY_MIN_WORKING_REBELS;
	Template.ActivityCreation.Conditions.AddItem(RebelCondition2);

	BucketFill = new class 'X2LWActivityCondition_FullOutpostJobBuckets';
	BucketFill.FullRetal = true;
	BucketFill.RequiredDays = default.COIN_BUCKET;
	Template.ActivityCreation.Conditions.AddItem(BucketFill);

	//these define the requirements for discovering each activity, based on the RebelJob "Missions"
	Template.DetectionCalc = new class'X2LWActivityDetectionCalc_Terror';

	//REgional Cooldown
	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.COIN_MIN_COOLDOWN_HOURS;
	Cooldown.RandCooldown_Hours = default.COIN_MAX_COOLDOWN_HOURS - default.COIN_MIN_COOLDOWN_HOURS;
	Template.ActivityCooldown = Cooldown;

	// required delegates
	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	//optional delegates
	Template.OnActivityStartedFn = EmptyRetalBucket;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel; // use regional AlertLevel

	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = GetCounterinsurgencyRewards;

	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnCounterInsurgencyComplete;

	return Template;
}

static function OnCounterInsurgencyComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
    local XComGameState_LWOutpost Outpost;
    local XComGameState_WorldRegion Region;
    local XComGameStateHistory History;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

    History = `XCOMHISTORY;

    Region = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if (Region == none)
	    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

    Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState, true);

	if (bAlienSuccess)
	{
		Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
		NewGameState.AddStateObject(Outpost);
		Outpost.WipeOutOutpost(NewGameState);
		RegionalAI.AddVigilance (NewGameState, -default.VIGILANCE_DECREASE_ON_ADVENT_RETAL_WIN);
	}
	else
	{
		// This counteracts base vigilance increase on an xcom win to prevent vigilance spiralling out of control
		RegionalAI.AddVigilance (NewGameState, default.VIGILANCE_CHANGE_ON_XCOM_RETAL_WIN);
	}
}

static function array<name> GetCounterinsurgencyRewards (XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> RewardArray;

	if (MissionFamily == 'DestroyObject_LW')
	{
		RewardArray[0] = 'Reward_Intel';
	}
	else
	{
		RewardArray[0] = 'Reward_Dummy_Unhindered';
	}
	return RewardArray;
}

//#############################################################################################
//------------------------------   REINFORCE   ------------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateReinforceTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_Month MonthRestriction;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.ReinforceName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation_Reinforce';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.AnyAlienRegion);

	MonthRestriction = new class'X2LWActivityCondition_Month';
	MonthRestriction.FirstMonthPossible = 1;
	Template.ActivityCreation.Conditions.AddItem(MonthRestriction);

	//this defines the requirements for discovering each activity
	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	// required delegates
	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	//optional delegates
	Template.OnActivityStartedFn = none;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetReinforceAlertLevel; // Custom increased AlertLevel because of reinforcements

	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = GetReinforceRewards;
	Template.OnActivityUpdateFn = none;

	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnReinforceActivityComplete; // transfer of regional alert/force levels

	return Template;
}

// uses the higher alert level
static function int GetReinforceAlertLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local XComGameState_WorldRegion OriginRegionState, DestinationRegionState;
	local XComGameState_WorldRegion_LWStrategyAI OriginAIState, DestinationAIState;

	OriginRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));

	if(OriginRegionState == none)
		OriginRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));

	DestinationRegionState =  XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	if(DestinationRegionState == none)
		DestinationRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));


	OriginAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(OriginRegionState, NewGameState);
	DestinationAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(DestinationRegionState, NewGameState);

	if(default.ACTIVITY_LOGGING_ENABLED)
	{
		`LWTRACE("Activity " $ ActivityState.GetMyTemplateName $ ": Mission Alert Level =" $ Max (OriginAIState.LocalAlertLevel, DestinationAIState.LocalAlertLevel) + ActivityState.GetMyTemplate().AlertLevelModifier );
	}
	return Max (OriginAIState.LocalAlertLevel, DestinationAIState.LocalAlertLevel) + ActivityState.GetMyTemplate().AlertLevelModifier;
}


static function array<name> GetReinforceRewards(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> Rewards;

	Rewards[0] = 'Reward_Dummy_Materiel';
	return Rewards;
}

static function OnReinforceActivityComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion DestRegionState, OrigRegionState;
	local XComGameState_WorldRegion_LWStrategyAI DestRegionalAI, OrigRegionalAI;

	History = `XCOMHISTORY;
	DestRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(DestRegionState == none)
		DestRegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	DestRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(DestRegionState, NewGameState, true);

	OrigRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));
	if(OrigRegionState == none)
		OrigRegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));

	OrigRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(OrigRegionState, NewGameState, true);

	if(bAlienSuccess)
	{
		`LWTRACE("ReinforceRegion : Alien Success, moving force/alert levels");

		// reinforcements arrive, boost primary (destination) alert and force levels
		// also make sure the origin didn't lose somebody in the meantime
		if (OrigRegionalAI.LocalAlertLevel > 1)
		{
			DestRegionalAI.LocalAlertLevel += 1;
			OrigRegionalAI.LocalAlertLevel -= 1;
		}
		if(DestRegionalAI.LocalVigilanceLevel - DestRegionalAI.LocalAlertLevel > default.REINFORCE_DIFFERENCE_REQ_FOR_FORCELEVEL_TRANSFER)
		{
			if(OrigRegionalAI.LocalForceLevel > 2)
			{
				DestRegionalAI.LocalForceLevel += 1;
				OrigRegionalAI.LocalForceLevel -= 1;
			}
		}
	}
	else
	{
		`LWTRACE("ReinforceRegion : XCOM Success, reducing alert level, increasing vigilance");
		//reinforcements destroyed, increase orig vigilance and it loses the AlertLevel
		OrigRegionalAI.LocalAlertLevel = Max(OrigRegionalAI.LocalAlertLevel - 1, 1);
		OrigRegionalAI.AddVigilance (NewGameState, default.REINFORCEMENTS_STOPPED_ORIGIN_VIGILANCE_INCREASE);
		AddVigilanceNearby (NewGameState, DestRegionState, default.REINFORCEMENTS_STOPPED_ADJACENT_VIGILANCE_BASE, default.REINFORCEMENTS_STOPPED_ADJACENT_VIGILANCE_RAND);
	}
}

//#############################################################################################
//------------------------------   COIN RESEARCH   ------------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateCOINResearchTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_ResearchFacility ResearchFacility;
	local X2LWActivityCondition_RestrictedActivity RestrictedActivity;
	local X2LWActivityCooldown_Global Cooldown;
	local X2LWActivityCondition_Month MonthRestriction;
	local X2LWActivityCondition_RegionStatus RegionStatus;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.COINResearchName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.TwoActivitiesInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');

	RegionStatus = new class'X2LWActivityCondition_RegionStatus';
	RegionStatus.bAllowInContactedOrAdjacentToContacted=true;
	RegionStatus.bAllowInContacted=true;
	RegionStatus.bAllowInUncontacted=true;
	RegionStatus.bAllowInLiberated=false;
	RegionStatus.bAllowInAlien=true;
	Template.ActivityCreation.Conditions.AddItem(RegionStatus);

	ResearchFacility = new class'X2LWActivityCondition_ResearchFacility';
 	ResearchFacility.bAllowedAlienResearchFacilityInRegion = false;
	Template.ActivityCreation.Conditions.AddItem(ResearchFacility);

	RestrictedActivity = new class'X2LWActivityCondition_RestrictedActivity';
	RestrictedActivity.ActivityNames.AddItem(default.BuildResearchFacilityName);
	RestrictedActivity.ActivityNames.AddItem(default.COINOpsName);
	RestrictedActivity.MaxRestricted = 1;
	Template.ActivityCreation.Conditions.AddItem(RestrictedActivity);

	//these define the requirements for discovering each activity, based on the RebelJob "Missions"
	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//Cooldown
	Cooldown = new class'X2LWActivityCooldown_Global';
	Cooldown.Cooldown_Hours = default.COIN_RESEARCH_GLOBAL_COOLDOWN;
	Template.ActivityCooldown = Cooldown;

	MonthRestriction = new class'X2LWActivityCondition_Month';
	MonthRestriction.UseDarkEventDifficultyTable = true;
	Template.ActivityCreation.Conditions.AddItem(MonthRestriction);

	// required delegates
	Template.OnMissionSuccessFn = COINDarkEventSuccess; //TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = COINDarkEventFailure; // TypicalAdvanceActivityOnMissionFailure;

	//optional delegates
	Template.OnActivityStartedFn = ChooseDarkEventForCoinResearch;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel; // configurable offset to mission difficulty

	Template.GetTimeUpdateFn = none; //Must be none for activities that spawn dark events
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = COINResearchRewards;
	Template.OnActivityUpdateFn = none;
	Template.GetMissionDarkEventFn = GetTypicalMissionDarkEvent;  // Dark Event attached to last mission in chain

	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnCOINResearchComplete;

	return Template;
}

static function COINDarkEventSuccess(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{

	if(MissionState.HasDarkEvent())
	{
		class'XComGameState_HeadquartersResistance'.static.AddGlobalEffectString(NewGameState, MissionState.GetDarkEvent().GetPostMissionText(true), false);
	}
	TypicalEndActivityOnMissionSuccess(ActivityState, MissionState, NewGameState);
}

static function COINDarkEventFailure(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	if(MissionState.HasDarkEvent())
	{
		class'XComGameState_HeadquartersResistance'.static.AddGlobalEffectString(NewGameState, MissionState.GetDarkEvent().GetPostMissionText(false), false);
	}
	TypicalAdvanceActivityOnMissionFailure(ActivityState, MissionState, NewGameState);
}

//select the DarkEvent for the associated mission
static function  StateObjectReference GetMissionDarkEvent(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	if(default.ACTIVITY_LOGGING_ENABLED)
	{
		`LWTRACE("COIN Research : Retrieving DarkEvent ");
	}
	return ActivityState.DarkEvent;
}

//select a dark event for the activity and add it to the chosen list in AlienHQ -- this replaces the existing deck system
static function ChooseDarkEventForCoinResearch(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	ChooseDarkEvent(true, ActivityState, NewGameState);
}

static function ChooseDarkEvent(bool bTactical, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_DarkEvent> DarkEventDeck;
	local XComGameState_DarkEvent DarkEventState;
	local int idx;

	AlienHQ = GetAndAddAlienHQ(NewGameState);
	DarkEventDeck = AlienHQ.BuildDarkEventDeck();
	DarkEventState = AlienHQ.DrawFromDarkEventDeck(DarkEventDeck);

	while(DarkEventState.GetMyTemplate().bTactical != bTactical && idx++ < 30)
	{
		DarkEventState = AlienHQ.DrawFromDarkEventDeck(DarkEventDeck);
	}
	if(DarkEventState != none)
	{
		DarkEventState = XComGameState_DarkEvent(NewGameState.CreateStateObject(class'XComGameState_DarkEvent', DarkEventState.ObjectID));
		NewGameState.AddStateObject(DarkEventState);
		DarkEventState.TimesPlayed++;
		DarkEventState.Weight += DarkEventState.GetMyTemplate().WeightDeltaPerPlay;
		DarkEventState.Weight = Clamp(DarkEventState.Weight, DarkEventState.GetMyTemplate().MinWeight, DarkEventState.GetMyTemplate().MaxWeight);

		// Dark Events initiated through activities will not fire on their own independently from the activity, rather it completes
		// when the activity does unless stopped. So do not initiate the timer for this DE and instead set the end date to some time
		// in the future. The InstantiateActivityTimeline will set the expiry time based on the configured timer settings for this DE,
		// so as long as the end time in the DE state itself is beyond this time it won't accidentally trigger before the activity expires.
		DarkEventState.StartDateTime = `STRATEGYRULES.GameTime;
		DarkEventState.EndDateTime = DarkEventState.StartDateTime;
		// Arbitrarily pick a year in the future - this is longer than any DE-triggering activity can run.
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(DarkEventState.EndDateTime, 24 * 28 * 12);
		DarkEventState.TimeRemaining = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(DarkEventState.EndDateTime,
			DarkEventState.StartDateTime);
		AlienHQ.ChosenDarkEvents.AddItem(DarkEventState.GetReference());

		if(!bTactical)
		{
			DarkEventState.bSecretEvent = true;
			DarkEventState.SetRevealCost();
		}
		else
		{
			DarkEventState.bSecretEvent = false;
		}
		if(default.ACTIVITY_LOGGING_ENABLED)
		{
			`LWTRACE("COIN Research : Choosing DarkEvent " $ DarkEventState.GetMyTemplateName());
		}
		ActivityState.DarkEvent = DarkEventState.GetReference();
	}
	else
	{
		`REDSCREEN("Unable to find valid Dark Event for Activity");
	}
}

static function OnCOINResearchComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_DarkEvent DarkEventState;

	if(bAlienSuccess)
	{
		if(default.ACTIVITY_LOGGING_ENABLED)
		{
			`LWTRACE("COINResearchComplete : Alien Success, marking for immediate DarkEvent Activation");
		}
		// research complete, mark for immediate DarkEvent activation
		DarkEventState = XComGameState_DarkEvent(NewGameState.CreateStateObject(class'XComGameState_DarkEvent', ActivityState.DarkEvent.ObjectID));
		NewGameState.AddStateObject(DarkEventState);
		DarkEventState.EndDateTime = `STRATEGYRULES.GameTime;
		class'XComGameState_HeadquartersResistance'.static.AddGlobalEffectString(NewGameState, DarkEventState.GetPostMissionText(false), true);

	}
	else
	{
		if(default.ACTIVITY_LOGGING_ENABLED)
		{
			`LWTRACE("COINResearchComplete : XCOM Success, cancelling DarkEvent");
		}
		//research halted, cancel dark event
		CancelActivityDarkEvent(ActivityState, NewGameState);
	}
}

static function CancelActivityDarkEvent(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local StateObjectReference DarkEventRef;
	local XComGameState_DarkEvent DarkEventState;

	AlienHQ = GetAndAddAlienHQ(NewGameState);
	//validate the dark event trying to be removed
	// 1) Make sure the reference is valid
	DarkEventRef = ActivityState.DarkEvent;
	if (DarkEventRef.ObjectID <= 0)
	{
		`REDSCREEN ("Attempting to cancel dark event, but activity has invalid dark event reference");
		`LWTRACE("------------------------------------------");
		`LWTRACE("Attempted to cancel dark event for activity " $ string(ActivityState.GetMyTemplateName()) $ ", but the activity's dark event reference has ObjectID of 0.");
		`LWTRACE("------------------------------------------");
		return;
	}
	// 2) Make sure the reference is on the AlienHQ ChosenDarkEvents list
	if (AlienHQ.ChosenDarkEvents.Find('ObjectID', DarkEventRef.ObjectID) == -1)
	{
		`REDSCREEN ("Attempting to cancel dark event, but dark event is not on AlienHQ.ChosenDarkEvents list");
		`LWTRACE("------------------------------------------");
		`LWTRACE("Attempted to cancel dark event for activity " $ string(ActivityState.GetMyTemplateName()) $ ", but the Alien HQ does not have the DE on the ChosenDarkEvents list.");
		`LWTRACE("------------------------------------------");
		return;
	}
	// 3) Check the referenced dark event has a retrievable state
	DarkEventState =  XComGameState_DarkEvent(`XCOMHISTORY.GetGameStateForObjectID(DarkEventRef.ObjectID));
	if (DarkEventState == none)
	{
		`REDSCREEN ("Attempting to cancel dark event, but dark event has no valid gamestate");
		`LWTRACE("------------------------------------------");
		`LWTRACE("Attempted to cancel dark event for activity " $ string(ActivityState.GetMyTemplateName()) $ ", with ObjectID=" $ string(DarkEventRef.ObjectID) $ " but there is no such DE in the history.");
		`LWTRACE("------------------------------------------");
		return;
	}

	//remove the dark event from the AlienHQ ChosenDarkEvent list
	AlienHQ.CancelDarkEvent(NewGameState, DarkEventRef);
}

static function array<name> COINResearchRewards(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> Rewards;

	Rewards[0] = 'Reward_Intel'; // for Neutralize, this will be granted only if captured
	if (MissionFamily == 'Rescue_LW')
	{
		Rewards[1] = RescueReward(false, false, NewGameState);
	}
	else
	{
		if (CanAddPOI())
		{
			Rewards[1] = 'Reward_POI_LW'; // for Neutralize, this will always be granted
			Rewards[2] = 'Reward_Dummy_POI';
		}
		else
		{
			Rewards[1] = 'Reward_Supplies';
		}
	}

	return Rewards;
}

//#############################################################################################
//------------------------------   COIN OPS   ------------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateCOINOpsTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_ResearchFacility ResearchFacility;
	local X2LWActivityCondition_RestrictedActivity RestrictedActivity;
	local X2LWActivityCooldown_Global Cooldown;
	local X2LWActivityCondition_Month MonthRestriction;
	local X2LWActivityCondition_AlertVigilance AlertVigilanceCondition;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.COINOpsName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);

	//Add different setup condition for Alert/Vigilance

	AlertVigilanceCondition = new class'X2LWActivityCondition_AlertVigilance';
	AlertVigilanceCondition.MinAlert=default.COINOPS_MIN_ALERT;
	AlertVigilanceCondition.MinVigilance=default.COINOPS_MIN_VIGILANCE;
	Template.ActivityCreation.Conditions.AddItem(AlertVigilanceCondition);

	ResearchFacility = new class'X2LWActivityCondition_ResearchFacility';
 	ResearchFacility.bAllowedAlienResearchFacilityInRegion = false;
	Template.ActivityCreation.Conditions.AddItem(ResearchFacility);

	RestrictedActivity = new class'X2LWActivityCondition_RestrictedActivity';
	RestrictedActivity.ActivityNames.AddItem(default.BuildResearchFacilityName);
	RestrictedActivity.ActivityNames.AddItem(default.COINResearchName);
	RestrictedActivity.MaxRestricted = 1;
	Template.ActivityCreation.Conditions.AddItem(RestrictedActivity);

	MonthRestriction = new class'X2LWActivityCondition_Month';
	MonthRestriction.UseDarkEventDifficultyTable = true;
	Template.ActivityCreation.Conditions.AddItem(MonthRestriction);

	//these define the requirements for discovering each activity, based on the RebelJob "Missions"
	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//Cooldown
	Cooldown = new class'X2LWActivityCooldown_Global';
	Cooldown.Cooldown_Hours = default.COIN_OPS_GLOBAL_COOLDOWN;
	Template.ActivityCooldown = Cooldown;

	// required delegates
	Template.OnMissionSuccessFn = COINDarkEventSuccess; //TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = COINDarkEventFailure; // TypicalAdvanceActivityOnMissionFailure;

	//optional delegates
	Template.OnActivityStartedFn = ChooseDarkEventForCoinOps;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel; // configurable offset to mission difficulty

	Template.GetTimeUpdateFn = none;  //Must be none for activities that spawn dark events
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = COINOpsRewards;
	Template.OnActivityUpdateFn = none;
	Template.GetMissionDarkEventFn = GetTypicalMissionDarkEvent;  // Dark Event attached to last mission in chain

	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnCOINOpsComplete;

	return Template;
}

//select a dark event for the activity and add it to the chosen list in AlienHQ -- this replaces the existing deck system
static function ChooseDarkEventForCoinOps(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	ChooseDarkEvent(false, ActivityState, NewGameState);
}

static function OnCOINOpsComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_DarkEvent DarkEventState;

	if(bAlienSuccess)
	{
		if(default.ACTIVITY_LOGGING_ENABLED)
		{
			`LWTRACE("COINOpsComplete : Alien Success, marking for immediate DarkEvent Activation");
		}
		// research complete, mark for immediate DarkEvent activation
		DarkEventState = XComGameState_DarkEvent(NewGameState.CreateStateObject(class'XComGameState_DarkEvent', ActivityState.DarkEvent.ObjectID));
		NewGameState.AddStateObject(DarkEventState);
		DarkEventState.EndDateTime = `STRATEGYRULES.GameTime;
		class'XComGameState_HeadquartersResistance'.static.AddGlobalEffectString(NewGameState, DarkEventState.GetPostMissionText(false), true);

	}
	else
	{
		if(default.ACTIVITY_LOGGING_ENABLED)
		{
			`LWTRACE("COINOpsComplete : XCOM Success, cancelling DarkEvent");
		}
		//research halted, cancel dark event
		CancelActivityDarkEvent(ActivityState, NewGameState);
	}
}

static function array<name> COINOpsRewards(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> Rewards;

	Rewards[0] = 'Reward_Intel';
	return Rewards;
}


//#############################################################################################
//------------------------------   BUILD RESEARCH FACILITY ------------------------------------
//#############################################################################################

static function X2DataTemplate CreateBuildResearchFacilityTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_ResearchFacility ResearchFacility;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.BuildResearchFacilityName);

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation_FurthestAway';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.AlertAtLeastEqualToVigilance);
	Template.ActivityCreation.Conditions.AddItem(default.AnyAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');

	//these define the requirements for discovering each activity, based on the RebelJob "Missions"
	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	ResearchFacility = new class'X2LWActivityCondition_ResearchFacility';
 	ResearchFacility.bAllowedAlienResearchFacilityInRegion = false;
	ResearchFacility.bBuildingResearchFacility = true;
	Template.ActivityCreation.Conditions.AddItem(ResearchFacility);

	// required delegates
	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	//optional delegates
	Template.OnActivityStartedFn = none;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel; // configurable offset to mission difficulty

	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = GetBuildResearchFacilityRewards;
	//Template.GetNextMissionDurationSecondsFn = GetTypicalMissionDuration;
	Template.OnActivityUpdateFn = none;

	Template.CanBeCompletedFn = none;  // can always be completed
	//Template.GetTimeCompletedFn = TypicalActivityTimeCompleted;
	Template.OnActivityCompletedFn = OnBuildResearchFacilityComplete;

	return Template;
}

static function array<name> GetBuildResearchFacilityRewards(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> Rewards;

	Rewards[0] = 'Reward_Dummy_Materiel';
	Rewards[1] = 'Reward_Intel';
	return Rewards;
}

static function OnBuildResearchFacilityComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	History = `XCOMHISTORY;
	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);

	if(bAlienSuccess)
	{
		`LWTRACE("BuildResearchFacilityComplete : Alien Success, marking region for research base creation");
		// construction complete, mark for follow-up activity
		RegionalAI.bHasResearchFacility = true;
	}
	else
	{
		`LWTRACE("BuildResearchFacilityComplete : XCOM Success, increasing vigilance");
		//activity halted, boost vigilance by an extra point over the typical +1
		RegionalAI.AddVigilance (NewGameState, 1);
	}
}

//#############################################################################################
//------------------------------   REGIONAL AVATAR RESEARCH -----------------------------------
//#############################################################################################

static function X2DataTemplate CreateRegionalAvatarResearchTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_ResearchFacility ResearchFacility;
	local X2LWActivityDetectionCalc Detection;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.RegionalAvatarResearchName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);

	ResearchFacility = new class'X2LWActivityCondition_ResearchFacility';
 	ResearchFacility.bRequiresAlienResearchFacilityInRegion = true;
	Template.ActivityCreation.Conditions.AddItem(ResearchFacility);

	Template.CanOccurInLiberatedRegion = true;

	Detection = new class'X2LWActivityDetectionCalc';
	Detection.SetNeverDetected(true);		// ONLY DETECTED IF A LEAD REWARD IS OBTAINED. CANNOT BE DETECTED BY INTEL PERSONNEL.
	//Detection.SetAlwaysDetected(true);		// FOR TESTING ONLY !!
	Template.DetectionCalc =  Detection;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalNoActionOnMissionFailure; // facility keeps on going (1.3 fix)
	// update timer used to spawn doom
	Template.GetTimeUpdateFn = RegionalAvatarResearchTimer;
	Template.UpdateModifierHoursFn = RegionalAvatarResearchTimeModifier;
	Template.OnActivityUpdateFn = OnRegionalAvatarResearchUpdate;
	Template.OnMissionCreatedFn = OnAlienResearchMissionCreated;
	Template.OnActivityCompletedFn = DisableAlienResearch;

	return Template;
}

//disable the regional AI research facility flag when activity completes
static function DisableAlienResearch(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	History = `XCOMHISTORY;
	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
	RegionalAI.bHasResearchFacility = false;

}

// detection code -- called when Tech_AlienFacilityLead completes
static function FacilityLeadCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameStateHistory History;
	local XComGameState_LWAlienActivity ActivityState, UpdatedActivity;
	local array<XComGameState_LWAlienActivity> PossibleActivities;
	local XComGameState_MissionSite MissionState;
	local int k;
	History = `XCOMHISTORY;

	//find the specified activity in the specified region
	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if(ActivityState.GetMyTemplateName() == default.RegionalAvatarResearchName)
		{
			if (!ActivityState.bDiscovered) // not yet detected
			{
				PossibleActivities.AddItem(ActivityState);
				if(ActivityState.CurrentMissionRef.ObjectID > 0) // has a mission
				{
					MissionState = XComGameState_MissionSite(NewGameState.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
					if (MissionState == none)
					{
						MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
						// add a chance per doom
						//`LWTRACE ("MissionState.Doom" @ string (MissionState.Doom));
						for (k = 0; k < MissionState.Doom; k++)
						{
							PossibleActivities.AddItem(ActivityState);
						}
					}
				}
			}
		}
	}
	if (PossibleActivities.Length == 0)
	{
		`REDSCREEN("No valid activities of type: " $ default.RegionalAvatarResearchName);
		return;
	}
	ActivityState = PossibleActivities[`SYNC_RAND_STATIC(PossibleActivities.Length)];

	UpdatedActivity = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', ActivityState.ObjectID));
	NewGameState.AddStateObject(UpdatedActivity);

	if (ActivityState.CurrentMissionRef.ObjectID > 0)
	{
		MissionState = XComGameState_MissionSite(NewGameState.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
		if (MissionState == none)
		{
			MissionState = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', ActivityState.CurrentMissionRef.ObjectID));
			NewGameState.AddStateObject(MissionState);
		}
		MissionState.Available = true;
		UpdatedActivity.bDiscovered = true;
		UpdatedActivity.bNeedsAppearedPopup = true;
		UpdatedActivity.bNeedsUpdateDiscovery = false;
	}
	else // this shouldn't ever happen, but is included for error handling
	{
		//check to see if we are back in geoscape yet
		if (`HQGAME == none || `HQPRES == none || `HQPRES.StrategyMap2D == none)
		{
			//not there, so mark the activity to be detected the next time we are back in geoscape
			UpdatedActivity.bNeedsUpdateDiscovery = true;
		}
		else
		{
			if(UpdatedActivity.SpawnMission(NewGameState))
			{
				UpdatedActivity.bDiscovered = true;
				UpdatedActivity.bNeedsAppearedPopup = true;
			}
		}
	}

	TechState.RegionRef = ActivityState.PrimaryRegion;
}

//transfer any activity doom to the mission
static function OnAlienResearchMissionCreated(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	if(MissionState.GeneratedMission.Mission.MissionName == 'SabotageAlienFacility_LW')
	{
		MissionState.Doom = ActivityState.Doom;
		ActivityState.Doom = 0;
	}
}

//Setting up timer to add doom / transfer doom to AlienHQ
static function TDateTime RegionalAvatarResearchTimer(XComGameState_LWAlienActivity ActivityState, optional XComGameState NewGameState)
{
	local TDateTime UpdateTime;
	local int HoursToAdd;
    local XComGameState_HeadquartersAlien AlienHQ;

	class'X2StrategyGameRulesetDataStructures'.static.CopyDateTime(class'XComGameState_GeoscapeEntity'.static.GetCurrentTime(), UpdateTime);

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	if (AlienHQ.GetCurrentDoom(true) >= AlienHQ.GetMaxDoom()) // player is in the lose state
	{
		// add one day, check again then in case player has dropped doom counter down
		HoursToAdd = 24;
	}
	else
	{
		//use configured times, based on difficulty;
		HoursToAdd = default.REGIONAL_AVATAR_RESEARCH_TIME_MIN[`STRATEGYDIFFICULTYSETTING];
		HoursToAdd += `SYNC_RAND_STATIC(default.REGIONAL_AVATAR_RESEARCH_TIME_MAX[`STRATEGYDIFFICULTYSETTING] - default.REGIONAL_AVATAR_RESEARCH_TIME_MIN[`STRATEGYDIFFICULTYSETTING] + 1);
	}
	class'X2StrategyGameRulesetDataStructures'.static.AddHours(UpdateTime, HoursToAdd);

	return UpdateTime;
}

// compute modifier to all regional AVATAR research doom ticks, based on current vigiliance, etc
static function int RegionalAvatarResearchTimeModifier(XComGameState_LWAlienActivity ActivityState, optional XComGameState NewGameState)
{
	return `LWACTIVITYMGR.GetDoomUpdateModifierHours(ActivityState, NewGameState);
}

//handles updating of the regional research project, adding doom and possibly transfer doom to AlienHQ
static function OnRegionalAvatarResearchUpdate(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local float TransferChance;
	local int idx, FacilityDoom;
	local bool bTransferDoom;
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local int AlertVigilanceDiff;
	local bool AliensHaveOneRegion;
	local XComGameState_LWAlienActivity ActivityLooper;

	AlertVigilanceDiff = `LWACTIVITYMGR.GetGlobalAlert() - `LWACTIVITYMGR.GetGlobalVigilance();

	// Disabled by config, superceded by other mechanics
	if (AlertVigilanceDiff < -default.SUPER_EMERGENCY_GLOBAL_VIG)
	{
		if(`SYNC_FRAND_STATIC() >= default.CHANCE_TO_GAIN_DOOM_IN_SUPER_EMERGENCY[`STRATEGYDIFFICULTYSETTING] / 100.0)
			return;
	}

	// If aliens have lost most of their territory and are trying to land foothold UFOs, research stops
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityLooper)
	{
		if(ActivityLooper.GetMyTemplateName() == default.FootholdName)
			return;
	}

	// ALso halt if aliens have no regions
	AliensHaveOneRegion = false;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_WorldRegion', Region)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
		if (!RegionalAI.bLiberated)
		{
			AliensHaveOneRegion = true;
		}
	}

	if (!AliensHaveOneRegion)
		return;

	if(ActivityState.CurrentMissionRef.ObjectID > 0) // has a mission
	{
		MissionState = XComGameState_MissionSite(NewGameState.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
		if (MissionState == none)
		{
			MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
		}
		FacilityDoom = MissionState.Doom;
	}

	FacilityDoom += ActivityState.Doom;

	TransferChance = default.CHANCE_PER_LOCAL_DOOM_TRANSFER_TO_ALIEN_HQ[`STRATEGYDIFFICULTYSETTING] / 100.0;
	for (idx = 0; idx < FacilityDoom; idx++)
	{
		if (`SYNC_FRAND_STATIC() < TransferChance)
		{
			bTransferDoom = true;
			break;
		}
	}

	if(bTransferDoom)
	{
		class'XComGameState_LWAlienActivityManager'.static.AddDoomToFortress(NewGameState, 1);
	}
	else // add a point of doom to the local facility
	{
		class'XComGameState_LWAlienActivityManager'.static.AddDoomToFacility(ActivityState, NewGameState, 1);
	}
	//ActivityState.bNeedsPause = true;

}

//#############################################################################################
//----------------------   SCHEDULED OFFWORLD REINFORCEMENTS-----------------------------------
//#############################################################################################

// increases forcelevel in all regions by 1

static function X2DataTemplate CreateScheduledOffworldReinforcementsTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown_UFO Cooldown;
	local X2LWActivityCondition_Days DaysRestriction;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.ScheduledOffworldReinforcementsName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation_SafestRegion';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.AnyAlienRegion);

	DaysRestriction = new class'X2LWActivityCondition_Days';
	DaysRestriction.FirstDayPossible[0] = default.FORCE_UFO_LAUNCH[0];
	DaysRestriction.FirstDayPossible[1] = default.FORCE_UFO_LAUNCH[1];
	DaysRestriction.FirstDayPossible[2] = default.FORCE_UFO_LAUNCH[2];
	DaysRestriction.FirstDayPossible[3] = default.FORCE_UFO_LAUNCH[3];
	Template.ActivityCreation.Conditions.AddItem(DaysRestriction);

	//Cooldown
	Cooldown = new class'X2LWActivityCooldown_UFO';
	Cooldown.UseForceTable = true;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalAdvanceActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalEndActivityOnMissionFailure;

	//optional delegates
	Template.OnActivityStartedFn = none;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // configurable offset
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel; // configurable offset to mission difficulty

	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = GetUFOMissionRewards;
	Template.OnActivityUpdateFn = none;

	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnScheduledOffworldReinforcementsComplete;

	return Template;
}

static function OnScheduledOffworldReinforcementsComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	

	History = `XCOMHISTORY;

	if (bAlienSuccess)
	{
		foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
		{
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
			RegionalAI.LocalForceLevel += 1;
			`LWTRACE("ScheduledOffworldReinforcements : Activity Complete, Alien Win, Increasing ForceLevel by 1 in " $ RegionState.GetMyTemplate().DisplayName );
		}
		//All region force level is the same, so i just need one instance of it
		
		// Increase Chosen level inline with the current global force
		// level. Also make sure the Chosen are activated when force
		// level reaches the configured threshold.
		TryIncreasingChosenLevel(RegionalAI.LocalForceLevel);
		if (RegionalAI.LocalForceLevel == default.CHOSEN_ACTIVATE_AT_FL)
			ActivateChosenIfEnabled(NewGameState);
	}
	else
	{
		`LWTRACE("ScheduledOffworldReinforcementsComplete : XCOM Success, boosting vigilance by 2 in " $ RegionState.GetMyTemplate().DisplayName);
		RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if(RegionState == none)
			RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
		RegionalAI.AddVigilance (NewGameState, 2);
	}
}

static function TryIncreasingChosenLevel(int CurrentForceLevel)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	local array<XComGameState_AdventChosen> AllChosen;
	local name OldTacticalTag, NewTacticalTag;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState NewGameState;

	// Ignore force levels that aren't Chosen level thresholds
	if (default.CHOSEN_LEVEL_FL_THRESHOLDS.Find(CurrentForceLevel) == INDEX_NONE)
		return;

	History = `XCOMHISTORY;

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen();

	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Creating Alien Customization Component");
	NewGameState = History.CreateNewGameState(true, ChangeContainer);

	foreach AllChosen(ChosenState)
	{
		OldTacticalTag = ChosenState.GetMyTemplate().GetSpawningTag(ChosenState.Level);
		Chosenstate.Level++;
		// Tedster - Cap chosen levels at the length of the level FL thresholds array, which should line up with the max level value since both start at 0.
		ChosenState.Level = MIN(default.CHOSEN_LEVEL_FL_THRESHOLDS.Length, Chosenstate.Level);

		//5th tier of chosen created by using PostEncounterCreation
		if(ChosenState.Level == 4)
		{
			ChosenState.Level = 3;
		}

		NewTacticalTag = ChosenState.GetMyTemplate().GetSpawningTag(ChosenState.Level);
		if (ChosenState.bMetXCom && !ChosenState.bDefeated)
		{
			ChosenState.bJustLeveledUp = true;
		}
		// Replace Old Tag with new Tag in missions
		ChosenState.RemoveTacticalTagFromAllMissions(NewGameState, OldTacticalTag, NewTacticalTag);
	}

	`GAMERULES.SubmitGameState(NewGameState);
}

// version that takes in a NewGameState for DLCInfo use for patching existing campaigns.
static function TryIncreasingChosenLevelWithGameState(int CurrentForceLevel, XComGameState NewGameState, XComGameState_AdventChosen ChosenState)
{
	local name OldTacticalTag, NewTacticalTag;
	local int NewChosenLevel;

		OldTacticalTag = ChosenState.GetMyTemplate().GetSpawningTag(ChosenState.Level);

		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
		
		//handle all force levels here.
		switch (CurrentForceLevel)
		{
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
				NewChosenLevel = 0;
				break;
			case 7:
			case 8:
			case 9:
			case 10:
				NewChosenLevel = 1;
				break;
			case 11:
			case 12:
			case 13:
			case 14:
			case 15:
				NewChosenLevel = 2;
				break;
			case 16:
			case 17:
			case 18:
			case 19:
			case 20:
				NewChosenLevel = 3;
				break;
			// default catches FL21+ campaigns
			default:
				NewChosenLevel = 3;
				break;
		}
		if(NewChosenLevel == ChosenState.Level)
			return;

		ChosenState.Level = NewChosenLevel;

		if(ChosenState.Level > 3)
		{
			ChosenState.Level = 3;
		}

		NewTacticalTag = ChosenState.GetMyTemplate().GetSpawningTag(ChosenState.Level);
		if (ChosenState.bMetXCom && !ChosenState.bDefeated)
		{
			ChosenState.bJustLeveledUp = true;
		}
		// Replace Old Tag with new Tag in missions
		ChosenState.RemoveTacticalTagFromAllMissions(NewGameState, OldTacticalTag, NewTacticalTag);

}

static function ActivateChosenIfEnabled(XComGameState NewGameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	local array<XComGameState_AdventChosen> AllChosen;
	local int i;
	if (!`SecondWaveEnabled('DisableChosen'))
	{

		AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		AlienHQ.OnChosenActivation(NewGameState);

		AllChosen = AlienHQ.GetAllChosen();

		//MAKE ABSOLUTELY 100% FULL ON SURE THAT CHOSEN START WITH 0 STRENGTHS BECAUSE THE CONFIGS LIE
		//ALSO REMOVE ALL WEAKNESSES FROM THEM
		foreach AllChosen(ChosenState)
		{
			if (!ChosenState.bMetXCom)
			{
				ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
				ChosenState.Strengths.length = 0;
				

				// Get them training and learning about XCOM straight away
				ChosenState.bMetXCom = true;
				ChosenState.NumEncounters++; 

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
		}
	}
}

static function name RescueReward(bool IncludeRebel, bool IncludePrisoner, XComGameState NewGameState)
{
	local int iRoll, Rescue_Soldier_Modified_Weight, Rescue_Engineer_Modified_Weight, Rescue_Scientist_Modified_Weight, Rescue_Rebel_Modified_Weight;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XCOMHQ;
	local array<StateObjectReference> CapturedSoldiers;
	local name Reward;

	History = class'XComGameStateHistory'.static.GetGameStateHistory();
	XCOMHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	Rescue_Soldier_Modified_Weight = default.RESCUE_SOLDIER_WEIGHT;
	Rescue_Engineer_Modified_Weight = default.RESCUE_SCIENTIST_WEIGHT;
	Rescue_Scientist_Modified_Weight = default.RESCUE_ENGINEER_WEIGHT;
	Rescue_Rebel_Modified_Weight = default.RESCUE_REBEL_CONDITIONAL_WEIGHT;

	// force an engineeer if you have none
	if (XCOMHQ.GetNumberOfEngineers() == 0)
	{
		Rescue_Soldier_Modified_Weight = 0;
		Rescue_Scientist_Modified_Weight = 0;
		Rescue_Rebel_Modified_Weight = 0;
	}
	else
	{
		// force a scientist if you have an engineer but no scientist
		if (XCOMHQ.GetNumberOfScientists() == 0)
		{
			Rescue_Soldier_Modified_Weight = 0;
			Rescue_Rebel_Modified_Weight = 0;
			Rescue_Engineer_Modified_Weight = 0;
		}
	}

	iRoll = `SYNC_RAND_STATIC(Rescue_Scientist_Modified_Weight + Rescue_Engineer_Modified_Weight + (IncludeRebel ? Rescue_Rebel_Modified_Weight : 0) + Rescue_Soldier_Modified_Weight);
	if (Rescue_Scientist_Modified_Weight > 0 && iRoll < Rescue_Scientist_Modified_Weight)
	{
		Reward = 'Reward_Scientist';
		return Reward;
	}
	else
	{
		iRoll -= Rescue_Scientist_Modified_Weight;
	}
	if (Rescue_Engineer_Modified_Weight > 0 && iRoll < Rescue_Engineer_Modified_Weight)
	{
		Reward = 'Reward_Engineer';
		return Reward;
	}
	else
	{
		iRoll -= Rescue_Engineer_Modified_Weight;
	}
	if (IncludeRebel && Rescue_Rebel_Modified_Weight > 0 && iRoll < Rescue_Rebel_Modified_Weight)
	{
		Reward='Reward_Rebel';
		return Reward;
	}

	CapturedSoldiers = class'Helpers_LW'.static.FindAvailableCapturedSoldiers(NewGameState);
	if (IncludePrisoner && CapturedSoldiers.Length > 0)
	{
		`LWTrace("[RescueSoldier] Adding a rescue captured soldier reward (RescueReward)");
		Reward = 'Reward_SoldierCaptured';
	}
	else
	{
		Reward = 'Reward_Soldier';
	}
	return Reward;
}

static function array<name> GetUFOMissionRewards(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> RewardArray;

	if (MissionFamily == 'SecureUFO_LW')
	{
		RewardArray[0] = 'Reward_Dummy_Materiel';
		RewardArray[1] = 'Reward_AvengerPower';
		return RewardArray;
	}
	if (MissionFamily == 'Rescue_LW')
	{
		RewardArray[0] = RescueReward(true, true, NewGameState);
		if (instr(RewardArray[0], "Soldier") != -1 && CanAddPOI())
		{
			RewardArray[1] = 'Reward_POI_LW';
			RewardArray[2] = 'Reward_Dummy_POI'; // The first POI rewarded on any mission doesn't display in rewards, so this corrects for that
		}
		return RewardArray;
	}
	RewardArray[0] = 'Reward_Intel';
	return RewardArray;
}

//#############################################################################################
//----------------------   ALERT-GRANTING OFFWORLD REINFORCEMENTS -----------------------------
//#############################################################################################

static function X2DataTemplate CreateEmergencyOffworldReinforcementsTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown_UFO Cooldown;
	local X2LWActivityCondition_Month MonthRestriction;
	local X2LWActivityCondition_RestrictedActivity RestrictedActivity;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.EmergencyOffworldReinforcementsName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation_AlertUFOLandingRegion';
	Template.ActivityCreation.Conditions.AddItem(default.AnyAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);

	RestrictedActivity = new class'X2LWActivityCondition_RestrictedActivity';
	RestrictedActivity.ActivityNames.AddItem(default.SuperEmergencyOffworldReinforcementsName);
	RestrictedActivity.MaxRestricted = 1;
	Template.ActivityCreation.Conditions.AddItem(RestrictedActivity);

	MonthRestriction = new class'X2LWActivityCondition_Month';
	MonthRestriction.FirstMonthPossible = 1;
	Template.ActivityCreation.Conditions.AddItem(MonthRestriction);

	//Cooldown
	Cooldown = new class'X2LWActivityCooldown_UFO';
	Cooldown.UseForceTable = false;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalAdvanceActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalEndActivityOnMissionFailure;

	//optional delegates
	Template.OnActivityStartedFn = none;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // configurable offset
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel; // configurable offset to mission difficulty

	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = GetUFOMissionRewards;
	//Template.GetNextMissionDurationSecondsFn = GetTypicalMissionDuration;
	Template.OnActivityUpdateFn = none;

	Template.CanBeCompletedFn = none;  // can always be completed
	//Template.GetTimeCompletedFn = TypicalActivityTimeCompleted;
	Template.OnActivityCompletedFn = OnEmergencyOffworldReinforcementsComplete;

	return Template;
}

static function OnEmergencyOffworldReinforcementsComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState, AdjacentRegion;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local XComGameState_WorldRegion_LWStrategyAI AdjacentRegionalAI;
	local StateObjectReference                   LinkedRegionRef;
	local int k, RandIndex;
	local array<XComGameState_WorldRegion> RegionLinks;

	History = `XCOMHISTORY;

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
	if(bAlienSuccess)
	{
		`LWTRACE("EmergencyOffworldReinforcementsComplete : Alien Success, adding AlertLevel to primary and some surrounding regions");
		// reinforcements have arrived
		RegionalAI.LocalAlertLevel += default.EMERGENCY_REINFORCEMENT_PRIMARY_REGION_ALERT_BONUS;

		foreach RegionState.LinkedRegions(LinkedRegionRef)
		{
			AdjacentRegion = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
			if (AdjacentRegion == none)
				AdjacentRegion = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
			if (AdjacentRegion != none && !RegionIsLiberated(AdjacentRegion, NewGameState))
			{
				RegionLinks.AddItem(AdjacentRegion);
			}
		}

		for (k = 0; k < default.ADJACENT_REGIONS_REINFORCED_BY_REGULAR_ALERT_UFO; k++)
		{
			RandIndex = `SYNC_RAND_STATIC(RegionLinks.Length);
			AdjacentRegion = RegionLinks[RandIndex];
			if (AdjacentRegion != none)
			{
				RegionLinks.Remove(RandIndex, 1);
				AdjacentRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(AdjacentRegion, NewGameState, true);
				AdjacentRegionalAI.LocalAlertLevel += default.EMERGENCY_REINFORCEMENT_ADJACENT_REGION_ALERT_BONUS;
			}
		}
	}
	else
	{
		if(default.ACTIVITY_LOGGING_ENABLED)
		{
			`LWTRACE("EmergencyOffworldReinforcementsComplete : XCOM Success, boosting vigilance");
		}
		RegionalAI.AddVigilance (NewGameState, 2);
	}
}


//#############################################################################################
//-------------------- STRONGER ALERT-GRANTING OFFWORLD REINFORCEMENTS--------------------------
//#############################################################################################

static function X2DataTemplate CreateSuperEmergencyOffworldReinforcementsTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_RestrictedActivity RestrictedActivity;
	local X2LWActivityCondition_AlertVigilance AlertVigilance;
	local X2LWActivityCooldown_Global Cooldown;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.SuperEmergencyOffworldReinforcementsName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation_AlertUFOLandingRegion';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.AnyAlienRegion);

	RestrictedActivity = new class'X2LWActivityCondition_RestrictedActivity';
	RestrictedActivity.ActivityNames.AddItem(default.EmergencyOffworldReinforcementsName);
	RestrictedActivity.MaxRestricted = 1;
	Template.ActivityCreation.Conditions.AddItem(RestrictedActivity);

	AlertVigilance = new class'X2LWActivityCondition_AlertVigilance';
	AlertVigilance.MaxAlertVigilanceDiff_Global = -default.SUPER_EMERGENCY_GLOBAL_VIG;
	Template.ActivityCreation.Conditions.AddItem(AlertVigilance);

	//Cooldown -- not difficulty specific here
	Cooldown = new class'X2LWActivityCooldown_Global';
	Cooldown.Cooldown_Hours = default.SUPEREMERGENCY_ALERT_UFO_GLOBAL_COOLDOWN_DAYS * 24.0;
	Template.ActivityCooldown = Cooldown;

	//these define the requirements for discovering each activity, based on the RebelJob "Missions"
	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	// required delegates
	Template.OnMissionSuccessFn = TypicalAdvanceActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalEndActivityOnMissionFailure;

	//optional delegates
	Template.OnActivityStartedFn = none;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // configurable offset
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel; // configurable offset to mission difficulty

	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = GetUFOMissionRewards;
	Template.OnActivityUpdateFn = none;

	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnSuperEmergencyOffworldReinforcementsComplete;

	return Template;
}

static function OnSuperEmergencyOffworldReinforcementsComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameStateHistory							History;
	local XComGameState_WorldRegion						RegionState, AdjacentRegion;
	local XComGameState_WorldRegion_LWStrategyAI		RegionalAI;
	local XComGameState_WorldRegion_LWStrategyAI		AdjacentRegionalAI;
	local StateObjectReference                          LinkedRegionRef;
	local int k, RandIndex;
	local array<XComGameState_WorldRegion> RegionLinks;

	History = `XCOMHISTORY;
	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);

	if(bAlienSuccess)
	{
		`LWTRACE("SuperEmergencyOffworldReinforcementsComplete : Alien Success, adding AlertLevel to primary and some surrounding regions");
		RegionalAI.LocalAlertLevel += default.SUPEREMERGENCY_REINFORCEMENT_PRIMARY_REGION_ALERT_BONUS;

		foreach RegionState.LinkedRegions(LinkedRegionRef)
		{
			AdjacentRegion = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
			if (AdjacentRegion == none)
				AdjacentRegion = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
			if (AdjacentRegion != none && !RegionIsLiberated(AdjacentRegion, NewGameState))
			{
				RegionLinks.AddItem(AdjacentRegion);
			}
		}

		for (k = 0; k < default.ADJACENT_REGIONS_REINFORCED_BY_SUPEREMERGENCY_ALERT_UFO; k++)
		{
			RandIndex = `SYNC_RAND_STATIC(RegionLinks.Length);
			AdjacentRegion = RegionLinks[RandIndex];
			if (AdjacentRegion != none)
			{
				RegionLinks.Remove(RandIndex, 1);
				AdjacentRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(AdjacentRegion, NewGameState, true);
				AdjacentRegionalAI.LocalAlertLevel += default.SUPEREMERGENCY_REINFORCEMENT_ADJACENT_REGION_ALERT_BONUS;
			}
		}
	}
	else
	{
		`LWTRACE("SuperEmergencyOffworldReinforcementsComplete : XCOM Success, boosting vigilance");
		//activity halted, boost vigilance by an extra two points over the typical +1
		RegionalAI.AddVigilance (NewGameState, 2);
	}
}

//#############################################################################################
//---------------------------------------- REPRESSION -----------------------------------------
//#############################################################################################

static function X2DataTemplate CreateRepressionTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityDetectionCalc DetectionCalc;
	local X2LWActivityCondition_RegionStatus RegionStatus;
	local X2LWActivityCooldown Cooldown;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.RepressionName);

	//no missions

	DetectionCalc = new class'X2LWActivityDetectionCalc';
	DetectionCalc.SetNeverDetected(true);
	Template.DetectionCalc = DetectionCalc;

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.REPRESSION_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.REPRESSION_REGIONAL_COOLDOWN_HOURS_MAX - default.REPRESSION_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	RegionStatus = new class'X2LWActivityCondition_RegionStatus';
	RegionStatus.bAllowInUncontacted = true;
	Template.ActivityCreation.Conditions.AddItem(RegionStatus);

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = none;
	Template.WasMissionSuccessfulFn = none;
	Template.GetMissionForceLevelFn = none;
	Template.GetMissionAlertLevelFn = none;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none;
	Template.GetMissionRewardsFn = none;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;
	Template.OnActivityCompletedFn = RepressionComplete;

	return Template;
}

static function bool InvisibleActivity (XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	return false;
}

static function RepressionComplete (bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion_LWStrategyAI	NewRegionalAI;
	local XComGameState_WorldRegion					RegionState;
    local XComGameState_LWOutpost					Outpoststate, NewOutpostState;
	local XComGameState_LWOutpostManager			OutPostManager;
	local int										iRoll, RebelToRemove;
	local StateObjectReference						NewUnitRef;
	local bool										AIchange, OPChange;

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	If (RegionState == none)
	{
		`LWTRACE ("Repression activity created and ended with no primary region!");
		return;
	}

	if (RegionState.HaveMadeContact() || RegionIsLiberated(RegionState, NewGameState))
		return;

	NewRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	OutpostState = OutpostManager.GetOutpostForRegion(RegionState);
	NewOutpostState = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutPostState.ObjectID));

	AIChange = false;
	OPChange = false;

	iRoll == `SYNC_RAND_STATIC (100);
	if (iRoll < default.REPRESSION_ADVENT_LOSS_CHANCE)
	{
		NewRegionalAI.AddVigilance (NewGameState, 1);
		NewRegionalAI.LocalAlertLevel = Max (NewRegionalAI.LocalAlertLevel - 1, 1);
		AIChange = true;
	}

	iRoll == `SYNC_RAND_STATIC (100);
	if (iRoll < default.REPRESSION_RECRUIT_REBEL_CHANCE)
	{
		NewUnitRef = NewOutpostState.CreateRebel(NewGameState, RegionState, true);
		NewOutpostState.AddRebel(NewUnitRef, NewGameState);
		OPChange = true;
	}

	iRoll == `SYNC_RAND_STATIC (100);
	if (iRoll < default.REPRESSION_VIGILANCE_INCREASE_CHANCE)
	{
		NewRegionalAI.AddVigilance (NewGameState, 1);
		AIChange = true;
	}

	iRoll == `SYNC_RAND_STATIC (100);
	if (iRoll > default.REPRESSION_REBEL_LOST_CHANCE)
	{
		if (OutPostState.Rebels.length > 1)
		{
			RebeltoRemove = `SYNC_RAND_STATIC(NewOutPostState.Rebels.length);
			if (!OutPostState.Rebels[RebelToRemove].IsFaceless)
			{
				NewOutPostState.RemoveRebel (OutPostState.Rebels[RebeltoRemove].Unit, NewGameState);
				NewRegionalAI.AddVigilance (NewGameState, -1);
				AIChange = true;
				OPChange = true;
			}
		}
	}

	iRoll == `SYNC_RAND_STATIC (100);
	if (iRoll < default.REPRESSION_CLONES_RELEASED_CHANCE)
	{
		NewRegionalAI.LocalAlertLevel += 1;
		AIChange = true;
	}

	iRoll == `SYNC_RAND_STATIC (100);
	if (iRoll < default.REPRESSION_2ND_REBEL_LOST_CHANCE)
	{
		if (OutPostState.Rebels.length > 1)
		{
			if (!NewOutPostState.Rebels[RebelToRemove].IsFaceless)
			{
				RebeltoRemove = `SYNC_RAND_STATIC(NewOutPostState.Rebels.length);
				NewOutPostState.RemoveRebel (OutPostState.Rebels[RebeltoRemove].Unit, NewGameState);
				NewRegionalAI.AddVigilance (NewGameState, -1);
				AIChange = true;
				OPChange = true;
			}
		}
	}
	If (OPChange)
		NewGameState.AddStateObject(NewOutpostState);
	if (AIChange)
		NewGameState.AddStateObject(NewRegionalAI);

	`LWTRACE("Repression Finished" @ RegionState.GetMyTemplate().DisplayName @ "Roll:" @ string (iRoll) @ "Rebels left:" @ string (NewOutPostState.Rebels.length));

}

// ########################
// ####### FOOTHOLD #######
// ########################

static function X2DataTemplate CreateFootholdTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_RegionStatus RegionStatus;
	local X2LWActivityCooldown Cooldown;
	local X2LWActivityCondition_MinLiberatedRegions WorldStatus;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.FootholdName);

	Template.CanOccurInLiberatedRegion = true;

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);

	RegionStatus = new class'X2LWActivityCondition_RegionStatus';
	RegionStatus.bAllowInLiberated = true;
	RegionStatus.bAllowInAlien = false;
	RegionStatus.bAllowInContacted = true;
	Template.ActivityCreation.Conditions.AddItem(RegionStatus);

	WorldStatus = new class 'X2LWActivityCondition_MinLiberatedRegions';
	WorldStatus.MaxAlienRegions = default.ATTEMPT_FOOTHOLD_MAX_ALIEN_REGIONS;
	Template.ActivityCreation.Conditions.AddItem(WorldStatus);

	Cooldown = new class'X2LWActivityCooldown_Global';
	Cooldown.Cooldown_Hours = default.FOOTHOLD_GLOBAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.FOOTHOLD_GLOBAL_COOLDOWN_HOURS_MAX - default.FOOTHOLD_GLOBAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetFootholdForceLevel;
	Template.GetMissionAlertLevelFn = GetFootholdAlertLevel;

	Template.GetTimeUpdateFn = none; //TypicalSecondMissionSpawnTimeUpdate;
	Template.OnActivityUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = none;

	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnFootholdComplete; // transfer of regional alert/force levels

	return Template;
}

static function int GetFootholdForceLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	if (ActivityState.GetMyTemplate().ForceLevelModifier > 0)
		return ActivityState.GetMyTemplate().ForceLevelModifier;

	return 18;
}

static function int GetFootholdAlertLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	if (ActivityState.GetMyTemplate().AlertLevelModifier > 0)
		return ActivityState.GetMyTemplate().AlertLevelModifier;

	return 15;
}


static function OnFootholdComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion							PrimaryRegionState;
	local XComGameState_WorldRegion_LWStrategyAI			PrimaryRegionalAI;
	local XComGameState_LWOutpost							Outpost;

	if(bAlienSuccess)
	{
		PrimaryRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if(PrimaryRegionState == none)
			PrimaryRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		PrimaryRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(PrimaryRegionState, NewGameState, true);

		PrimaryRegionalAI.bLiberated = false;
		PrimaryRegionalAI.LiberateStage1Complete = false;
		PrimaryRegionalAI.LiberateStage2Complete = false;
		PrimaryRegionalAI.AddVigilance (NewGameState, PrimaryRegionalAI.LocalVigilanceLevel - PrimaryRegionalAI.LocalVigilanceLevel + 10);
		PrimaryRegionalAI.LocalAlertLevel = 10;

		Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(PrimaryRegionState);
		Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
		NewGameState.AddStateObject(Outpost);
		Outpost.WipeOutOutpost(NewGameState);

	}
}

//#############################################################################################
//--------------------------------------- RENDEZVOUS-------------------------------------------
//#############################################################################################
static function X2DataTemplate CreateRendezvousTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_RegionStatus RegionStatus;
    local X2LWActivityCooldown Cooldown;
	local X2LWActivityCondition_HasAdviserofClass AdviserStatus;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.RendezvousName);

    // Faceless can still exist in liberated regions.
	Template.CanOccurInLiberatedRegion = true;
	Template.ActivityCreation = new class'X2LWActivityCreation';

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc_Rendezvous';

    // Allow only in contacted regions.
	RegionStatus = new class'X2LWActivityCondition_RegionStatus';
	RegionStatus.bAllowInLiberated = true;
	RegionStatus.bAllowInAlien = true;
	RegionStatus.bAllowInContacted = true;
	Template.ActivityCreation.Conditions.AddItem(RegionStatus);

	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);

    // Allow only if the region contains faceless
    Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_HasFaceless');

	AdviserStatus = new class'X2LWActivityCondition_HasAdviserofClass';
	AdviserStatus.SpecificType = true;
	AdviserStatus.AdviserType = 'Soldier';
	Template.ActivityCreation.Conditions.AddItem(AdviserStatus);

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.RENDEZVOUS_GLOBAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.RENDEZVOUS_GLOBAL_COOLDOWN_HOURS_MAX - default.RENDEZVOUS_GLOBAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetRendezvousForceLevel;
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;

	Template.GetTimeUpdateFn = none;
	Template.OnActivityUpdateFn = none;
	Template.OnMissionExpireFn = OnRendezvousExpired;
	Template.GetMissionRewardsFn = none;
    Template.GetMissionSiteFn = GetRendezvousMissionSite;

	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = none;

	return Template;
}

static function int GetRendezvousForceLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;

	RegionState = MissionSite.GetWorldRegion();
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);
	return int (RegionalAIState.LocalForceLevel * default.RENDEZVOUS_FL_MULTIPLIER) + ActivityState.GetMyTemplate().ForceLevelModifier;
}


static function XComGameState_MissionSite GetRendezvousMissionSite(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
    local XComGameState_LWOutpost Outpost;
    local XComGameState_WorldRegion Region;
    local XComGameStateHistory History;
    local XComGameState_MissionSiteRendezvous_LW RendezvousMission;
    local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
    local array<StateObjectReference> arrFaceless;
    local int i;

    History = `XCOMHISTORY;

    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
    Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);
    RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);

    for (i = 0; i < Outpost.Rebels.Length; ++i)
    {
        if (Outpost.Rebels[i].IsFaceless)
        {
            arrFaceless.AddItem(Outpost.Rebels[i].Unit);
        }
    }

    if (arrFaceless.Length == 0)
    {
        `redscreen("GetRendezvousMissionSite: Failed to locate any faceless in outpost");
    }

    if (MissionFamily == 'Rendezvous_LW')
    {
        RendezvousMission = XComGameState_MissionSiteRendezvous_LW(NewGameState.CreateNewStateobject(class'XComGameState_MissionSiteRendezvous_LW'));

		// There's always at least one faceless
        i = `SYNC_RAND_STATIC(arrFaceless.Length);
        RendezvousMission.FacelessSpies.AddItem(arrFaceless[i]);
        arrFaceless.Remove(i, 1);

		// Add additional faceless from the haven up to the local force level
        while (arrFaceless.Length > 0 && RendezvousMission.FacelessSpies.Length < RegionalAI.LocalForceLevel)
        {
            // Choose another
            i = `SYNC_RAND_STATIC(arrFaceless.Length);
            RendezvousMission.FacelessSpies.AddItem(arrFaceless[i]);
			arrFaceless.Remove(i, 1);
        }
        return RendezvousMission;
    }
    else
    {
        return XComGameState_MissionSite(NewGameState.CreateNewStateObject(class'XComGameState_MissionSite'));
    }
}

static function OnRendezvousExpired (XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	local int k;
	local XComGameState_MissionSiteRendezvous_LW RendezvousState;
	local XComGameSTate_WorldRegion Region;
	local XComGameState_LWOutpost OutPost;

	if (!ActivityState.bDiscovered)
	{
		// Nothing to do if this mission wasn't detected
		return;
	}

	RendezvousState = XComGameState_MissionSiteRendezvous_LW(MissionState);
	if (RendezvousState != none)
	{
		Region = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);
		Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutPost.ObjectID));
		NewGameState.AddStateObject(Outpost);

		// Remove all faceless that were on this mission from the haven: the adviser detected this mission
		// and knows who they are, so their cover is blown.
		for (k=0; k < RendezvousState.FacelessSpies.Length; k++)
		{
			OutPost.RemoveRebel(RendezvousState.FacelessSpies[k], NewGameState);
		}
	}
}

//#############################################################################################
//---------------------------------------- INVASION-------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateInvasionTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_RegionStatus RegionStatus;
	local X2LWActivityCooldown Cooldown;
	local X2LWActivityCondition_LiberatedDays FreedomDuration;
	local X2LWActivityCondition_RNG_Region AlienSearchCondition;
	local X2LWActivityCondition_MinRebels RebelCondition1;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.InvasionName);

	Template.CanOccurInLiberatedRegion = true;

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation_Invasion';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);

	// This makes sure there are enough warm bodies for the mission to be meaningful
	RebelCondition1 = new class 'X2LWActivityCondition_MinRebels';
	RebelCondition1.MinRebels = default.ATTEMPT_COUNTERINSURGENCY_MIN_REBELS;
	Template.ActivityCreation.Conditions.AddItem(RebelCondition1);

	RegionStatus = new class'X2LWActivityCondition_RegionStatus';
	RegionStatus.bAllowInLiberated = true;
	RegionStatus.bAllowInAlien = false;
	RegionStatus.bAllowInContacted = true;
	Template.ActivityCreation.Conditions.AddItem(RegionStatus);

	FreedomDuration = new class 'X2LWActivityCondition_LiberatedDays';
	FreedomDuration.MinLiberatedDays = default.INVASION_MIN_LIBERATED_DAYS;
	Template.ActivityCreation.Conditions.AddItem(FreedomDuration);

	AlienSearchCondition = new class 'X2LWActivityCondition_RNG_Region';
	AlienSearchCondition.Invasion = true;
	AlienSearchCondition.Multiplier = 1.0;
	AlienSearchCondition.UseFaceless = true;
	Template.ActivityCreation.Conditions.AddItem(AlienSearchCondition);

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.INVASION_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.INVASION_REGIONAL_COOLDOWN_HOURS_MAX - default.INVASION_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	//optional delegates
	Template.OnActivityStartedFn = none;

	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetInvasionForceLevel;
	Template.GetMissionAlertLevelFn = GetOriginAlertLevel;

	Template.GetTimeUpdateFn = none; //TypicalSecondMissionSpawnTimeUpdate;
	Template.OnActivityUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission, handle in failure
	Template.GetMissionRewardsFn = GetInvasionRewards;

	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = OnInvasionComplete; // transfer of regional alert/force levels

	return Template;
}

static function int GetInvasionForceLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));

	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));

	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);

	if(default.ACTIVITY_LOGGING_ENABLED)
	{
		`LWTRACE("Activity " $ ActivityState.GetMyTemplateName $ ": Mission Force Level =" $ RegionalAIState.LocalForceLevel + ActivityState.GetMyTemplate().ForceLevelModifier );
	}
	return RegionalAIState.LocalForceLevel + ActivityState.GetMyTemplate().ForceLevelModifier;
}

static function int GetOriginAlertLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));

	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));

	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);

	if(default.ACTIVITY_LOGGING_ENABLED)
	{
		`LWTRACE("Activity " $ ActivityState.GetMyTemplateName $ ": Mission Alert Level =" $ RegionalAIState.LocalAlertLevel + ActivityState.GetMyTemplate().AlertLevelModifier );
	}
	return RegionalAIState.LocalAlertLevel + ActivityState.GetMyTemplate().AlertLevelModifier;
}


static function array<name> GetInvasionRewards(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> Rewards;

	if (MissionFamily == 'SupplyLineRaid_LW')
	{
		Rewards[0] = 'Reward_Dummy_Materiel';
	}
	else
	{
		Rewards[0] = 'Reward_Dummy_Unhindered';
	}
	return Rewards;
}


static function OnInvasionComplete(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion							PrimaryRegionState, OriginRegionState;
	local XComGameState_WorldRegion_LWStrategyAI			PrimaryRegionalAI, OriginRegionalAI;
	local XComGameState_LWOutpost							Outpost;

	OriginRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));

	if(OriginRegionState == none)
		OriginRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.SecondaryRegions[0].ObjectID));

	OriginRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(OriginRegionState, NewGameState, true);

	if(bAlienSuccess)
	{
		PrimaryRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if(PrimaryRegionState == none)
			PrimaryRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		PrimaryRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(PrimaryRegionState, NewGameState, true);

		PrimaryRegionalAI.bLiberated = false;
		PrimaryRegionalAI.LiberateStage1Complete = false;
		PrimaryRegionalAI.LiberateStage2Complete = false;
		PrimaryRegionalAI.AddVigilance (NewGameState, PrimaryRegionalAI.LocalVigilanceLevel - PrimaryRegionalAI.LocalVigilanceLevel + 10);
		PrimaryRegionalAI.LocalAlertLevel = Max (OriginRegionalAI.LocalAlertLevel / 2, 1);
		OriginRegionalAI.LocalAlertLevel = Max (OriginRegionalAI.LocalAlertLevel / 2 + OriginRegionalAI.LocalAlertLevel % 2, 1);

	    Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(PrimaryRegionState);
		Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
		NewGameState.AddStateObject(Outpost);
		Outpost.WipeOutOutpost(NewGameState);
	}
	else
	{
		OriginRegionalAI.LocalAlertLevel = Max (OriginRegionalAI.LocalAlertLevel - 2, 1);
		OriginRegionalAI.AddVigilance (NewGameState, 3);
	}
}

//#############################################################################################
//---------------------------------------- PROPAGANDA -----------------------------------------
//#############################################################################################

static function X2DataTemplate CreatePropagandaTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown Cooldown;
	local X2LWActivityCondition_Month MonthRestriction;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.PropagandaName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier
	//Template.ActivityCategory = 'GeneralOps';

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	//Template.ActivityCreation.Conditions.AddItem(default.GeneralOpsCondition);				// Can't trigger if region already has two general ops running
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');
	Template.ActivityCreation.Conditions.AddItem(default.TwoActivitiesInWorld);
	//Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_GeneralOpsCap');

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.PROPAGANDA_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.PROPAGANDA_REGIONAL_COOLDOWN_HOURS_MAX - default.PROPAGANDA_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	MonthRestriction = new class'X2LWActivityCondition_Month';
	MonthRestriction.FirstMonthPossible = 2;
	Template.ActivityCreation.Conditions.AddItem(MonthRestriction);

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = none;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = PropagandaRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = PropagandaComplete;

	return Template;
}

static function PropagandaComplete (bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion_LWStrategyAI	RegionalAI;
	local XComGameState_WorldRegion					RegionState;

	`LWTrace ('Propaganda Complete');
	if (!bAlienSuccess)
	{
		RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if (RegionState == none)
		{
			RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
			if (RegionState == none)
			{
				`REDSCREEN("PropagandaComplete: ActivityState has no primary region");
			}
		}
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
		RegionalAI.AddVigilance(NewGameState, default.XCOM_WIN_PROPAGANDA_VIGILANCE_GAIN);
		`LWTrace ("Propaganda XCOM Win: Adding Vigilance");
		AddVigilanceNearby (NewGameState, RegionState, default.PROPAGANDA_ADJACENT_VIGILANCE_BASE, default.PROPAGANDA_ADJACENT_VIGILANCE_RAND);
	}
}

static function array<name> PropagandaRewards (XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> RewardArray;

	if (MissionFamily == 'Neutralize_LW')
	{
		if (CanAddPOI())
		{
			RewardArray[0] = 'Reward_POI_LW'; // this will only be granted if captured
			RewardArray[1] = 'Reward_Dummy_POI'; // The first POI rewarded on any mission doesn't display in rewards, so this corrects for that
			RewardArray[2] = 'Reward_Intel';
		}
		else
		{
			RewardArray[0] = 'Reward_Supplies';
			RewardArray[1] = 'Reward_Intel';
		}
	}
	else
	{
		RewardArray[0] = 'Reward_Intel';
	}
	return RewardArray;
}


//#############################################################################################
//---------------------------------- PROTECT RESEARCH -----------------------------------------
//#############################################################################################

static function X2DataTemplate CreateProtectResearchTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCondition_ResearchFacility ResearchFacility;
	local X2LWActivityCooldown Cooldown;
	local X2LWActivityCondition_Month TimeCondition;
	local X2LWActivityCondition_MinLiberatedRegionsLegendary LibCondition;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.ProtectResearchName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc_ProtectResearch';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation_ProtectResearch';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AvatarRevealed');
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');
	Template.ActivityCreation.Conditions.AddItem(default.TwoActivitiesInWorld);

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.PROTECT_RESEARCH_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.PROTECT_RESEARCH_REGIONAL_COOLDOWN_HOURS_MAX - default.PROTECT_RESEARCH_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	ResearchFacility = new class'X2LWActivityCondition_ResearchFacility';
	ResearchFacility.bRequiresHiddenAlienResearchFacilityInWorld = true;
	ResearchFacility.bRequiresAlienResearchFacilityInRegion = false;
	Template.ActivityCreation.Conditions.AddItem(ResearchFacility);

	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_FacilityLeadItem'); // prevents creation if would create more items than there are facilities

	//Add a time delay so you don't instantly get facility missions
	TimeCondition = new class'X2LWActivityCondition_Month';
	TimeCondition.FirstMonthPossible = default.PROTECT_RESEARCH_FIRST_MONTH_POSSIBLE;
	Template.ActivityCreation.Conditions.AddItem(TimeCondition);

	//Add Lib condition for Legendary;
	LibCondition = new class'X2LWActivityCondition_MinLiberatedRegionsLegendary';
	LibCondition.MaxAlienRegions = 15; // 1 region liberated
	Template.ActivityCreation.Conditions.AddItem(LibCondition);

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = none;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = GetProtectResearchRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = ProtectResearchComplete;

	return Template;
}

static function array<name> GetProtectResearchRewards (XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> RewardArray;

	switch (MissionFamily)
	{
		case 'Hack_LW':
		case 'Recover_LW': RewardArray[0] = 'Reward_Intel'; break;
		case 'Rescue_LW':
		case 'Extract_LW': RewardArray[0] = 'Reward_Scientist'; break;
		default: break;
	}
	RewardArray[1] = 'Reward_FacilityLead';
	return RewardArray;
}

static function ProtectResearchComplete (bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
}

//#############################################################################################
//--------------------------------------- PROTECT DATA ----------------------------------------
//#############################################################################################

static function X2DataTemplate CreateProtectDataTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown Cooldown;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.ProtectDataName);
	Template.iPriority = 50;
	Template.ActivityCategory = 'GeneralOps';

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.GeneralOpsCondition);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_POIAvailable');
	Template.ActivityCreation.Conditions.AddItem(default.TwoActivitiesInWorld);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_GeneralOpsCap');

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.PROTECT_DATA_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.PROTECT_DATA_REGIONAL_COOLDOWN_HOURS_MAX - default.PROTECT_DATA_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = StartGeneralOp;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = GetProtectDataRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = ProtectDataComplete;

	return Template;
}

static function ProtectDataComplete (bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
}

static function array<name> GetProtectDataRewards (XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> RewardArray;

	switch (MissionFamily)
	{
		case 'DestroyObject_LW':
		case 'Hack_LW':
		case 'Recover_LW': RewardArray[0] = 'Reward_Intel'; break;
		case 'Rescue_LW': RewardArray[0] = RescueReward (true, true, NewGameState); break;
		case 'Extract_LW': RewardArray[0] = RescueReward (true, true, NewGameState); break;
		default: break;
	}
	if (CanAddPOI())
	{
		RewardArray[1] = 'Reward_POI_LW';
		RewardArray[2] = 'Reward_Dummy_POI';
	}
	else
	{
		RewardArray[1] = 'Reward_Supplies';
	}
	return RewardArray;
}

//#############################################################################################
//---------------------------------- TROOP MANEUVERS -----------------------------------------
//#############################################################################################

static function X2DataTemplate CreateTroopManeuversTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown Cooldown;
	local X2LWActivityDetectionCalc_TroopManeuvers DetectionCalc;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.TroopManeuversName);
	Template.ActivityCategory = 'GeneralOps';

	DetectionCalc = new class'X2LWActivityDetectionCalc_TroopManeuvers';
	DetectionCalc.DetectionChancePerLocalAlert = default.TROOP_MANEUVERS_BONUS_DETECTION_PER_DAY_PER_ALERT;
	Template.DetectionCalc = DetectionCalc;

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.GeneralOpsCondition);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');
	Template.ActivityCreation.Conditions.AddItem(default.TwoActivitiesInWorld);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_GeneralOpsCap');

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.TROOP_MANEUVERS_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.TROOP_MANEUVERS_REGIONAL_COOLDOWN_HOURS_MAX - default.TROOP_MANEUVERS_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = StartGeneralOp;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = GetTroopManeuversRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = TroopManeuversComplete;

	return Template;
}

static function TroopManeuversComplete (bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion_LWStrategyAI	RegionalAI;
	local XComGameState_WorldRegion					RegionState;

	if (!bAlienSuccess)
	{
		RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if(RegionState == none)
			RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if (RegionState == none)
		{
			`LWTRACE ("Error: Can't find region post Troop Maneuvers");
		}
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
		if (RegionalAI == none)
		{
			`LWTRACE ("Error: Can't find regional AI post Troop Maneuvers");
		}
		RegionalAI.AddVigilance(NewGameState, default.TROOP_MANEUVERS_VIGILANCE_GAIN);

		if (`SYNC_RAND_STATIC(100) < default.TROOP_MANEUVERS_CHANCE_KILL_ALERT[`STRATEGYDIFFICULTYSETTING])
		{
			`LWTRACE ("TROOP MANEUVERS WIN, Old:" @ string (RegionalAI.LocalAlertLevel) @ "New:" @ string (Max(RegionalAI.LocalAlertLevel - 1, 1)));
			RegionalAI.LocalAlertLevel = Max(RegionalAI.LocalAlertLevel - 1, 1);
			AddVigilanceNearby (NewGameState, RegionState, default.TROOP_MANEUVERS_NEIGHBOR_VIGILANCE_BASE, default.TROOP_MANEUVERS_NEIGHBOR_VIGILANCE_RAND);
		}
	}
}

static function array<name> GetTroopManeuversRewards (XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> RewardArray;

	RewardArray[0] = 'Reward_Dummy_Materiel';
	return RewardArray;
}

// Covert op version

static function X2DataTemplate CreateCovertOpsTroopManeuversTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local MissionLayerInfo MissionLayer;
	local X2LWActivityDetectionCalc DetectionCalc;
	local X2LWActivityCondition_AlertVigilance AlertVigilance;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, 'CovertOpsTroopManeuvers');

	MissionLayer.MissionFamilies.AddItem('CovertOpsTroopManeuvers_LW');
	MissionLayer.Duration_Hours = 24*5.5;
	MissionLayer.DurationRand_Hours = 24;
	MissionLayer.BaseInfiltrationModifier_Hours=-24;
    Template.MissionTree.AddItem(MissionLayer);


 	DetectionCalc = new class'X2LWActivityDetectionCalc';
	DetectionCalc.SetAlwaysDetected(true);
	Template.DetectionCalc = DetectionCalc;

 	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';

	AlertVigilance = new class'X2LWActivityCondition_AlertVigilance';
	AlertVigilance.MinAlert = 9999; // never created normally, only via Covert Op
	Template.ActivityCreation.Conditions.AddItem(AlertVigilance);

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = none;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetCovertOpsTroopManeuversMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = GetTroopManeuversRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = none; // this one doesn't reduce strength

	return Template;
}

// using this to cap this at str 4
static function int GetCovertOpsTroopManeuversMissionAlertLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;

	RegionState = MissionSite.GetWorldRegion();
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);

	if(default.ACTIVITY_LOGGING_ENABLED)
	{
		`LWTRACE("Activity " $ ActivityState.GetMyTemplateName $ ": Mission Alert Level =" $ min(RegionalAIState.LocalAlertLevel + ActivityState.GetMyTemplate().AlertLevelModifier, 4) );
	}
	return min(RegionalAIState.LocalAlertLevel + ActivityState.GetMyTemplate().AlertLevelModifier, 4);
}


//#############################################################################################
//---------------------------------- HIGH-VALUE PRISONER --------------------------------------
//#############################################################################################

static function X2DataTemplate CreateHighValuePrisonerTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown Cooldown;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.HighValuePrisonerName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier
	Template.ActivityCategory = 'GeneralOps';

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.GeneralOpsCondition);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');
	Template.ActivityCreation.Conditions.AddItem(default.TwoActivitiesInWorld);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_GeneralOpsCap');

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.HIGH_VALUE_PRISONER_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.HIGH_VALUE_PRISONER_REGIONAL_COOLDOWN_HOURS_MAX - default.HIGH_VALUE_PRISONER_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = StartGeneralOp;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = GetHVPRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = none;

	return Template;
}

static function bool CanAddPOI()
{
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local array<XComGameState_PointOfInterest> POIDeck;

	ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	POIDeck = ResistanceHQ.BuildPOIDeck(false);
	if (POIDeck.length > 0)
	{
		return true;
	}
	return false;
}

static function array<name> GetHVPRewards(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<name> RewardArray;

	RewardArray[0] = RescueReward(false, true, NewGameState);
	if (instr(RewardArray[0], "Soldier") != -1 && CanAddPOI())
	{
		RewardArray[1] = 'Reward_POI_LW';
		RewardArray[2] = 'Reward_Dummy_POI'; // The first POI rewarded on any mission doesn't display in rewards, so this corrects for that
	}
	return RewardArray;
}


//#############################################################################################
//---------------------------------- POLITICAL PRISONERS --------------------------------------
//#############################################################################################

static function X2DataTemplate CreatePoliticalPrisonersTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown Cooldown;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.PoliticalPrisonersName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier
	Template.ActivityCategory = 'GeneralOps';

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.GeneralOpsCondition);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');
	Template.ActivityCreation.Conditions.AddItem(default.TwoActivitiesInWorld);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_GeneralOpsCap');

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.POLITICAL_PRISONERS_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.POLITICAL_PRISONERS_REGIONAL_COOLDOWN_HOURS_MAX - default.POLITICAL_PRISONERS_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalAdvanceActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = StartGeneralOp;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = GetPoliticalPrisonersReward;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = none;

	return Template;

}

function array<Name> GetPoliticalPrisonersReward(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local array<Name> Rewards;
	local int NumRebels, Roll, RebelChance, MaxRebels, NumCapturedSoldiers;
	local XComGameState_WorldRegion							Region;
	local XComGameState_LWOutpost							Outpost;
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local array<StateObjectReference>          CapturedSoldiers;

    switch(MissionFamily)
    {
	    case 'Jailbreak_LW':
			ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
			// This limits the number of rescues early to smooth out starts
			MaxRebels = Min (default.POLITICAL_PRISONERS_REBEL_REWARD_MAX, default.POLITICAL_PRISONERS_REBEL_REWARD_MAX - (3 - ResistanceHQ.NumMonths));
			NumRebels = `SYNC_RAND(MaxRebels - default.POLITICAL_PRISONERS_REBEL_REWARD_MIN + 1) + default.POLITICAL_PRISONERS_REBEL_REWARD_MIN;

			// Prioritise rescuing captured soldiers. Note that we can't do
			// FindAvailableCapturedSoldiers().Length because it doesn't work
			// in UnrealScript, hence the intermediate `CapturedSoldiers` variable.
			CapturedSoldiers = class'Helpers_LW'.static.FindAvailableCapturedSoldiers(NewGameState);
			NumCapturedSoldiers = CapturedSoldiers.Length;
			while (NumRebels > 0 && NumCapturedSoldiers > 0 && Rewards.Length < default.MAX_CAPTURED_SOLDIER_REWARDS)
			{
				`LWTrace("[RescueSoldier] Adding a rescue captured soldier reward to Jailbreak");
				Rewards.AddItem('Reward_SoldierCaptured');
				--NumRebels;
				--NumCapturedSoldiers;
			}

			Region = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
			Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);

			RebelChance = class'LWRebelJob_DefaultJobSet'.default.RECRUIT_REBEL_BAR;
			if (Outpost.GetRebelCount() > Outpost.GetMaxRebelCount())
			{
				RebelChance -= class'LWRebelJob_DefaultJobSet'.default.RECRUIT_SOLDIER_BIAS_IF_FULL;
			}
			while (NumRebels > 0)
			{
				roll = `SYNC_RAND(class'LWRebelJob_DefaultJobSet'.default.RECRUIT_REBEL_BAR + class'LWRebelJob_DefaultJobSet'.default.RECRUIT_SOLDIER_BAR);
				if (roll < RebelChance)
				{
					Rewards.AddItem(class'X2StrategyElement_DefaultRewards_LW'.const.REBEL_REWARD_NAME);
				}
				else
				{
					Rewards.AddItem('Reward_Rookie');
				}
				--NumRebels;
			}
			return Rewards;
		default:
			return Rewards;
    }
}


static function X2DataTemplate CreateLogisticsTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown Cooldown;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.LogisticsName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier
	Template.ActivityCategory = 'GeneralOps';

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInRegion);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.GeneralOpsCondition);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');
	Template.ActivityCreation.Conditions.AddItem(default.TwoActivitiesInWorld);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_GeneralOpsCap');

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.LOGISTICS_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.LOGISTICS_REGIONAL_COOLDOWN_HOURS_MAX - default.LOGISTICS_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalAdvanceActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = StartGeneralOp;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = GetLogisticsReward;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = none;

	return Template;

}

function array<Name> GetLogisticsReward(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
    local array<Name> Rewards;

	Rewards[0] = 'Reward_Dummy_Materiel';
	return Rewards;
}



//#############################################################################################
//-------------------------------------- SNARE ------------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateSnareTemplate()
{
	local X2LWAlienActivityTemplate Template;
	local X2LWActivityCooldown Cooldown;
	local X2LWActivityCondition_Month MonthRestriction;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.SnareName);
	Template.iPriority = 50; // 50 is default, lower priority gets created earlier
	Template.ActivityCategory = 'GeneralOps';

	Template.DetectionCalc = new class'X2LWActivityDetectionCalc';

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_GeneralOpsCap');

	Cooldown = new class'X2LWActivityCooldown_Global';
	Cooldown.Cooldown_Hours = default.SNARE_GLOBAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.SNARE_GLOBAL_COOLDOWN_HOURS_MAX - default.SNARE_GLOBAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	MonthRestriction = new class'X2LWActivityCondition_Month';
	MonthRestriction.FirstMonthPossible = 2;
	Template.ActivityCreation.Conditions.AddItem(MonthRestriction);

	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_HasFaceless');

	Template.OnMissionSuccessFn = TypicalAdvanceActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = StartGeneralOp;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = GetSnareReward;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = none;

	return Template;
}

function array<Name> GetSnareReward(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
    local array<Name> Rewards;

	Rewards[0] = 'Reward_Intel';
	Rewards[1] = 'Reward_Dummy_POI';
	return Rewards;
}

static function StartGeneralOp (XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local XComGameState_WorldRegion Region;

	Region = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if (Region == none)
	   Region = XComGameState_WorldRegion(`XCOMHistory.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState, true);
	RegionalAI.GeneralOpsCount += 1;
}


//#############################################################################################
//--------------------------------------- INTEL RAID ------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateIntelRaidTemplate()
{
	local X2LWAlienActivityTemplate					Template;
	local X2LWActivityCooldown						Cooldown;
	local X2LWActivityCondition_MinRebelsOnJob		RebelCondition;
	local X2LWActivityDetectionCalc					AlwaysDetect;
	local X2LWActivityCondition_FullOutpostJobBuckets BucketFill;
	local X2LWActivityCondition_RetalMixer				RetalMixer;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.IntelRaidName);
	Template.ActivityCategory = 'RetalOps';

	AlwaysDetect = new class'X2LWActivityDetectionCalc';
	AlwaysDetect.SetAlwaysDetected(true);
	Template.DetectionCalc = AlwaysDetect;

	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.RetalOpsCondition);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');

	//This makes certain regions more or less likely
	RetalMixer = new class'X2LWActivityCondition_RetalMixer';
	RetalMixer.UseSpecificJob = true;
	RetalMixer.SpecificJob = class'LWRebelJob_DefaultJobSet'.const.INTEL_JOB;
	Template.ActivityCreation.Conditions.AddItem(RetalMixer);

	RebelCondition = new class 'X2LWActivityCondition_MinRebelsOnJob';
	RebelCondition.MinRebelsOnJob = default.MIN_REBELS_TO_TRIGGER_INTEL_RAID;
	RebelCondition.FacelessReduceMinimum=true;
	RebelCondition.Job = class'LWRebelJob_DefaultJobSet'.const.INTEL_JOB;
	Template.ActivityCreation.Conditions.AddItem(RebelCondition);

	BucketFill = new class 'X2LWActivityCondition_FullOutpostJobBuckets';
	BucketFill.FullRetal = false;
	BucketFill.Job = class'LWRebelJob_DefaultJobSet'.const.INTEL_JOB;
	BucketFill.RequiredDays = default.INTEL_RAID_BUCKET;
	Template.ActivityCreation.Conditions.AddItem(BucketFill);

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.INTEL_RAID_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.INTEL_RAID_REGIONAL_COOLDOWN_HOURS_MAX - default.INTEL_RAID_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = EmptyRetalBucket;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetIntelRaidAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = OnRaidExpired; // just remove the mission
	Template.GetMissionRewardsFn = GetAnyRaidRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = IntelRaidCompleted;
    Template.GetMissionSiteFn = GetRebelRaidMissionSite;

	return Template;
}



static function EmptyRetalBucket (XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_LWOutpost							Outpost;
	local XComGameState_WorldRegion							Region;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_WorldRegion', Region)
	{
		Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);
		Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutPost.ObjectID));
		NewGameState.AddStateObject(Outpost);
		switch (ActivityState.GetMyTemplateName())
		{
			case default.IntelRaidName:
				OutPost.ResetJobBucket(class'LWRebelJob_DefaultJobSet'.const.INTEL_JOB);
				break;
			case default.SupplyConvoyName:
				OutPost.ResetJobBucket(class'LWRebelJob_DefaultJobSet'.const.SUPPLY_JOB);
				break;
			case default.RecruitRaidName:
				OutPost.ResetJobBucket(class'LWRebelJob_DefaultJobSet'.const.RECRUIT_JOB);
				break;
			case default.CounterInsurgencyName:
				OutPost.TotalResistanceBucket = 0;
				break;
			default:
				break;
		}
	}
}


function array<Name> GetAnyRaidRewards(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
    local array<Name> Rewards;

	Rewards[0] = 'Reward_Dummy_Unhindered';
	return Rewards;
}

static function ProhibitJob (XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState, name JobName)
{
	local XComGameState_WorldRegion							Region;
	local XComGameState_LWOutpost							Outpost;
	local bool												ExtendCurrent;
	local int												k;
	local string											AlertString;
	local XGParamTag ParamTag;

	`LWTRACE ("PROHIBITING JOB:" @ JobName);
	Region = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);
	Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutPost.ObjectID));
	NewGameState.AddStateObject(Outpost);
	ExtendCurrent = false;

	for (k = 0; k < Outpost.ProhibitedJobs.Length; k++)
	{
		if (OutPost.ProhibitedJobs[k].Job == JobName)
		{
			ExtendCurrent = true;
			OutPost.ProhibitedJobs[k].DaysLeft += default.PROHIBITED_JOB_DURATION;
			break;
		}
	}
	if (!ExtendCurrent)
	{
		OutPost.AddProhibitedJob(JobName, default.PROHIBITED_JOB_DURATION);
		//`LWTRACE ("ADDING PROHIBITED JOB:" @ JobName);
		ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		ParamTag.IntValue0 = default.PROHIBITED_JOB_DURATION;
		ParamTag.StrValue0 = OutPost.GetJobName(JobName);
		ParamTag.StrValue1 = Region.GetMyTemplate().DisplayName;
		AlertString = `XEXPAND.ExpandString(class'XComGameState_LWOutPost'.default.m_strProhibitedJobAlert);
		`HQPRES.Notify (AlertString);
		for (k=0; k < OutPost.Rebels.Length; k++)
		{
			if (OutPost.Rebels[k].Job == JobName)
			{
				//`LWTRACE ("SETTING REBEL JOB TO HIDING:" @ JobName);
				OutPost.SetRebelJob (OutPost.Rebels[k].Unit, 'Hiding');
			}
		}
	}
}

static function OnRaidExpired (XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	local int k;
	local XComGameState_MissionSiteRebelRaid_LW RaidState;
	local XComGameSTate_WorldRegion Region;
	local XComGameState_LWOutpost OutPost;

	RaidState = XComGameState_MissionSiteRebelRaid_LW(MissionState);
	if (RaidState != none)
	{
		Region = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);
		Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', OutPost.ObjectID));
		NewGameState.AddStateObject(Outpost);

		// All rebels on this mission are killed (faceless or not)
		for (k=0; k < OutPost.Rebels.Length; k++)
		{
			if (RaidState.Rebels.Find('ObjectID', OutPost.Rebels[k].Unit.ObjectID) != -1)
			{
				OutPost.RemoveRebel(OutPost.Rebels[k].Unit, NewGameState);
				--k;
			}
		}

		// If we have an adviser on this mission, kill/capture them.
		if (Outpost.HasLiaisonValidForMission(MissionState.GeneratedMission.Mission.sType))
		{
			Outpost.RemoveAndCaptureLiaison(NewGameState);
		}
	}
}


static function IntelRaidCompleted (bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local XComGameState_WorldRegion Region;

	Region = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if (Region == none)
	   Region = XComGameState_WorldRegion(`XCOMHistory.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState, true);
	if (bAlienSuccess)
	{
		ProhibitJob (ActivityState, NewGameState, 'Intel');
		RegionalAI.AddVigilance (NewGameState, -default.VIGILANCE_DECREASE_ON_ADVENT_RAID_WIN);
	}
	else
	{
		// This counteracts base vigilance increase on an xcom win to prevent vigilance spiralling up in vig->retal cycle
		RegionalAI.AddVigilance (NewGameState, default.VIGILANCE_CHANGE_ON_XCOM_RAID_WIN);
	}
}


//#############################################################################################
//------------------------------------- SUPPLY RAID ------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateSupplyConvoyTemplate()
{
	local X2LWAlienActivityTemplate					Template;
	local X2LWActivityCondition_MinRebelsOnJob		RebelCondition;
	local X2LWActivityDetectionCalc					AlwaysDetect;
	local X2LWActivityCooldown						Cooldown;
	local X2LWActivityCondition_FullOutpostJobBuckets BucketFill;
	local X2LWActivityCondition_RetalMixer				RetalMixer;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.SupplyConvoyName);
	Template.ActivityCategory = 'RetalOps';

	AlwaysDetect = new class'X2LWActivityDetectionCalc';
	AlwaysDetect.SetAlwaysDetected(true);
	Template.DetectionCalc = AlwaysDetect;

	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.RetalOpsCondition);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');

	RetalMixer = new class'X2LWActivityCondition_RetalMixer';
	RetalMixer.UseSpecificJob = true;
	RetalMixer.SpecificJob = class'LWRebelJob_DefaultJobSet'.const.SUPPLY_JOB;
	Template.ActivityCreation.Conditions.AddItem(RetalMixer);

	RebelCondition = new class 'X2LWActivityCondition_MinRebelsOnJob';
	RebelCondition.MinRebelsOnJob = default.MIN_REBELS_TO_TRIGGER_SUPPLY_RAID;
	RebelCondition.Job = class'LWRebelJob_DefaultJobSet'.const.SUPPLY_JOB;
	RebelCondition.FacelessReduceMinimum=false;
	Template.ActivityCreation.Conditions.AddItem(RebelCondition);

	BucketFill = new class 'X2LWActivityCondition_FullOutpostJobBuckets';
	BucketFill.FullRetal = false;
	BucketFill.Job = class'LWRebelJob_DefaultJobSet'.const.SUPPLY_JOB;
	BucketFill.RequiredDays = default.SUPPLY_RAID_BUCKET;
	Template.ActivityCreation.Conditions.AddItem(BucketFill);

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.SUPPLY_RAID_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.SUPPLY_RAID_REGIONAL_COOLDOWN_HOURS_MAX - default.SUPPLY_RAID_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = EmptyRetalBucket;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = OnRaidExpired; // just remove the mission
	Template.GetMissionRewardsFn = GetAnyRaidRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = SupplyConvoyCompleted;
    Template.GetMissionSiteFn = GetRebelRaidMissionSite;

	return Template;
}

static function SupplyConvoyCompleted (bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	Region = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if (Region == none)
		Region = XComGameState_WorldRegion(`XCOMHistory.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState, true);

	if (bAlienSuccess)
	{
		ProhibitJob (ActivityState, NewGameState, 'Resupply');
		RegionalAI.AddVigilance (NewGameState, -default.VIGILANCE_DECREASE_ON_ADVENT_RAID_WIN);
	}
	else
	{
		// This counteracts base vigilance increase on an xcom win to prevent vigilance spiralling up in vig->retal cycle
		RegionalAI.AddVigilance (NewGameState, default.VIGILANCE_CHANGE_ON_XCOM_RAID_WIN);
	}
}

//#############################################################################################
//---------------------------------- RECRUIT RAID ------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateRecruitRaidTemplate()
{
	local X2LWAlienActivityTemplate						Template;
	local X2LWActivityCondition_MinRebelsOnJob			RebelCondition;
	local X2LWActivityDetectionCalc						AlwaysDetect;
	local X2LWActivityCooldown							Cooldown;
	local X2LWActivityCondition_FullOutpostJobBuckets	BucketFill;
	local X2LWActivityCondition_RetalMixer				RetalMixer;

	`CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.RecruitRaidName);
	Template.ActivityCategory = 'RetalOps';

	AlwaysDetect = new class'X2LWActivityDetectionCalc';
	AlwaysDetect.SetAlwaysDetected(true);
	Template.DetectionCalc = AlwaysDetect;

	Template.ActivityCreation = new class'X2LWActivityCreation';
	Template.ActivityCreation.Conditions.AddItem(default.SingleActivityInWorld);
	Template.ActivityCreation.Conditions.AddItem(default.ContactedAlienRegion);
	Template.ActivityCreation.Conditions.AddItem(default.RetalOpsCondition);
	Template.ActivityCreation.Conditions.AddItem(new class'X2LWActivityCondition_AlertVigilance');

	RetalMixer = new class'X2LWActivityCondition_RetalMixer';
	RetalMixer.UseSpecificJob = true;
	RetalMixer.SpecificJob = class'LWRebelJob_DefaultJobSet'.const.RECRUIT_JOB;
	Template.ActivityCreation.Conditions.AddItem(RetalMixer);

	RebelCondition = new class 'X2LWActivityCondition_MinRebelsOnJob';
	RebelCondition.MinRebelsOnJob = default.MIN_REBELS_TO_TRIGGER_RECRUIT_RAID;
	RebelCondition.FacelessReduceMinimum=true;
	RebelCondition.Job = class'LWRebelJob_DefaultJobSet'.const.RECRUIT_JOB;
	Template.ActivityCreation.Conditions.AddItem(RebelCondition);

	BucketFill = new class 'X2LWActivityCondition_FullOutpostJobBuckets';
	BucketFill.FullRetal = false;
	BucketFill.Job = class'LWRebelJob_DefaultJobSet'.const.RECRUIT_JOB;
	BucketFill.RequiredDays = default.RECRUIT_RAID_BUCKET;
	Template.ActivityCreation.Conditions.AddItem(BucketFill);

	Cooldown = new class'X2LWActivityCooldown';
	Cooldown.Cooldown_Hours = default.RECRUIT_RAID_REGIONAL_COOLDOWN_HOURS_MIN;
	Cooldown.RandCooldown_Hours = default.RECRUIT_RAID_REGIONAL_COOLDOWN_HOURS_MAX - default.RECRUIT_RAID_REGIONAL_COOLDOWN_HOURS_MIN;
	Template.ActivityCooldown = Cooldown;

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = EmptyRetalBucket;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = OnRaidExpired; // just remove the mission
	Template.GetMissionRewardsFn = GetAnyRaidRewards;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = RecruitRaidCompleted;
    Template.GetMissionSiteFn = GetRebelRaidMissionSite;

	return Template;
}

static function RecruitRaidCompleted (bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	Region = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if (Region == none)
		Region = XComGameState_WorldRegion(`XCOMHistory.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState, true);

	if (bAlienSuccess)
	{
		ProhibitJob (ActivityState, NewGameState, 'Recruit');
		RegionalAI.AddVigilance (NewGameState, -default.VIGILANCE_DECREASE_ON_ADVENT_RAID_WIN);
	}
	else
	{
		RegionalAI.AddVigilance (NewGameState, default.VIGILANCE_CHANGE_ON_XCOM_RAID_WIN);
	}
}

//#############################################################################################
//---------------------------------- Big Supply Extraction ------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateBigSupplyExtractionTemplate()
{
    local X2LWAlienActivityTemplate Template;
    local MissionLayerInfo MissionLayer;
	local X2LWActivityDetectionCalc DetectionCalc;
	local X2LWActivityCondition_AlertVigilance AlertVigilance;

    `CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, 'BigSupplyExtraction_LW');
    // Add an arbitrary mission to the mission list. This won't really be used, it'll be overridden
    // by the cheat command to force a particular mission kind.
    MissionLayer.MissionFamilies.AddItem('BigSupplyExtraction_LW');
	MissionLayer.Duration_Hours = 24*6;
	MissionLayer.DurationRand_Hours = 24;
    Template.MissionTree.AddItem(MissionLayer);

 	DetectionCalc = new class'X2LWActivityDetectionCalc';
	DetectionCalc.SetAlwaysDetected(true);
	Template.DetectionCalc = DetectionCalc;

 	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';

	AlertVigilance = new class'X2LWActivityCondition_AlertVigilance';
	AlertVigilance.MinAlert = 9999; // never created normally, only via Covert Op
	Template.ActivityCreation.Conditions.AddItem(AlertVigilance);

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = none;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = GetLogisticsReward;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = none;

    return Template;
}

static function int GetBigExtractMissionAlertLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;

	RegionState = MissionSite.GetWorldRegion();
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);

	if(default.ACTIVITY_LOGGING_ENABLED)
	{
		`LWTRACE("Activity " $ ActivityState.GetMyTemplateName $ ": Mission Alert Level =" $ min(RegionalAIState.LocalAlertLevel + ActivityState.GetMyTemplate().AlertLevelModifier, default.BIGSUPPLYEXTRACTION_MAX_ALERT) );
	}
	return min(RegionalAIState.LocalAlertLevel + ActivityState.GetMyTemplate().AlertLevelModifier, default.BIGSUPPLYEXTRACTION_MAX_ALERT);
}


//#############################################################################################
//---------------------------------- MISSION TESTING ------------------------------------------
//#############################################################################################

static function X2DataTemplate CreateDebugMissionTemplate()
{
    local X2LWAlienActivityTemplate Template;
    local MissionLayerInfo MissionLayer;
	local X2LWActivityDetectionCalc DetectionCalc;
	local X2LWActivityCondition_AlertVigilance AlertVigilance;

    `CREATE_X2TEMPLATE(class'X2LWAlienActivityTemplate', Template, default.DebugMissionName);
    // Add an arbitrary mission to the mission list. This won't really be used, it'll be overridden
    // by the cheat command to force a particular mission kind.
    MissionLayer.MissionFamilies.AddItem('Hack_LW');
	MissionLayer.Duration_Hours = 24*7;
    Template.MissionTree.AddItem(MissionLayer);

 	DetectionCalc = new class'X2LWActivityDetectionCalc';
	DetectionCalc.SetAlwaysDetected(true);
	Template.DetectionCalc = DetectionCalc;

 	//these define the requirements for creating each activity
	Template.ActivityCreation = new class'X2LWActivityCreation';

	AlertVigilance = new class'X2LWActivityCondition_AlertVigilance';
	AlertVigilance.MinAlert = 9999; // never created normally, only via console command
	Template.ActivityCreation.Conditions.AddItem(AlertVigilance);

	Template.OnMissionSuccessFn = TypicalEndActivityOnMissionSuccess;
	Template.OnMissionFailureFn = TypicalAdvanceActivityOnMissionFailure;

	Template.OnActivityStartedFn = none;
	Template.WasMissionSuccessfulFn = none;  // always one objective
	Template.GetMissionForceLevelFn = GetTypicalMissionForceLevel; // use regional ForceLevel
	Template.GetMissionAlertLevelFn = GetTypicalMissionAlertLevel;
	Template.GetTimeUpdateFn = none;
	Template.OnMissionExpireFn = none; // just remove the mission
	Template.GetMissionRewardsFn = none;
	Template.OnActivityUpdateFn = none;
	Template.CanBeCompletedFn = none;  // can always be completed
	Template.OnActivityCompletedFn = none;

    return Template;
}

//#############################################################################################
//----------------   GAMEPLAY TYPICAL   -------------------------------------------------------
//#############################################################################################


static function int GetTypicalMissionForceLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;

	RegionState = MissionSite.GetWorldRegion();
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);

	if(default.ACTIVITY_LOGGING_ENABLED)
	{
		`LWTRACE("Activity " $ ActivityState.GetMyTemplateName $ ": Mission Force Level =" $ RegionalAIState.LocalForceLevel + ActivityState.GetMyTemplate().ForceLevelModifier );
	}
	return RegionalAIState.LocalForceLevel + ActivityState.GetMyTemplate().ForceLevelModifier;
}

static function int GetIntelRaidAlertLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;
	local int AlertLevel;

	RegionState = MissionSite.GetWorldRegion();
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);

	AlertLevel = GetTypicalMissionAlertLevel(ActivityState, MissionSite, NewGameState);

	// Adjust the alert level based on Force Level to ensure the first couple of intel raids
	// aren't quite as strong a shock to the player's system. This is a bit of a hack, but
	// if it works out, parameterise the 8 (the 4 is just half that value).
	AlertLevel -= Max(0, FFloor((8 - RegionalAIState.LocalForceLevel) / 4) + 1);

	return AlertLevel;
}

static function int GetTypicalMissionAlertLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;

	RegionState = MissionSite.GetWorldRegion();
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);

	if(default.ACTIVITY_LOGGING_ENABLED)
	{
		`LWTRACE("Activity " $ ActivityState.GetMyTemplateName $ ": Mission Alert Level =" $ RegionalAIState.LocalAlertLevel + ActivityState.GetMyTemplate().AlertLevelModifier );
	}
	return RegionalAIState.LocalAlertLevel + ActivityState.GetMyTemplate().AlertLevelModifier;
}

static function TypicalAdvanceActivityOnMissionSuccess(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	local X2LWAlienActivityTemplate ActivityTemplate;
	local XComGameState_WorldRegion RegionState;
	local array<int> ExcludeIndices;

	if(ActivityState == none)
		`REDSCREEN("AlienActivities : TypicalAdvanceActivityOnMissionSuccess -- no ActivityState");

	ActivityTemplate = ActivityState.GetMyTemplate();
	NewGameState.AddStateObject(ActivityState);

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

    // We need to apply the rewards immediately, but don't want to run them twice if we need to also defer the
    // activity update until we're back at the geoscape.
    if (!ActivityState.bNeedsUpdateMissionSuccess)
    {
	    if (MissionState != none)
	    {
			ExcludeIndices = GetRewardExcludeIndices(ActivityState, MissionState, NewGameState);
		    GiveRewards(NewGameState, MissionState, ExcludeIndices);
		    RecordResistanceActivity(true, ActivityState, MissionState, NewGameState);

			IncreaseChosenKnowledge(RegionState, NewGameState);

		    MissionState.RemoveEntity(NewGameState);
	    }
    }

    if(MissionState.GeneratedMission.Mission.MissionName == 'AssaultNetworkTower_LW')
	{
		`XEVENTMGR.TriggerEvent('LiberateStage2Complete', , , NewGameState); // this is needed to advance objective LW_T2_M0_S3 -- THIS IS A BACKUP, IT SHOULD HAVE BEEN TRIGGERED EARLIER
		`XEVENTMGR.TriggerEvent('NetworkTowerDefeated', ActivityState, ActivityState, NewGameState); // this is needed to advance objective LW_T2_M0_S3_CompleteActivity
	}

	if(ActivityTemplate.DataName == class'X2StrategyElement_DefaultAlienActivities'.default.ProtectRegionEarlyName && ActivityState.CurrentMissionLevel == 0)
	{
		`XEVENTMGR.TriggerEvent('OnProtectRegionActivityDiscovered', , , NewGameState); // this is needed to advance objective LW_T2_M0_S2_FindActivity
	}

	//check to see if we are back in geoscape yet
	if (`HQGAME == none || `HQPRES == none || `HQPRES.StrategyMap2D == none)
	{
		//not there, so mark the activity to update next time we are back in geoscape
		ActivityState.bNeedsUpdateMissionSuccess = true;
		return;
	}


	//advance to the next mission in the chain
	ActivityState.CurrentMissionLevel++;

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	//when a region is liberated, activities can no longer be advanced
	if(RegionState != none && RegionIsLiberated(RegionState, NewGameState) && !ActivityTemplate.CanOccurInLiberatedRegion)
	{
		if(MissionState != none)
		{
			if (MissionState.POIToSpawn.ObjectID > 0)
			{
				class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
			}
			MissionState.RemoveEntity(NewGameState);
		}
		if(ActivityTemplate.OnActivityCompletedFn != none)
			ActivityTemplate.OnActivityCompletedFn(false /* alien failure */, ActivityState, NewGameState);
		NewGameState.RemoveStateObject(ActivityState.ObjectID);
	}
	else if(ActivityState.SpawnMission(NewGameState)) //try and spawn the next mission
	{
		if (ActivityState.bDiscovered)
		{
			ActivityState.bNeedsAppearedPopup = true;
		}
		ActivityState.bMustLaunch = false;
	}
	else // we've reached the end of the chain
	{
		if(ActivityTemplate.OnActivityCompletedFn != none)
			ActivityTemplate.OnActivityCompletedFn(false /* not alien success*/, ActivityState, NewGameState);

		ActivityState.bNeedsAppearedPopup = false;
		ActivityState.bMustLaunch = false;

		NewGameState.RemoveStateObject(ActivityState.ObjectID);
	}

	//record success

}

static function TypicalEndActivityOnMissionSuccess(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	local X2LWAlienActivityTemplate ActivityTemplate;
	local XComGameState_WorldRegion RegionState;
	local array<int> ExcludeIndices;

	if(ActivityState == none)
		`REDSCREEN("AlienActivities : TypicalEndActivityOnMissionSuccess -- no ActivityState");

	ActivityTemplate = ActivityState.GetMyTemplate();
	NewGameState.AddStateObject(ActivityState);

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	if (MissionState != none)
	{
		ExcludeIndices = GetRewardExcludeIndices(ActivityState, MissionState, NewGameState);

		GiveRewards(NewGameState, MissionState, ExcludeIndices);
		RecordResistanceActivity(true, ActivityState, MissionState, NewGameState);

		IncreaseChosenKnowledge(RegionState, NewGameState);

		MissionState.RemoveEntity(NewGameState);
	}

	if(ActivityTemplate.OnActivityCompletedFn != none)
		ActivityTemplate.OnActivityCompletedFn(false /* not alien success*/, ActivityState, NewGameState);

	NewGameState.RemoveStateObject(ActivityState.ObjectID);

	//record success

}

static function TypicalEndActivityOnMissionFailure(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	local X2LWAlienActivityTemplate ActivityTemplate;

	if(ActivityState == none)
		`REDSCREEN("AlienActivities : TypicalEndActivityOnMissionFailure -- no ActivityState");
	ActivityTemplate = ActivityState.GetMyTemplate();
	NewGameState.AddStateObject(ActivityState);
	if (MissionState != none)
	{
		RecordResistanceActivity(false, ActivityState, MissionState, NewGameState);
		MissionState.RemoveEntity(NewGameState);
	}
	if(ActivityTemplate.OnActivityCompletedFn != none)
		ActivityTemplate.OnActivityCompletedFn(true, ActivityState, NewGameState);
	NewGameState.RemoveStateObject(ActivityState.ObjectID);
}

//handles the case where mission failure simply doesn't advance the chain -- there's no other consequence
static function TypicalNoActionOnMissionFailure(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	// The caller created this, but all delegates need to add the object.
	NewGameState.AddStateObject(ActivityState);

	//don't do anything here -- player can still undertake the mission

	//record failure
	if (MissionState != none)
		RecordResistanceActivity(false, ActivityState, MissionState, NewGameState);
}

//handles the case where mission failure advances the chain to the next mission
static function TypicalAdvanceActivityOnMissionFailure(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	local X2LWAlienActivityTemplate ActivityTemplate;
	local XComGameState_WorldRegion RegionState;
	local bool ForceDetection;

	if(ActivityState == none)
		`REDSCREEN("AlienActivities : TypicalContinueOnMissionSuccess -- no ActivityState");

	ActivityTemplate = ActivityState.GetMyTemplate();
	NewGameState.AddStateObject(ActivityState);

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	if (MissionState != none)
	{
		RecordResistanceActivity(false, ActivityState, MissionState, NewGameState);
		if (MissionState.POIToSpawn.ObjectID > 0)
		{
			// This mission had a POI, deactivate it.
			class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
		}
	}

	//when a region is liberated, activities can no longer be lost
	if(RegionState != none && RegionIsLiberated(RegionState, NewGameState) && !ActivityTemplate.CanOccurInLiberatedRegion)
	{
		if(MissionState != none)
			MissionState.RemoveEntity(NewGameState);
		if(ActivityTemplate.OnActivityCompletedFn != none)
			ActivityTemplate.OnActivityCompletedFn(false /* alien failure */, ActivityState, NewGameState);
		NewGameState.RemoveStateObject(ActivityState.ObjectID);
	}

	if (ActivityTemplate.MissionTree.length > ActivityState.CurrentMissionLevel+1)
	{
		ForceDetection = ActivityTemplate.MissionTree[ActivityState.CurrentMissionLevel+1].ForceActivityDetection;
	}
	//check to see if we are back in geoscape yet
	if (`HQGAME == none || `HQPRES == none || `HQPRES.StrategyMap2D == none)
	{
		//not there, so mark the activity to update next time we are back in geoscape
		ActivityState.bNeedsUpdateMissionFailure = true;
		if (ForceDetection)
			ActivityState.bNeedsUpdateDiscovery = true;

		return;
	}

	if (ForceDetection)
		ActivityState.bDiscovered = true;

	if(MissionState != none)
		MissionState.RemoveEntity(NewGameState);

	//advance to the next mission in the chain
	ActivityState.CurrentMissionLevel++;

	//try and spawn the next mission
	if(ActivityState.SpawnMission(NewGameState))
	{
		if (ActivityState.bDiscovered)
		{
			ActivityState.bNeedsAppearedPopup = true;
		}
	}
	else // we've reached the end of the chain
	{
		if(ActivityTemplate.OnActivityCompletedFn != none)
			ActivityTemplate.OnActivityCompletedFn(true /* alien success*/, ActivityState, NewGameState);

		NewGameState.RemoveStateObject(ActivityState.ObjectID);
	}

	//record failure

}

static function StateObjectReference GetTypicalMissionDarkEvent(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
	local StateObjectReference DarkEventRef;
	local X2LWAlienActivityTemplate ActivityTemplate;

	ActivityTemplate = ActivityState.GetMyTemplate();
	//default is to add the dark event to the last mission in the mission chain
	if(ActivityState.CurrentMissionLevel == ActivityTemplate.MissionTree.Length-1)
	{
		DarkEventRef = ActivityState.DarkEvent;
	}

	return DarkEventRef;
}

static function AddVigilanceNearby (XComGameState NewGameState, XComGameState_WorldRegion CoreRegionState, int BaseNearbyIncrease, int RandNearbyIncrease)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local StateObjectReference LinkedRegionRef;

	foreach CoreRegionState.LinkedRegions(LinkedRegionRef)
	{
		RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
		if(RegionState == none)
			RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
		if(RegionState != none && !RegionIsLiberated(RegionState, NewGameState))
		{
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
			if (RegionalAI != none)
				RegionalAI.AddVigilance(NewGameState, BaseNearbyIncrease + `SYNC_RAND_STATIC(RandNearbyIncrease));
		}
	}
}


static function IncreaseChosenKnowledge(XComGameState_WorldRegion RegionState, XComGameState NewGameState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = RegionState.GetControllingChosen();
	ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
	ChosenState.ModifyKnowledgeScore(NewGameState, default.CHOSEN_KNOWLEDGE_GAIN_MISSIONS);
}

static function RecordResistanceActivity(bool Success, XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local name ActivityTemplateName;
	local int DoomToRemove;
	local string MissionFamily;

	History = `XCOMHISTORY;

	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);
	if(Success)
	{
		RegionalAI.AddVigilance(NewGameState, default.XCOM_WIN_VIGILANCE_GAIN);
	}
	else
	{
		RegionalAI.AddVigilance(NewGameState, default.XCOM_LOSE_VIGILANCE_GAIN);
	}

	// Golden Path missions are handled by their MissionSource templates, which are still in-use

	MissionFamily = MissionState.GeneratedMission.Mission.MissionFamily;
	if (Success)
	{
		switch (MissionFamily) {
		case "Hack_LW":
		case "Recover_LW":
		case "Rescue_LW":
		case "Extract_LW":
		case "DestroyObject_LW":
		case "Jailbreak_LW":
		case "TroopManeuvers_LW":
		case "CovertOpsTroopManeuvers_LW":
		case "ProtectDevice_LW":
		case "SabotageCC":
		case "SabotageCC_LW":
		case "AssaultNetworkTower_LW":
		case "SmashnGrab_LW":
		case "SupplyExtraction_LW":
		case "BigSupplyExtraction_LW":
			ActivityTemplateName='ResAct_GuerrillaOpsCompleted';
			break;
		case "SecureUFO_LW":
			ActivityTemplateName='ResAct_LandedUFOsCompleted';
			break;
		case "Terror_LW":
        case "Defend_LW":
			ActivityTemplateName='ResAct_RetaliationsStopped';
			break;
		case "Invasion_LW":
			ActivityTemplateName='ResAct_RegionsLiberated';
			break;
		case "SupplyLineRaid_LW":
			ActivityTemplateName='ResAct_SupplyRaidsCompleted';
			break;
		case "Sabotage_LW":
			ActivityTemplateName='ResAct_AlienFacilitiesDestroyed';
			DoomToRemove = MissionState.Doom;
			break;
        case "Rendezvous_LW":
			ActivityTemplateName='ResAct_FacelessUncovered';
            break;
		case "AssaultAlienBase_LW":
			ActivityTemplateName='ResAct_RegionsLiberated';
			if (RegionalAI.NumTimesLiberated <= 0)
			{
				`LWTRACE ("Removing one doom for capturing a region!");
				DoomToRemove = default.ALIEN_BASE_DOOM_REMOVAL;
			}
			break;
		case "RecruitRaid_LW":
		case "IntelRaid_LW":
		case "SupplyConvoy_LW":
			ActivityTemplateName='ResAct_RaidsDefeated';
			break;
		default:
			ActivityTemplateName='ResAct_GuerrillaOpsCompleted';
			break;
		}
	}
	else
	{
		switch (MissionFamily) {
		case "Hack_LW":
		case "Recover_LW":
		case "Rescue_LW":
		case "Extract_LW":
		case "DestroyObject_LW":
		case "Jailbreak_LW":
		case "TroopManeuvers_LW":
		case "CovertOpsTroopManeuvers_LW":
		case "ProtectDevice_LW":
		case "SabotageCC":
		case "SabotageCC_LW":
		case "Rendezvous_LW":
		case "AssaultNetworkTower_LW":
		case "Sabotage_LW":
		case "SmashnGrab_LW":
		case "SupplyExtraction_LW":
		case "BigSupplyExtraction_LW":
		case "AssaultAlienBase_LW":
			if (!ActivityState.bFailedFromMissionExpiration)
			{
				ActivityTemplateName='ResAct_GuerrillaOpsFailed';
			}
			break;
		case "SecureUFO_LW":
			if (!ActivityState.bFailedFromMissionExpiration)
			{
				ActivityTemplateName='ResAct_LandedUFOsFailed';
			}
			break;
		case "Terror_LW":
        case "Defend_LW":
			ActivityTemplateName='ResAct_RetaliationsFailed';
			break;
		case "Invasion_LW":
			ActivityTemplateName='ResAct_RegionsLost';
			break;
		case "SupplyLineRaid_LW":
			if (!ActivityState.bFailedFromMissionExpiration)
			{
				ActivityTemplateName='ResAct_SupplyRaidsFailed';
			}
		case "Rendezvous_LW":
			if (!ActivityState.bFailedFromMissionExpiration)
			{
				ActivityTemplateName='ResAct_FacelessUncovered';
			}
			break;
		case "RecruitRaid_LW":
		case "IntelRaid_LW":
		case "SupplyConvoy_LW":
			ActivityTemplateName='ResAct_RaidsLost';
			break;
		default:
			break;
		}
	}

	/// DID NOT USE: ResAct_CouncilMissionsCompleted

	//only record for missions that were ever visible
	if (MissionState.Available)
	{
		class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, ActivityTemplateName);
		if (DoomToRemove > 0)
		{
			class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_AvatarProgressReduced', DoomToRemove);
		}
	}
}

static function SelectPOI(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	ResHQ.ChoosePOI(NewGameState, true);
}

static function GiveRewards(XComGameState NewGameState, XComGameState_MissionSite MissionState, optional array<int> ExcludeIndices)
{
	local XComGameStateHistory History;
	local XComGameState_PointOfInterest POIState;
	local XComGameState_Reward RewardState;
	local int idx;

	History = `XCOMHISTORY;

	`LWTRACE ("GiveRewards 1");

	// First Check if we need to exclude some rewards
	for(idx = 0; idx < MissionState.Rewards.Length; idx++)
	{
		RewardState = XComGameState_Reward(History.GetGameStateForObjectID(MissionState.Rewards[idx].ObjectID));
		if(RewardState != none)
		{
			if(ExcludeIndices.Find(idx) != INDEX_NONE)
			{
				RewardState.CleanUpReward(NewGameState);
				NewGameState.RemoveStateObject(RewardState.ObjectID);
                // Don't remove the reward from the list: this will shift the indices and cause ExcludeIndices to
                // match rewards it shouldn't. Note: This is a vanilla bug that still exists in DefaultMissionSources,
                // but we aren't using that code for LW Overhaul.
				//MissionState.Rewards.Remove(idx, 1);
				//idx--;
			}
		}
	}

	`LWTRACE ("GiveRewards 2");

	class'XComGameState_HeadquartersResistance'.static.SetRecapRewardString(NewGameState, MissionState.GetRewardAmountStringArray());

	// @mnauta: set VIP rewards string is deprecated, leaving blank
	class'XComGameState_HeadquartersResistance'.static.SetVIPRewardString(NewGameState, "" /*REWARDS!*/);

	// add the hard-coded POIToSpawn in MissionState, which we are keeping so that existing DLC/Mods can alter it
	if (MissionState.POIToSpawn.ObjectID > 0)
	{
		POIState = XComGameState_PointOfInterest(History.GetGameStateForObjectID(MissionState.POIToSpawn.ObjectID));

		if (POIState != none)
		{
			POIState = XComGameState_PointOfInterest(NewGameState.CreateStateObject(class'XComGameState_PointOfInterest', POIState.ObjectID));
			NewGameState.AddStateObject(POIState);
			POIState.Spawn(NewGameState);
		}
	}

	`LWTRACE ("GiveRewards 3");

	for(idx = 0; idx < MissionState.Rewards.Length; idx++)
	{
		`LWTRACE ("GiveRewards LOOP 1");

        // Skip excluded rewards.
    	if(ExcludeIndices.Find(idx) != INDEX_NONE)
		{
            continue;
        }

		`LWTRACE ("GiveRewards LOOP 2");

		RewardState = XComGameState_Reward(History.GetGameStateForObjectID(MissionState.Rewards[idx].ObjectID));

		// Give rewards
		if(RewardState != none)
		{
			`LWTRACE ("GiveReward Loop Applying Reward" @ RewardState.GetMyTemplateName());
			switch (RewardState.GetMyTemplateName())
			{
				case 'Reward_POI_LW':
					`LWTRACE("TRIGGER POI REWARD");
					SelectPOI(NewGameState, MissionState);
					break;
				case 'Reward_FacilityLead':
					AddItemRewardToLoot(RewardState, NewGameState);
					break;
				default:
					`LWTRACE("GiveRewards: Giving" @ RewardState.GetMyTemplateName());
					RewardState.GiveReward(NewGameState, MissionState.Region);
				break;
			}
		}
		// Remove the reward state objects
		NewGameState.RemoveStateObject(RewardState.ObjectID);
	}

	MissionState.Rewards.Length = 0;
}

static function AddItemRewardToLoot(XComGameState_Reward RewardState, XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item ItemState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	ItemState = XComGameState_Item(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));

	if(!XComHQ.PutItemInInventory(NewGameState, ItemState, true /* loot */))
	{
		NewGameState.PurgeGameStateForObjectID(XComHQ.ObjectID);
	}
	else
	{
		NewGameState.AddStateObject(XComHQ);
	}
}

static function array<int> GetRewardExcludeIndices(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local array<int> ExcludeIndices;
    local XComGameState_Unit Unit;
    local XComGameState_Reward Reward;
    local int i;

	History = `XCOMHISTORY;


	// remove and dead or left-behind reward units
    for (i = 0; i < MissionState.Rewards.Length; ++i)
    {
        Reward = XComGameState_Reward(History.GetGameStateForObjectID(MissionState.Rewards[i].ObjectID));
        Unit = XComGameState_Unit(History.GetGameStateForObjectID(Reward.RewardObjectReference.ObjectID));
		if (Unit != none)
		{
			if (Unit.IsDead() || !Unit.bRemovedFromPlay)
			{
				`LWTRACE ("Excluding Reward" @ Reward.GetMyTemplateName());
				ExcludeIndices.AddItem(i);
			}
		}
    }

	// give one or the other reward
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	for(i = 0; i < BattleData.MapData.ActiveMission.MissionObjectives.Length; i++)
	{
		if(BattleData.MapData.ActiveMission.MissionObjectives[i].ObjectiveName == 'Capture' &&
		   !BattleData.MapData.ActiveMission.MissionObjectives[i].bCompleted)
		{
			`LWTRACE ("Excluding Reward index 0 because VIP not captured");
			ExcludeIndices.AddItem(0);
		}
	}

	return ExcludeIndices;
}

static function bool MeetsAlertAndVigilanceReqs(X2LWAlienActivityTemplate Template, XComGameState_WorldRegion_LWStrategyAI RegionalAI)
{

	if (RegionalAI == none)
	{
		`LOG (Template.Dataname @ "No Regional AI found!");
	}

	if(Template.MaxVigilance > 0 && RegionalAI.LocalVigilanceLevel > Template.MaxVigilance)
		return false;

	if(Template.MinVigilance > 0 && RegionalAI.LocalVigilanceLevel < Template.MinVigilance)
		return false;

	if(Template.MaxAlert > 0 && RegionalAI.LocalAlertLevel > Template.MaxAlert)
		return false;

	if(Template.MinAlert > 0 && RegionalAI.LocalAlertLevel < Template.MinAlert)
		return false;

	return true;
}

static function bool RegionIsLiberated(XComGameState_WorldRegion RegionState, optional XComGameState NewGameState)
{
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);
	if(RegionalAI != none)
	{
		return RegionalAI.bLiberated;
	}
	//`REDSCREEN("RegionIsLiberated : Supplied Region " $ RegionState.GetMyTemplate().DataName $ " has no regional AI info");
	return false;

}

static function TDateTime GetCurrentTime()
{
	return class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
}

static function XComGameState_HeadquartersAlien GetAndAddAlienHQ(XComGameState NewGameState)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersAlien', AlienHQ)
	{
		break;
	}

	if(AlienHQ == none)
	{
		AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		NewGameState.AddStateObject(AlienHQ);
	}

	return AlienHQ;
}

static function XComGameState_MissionSite GetRebelRaidMissionSite(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState)
{
    local XComGameState_LWOutpost Outpost;
    local XComGameState_WorldRegion Region;
    local XComGameStateHistory History;
    local XComGameState_MissionSiteRebelRaid_LW RaidMission;
    local array<StateObjectReference> arrRebels;
    local int i;
    local int NumRebelsToChoose;
    local name RequiredJob;

    History = `XCOMHISTORY;

    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
    Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);

    switch(MissionFamily)
    {
        case 'IntelRaid_LW':
            RequiredJob = class'LWRebelJob_DefaultJobSet'.const.INTEL_JOB;
            break;
		case 'SupplyConvoy_LW':
            RequiredJob = class'LWRebelJob_DefaultJobSet'.const.SUPPLY_JOB;
            break;
		case 'RecruitRaid_LW':
			RequiredJob = class'LWRebelJob_DefaultJobSet'.const.RECRUIT_JOB;
            break;

        default:
            `Redscreen("GetRebelRaidMissionSite called for an unsupported family: " $ MissionFamily);
            // Not a supported mission.
            return XComGameState_MissionSite(NewGameState.CreateNewStateObject(class'XComGameState_MissionSite'));
    }

    for (i = 0; i < Outpost.Rebels.Length; ++i)
    {
        if (Outpost.Rebels[i].Job == RequiredJob)
        {
            arrRebels.AddItem(Outpost.Rebels[i].Unit);
        }
    }

    RaidMission = XComGameState_MissionSiteRebelRaid_LW(NewGameState.CreateNewStateobject(class'XComGameState_MissionSiteRebelRaid_LW'));

    NumRebelsToChoose = default.RAID_MISSION_MIN_REBELS +
        `SYNC_RAND_STATIC(default.RAID_MISSION_MAX_REBELS - default.RAID_MISSION_MIN_REBELS);
    NumRebelsToChoose = Min(NumRebelsToChoose, arrRebels.Length);

    while(NumRebelsToChoose > 0)
    {
        i = `SYNC_RAND_STATIC(arrRebels.Length);
        RaidMission.Rebels.AddItem(arrRebels[i]);
        arrRebels.Remove(i, 1);
        --NumRebelsToChoose;
    }

    // For recruit raids the rebels spawn with the squad and aren't armed. The others use the default spawn at objective.
    if (MissionFamily == 'RecruitRaid_LW')
    {
        RaidMission.SpawnType = eRebelRaid_SpawnWithSquad;
        RaidMission.ArmRebels = true;
    }

    return RaidMission;
}




defaultProperties
{
	ProtectRegionEarlyName="ProtectRegionEarly";
	ProtectRegionMidName="ProtectRegionMid";
    ProtectRegionName="ProtectRegion";
    CounterinsurgencyName="Counterinsurgency";
    ReinforceName="ReinforceActivity";
    COINResearchName="COINResearch";
    COINOpsName="COINOps";
    BuildResearchFacilityName="BuildResearchFacility";
    RegionalAvatarResearchName="RegionalAvatarResearch";
	ScheduledOffworldReinforcementsName="ScheduledOffworldReinforcements";
    EmergencyOffworldReinforcementsName="EmergencyOffworldReinforcements";
    SuperEmergencyOffworldReinforcementsName="SuperEmergencyOffworldReinforcements";
    RepressionName="Repression";
	InvasionName="Invasion";
    PropagandaName="Propaganda";
    ProtectResearchName="ProtectResearch";
    ProtectDataName="ProtectData";
    TroopManeuversName="TroopManeuvers";
    HighValuePrisonerName="HighValuePrisoner";
    PoliticalPrisonersName="PoliticalPrisoners";
	IntelRaidName="IntelRaid";
	SupplyConvoyName="SupplyConvoy";
	RecruitRaidName="RecruitRaid";
	FootholdName="Foothold";
    DebugMissionName="DebugMission";
	SnareName="Snare";
    RendezvousName="Rendezvous";
	LogisticsName="Logistics";

	RebelMissionsJob="Intel"


	Begin Object Class=X2LWActivityCondition_NumberActivities Name=DefaultSingleActivityInRegion
		MaxActivitiesInRegion=1
	End Object
	SingleActivityInRegion = DefaultSingleActivityInRegion;

	Begin Object Class=X2LWActivityCondition_NumberActivities Name=DefaultSingleActivityInWorld
		MaxActivitiesInWorld=1
	End Object
	SingleActivityInWorld = DefaultSingleActivityInWorld;

	Begin Object Class=X2LWActivityCondition_NumberActivities Name=DefaultTwoActivitiesInWorld
		MaxActivitiesInWorld=2
	End Object
	TwoActivitiesInWorld = DefaultTwoActivitiesInWorld;

	Begin Object Class=X2LWActivityCondition_RegionStatus Name=DefaultContactedAlienRegion
		bAllowInLiberated=false
		bAllowInContacted=true
		bAllowInUncontacted=false
	End Object
	ContactedAlienRegion = DefaultContactedAlienRegion;

	Begin Object Class=X2LWActivityCondition_RegionStatus Name=DefaultAnyAlienRegion
		bAllowInLiberated=false
		bAllowInContacted=true
		bAllowInUncontacted=true
	End Object
	AnyAlienRegion = DefaultAnyAlienRegion;

	Begin Object Class=X2LWActivityCondition_AlertVigilance Name=DefaultAlertGreaterThanVigilance
		MinAlertVigilanceDiff = -1
	End Object
	AlertGreaterThanVigilance=DefaultAlertGreaterThanVigilance

	Begin Object Class=X2LWActivityCondition_AlertVigilance Name=DefaultAlertAtLeastEqualtoVigilance
		MinAlertVigilanceDiff = 0
	End Object
	AlertAtLeastEqualtoVigilance=DefaultAlertAtLeastEqualtoVigilance

	Begin Object Class=X2LWActivityCondition_RestrictedActivity Name=DefaultGeneralOpsCondition
		CategoryNames(0)="GeneralOps"
		MaxRestricted_Category=2
	End Object
	GeneralOpsCondition = DefaultGeneralOpsCondition;

	Begin Object Class=X2LWActivityCondition_RestrictedActivity Name=DefaultRetalOpsCondition
		CategoryNames(0)="RetalOps"
		MaxRestricted_Category=1
	End Object
	RetalOpsCondition = DefaultRetalOpsCondition;

	Begin Object Class=X2LWActivityCondition_RestrictedActivity Name=DefaultLiberationCondition
		CategoryNames(0)="LiberationSequence"
		MaxRestricted_Category=1
	End Object
	LiberationCondition = DefaultLiberationCondition;
}
