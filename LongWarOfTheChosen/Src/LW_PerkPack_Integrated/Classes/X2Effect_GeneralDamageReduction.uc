class X2Effect_GeneralDamageReduction extends X2Effect_Persistent;

var float DamageReduction;

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
    return CurrentDamage * (1 - DamageReduction);
}


