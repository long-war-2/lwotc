// X2EventListener_Tactical.uc
// 
// A listener template that allows LW2 to override game behaviour related to
// tactical missions. It's a dumping ground for tactical stuff that doesn't
// fit with more specific listener classes.
//
class X2EventListener_Tactical extends X2EventListener config(LW_Overhaul);

var config int LISTENER_PRIORITY;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateEvacListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateEvacListeners()
{
	local CHEventListenerTemplate Template;
	
	`LWTrace("Registering evac event listeners");

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'EvacListeners');
	Template.AddCHEvent('GetEvacPlacementDelay', OnPlacedDelayedEvacZone, ELD_Immediate, GetListenerPriority());
	Template.RegisterInTactical = true;

	return Template;
}

static protected function int GetListenerPriority()
{
	return default.LISTENER_PRIORITY != -1 ? default.LISTENER_PRIORITY : class'XComGameState_LWListenerManager'.default.DEFAULT_LISTENER_PRIORITY;
}

// Handles modification of the evac timer based on various conditions, such as
// infiltration percentage, squad size, etc.
static function EventListenerReturn OnPlacedDelayedEvacZone(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple EvacDelayTuple;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_LWPersistentSquad Squad;
	local XComGameState_MissionSite MissionState;
	local XComGameState_LWAlienActivity CurrentActivity;

	EvacDelayTuple = XComLWTuple(EventData);
	if(EvacDelayTuple == none)
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Id != 'DelayedEvacTurns')
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Data[0].Kind != XComLWTVInt)
		return ELR_NoInterrupt;

	XComHQ = `XCOMHQ;
	SquadMgr = class'XComGameState_LWSquadManager'.static.GetSquadManager();
	if(SquadMgr == none)
		return ELR_NoInterrupt;

	Squad = SquadMgr.GetSquadOnMission(XComHQ.MissionRef);

	`LWTRACE("**** Evac Delay Calculations ****");
	`LWTRACE("Base Delay : " $ EvacDelayTuple.Data[0].i);

	// adjustments based on squad size
	EvacDelayTuple.Data[0].i += Squad.EvacDelayModifier_SquadSize();
	`LWTRACE("After Squadsize Adjustment : " $ EvacDelayTuple.Data[0].i);

	// adjustments based on infiltration
	EvacDelayTuple.Data[0].i += Squad.EvacDelayModifier_Infiltration();
	`LWTRACE("After Infiltration Adjustment : " $ EvacDelayTuple.Data[0].i);

	// adjustments based on number of active missions engaged with
	EvacDelayTuple.Data[0].i += Squad.EvacDelayModifier_Missions();
	`LWTRACE("After NumMissions Adjustment : " $ EvacDelayTuple.Data[0].i);

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	CurrentActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);

	EvacDelayTuple.Data[0].i += CurrentActivity.GetMyTemplate().MissionTree[CurrentActivity.CurrentMissionLevel].EvacModifier;

	`LWTRACE("After Activity Adjustment : " $ EvacDelayTuple.Data[0].i);
	
	return ELR_NoInterrupt;

}
