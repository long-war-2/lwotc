//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_CombinedArms
//  AUTHOR:  John Lumpkin / Pavonis Interactive
//  PURPOSE: Combined Arms effect
//--------------------------------------------------------------------------------------- 
class X2Effect_CombinedArms extends X2Effect_LWOfficerCommandAura 
	config (LW_OfficerPack);

var config float COMBINEDARMS_DAMAGE_BONUS;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local bool DamagingAttack;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	//`Log("Combined Arms: Checking relevance");
	DamagingAttack = (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.Damage > 0 || X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.PlusOne > 0);

	
	WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (WeaponDamageEffect != none)
	{			
		if (WeaponDamageEffect.bIgnoreBaseDamage)
		{	
			return 0;		
		}
	}

	if (IsEffectCurrentlyRelevant(EffectState, Attacker) && DamagingAttack)
	{
		if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		{
			return int(default.COMBINEDARMS_DAMAGE_BONUS);
		}
	}
	return 0;
}

defaultproperties
{
 	EffectName=CombinedArms;

}