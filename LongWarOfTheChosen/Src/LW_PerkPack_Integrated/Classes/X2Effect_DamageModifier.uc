class X2Effect_DamageModifier extends X2Effect_Persistent;

var int DamageModifier;
var array<name> AllowedAbilities;

function float GetPostDefaultAttackingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    Damageable Target,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float CurrentDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local float Damage;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            if (ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
            {
                return 0;
            }

            if (AllowedAbilities.Length > 0 && AllowedAbilities.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
            {
                return 0;
            }

            Damage = CurrentDamage * DamageModifier / 100;
            Damage = Max(-1 * CurrentDamage, Damage);

            return Damage;
        }
    }

    return 0;
}