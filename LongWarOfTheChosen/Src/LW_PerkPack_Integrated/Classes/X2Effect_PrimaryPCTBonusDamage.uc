class X2Effect_PrimaryPCTBonusDamage extends X2Effect_Persistent;

var float BonusDmg;
var bool includepistols;
var bool includesos;

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
	local X2WeaponTemplate WeaponTemplate;
    local X2AbilityToHitCalc_StandardAim StandardHit;

	if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
	{
		if (WeaponDamageEffect != none)
		{			
			if (WeaponDamageEffect.bIgnoreBaseDamage)
			{	
				return 0;		
			}
		}

		if (AbilityState.GetMyTemplateName() == 'LWRocketLauncher' || AbilityState.GetMyTemplateName() == 'LWBlasterLauncher' || AbilityState.GetMyTemplateName() == 'MicroMissiles')
		{
			return 0;
		}
		StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (StandardHit != none && StandardHit.bIndirectFire)
		{
			return 0;
		}		
		if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
		{
			
			return WeaponDamage * BonusDmg;
			
		}
	}
	return 0;
}
