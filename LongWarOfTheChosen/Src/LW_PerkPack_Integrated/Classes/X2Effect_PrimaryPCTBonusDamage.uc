class X2Effect_PrimaryPCTBonusDamage extends X2Effect_Persistent;

var float BonusDmg;
var bool IncludeExplosives;

function float GetPostDefaultAttackingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit SourceUnit,
	Damageable Target,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData ApplyEffectParameters,
	float WeaponDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{

	if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
	{
		if (WeaponDamageEffect != none)
		{			
			if (WeaponDamageEffect.bIgnoreBaseDamage)
			{	
				return 0;		
			}
		}

		if((AbilityState.GetMyTemplateName() == 'ThrowGrenade' || AbilityState.GetMyTemplateName() == 'LaunchGrenade' 
		|| AbilityState.GetMyTemplateName() == 'IRI_FireRocket' || AbilityState.GetMyTemplateName() == 'IRI_FireRocketLauncher')
		&& IncludeExplosives)
		{
			return WeaponDamage * BonusDmg;
		}
		
		if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
		{
			
			return WeaponDamage * BonusDmg;
			
		}
	}
	return 0;
}
