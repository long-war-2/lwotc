class X2Effect_SensorOverlays extends X2Effect_Persistent;

var int AimBonus;
var int CritBonus;
var bool bAllowSquadsight;
var bool bAllowStack;

function bool UniqueToHitModifiers()
{
    return !bAllowStack;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Unit            SourceUnit;
    local GameRulesCache_VisibilityInfo VisInfo;
    local ShotModifierInfo              ShotInfo;

    if (IsEffectCurrentlyRelevant(EffectState, Attacker))
    {
        SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

        if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, Target.ObjectID, VisInfo))
        {
            if (VisInfo.bVisibleGameplay || VisInfo.bClearLOS && SourceUnit.HasSquadsight() && bAllowSquadsight)
            {
                ShotInfo.ModType = eHit_Success;
                ShotInfo.Reason = FriendlyName;
                ShotInfo.Value = AimBonus;
                ShotModifiers.AddItem(ShotInfo);

                ShotInfo.ModType = eHit_Crit;
                ShotInfo.Reason = FriendlyName;
                ShotInfo.Value = CritBonus;
                ShotModifiers.AddItem(ShotInfo);
            }
        }
    }
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local XComGameState_Unit SourceUnit;

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    
    if (SourceUnit == none || SourceUnit.IsDead())
    {
        return false;
    }

    return SourceUnit.IsFriendlyUnit(TargetUnit);
}

static function EventListenerReturn AbilityTriggerEventListener_SquadPassive(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Ability         CallbackAbilityState;
    local XComGameState_Unit            TargetUnit;
    local int                           VisualizeIndex;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        CallbackAbilityState = XComGameState_Ability(CallbackData);
        TargetUnit = XComGameState_Unit(EventSource);

        VisualizeIndex = GameState.HistoryIndex;

        if (CallbackAbilityState.OwnerStateObject.ObjectID != TargetUnit.ObjectID)
        {
            if (CallbackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit) == 'AA_Success')
            {
                CallbackAbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false, VisualizeIndex);
            }
        }
        else
        {
            foreach History.IterateByClassType(class'XComGameState_Unit', TargetUnit,,, GameState.HistoryIndex)
            {
                if (CallbackAbilityState.CanActivateAbilityForObserverEvent(TargetUnit) == 'AA_Success')
                {
                    CallbackAbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false, VisualizeIndex);
                }
            }
        }
    }

    return ELR_NoInterrupt;
}