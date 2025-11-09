class X2Effect_DeathFromAbove_LW extends X2Effect_DeathFromAbove config(LW_SoldierSkills);

var config int DFA_USES_PER_TURN;
var config array<name> DFA_BLACKLISTED_ABILITIES;
var config float DFA_RANGE_PENALTY_NEGATION_MODIFIER;
var config int DFA_RANGE_PENALTY_NEGATION_BASE_RANGE;

var bool bMatchSourceWeapon;
var bool bAllowMultiTarget;
var bool bDisallowMultiTarget;

var name PointType;
var int ActivationsPerTurn;

var array<name> BlacklistedAbilities;

var name CounterName;
var name EventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local XComGameState_Unit        UnitState;
    local Object                    EffectObj;

    EffectObj = EffectGameState;
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    `XEVENTMGR.RegisterForEvent(EffectObj, EventName, EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, 40, UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameStateHistory      History;
    local XComGameState_Ability     AbilityState;
    local XComGameState_Unit        TargetUnit, PrevTargetUnit;
    local UnitValue                 UnitValue;
    local int                       iCounter;
    local int                       Index;
    local bool                      bIsMultiTarget;
    local bool                      bShouldApply;

    if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
        return false;

    if (class'Helpers_LW'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
        return false;

    SourceUnit.GetUnitValue(CounterName, UnitValue);
    iCounter = int(UnitValue.fValue);

    if (ActivationsPerTurn > 0 && iCounter >= ActivationsPerTurn)
        return false;

    History = `XCOMHISTORY;

    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

    if (AbilityState != none)
    {
        if (!bMatchSourceWeapon || kAbility.SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        {
            if (kAbility.IsAbilityInputTriggered() && ValidateAbilityCost(kAbility, SourceUnit))
            {
                bIsMultiTarget = IsMultiTarget(AbilityState);
                if (BlacklistedAbilities.Find(kAbility.GetMyTemplateName()) == INDEX_NONE
                    && (!bDisallowMultiTarget || !bIsMultiTarget))
                {
                    TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

                    if (TargetUnit != none)
                    {
                        PrevTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID));
                        if (TargetUnit.IsDead() && SourceUnit.HasHeightAdvantageOver(PrevTargetUnit, true))
                        {
                            bShouldApply = true;
                        }
                    }
                    
                    if (!bShouldApply && bAllowMultiTarget && bIsMultiTarget)
                    {
                        for (Index = 0; Index < AbilityContext.InputContext.MultiTargets.Length; Index++)
                        {
                            TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.MultiTargets[Index].ObjectID));

                            if (TargetUnit != none)
                            {
                                PrevTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID));
                                if (TargetUnit.IsDead() && SourceUnit.HasHeightAdvantageOver(PrevTargetUnit, true))
                                {
                                    bShouldApply = true;
                                    break;
                                }
                            }
                        }
                    }
                    
                    if (bShouldApply)
                    {
                        SourceUnit.SetUnitFloatValue(CounterName, iCounter + 1.0, eCleanup_BeginTurn);
                        if (PointType != '')
                            SourceUnit.ActionPoints.AddItem(PointType);
                        else
                            SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
                        
                        `XEVENTMGR.TriggerEvent(EventName, AbilityState, SourceUnit, NewGameState);
                    }
                }
            }
        }
    }
    
    return false;
}

// Helper function that returns false if the ability is free
static function bool ValidateAbilityCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
    local X2AbilityTemplate Template;
    local X2AbilityCost Cost;
    local X2AbilityCost_ActionPoints ActionPointCost;

    Template = AbilityState.GetMyTemplate();

    foreach Template.AbilityCosts(Cost)
    {
        ActionPointCost = X2AbilityCost_ActionPoints(Cost);
        if (ActionPointCost != none && !ActionPointCost.bFreeCost && ActionPointCost.GetPointCost(AbilityState, AbilityOwner) > 0)
            return true;
    }
    return false;
}

static function bool IsMultiTarget(XComGameState_Ability AbilityState)
{
    local X2AbilityTemplate Template;

    Template = AbilityState.GetMyTemplate();

    return Template.AbilityMultiTargetStyle != none && X2AbilityMultiTarget_BurstFire(Template.AbilityMultiTargetStyle) == none;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = DeathFromAbove_LW
    CounterName = LW_DeathFromAboveUses
    EventName = DeathFromAbove
    bMatchSourceWeapon = true
    bAllowMultiTarget = true
    bDisallowMultiTarget = false
}