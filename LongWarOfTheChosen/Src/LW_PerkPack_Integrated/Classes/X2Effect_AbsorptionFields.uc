//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_AbsorptionFields
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up damage mitigation from AF
//--------------------------------------------------------------------------------------- 

class X2Effect_AbsorptionFields extends X2Effect_BonusArmor config (LW_SoldierSkills);

var config float ABSORPTION_FIELDS_DAMAGE_REDUCTION_PCT;

function float GetPostDefaultDefendingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit Attacker,
	XComGameState_Unit TargetDamageable,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData AppliedData,
	float CurrentDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{
	return -CurrentDamage * default.ABSORPTION_FIELDS_DAMAGE_REDUCTION_PCT / 100.0;
}
