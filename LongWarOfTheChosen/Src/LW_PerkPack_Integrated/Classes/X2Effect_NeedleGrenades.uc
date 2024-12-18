class X2Effect_NeedleGrenades extends X2Effect_Persistent;

var int BonusDamage_Conv;
var int BonusDamage_Mag;
var int BonusDamage_Beam;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local X2GrenadeTemplate GrenadeTemplate;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local XComGameState_Unit TargetUnit;
	local int BonusDamage;
	SourceWeapon = AbilityState.GetSourceWeapon();

	TargetUnit = XComGameState_Unit(TargetDamageable);

	// Short Circuit if damage being dealt = 0.
	if (CurrentDamage == 0)
	{
		return 0;
	}

	BonusDamage = BonusDamage_Conv;
	switch (SourceWeapon.GetWeaponTech())
	{
		case 'laser_lw':
		case 'magnetic':
			BonusDamage = BonusDamage_Mag;
			break;
		case 'coilgun_lw':
		case 'beam':
			BonusDamage = BonusDamage_Beam;
			break;
		default:
			break;
	}

	if (SourceWeapon != none)
	{
		GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());

		if (GrenadeTemplate == none)
		{
			GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
		}

		if (GrenadeTemplate != none && GrenadeTemplate.bAllowVolatileMix)
		{

			//	no game state means it's for damage preview
			if (NewGameState == none)
			{				
				return BonusDamage;
			}

			//	only add the bonus damage when the damage effect is applying the weapon's base damage
			DamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
			if (TargetUnit != none)
			{
				if (DamageEffect != none && !DamageEffect.bIgnoreBaseDamage && TargetUnit.GetArmorMitigation(AppliedData.AbilityResultContext.ArmorMitigation) == 0)
				{
					return BonusDamage;
				}
			}			
		}
	}
	return 0;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	bDisplayInSpecialDamageMessageUI = true
}
