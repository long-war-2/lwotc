//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_GrenadeDamage
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Restores the pre-WOTC Volatile Mix behaviour so that damage
//           increases can apply to tick damage.
//--------------------------------------------------------------------------------------- 

class X2Effect_GrenadeDamage extends X2Effect_Persistent;

var int BonusDamage;
var bool ApplyToNonBaseDamage;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local X2GrenadeTemplate GrenadeTemplate;
	local X2Effect_ApplyWeaponDamage DamageEffect;

	SourceWeapon = AbilityState.GetSourceWeapon();

	if (SourceWeapon != none)
	{
		GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());

		if (GrenadeTemplate == none)
		{
			GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
		}

		if (GrenadeTemplate != none && GrenadeTemplate.bAllowVolatileMix)
		{
			// No game state means it's for damage preview
			if (NewGameState == none)
			{				
				return BonusDamage;
            }

			DamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
            if (DamageEffect != none && (ApplyToNonBaseDamage || !DamageEffect.bIgnoreBaseDamage) && CurrentDamage > 0)
            {
                return BonusDamage;
            }
		}
    }

	return 0;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
	bDisplayInSpecialDamageMessageUI = true
}
