//---------------------------------------------------------------------------------------
//  FILE:    X2LWAlienActivityTemplate.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Creates templates for Alien Activities, which alien strategy AI pursues, and XCOM tries to discover to generate missions
//---------------------------------------------------------------------------------------
class X2LWAlienActivityTemplate extends X2StrategyElementTemplate config(LW_Activities);

var config int HOURS_BETWEEN_ALIEN_ACTIVITY_MANAGER_UPDATES;
var config int HOURS_BETWEEN_ALIEN_ACTIVITY_DETECTION_UPDATES;

var localized string ActivityName;
var localized array<string> ActivityObjectives;

//this gives the possible missions and weights at a given level in the tree of possible branching missions
struct MissionLayerInfo
{
	var array<name> MissionFamilies;
	var float Duration_Hours;
	var float DurationRand_Hours;
	var float BaseInfiltrationModifier_Hours;
	var bool ForceActivityDetection;
	var bool AdvanceMissionOnDetection;
	var int EvacModifier;
};

//this defines the full tree of possible missions for a given activity
var config array<MissionLayerInfo> MissionTree;

struct ActivityMissionDescription
{
	var name MissionFamily;
	var string Description;
	var int MissionIndex;
	structdefaultproperties
	{
		MissionIndex = -1
	}
};

var localized array<ActivityMissionDescription> MissionDescriptions;

var config name ActivityCategory;

//modifiers to regional values if Typical delegate used
var config int ForceLevelModifier;
var config int AlertLevelModifier;

//conditions that can be used in creation functions
var config int MinAlert, MaxAlert;
var config int MinVigilance, MaxVigilance;

var config bool MakesDoom;

var X2LWActivityCreation ActivityCreation;	//these define the requirements for creating each activity
var X2LWActivityCooldown ActivityCooldown;

//these define the requirements for discovering each activity, based on the RebelJob "Intel"
var X2LWActivityDetectionCalc DetectionCalc;
var config float RequiredRebelMissionIncome;
var config float DiscoveryPctChancePerDayPerHundredMissionIncome;

//flag to allow the activity to occur even though the region has been liberated
var config bool CanOccurInLiberatedRegion;

//lower priority means the activity type is checked sooner for being created and detected
var int iPriority;

//required delegate functions
var Delegate<OnMissionSuccess> OnMissionSuccessFn;
var Delegate<OnMissionFailure> OnMissionFailureFn;

//optional delegate functions
var Delegate<OnActivityStarted> OnActivityStartedFn;

var Delegate<GetMissionRewards> GetMissionRewardsFn;
var Delegate<GetMissionDarkEvent> GetMissionDarkEventFn;
var Delegate<GetMissionForceLevel> GetMissionForceLevelFn;
var Delegate<GetMissionAlertLevel> GetMissionAlertLevelFn;
var Delegate<GetMissionSite> GetMissionSiteFn;

var Delegate<GetTimeUpdate> GetTimeUpdateFn;
var Delegate<UpdateModifierHours> UpdateModifierHoursFn;
var Delegate<OnActivityUpdate> OnActivityUpdateFn;
var Delegate<WasMissionSuccessful> WasMissionSuccessfulFn;
var Delegate<OnMissionCreated> OnMissionCreatedFn;
var Delegate<OnMissionExpire> OnMissionExpireFn;

var Delegate<CanBeCompleted> CanBeCompletedFn;
var Delegate<OnActivityCompleted> OnActivityCompletedFn;

// handles mission success, failure
delegate OnMissionSuccess(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState);
delegate OnMissionFailure(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState);

//OPTIONAL: Used to determine whether a given mission should have any rewards directly attached
delegate array<name> GetMissionRewards(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState);

//OPTIONAL: Used to determine whether a given mission shoud have a DarkEvent directly attached
delegate StateObjectReference GetMissionDarkEvent(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState);

//OPTIONAL: Used to set a custom XComGameState_MissionSite subclass for a particular mission
delegate XComGameState_MissionSite GetMissionSite(XComGameState_LWAlienActivity ActivityState, name MissionFamily, XComGameState NewGameState);

//OPTIONAL: Used to determine an activity's ForceLevel. If undefined, defaults to the regional ForceLevel.
delegate int GetMissionForceLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState);

//OPTIONAL: Used to determine an activity's AlertLevel. If undefined, defaults to the regional AlertLevel.
delegate int GetMissionAlertLevel(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionSite, XComGameState NewGameState);

//OPTIONAL: invoked during activity gamestate creation, allows handling of any further gamestate changes that result from activity creation
delegate OnActivityStarted(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState);

//OPTIONAL: Retrieves the next time an intermediate update to the activity should be performed
delegate TDateTime GetTimeUpdate(XComGameState_LWAlienActivity ActivityState, optional XComGameState NewGameState);

//OPTIIONAL: A modifier on when the activity will next update, computed dynamically
delegate int UpdateModifierHours(XComGameState_LWAlienActivity ActivityState, optional XComGameState NewGameState);

//OPTIONAL: Anything special to do when a mission is created
delegate OnMissionCreated(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState);

//OPTIONAL: Anything special to do when a mission expires
delegate OnMissionExpire(XComGameState_LWAlienActivity ActivityState, XComGameState_MissionSite MissionState, XComGameState NewGameState);

//OPTIONAL: Checks if a particular mission was successful -- defaults to OneStrategyObjectiveCompleted
delegate bool WasMissionSuccessful(XComGameState_LWAlienActivity AlienActivity, XComGameState_MissionSite MissionState, XComGameState_BattleData BattleDataState);

//OPTIONAL (linked with GetTimeUpdate) : performs any updates necessary when an intermediate update is triggered
delegate OnActivityUpdate(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState);

//OPTIONAL: invoked during activity gamestate creation, allows "locking" an activity to prevent completion despite timer elapsing
delegate bool CanBeCompleted(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState);

//OPTIONAL used during update once the activity has completed to apply any results to the gamestate
delegate OnActivityCompleted(bool bAlienSuccess, XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState);

function XComGameState_LWAlienActivity CreateInstanceFromTemplate(StateObjectReference PrimaryRegionRef, XComGameState NewGameState, optional MissionDefinition ForceMission)
{
	local XComGameState_LWAlienActivity ActivityState;

	ActivityState = XComGameState_LWAlienActivity(NewGameState.CreateNewStateObject(class'XComGameState_LWAlienActivity', self));
	if (Len(ForceMission.sType) > 0)
	{
		ActivityState.ForceMission = ForceMission;
	} 
	ActivityState.PostCreateInit(NewGameState, PrimaryRegionRef);

	return ActivityState;
}

// figures out duration for each mission and activity overall
function InstantiateActivityTimeline(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local X2LWAlienActivityTemplate Template;
	local int idx;
	local float TotalHoursToAdd;
	local XComGameState_DarkEvent DarkEventState;

	Template = ActivityState.GetMyTemplate();

	ActivityState.arrDuration_Hours.Length = Template.MissionTree.Length;
	for (idx = 0; idx < Template.MissionTree.Length ; idx++)
	{
		ActivityState.arrDuration_Hours[idx] = 500000;
		if (Template.MissionTree[idx].Duration_Hours > 0)
		{
			ActivityState.arrDuration_Hours[idx] = Template.MissionTree[idx].Duration_Hours;
			if (Template.MissionTree[idx].DurationRand_Hours > 0)
			{
				ActivityState.arrDuration_Hours[idx] += `SYNC_FRAND() * Template.MissionTree[idx].DurationRand_Hours;
			}
		}
		TotalHoursToAdd += ActivityState.arrDuration_Hours[idx];
	}
	// add time for a dark event if there is one, dark events are always attached to the last mission in a chain
	if (ActivityState.DarkEvent.ObjectID > 0)
	{
		DarkEventState = XComGameState_DarkEvent(NewGameState.GetGameStateForObjectID(ActivityState.DarkEvent.ObjectID));
		if (DarkEventState == none)
			DarkEventState = XComGameState_DarkEvent(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.DarkEvent.ObjectID));
		
		if (DarkEventState != none)
		{
			ActivityState.DarkEventDuration_Hours = 24.0 * DarkEventState.GetMyTemplate().MinActivationDays + `SYNC_RAND_STATIC (DarkEventState.GetMyTemplate().MaxActivationDays - DarkEventState.GetMyTemplate().MinActivationDays + 1);
			TotalHoursToAdd -= ActivityState.arrDuration_Hours[Template.MissionTree.Length - 1];
			ActivityState.arrDuration_Hours[Template.MissionTree.Length - 1] = ActivityState.DarkEventDuration_Hours;
			TotalHoursToAdd += ActivityState.DarkEventDuration_Hours;
		}
	}

	if (TotalHoursToAdd < 500000)
	{
		class'X2StrategyGameRulesetDataStructures'.static.CopyDateTime(ActivityState.DateTimeStarted, ActivityState.DateTimeActivityComplete);
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(ActivityState.DateTimeActivityComplete, TotalHoursToAdd); 
	}
	else
	{
		ActivityState.DateTimeActivityComplete.m_iYear = 2100;
	}
}

function bool ValidateTemplate(out string strError)
{
	//local X2MissionTemplateManager MissionTemplateManager;
	local MissionLayerInfo MissionLayer;
	local int MissionIdx;
	local name MissionFamilyName;
	local bool bFoundError;

	bFoundError = false;

	strError = "\n";
	//check that all defined mission types are valid
	//MissionTemplateManager = class'X2MissionTemplateManager'.static.GetMissionTemplateManager();
	foreach MissionTree(MissionLayer)
	{
		foreach MissionLayer.MissionFamilies(MissionFamilyName)
		{
			MissionIdx = class'XComTacticalMissionManager'.default.arrMissions.Find('MissionFamily', string(MissionFamilyName));
			if(MissionIdx == -1)
				MissionIdx = class'XComTacticalMissionManager'.default.arrMissions.Find('sType', string(MissionFamilyName));
			if(MissionIdx == -1)
			{
				strError $= "Mission Template '" $ MissionFamilyName $ "' is invalid\n";
				bFoundError = true;
			}
		}
	}

	if(DetectionCalc == none)
	{
		StrError $= "Missing required DetectionCalc\n";
		bFoundError = true;
	}
	if(ActivityCreation == none)
	{
		StrError $= "Missing required ActivityCreation\n";
		bFoundError = true;
	}
	//check for required delegates
	if(OnMissionSuccessFn == none)
	{
		StrError $= "Missing required delegate OnMissionSuccessFn\n";
		bFoundError = true;
	}
	if(OnMissionFailureFn == none)
	{
		StrError $= "Missing required delegate OnMissionFailureFn\n";
		bFoundError = true;
	}

	if(bFoundError)
		return false;

	return super.ValidateTemplate(strError);
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
	iPriority = 50
}