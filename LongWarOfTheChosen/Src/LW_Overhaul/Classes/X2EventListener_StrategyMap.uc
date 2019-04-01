class X2EventListener_StrategyMap extends X2EventListener config(LW_Overhaul);

var localized string strTimeRemainingHoursOnly;
var localized string strTimeRemainingDaysAndHours;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateMissionSiteListeners());
	Templates.AddItem(CreateGeoscapeEntryListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateMissionSiteListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MissionSiteListeners');
	Template.AddCHEvent('StrategyMapMissionSiteSelected', OnMissionSiteSelected, ELD_Immediate);
	Template.AddCHEvent('OverrideMissionIcon', OnOverrideMissionIcon, ELD_Immediate);

	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateGeoscapeEntryListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GeoscapeEntryListeners');
	Template.AddCHEvent('OnGeoscapeEntry', StopFirstPOISpawn, ELD_Immediate);

	Template.RegisterInStrategy = true;

	return Template;
}

// Launches the mission information screen on the Geoscape for missions that don't
// have squads infiltrating them yet.
static function EventListenerReturn OnMissionSiteSelected(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameState_MissionSite		MissionSite;
	local XComGameState_LWAlienActivity ActivityState;

	MissionSite = XComGameState_MissionSite(EventData);
	if(MissionSite == none)
		return ELR_NoInterrupt;

	ActivityState = `LWACTIVITYMGR.FindAlienActivityByMission(MissionSite);

	if(ActivityState != none)
	{
		ActivityState.TriggerMissionUI(MissionSite);
	}

	return ELR_NoInterrupt;
}

// Customises the mission icon tooltip to display expiry time. Also ensures that
// clicking a mission icon pops up the mission infiltration screen if that mission
// has a squad currently infiltrating.
static function EventListenerReturn OnOverrideMissionIcon(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_LWAlienActivity AlienActivity;
	local UIStrategyMap_MissionIcon MissionIcon;
	local XComGameState_LWPersistentSquad InfiltratingSquad;
	local string Title, Body;
	
	Tuple = XComLWTuple(EventData);
	if(Tuple == none)
		return ELR_NoInterrupt;

	MissionIcon = UIStrategyMap_MissionIcon(EventSource);
	if(MissionIcon == none)
	{
		`REDSCREEN("OverrideMissionIcon event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	`LWTrace("Received OverrideMissionIcon event of type " $ Tuple.Id);

	switch (Tuple.Id)
	{
		case 'OverrideMissionIcon_MissionTooltip':
			GetMissionSiteUIButtonToolTip(Title, Body, MissionIcon);
			Tuple.Data[0].Kind = XComLWTVString;
			Tuple.Data[0].s = Title;
			Tuple.Data[1].Kind = XComLWTVString;
			Tuple.Data[1].s = Body;
			break;
		case 'OverrideMissionIcon_SetMissionSite':
			InfiltratingSquad = `LWSQUADMGR.GetSquadOnMission(MissionIcon.MissionSite.GetReference());
			if(InfiltratingSquad != none && UIStrategyMapItem_Mission_LW(MissionIcon.MapItem) != none)
			{
				// A squad is infiltrating this mission, so bring up the infiltration screen
				// (UIMission_LWDelayedLaunch) so that the player can launch it or just see
				// details of the squad, etc.
				MissionIcon.OnClickedDelegate = UIStrategyMapItem_Mission_LW(MissionIcon.MapItem).OpenInfiltrationMissionScreen;
			}
			AlienActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionIcon.MissionSite);
			
			if (AlienActivity != none )
				MissionIcon.LoadIcon(AlienActivity.UpdateMissionIcon(MissionIcon, MissionIcon.MissionSite));

			GetMissionSiteUIButtonToolTip(Title, Body, MissionIcon);
			MissionIcon.SetMissionIconTooltip(Title, Body);
			break;
		case 'OverrideMissionIcon_ScanSiteTooltip': // we don't do anything with this currently
		case 'OverrideMissionIcon_SetScanSite': // we don't do anything with this currently
		default:
			break;
	}
	return ELR_NoInterrupt;
}

// Returns the time left before the mission for the given icon expires. Also sets the
// body to the mission objective.
protected static function GetMissionSiteUIButtonToolTip(out string Title, out string Body, UIStrategyMap_MissionIcon MissionIcon)
{
	local XComGameState_LWPersistentSquad InfiltratingSquad;
	local X2MissionTemplate MissionTemplate;
	local float RemainingSeconds;
	local int Hours, Days;
	local XComGameState_LWAlienActivity AlienActivity;
	local XGParamTag ParamTag;
	local XComGameState_MissionSite MissionSite;

	MissionSite = MissionIcon.MissionSite;

	InfiltratingSquad = `LWSQUADMGR.GetSquadOnMission(MissionSite.GetReference());
	if(InfiltratingSquad != none)
	{
		Title = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(InfiltratingSquad.sSquadName);
	}
	else
	{
		MissionTemplate = class'X2MissionTemplateManager'.static.GetMissionTemplateManager().FindMissionTemplate(MissionSite.GeneratedMission.Mission.MissionName);
		Title = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(MissionTemplate.PostMissionType);
	}

	AlienActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionSite);
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

	if(AlienActivity != none)
		RemainingSeconds = AlienActivity.SecondsRemainingCurrentMission();
	else
		if (MissionSite.ExpirationDateTime.m_iYear >= 2050)
			RemainingSeconds = 2147483640;
		else
			RemainingSeconds = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(MissionSite.ExpirationDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime());

	Days = int(RemainingSeconds / 86400.0);
	Hours = int(RemainingSeconds / 3600.0) % 24;

	if(Days < 730)
	{
		Title $= ": ";

		ParamTag.IntValue0 = Hours;
		ParamTag.IntValue1 = Days;

		if(Days >= 1)
			Title $= `XEXPAND.ExpandString(default.strTimeRemainingDaysAndHours);
		else
			Title $= `XEXPAND.ExpandString(default.strTimeRemainingHoursOnly);
	}

	Body = MissionSite.GetMissionObjectiveText();
}

// On Geoscape Entry, hack the resistance HQ so that it appears to have spawned the
// first POI.
static function EventListenerReturn StopFirstPOISpawn(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameState_HeadquartersResistance ResHQ;
	
	ResHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	ResHQ.bFirstPOISpawned = true;
	
	return ELR_NoInterrupt;	
}