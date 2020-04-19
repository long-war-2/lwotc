//----------------------------------------------------------------------------------------
//  FILE:    X2EventListener_Tutorial.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Handle various LWOTC tutorial events.
//----------------------------------------------------------------------------------------

class X2EventListener_Tutorial extends X2EventListener config(LW_Tutorial);

var localized string DroneSightedTitle;
var localized string DroneSightedBody;
var localized string EngineerSightedTitle;
var localized string EngineerSightedBody;
var localized string SentrySightedTitle;
var localized string SentrySightedBody;
var localized string GunnerSightedTitle;
var localized string GunnerSightedBody;
var localized string RocketeerSightedTitle;
var localized string RocketeerSightedBody;

var localized string HavenHighlightTitle;
var localized string HavenHighlightBody;

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
	Template.AddCHEvent('EngineerSighted', OnEngineerSighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('SentrySighted', OnSentrySighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('GunnerSighted', OnGunnerSighted, ELD_OnStateSubmitted, 90);
	Template.AddCHEvent('RocketeerSighted', OnRocketeerSighted, ELD_OnStateSubmitted, 90);
	Template.RegisterInTactical = true;

	return Template;
}

static function CHEventListenerTemplate CreateStrategyListeners()
{
	local CHEventListenerTemplate Template;

	// Use a high priority for these listeners because we want them triggering
	// before the strategy objective is completed from the same event.
	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'StrategyTutorialListeners');
	Template.AddCHEvent('OnGeoscapeEntry', OnGeoscapeEntered, ELD_Immediate);
	Template.RegisterInStrategy = true;

	return Template;
}

// Pop up a tutorial box when a drone is sighted for the first time
static function EventListenerReturn OnDroneSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('LW_TUT_DroneSighted'))
	{
		// Show the tutorial box for drones
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.DroneSightedTitle,
				default.DroneSightedBody,
				"img:///UILibrary_LW_Overhaul.TutorialImages.LWDrone");
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnEngineerSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('LW_TUT_EngineerSighted'))
	{
		// Show the tutorial box for Engineers
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.EngineerSightedTitle,
				default.EngineerSightedBody,
				"img:///UILibrary_LW_Overhaul.TutorialImages.LWEngineer");
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnSentrySighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('LW_TUT_SentrySighted'))
	{
		// Show the tutorial box for Sentries
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.SentrySightedTitle,
				default.SentrySightedBody,
				"img:///UILibrary_LW_Overhaul.TutorialImages.LWSentry");
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnGunnerSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('LW_TUT_GunnerSighted'))
	{
		// Show the tutorial box for Gunners
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.GunnerSightedTitle,
				default.GunnerSightedBody,
				"img:///UILibrary_LW_Overhaul.TutorialImages.LWGunner");
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnRocketeerSighted(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (!`SecondWaveEnabled('DisableTutorial') && !class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('LW_TUT_RocketeerSighted'))
	{
		// Show the tutorial box for rocketeers
		class'XComGameStateContext_TutorialBox'.static.AddModalTutorialBoxToHistoryExplicit(
				default.RocketeerSightedTitle,
				default.RocketeerSightedBody,
				"img:///UILibrary_LW_Overhaul.TutorialImages.LWRocketeer");
	}
	return ELR_NoInterrupt;
}

// Pop up a tutorial box when the Geoscape is first entered that directs the
// player to their starting haven/outpost.
static function EventListenerReturn OnGeoscapeEntered(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('LW_TUT_HavenOnGeoscape') == eObjectiveState_InProgress)
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_HavenOnGeoscape');
		`PRESBASE.UITutorialBox(
			default.HavenHighlightTitle,
			default.HavenHighlightBody,
			"img:///UILibrary_LW_Overhaul.TutorialImages.LWHaven_Map_Icon");
	}

	return ELR_NoInterrupt;
}
