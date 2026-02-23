class X2Effect_DeathFromAbove_LW extends X2Effect_DeathFromAbove config(LW_SoldierSkills);

var config int DFA_USES_PER_TURN;
var config array<name> DFA_BLACKLISTED_ABILITIES;
var config float DFA_RANGE_PENALTY_NEGATION_MODIFIER;
var config int DFA_RANGE_PENALTY_NEGATION_BASE_RANGE;
var config bool DFA_DISABLE_WITH_SERIAL;

var bool bMatchSourceWeapon;
// If `true`, all abilities that have AbilityMultiTargetStyle that's not X2AbilityMultiTarget_BurstFire will be blacklisted
var bool bDisallowMultiTarget;
// If `false`, the effect will be activated if any of the units in AbilityContext.InputContext.MultiTargets satisfy the conditions
var bool bOnlyPrimaryTarget;
// If `true`, the effect will be activated only if the activated ability wasn't free
var bool bDisallowFreeActions;
// If `true`, the effects will be disabled while Serial is active
var bool bDisableWithSerial;

var name PointType;
var int ActivationsPerTurn;

var array<name> BlacklistedAbilities;

var name CounterName;

var config bool bLog;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    TargetUnit;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;
    TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', OnAbilityActivated, ELD_OnStateSubmitted,, TargetUnit,, EffectObj);
}

static function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Unit            SourceUnit;
    local XComGameState_Ability         AbilityState;
    local XComGameState_Effect          EffectState;
    local X2Effect_DeathFromAbove_LW    Effect;
    local XComGameState                 NewGameState;
    local UnitValue                     CountUnitValue;

    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        SourceUnit = XComGameState_Unit(EventSource);
        AbilityState = XComGameState_Ability(EventData);
        EffectState = XComGameState_Effect(CallbackData);

        if (SourceUnit != none && AbilityState != none && EffectState != none)
        {
            Effect = X2Effect_DeathFromAbove_LW(EffectState.GetX2Effect());

            if (Effect != none)
            {
                if (Effect.IsEffectCurrentlyRelevant(EffectState, SourceUnit))
                {
                    if (Effect.IsAbilityRelevant(AbilityState, SourceUnit, EffectState, GameState))
                    {
                        if (Effect.IsTargetRelevant(AbilityContext, GameState, SourceUnit, EffectState))
                        {
                            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(default.Class.Name));
                            SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));

                            if (Effect.CounterName != '')
                            {
                                SourceUnit.GetUnitValue(Effect.CounterName, CountUnitValue);
                                SourceUnit.SetUnitFloatValue(Effect.CounterName, CountUnitValue.fValue + 1, eCleanup_BeginTurn);
                            }

                            NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
                            XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectState.TriggerAbilityFlyoverVisualizationFn;

                            SourceUnit.ActionPoints.AddItem(Effect.GetActionPointType());

                            `TACTICALRULES.SubmitGameState(NewGameState);
                        }
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    return false;
}

function bool IsAbilityRelevant(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Effect EffectState, XComGameState GameState)
{
    local XComGameStateHistory          History;
    local XComGameState                 ChainStartGameState;
    local XComGameStateContext_Ability  ChainStartAbilityContext;
    local XComGameState_Ability         ChainStartAbilityState;

    `LOG(GetFuncName() @ AbilityState.GetMyTemplateName(), default.bLog, default.Class.Name);

    History = `XCOMHISTORY;

    if (AbilityState.IsAbilityInputTriggered())
    {
        if (bDisallowFreeActions && WasAbilityFree(AbilityState, SourceUnit, GameState.HistoryIndex - 1))
        {
            return false;
        }
    }
    else
    {
        `LOG(AbilityState.GetMyTemplateName() $ " is not input-activated", default.bLog, default.Class.Name);
        ChainStartGameState = GameState.GetContext().GetFirstStateInEventChain();
        if (GameState != ChainStartGameState)
        {
            ChainStartAbilityContext = XComGameStateContext_Ability(ChainStartGameState.GetContext());
            if (ChainStartAbilityContext == none)
            {
                `LOG("AbilityContext not found", default.bLog, default.Class.Name);
                return false;
            }
            else
            {
                if (ChainStartAbilityContext.InputContext.SourceObject.ObjectID != SourceUnit.ObjectID)
                {
                    `LOG("First ability in chain has a different source", default.bLog, default.Class.Name);
                    return false;
                }

                ChainStartAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ChainStartAbilityContext.InputContext.AbilityRef.ObjectID));
                if (!IsAbilityRelevant(ChainStartAbilityState, SourceUnit, EffectState, ChainStartGameState))
                {
                    return false;
                }
            }
        }
    }

    if (bDisallowMultiTarget && IsMultiTarget(AbilityState))
    {
        `LOG("MultiTarget abilities are not allowed", default.bLog, default.Class.Name);
        return false;
    }

    if (BlacklistedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        `LOG(AbilityState.GetMyTemplateName() $ " is blacklisted", default.bLog, default.Class.Name);
        return false;
    }

    if (bMatchSourceWeapon)
    {
        if (AbilityState.SourceWeapon.ObjectID > 0)
        {
            if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
            {
                `LOG("Source weapon doesn't match", default.bLog, default.Class.Name);
                return false;
            }
        }
        else
        {
            `LOG("No source weapon", default.bLog, default.Class.Name);
            return false;
        }
    }

    `LOG("Ability is relevant", default.bLog, default.Class.Name);

    return true;
}

function bool IsTargetRelevant(XComGameStateContext_Ability AbilityContext, XComGameState GameState, XComGameState_Unit SourceUnit, XComGameState_Effect EffectState)
{
    local XComGameStateHistory  History;
    local XComGameState_Unit    TargetUnit, OldTargetState;
    local int                   Index;

    `LOG(GetFuncName(), default.bLog, default.Class.Name);

    History = `XCOMHISTORY;

    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

    if (TargetUnit != none)
    {
        OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID,, GameState.HistoryIndex - 1));
        if (OldTargetState.IsAlive() && TargetUnit.IsDead() && SourceUnit.HasHeightAdvantageOver(OldTargetState, true))
        {
            `LOG("Primary target is valid", default.bLog, default.Class.Name);
            return true;
        }
        `LOG("Primary target is not valid", default.bLog, default.Class.Name);
    }

    if (!bOnlyPrimaryTarget && AbilityContext.InputContext.MultiTargets.Length > 0)
    {
        `LOG("MultiTargets.Length = " $ AbilityContext.InputContext.MultiTargets.Length, default.bLog, default.Class.Name);
        for (Index = 0; Index < AbilityContext.InputContext.MultiTargets.Length; Index++)
        {
            TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[Index].ObjectID));

            if (TargetUnit != none)
            {
                OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID,, GameState.HistoryIndex - 1));
                if (OldTargetState.IsAlive() && TargetUnit.IsDead() && SourceUnit.HasHeightAdvantageOver(OldTargetState, true))
                {
                    `LOG("MultiTarget #" $ Index $ " is valid", default.bLog, default.Class.Name);
                    return true;
                }
            }
        }
    }

    `LOG("No valid targets", default.bLog, default.Class.Name);

    return false;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local UnitValue CountUnitValue;

    if (class'Helpers_LW'.static.IsUnitInterruptingEnemyTurn(TargetUnit))
    {
        return false;
    }

    if (bDisableWithSerial && TargetUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
    {
        return false;
    }

    if (CounterName != '')
    {
        TargetUnit.GetUnitValue(CounterName, CountUnitValue);
        if (ActivationsPerTurn > 0 && CountUnitValue.fValue >= ActivationsPerTurn)
        {
            return false;
        }
    }

    return true;
}

function name GetActionPointType()
{
    return PointType != '' ? PointType : class'X2CharacterTemplateManager'.default.StandardActionPoint;
}

static function bool WasAbilityFree(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner, optional int HistoryIndex = -1)
{
    local XComGameStateHistory      History;
    local XComGameState_Ability     OldAbilityState;
    local XComGameState_Unit        OldAbilityOwner;
    local X2AbilityTemplate         Template;
    local X2AbilityCost             Cost;
    local X2AbilityCost_ActionPoints ActionPointCost;

    `LOG(GetFuncName() @ AbilityState.GetMyTemplateName(), default.bLog, default.Class.Name);
    `LOG("HistoryIndex = " $ HistoryIndex, default.bLog, default.Class.Name);

    History = `XCOMHISTORY;

    Template = AbilityState.GetMyTemplate();

    if (HistoryIndex != -1)
    {
        OldAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityState.ObjectID,, HistoryIndex));
        OldAbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityOwner.ObjectID,, HistoryIndex));
    }
    else
    {
        OldAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityState.ObjectID));
        OldAbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityOwner.ObjectID));
    }

    foreach Template.AbilityCosts(Cost)
    {
        ActionPointCost = X2AbilityCost_ActionPoints(Cost);
        if (ActionPointCost != none)
        {
            if (!ActionPointCost.bFreeCost && ActionPointCost.GetPointCost(OldAbilityState, OldAbilityOwner) > 0)
            {
                `LOG(AbilityState.GetMyTemplateName() $ " wasn't free", default.bLog, default.Class.Name);
                return false;
            }
        }
    }

    `LOG(AbilityState.GetMyTemplateName() $ " was free", default.bLog, default.Class.Name);

    return true;
}

static function bool IsMultiTarget(XComGameState_Ability AbilityState)
{
    local X2AbilityTemplate Template;
    local bool bIsMultiTarget;

    `LOG(GetFuncName() @ AbilityState.GetMyTemplateName(), default.bLog, default.Class.Name);

    Template = AbilityState.GetMyTemplate();
    bIsMultiTarget = Template.AbilityMultiTargetStyle != none && X2AbilityMultiTarget_BurstFire(Template.AbilityMultiTargetStyle) == none;

    `LOG(bIsMultiTarget, default.bLog, default.Class.Name);

    return bIsMultiTarget;
}

defaultproperties
{
    EffectName = DeathFromAbove_LW
    DuplicateResponse = eDupe_Ignore

    CounterName = LW_DeathFromAboveUses

    bMatchSourceWeapon = true
    bDisallowMultiTarget = false
    bOnlyPrimaryTarget = false
    bDisallowFreeActions = true
}