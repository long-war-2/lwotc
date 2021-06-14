//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_DeadeyeDamage_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modified version of the vanilla effect that uses the Community
//           Highlander hooks for multiplicative damage multipliers.
//---------------------------------------------------------------------------------------
class X2Effect_DeadeyeDamage_LW extends X2Effect_Persistent;

var float DamageMultiplier;

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
	if (AbilityState.GetMyTemplateName() == 'Deadeye' && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		return CurrentDamage * DamageMultiplier;
	}

	return 0;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
