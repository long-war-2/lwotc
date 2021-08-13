class X2Effect_Grit extends X2Effect_Persistent;


var float Grit_Base_Dr;

function float GetPostDefaultDefendingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit Attacker,
	XComGameState_Unit Target,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData AppliedData,
	float CurrentDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{
    local float PCTHPMissing;
    local int MaxHP, CurrentHP;

    MaxHP = Target.GetMaxStat(eStat_HP);
    CurrentHP = Target.GetCurrentStat(eStat_HP);

    PCTHPMissing = 1 - (1.0 * CurrentHP) / MaxHP;

    return CurrentDamage * (1 - (Grit_Base_Dr + PCTHPMissing / 2));
}


