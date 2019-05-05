class X2EventListener_Missions extends X2EventListener config(LW_Overhaul);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateObjectivesListeners());
	Templates.AddItem(CreateSquadListeners());
	Templates.AddItem(CreateMissionPrepListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateObjectivesListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MissionObjectivesListeners');
	Template.AddCHEvent('OverrideObjectiveSpawnCount', OnOverrideObjectiveSpawnCount, ELD_Immediate);

	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateSquadListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MissionSquadListeners');
	Template.AddCHEvent('rjSquadSelect_AllowAutoFilling', DisableSquadAutoFill, ELD_Immediate);

	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateMissionPrepListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MissionPrepListeners');
	Template.AddCHEvent('OverrideEncounterZoneAnchorPoint', DisableAutoAdjustingPatrolZones, ELD_Immediate);
	Template.AddCHEvent('OverridePatrolBehavior', DisableDefaultPatrolBehavior, ELD_Immediate);
	Template.AddCHEvent('OnTacticalBeginPlay', DisableInterceptAIBehavior, ELD_Immediate);

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

// Disable autofilling of the mission squad in robojumper's Squad Select screen
static function EventListenerReturn DisableSquadAutoFill(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	
	Tuple = XComLWTuple(EventData);
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
function EventListenerReturn DisableDefaultPatrolBehavior(
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
