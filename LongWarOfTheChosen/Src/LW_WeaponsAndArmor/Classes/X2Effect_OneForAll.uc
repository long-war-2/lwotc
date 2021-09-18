//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_OneForAll.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Grants ablative on use, scales with shield tier
//---------------------------------------------------------------------------------------

class X2Effect_OneForAll extends X2Effect_Persistent;

var float DamageReduction;

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
	return -CurrentDamage * DamageReduction;
}


defaultproperties
{
	DuplicateResponse=eDupe_Refresh
} 
