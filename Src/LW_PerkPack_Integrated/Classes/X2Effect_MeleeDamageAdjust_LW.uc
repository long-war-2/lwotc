///---------------------------------------------------------------------------------------
//  FILE:    XEffect_MeleeDamageAdjust_LW
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Rework of base-game effect of same name to fix bug where stun lancer attacks don't count as melee damage
///---------------------------------------------------------------------------------------
class X2Effect_MeleeDamageAdjust_LW extends X2Effect_Persistent;

var int DamageMod;

var name MeleeDamageTypeName;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, 
										const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local X2AbilityToHitCalc_StandardAim ToHitCalc;
	local bool bIsMeleeDamage;

	// The damage effect's DamageTypes must be empty or have melee in order to adjust the damage
	if (WeaponDamageEffect.EffectDamageValue.DamageType == MeleeDamageTypeName)
		bIsMeleeDamage = true;
	else if (WeaponDamageEffect.DamageTypes.Find(MeleeDamageTypeName) != INDEX_NONE)
		bIsMeleeDamage = true;
	else if ((WeaponDamageEffect.EffectDamageValue.DamageType == '') && (WeaponDamageEffect.DamageTypes.Length == 0))
		bIsMeleeDamage = true;
	else if ((Attacker.GetMyTemplate().CharacterGroupName == 'AdventStunLancer') && WeaponDamageEffect.DamageTypes.Find('Electrical') != INDEX_NONE)
		bIsMeleeDamage = true;

	// remove from DOT effects
	if (WeaponDamageEffect != none)
	{			
		if (WeaponDamageEffect.bIgnoreBaseDamage)
		{	
			return 0;
		}
	}

	if (bIsMeleeDamage)
	{
		ToHitCalc = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (ToHitCalc != none && ToHitCalc.bMeleeAttack)
		{
			// Don't let a damage reduction effect reduce damage to less than 1 (or worse, heal).
			if (DamageMod < 0 && (CurrentDamage + DamageMod < 1))
			{
				if (CurrentDamage <= 1)
					return 0;

				return (CurrentDamage - 1) * -1;
			}
			return DamageMod;
		}
	}
	
	return 0;
}

defaultproperties
{
	MeleeDamageTypeName="melee"
}