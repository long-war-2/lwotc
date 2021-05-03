//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ArcWaveMultiDamage_LW
//  AUTHOR:  Grobobobo
//  PURPOSE: Updates the Arcwave effect so that its damage is dependent on weapon tier instead of focus
//---------------------------------------------------------------------------------------
class X2Effect_ArcWaveMultiDamage_LW extends X2Effect_ArcWaveMultiDamage;

var int T1Damage;
var int T2Damage;
var int T3Damage;
function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue Damage;

	if (TargetRef.ObjectID > 0)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();

		switch(SourceWeapon.GetMyTemplateName())
		{
			case 'ShardGauntlet_CV':
				Damage.Damage = T1Damage;
				break;
			case 'ShardGauntlet_MG':
				Damage.Damage = T2Damage;
				break;
			case 'ShardGauntlet_BM':
				break;
				Damage.Damage = T3Damage;
			default:
				Damage.Damage = T1Damage;
		}
	}
	return Damage;
}
