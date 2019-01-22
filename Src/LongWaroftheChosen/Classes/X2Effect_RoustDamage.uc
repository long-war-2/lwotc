//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Roust
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Applies %-based damage penalty when using Roust
//--------------------------------------------------------------------------------------

class X2Effect_RoustDamage extends X2Effect_Persistent;

var float Roust_Damage_Modifier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local float ExtraDamage;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;

	WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (WeaponDamageEffect != none)
	{			
		if (WeaponDamageEffect.bIgnoreBaseDamage)
		{	
			return 0;		
		}
	}

    if(AbilityState.GetMyTemplateName() == 'Roust')
    {
		if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		{
			ExtraDamage = -1 * (float(CurrentDamage) * Roust_Damage_Modifier);
		}
    }
    return int(ExtraDamage);
}