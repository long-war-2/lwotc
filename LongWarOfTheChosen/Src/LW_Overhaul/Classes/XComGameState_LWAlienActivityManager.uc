//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWAlienActivityManager.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This is the singleton, overall alien strategic manager for generating/managing activities
//---------------------------------------------------------------------------------------
class XComGameState_LWAlienActivityManager extends XComGameState_GeoscapeEntity dependson(X2LWAlienActivityTemplate) config(LW_Activities);



var TDateTime NextUpdateTime;

var array<ActivityCooldownTimer> GlobalCooldowns;

var config int AVATAR_DELAY_HOURS_PER_NET_GLOBAL_VIG;

//#############################################################################################
//----------------   INITIALIZATION   ---------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
event OnCreation(optional X2DataTemplate InitTemplate)
{
	NextUpdateTime = class'UIUtilities_Strategy'.static.GetGameTime().CurrentTime;
}

static function X2StrategyElementTemplateManager GetStrategyTemplateManager()
{
	return class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
}

static function XComGameState_LWAlienActivityManager GetAlienActivityManager(optional bool AllowNULL = false)
{
    return XComGameState_LWAlienActivityManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWAlienActivityManager', AllowNULL));
}

static function XComGameState_LWAlienActivityManager CreateAlienActivityManager(optional XComGameState StartState)
{
	local XComGameState_LWAlienActivityManager ActivityMgr;
	local XComGameState NewGameState;

	//first check that there isn't already a singleton instance of this manager
	ActivityMgr = GetAlienActivityManager(true);
	if (ActivityMgr != none)
	{
		return ActivityMgr;
	}

	if(StartState != none)
	{
		ActivityMgr = XComGameState_LWAlienActivityManager(StartState.CreateNewStateObject(class'XComGameState_LWAlienActivityManager'));
	}
	else
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating LW Alien Activity Manager Quasi-singleton");
		ActivityMgr = XComGameState_LWAlienActivityManager(NewGameState.CreateNewStateObject(class'XComGameState_LWAlienActivityManager'));
	}

	return ActivityMgr;
}

//#############################################################################################
//----------------   UPDATE   -----------------------------------------------------------------
//#############################################################################################

//---------------------------------------------------------------------------------------
function bool Update(XComGameState NewGameState)
{
	local bool bUpdated;
	local array<X2StrategyElementTemplate> ActivityTemplates;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local int idx, NumActivities, ActivityIdx;
	local XComGameState_LWAlienActivityManager UpdatedActivityMgr;
	local ActivityCooldownTimer Cooldown;
	local array<ActivityCooldownTimer> CooldownsToRemove;
	local StateObjectReference PrimaryRegionRef;

	bUpdated = false;
	
	if (class'X2StrategyGameRulesetDataStructures'.static.LessThan(NextUpdateTime, `STRATEGYRULES.GameTime))
	{
		//`LOG("Alien Activity Manager : Updating, CurrentTime=" $ 
			//class'X2StrategyGameRulesetDataStructures'.static.GetTimeString(`STRATEGYRULES.GameTime) $ ":" $ class'X2StrategyGameRulesetDataStructures'.static.GetDateString(`STRATEGYRULES.GameTime) $
			//", NextUpdateTime=" $ class'X2StrategyGameRulesetDataStructures'.static.GetTimeString(NextUpdateTime) $ ":" $ class'X2StrategyGameRulesetDataStructures'.static.GetDateString(NextUpdateTime));

		ValidatePendingDarkEvents(NewGameState);

		//Update Global Cooldowns
		foreach GlobalCooldowns(Cooldown)
		{
			if(class'X2StrategyGameRulesetDataStructures'.static.LessThan(Cooldown.CooldownDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()))
			{
				CooldownsToRemove.AddItem(Cooldown);
			}
		}
		if(CooldownsToRemove.Length > 0)
		{
			foreach CooldownsToRemove(Cooldown)
			{
				GlobalCooldowns.RemoveItem(Cooldown);
			}
			bUpdated = true;
		}
	
		//AlienActivity Creation
		ActivityTemplates = GetStrategyTemplateManager().GetAllTemplatesOfClass(class'X2LWAlienActivityTemplate');
		ActivityTemplates = RandomizeOrder(ActivityTemplates);
		ActivityTemplates.Sort(ActivityPrioritySort);
		for(idx = 0; idx < ActivityTemplates.Length; idx++)
		{
			ActivityTemplate = X2LWAlienActivityTemplate(ActivityTemplates[idx]);
			if(GlobalCooldowns.Find('ActivityName', ActivityTemplate.DataName) == -1)
			{
				if(ActivityTemplate == none)
				{
					bUpdated = bUpdated;
				}
				ActivityTemplate.ActivityCreation.InitActivityCreation(ActivityTemplate, NewGameState);
				NumActivities = ActivityTemplate.ActivityCreation.GetNumActivitiesToCreate(NewGameState);
				for(ActivityIdx = 0 ; ActivityIdx < NumActivities; ActivityIdx++)
				{
					PrimaryRegionRef = ActivityTemplate.ActivityCreation.GetBestPrimaryRegion(NewGameState);
					if(PrimaryRegionRef.ObjectID > 0)
					{
						bUpdated = true;
						ActivityTemplate.CreateInstanceFromTemplate(PrimaryRegionRef, NewGameState);
					}
				}
			}
		}

		//update activity creation timer
		UpdatedActivityMgr = XComGameState_LWAlienActivityManager(NewGameState.ModifyStateObject(Class, ObjectID));
		if(class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours(class'XComGameState_GeoscapeEntity'.static.GetCurrentTime(), NextUpdateTime) > 20 * class'X2LWAlienActivityTemplate'.default.HOURS_BETWEEN_ALIEN_ACTIVITY_MANAGER_UPDATES)
		{
			NextUpdateTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();

		}
		class'X2StrategyGameRulesetDataStructures'.static.AddDay(UpdatedActivityMgr.NextUpdateTime);
		bUpdated = true;
	}

	return bUpdated;
}

//---------------------------------------------------------------------------------------
function UpdateGameBoard()
{
	local XComGameState NewGameState;
	local XComGameState_LWAlienActivityManager AAMState;
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Regional AIs");
	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);

		if (!RegionalAI.UpdateRegionalAI(NewGameState))
			NewGameState.PurgeGameStateForObjectID(RegionalAI.ObjectID);
	}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);


	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update/Create Alien Activities");
	AAMState = XComGameState_LWAlienActivityManager(NewGameState.ModifyStateObject(class'XComGameState_LWAlienActivityManager', ObjectID));

	if (!AAMState.Update(NewGameState))
		NewGameState.PurgeGameStateForObjectID(AAMState.ObjectID);

	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

//#############################################################################################
//----------------   UTILITY   ----------------------------------------------------------------
//#############################################################################################

// for now, just setting based on liberation status. if finer control is needed, consider adding an activity template delegate
function UpdatePreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_BattleData BattleData;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;

	foreach StartGameState.IterateByClassType (class'XComGameState_BattleData', BattleData)
	{
		break;
	}
	if (BattleData == none)
	{
		`REDSCREEN ("OnPreMission called by cannot retrieve BattleData");
		return;
	}
	RegionState = MissionState.GetWorldRegion();
	if (RegionState == none) { return; }
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
	if (RegionalAIState != none && RegionalAIState.bLiberated)
	{
		// set the popular support high so that civs won't be hostile
		BattleData.SetPopularSupport(1000);
		BattleData.SetMaxPopularSupport(1000);
	}
}

function ValidatePendingDarkEvents(optional XComGameState NewGameState)
{
	local array<StateObjectReference> InvalidDarkEvents, ValidDarkEvents;
	local StateObjectReference DarkEventRef;
	local array<XComGameState_LWAlienActivity> AllActivities;
	local XComGameState_LWAlienActivity Activity;
	local XComGameState_HeadquartersAlien UpdateAlienHQ;
	local bool bNeedsUpdate;

	//History = `XCOMHISTORY;
	bNeedsUpdate = NewGameState == none;
	if (bNeedsUpdate)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Validating Pending Dark Events");
	}
	
	UpdateAlienHQ = GetAlienHQ(NewGameState);

	AllActivities = GetAllActivities();
	foreach AllActivities(Activity)
	{
		if (Activity.DarkEvent.ObjectID > 0)
		{
			ValidDarkEvents.AddItem(Activity.DarkEvent);
		}
	}
	foreach UpdateAlienHQ.ChosenDarkEvents (DarkEventRef)
	{
		if (ValidDarkEvents.Find ('ObjectID', DarkEventRef.ObjectID) == -1)
		{
			InvalidDarkEvents.AddItem(DarkEventRef);
		}
	}
	if (InvalidDarkEvents.length > 0)
	{
		`LWTRACE("------------------------------------------");
		`LWTRACE ("Found invalid dark events when validating.");
		`LWTRACE("------------------------------------------");
		foreach InvalidDarkEvents(DarkEventRef)
		{
			UpdateAlienHQ.ChosenDarkEvents.RemoveItem(DarkEventRef);
		}
	}

	if (bNeedsUpdate)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}

static function array<XComGameState_LWAlienActivity> GetAllActivities(optional XComGameState NewGameState)
{
	local array<XComGameState_LWAlienActivity> arrActivities;
	local array<StateObjectReference> arrActivityRefs;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameStateHistory History;
	
	History = `XCOMHISTORY;
	if(NewGameState != none)
	{
		foreach NewGameState.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
		{
			arrActivities.AddItem(ActivityState);
			arrActivityRefs.AddItem(ActivityState.GetReference());
		}
	}
	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if(arrActivityRefs.Find('ObjectID', ActivityState.ObjectID) == -1)
		{
			arrActivities.AddItem(ActivityState);
		}
	}

	return arrActivities;
}

static function XComGameState_LWAlienActivity FindAlienActivityByMission(XComGameState_MissionSite MissionSite)
{
	return FindAlienActivityByMissionRef(MissionSite.GetReference());
}

static function XComGameState_LWAlienActivity FindAlienActivityByMissionRef(StateObjectReference MissionRef)
{
	local XComGameStateHistory History;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState StrategyState;
	local int LastStrategyStateIndex;
	
	History = `XCOMHISTORY;
	
	if (`TACTICALRULES != none && `TACTICALRULES.TacticalGameIsInPlay())
	{
		// grab the archived strategy state from the history and the headquarters object
		LastStrategyStateIndex = History.FindStartStateIndex() - 1;
		StrategyState = History.GetGameStateFromHistory(LastStrategyStateIndex, eReturnType_Copy, false);
		foreach StrategyState.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
		{
			if(ActivityState.CurrentMissionRef.ObjectID == MissionRef.ObjectID)
				return ActivityState;
		}
	}
	else
	{
		foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
		{
			if(ActivityState.CurrentMissionRef.ObjectID == MissionRef.ObjectID)
				return ActivityState;
		}
	}
	return none;
}

static function UpdateMissionData(XComGameState_MissionSite MissionSite)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local int ForceLevel, AlertLevel, i;
	local XComGameState_LWPersistentSquad InfiltratingSquad;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;
	local array<X2DownloadableContentInfo> DLCInfos;
	local MissionDefinition MissionDef;
	local name NewMissionFamily;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	SquadMgr = `LWSQUADMGR;
	InfiltratingSquad = SquadMgr.GetSquadOnMission(MissionSite.GetReference());
	ActivityState = FindAlienActivityByMission(MissionSite);
	RegionState = MissionSite.GetWorldRegion();
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);

	//ForceLevel : what types of aliens are present
	if(ActivityState != none && ActivityState.GetMyTemplate().GetMissionForceLevelFn != none)
	{
		ForceLevel = ActivityState.GetMyTemplate().GetMissionForceLevelFn(ActivityState, MissionSite, none);
	}
	else
	{
		if(RegionalAIState != none)
			ForceLevel = RegionalAIState.LocalForceLevel;
		else
			ForceLevel = AlienHQ.GetForceLevel();
	}
	ForceLevel = Clamp(ForceLevel, class'XComGameState_HeadquartersAlien'.default.AlienHeadquarters_StartingForceLevel, class'XComGameState_HeadquartersAlien'.default.AlienHeadquarters_MaxForceLevel);

	//AlertLevel : how many pods, how many aliens in each pod, types of pods, etc (from MissionSchedule)
	AlertLevel = GetMissionAlertLevel(MissionSite);

	//modifiers
	if (InfiltratingSquad != none && !MissionSite.GetMissionSource().bGoldenPath)
		AlertLevel += InfiltratingSquad.GetAlertnessModifierForCurrentInfiltration(); // this submits its own gamestate update
	AlertLevel = Max(AlertLevel, 1); // clamp to be no less than 1

	`LWTRACE("Updating Mission Difficulty: ForceLevel=" $ ForceLevel $ ", AlertLevel=" $ AlertLevel);

	// add explicit hook so that DLCs can update (e.g. AlienHunters to add Rulers) -- these are assumed to submit their own gamestate updates
	DLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);
	for(i = 0; i < DLCInfos.Length; ++i)
	{
		if (DLCInfos[i].UpdateShadowChamberMissionInfo(MissionSite.GetReference()))
		{
			`LWTRACE("UpdateShadowChamberMissionInfo substituted in something -- probably an alien ruler");
		}
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Mission Data");
	MissionSite = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', MissionSite.ObjectID));
	NewGameState.AddStateObject (MissionSite);

	//update the mission encounters in case they were updated (e.g. mod update)
	if (`TACTICALMISSIONMGR.GetMissionDefinitionForType(MissionSite.GeneratedMission.Mission.sType, MissionDef))
	{
		// get here if the mission wasn't removed in the update
		MissionSite.GeneratedMission.Mission = MissionDef;
	}
	else
	{
		//the whole mission in the current save was removed, so we need to get a new one
		`REDSCREEN ("Mission type " $ MissionSite.GeneratedMission.Mission.sType $ " removed in update. Attempting to recover.");
		NewMissionFamily = ActivityState.GetNextMissionFamily(none);
		MissionSite.GeneratedMission.Mission = ActivityState.GetMissionDefinitionForFamily(NewMissionFamily);
	}

	//cache the difficulty
	MissionSite.CacheSelectedMissionData(ForceLevel, AlertLevel);

	if (NewGameState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

}

static function int GetMissionAlertLevel(XComGameState_MissionSite MissionSite)
{
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;
	local int AlertLevel;
	
	ActivityState = FindAlienActivityByMission(MissionSite);
	RegionState = MissionSite.GetWorldRegion();
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
	if(ActivityState != none && ActivityState.GetMyTemplate().GetMissionAlertLevelFn != none)
	{
		AlertLevel = ActivityState.GetMyTemplate().GetMissionAlertLevelFn(ActivityState, MissionSite, none);
	}
	else if (MissionSite.GetMissionSource().bGoldenPath)
	{
		AlertLevel = `STRATEGYDIFFICULTYSETTING + 1;
	}
	else if(RegionalAIState != none)
	{
		AlertLevel = RegionalAIState.LocalAlertLevel;
	}
	else
	{
		AlertLevel = MissionSite.GetMissionDifficulty(); // this should basically never happen
	}
	if(`XCOMHQ.TacticalGameplayTags.Find('DarkEvent_ShowOfForce') != INDEX_NONE)
	{
		AlertLevel ++;
	}
	return AlertLevel;
}

private function int ActivityPrioritySort(X2LWAlienActivityTemplate TemplateA, X2LWAlienActivityTemplate TemplateB)
{
	return (TemplateB.iPriority - TemplateA.iPriority);
}

static function array<X2StrategyElementTemplate> RandomizeOrder(const array<X2StrategyElementTemplate> InputActivityTemplates)
{
	local array<X2StrategyElementTemplate> Templates;
	local array<X2StrategyElementTemplate> RemainingTemplates;
	local int ArrayLength, idx, Selection;

	ArrayLength = InputActivityTemplates.Length;
	RemainingTemplates = InputActivityTemplates;

	for(idx = 0; idx < ArrayLength; idx++)
	{
		Selection = `SYNC_RAND_STATIC(RemainingTemplates.Length);
		Templates.AddItem(RemainingTemplates[Selection]);
		RemainingTemplates.Remove(Selection, 1);
	}

	return Templates;
}

static function AddDoomToFortress(XComGameState NewGameState, int DoomToAdd, optional string DoomMessage, optional bool bCreatePendingDoom = true)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_MissionSite MissionState;
	local PendingDoom DoomPending;
	local int DoomDiff;

	AlienHQ = GetAlienHQ(NewGameState);
	if (AlienHQ == none)
		return;

	DoomDiff = AlienHQ.GetMaxDoom() - AlienHQ.GetCurrentDoom(true);
	DoomToAdd = Clamp(DoomToAdd, 0, DoomDiff);

	if (DoomToAdd <= 0)
		return; // don't set up event, etc for no doom

	MissionState = AlienHQ.GetAndAddFortressMission(NewGameState);

	if(MissionState != none)
	{
		MissionState.Doom += DoomToAdd;

		if(bCreatePendingDoom && class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('LW_T2_M1_N2_RevealAvatarProject'))
		{
			DoomPending.Doom = DoomToAdd;

			if(DoomMessage != "")
			{
				DoomPending.DoomMessage = DoomMessage;
			}
			else
			{
				DoomPending.DoomMessage = class'XComGameState_HeadquartersAlien'.default.HiddenDoomLabel;
			}

			AlienHQ.PendingDoomData.AddItem(DoomPending);
		
			AlienHQ.PendingDoomEntity = MissionState.GetReference();

			if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T5_M1_AutopsyTheAvatar'))
				AlienHQ.PendingDoomEvent = 'OnFortressAddsDoomEndgame';
			else
				AlienHQ.PendingDoomEvent = 'OnFortressAddsDoom';
		}

		class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_AvatarProgress', DoomToAdd);
	}
}

static function AddDoomToRandomFacility(XComGameState NewGameState, int DoomToAdd, optional string DoomMessage)
{
	local XComGameStateHistory History;
	local XComGameState_LWAlienActivity ActivityState;
	local array<XComGameState_LWAlienActivity> ResearchFacilities;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if(ActivityState.GetMyTemplateName() == class'X2StrategyElement_DefaultAlienActivities'.default.RegionalAvatarResearchName)
		{
			ResearchFacilities.AddItem(ActivityState);
		}
	}
	if(ResearchFacilities.Length > 0)
	{
		ActivityState = ResearchFacilities[`SYNC_RAND_STATIC(ResearchFacilities.Length)];
		AddDoomToFacility(ActivityState, NewGameState, DoomToAdd, DoomMessage);
	}
	else
	{
		AddDoomToFortress(NewGameState, DoomToAdd, DoomMessage);
	}
}

static function AddDoomToFacility(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState, int DoomToAdd, optional string DoomMessage)
{
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion RegionState;
	local PendingDoom DoomPending;
	local XGParamTag ParamTag;
	local int DoomDiff;
	local XComGameState_HeadquartersAlien UpdateAlienHQ;

	UpdateAlienHQ = GetAlienHQ(NewGameState);
	if(UpdateAlienHQ == none)
		return;

	DoomDiff = UpdateAlienHQ.GetMaxDoom() - UpdateAlienHQ.GetCurrentDoom(true);
	DoomToAdd = Clamp(DoomToAdd, 0, DoomDiff);

	if (DoomToAdd <= 0)
		return; // don't set up event, etc for no doom

	if(ActivityState.CurrentMissionRef.ObjectID > 0) // is detected and has a mission
	{
		MissionState = XComGameState_MissionSite(NewGameState.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
		if (MissionState == none)
		{
			MissionState = XComGameState_MissionSite(NewGameState.CreateStateObject(class'XComGameState_MissionSite', ActivityState.CurrentMissionRef.ObjectID));
			NewGameState.AddStateObject(MissionState);
		}
	}
	if(MissionState != none)
		MissionState.Doom += DoomToAdd;
	else
		ActivityState.Doom += DoomToAdd;

	DoomPending.Doom = DoomToAdd;

	if(DoomMessage != "")
	{
		DoomPending.DoomMessage = DoomMessage;
	}
	else
	{
		ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		ParamTag.StrValue0 = RegionState.GetDisplayName();
		DoomPending.DoomMessage = `XEXPAND.ExpandString(class'XComGameState_HeadquartersAlien'.default.FacilityDoomLabel);
	}
		
	if (UpdateAlienHQ.bHasSeenDoomMeter && class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('LW_T2_M1_N2_RevealAvatarProject'))
	{
		UpdateAlienHQ.PendingDoomData.AddItem(DoomPending);
		if(MissionState != none)
		{
			UpdateAlienHQ.PendingDoomEntity = MissionState.GetReference();
		}
		UpdateAlienHQ.PendingDoomEvent = 'OnFacilityAddsDoom';
		ActivityState.bNeedsPause = true;
	}
	class'XComGameState_HeadquartersResistance'.static.RecordResistanceActivity(NewGameState, 'ResAct_AvatarProgress', DoomToAdd);
}

static function XComGameState_HeadquartersAlien GetAlienHQ(XComGameState NewGameState)
{
	local XComGameState_HeadquartersAlien AlienHQ, UpdateAlienHQ;

	AlienHQ = class'UIUtilities_Strategy'.static.GetAlienHQ(true);
	if(AlienHQ == none)
		return none;

	UpdateAlienHQ = XComGameState_HeadquartersAlien(NewGameState.GetGameStateForObjectID(AlienHQ.ObjectID));
	if(UpdateAlienHQ == none)
	{
		UpdateAlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(AlienHQ.Class, AlienHQ.ObjectID));
		NewGameState.AddStateObject(UpdateAlienHQ);
	}
	return UpdateAlienHQ;
}

// compute modifiers to Doom update timers for both facility doom generation and alien hq doom generation
// facility doom will pass in the optional arguments, while the static-timer based alien hq doom will not
static function int GetDoomUpdateModifierHours(optional XComGameState_LWAlienActivity ActivityState, optional XComGameState NewGameState)
{
	return Max (0, GetNetVigilance() * default.AVATAR_DELAY_HOURS_PER_NET_GLOBAL_VIG);
}

static function int GetNetVigilance()
{
	return GetGlobalVigilance() - GetNumAlienRegions() - GetGlobalAlert();
}

static function int GetGlobalVigilance()
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local int SumVigilance;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
		if(!RegionalAI.bLiberated)
		{
			SumVigilance += RegionalAI.LocalVigilanceLevel;
		}
	}
	return SumVigilance;
}

static function int GetGlobalAlert()
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local int SumAlert;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
		if(!RegionalAI.bLiberated)
		{
			SumAlert += RegionalAI.LocalAlertLevel;
		}
	}
	return SumAlert;
}

static function int GetNumAlienRegions()
{
	local int kount;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	foreach `XCOMHistory.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
		if(!RegionalAI.bLiberated)
		{
			kount += 1;
		}
	}
	return kount;
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

