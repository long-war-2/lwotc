//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_PCTDamageReduction.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: General, unconditional, %-based damage reduction effect
//---------------------------------------------------------------------------------------
class X2Effect_PCTDamageReduction extends X2Effect_Persistent config(LW_SoldierSkills);

var float PCTDamage_Reduction;
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
	return -CurrentDamage * PCTDamage_Reduction;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}
