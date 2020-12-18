//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BloodThirst.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Blood Thirst Ability Effect
//---------------------------------------------------------------------------------------
class X2Effect_BloodThirst extends X2Effect_Persistent config(LW_SoldierSkills);

var float BloodThirstDMGPCT;
var bool bflatdamage;
var float BloodThirstFlatDMG;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	

	if (AppliedData.AbilityResultContext.HitResult != eHit_Miss &&
		AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		TargetUnit = XComGameState_Unit(TargetDamageable);
		if (TargetUnit != none)
		{
			if (!bflatdamage)
			{
				return int (CurrentDamage * (BloodThirstDMGPCT / 100));
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
}
