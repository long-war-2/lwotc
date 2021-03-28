//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_PCTDamageReduction.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: General Damage Reduction Effect
//---------------------------------------------------------------------------------------
class X2Effect_PCTDamageReduction extends X2Effect_Persistent config(LW_SoldierSkills);

var float PCTDamage_Reduction;
function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int DamageMod;

	DamageMod = -int(float(CurrentDamage) * PCTDamage_Reduction);

	return DamageMod;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}
