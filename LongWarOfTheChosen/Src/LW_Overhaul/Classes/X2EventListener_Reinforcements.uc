// X2EventListener_Reinforcements.uc
// 
// A listener template that allows LW2 to override game behaviour related to
// reinforcements, such as whether the reinforcement flare should be shown or
// not.
//
class X2EventListener_Reinforcements extends X2EventListener config(LW_Overhaul);

var config int LISTENER_PRIORITY;
var config array<bool> DISABLE_REINFORCEMENT_FLARES;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateReinforcementsListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateReinforcementsListeners()
{
	local CHEventListenerTemplate Template;
	
	`LWTrace("Registering reinforcements event listeners");

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'ReinforcementsListeners');
	Template.AddCHEvent('OverrideDisableReinforcementsFlare', OnOverrideDisableReinforcementsFlare, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('OverrideReinforcementsAlert', OnOverrideReinforcementsAlert, ELD_Immediate, GetListenerPriority());
	Template.RegisterInTactical = true;
	// Template.RegisterInStrategy = true;

	return Template;
}

static protected function int GetListenerPriority()
{
	return default.LISTENER_PRIORITY != -1 ? default.LISTENER_PRIORITY : class'XComGameState_LWListenerManager'.default.DEFAULT_LISTENER_PRIORITY;
}

// Disable the reinforcements flare
static protected function EventListenerReturn OnOverrideDisableReinforcementsFlare(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple OverrideTuple;
	local XComGameState_AIReinforcementSpawner SpawnerState;

	`LWTRACE("OverrideDisableReinforcementsFlare : Starting listener.");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OverrideDisableReinforcementsFlare event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideDisableReinforcementsFlare : Parsed XComLWTuple.");

	SpawnerState = XComGameState_AIReinforcementSpawner(EventSource);
	if(SpawnerState == none)
	{
		`REDSCREEN("OverrideDisableReinforcementsFlare event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideDisableReinforcementsFlare : EventSource valid.");

	if(OverrideTuple.Id != 'OverrideDisableReinforcementsFlare')
		return ELR_NoInterrupt;

	`LWTRACE ("Disable Reinforcement Flares" @ default.DISABLE_REINFORCEMENT_FLARES[`TACTICALDIFFICULTYSETTING]);
	OverrideTuple.Data[0].b = default.DISABLE_REINFORCEMENT_FLARES[`TACTICALDIFFICULTYSETTING];

	return ELR_NoInterrupt;
}

static protected function EventListenerReturn OnOverrideReinforcementsAlert(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple OverrideTuple;
	local XComGameState AssociatedGameState;
	local XComGameState_AIReinforcementSpawner SpawnerState;
	local XComGameState_LWReinforcements LWReinforcements;
	local int ReinfColor;
	local String ReinfState;
	
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OverrideReinforcementsAlert event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	if(OverrideTuple.Id != 'OverrideReinforcementsAlert')
		return ELR_NoInterrupt;

	AssociatedGameState = XComGameState(OverrideTuple.Data[4].o);
	if (AssociatedGameState == none)
	{
		return ELR_NoInterrupt;
	}

	// Look for an active reinforcement spawner.
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_AIReinforcementSpawner', SpawnerState,,, AssociatedGameState.HistoryIndex)
	{
		if (SpawnerState.Countdown > 0)
		{
			`LWTRace("OverrideReinforcementsAlert: Existing RNF spawner detected, setting to red RNF.");
			// Reinforcements are pending. Show the normal indicator.
			OverrideTuple.Data[0].b = true;
			OverrideTuple.Data[1].s = class'UITacticalHUD_Countdown'.default.m_strReinforcementsTitle;
			OverrideTuple.Data[2].s = class'UITacticalHUD_Countdown'.default.m_strReinforcementsBody;
			OverrideTuple.Data[3].s = class'UIUtilities_Colors'.const.BAD_HTML_COLOR;
			return ELR_NoInterrupt;
		}
	}

	// Look for a LW reinforcements object.
	LWReinforcements = XComGameState_LWReinforcements(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWReinforcements', true));
	if (LWReinforcements != none && LWReinforcements.ReinforcementsArePossible())
	{
		// If the reinf system is initialized, show reinforcements as possible.
		if (LWReinforcements.Bucket < 0.5)
		{
			ReinfColor = eUIState_Good;
			ReinfState = class'UIMission_Retaliation'.default.m_strRetaliationWarning;
		}
		else
		{
			ReinfColor = eUIState_Warning;
			ReinfState = class 'UIAdventOperations'.default.m_strImminent;
		}
		`LWTrace("OverrideReinforcementsAlert: LW RNF object detected, setting RNF tuple override to green/yellow.");
		OverrideTuple.Data[0].b = true;
		OverrideTuple.Data[1].s = class'UIUtilities_Text'.static.GetColoredText(class'UITacticalHUD_Countdown'.default.m_strReinforcementsTitle, ReinfColor);
		OverrideTuple.Data[2].s = class'UIUtilities_Text'.static.GetColoredText(ReinfState, ReinfColor);
		OverrideTuple.Data[3].s = class'UIUtilities_Colors'.static.GetHexColorFromState(ReinfColor);
		return ELR_NoInterrupt;
	}

	// No active reinforcements incoming, and we aren't building toward reinforcements on this mission: no override.
	return ELR_NoInterrupt;
}
