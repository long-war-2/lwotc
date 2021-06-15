//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Roust
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Applies %-based damage penalty when using Roust
//--------------------------------------------------------------------------------------

class X2Effect_RoustDamage extends X2Effect_Persistent;

var float Roust_Damage_Modifier;

function float GetPostDefaultAttackingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit Attacker,
	Damageable TargetDamageable,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData AppliedData,
	float CurrentDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{
	local float ExtraDamage;

	if (WeaponDamageEffect.bIgnoreBaseDamage)
	{	
		return 0;		
	}

	if (AbilityState.GetMyTemplateName() == 'Roust')
	{
		if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		{
			ExtraDamage = -CurrentDamage * Roust_Damage_Modifier;
		}
	}
	return ExtraDamage;
}
