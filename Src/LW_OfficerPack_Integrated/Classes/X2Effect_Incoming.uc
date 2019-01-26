class X2Effect_Incoming extends X2Effect_Persistent;

var int ExplosivesDamageReduction;

function int GetDefendingDamageModifier(
		XComGameState_Effect EffectState,
		XComGameState_Unit Attacker,
		Damageable TargetDamageable,
		XComGameState_Ability AbilityState,
		const out EffectAppliedData AppliedData,
		const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect,
		optional XComGameState NewGameState)
{
	local int DamageMod;
	local bool Explosives;
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	DamageMod = 0;
	if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'Incoming')
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none)
			WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

		Explosives = false;
		if (WeaponDamageEffect.bExplosiveDamage)
			Explosives = true;
		if (WeaponDamageEffect.EffectDamageValue.DamageType == 'Explosion')
			Explosives = true;
		if (WeaponDamageEffect.DamageTypes.Find('Explosion') != -1)
			Explosives = true;
		if (WeaponDamageEffect.EffectDamageValue.DamageType == 'BlazingPinions')
			Explosives = true;
		if (WeaponDamageEffect.DamageTypes.Find('BlazingPinions') != -1)
			Explosives = true;
		if (WeaponTemplate != none && WeaponTemplate.DamageTypeTemplateName == 'Explosion')
			Explosives = true;
		if (WeaponTemplate != none && WeaponTemplate.DamageTypeTemplateName == 'BlazingPinions')
			Explosives = true;

		if(Explosives)
		{
			DamageMod = -ExplosivesDamageReduction;
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
