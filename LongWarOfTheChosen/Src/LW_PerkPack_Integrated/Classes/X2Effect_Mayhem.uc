class X2Effect_Mayhem extends X2Effect_Persistent config(LW_SoldierSkills);

var config float MAYHEM_DAMAGE_BONUS_PCT;

function float GetPostDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData,
    float WeaponDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    if (class'X2Ability_PerkPackAbilitySet'.default.SUPPRESSION_SHOT_ABILITIES.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
        {
            if (SourceUnit.HasSoldierAbility('Mayhem'))
            {
                return WeaponDamage * (default.MAYHEM_DAMAGE_BONUS_PCT / 100);
            }
        }
    }

    return 0.0;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
}
