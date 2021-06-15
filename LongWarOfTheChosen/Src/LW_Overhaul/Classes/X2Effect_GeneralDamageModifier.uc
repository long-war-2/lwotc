class X2Effect_GeneralDamageModifier extends X2Effect_Persistent;

var float DamageModifier;
var name AbilityTemplate;

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

	ExtraDamage = 0.0;
	if (AbilityState.GetMyTemplateName() == AbilityTemplate || AbilityTemplate == 'AllAbilities')
	{
		if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		{
			ExtraDamage = CurrentDamage * DamageModifier;
		}
	}
	return ExtraDamage;
}

defaultproperties
{
	AbilityTemplate="AllAbilities"
}
