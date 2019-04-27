//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWEvacSpawner.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Game state for tracking delayed evac zone deployment.
//---------------------------------------------------------------------------------------

class XComGameState_LWEvacSpawner extends XComGameState_BaseObject
    config(LW_Overhaul)
    implements(LWVisualizedInterface);

var privatewrite Vector SpawnLocation;
var privatewrite int Countdown;
var privatewrite bool SkipCreationNarrative;

var config String FlareEffectPathName;
var config String EvacRequestedNarrativePathName;
var config String FirebrandArrivedNarrativePathName;

function OnEndTacticalPlay(XComGameState NewGameState)
{
    local X2EventManager EventManager;
    local Object ThisObj;

    ThisObj = self;
    EventManager = `XEVENTMGR;

    EventManager.UnRegisterFromEvent(ThisObj, 'EvacSpawnerCreated');
    EventManager.UnRegisterFromEvent(ThisObj, 'SpawnEvacZoneComplete');
}

// A new evac spawner was created.
function EventListenerReturn OnEvacSpawnerCreated(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState NewGameState;
    local XComGameState_LWEvacSpawner NewSpawnerState;
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - start OnEvacSpawnerCreated");
    // END

    // Set up visualization to drop the flare.
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
    XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = BuildVisualizationForSpawnerCreation;
    NewSpawnerState = XComGameState_LWEvacSpawner(NewGameState.CreateStateObject(class'XComGameState_LWEvacSpawner', ObjectID));
    NewGameState.AddStateObject(NewSpawnerState);
    `TACTICALRULES.SubmitGameState(NewGameState);

    // no countdown specified, spawn the evac zone immediately. Otherwise we'll tick down each turn start (handled in
    // UIScreenListener_TacticalHUD to also display the counter).
    if(Countdown == 0)
    {
        NewSpawnerState.SpawnEvacZone();
    }

    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - end OnEvacSpawnerCreated");
    // END

    return ELR_NoInterrupt;
}

// Visualize the spawner creation: drop a flare at the point the evac zone will appear.
function BuildVisualizationForSpawnerCreation(XComGameState VisualizeGameState)
{
    local VisualizationActionMetadata BuildTrack;
    local XComGameStateHistory History;
    local XComGameState_LWEvacSpawner EvacSpawnerState;
    local X2Action_PlayEffect EvacSpawnerEffectAction;
    local X2Action_PlayNarrative NarrativeAction;

    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - start BuildVisualizationForSpawnerCreation");
    // END

    History = `XCOMHISTORY;
    EvacSpawnerState = XComGameState_LWEvacSpawner(History.GetGameStateForObjectID(ObjectID));

    // Temporary flare effect is the advent reinforce flare. Replace this.
    EvacSpawnerEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
    EvacSpawnerEffectAction.EffectName = FlareEffectPathName;
    EvacSpawnerEffectAction.EffectLocation = EvacSpawnerState.SpawnLocation;

    // Don't take control of the camera, the player knows where they put the zone.
    EvacSpawnerEffectAction.CenterCameraOnEffectDuration = 0; //ContentManager.LookAtCamDuration;
    EvacSpawnerEffectAction.bStopEffect = false;

    BuildTrack.StateObject_OldState = EvacSpawnerState;
    BuildTrack.StateObject_NewState = EvacSpawnerState;

    if (!EvacSpawnerState.SkipCreationNarrative)
    {
        NarrativeAction = X2Action_PlayNarrative(class'X2Action_PlayNarrative'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
        NarrativeAction.Moment = XComNarrativeMoment(DynamicLoadObject(EvacRequestedNarrativePathName, class'XComNarrativeMoment'));
        NarrativeAction.WaitForCompletion = false;
    }

    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - end BuildVisualizationForSpawnerCreation");
    // END
}

// Countdown complete: time to spawn the evac zone.
function SpawnEvacZone()
{
    local XComGameState NewGameState;
    local X2EventManager EventManager;
    local Object ThisObj;

    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - start SpawnEvacZone");
    // END

    EventManager = `XEVENTMGR;

    // Set up visualization of the new evac zone.
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SpawnEvacZone");
    XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = BuildVisualizationForEvacSpawn;

    // Place the evac zone on the map.
    class'XComGameState_EvacZone'.static.PlaceEvacZone(NewGameState, SpawnLocation, eTeam_XCom);

    // Register and trigger an event to occur after we've visualized this to clean ourselves up.
    ThisObj = self;
    EventManager.RegisterForEvent(ThisObj, 'SpawnEvacZoneComplete', OnSpawnEvacZoneComplete, ELD_OnStateSubmitted,, ThisObj);
    EventManager.TriggerEvent('SpawnEvacZoneComplete', ThisObj, ThisObj, NewGameState);

    `TACTICALRULES.SubmitGameState(NewGameState);
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - end SpawnEvacZone");
    // END
}

// Evac zone has spawned. We can now clean ourselves up as this state object is no longer needed.
function EventListenerReturn OnSpawnEvacZoneComplete(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState NewGameState;
    local XComGameState_LWEvacSpawner NewSpawnerState;
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - start OnSpawnEvacZoneComplete");
    // END

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Spawn Evac Zone Complete");
    NewSpawnerState = XComGameState_LWEvacSpawner(NewGameState.CreateStateObject(class'XComGameState_LWEvacSpawner', ObjectID));
    NewSpawnerState.ResetCountdown();
    NewGameState.AddStateObject(NewSpawnerState);
    `TACTICALRULES.SubmitGameState(NewGameState);
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - end OnSpawnEvacZoneComplete");
    // END

    return ELR_NoInterrupt;
}

function BuildVisualizationForFlareDestroyed(XComGameState VisualizeState)
{
    local X2Action_PlayEffect EvacSpawnerEffectAction;
    local VisualizationActionMetadata BuildTrack;
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - start BuildVisualizationForFlareDestroyed");
    // END

    EvacSpawnerEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(BuildTrack, VisualizeState.GetContext(), false, BuildTrack.LastActionAdded));
    EvacSpawnerEffectAction.EffectName = FlareEffectPathName;
    EvacSpawnerEffectAction.EffectLocation = SpawnLocation;
    EvacSpawnerEffectAction.bStopEffect = true;
    EvacSpawnerEffectAction.bWaitForCompletion = false;
    EvacSpawnerEffectAction.bWaitForCameraCompletion = false;
    
    BuildTrack.StateObject_OldState = self;
    BuildTrack.StateObject_NewState = self;
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - end BuildVisualizationForFlareDestroyed");
    // END
}

// Visualize the evac spawn: turn off the flare we dropped as a countdown visualizer and visualize the evac zone dropping.
function BuildVisualizationForEvacSpawn(XComGameState VisualizeState)
{
    local XComGameStateHistory History;
    local XComGameState_EvacZone EvacZone;
    local VisualizationActionMetadata BuildTrack;
    local VisualizationActionMetadata EmptyTrack;
    local XComGameState_LWEvacSpawner EvacSpawnerState;
    local X2Action_PlayEffect EvacSpawnerEffectAction;
    local X2Action_PlayNarrative NarrativeAction;
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - start BuildVisualizationForEvacSpawn");
    // END

    History = `XCOMHISTORY;

    // First, get rid of our old visualization from the delayed spawn.
    EvacSpawnerState = XComGameState_LWEvacSpawner(History.GetGameStateForObjectID(ObjectID));

    EvacSpawnerEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(BuildTrack, VisualizeState.GetContext(), false, BuildTrack.LastActionAdded));
    EvacSpawnerEffectAction.EffectName = FlareEffectPathName;
    EvacSpawnerEffectAction.EffectLocation = EvacSpawnerState.SpawnLocation;
    EvacSpawnerEffectAction.bStopEffect = true;
    EvacSpawnerEffectAction.bWaitForCompletion = false;
    EvacSpawnerEffectAction.bWaitForCameraCompletion = false;
    
    BuildTrack.StateObject_OldState = EvacSpawnerState;
    BuildTrack.StateObject_NewState = EvacSpawnerState;

    // Now add the new visualization for the evac zone placement.
    BuildTrack = EmptyTrack;

    foreach VisualizeState.IterateByClassType(class'XComGameState_EvacZone', EvacZone)
    {
        break;
    }
    `assert (EvacZone != none);

    BuildTrack.StateObject_OldState = EvacZone;
    BuildTrack.StateObject_NewState = EvacZone;
    BuildTrack.VisualizeActor = EvacZone.GetVisualizer();
    class'X2Action_PlaceEvacZone'.static.AddToVisualizationTree(BuildTrack, VisualizeState.GetContext(), false, BuildTrack.LastActionAdded);
    NarrativeAction = X2Action_PlayNarrative(class'X2Action_PlayNarrative'.static.AddToVisualizationTree(BuildTrack, VisualizeState.GetContext(), false, BuildTrack.LastActionAdded));
    NarrativeAction.Moment = XComNarrativeMoment(DynamicLoadObject(FirebrandArrivedNarrativePathName, class'XComNarrativeMoment'));
    NarrativeAction.WaitForCompletion = false;
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - end BuildVisualizationForEvacSpawn");
    // END
}

function InitEvac(int Turns, vector Loc)
{
    Countdown = Turns;
    SpawnLocation = Loc;

    `CONTENT.RequestGameArchetype(FlareEffectPathName);
}

// Entry point: create a delayed evac zone instance with the given countdown and position.
static function InitiateEvacZoneDeployment(
    int InitialCountdown,
    const out Vector DeploymentLocation,
    optional XComGameState IncomingGameState,
    optional bool bSkipCreationNarrative)
{
    local XComGameState_LWEvacSpawner NewEvacSpawnerState;
    local XComGameState NewGameState;
    local X2EventManager EventManager;
    local Object EvacObj;
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - start InitiateEvacZoneDeployment");
    // END

    EventManager = `XEVENTMGR;

    if (IncomingGameState == none)
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating XCom Evac Spawner");
    }
    else
    {
        NewGameState = IncomingGameState;
    }

    NewEvacSpawnerState = XComGameState_LWEvacSpawner(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWEvacSpawner', true));
    if (NewEvacSpawnerState != none)
    {
        NewEvacSpawnerState = XComGameState_LWEvacSpawner(NewGameState.CreateStateObject(class'XComGameState_LWEvacSpawner', NewEvacSpawnerState.ObjectID));
    }
    else
    {
        NewEvacSpawnerState = XComGameState_LWEvacSpawner(NewGameState.CreateStateObject(class'XComGameState_LWEvacSpawner'));
    }

    // Clean up any existing evac zone.
    RemoveExistingEvacZone(NewGameState);

    NewEvacSpawnerState.InitEvac(InitialCountdown, DeploymentLocation);
    NewEvacSpawnerState.SkipCreationNarrative = bSkipCreationNarrative;

    NewGameState.AddStateObject(NewEvacSpawnerState);

    // Let others know we've requested an evac.
    EventManager.TriggerEvent('EvacRequested', NewEvacSpawnerState, NewEvacSpawnerState, NewGameState);

    // Register & immediately trigger a new event to react to the creation of this object. This should allow visualization to
    // occur in the desired order: e.g. we see the visualization of the place evac zone ability before the visualization of the state itself
    // (i.e. the flare).
    
    // NOTE: This event isn't intended for other parts of the code to listen to. See the 'EvacRequested' event below for that.
    EvacObj = NewEvacSpawnerState;
    EventManager.RegisterForEvent(EvacObj, 'EvacSpawnerCreated', OnEvacSpawnerCreated, ELD_OnStateSubmitted, , NewEvacSpawnerState);
    EventManager.TriggerEvent('EvacSpawnerCreated', NewEvacSpawnerState, NewEvacSpawnerState);

    if (IncomingGameState == none)
    {
        `TACTICALRULES.SubmitGameState(NewGameState);
    }
    
        // WOTC DEBUGGING:
        `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - end InitiateEvacZoneDeployment");
        // END
}

// Nothing to do here.
function SyncVisualizer(optional XComGameState GameState = none)
{

}

// Called when we load a saved game with an active delayed evac zone counter. Put the flare effect back up again, but don't
// focus the camera on it.
function AppendAdditionalSyncActions(out VisualizationActionMetadata ActionMetadata)
{
    local X2Action_PlayEffect PlayEffect;
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - start AppendAdditionalSyncActions");
    // END

    PlayEffect = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, GetParentGameState().GetContext(), false, ActionMetadata.LastActionAdded));

    PlayEffect.EffectName = FlareEffectPathName;

    PlayEffect.EffectLocation = SpawnLocation;
    PlayEffect.CenterCameraOnEffectDuration = 0;
    PlayEffect.bStopEffect = false;
    
    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: XCGS_LWEvacSpawner - end AppendAdditionalSyncActions");
    // END
}

function int GetCountdown()
{
    return Countdown;
}

function SetCountdown(int NewCountdown)
{
    Countdown = NewCountdown;
}

function ResetCountdown()
{
    // Clear the countdown (effectively disable the spawner)
    Countdown = -1;
}

function TTile GetCenterTile()
{
	return `XWORLD.GetTileCoordinatesFromPosition(SpawnLocation);
}

function static RemoveExistingEvacZone(XComGameState NewGameState)
{
    local XComGameState_EvacZone EvacZone;
    local X2Actor_EvacZone EvacZoneActor;

    EvacZone = class'XComGameState_EvacZone'.static.GetEvacZone();
    if (EvacZone == none)
        return;

    EvacZoneActor = X2Actor_EvacZone(EvacZone.GetVisualizer());
    if (EvacZoneActor == none)
        return;

    // We have an existing evac zone

    // Disable the evac ability
    class'XComGameState_BattleData'.static.SetGlobalAbilityEnabled('Evac', false, NewGameState);

    // Tell the visualizer to clean itself up.
    EvacZoneActor.Destroy();
    
    // Remove the evac zone state (even though we destroyed its visualizer, the state is still
    // there and will reappear if we reload the save).
    NewGameState.RemoveStateObject(EvacZone.ObjectID);

    // Stop the EvacZoneFlare environmental SFX (chopper blades/exhaust)
    //class'WorldInfo'.static.GetWorldInfo().StopAkSound('EvacZoneFlares');
}

static function XComGameState_LWEvacSpawner GetPendingEvacZone()
{
    local XComGameState_LWEvacSpawner EvacState;
    local XComGameStateHistory History;

    History = `XCOMHistory;
    foreach History.IterateByClassType(class'XComGameState_LWEvacSpawner', EvacState)
    {
		if (EvacState.GetCountdown() > 0)
		{
			return EvacState;
		}
    }    
    return none;
}

function vector GetLocation()
{
    return SpawnLocation;
}

defaultproperties
{
	bTacticalTransient=true
}