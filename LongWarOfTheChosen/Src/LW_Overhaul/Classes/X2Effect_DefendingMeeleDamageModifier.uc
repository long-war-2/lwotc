class X2Effect_DefendingMeeleDamageModifier extends X2Effect_Persistent;
//Like iron skin but percentage based

var float DamageMod;

var name MeleeDamageTypeName;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, 
										const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local bool bIsMeleeDamage;
	local int CurrentDamageMod;
	local X2AbilityToHitCalc_StandardAim ToHitCalc;

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
		CurrentDamageMod = -int(float(CurrentDamage) * DamageMod);
		ToHitCalc = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (ToHitCalc != none && ToHitCalc.bMeleeAttack)
		{
			// Don't let a damage reduction effect reduce damage to less than 1 (or worse, heal).
			if (CurrentDamageMod < 0 && (CurrentDamage + CurrentDamageMod < 1))
			{
				if (CurrentDamage <= 1)
					return 0;

				return (CurrentDamageMod - 1) * -1;
			}
			return CurrentDamageMod;
		}
		
	}
	return 0;
}

defaultproperties
{
	MeleeDamageTypeName="melee"
}
