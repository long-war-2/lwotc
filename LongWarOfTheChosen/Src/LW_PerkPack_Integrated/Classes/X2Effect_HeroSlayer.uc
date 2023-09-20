class X2Effect_HeroSlayer extends X2Effect_Persistent;

var float DmgMod;

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
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(TargetDamageable);


	if (TargetUnit.IsResistanceHero() && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		return CurrentDamage * DmgMod;
	}

	return 0;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
