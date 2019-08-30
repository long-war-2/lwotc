class X2EventListener_Missions extends X2EventListener config(LW_Overhaul);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateObjectivesListeners());
	Templates.AddItem(CreateSquadListeners());
	Templates.AddItem(CreateMissionPrepListeners());
	Templates.AddItem(CreateMiscellaneousListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateSquadListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MissionSquadListeners');
	Template.AddCHEvent('rjSquadSelect_AllowAutoFilling', DisableSquadAutoFill, ELD_Immediate);

	Template.RegisterInStrategy = true;

	return Template;
}

////////////////
/// Tactical ///
////////////////

static function CHEventListenerTemplate CreateObjectivesListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MissionObjectivesListeners');
	Template.AddCHEvent('OverrideObjectiveSpawnCount', OnOverrideObjectiveSpawnCount, ELD_Immediate);
	Template.AddCHEvent('OverrideObjectiveSpawnCount', OverrideObjectiveDestructibleHealths, ELD_Immediate);
	Template.AddCHEvent('OverrideBodyRecovery', OnOverrideBodyAndLootRecovery, ELD_Immediate);
	Template.AddCHEvent('OverrideLootRecovery', OnOverrideBodyAndLootRecovery, ELD_Immediate);

	Template.RegisterInTactical = true;

	return Template;
}

static function CHEventListenerTemplate CreateMissionPrepListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MissionPrepListeners');
	Template.AddCHEvent('OverrideEncounterZoneAnchorPoint', DisableAutoAdjustingPatrolZones, ELD_Immediate);
	Template.AddCHEvent('OverridePatrolBehavior', DisableDefaultPatrolBehavior, ELD_Immediate);
	Template.AddCHEvent('SpawnReinforcementsComplete', OnSpawnReinforcementsComplete, ELD_OnStateSubmitted);
	Template.AddCHEvent('OnTacticalBeginPlay', DisableInterceptAIBehavior, ELD_Immediate);

	Template.RegisterInTactical = true;

	return Template;
}

static function CHEventListenerTemplate CreateMiscellaneousListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MiscMissionListeners');
	Template.AddCHEvent('PlayerTurnBegun', LW2OnPlayerTurnBegun, ELD_Immediate);

	Template.RegisterInTactical = true;

	return Template;
}

static function EventListenerReturn OnOverrideObjectiveSpawnCount(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_BattleData BattleData;
	local XComGameState_MissionSite MissionSite;
	
	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
		return ELR_NoInterrupt;

	`LWTrace("Received OverrideObjectiveSpawnCount event of type " $ Tuple.Id);

	if (Tuple.Id != 'OverrideObjectiveSpawnCount')
	{
		return ELR_NoInterrupt;
	}
	
	BattleData = XComGameState_BattleData(Tuple.Data[0].o);
	if (BattleData == none)
	{
		`REDSCREEN("Unexpected object passed in tuple for OverrideObjectiveSpawnCount event");
		return ELR_NoInterrupt;
	}

	MissionSite = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(BattleData.m_iMissionID));
	if (MissionSite == none)
	{
		`Log("GetNumObjectivesToSpawn: Failed to fetch mission site for battle.");
		return ELR_NoInterrupt;
	}

	// If this is a Jailbreak_LW mission (Political Prisoners activity) then we
	// need to use the number of rebels we generated as rewards as the number of
	// objectives.
	if (MissionSite.GeneratedMission.Mission.sType == "Jailbreak_LW")
	{
		`LWTRACE("Jailbreak mission overriding NumObjectivesToSpawn = " $ MissionSite.Rewards.Length);
		Tuple.Data[1].i = MissionSite.Rewards.Length;
	}

	return ELR_NoInterrupt;
}

// The destructible health overrides performed in `OnPreMission` don't seem to have an effect
// on objectives, like the alien relay or resistance data transmitter. Performing the same
// work here apparently does the job.
static function EventListenerReturn OverrideObjectiveDestructibleHealths(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	class'X2DownloadableContentInfo_LongWarOfTheChosen'.static.OverrideDestructibleHealths(NewGameState);
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnOverrideBodyAndLootRecovery(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_BattleData BattleData;
	
	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
		return ELR_NoInterrupt;

	BattleData = XComGameState_BattleData(EventSource);
	if (BattleData == none)
	{
		`REDSCREEN("BattleData not provided with 'OverrideBodyAndLootRecovery' event");
		return ELR_NoInterrupt;
	}

	Tuple.Data[0].b = (HasAnyTriadObjective(BattleData) && BattleData.AllTriadObjectivesCompleted()) || Tuple.Data[0].b;

	return ELR_NoInterrupt;
}

static function bool HasAnyTriadObjective(XComGameState_BattleData Battle)
{
	local int ObjectiveIndex;

	for( ObjectiveIndex = 0; ObjectiveIndex < Battle.MapData.ActiveMission.MissionObjectives.Length; ++ObjectiveIndex )
	{
		if( Battle.MapData.ActiveMission.MissionObjectives[ObjectiveIndex].bIsTriadObjective )
		{
			return true;
		}
	}

	return false;
}

// Disable autofilling of the mission squad in robojumper's Squad Select screen
static function EventListenerReturn DisableSquadAutoFill(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local LWTuple Tuple;
	
	Tuple = LWTuple(EventData);
	if (Tuple == none)
		return ELR_NoInterrupt;

	// Sanity check. This should not happen.
	if (Tuple.Id != 'rjSquadSelect_AllowAutoFilling')
	{
		`REDSCREEN("Received unexpected event ID in DisableSquadAutoFill() event handler");
		return ELR_NoInterrupt;
	}

	Tuple.Data[0].b = false;
	return ELR_NoInterrupt;
}

// Disable the vanilla behaviour of moving patrol zones to account for the
// changing line of play that comes from the XCOM squad moving around the
// map. We set the anchor point to the spawn location of the XCOM squad.
static function EventListenerReturn DisableAutoAdjustingPatrolZones(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComGameState_BattleData BattleData;
	local XComLWTuple Tuple;
	local Vector AnchorPoint;
	
	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
		return ELR_NoInterrupt;

	// Sanity check. This should not happen.
	if (Tuple.Id != 'OverrideEncounterZoneAnchorPoint')
	{
		`REDSCREEN("Received unexpected event ID in DisableAutoAdjustingPatrolZones() event handler");
		return ELR_NoInterrupt;
	}

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	AnchorPoint = BattleData.MapData.SoldierSpawnLocation;
	Tuple.Data[0].f = AnchorPoint.X;
	Tuple.Data[1].f = AnchorPoint.Y;
	Tuple.Data[2].f = AnchorPoint.Z;

	return ELR_NoInterrupt;
}

// Override AI intercept/patrol behavior. The base game uses a function to control pod movement.
//
// For the overhaul mod we will not use either upthrottling or the 'intercept' behavior if XCOM passes
// the pod along the LoP. Instead we will use the pod manager to control movement. But we still want pods
// with no jobs to patrol as normal.
static function EventListenerReturn DisableDefaultPatrolBehavior(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_AIGroup Group;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
		return ELR_NoInterrupt;

	// Sanity check. This should not happen.
	if (Tuple.Id != 'OverridePatrolBehavior')
	{
		`REDSCREEN("Received unexpected event ID in DisableDefaultPatrolBehavior() event handler");
		return ELR_NoInterrupt;
	}

	Group = XComGameState_AIGroup(EventSource);

	if (Group != none && `LWPODMGR.PodHasJob(Group) || `LWPODMGR.GroupIsInYellowAlert(Group))
	{
		// This pod has a job, or is in yellow alert. Don't let the base game alter its alert.
		// For pods with jobs, we want the game to use the throttling beacon we have set for them.
		// For yellow alert pods, either they have a job, in which case they should go where that job
		// says they should, or they should be investigating their yellow alert cause.
		Tuple.Data[0].b = true;
	}
	else
	{
		// No job. Let the base game patrol, but don't try to use the intercept mechanic.
		Tuple.Data[0].b = false;
	}

	return ELR_NoInterrupt;
}

// A RNF pod has spawned. Mark the units with a special marker to indicate they shouldn't be eligible for
// reflex actions this turn.
static function EventListenerReturn OnSpawnReinforcementsComplete (
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name InEventID,
	Object CallbackData)
{
	local XComGameState_Unit Unit;
	local XComGameState NewGameState;
	local XComGameState_AIReinforcementSpawner Spawner;
	local int i;

	Spawner = XComGameState_AIReinforcementSpawner(EventSource);
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Prevent RNF units from getting yellow actions");
	for (i = 0; i < Spawner.SpawnedUnitIDs.Length; ++i)
	{
		Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Spawner.SpawnedUnitIDs[i]));
		Unit.SetUnitFloatValue(class'Utilities_LW'.const.NoReflexActionUnitValue, 1, eCleanup_BeginTurn);
	}
	
	// Issue #117
	//
	// Alien pack enemies within reinforcements need their pawns updating to look the way
	// they should (rather than as disembodied heads). This is a small hack that uses the
	// new game state to activate a visualization that fixes the enemy RNF pawns.
	//
	// WOTC TODO: Perhaps this could be attached to the original spawn reinforcements game
	// state change, either via a PostBuildVisualizationFn or by using
	// ELD_OnVisualizationBlockStarted/Completed. The main requirement is that the visualization
	// function has access to the pending unit states in the game state change.
	XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = CustomizeAliens_BuildVisualization;

	`TACTICALRULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}

// Disable the "intercept player" AI behaviour for all missions by setting a new
// WOTC property on the battle data object. This can probably still be overridden
// by Kismet, but I'm not sure why we would ever want to do that.
static function EventListenerReturn DisableInterceptAIBehavior(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local bool SubmitGameState;

	SubmitGameState = false;
	History = `XCOMHISTORY;

	if (NewGameState == none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Force Disable Intercept Movement");
		SubmitGameState = true;
	}

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	BattleData = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
	BattleData.bKismetDisabledInterceptMovement = true;

	if (SubmitGameState)
	{
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
}

// A BuildVisualization function that ensures that alien pack enemies have their
// pawns updated via X2Action_CustomizeAlienPackRNFs.
static simulated function CustomizeAliens_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameState_Unit UnitState;
	local VisualizationActionMetadata EmptyMetadata, ActionMetadata;
	local XComGameState_Unit_AlienCustomization AlienCustomization;

	if (VisualizeGameState.GetNumGameStateObjects() > 0)
	{
		foreach VisualizeGameState.IterateByClassType( class'XComGameState_Unit', UnitState )
		{
			AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.GetCustomizationComponent(UnitState);
			if (AlienCustomization == none)
			{
				continue;
			}
			
			ActionMetadata = EmptyMetadata;
			ActionMetadata.StateObject_OldState = UnitState;
			ActionMetadata.StateObject_NewState = UnitState;

			ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

			class'X2Action_CustomizeAlienPackRNFs'.static.AddToVisualizationTree(
				ActionMetadata,
				VisualizeGameState.GetContext(),
				false);
		}
	}
}

static function EventListenerReturn LW2OnPlayerTurnBegun(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
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
