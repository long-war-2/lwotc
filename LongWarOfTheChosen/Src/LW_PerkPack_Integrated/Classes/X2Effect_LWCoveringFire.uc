//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_LWCoveringFire.uc
//  AUTHOR:  Merist
//  PURPOSE: Fixed version of X2Effect_CoveringFire with support for an array of possible abilities to activate
//---------------------------------------------------------------------------------------
class X2Effect_LWCoveringFire extends X2Effect_CoveringFire dependson(X2Effect_LWReserveOverwatchPoints);

// Hide the old property
var private name AbilityToActivate;

// Include MultiTargets for bDirectAttackOnly
var bool bDirectAttackOnly_AllowMultiTarget;
// Include allies for bDirectAttackOnly
var bool bDirectAttackOnly_AllowAllies;
// ... but exclude the covering unit
var bool bDirectAttackOnly_AllowAllies_ExcludeSelf;
// Require the hostile action to hit to activate
var bool bOnlyWhenAttackHits;
// Include non-damaging attacks.
var bool bAnyHostileAction;

var bool bMatchSourceWeapon;
var array<OverwatchAbilityInfo> AbilitiesToActivate;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', NewCoveringFireCheck, ELD_OnStateSubmitted,,,, EffectObj);
}

function AddAbilityToActivate(name AbiltiyName, optional int Priority = 50)
{
    local OverwatchAbilityInfo NewAbilityToActivate;

    NewAbilityToActivate.AbilityName = AbiltiyName;
    NewAbilityToActivate.Priority = Priority;

    AbilitiesToActivate.AddItem(NewAbilityToActivate);
}

static function EventListenerReturn NewCoveringFireCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameStateHistory          History;

    local XComGameState_Unit            AttackingUnit, CoveringUnit, TargetUnit;
    local XComGameStateContext_Ability  AbilityContext;
    local XComGameState_Effect          CoveringFireEffectState;
    local X2Effect_LWCoveringFire       CoveringFireEffect;
    local XComGameState_Ability         EventAbilityState;
    local X2AbilityTemplate             EventAbilityTemplate;

    local bool                          bIsDirectAttack;
    local int                           RandRoll;
    local int                           Index;

    local StateObjectReference          AbilityRef;
    local XComGameState_Ability         AbilityState;
    local OverwatchAbilityInfo          AbilityInfo;
    local array<OverwatchAbilityInfo>   AbilitiesToActivateSorted;
    local name                          AbilityName;

    local XComGameState                 NewGameState;
    local bool                          bCleanupPendingGameState;

    History = `XCOMHISTORY;

    CoveringFireEffectState = XComGameState_Effect(CallbackData);

    if (CoveringFireEffectState != none)
    {
        AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
        CoveringFireEffect = X2Effect_LWCoveringFire(CoveringFireEffectState.GetX2Effect());
        CoveringUnit = XComGameState_Unit(History.GetGameStateForObjectID(CoveringFireEffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
        AttackingUnit = XComGameState_Unit(EventSource);
        EventAbilityState = XComGameState_Ability(EventData);

        if (AbilityContext != none && CoveringFireEffect != none && CoveringUnit != none && AttackingUnit != none && EventAbilityState != none)
        {
            EventAbilityTemplate = EventAbilityState.GetMyTemplate();
            if (EventAbilityState.GetMyTemplate().Hostility != eHostility_Offensive
                || !(CoveringFireEffect.bAnyHostileAction
                || EventAbilityTemplate.TargetEffectsDealDamage(EventAbilityState.GetSourceWeapon(), EventAbilityState) && !EventAbilityTemplate.bIsASuppressionEffect))
                return ELR_NoInterrupt;

            if (CoveringFireEffect.bOnlyDuringEnemyTurn && `TACTICALRULES.GetUnitActionTeam() == CoveringUnit.GetTeam())
                return ELR_NoInterrupt;

            if (CoveringFireEffect.bPreEmptiveFire != (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt))
                return ELR_NoInterrupt;

            if (CoveringFireEffect.ActivationPercentChance > 0)
            {
                RandRoll = `SYNC_RAND_STATIC(100);
                if (RandRoll >= CoveringFireEffect.ActivationPercentChance)
                {
                    return ELR_NoInterrupt;
                }
            }

            if (CoveringFireEffect.bDirectAttackOnly)
            {
                if (CoveringFireEffect.bDirectAttackOnly_AllowAllies)
                {
                    TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
                    if (CoveringFireEffect.bDirectAttackOnly_AllowAllies_ExcludeSelf)
                    {
                        bIsDirectAttack = AbilityContext.InputContext.PrimaryTarget.ObjectID != CoveringUnit.ObjectID && CoveringUnit.IsFriendlyUnit(TargetUnit);
                    }
                    else
                    {
                        bIsDirectAttack = AbilityContext.InputContext.PrimaryTarget.ObjectID == CoveringUnit.ObjectID || CoveringUnit.IsFriendlyUnit(TargetUnit);
                    }
                }
                else
                {
                    bIsDirectAttack = AbilityContext.InputContext.PrimaryTarget.ObjectID == CoveringUnit.ObjectID;
                }
                
                if (!bIsDirectAttack && CoveringFireEffect.bDirectAttackOnly_AllowMultiTarget)
                {
                    for (Index = 0; Index < AbilityContext.InputContext.MultiTargets.Length && !bIsDirectAttack; Index++)
                    {
                        if (CoveringFireEffect.bDirectAttackOnly_AllowAllies)
                        {
                            TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[Index].ObjectID));
                            if (CoveringFireEffect.bDirectAttackOnly_AllowAllies_ExcludeSelf)
                            {
                                bIsDirectAttack = AbilityContext.InputContext.MultiTargets[Index].ObjectID != CoveringUnit.ObjectID && CoveringUnit.IsFriendlyUnit(TargetUnit);
                            }
                            else
                            {
                                bIsDirectAttack = AbilityContext.InputContext.MultiTargets[Index].ObjectID == CoveringUnit.ObjectID || CoveringUnit.IsFriendlyUnit(TargetUnit);
                            }
                        }
                        else
                        {
                            bIsDirectAttack = AbilityContext.InputContext.MultiTargets[Index].ObjectID == CoveringUnit.ObjectID;
                        }
                    }
                }
                
                if (!bIsDirectAttack)
                {
                    return ELR_NoInterrupt;
                }
            }
                
            if (CoveringFireEffect.bOnlyWhenAttackMisses && class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult))
                return ELR_NoInterrupt;

            if (CoveringFireEffect.bOnlyWhenAttackHits && class'XComGameStateContext_Ability'.static.IsHitResultMiss(AbilityContext.ResultContext.HitResult))
                return ELR_NoInterrupt;

            if (CoveringFireEffect.GrantActionPoint != ''
                && (CoveringFireEffect.MaxPointsPerTurn > CoveringFireEffectState.GrantsThisTurn || CoveringFireEffect.MaxPointsPerTurn <= 0))
            {
                NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                CoveringFireEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(CoveringFireEffectState.Class, CoveringFireEffectState.ObjectID));
                CoveringFireEffectState.GrantsThisTurn++;

                CoveringUnit = XComGameState_Unit(NewGameState.ModifyStateObject(CoveringUnit.Class, CoveringUnit.ObjectID));
                CoveringUnit.ReserveActionPoints.AddItem(CoveringFireEffect.GrantActionPoint);

                bCleanupPendingGameState = true;
            }

            foreach CoveringFireEffect.AbilitiesToActivate(AbilityInfo)
            {
                AbilitiesToActivateSorted.AddItem(AbilityInfo);
            }
            AbilitiesToActivateSorted.Sort(class'X2Effect_LWReserveOverwatchPoints'.static.SortOverwatchAbilities);

            foreach AbilitiesToActivateSorted(AbilityInfo)
            {
                AbilityName = AbilityInfo.AbilityName;
                if (CoveringFireEffect.bMatchSourceWeapon && CoveringFireEffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID != 0)
                    AbilityRef = CoveringUnit.FindAbility(AbilityName, CoveringFireEffectState.ApplyEffectParameters.ItemStateObjectRef);
                else
                    AbilityRef = CoveringUnit.FindAbility(AbilityName);

                if (AbilityRef.ObjectID != 0)
                {
                    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
                    if (AbilityState != none)
                    {
                        if (AbilityState.CanActivateAbilityForObserverEvent(
                            (CoveringFireEffect.bSelfTargeting ? CoveringUnit : AttackingUnit),
                            (CoveringFireEffect.bSelfTargeting ? none : CoveringUnit)) == 'AA_Success')
                        {
                            if (NewGameState != none)
                            {
                                bCleanupPendingGameState = false;
                                `TACTICALRULES.SubmitGameState(NewGameState);
                            }

                            AbilityState.AbilityTriggerAgainstSingleTarget(
                                (CoveringFireEffect.bSelfTargeting ? CoveringUnit.GetReference() : AttackingUnit.GetReference()),
                                CoveringFireEffect.bUseMultiTargets);
                            return ELR_NoInterrupt;
                        }
                    }
                }
            }
            if (bCleanupPendingGameState)
            {
                History.CleanupPendingGameState(NewGameState);
            }
            
        }
    }
    return ELR_NoInterrupt;
}

static function X2Effect_LWCoveringFire CreateCoveringFireEffect(optional bool bMatchWeapon)
{
    local X2Effect_LWCoveringFire       CoveringFireEffect;
    local X2Condition_AbilityProperty   CoveringFireCondition;

    CoveringFireCondition = new class'X2Condition_AbilityProperty';
    CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');

    CoveringFireEffect = new class'X2Effect_LWCoveringFire';
    CoveringFireEffect.AbilitiesToActivate = class'X2Effect_LWReserveOverwatchPoints'.default.OverwatchAbilities;
    CoveringFireEffect.bMatchSourceWeapon = bMatchWeapon;
    CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);

    return CoveringFireEffect;
}

defaultproperties
{
    bAnyHostileAction = true
}