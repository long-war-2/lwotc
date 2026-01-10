class X2Effect_SkirmisherReflex_LW extends X2Effect_SkirmisherReflex;

var int ActivationsPerMission;
var bool bAllowAsMultiTarget;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectEventListener_SkirmisherReflex, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn EffectEventListener_SkirmisherReflex(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameStateHistory          History;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            Attacker, Defender;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local X2Effect_SkirmisherReflex_LW  Effect;
    local X2AbilityTemplate             AbilityTemplate;
    local XComGameState                 NewGameState;
    local UnitValue                     TotalValue, ReflexValue;
    local int                           Index;
    local bool                          bIsDirectAttack;

    History = `XCOMHISTORY;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        Attacker = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        EffectState = XComGameState_Effect(CallbackData);

        if (Attacker != none && AbilityState != none && EffectState != none)
        {
            Defender = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
            Effect = X2Effect_SkirmisherReflex_LW(EffectState.GetX2Effect());

            if (Defender != none && Effect != none)
            {
                AbilityTemplate = AbilityState.GetMyTemplate();
                if (AbilityState.IsAbilityInputTriggered() && AbilityTemplate.Hostility == eHostility_Offensive)
                {
                    bIsDirectAttack = AbilityContext.InputContext.PrimaryTarget.ObjectID == Defender.ObjectID;
                    if (!bIsDirectAttack && Effect.bAllowAsMultiTarget)
                    {
                        for (Index = 0; Index < AbilityContext.InputContext.MultiTargets.Length; Index++)
                        {
                            if (AbilityContext.InputContext.MultiTargets[Index].ObjectID == Defender.ObjectID)
                            {
                                bIsDirectAttack = true;
                                break;
                            }
                        }
                    }

                    if (!bIsDirectAttack)
                        return ELR_NoInterrupt;

                    if (Defender.IsFriendlyUnit(Attacker))
                        return ELR_NoInterrupt;

                    Defender.GetUnitValue(Effect.TotalEarnedValue, TotalValue);
                    if (Effect.ActivationsPerMission > 0 && TotalValue.fValue >= Effect.ActivationsPerMission)
                        return ELR_NoInterrupt;

                    if (Defender.IsAbleToAct() && !Defender.IsMindControlled())
                    {
                        if (Defender.ControllingPlayer == `TACTICALRULES.GetCachedUnitActionPlayerRef())
                        {
                            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Skirmisher Reflex Immediate Action");
                            Defender = XComGameState_Unit(NewGameState.ModifyStateObject(Defender.Class, Defender.ObjectID));
                            Defender.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
                            Defender.SetUnitFloatValue(Effect.TotalEarnedValue, TotalValue.fValue + 1, eCleanup_BeginTactical);
                        }
                        else
                        {
                            Defender.GetUnitValue(Effect.ReflexUnitValue, ReflexValue);
                            if (ReflexValue.fValue == 0)
                            {
                                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Skirmisher Reflex For Next Turn Increment");
                                Defender = XComGameState_Unit(NewGameState.ModifyStateObject(Defender.Class, Defender.ObjectID));
                                Defender.SetUnitFloatValue(Effect.ReflexUnitValue, 1, eCleanup_BeginTactical);
                                Defender.SetUnitFloatValue(Effect.TotalEarnedValue, TotalValue.fValue + 1, eCleanup_BeginTactical);
                            }
                        }
                        if (NewGameState != none)
                        {
                            NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
                            XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectState.TriggerAbilityFlyoverVisualizationFn;
                            `TACTICALRULES.SubmitGameState(NewGameState);
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
    local UnitValue ReflexValue;

    if (UnitState.GetUnitValue(ReflexUnitValue, ReflexValue))
    {
        if (ReflexValue.fValue > 0)
        {
            if (UnitState.IsAbleToAct() && !UnitState.IsMindControlled())
            {
                ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
            }
        }
        UnitState.ClearUnitValue(ReflexUnitValue);
    }
}

defaultproperties
{
    bAllowAsMultiTarget = false
}