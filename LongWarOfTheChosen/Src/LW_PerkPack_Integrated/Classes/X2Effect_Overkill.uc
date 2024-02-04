//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_Overkill.uc
//  AUTHOR:  Grobobobo/Taken  from shadow ops
//  PURPOSE: Bonus damage on 50% hp or less.
//---------------------------------------------------------------------------------------
class X2Effect_Overkill extends XMBEffect_Extended;

var int BonusDamage;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local XComGameState_Unit Target;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon == none)
		return 0;

	if (AbilityState.IsMeleeAbility())
		return 0;

	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		return 0;

	// Damage preview doesn't fill out the EffectRef, so skip this check if there's no EffectRef
	if (AppliedData.EffectRef.SourceTemplateName != '')
	{
		WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
		if (WeaponDamageEffect == none)
			return 0;
	}

	Target = XComGameState_Unit(TargetDamageable);
	if (Target == none)
		return 0;
	if (Target.GetCurrentStat(eStat_HP) > Target.GetMaxStat(eStat_HP) / 2)
		return 0;
 
 	//fix: don't add bonus damage to things that don't deal damage.
	if(CurrentDamage == 0)
		return 0;

	return BonusDamage;
}

function bool GetTagValue(name Tag, XComGameState_Ability AbilityState, out string TagValue) 
{
	if (Tag == 'Damage')
	{
		TagValue = string(BonusDamage);
		return true;
	}
 
	return false; 
}
