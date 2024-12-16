// Shamelessly stolen from the Spark Pugilist Class mod

// And used with permission from NotSoLoneWolf by Tedster


class X2Effect_HalfDamage_LW extends X2Effect_DLC_3StrikeDamage;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue DamageValue;
	//local XComGameStateHistory History;
	//local XComGameState_Unit UnitState;

	// now unused?
	//History = class'XComGameStateHistory'.static.GetGameStateHistory();

	DamageValue = super.GetBonusEffectDamageValue(AbilityState, SourceUnit, SourceWeapon, TargetRef);

	// unused?
	//UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	DamageValue.Damage = DamageValue.Damage / 2;

	//  if under the effect of Obliterator, halve the damage from that
	if (SourceUnit.IsUnitAffectedByEffectName('Obliterator_LW'))
	{
		DamageValue.Damage = DamageValue.Damage - 1;
	}
	
	return DamageValue;
}