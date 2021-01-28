//---------------------------------------------------------------------------------------
//  FILE:   LWRebelJobIncomeModifier_Retribution.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Effect for the impact compensation ability
//---------------------------------------------------------------------------------------
class X2Effect_ImpactCompensation extends X2Effect_Persistent config(LW_SoldierSkills);

var config float IMPACT_COMPENSATION_PCT_DR;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int DamageMod;

	DamageMod = -int(float(CurrentDamage) * default.IMPACT_COMPENSATION_PCT_DR);

	return DamageMod;
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = false
}
