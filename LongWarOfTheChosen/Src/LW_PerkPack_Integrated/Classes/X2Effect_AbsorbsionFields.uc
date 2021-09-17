class X2Effect_AbsorbsionFields extends X2Effect_Persistent;

var float DamageReduction;

function float GetPostDefaultDefendingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit Attacker,
	XComGameState_Unit Target,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData AppliedData,
	float CurrentDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{
	
	local UnitValue AbsorbsionValue;

	Target.GetUnitValue('AbsorptionFieldsTimes', AbsorbsionValue);
	if(AbsorbsionValue.fValue <= 0.1)
	{
		return -(CurrentDamage * DamageReduction);
	}
	else
	{
		return 0;
	}
	
}


