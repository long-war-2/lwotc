//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BloodTrail_LW
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Adds a dodge-reduction bonus to the target in addition to the normal
//           Blood Trail bonus damage.
//---------------------------------------------------------------------------------------

class X2Effect_BloodTrail_LW extends X2Effect_Persistent;

var float BonusDamage;
var int DodgeReductionBonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{

}

function float GetPostDefaultAttackingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit Attacker,
	Damageable TargetDamageable,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData AppliedData,
	float CurrentDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;


	if (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).WeaponCat == 'grenade')
	{
		return 0;
	}

	if (WeaponDamageEffect != none)
	{
		if (WeaponDamageEffect.bIgnoreBaseDamage)
		{
			return 0;
		}
	}

	if(AbilityState.SourceWeapon == AppliedData.ItemStateObjectRef)
	{
		if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) && AbilityState.IsAbilityInputTriggered())
		{
			TargetUnit = XComGameState_Unit(TargetDamageable);
			if (TargetUnit != none && ShouldApplyBonuses(EffectState, TargetUnit, AbilityState, Attacker))
			{
				return CurrentDamage * BonusDamage;
			}
		}
	}

	return 0;
	}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;
	local int DodgeReduction;

	if (ShouldApplyBonuses(EffectState, Target, AbilityState, Attacker))
	{
		DodgeReduction = Min(DodgeReductionBonus, Target.GetCurrentStat(eStat_Dodge));

		ShotInfo.ModType = eHit_Graze;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = -1 * DodgeReduction;
		ShotModifiers.AddItem(ShotInfo);
	}
}

private function bool ShouldApplyBonuses(XComGameState_Effect EffectState, XComGameState_Unit Target, XComGameState_Ability AbilityState, XComGameState_Unit Attacker)
{
	local UnitValue DamageUnitValue;
	local UnitValue CheapShotUsesThisTurn;
	Target.GetUnitValue('DamageThisTurn', DamageUnitValue);

	Attacker.GetUnitValue ('CheapShotUses', CheapShotUsesThisTurn);

	return DamageUnitValue.fValue > 0 && CheapShotUsesThisTurn.fValue <= 0.1f;
}

defaultproperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "BloodTrail"
	bDisplayInSpecialDamageMessageUI = true
}
