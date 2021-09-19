
//---------------------------------------------------------------------------------------
//  FILE:    Helpers_LW
//  AUTHOR:  Grobobobo
//
//  PURPOSE: Make Reaper Damage reduction based on %
//          
//---------------------------------------------------------------------------------------

class X2Effect_Reaper_LW extends X2Effect_Reaper;

var float PCT_DMG_Reduction;


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
	local UnitValue UnitVal;
    local float DamageReduction;
	local float DamageMod;
	if (AbilityState.GetMyTemplate().IsMelee())
	{
		SourceUnit.GetUnitValue(default.ReaperKillName, UnitVal);

		if(UnitVal.fValue > 0)
		{

        DamageReduction = WeaponDamage;

		DamageMod = (1- PCT_DMG_Reduction)** UnitVal.fValue;

		DamageReduction = DamageReduction * (1-DamageMod);
		}
    }

	return -DamageReduction;
}



function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{

	return 0;
}
