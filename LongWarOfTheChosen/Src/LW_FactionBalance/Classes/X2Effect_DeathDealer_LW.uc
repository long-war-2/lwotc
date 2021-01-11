//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DeathDealer_LW
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Fixes Death Dealer so that it does not apply to damage that
//           ignores base weapon damage, such as bleed, burning, etc.
//---------------------------------------------------------------------------------------

class X2Effect_DeathDealer_LW extends X2Effect_Executioner;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local X2Effect_ApplyWeaponDamage DamageEffect;

	// Ignore damage that ignores base weapon damage
	DamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (DamageEffect != none && DamageEffect.bIgnoreBaseDamage)
		return 0;

	return super.GetAttackingDamageModifier(
		EffectState, Attacker, TargetDamageable, AbilityState,
		AppliedData, CurrentDamage, NewGameState);
}
