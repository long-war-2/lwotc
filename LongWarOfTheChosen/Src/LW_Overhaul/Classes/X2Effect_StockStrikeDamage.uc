//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_StockStrikeDamage.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Sets up Damage for the stock strike to deal % of soldier's max HP
//---------------------------------------------------------------------------------------
class X2Effect_StockStrikeDamage extends X2Effect_ApplyWeaponDamage;

var float Stockstrike_MaxHpDamage;

simulated function bool ModifyDamageValue(out WeaponDamageValue DamageValue, Damageable Target, out array<Name> AppliedDamageTypes)
{
	local WeaponDamageValue EmptyDamageValue;
	local bool bIsImmune;
	local XComGameState_Unit TargetUnit;
	
	bIsImmune = false;

	DamageValue.DamageType= 'Melee';

	if (Target != none)
	{
		TargetUnit = XComGameState_Unit(Target);

		if (Target.IsImmuneToDamage(DamageValue.DamageType))
		{
			`log("Target is immune to damage type" @ DamageValue.DamageType $ "!", true, 'XCom_HitRolls');
			DamageValue = EmptyDamageValue;
			bIsImmune = true;
		}
		else if (AppliedDamageTypes.Find(DamageValue.DamageType) == INDEX_NONE)
		{
			AppliedDamageTypes.AddItem(DamageValue.DamageType);
		}
	}
	
	DamageValue.Damage = TargetUnit.GetMaxStat(eStat_HP) * Stockstrike_MaxHpDamage;
    
	bIgnoreArmor = true;
	EffectDamagevalue = DamageValue;

	return bIsImmune;
}
