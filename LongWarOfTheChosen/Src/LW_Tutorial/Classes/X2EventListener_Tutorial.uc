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

// Pop up a tutorial box when the Geoscape is first entered that directs the
// player to their starting haven/outpost.
static function EventListenerReturn OnGeoscapeEntered(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_HavenOnGeoscape'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_HavenOnGeoscape');
		`PRESBASE.UITutorialBox(
			default.HavenHighlightTitle,
			default.HavenHighlightBody,
			"img:///UILibrary_LW_Overhaul.TutorialImages.LWHaven_Map_Icon");
	}

	return ELR_NoInterrupt;
}
