class X2Effect_MeleeDamageResistance extends X2Effect_Persistent;

var bool bApplyToStandardMelee;
var bool bApplyToMovingMelee;

var bool bAllowImpaired;
var bool bAllowPanicked;
var bool bAllowBurning;
var bool bAllowFrozen;

var float PercentDR;
var int FlatDR;

var array<name> BlacklistedAbilities;
var array<name> WhitelistedAbilities;

function int GetDefendingDamageModifier(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    const int CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    optional XComGameState NewGameState)
{
    if (XComGameState_Unit(TargetDamageable) == none)
        return 0;

    if (ValidateAttack(EffectState, Attacker, XComGameState_Unit(TargetDamageable), AbilityState, AppliedData, WeaponDamageEffect))
        return -1 * Min(CurrentDamage - 1, FlatDR);
    
    return 0;
}

function float GetPostDefaultDefendingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    XComGameState_Unit TargetUnit,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float WeaponDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    if (ValidateAttack(EffectState, SourceUnit, TargetUnit, AbilityState, ApplyEffectParameters, WeaponDamageEffect))
        return -1 * Min(WeaponDamage - 1, WeaponDamage * PercentDR / 100);

    return 0;
}

private function bool ValidateAttack(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    XComGameState_Unit TargetUnit,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect)
{
    local bool bIsMelee;
    local bool bIsMovingMelee;

    if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return false;

    if (!bAllowImpaired && TargetUnit.IsImpaired()
        || !bAllowPanicked && TargetUnit.IsPanicked()
        || !bAllowBurning && TargetUnit.IsBurning()
        || !bAllowFrozen && TargetUnit.AffectedByEffectNames.Find('Frozen') != INDEX_NONE)
        return false;

    if (WhitelistedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        return true;

    if (BlacklistedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        return false;

    bIsMelee = AbilityState.IsMeleeAbility() || WeaponDamageEffect.DamageTypes.Find('Melee') != INDEX_NONE;

    bIsMovingMelee = bIsMelee && (AbilityState.GetMyTemplate().AbilityTargetStyle != none
        && AbilityState.GetMyTemplate().AbilityTargetStyle.IsA('X2AbilityTarget_MovingMelee'));

    if (bIsMovingMelee)
        return bApplyToMovingMelee;
    
    if (bIsMelee)
        return bApplyToStandardMelee;

    return false;
}

defaultproperties
{
    bApplyToStandardMelee = true
    bApplyToMovingMelee = true

    bAllowImpaired = true
    bAllowPanicked = true
    bAllowBurning = true
    bAllowFrozen = true

    WhitelistedAbilities[0] = PartingSilk
    WhitelistedAbilities[1] = AssassinSlash_LW
    WhitelistedAbilities[2] = RageStrike
}