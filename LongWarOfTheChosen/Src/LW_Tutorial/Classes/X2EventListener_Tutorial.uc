//----------------------------------------------------------------------------------------
//  FILE:    X2EventListener_Tutorial.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Handle various LWOTC tutorial events.
//----------------------------------------------------------------------------------------

class X2EventListener_Tutorial extends X2EventListener config(LW_Tutorial);

var localized string DroneSightedTitle;
var localized string DroneSightedBody;
var localized string RainbowTrooperSightedTitle;
var localized string RainbowTrooperSightedBody;

var localized string HavenHighlightTitle;
var localized string HavenHighlightBody;

var localized string FirstMissionDiscoveredTitle;
var localized string FirstMissionDiscoveredBody;

var localized string FirstRetaliationTitle;
var localized string FirstRetaliationBody;

var localized string CommandersQuartersEnteredTitle;
var localized string CommandersQuartersEnteredBody;

var localized string GeneralChosenTitle;
var localized string GeneralChosenBody;

var localized string TacticalChosenTitle;
var localized string TacticalChosenBody;

var localized string AssassinSightedTitle;
var localized string AssassinSightedBody;

var localized string WarlockSightedTitle;
var localized string WarlockSightedBody;

var localized string HunterSightedTitle;
var localized string HunterSightedBody;
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTacticalListeners());
	Templates.AddItem(CreateStrategyListeners());

	return Templates;
}

static function CHEventListenerTemplate CreateTacticalListeners()
{
	local CHEventListenerTemplate Template;

	// Use a high priority for these listeners because we want them triggering
	// before the strategy objective is completed from the same event.
	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'TacticalTutorialListeners');
	Template.AddCHEvent('DroneSighted', OnDroneSighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('EngineerSighted', OnRainbowTrooperSighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('SentrySighted', OnRainbowTrooperSighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('GunnerSighted', OnRainbowTrooperSighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('RocketeerSighted', OnRainbowTrooperSighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('ChosenSighted', OnChosenSighted, ELD_OnStateSubmitted, 80);
	Template.AddCHEvent('AssassinSighted', OnAssassinSighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('WarlockSighted', OnWarlockSighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('HunterSighted', OnHunterSighted, ELD_OnStateSubmitted, 90);
	Template.RegisterInTactical = true;

	return Template;
}

static function CHEventListenerTemplate CreateStrategyListeners()
{
	local CHEventListenerTemplate Template;

	// Use a high priority for these listeners because we want them triggering
	// before the strategy objective is completed from the same event.
	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'StrategyTutorialListeners');
	Template.AddCHEvent('NewMissionAppeared', OnMissionDiscovered, ELD_OnStateSubmitted);
	Template.AddCHEvent('NewMissionAppeared', HandleFirstRetaliation, ELD_OnStateSubmitted);
	Template.AddCHEvent('OnEnteredFacility_CommandersQuarters', ShowArchivesTutorial, ELD_OnStateSubmitted, 10);
	Template.RegisterInStrategy = true;

	return Template;
}

// Pop up a tutorial box when a drone is sighted for the first time
static function EventListenerReturn OnDroneSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_DroneSighted'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_DroneSighted');

		// Show the tutorial box for drones
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.DroneSightedTitle,
				default.DroneSightedBody,
				"img:///UILibrary_LW_Overhaul.TutorialImages.LWDrone");
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnRainbowTrooperSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_RainbowTrooperSighted'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_RainbowTrooperSighted');

		// Show the tutorial box for rainbow troopers
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.RainbowTrooperSightedTitle,
				default.RainbowTrooperSightedBody,
				"img:///UILibrary_LW_Overhaul.TutorialImages.LWRainbow");
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnChosenSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_ChosenTactical'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_ChosenTactical');

		// Show the tutorial box for rainbow troopers
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.TacticalChosenTitle,
				default.TacticalChosenBody,
				"img:///UILibrary_XPACK_StrategyImages.DarkEvent_MadeWhole");
	}
	return ELR_NoInterrupt;
}
static function EventListenerReturn OnAssassinSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_AssassinSighted'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_AssassinSighted');

		// Show the tutorial box for rainbow troopers
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.AssassinSightedTitle,
				default.AssassinSightedBody,
				"img:///UILibrary_XPACK_StrategyImages.DarkEvent_Loyalty_Among_Thieves_Assasin");
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnHunterSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_HunterSighted'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_HunterSighted');

		// Show the tutorial box for rainbow troopers
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.HunterSightedTitle,
				default.HunterSightedBody,
				"img:///UILibrary_XPACK_StrategyImages.DarkEvent_Loyalty_Among_Thieves_Hunter");
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnWarlockSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_WarlockSighted'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_WarlockSighted');

		// Show the tutorial box for rainbow troopers
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.WarlockSightedTitle,
				default.WarlockSightedBody,
				"img:///UILibrary_XPACK_StrategyImages.DarkEvent_Loyalty_Among_Thieves_Warlock");
	}
	return ELR_NoInterrupt;
}
// Pop up a tutorial box when the Geoscape is first entered that directs the
// player to their starting haven/outpost.
static function EventListenerReturn OnMissionDiscovered(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name InEventID,
	Object CallbackData)
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_FirstMissionDiscovered'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_FirstMissionDiscovered');
		`PRESBASE.UITutorialBox(
			default.FirstMissionDiscoveredTitle,
			default.FirstMissionDiscoveredBody,
			"img:///UILibrary_LW_Overhaul.TutorialImages.LWMission_Map_Icon");
	}

	return ELR_NoInterrupt;
}

// Pop up a tutorial box when the Geoscape is first entered that directs the
// player to their starting haven/outpost.
static function EventListenerReturn HandleFirstRetaliation(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name InEventID,
	Object CallbackData)
{
	local XComGameState_LWAlienActivity ActivityState;
	local name ActivityName;

	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_FirstRetaliation'))
	{
		ActivityState = XComGameState_LWAlienActivity(EventSource);
		if (ActivityState == none ) return ELR_NoInterrupt;

		// Check whether this is a retaliation mission.
		ActivityName = ActivityState.GetMyTemplateName();
		if (ActivityName != class'X2StrategyElement_DefaultAlienActivities'.default.CounterinsurgencyName &&
			ActivityName != class'X2StrategyElement_DefaultAlienActivities'.default.IntelRaidName &&
			ActivityName != class'X2StrategyElement_DefaultAlienActivities'.default.SupplyConvoyName &&
			ActivityName != class'X2StrategyElement_DefaultAlienActivities'.default.RecruitRaidName)
		{
			// Not a retal
			return ELR_NoInterrupt;
		}
		if(!`SecondWaveEnabled('DisableChosen'))
		{
			class'LWTutorial'.static.CompleteObjective('LW_TUT_GeneralChosen');
			`PRESBASE.UITutorialBox(
			default.GeneralChosenTitle,
			default.GeneralChosenBody,
			"img:///UILibrary_XPACK_StrategyImages.DarkEvent_MadeWhole");
		}

		class'LWTutorial'.static.CompleteObjective('LW_TUT_FirstRetaliation');
		`PRESBASE.UITutorialBox(
			default.FirstRetaliationTitle,
			default.FirstRetaliationBody,
			"img:///UILibrary_LW_Overhaul.TutorialImages.LWOTC_Logo");
	}

	return ELR_NoInterrupt;
}

// Pop up a tutorial box when the Geoscape is first entered that directs the
// player to their starting haven/outpost.
static function EventListenerReturn ShowArchivesTutorial(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name InEventID,
	Object CallbackData)
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_CommandersQuarters'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_CommandersQuarters');
		`PRESBASE.UITutorialBox(
			default.CommandersQuartersEnteredTitle,
			default.CommandersQuartersEnteredBody,
			"img:///UILibrary_LW_Overhaul.TutorialImages.LWOTC_Logo");
	}

	return ELR_NoInterrupt;
}
