class X2Effect_HeavyHitter_LW extends X2Effect_Persistent;

var int DamageBonus;
var int DamageOverTimeBonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
            {
                return DamageOverTimeBonus;
            }

            return DamageBonus;
        }
    }

    return 0;
}

defaultproperties
{
    EffectName = "HeavyHitter_LW"
    DuplicateResponse = eDupe_Allow
}