//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_PlaceDelayedEvacZone.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Replacement ability for PlaceEvacZone to include a delay between ability use
//           and evac zone spawn.
//---------------------------------------------------------------------------------------

class X2Ability_PlaceDelayedEvacZone extends X2Ability config(LW_Overhaul);

// How many turns will it take before the skyranger shows up?
var config const array<int> DEFAULT_EVAC_PLACEMENT_DELAY;

// What is the maximum number of turns of delay for the skyranger?
var config const int MAX_EVAC_PLACEMENT_DELAY;
var config const array<int> MIN_EVAC_PLACEMENT_DELAY;

// How much time is added for moving an evac zone that already exists?
var config const int MOVE_EXISTING_EVAC_ZONE_DELAY;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(PlaceDelayedEvacZone());
    return Templates;
}

static function X2AbilityTemplate PlaceDelayedEvacZone()
{
    local X2AbilityTemplate Template;
    local X2AbilityCost_ActionPoints ActionPointCost;
    local X2AbilityCooldown_Global Cooldown;
    local X2AbilityTarget_Cursor CursorTarget;
    local X2AbilityToHitCalc_StandardAim StandardAim;
    local X2Condition_PlaceDelayedEvacZonePermitted CanPlaceEvacZoneCondition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'PlaceDelayedEvacZone');

    Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); // Do not allow "Evac Zone Placement" in MP!

    Template.Hostility = eHostility_Offensive;
    Template.bCommanderAbility = true;
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.PLACE_EVAC_PRIORITY;
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_evac";
    Template.AbilitySourceName = 'eAbilitySource_Commander';
    Template.bShowActivation = false;
    Template.ActivationSpeech = 'EVACrequest';
    Template.bShowPostActivation = false;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bIndirectFire = true;
    StandardAim.bAllowCrit = false;
    Template.AbilityToHitCalc = StandardAim;

    Template.bHideWeaponDuringFire = true;

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;
    Template.TargetingMethod = class'X2TargetingMethod_LWEvacZone';
    // Template.TargetingMethod = class'X2TargetingMethod_EvacZone';

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bFreeCost = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

    Cooldown = new class'X2AbilityCooldown_Global';
    Cooldown.iNumTurns = 3;
    Template.AbilityCooldown = Cooldown;

    // Disallow the evac flare if the global 'PlaceEvacZone' is disabled.
    CanPlaceEvacZoneCondition = new class'X2Condition_PlaceDelayedEvacZonePermitted';
    Template.AbilityShooterConditions.AddItem(CanPlaceEvacZoneCondition);

    Template.BuildNewGameStateFn = PlaceDelayedEvacZone_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;
}

static function int GetEvacDelay()
{
    local XComGameState_LWEvacSpawner EvacSpawner;
    local XComLWTuple EvacDelayTuple;
    local XComLWTValue Value;
    local int Delay;

    // Handle cases where this isn't the first time we've placed an evac zone on this map. If it takes
    // 6 turns for Firebrand to get here from the Avenger, it doesn't make sense to take another 6 turns
    // if we move it when she's already here or if she's almost here but we adjust the zone by 30 feet.
    // But making adjustments instant would be gamey - spawn the zone on turn one near the start point,
    // wait it out, and then just move it to a new place when you complete the objective. That still might
    // be a viable strategy on some timed missions to turn-1 spawn to get her moving, but that costs you
    // concealment.

    // First check if we already have an evac zone. If so we aren't starting from scratch, we're
    // just going to add a small delay.
    if (class'XComGameState_EvacZone'.static.GetEvacZone() != none)
    {
        return default.MOVE_EXISTING_EVAC_ZONE_DELAY;
    }

    // Next look for an existing in-progress spawner. If we find one, add the move delay to the existing
    // countdown instead of starting from scratch.
    EvacSpawner = XComGameState_LWEvacSpawner(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWEvacSpawner', true));
    if (EvacSpawner != none && EvacSpawner.GetCountdown() > 0)
    {
        return EvacSpawner.GetCountdown() + default.MOVE_EXISTING_EVAC_ZONE_DELAY;
    }

    // Below here, we're spawning a new one for the first time, so use the full delay.

    Value.Kind = XComLWTVInt;
    Value.i = default.DEFAULT_EVAC_PLACEMENT_DELAY[`STRATEGYDIFFICULTYSETTING];

    EvacDelayTuple = new class'XComLWTuple';
    EvacDelayTuple.Data.AddItem(Value);
    EvacDelayTuple.Id = 'DelayedEvacTurns';

    `XEVENTMGR.TriggerEvent('GetEvacPlacementDelay', EvacDelayTuple, none);

    if (EvacDelayTuple.Data.Length != 1 || EvacDelayTuple.Data[0].Kind != XComLWTVInt)
    {
        // oops, someone set a bad value.
        `log("X2Ability_PlaceDelayedEvacZone.PlaceDelayedEvacZone_BuildGameState: Bad tuple value returned.");
        Delay = default.DEFAULT_EVAC_PLACEMENT_DELAY[`STRATEGYDIFFICULTYSETTING];
    }
    else
    {
        Delay = Clamp(EvacDelayTuple.Data[0].i, default.MIN_EVAC_PLACEMENT_DELAY[`STRATEGYDIFFICULTYSETTING], default.MAX_EVAC_PLACEMENT_DELAY);
    }

    return Delay;
}

simulated function XComGameState PlaceDelayedEvacZone_BuildGameState(XComGameStateContext Context)
{
    local XComGameState NewGameState;
    local XComGameState_Unit UnitState;
    local XComGameState_Ability AbilityState;
    local XComGameStateContext_Ability AbilityContext;
    local X2AbilityTemplate AbilityTemplate;
    local XComGameStateHistory History;
    local Vector SpawnLocation;
    local int Delay;

    History = `XCOMHISTORY;

    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: X2Ability_PlaceDelayedEvacZone - start building game state");
    // END

    NewGameState = History.CreateNewGameState(true, Context);

    AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID, eReturnType_Reference));
    AbilityTemplate = AbilityState.GetMyTemplate();

    UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));
    AbilityTemplate.ApplyCost(AbilityContext, AbilityState, UnitState, none, NewGameState);
    
    NewGameState.AddStateObject(UnitState);

    `assert(AbilityContext.InputContext.TargetLocations.Length == 1);
    SpawnLocation = AbilityContext.InputContext.TargetLocations[0];

    Delay = GetEvacDelay();
    class'XComGameState_LWEvacSpawner'.static.InitiateEvacZoneDeployment(Delay, SpawnLocation, NewGameState);

    // WOTC DEBUGGING:
    `LWTrace("PlaceDelayedEvacZone debugging: X2Ability_PlaceDelayedEvacZone - finish building game state");
    // END

    return NewGameState;
}
