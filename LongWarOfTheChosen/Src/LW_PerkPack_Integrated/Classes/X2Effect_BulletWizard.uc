//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BulletWizard.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Effect Applies damage depending on weapon tech
//---------------------------------------------------------------------------------------
class X2Effect_BulletWizard extends X2Effect_ApplyWeaponDamage;


function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue Damage;

	if (TargetRef.ObjectID > 0)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();

		switch(X2WeaponTemplate(SourceWeapon.GetMyTemplate()).WeaponTech)
		{
			case 'conventional':
				Damage.Damage = 1;
				break;
			case 'laser_LW':
				Damage.Damage = 2;
				break;
             case 'magnetic':
				Damage.Damage = 3;
				break;
			case 'coilgun_LW':
				Damage.Damage = 4;
				break;
             case 'beam':
				Damage.Damage = 5;
				break;
			default:
				Damage.Damage = 1;
		}

		if(SourceUnit.HasSoldierAbility('Shredder'))
		{
			Damage.Shred += 1;
		}
	}
	return Damage;
}


DefaultProperties
{
	bIgnoreBaseDamage = true
	bAllowFreeKill = false
	bAllowWeaponUpgrade = false
	bBypassShields = false
	bIgnoreArmor = false
	DamageTypes(0)="Projectile_MagXCom"
}