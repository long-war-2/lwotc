// X2EventListener_PodManagement.uc
// 
// A listener template that updates the LW2 pod manager when various events
// trigger. These listeners used to be in `XCGS_LWPodManager` itself.
//
class X2EventListener_PodManagement extends X2EventListener config(LW_Overhaul);

var config int LISTENER_PRIORITY;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListeners());

	return Templates;
}

static function CHEventListenerTemplate CreateListeners()
{
	local CHEventListenerTemplate Template;

	`LWTrace("Registering evac event listeners");

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'PodManagementListeners');
	Template.AddCHEvent('AlienTurnBegun', OnAlienTurnBegin, ELD_OnStateSubmitted, GetListenerPriority());
	Template.AddCHEvent('UnitGroupTurnBegun', OnUnitGroupTurnBegun, ELD_OnStateSubmitted, GetListenerPriority());
	Template.AddCHEvent('AbilityActivated', SetPodManagerAlert, ELD_OnStateSubmitted, GetListenerPriority());

	Template.RegisterInTactical = true;

	return Template;
}

static protected function int GetListenerPriority()
{
	return default.LISTENER_PRIORITY != -1 ? default.LISTENER_PRIORITY : class'XComGameState_LWListenerManager'.default.DEFAULT_LISTENER_PRIORITY;
}

// If we have a 'RedAlert' or 'YellowAlert' ability activation set the alert flag in the pod manager: we're on.
static function EventListenerReturn SetPodManagerAlert(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Ability Ability;
	local XComGameState NewGameState;
	local XComGameState_LWPodManager NewPodManager;

	Ability = XComGameState_Ability(EventData);
	if (Ability != none && 
			(Ability.GetMyTemplateName() == 'RedAlert' || Ability.GetMyTemplateName() == 'YellowAlert') &&
			GameState != none && 
			XComGameStateContext_Ability(GameState.GetContext()).ResultContext.InterruptionStep <= 0)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("PodManager: RedAlert");
		NewPodManager = XComGameState_LWPodManager(NewGameState.ModifyStateObject(class'XComGameState_LWPodManager', `LWPODMGR.ObjectID));
		NewGameState.AddStateObject(NewPodManager);
		NewPodManager.AlertLevel = (Ability.GetMyTemplateName() == 'RedAlert') ? `ALERT_LEVEL_RED : `ALERT_LEVEL_YELLOW;
		`TACTICALRULES.SubmitGameState(NewGameState);
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnAlienTurnBegin(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_LWPodManager NewPodManager;

	// If we're still concealed, don't take any actions yet.
	// XComPlayer = class'Utilities_LW'.static.FindPlayer(eTeam_XCom);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Preparing Pod Jobs");
    NewPodManager = XComGameState_LWPodManager(NewGameState.ModifyStateObject(class'XComGameState_LWPodManager', `LWPODMGR.ObjectID));

	// If we're in green alert (from mission start) check if we should immediately bump it to yellow
	// because of the mission type.
	if (NewPodManager.AlertLevel == `ALERT_LEVEL_GREEN && `TACTICALMISSIONMGR.ActiveMission.AliensAlerted)
	{
		NewPodManager.AlertLevel = `ALERT_LEVEL_YELLOW;
	}

	// Don't activate pod mechanics until both we have an alert activation on a pod
    // (Reapers can activate pods without breaking concealment, so dropping the
    // "squad is concealed" check. Also not sure what it's for.)
	if (NewPodManager.AlertLevel != `ALERT_LEVEL_GREEN) // && !XComPlayer.bSquadIsConcealed)
	{
        NewPodManager.TurnInit(NewGameState);
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnUnitGroupTurnBegun(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
    local XComGameState_LWPodManager NewPodManager;
    local XComGameState_AIGroup GroupState;
    
    GroupState = XComGameState_AIGroup(EventSource);
    if (GroupState == none)
    {
        `REDSCREEN("XCGS_AIGroup not passed as event source for 'UnitGroupTurnBegun'");
        return ELR_NoInterrupt;
    }

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating Pod Job");
	NewPodManager = XComGameState_LWPodManager(NewGameState.ModifyStateObject(class'XComGameState_LWPodManager', `LWPODMGR.ObjectID));
	NewPodManager.UpdatePod(NewGameState, GroupState);

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}

	return ELR_NoInterrupt;
}
