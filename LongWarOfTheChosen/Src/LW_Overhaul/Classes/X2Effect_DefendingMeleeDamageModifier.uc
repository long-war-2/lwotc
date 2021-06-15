class X2Effect_DefendingMeleeDamageModifier extends X2Effect_Persistent;
//Like iron skin but percentage based

var float DamageMod;

var name MeleeDamageTypeName;

var bool OnlyForDashingAttacks;

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
	local bool bIsMeleeDamage;
	local float CurrentDamageMod;
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

	// Exclude DOT effects and anything else that ignores base weapon damage
	if (WeaponDamageEffect != none && WeaponDamageEffect.bIgnoreBaseDamage)
	{
		return 0;
	}

	if (bIsMeleeDamage)
	{
		CurrentDamageMod = -CurrentDamage * DamageMod;
		ToHitCalc = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (ToHitCalc != none && ToHitCalc.bMeleeAttack)
		{
			if (OnlyForDashingAttacks)
			{
				if (!AbilityState.GetMyTemplate().AbilityTargetStyle.isA('X2AbilityTarget_MovingMelee'))
				{
					return 0;
				}
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
