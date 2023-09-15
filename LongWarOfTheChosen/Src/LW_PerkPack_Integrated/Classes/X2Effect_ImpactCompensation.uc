//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ImpactCompensation.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Stackable, percent-based damage reduction with a maximum number of
//           stacks.
//---------------------------------------------------------------------------------------
class X2Effect_ImpactCompensation extends X2Effect_Persistent config(LW_SoldierSkills);

var int MaxStacks;
var float DamageModifier;

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
	local UnitValue Value;

	Value.fValue = 0.0;
	TargetDamageable.GetUnitValue(class'X2Ability_PerkPackAbilitySet2'.const.DAMAGED_COUNT_NAME, Value);

	if (Value.fValue == 0)
		return 0;

	return -CurrentDamage * (1 - ((1 - DamageModifier) ** Min(MaxStacks, Value.fValue)));
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
