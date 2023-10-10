//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BloodThirst.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Blood Thirst Ability Effect
//---------------------------------------------------------------------------------------
class X2Effect_BloodThirst extends X2Effect_Persistent config(LW_SoldierSkills);

var config int BLOODTHIRST_T1_DMG;
var config int BLOODTHIRST_T2_DMG;
var config int BLOODTHIRST_T3_DMG;
var config int BLOODTHIRST_T4_DMG;
var config int BLOODTHIRST_T5_DMG;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item SourceWeapon;
	local XComGameStateHistory History;
 
	History = `XCOMHISTORY;

	if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		
	TargetUnit = XComGameState_Unit(TargetDamageable);
	if (TargetUnit != none)
	{
		SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(AppliedData.ItemStateObjectRef.ObjectID));

		switch(SourceWeapon.GetMyTemplateName())
		{
			case 'ChosenSword_CV':
			case 'ChosenSword_XCOM':
				return default.BLOODTHIRST_T1_DMG;
			case 'ChosenSword_MG':
				return default.BLOODTHIRST_T2_DMG;
			case 'ChosenSword_BM':
				return default.BLOODTHIRST_T3_DMG;
			case 'ChosenSword_T4':
				return default.BLOODTHIRST_T4_DMG;
			case 'ChosenSword_T5':
				return default.BLOODTHIRST_T5_DMG;
			default:
				return default.BLOODTHIRST_T1_DMG;
		}
	}


	}
	return 0;
}

defaultproperties
{
	EffectName=BloodThirst
}
