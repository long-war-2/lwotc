class X2EventListener_Missions extends X2EventListener config(LW_Overhaul);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateObjectivesListeners());
	Templates.AddItem(CreateSquadListeners());

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
