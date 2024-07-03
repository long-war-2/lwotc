//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWAlienActivity.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This models a single persistent alien activity, which can generate mission(s)
//---------------------------------------------------------------------------------------
class XComGameState_LWAlienActivity extends XComGameState_GeoscapeEntity config(LW_Overhaul);

struct LWRewardScalar
{
	var Name ActivityName;
	var float RewardScalar;
};

var protected name							m_TemplateName;
var protected X2LWAlienActivityTemplate		m_Template;

var TDateTime		DateTimeStarted;						// When the activity was created (by the Activity Manager)
var TDateTime		DateTimeNextUpdate;						// The next time an intermediate update is schedule (may be never)
var TDateTime		DateTimeActivityComplete;				// The time when the activity will complete (may be never)
var TDateTime		DateTimeNextDiscoveryUpdate;			// The next time the activity is scheduled to check to see if it has been discovered by player (generally ever 6 hours)
var TDateTime		DateTimeCurrentMissionStarted;			// Have to store the time when the mission started, because base-game doesn't keep track of that

var float			MissionResourcePool;					// a local pool of effort spent detecting this activity by the local resistance outpost

var int				Doom;									// doom collected in this activity

var StateObjectReference			PrimaryRegion;			// The region the activity is taking place in
var array<StateObjectReference>		SecondaryRegions;		// Options secondary regions the activity affects in some way

var bool						bNeedsAppearedPopup;		// Does this POI need to show its popup for appearing for the first time?
var bool						bDiscovered;				// Has this activity been discovered, and its mission chain started?
var bool						bMustLaunch;				// Has time run out on the current mission so player must launch/abort at next opportunity?
var bool						bNeedsExpiryWarning;		// Is a critical mission (like retal) about to expire?
var bool						bExpiryWarningShown;
var bool						bNeedsMissionCleanup;		// The mission should be deleted at the next safe opporunity
var bool						bNeedsPause;				// should pause geoscape at next opportunity
var bool						bNeedsUpdateMissionSuccess;  // the last mission succeeded, so update when we're back in geoscape
var bool						bNeedsUpdateMissionFailure;  // the last mission failed, so update when we're back in geoscape
var bool						bNeedsUpdateDiscovery;		// the mission was discovered while not in the geoscape, so needs to be detected now
var bool						bFailedFromMissionExpiration; // records that a mission failed because nobody went on it
var bool						bActivityComplete;			// an activity just completed, so need objectives UI update after submission
var StateObjectReference		CurrentMissionRef;			// The current mission in the chain, the one that is active
var int							CurrentMissionLevel;		// The depth in the activity's mission tree for the current mission
var GeneratedMissionData		CurrentMissionData;			// used only for accessing data, and matching

var StateObjectReference		DarkEvent;					//associated Dark Event, if any
var float						DarkEventDuration_Hours;	//randomized duration for the DarkEvent
var array<float>				arrDuration_Hours;			//randomized duration of all missions in the chain, filled out when activity is created

var MissionDefinition ForceMission;                         // A mission type to force to occur next.

// LWOTC: Allow configuration of which mission types the Chosen should be excluded from
var config array<string> ExcludeChosenFromMissionTypes;

var config array<string> GuaranteeChosenInMissionTypes;

var config array<string> NO_SIT_REP_MISSION_TYPES;

var StateObjectReference AssociatedChosen;

var config array<string> SlightlyLargeMaps;

var config array<string> LargeMaps;

var config array<string> VeryLargeMaps;

var config array<LWRewardScalar> ActivityRewardScalars;

//#############################################################################################
//----------------   REQUIRED FROM BASEOBJECT   -----------------------------------------------
//#############################################################################################

static function X2StrategyElementTemplateManager GetMyTemplateManager()
{
	return class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
}

simulated function name GetMyTemplateName()
{
	return m_TemplateName;
}

simulated function X2LWAlienActivityTemplate GetMyTemplate()
{
	if (m_Template == none)
	{
		m_Template = X2LWAlienActivityTemplate(GetMyTemplateManager().FindStrategyElementTemplate(m_TemplateName));
	}
	return m_Template;
}

event OnCreation(optional X2DataTemplate InitTemplate)
{
	m_Template = X2LWAlienActivityTemplate(InitTemplate);
	m_TemplateName = InitTemplate.DataName;
}

function PostCreateInit(XComGameState NewGameState, StateObjectReference PrimaryRegionRef)
{
	PrimaryRegion = PrimaryRegionRef;

	SecondaryRegions = m_Template.ActivityCreation.GetSecondaryRegions(NewGameState, self);

	if(m_Template.OnActivityStartedFn != none)
		m_Template.OnActivityStartedFn(self, NewGameState);

	DateTimeStarted = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();

	m_Template.InstantiateActivityTimeline(self, NewGameState);

	if(m_Template.GetTimeUpdateFn != none)
		DateTimeNextUpdate = m_Template.GetTimeUpdateFn(self);
	else
		DateTimeNextUpdate.m_iYear = 9999; // never updates

	if(m_Template.ActivityCooldown != none)
		m_Template.ActivityCooldown.ApplyCooldown(self, NewGameState);

	if (m_Template.MissionTree[0].ForceActivityDetection)
	{
		bDiscovered = true;
		bNeedsAppearedPopup = true;
	}
	SpawnMission (NewGameState); // this initial mission will typically be hidden

	DateTimeNextDiscoveryUpdate = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
}

//#############################################################################################
//----------------   UPDATE   -----------------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function bool Update(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local bool bUpdated;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local XComGameState_MissionSite MissionState;
	local TDateTime TempUpdateDateTime, ExpiryDateTime;

	History = `XCOMHISTORY;
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(CurrentMissionRef.ObjectID));

	bUpdated = false;
	ActivityTemplate = GetMyTemplate();

	//handle deferred success/failure from post-mission gamelogic, which can't place new missions because it needs geoscape data
	if(bNeedsUpdateMissionSuccess)
	{
		ActivityTemplate.OnMissionSuccessFn(self, MissionState, NewGameState);
		bNeedsUpdateMissionSuccess = false;
		bUpdated = true;
		MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(CurrentMissionRef.ObjectID)); // regenerate the MissionState in case it was changed
	}
	else if(bNeedsUpdateMissionFailure)
	{
		ActivityTemplate.OnMissionFailureFn(self, MissionState, NewGameState);
		bNeedsUpdateMissionFailure = false;
		bFailedFromMissionExpiration = false;
		bUpdated = true;
		MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(CurrentMissionRef.ObjectID)); // regenerate the MissionState in case it was changed
	}

	if (bRemoved)
	{
		return bUpdated;
	}

	//handle intermediate updates to an activity
	TempUpdateDateTime = DateTimeNextUpdate;
	if (ActivityTemplate.UpdateModifierHoursFn != none)
	{
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(TempUpdateDateTime, ActivityTemplate.UpdateModifierHoursFn(self, NewGameState));
	}

	if (class'X2StrategyGameRulesetDataStructures'.static.LessThan(TempUpdateDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()))
	{
		bUpdated = true;
		if(ActivityTemplate.OnActivityUpdateFn != none)
			ActivityTemplate.OnActivityUpdateFn(self, NewGameState);

		if(ActivityTemplate.GetTimeUpdateFn != none)
			DateTimeNextUpdate = ActivityTemplate.GetTimeUpdateFn(self, NewGameState);
	}

	// Warn if critical noninfiltrated missions are close to expiry
	ExpiryDateTime = MissionState.ExpirationDateTime;
	class'X2StrategyGameRulesetDataStructures'.static.RemoveHours(ExpiryDateTime, 3);
	if (!bExpiryWarningShown && MissionState != none &&
		class'Utilities_LW'.static.IsMissionRetaliation(MissionState.GetReference()) &&
		class'X2StrategyGameRulesetDataStructures'.static.LessThan(ExpiryDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()))
	{
		bUpdated = true;
		bNeedsExpiryWarning = true;
	}

	//handle activity current mission expiration -- regular expiration mechanism don't allow us to query player for one last chance to go on mission while infiltrating
	if (MissionState != none && class'X2StrategyGameRulesetDataStructures'.static.LessThan(MissionState.ExpirationDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()))
	{
		bUpdated = true;
		if(`LWSQUADMGR.GetSquadOnMission(CurrentMissionRef) == none)
		{
			bNeedsUpdateMissionFailure = true;
			bFailedFromMissionExpiration = true;
			if(ActivityTemplate.OnMissionExpireFn != none)
				ActivityTemplate.OnMissionExpireFn(self, MissionState, NewGameState);
		}
		else
		{
			bNeedsAppearedPopup = true;	// Need a mission pop-up at next opportunity
			bMustLaunch = true;			// And the player has to either abort or launch
		}
	}

	//handle activity expiration
	if (class'X2StrategyGameRulesetDataStructures'.static.LessThan(DateTimeActivityComplete, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()))
	{
		if(ActivityTemplate.CanBeCompletedFn == none || ActivityTemplate.CanBeCompletedFn(self, NewGameState))
		{
			bUpdated = true;
			if(CurrentMissionRef.ObjectID == 0 || `LWSQUADMGR.GetSquadOnMission(CurrentMissionRef) == none)
			{
				if(CurrentMissionRef.ObjectID > 0)  // there is a mission, but no squad attached to it
				{
					// If the mission expired during this cycle too we've already cleaned it up just above and
					// set the bNeedsUpdateMissionFailure flag. Don't do it again.
					if (!bNeedsUpdateMissionFailure)
					{
						// mark the current mission to expire
						bNeedsUpdateMissionFailure = true;
						if(ActivityTemplate.OnMissionExpireFn != none)
							ActivityTemplate.OnMissionExpireFn(self, MissionState, NewGameState);
					}
				}
				else // no active mission, so silently clean up the activity
				{
					if(ActivityTemplate.OnActivityCompletedFn != none)
					{
						ActivityTemplate.OnActivityCompletedFn(true/*Alien Success*/, self, NewGameState);
						bActivityComplete = true;
					}
					NewGameState.RemoveStateObject(ObjectID);
				}
			}
			else
			{
				// there is a squad, so they get one last chance to complete the current mission
				bNeedsAppearedPopup = true;	// Need a mission pop-up at next opportunity
				bMustLaunch = true;			// And the player has to either abort or launch
			}
		}
	}

	// handle activity discovery, which generates first mission.
	// Missions cannot be detected if we set the bNeedsUpdateMissionFailure flag above (e.g. because it just expired). They also can't be detected
	// if the entire activity just expired (which either set this same flag if there was a mission, or removed the activity if there wasn't a mission).
	// In either case, skip detection altogther. If the activity still exists and only the mission expired, we'll loop back through here next update
	// cycle and will either clean up the activity (returning early so we won't get here) or generate a new mission in the chain (in which case we may
	// detect that one).
	if (!bNeedsUpdateMissionFailure && !bRemoved &&
		(bNeedsUpdateDiscovery || (!bDiscovered && class'X2StrategyGameRulesetDataStructures'.static.LessThan(DateTimeNextDiscoveryUpdate, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()))))
	{
		bUpdated = true;
		if(bNeedsUpdateDiscovery || (ActivityTemplate.DetectionCalc != none && ActivityTemplate.DetectionCalc.CanBeDetected(self, NewGameState)))
		{
			if (ActivityTemplate.MissionTree[CurrentMissionLevel].AdvanceMissionOnDetection)
			{
				if (MissionState != none) // clean up any existing mission -- we assume here that it's not possible for it to be infiltrated
				{
					if (MissionState.POIToSpawn.ObjectID > 0)
					{
						class'XComGameState_HeadquartersResistance'.static.DeactivatePOI(NewGameState, MissionState.POIToSpawn);
					}
					MissionState.RemoveEntity(NewGameState);
					MissionState = none;
					CurrentMissionRef.ObjectID = 0; 
				}
				CurrentMissionLevel++;
			}
			bDiscovered = true;
			bNeedsAppearedPopup = true;
			bNeedsUpdateDiscovery = false;
			if (MissionState == none)
			{
				SpawnMission(NewGameState);
			}
			else
			{
				MissionState = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', MissionState.ObjectID));
				MissionState.Available = true;
				NewGameState.AddStateObject(MissionState); 
			}
		}
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(DateTimeNextDiscoveryUpdate, class'X2LWAlienActivityTemplate'.default.HOURS_BETWEEN_ALIEN_ACTIVITY_DETECTION_UPDATES);
	}

	return bUpdated;
}

//---------------------------------------------------------------------------------------
function UpdateGameBoard()
{
	local XComGameState NewGameState;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameStateHistory History;
	local UIStrategyMap StrategyMap;
	local bool ShouldPause, UpdateObjectiveUI;
	local XGGeoscape Geoscape;

	StrategyMap = `HQPRES.StrategyMap2D;
	if (StrategyMap != none && StrategyMap.m_eUIState != eSMS_Flight)
	{
		History = `XCOMHISTORY;
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Alien Activities");
		ActivityState = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', ObjectID));
		NewGameState.AddStateObject(ActivityState);

		if (!ActivityState.Update(NewGameState))
		{
			NewGameState.PurgeGameStateForObjectID(ActivityState.ObjectID);
		}
		else
		{
			ShouldPause = ActivityState.bNeedsPause;
			ActivityState.bNeedsPause = false;
			UpdateObjectiveUI = ActivityState.bActivityComplete;
			ActivityState.bActivityComplete = false;
		}
		if (NewGameState.GetNumGameStateObjects() > 0)
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		else
			History.CleanupPendingGameState(NewGameState);

		if (ActivityState.bNeedsAppearedPopup && !ActivityState.bRemoved)
		{
			if(ActivityState.bMustLaunch)
			{
				ActivityState.SpawnInfiltrationUI();
			}
			else
			{
				ActivityState.SpawnMissionPopup();
			}
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Toggle Mission Appeared Popup");
			ActivityState = XComGameState_LWAlienActivity(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivity', ObjectID));
			NewGameState.AddStateObject(ActivityState);
			ActivityState.bNeedsAppearedPopup = false;
			ActivityState.bMustLaunch = false;
			`XEVENTMGR.TriggerEvent('NewMissionAppeared', , ActivityState, NewGameState);
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
		else if (ActivityState.bNeedsExpiryWarning && !ActivityState.bExpiryWarningShown)
		{
			`HQPRES.UITimeSensitiveMission(XComGameState_MissionSite(History.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID)));

			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Expiry Warning Shown");
			ActivityState = XComGameState_LWAlienActivity(NewGameState.ModifyStateObject(class'XComGameState_LWAlienActivity', ObjectID));
			ActivityState.bNeedsExpiryWarning = false;
			ActivityState.bExpiryWarningShown = true;
			ShouldPause = true;
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}

		if (ShouldPause)
		{
			Geoscape = `GAME.GetGeoscape();
			Geoscape.Pause();
			Geoscape.Resume();
			ShouldPause = false;
		}
		if (UpdateObjectiveUI)
		{
			class'X2StrategyGameRulesetDataStructures'.static.ForceUpdateObjectivesUI(); // this is to clean up "IN PROGRESS" after gamestate submission
		}
	}
}

function SpawnInfiltrationUI()
{
	local UIMission_LWLaunchDelayedMission MissionScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;
	MissionScreen = HQPres.Spawn(class'UIMission_LWLaunchDelayedMission', HQPres);
	MissionScreen.MissionRef = CurrentMissionRef;
	MissionScreen.bInstantInterp = false;
	MissionScreen = UIMission_LWLaunchDelayedMission(HQPres.ScreenStack.Push(MissionScreen));
}

function SpawnMissionPopup()
{
	local XComGameState_MissionSite MissionState;
	local XComHQPresentationLayer HQPres;
	local DynamicPropertySet PropertySet;

	HQPres = `HQPRES;

	if(CurrentMissionRef.ObjectID > 0)
		MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(CurrentMissionRef.ObjectID));

	if(MissionState == none)
		return;

	HQPres.BuildUIAlert(
			PropertySet,
			GetAlertType(MissionState),
			MissionAlertCB,
			GetEventToTrigger(MissionState),
			GetSoundToPlay(MissionState));
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicIntProperty(PropertySet, 'MissionRef', MissionState.ObjectID);
	HQPres.QueueDynamicPopup(PropertySet);
}

simulated function MissionAlertCB(Name eAction, out DynamicPropertySet AlertData, optional bool bInstant = false)
{
	if (eAction == 'eUIAction_Accept')
	{
		if (UIMission(`HQPRES.ScreenStack.GetCurrentScreen()) == none)
		{
			TriggerMissionUI(XComGameState_MissionSite(`DYNAMIC_ID_PROP(AlertData, 'MissionRef')));
		}

		if (`GAME.GetGeoscape().IsScanning())
			`HQPRES.StrategyMap2D.ToggleScan();
	}
}

function float SecondsRemainingCurrentMission()
{
	local XComGameState_MissionSite MissionState;
	local float SecondsInMission, SecondsInActivity;
	local float TotalSeconds;

	if(CurrentMissionRef.ObjectID >= 0)
	{
		MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(CurrentMissionRef.ObjectID));

		if (MissionState.ExpirationDateTime.m_iYear >= 2050)
			SecondsInMission = 2147483640;
		else
			SecondsInMission = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(MissionState.ExpirationDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime());
		
		if (DateTimeActivityComplete.m_iYear >= 2050)
			SecondsInActivity = 2147483640;
		else
			SecondsInActivity = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(DateTimeActivityComplete, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime());

		TotalSeconds = FMin(SecondsInMission, SecondsInActivity);
	}
	else  // no current mission
	{
		TotalSeconds = -1;
	}

	return TotalSeconds;
}

function int PercentCurrentMissionComplete()
{
	local XComGameState_MissionSite MissionState;
	local XComGameStateHistory History;
	local int TotalSeconds, RemainingSeconds, PctRemaining;

	History = `XCOMHISTORY;
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(CurrentMissionRef.ObjectID));
	PctRemaining = 0;
	if(MissionState.ExpirationDateTime.m_iYear < 2100)
	{
		TotalSeconds = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(MissionState.ExpirationDateTime, MissionState.TimerStartDateTime);
		RemainingSeconds = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours(class'UIUtilities_Strategy'.static.GetGameTime().CurrentTime, MissionState.TimerStartDateTime);
		PctRemaining = int(float(RemainingSeconds) / float(TotalSeconds) * 100.0);
	}
	return PctRemaining;
}

function bool SpawnMission(XComGameState NewGameState)
{
	local name RewardName;
	local array<name> RewardNames;
	local XComGameState_Reward RewardState;
	local X2RewardTemplate RewardTemplate;
	local X2StrategyElementTemplateManager StratMgr;
	local array<XComGameState_Reward> MissionRewards;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local XComGameState_MissionSite MissionState;
	local X2MissionSourceTemplate MissionSource;
	local XComGameState_WorldRegion PrimaryRegionState;
	local bool bExpiring, bHasPOIReward;
	local int idx;
	local Vector2D v2Loc;
	local name MissionFamily;
	local float SecondsUntilActivityComplete, DesiredSecondsOfMissionDuration, RewardScalar;
	local XComGameState_HeadquartersResistance ResHQ;

	MissionFamily = GetNextMissionFamily(NewGameState);
	`LWTrace("Mission Family selected:" @MissionFamily);
	if(MissionFamily == '')
		return false;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	PrimaryRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(PrimaryRegion.ObjectID));
	if(PrimaryRegionState == none)
		PrimaryRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(PrimaryRegion.ObjectID));

	if(PrimaryRegionState == none)
		return false;

	ActivityTemplate = GetMyTemplate();

	// Generate the mission reward
	if(ActivityTemplate.GetMissionRewardsFn != none)
		RewardNames = ActivityTemplate.GetMissionRewardsFn(self, MissionFamily, NewGameState);
	else
		RewardNames[0] = 'Reward_None';

	idx = RewardNames.Find('Reward_POI_LW');
	if (idx != -1) // if there is a reward POI, peel it off and attach it to the MissionState so that DLCs can modify it to insert optional content
	{
		bHasPOIReward = true;
		RewardNames.Remove(idx, 1); // peel off the first Reward_POI, since base-game only supports one per mission.
	}

	idx = default.ActivityRewardScalars.Find('ActivityName', ActivityTemplate.DataName);

	if(idx != INDEX_NONE)
	{
		RewardScalar = ActivityRewardScalars[idx].RewardScalar;
	}
	else
	{
		RewardScalar = 1.0;
	}

	foreach RewardNames(RewardName)
	{
		RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate(RewardName)); 
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		RewardState.GenerateReward(NewGameState, RewardScalar /*reward scalar */ , PrimaryRegion);
		MissionRewards.AddItem(RewardState);
	}

	// use a generic mission source that will link back to the activity
	MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_LWSGenericMissionSource'));

	//set false so missions don't auto-expire and get cleaned up before we give player last chance to taken them on, if infiltrated
	bExpiring = false;

	//calculate mission location
	v2Loc = PrimaryRegionState.GetRandom2DLocationInRegion();
	if(v2Loc.x == -1 && v2Loc.y == -1)
	{
		
	}
    
    // Build Mission, region and loc will be determined later so defer computing biome/plot data
    if (ActivityTemplate.GetMissionSiteFn != none)
        MissionState = ActivityTemplate.GetMissionSiteFn(self, MissionFamily, NewGameState);
    else
		MissionState = XComGameState_MissionSite(NewGameState.CreateNewStateObject(class'XComGameState_MissionSite'));

	// Add Dark Event if appropriate
	if(ActivityTemplate.GetMissionDarkEventFn != none)
		MissionState.DarkEvent = ActivityTemplate.GetMissionDarkEventFn(self, MissionFamily, NewGameState);

	MissionState.BuildMission(MissionSource,
									 v2Loc, 
									 PrimaryRegion, 
									 MissionRewards, 
									 bDiscovered, /*bAvailable*/
									 bExpiring, 
									 , /* Integer Hours Duration */
									 0, /* Integer Seconds Duration */
									 , /* bUseSpecifiedLevelSeed */
									 , /* LevelSeedOverride */
									 false /* bSetMissionData */
							   );

	//manually set the expiration time since we aren't setting the Expires flag true
	if (DateTimeActivityComplete.m_iYear >= 2090)
		SecondsUntilActivityComplete = 2147483640;
	else
		SecondsUntilActivityComplete = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(DateTimeActivityComplete, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime());
	DesiredSecondsOfMissionDuration = 3600.0 * (arrDuration_Hours[CurrentMissionLevel] > 0 ? arrDuration_Hours[CurrentMissionLevel] : 500000.0);
	MissionState.TimeUntilDespawn = FMin(SecondsUntilActivityComplete, DesiredSecondsOfMissionDuration);
	MissionState.ExpirationDateTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
	class'X2StrategyGameRulesetDataStructures'.static.AddTime(MissionState.ExpirationDateTime, MissionState.TimeUntilDespawn);

	MissionState.bMakesDoom = ActivityTemplate.MakesDoom;

	//add a POI to the mission state if one was specified earlier
	if (bHasPOIReward)
	{
		ResHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
		MissionState.POIToSpawn = ResHQ.ChoosePOI(NewGameState);
	}

	if(MissionState == none)
	{
		`REDSCREEN("XCGS_LWAlienActivity : Unable to create mission");
		return false;
	}
	// Use a custom implemention of XCGS_MissionSite.SetMissionData to set mission family based on something other than reward
	SetMissionData(MissionFamily, MissionState, MissionRewards[0].GetMyTemplate(), NewGameState, false, 0);

	//store off the mission so we can match it after tactical mission complete
	CurrentMissionRef = MissionState.GetReference();

	DateTimeCurrentMissionStarted = class'UIUtilities_Strategy'.static.GetGameTime().CurrentTime;

	if(ActivityTemplate.OnMissionCreatedFn != none)
		ActivityTemplate.OnMissionCreatedFn(self, MissionState, NewGameState);

	return true;
} 

function name GetNextMissionFamily(XComGameState NewGameState)
{
	local X2LWAlienActivityTemplate ActivityTemplate;
	local array<name> PossibleMissionFamilies;
	local array<int> ExistingMissionFamilyCounts, SelectArray;
	local XComGameState_MissionSite MissionSite;
	local int idx, i, j, FamilyIdx;
	local name MissionFamily;

	ActivityTemplate = GetMyTemplate();
	if (CurrentMissionLevel >= ActivityTemplate.MissionTree.Length)
		return '';

	PossibleMissionFamilies = ActivityTemplate.MissionTree[CurrentMissionLevel].MissionFamilies;

	`LWTrace("Possible Mission Families:");
	foreach PossibleMIssionFamilies (MissionFamily)
	{
		`LWTrace(MissionFamily);
	}

	if(PossibleMissionFamilies.Length > 0)
	{
		//count up how many visible missions there are of each type currently -- this more complex selection logic is to fix ID 713
		ExistingMissionFamilyCounts.length = PossibleMissionFamilies.length;
		foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_MissionSite', MissionSite)
		{
			if (MissionSite.Available)
			{
				idx = PossibleMissionFamilies.Find(name(MissionSite.GeneratedMission.Mission.MissionFamily));
				if (idx != -1)
				{
					ExistingMissionFamilyCounts[idx]++;
				}
			}
		}

		//set up a selection array where each instance of a mission family gets a single entry
		for (i = 0; i < ExistingMissionFamilyCounts.length; i++)
		{
			SelectArray.AddItem(i); // add one of each so that missions with 0 elements can still be selected
			for (j = 0; j < ExistingMissionFamilyCounts[i]; j++)
			{
				SelectArray.AddItem(i);
			}
		}

		if (SelectArray.length == 0)
		{
			return PossibleMissionFamilies[`SYNC_RAND_STATIC(PossibleMissionFamilies.length)];
		}
		else
		{
			while (SelectArray.length > 0)
			{
				FamilyIdx = SelectArray[`SYNC_RAND_STATIC(SelectArray.length)];  // randomly pick a mission family index from the SelectArray -- more represented missions are more likely to be selected
				SelectArray.RemoveItem(FamilyIdx); // removes all instances of that family index
			}
			return PossibleMissionFamilies[FamilyIdx]; // return the very last family to be removed
		}
	}
	return '';
}

// WOTC TODO: There has to be a better way to implement this than copy all the
// relevant code from XComGameState_MissionSite with a few changes!
function SetMissionData(name MissionFamily, XComGameState_MissionSite MissionState, X2RewardTemplate MissionReward, XComGameState NewGameState, bool bUseSpecifiedLevelSeed, int LevelSeedOverride)
{
	local GeneratedMissionData EmptyData;
	local XComTacticalMissionManager MissionMgr;
	local XComParcelManager ParcelMgr;
	local string Biome, MapName;
	// LWOTC vars
	local XComHeadquartersCheatManager CheatManager;
	local X2MissionSourceTemplate MissionSource;
	local PlotDefinition SelectedPlotDef;
	local PlotTypeDefinition PlotTypeDef;
	local array<name> SourceSitReps;
	local name SitRepName, SitrepNameToRemove;
	local array<name> SitRepNames, SitrepsToRemove;
	local String AdditionalTag;
	// End LWOTC vars
	// Variables for Issue #157
	local array<X2DownloadableContentInfo> DLCInfos; 
	local int i; 
	// Variables for Issue #157

	MissionMgr = `TACTICALMISSIONMGR;
	ParcelMgr = `PARCELMGR;

	MissionState.GeneratedMission = EmptyData;
	MissionState.GeneratedMission.MissionID = MissionState.ObjectID;

    if (Len(ForceMission.sType) > 0)
    {
        // Force this mission to the desired type and then un-set the force mission type
        // so any subsequent missions are as normal.
        MissionState.GeneratedMission.Mission = ForceMission;
        ForceMission.sType = "";
    }
    else
    {
        MissionState.GeneratedMission.Mission = GetMissionDefinitionForFamily(MissionFamily);
    }

	MissionState.GeneratedMission.LevelSeed = (bUseSpecifiedLevelSeed) ? LevelSeedOverride : class'Engine'.static.GetEngine().GetSyncSeed();
	MissionState.GeneratedMission.BattleDesc = "";

	// Does this mission type disallow sit reps?
	if (NO_SIT_REP_MISSION_TYPES.Find(MissionState.GeneratedMission.Mission.sType) != INDEX_NONE)
		MissionState.bForceNoSitRep = true;

	// LWOTC - copied from WOTC `XComGameState_MissionSite.SetMissionData()`
	//
	// This block basically adds support for adding SitReps
	MissionState.GeneratedMission.SitReps.Length = 0;
	SitRepNames.Length = 0;

	// Add additional required plot objective tags
	foreach MissionState.AdditionalRequiredPlotObjectiveTags(AdditionalTag)
	{
		MissionState.GeneratedMission.Mission.RequiredPlotObjectiveTags.AddItem(AdditionalTag);
	}

	MissionState.GeneratedMission.SitReps = MissionState.GeneratedMission.Mission.ForcedSitreps;
	SitRepNames = MissionState.GeneratedMission.Mission.ForcedSitreps;

	// Add Forced SitReps from Cheats
	CheatManager = XComHeadquartersCheatManager(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().CheatManager);
	if (CheatManager != none && CheatManager.ForceSitRepTemplate != '')
	{
		MissionState.GeneratedMission.SitReps.AddItem(CheatManager.ForceSitRepTemplate);
		SitRepNames.AddItem(CheatManager.ForceSitRepTemplate);
		CheatManager.ForceSitRepTemplate = '';
	}
	else if (!MissionState.bForceNoSitRep)
	{
		// No cheats, add SitReps from the Mission Source
		MissionSource = MissionState.GetMissionSource();

		if (MissionSource.GetSitrepsFn != none)
		{
			SourceSitReps = MissionSource.GetSitrepsFn(MissionState);

			foreach SourceSitReps(SitRepName)
			{
				if (MissionState.GeneratedMission.SitReps.Find(SitRepName) == INDEX_NONE)
				{
					MissionState.GeneratedMission.SitReps.AddItem(SitRepName);
					SitRepNames.AddItem(SitRepName);
				}
			}
		}
	}
	// End LWOTC additions

	`LWTrace("Mission Creation choosing quest item");

	MissionState.GeneratedMission.MissionQuestItemTemplate = MissionMgr.ChooseQuestItemTemplate(MissionState.Source, MissionReward, MissionState.GeneratedMission.Mission, (MissionState.DarkEvent.ObjectID > 0));

	if(MissionState.GeneratedMission.Mission.sType == "")
	{
		`Redscreen("GetMissionDefinitionForFamily() failed to generate a mission with: \n"
						$ " Family: " $ MissionFamily);
	}
	`LWTrace("Mission Generation choosing plot and biome");

	// find a plot that supports the biome and the mission
	SelectBiomeAndPlotDefinition(MissionState, Biome, SelectedPlotDef, SitrepsToRemove, SitRepNames);

	// do a weighted selection of our plot
	MissionState.GeneratedMission.Plot = SelectedPlotDef;
	MissionState.GeneratedMission.Biome = ParcelMgr.GetBiomeDefinition(Biome);
	`LWTrace(" >>> Selected plot " $ SelectedPlotDef.MapName $ " (" $ SelectedPlotDef.strType $ ") for mission " $
		MissionState.GeneratedMission.Mission.MissionName);

	// Add SitReps forced by Plot Type
	// Make sure The Lost are added to Abandoned City plots
	PlotTypeDef = ParcelMgr.GetPlotTypeDefinition(MissionState.GeneratedMission.Plot.strType);

	// Clear invalid sitreps
	`LWTrace("SitrepsToRemove length:" @SitrepsToRemove.Length);
	if(SitrepsToRemove.Length > 0)
	{
		foreach SitrepsToRemove (SitrepNameToRemove)
		{
			`LWTrace("Removing invalid Sitrep" @SitrepNameToRemove);
			SitrepNames.RemoveItem(SitrepNameToRemove);
			MissionState.GeneratedMission.SitReps.RemoveItem(SitrepNameToRemove);
		}
	}

	foreach PlotTypeDef.ForcedSitReps(SitRepName)
	{
		// Make sure the sit rep is actually valid for the mission!
		if (!class'X2StrategyElement_LWMissionSources'.static.IsSitRepValidForMission(SitRepName, MissionState))
		{
			continue;
		}

		// Don't add TheLost SitRep if TheHorde is also active
		if (MissionState.GeneratedMission.SitReps.Find(SitRepName) == INDEX_NONE &&
			(SitRepName != 'TheLost' || MissionState.GeneratedMission.SitReps.Find('TheHorde') == INDEX_NONE))
		{
			MissionState.GeneratedMission.SitReps.AddItem(SitRepName);
		}
	}

	MapName = MissionState.GeneratedMission.Plot.MapName;
	// Add sit reps for large and very large maps for fixed evac missions that
	// have an evac timer rather than an objective timer.
	if (class'UIUtilities_LW'.default.FixedExitMissions.Find(MissionState.GeneratedMission.Mission.MissionName) != INDEX_NONE &&
		class'UIUtilities_LW'.default.EvacTimerMissions.Find(MissionState.GeneratedMission.Mission.MissionName) != INDEX_NONE)
	{
		if (instr(MapName, "vlgObj") != INDEX_NONE)
		{
			MissionState.GeneratedMission.SitReps.AddItem('VeryLargeMap');
		}
		else if (instr(MapName, "LgObj") != INDEX_NONE)
		{
			MissionState.GeneratedMission.SitReps.AddItem('LargeMap');
		}
		else if (inStr(MapName,"EZR") != INDEX_NONE && inStr(MapName,"CTY") != INDEX_NONE )
		{
			// Catch Eclipsezr city maps.
			MissionState.GeneratedMission.SitReps.AddItem('LargeMap');
		}
		else if (default.LargeMaps.Find(MapName)!= INDEX_NONE)
		{
			MissionState.GeneratedMission.SitReps.AddItem('LargeMap');
		}
		else if (default.VeryLargeMaps.Find(MapName) != INDEX_NONE)
		{
			MissionState.GeneratedMission.SitReps.AddItem('VeryLargeMap');
		}
		
	}
	else if (default.SlightlyLargeMaps.Find(MapName) != INDEX_NONE) // added here specificaly for psi transmitter and the sewers map.
	{
		MissionState.GeneratedMission.SitReps.AddItem('SlightlyLargeMap');
	}

	// Start Issue #157
	DLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);
	for(i = 0; i < DLCInfos.Length; ++i)
	{
		DLCInfos[i].PostSitRepCreation(MissionState.GeneratedMission, self);
	}
	// End Issue #157

	// Now that all sitreps have been chosen, add any sitrep tactical tags to the mission list
	MissionState.UpdateSitrepTags();

	// Add the Chosen to the mission if required. We do this after the sit
	// reps are set up to ensure we don't get Chosen and Rulers together.
	MaybeAddChosenToMission(MissionState);

	// the plot we find should either have no defined biomes, or the requested biome type
	//`assert( (GeneratedMission.Plot.ValidBiomes.Length == 0) || (GeneratedMission.Plot.ValidBiomes.Find( Biome ) != -1) );
	if (MissionState.GeneratedMission.Plot.ValidBiomes.Length > 0)
	{
		MissionState.GeneratedMission.Biome = ParcelMgr.GetBiomeDefinition(Biome);
	}

	if(MissionState.GetMissionSource().BattleOpName != "")
	{
		MissionState.GeneratedMission.BattleOpName = MissionState.GetMissionSource().BattleOpName;
	}
	else
	{
		MissionState.GeneratedMission.BattleOpName = class'XGMission'.static.GenerateOpName(false);
	}

	MissionState.GenerateMissionFlavorText();
}

function MissionDefinition GetMissionDefinitionForFamily(name MissionFamily)
{
	local X2CardManager CardManager;
	local MissionDefinition MissionDef;
	local array<string> DeckMissionTypes;
	local string MissionType;
	local XComTacticalMissionManager MissionMgr;

	MissionMgr = `TACTICALMISSIONMGR;
	// LWOTC: Testing this line to see whether it helps even out the
	// plots selected for missions so players don't see the same two
	// types of plot all the time.
	MissionMgr.CacheMissionManagerCards();  
	CardManager = class'X2CardManager'.static.GetCardManager();

	// now that we have a mission family, determine the mission type to use
	CardManager.GetAllCardsInDeck('MissionTypes', DeckMissionTypes);
	foreach DeckMissionTypes(MissionType)
	{
		if(MissionMgr.GetMissionDefinitionForType(MissionType, MissionDef))
		{
			if(MissionDef.MissionFamily == string(MissionFamily) 
				|| (MissionDef.MissionFamily == "" && MissionDef.sType == string(MissionFamily))) // missions without families are their own family
			{
				CardManager.MarkCardUsed('MissionTypes', MissionType);
				return MissionDef;
			}
		}
	}

	`Redscreen("AlienActivity: Could not find a mission type for MissionFamily: " $ MissionFamily);
	return MissionMgr.arrMissions[0];
}

// Decides whether to add a Chosen to the given mission and if it does choose
// to do so, it adds LWOTC-specific Chosen tactical tags to the mission state
// and updates the given alert level.
static function MaybeAddChosenToMission(XComGameState_MissionSite MissionState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local XComGameState_AdventChosen ChosenState;

	// If Chosen are disabled, skip adding the tag.
	if (`SecondWaveEnabled('DisableChosen'))
	{
		return;
	}

	// Don't allow Chosen on the mission if there is already a Ruler
	if (class'XComGameState_AlienRulerManager' != none && class'LWDLCHelpers'.static.IsAlienRulerOnMission(MissionState))
	{
		return;
	}

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_HeadquartersAlien', AlienHQ)
	{
		break;
	}

	if (AlienHQ.bChosenActive)
	{
		AllChosen = AlienHQ.GetAllChosen(, true);

		foreach AllChosen(ChosenState)
		{
			if (ChosenState.bDefeated)
			{
				continue;
			}

			// Decide whether this Chosen will appear on this mission.
			if (WillChosenAppearOnMission(ChosenState, MissionState))
			{
				`LWTrace("    Chosen added!");
				MissionState.TacticalGameplayTags.AddItem(class'Helpers_LW'.static.GetChosenActiveMissionTag(ChosenState));
				MissionState.GeneratedMission.Sitreps.AddItem('ChosenOnMissionSitrep');
				// Only one Chosen on the mission!
				break;
			}
		}
	}
}

// Returns whether the given Chosen will appear on the given mission.
static function bool WillChosenAppearOnMission(XComGameState_AdventChosen ChosenState, XComGameState_MissionSite MissionState)
{
	local XComGameState_MissionSiteChosenAssault ChosenAssaultMission;

	`LWTrace("Checking Chosen" @ChosenState.GetChosenTemplate().CharacterGroupName);

	// If the Chosen doesn't control the region, they won't appear on the mission
	if (!ChosenState.ChosenControlsRegion(MissionState.Region))
	{
		return false;
	}
	
	//Check if the mission is chosen avenger defense, if yes than add that
	ChosenAssaultMission = XComGameState_MissionSiteChosenAssault(MissionState);
	if (ChosenAssaultMission != none)
	{
		if (ChosenState.GetReference() == ChosenAssaultMission.AttackingChosen)
		{
			return true;
		}
	}

	if (class'XComGameState_LWAlienActivity'.default.ExcludeChosenFromMissionTypes.Find(MissionState.GeneratedMission.Mission.sType) != INDEX_NONE)
	{
		// Can't be on this mission no matter what
		`LWTrace("Chosen can't be added to missions of type" @ MissionState.GeneratedMission.Mission.sType);
		return false;
	}
	else if (class'XComGameState_LWAlienActivity'.default.GuaranteeChosenInMissionTypes.Find(MissionState.GeneratedMission.Mission.sType) != INDEX_NONE)
	{
		// Guaranteed on this mission
		return true;
	}
	else
	{
		return false;
	}
}

//---------------------------------------------------------------------------------------
// Code (next 3 functions) copied from XComGameState_MissionSite
//
function SelectBiomeAndPlotDefinition(XComGameState_MissionSite MissionState, out string Biome, out PlotDefinition SelectedDef, out array<name>SitrepsToRemove,  optional array<name> SitRepNames)
{
	local MissionDefinition MissionDef;
	local array<string> ExcludeBiomes;

	ExcludeBiomes.Length = 0;

	MissionDef = MissionState.GeneratedMission.Mission;
	Biome = SelectBiome(MissionState, ExcludeBiomes);

	`LWTrace("Selected biome:" @Biome);

	while(!SelectPlotDefinition(MissionDef, Biome, SelectedDef, ExcludeBiomes, SitRepNames))
	{
		Biome = SelectBiome(MissionState, ExcludeBiomes);

		if(Biome == "")
		{
			ExcludeBiomes.Length = 0;
			Biome = SelectBiome(MissionState, ExcludeBiomes);
			`LWTrace("Could not find a valid plot for current Sitrep combination, adjusting sitreps instead");
			SelectAlternatePlotDef(MissionDef, Biome, SelectedDef, ExcludeBiomes, SitrepsToRemove, SitRepNames);
			return;
		}
	}

	`LWDebug("Selected plot '" $ SelectedDef.MapName $ "' with biome '" $ Biome $ "'");
}

//---------------------------------------------------------------------------------------
function string SelectBiome(XComGameState_MissionSite MissionState, out array<string> ExcludeBiomes)
{
	local string Biome;
	local int TotalValue, RollValue, CurrentValue, idx, BiomeIndex;
	local array<BiomeChance> BiomeChances;
	local string TestBiome;

	if (MissionState.GeneratedMission.Mission.ForcedBiome != "")
	{
		return MissionState.GeneratedMission.Mission.ForcedBiome;
	}

	// Grab Biome from location
	Biome = class'X2StrategyGameRulesetDataStructures'.static.GetBiome(MissionState.Get2DLocation());

	if (ExcludeBiomes.Find(Biome) != INDEX_NONE)
	{
		Biome = "";
	}

	// Grab "extra" biomes which we could potentially swap too (used for Xenoform)
	BiomeChances = class'X2StrategyGameRulesetDataStructures'.default.m_arrBiomeChances;

	// Not all plots support these "extra" biomes, check if excluded
	foreach ExcludeBiomes(TestBiome)
	{
		BiomeIndex = BiomeChances.Find('BiomeName', TestBiome);

		if (BiomeIndex != INDEX_NONE)
		{
			BiomeChances.Remove(BiomeIndex, 1);
		}
	}

	// If no "extra" biomes just return the world map biome
	if (BiomeChances.Length == 0)
	{
		return Biome;
	}

	// Calculate total value of roll to see if we want to swap to another biome
	TotalValue = 0;

	for (idx = 0; idx < BiomeChances.Length; idx++)
	{
		TotalValue += BiomeChances[idx].Chance;
	}

	// Chance to use location biome is remainder of 100
	if (TotalValue < 100)
	{
		TotalValue = 100;
	}

	// Do the roll
	RollValue = `SYNC_RAND(TotalValue);
	CurrentValue = 0;

	for (idx = 0; idx < BiomeChances.Length; idx++)
	{
		CurrentValue += BiomeChances[idx].Chance;

		if (RollValue < CurrentValue)
		{
			Biome = BiomeChances[idx].BiomeName;
			break;
		}
	}

	return Biome;
}

//---------------------------------------------------------------------------------------
function bool SelectPlotDefinition(MissionDefinition MissionDef, string Biome, out PlotDefinition SelectedDef, out array<string> ExcludeBiomes, optional out array<name> SitRepNames)
{
	local XComParcelManager ParcelMgr;
	local array<PlotDefinition> ValidPlots;
	local X2SitRepTemplateManager SitRepMgr;
	local name SitRepName;
	local X2SitRepTemplate SitRep;
	local int AllowPlot;  // int so it can be used as an `out` parameter

	ParcelMgr = `PARCELMGR;
	ParcelMgr.GetValidPlotsForMission(ValidPlots, MissionDef, Biome);
	SitRepMgr = class'X2SitRepTemplateManager'.static.GetSitRepTemplateManager();
	`LWDebug("Plot selection: Valid Plots length:" @ValidPlots.Length);

	// pull the first one that isn't excluded from strategy, they are already in order by weight
	foreach ValidPlots(SelectedDef)
	{
		AllowPlot = 1;
		foreach SitRepNames(SitRepName)
		{
			SitRep = SitRepMgr.FindSitRepTemplate(SitRepName);

			if (SitRep != none && SitRep.ExcludePlotTypes.Find(SelectedDef.strType) != INDEX_NONE)
			{
			//	`LWTrace("PlotDef" @SelectedDef.MapName @"invalid for sitrep" @Sitrep.DataName);
				AllowPlot = 0;
			}
		}

		if (TriggerOverridePlotValidForMission(MissionDef, SelectedDef, AllowPlot))
		{
			if (AllowPlot == 1) return true;
		}
		else if (AllowPlot == 1 && !SelectedDef.ExcludeFromStrategy)
		{
			return true;
		}
	}
	`LWDebug("Biome"@Biome @"Added to the exclude list.");
	ExcludeBiomes.AddItem(Biome);
	return false;
}
// End copied code

static function SelectAlternatePlotDef(MissionDefinition MissionDef, string Biome, out PlotDefinition SelectedDef, out array<string> ExcludeBiomes, out array<name> SitrepsToRemove, optional array<name> SitRepNames)
{
	local XComParcelManager ParcelMgr;
	local array<PlotDefinition> ValidPlots;
	local X2SitRepTemplateManager SitRepMgr;
	local name SitRepName;
	local X2SitRepTemplate SitRep;

	ParcelMgr = `PARCELMGR;
	ParcelMgr.GetValidPlotsForMission(ValidPlots, MissionDef, Biome);
	SitRepMgr = class'X2SitRepTemplateManager'.static.GetSitRepTemplateManager();

	SelectedDef = ValidPlots[0];

	foreach SitRepNames(SitRepName)
	{
		SitRep = SitRepMgr.FindSitRepTemplate(SitRepName);

		if (SitRep != none && SitRep.ExcludePlotTypes.Find(SelectedDef.strType) != INDEX_NONE)
		{
			SitrepsToRemove.AddItem(SitRepName);		
		}
	}
	return;
}

// Triggers an event that allows mods to override whether a plot is valid
// for a given mission type or not.
//
/// ```event
/// EventID: OverridePlotValidForMission,
/// EventData: [in string MissionType, in string MissionFamily, in string PlotType,
///             in string PlotName, in bool PlotExcludedFromStrategy,
///             inout bool IsPlotAllowed, out bool OverrideDefaultBehavior],
/// EventSource: XComGameState_LWAlienActivity (ActivityState),
/// NewGameState: no
/// ```
function bool TriggerOverridePlotValidForMission(
	MissionDefinition MissionDef,
	PlotDefinition PlotDef,
	out int IsAllowed)
{
	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'OverridePlotValidForMission';
	Tuple.Data.Add(7);
	Tuple.Data[0].kind = XComLWTVString;
	Tuple.Data[0].s = MissionDef.sType;
	Tuple.Data[1].kind = XComLWTVString;
	Tuple.Data[1].s = MissionDef.MissionFamily;
	Tuple.Data[2].kind = XComLWTVString;
	Tuple.Data[2].s = PlotDef.strType;
	Tuple.Data[3].kind = XComLWTVString;
	Tuple.Data[3].s = PlotDef.MapName;
	Tuple.Data[4].kind = XComLWTVBool;
	Tuple.Data[4].b = PlotDef.ExcludeFromStrategy;
	Tuple.Data[5].kind = XComLWTVBool;
	Tuple.Data[5].b = IsAllowed == 1;    // Allow the plot or not?
	Tuple.Data[6].kind = XComLWTVBool;
	Tuple.Data[6].b = false;   // Override the default behaviour?

	`XEVENTMGR.TriggerEvent(Tuple.Id, Tuple, self);

	IsAllowed = Tuple.Data[5].b ? 1 : 0;  // Convert back to int for the out parameter
	return Tuple.Data[6].b;
}

function string GetMissionDescriptionForActivity()
{
	local X2LWAlienActivityTemplate Template;
	local ActivityMissionDescription MissionDescription;
	local XComGameState_MissionSite MissionState;
	local name MissionFamily;
	local string DescriptionText;

	Template = GetMyTemplate();
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(CurrentMissionRef.ObjectID));
	if (MissionState != none)
	{
		MissionFamily = name(MissionState.GeneratedMission.Mission.MissionFamily);
		if (MissionFamily == '')
			MissionFamily = name(MissionState.GeneratedMission.Mission.sType);
		foreach Template.MissionDescriptions(MissionDescription)
		{
			if (MissionDescription.MissionIndex < 0 || MissionDescription.MissionIndex == CurrentMissionLevel)
			{
				if (MissionDescription.MissionFamily == MissionFamily)
				{
					DescriptionText = MissionDescription.Description;
					break;
				}
			}
		}
	}
	if (DescriptionText == "")
		DescriptionText = "MISSING DESCRIPTION ASSIGNED FOR THIS COMBINATION: \n" $ Template.DataName $ ", " $ MissionFamily $ ", " $ CurrentMissionLevel;

	return DescriptionText;
}

/////////////////////////////////////////////////////
///// UI Handlers

//function used to trigger a mission UI, using activity and mission info
function TriggerMissionUI(XComGameState_MissionSite MissionSite)
{
	local UIMission_LWCustomMission MissionScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;
	MissionScreen = HQPres.Spawn(class'UIMission_LWCustomMission', HQPres);
	MissionScreen.MissionRef = MissionSite.GetReference();
	MissionScreen.MissionUIType = GetMissionUIType(MissionSite);
	MissionScreen.bInstantInterp = false;
	MissionScreen = UIMission_LWCustomMission(HQPres.ScreenStack.Push(MissionScreen));
}

simulated function EMissionUIType GetMissionUIType(XComGameState_MissionSite MissionSite)
{
	local MissionSettings_LW MissionSettings;

    if (class'Utilities_LW'.static.GetMissionSettings(MissionSite, MissionSettings))
        return MissionSettings.MissionUIType;

	//nothing else found, default to GOps
	return eMissionUI_GuerrillaOps;
}

//function used to determine what mission icon to display on Geoscape
simulated function string GetMissionIconImage(XComGameState_MissionSite MissionSite)
{
	local MissionSettings_LW MissionSettings;

    if (class'Utilities_LW'.static.GetMissionSettings(MissionSite, MissionSettings))
	{
        return MissionSettings.MissionIconPath;
	}

	return "img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_GoldenPath";
}

//function for retrieving the 3D geoscape mesh used to represent a mission
simulated function string GetOverworldMeshPath(XComGameState_MissionSite MissionSite)
{
	local MissionSettings_LW MissionSettings;

    if (class'Utilities_LW'.static.GetMissionSettings(MissionSite, MissionSettings))
        return MissionSettings.OverworldMeshPath;

	//nothing else found, use a generic yellow hexagon
	return "UI_3D.Overworld.Hexagon";
}


simulated function name GetEventToTrigger(XComGameState_MissionSite MissionSite)
{
	local MissionSettings_LW MissionSettings;

    if (class'Utilities_LW'.static.GetMissionSettings(MissionSite, MissionSettings))
        return MissionSettings.EventTrigger;

	//nothing else found, default to none
	return '';

}
simulated function string GetSoundToPlay(XComGameState_MissionSite MissionSite)
{
	local MissionSettings_LW MissionSettings;

    if (class'Utilities_LW'.static.GetMissionSettings(MissionSite, MissionSettings))
        return MissionSettings.MissionSound;

	return "Geoscape_NewResistOpsMissions";
}

simulated function name GetAlertType(XComGameState_MissionSite MissionSite)
{
	local MissionSettings_LW MissionSettings;

    if (class'Utilities_LW'.static.GetMissionSettings(MissionSite, MissionSettings))
        return MissionSettings.AlertName;

	//nothing else found, default to GOps
	return 'eAlert_GOps';
}

simulated function String GetMissionImage(XComGameState_MissionSite MissionSite)
{
	local MissionSettings_LW MissionSettings;

    if (class'Utilities_LW'.static.GetMissionSettings(MissionSite, MissionSettings))
        return MissionSettings.MissionImagePath;

	// default to gops if nothing else.
	return "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Guerrilla_Ops";
}

// We need a UI class for all strategy elements (but they'll never be visible)
function class<UIStrategyMapItem> GetUIClass()
{
    return class'UIStrategyMapItem';
}

// Never show these on the map.
function bool ShouldBeVisible()
{
    return false;
}
