//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DeathDealer_LW
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Fixes Death Dealer so that it does not apply to damage that
//           ignores base weapon damage, such as bleed, burning, etc. Also
//           makes Death Dealer work at Squadsight range.
//---------------------------------------------------------------------------------------

class X2Effect_DeathDealer_LW extends X2Effect_Executioner;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local XComGameState_Item SourceWeapon;
	local XComGameState_Unit TargetUnit;
	local WeaponDamageValue DamageValue;

	// Ignore damage that ignores base weapon damage
	DamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (DamageEffect != none && DamageEffect.bIgnoreBaseDamage)
		return 0;

	TargetUnit = XComGameState_Unit(TargetDamageable);

	//  only add bonus damage on a crit, flanking, while in shadow
	if (AppliedData.AbilityResultContext.HitResult == eHit_Crit && Attacker.IsSuperConcealed() &&
		TargetUnit != none && class'Helpers_LW'.static.IsUnitFlankedBy(TargetUnit, Attacker))
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		SourceWeapon.GetBaseWeaponDamageValue(none, DamageValue);

		// Double the Crit damage
		return DamageValue.Crit;
	}

	return 0;
}
