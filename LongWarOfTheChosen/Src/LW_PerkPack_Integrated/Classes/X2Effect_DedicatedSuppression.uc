class X2Effect_DedicatedSuppression extends X2Effect_Persistent config(LW_SoldierSkills);

var array<name> AllowedActionPointTypes;
var config array<name> SuppressionActionPoints;
var config array<name> DedicatedSuppressionAbilities;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local Object                EffectObj;
    local XComGameState_Unit    TargetState;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'OverrideDamageRemovesReserveActionPoints', OnOverrideDamageRemovesReserveActionPoints, ELD_Immediate,, TargetState,, EffectObj);
}

static function EventListenerReturn OnOverrideDamageRemovesReserveActionPoints(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local bool bDamageRemovesReserveActionPoints;
    local XComGameState_Unit UnitState;
    local XComGameState_Effect EffectState;
    local X2Effect_DedicatedSuppression Effect;

    Tuple = XComLWTuple(EventData);

    if (Tuple != none && Tuple.Id == 'OverrideDamageRemovesReserveActionPoints')
    {
        bDamageRemovesReserveActionPoints = Tuple.Data[0].b;

        if (bDamageRemovesReserveActionPoints)
        {
            UnitState = XComGameState_Unit(EventSource);
            EffectState = XComGameState_Effect(CallbackData);
            Effect = X2Effect_DedicatedSuppression(EffectState.GetX2Effect());
            if (UnitState != none && EffectState != none && Effect != none)
            {
                if (Effect.ValidateReservePoints(UnitState))
                {
                    bDamageRemovesReserveActionPoints = false;
                    Tuple.Data[0].b = bDamageRemovesReserveActionPoints;
                }
            }
        }

        return ELR_NoInterrupt;
    }
}

function bool ValidateReservePoints(XComGameState_Unit UnitState)
{
    local name ActionPointName;
    if (AllowedActionPointTypes.Length > 0)
    {
        foreach UnitState.ReserveActionPoints(ActionPointName)
        {
            if (AllowedActionPointTypes.Find(ActionPointName) != INDEX_NONE)
            {
                return true;
            }
        }
        return false;
    }

    return UnitState.ReserveActionPoints.Length > 0;
}

// Delegate that registers the effect to be removed when taking damage
static function Suppression_EffectAdded(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
    local XComGameStateHistory  History;
    local X2EventManager        EventMgr;
    local Object                EffectObj;
    local XComGameState_Unit    SourceUnit;
    local XComGameState_Effect  EffectState;
    local StateObjectReference  EffectRef;
    local int                   idx;
    local name                  AbilityName;

    History = `XCOMHISTORY;

    // Do nothing if the effect is already registered by default
    if (PersistentEffect.bRemoveWhenSourceDamaged)
    {
        return;
    }

    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    if (SourceUnit == none)
    {
        SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    }

    if (SourceUnit != none)
    {
        // If the source has any of these abilities, do not register the effect for the event
        foreach default.DedicatedSuppressionAbilities(AbilityName)
        {
            if (SourceUnit.HasSoldierAbility(AbilityName, true))
            {
                return;
            }
        }

        foreach SourceUnit.AppliedEffects(EffectRef, idx)
        {
            if (SourceUnit.AppliedEffectNames[idx] == PersistentEffect.EffectName)
            {
                EffectState = XComGameState_Effect(NewGameState.GetGameStateForObjectID(EffectRef.ObjectID));
                if (EffectState == none)
                {
                    EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
                }
                if (EffectState != none)
                {
                    if (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)
                    {
                        break;
                    }
                    else
                    {
                        EffectState = none;
                    }
                }
            }
        }

        if (EffectState != none)
        {
            EventMgr = `XEVENTMGR;
            EffectObj = EffectState;
            EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', EffectState.OnSourceUnitTookEffectDamage, ELD_OnStateSubmitted,, SourceUnit);
        }
    }
}

defaultproperties
{
    EffectName = DedicatedSuppression_LW
    DuplicateResponse = eDupe_Ignore
}