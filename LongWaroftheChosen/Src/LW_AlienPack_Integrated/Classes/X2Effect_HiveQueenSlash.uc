class X2Effect_HiveQueenSlash extends X2Effect_Persistent;

var int BonusDamage;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Unit TargetUnit;
    //local GameRulesCache_VisibilityInfo VisInfo;

    TargetUnit = XComGameState_Unit(TargetDamageable);
    if(AbilityState.IsMeleeAbility() && TargetUnit != none && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
		return BonusDamage;
	}
    return 0;
}