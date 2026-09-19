class X2Effect_Quickburn extends X2Effect_Persistent;

var array<name> AllowedAbilities;

// Max number of activations per use
var name CountValueName;
var int ActivationsPerUse;

// Allow using Cost-Based Ability Colors' tuple to adjust the color
// Cannot rely on ability context
var bool bAllowCBACOverride;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local XComGameState_Unit TargetUnit;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;
    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    /// ```event
    /// EventID: OverrideAbilityIconColorCBAC,
    /// EventData: [
    ///     in XComGameState AbilityState,
    ///     out bool bOverride,
    ///     inout string EventOverrideColor,
    ///     inout int PointCost,
    ///     inout int TurnEnding
    /// ],
    /// EventSource: XComGameState_Unit (UnitState)
    /// NewGameState: none
    /// ```
    if (bAllowCBACOverride)
    {
        EventMgr.RegisterForEvent(EffectObj, 'OverrideAbilityIconColorCBAC', OnOverrideAbilityIconColor, ELD_Immediate,, TargetUnit,, EffectObj);
    }
}

static function EventListenerReturn OnOverrideAbilityIconColor(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComLWTuple                   Tuple;
    local bool                          bOverride;
    local XComGameState_Unit            UnitState;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local X2Effect_Quickburn            Effect;
    local int                           PointCost;
    local bool                          bIsTurnEnding;

    Tuple = XComLWTuple(EventData);

    `assert(Tuple != none);
    `assert(Tuple.Id == 'OverrideAbilityIconColorCBAC');

    bOverride = Tuple.Data[1].b;
    PointCost = Tuple.Data[3].i;
    bIsTurnEnding = bool(Tuple.Data[4].i);

    if (PointCost > 0)
    {
        UnitState = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(Tuple.Data[0].o);
        EffectState = XComGameState_Effect(CallbackData);
        if (UnitState != none && AbilityState != none && EffectState != none)
        {
            Effect = X2Effect_Quickburn(EffectState.GetX2Effect());
            if (Effect != none)
            {
                if (Effect.IsEffectCurrentlyRelevant(EffectState, UnitState))
                {
                    if (Effect.IsAbilityRelevant(AbilityState, UnitState, EffectState))
                    {
                        bOverride = true;
                        PointCost = 0;
                        bIsTurnEnding = false;

                        if (bOverride)
                        {
                            Tuple.Data[1].b = bOverride;
                            Tuple.Data[3].i = PointCost;
                            Tuple.Data[4].i = int(bIsTurnEnding);
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(kNewTargetState);
    if (TargetUnit != none)
    {
        TargetUnit.ClearUnitValue(CountValueName);
    }
}

function bool PostAbilityCostPaid(
    XComGameState_Effect EffectState,
    XComGameStateContext_Ability AbilityContext,
    XComGameState_Ability kAbility,
    XComGameState_Unit SourceUnit,
    XComGameState_Item AffectWeapon,
    XComGameState NewGameState,
    const array<name> PreCostActionPoints,
    const array<name> PreCostReservePoints)
{
    local UnitValue             CountUnitValue;

    if (IsEffectCurrentlyRelevant(EffectState, SourceUnit))
    {
        if (IsAbilityRelevant(kAbility, SourceUnit, EffectState))
        {
            if (!class'X2Effect_RefundActionPoints'.static.WasAbilityFree(kAbility, SourceUnit))
            {
                if (CountValueName != '')
                {
                    SourceUnit.GetUnitValue(CountValueName, CountUnitValue);
                    SourceUnit.SetUnitFloatValue(CountValueName, CountUnitValue.fValue + 1, eCleanup_BeginTurn);
                    if (CountUnitValue.fValue + 1 >= ActivationsPerUse)
                    {
                        EffectState.RemoveEffect(NewGameState, NewGameState);
                    }
                }

                SourceUnit.ActionPoints = PreCostActionPoints;
                return true;
            }
        }
    }

    return false;
}



function bool IsAbilityRelevant(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Effect EffectState)
{
    if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
    {
        return false;
    }

    return true;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local UnitValue CountUnitValue;

    if (class'Helpers_LW'.static.IsUnitInterruptingEnemyTurn(TargetUnit))
    {
        return false;
    }

    if (CountValueName != '' && ActivationsPerUse > 0)
    {
        TargetUnit.GetUnitValue(CountValueName, CountUnitValue);
        if (CountUnitValue.fValue >= ActivationsPerUse)
        {
            return false;
        }
    }
    
    return true;
}

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
    return true;
}

defaultproperties
{
    EffectName = M31_Quickburn
    DuplicateResponse = eDupe_Refresh

    CountValueName = M31_Quickburn_Activations
    ActivationsPerUse = 1

    bAllowCBACOverride = true
}