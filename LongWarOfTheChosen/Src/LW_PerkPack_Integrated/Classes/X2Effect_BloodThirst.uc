//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BloodThirst.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Blood Thirst Ability Effect
//---------------------------------------------------------------------------------------
class X2Effect_BloodThirst extends X2Effect_Persistent config(LW_SoldierSkills);

var float BloodThirstDMGPCT;
var bool bflatdamage;
var float BloodThirstFlatDMG;

function float GetPostDefaultAttackingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit SourceUnit,
	Damageable Target,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData ApplyEffectParameters,
	float WeaponDamage, XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
		
	if (ApplyEffectParameters.AbilityResultContext.HitResult != eHit_Miss &&
		AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		TargetUnit = XComGameState_Unit(Target);
		if (TargetUnit != none)
		{
			if (!bflatdamage)
			{
				return WeaponDamage * (BloodThirstDMGPCT / 100);
			}
			else
			{
				return BloodThirstFlatDMG;
			}
		}
	}
	return 0;
}

defaultproperties
{
	BloodThirstDMGPCT=25
	bflatdamage=false
	BloodThirstFlatDMG=0
	EffectName=BloodThirst
}
