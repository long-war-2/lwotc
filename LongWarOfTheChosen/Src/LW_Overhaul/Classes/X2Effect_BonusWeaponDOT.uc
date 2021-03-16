//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BonusWeaponDOT.uc
//  PURPOSE: Replacement for X2EffectBonusWeaponDamage modifier, which can optionally
//           apply to damage sources with bIgnoreBaseDamage set, such as DOT effects.
//---------------------------------------------------------------------------------------

class X2Effect_BonusWeaponDOT extends X2Effect_Persistent;

var int BonusDmg;
var bool ApplyToNonBaseDamage;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{
	local X2Effect_ApplyWeaponDamage DamageEffect;

	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
		return 0;

	// only limit this when actually applying damage (not previewing)
	if( NewGameState != none )
	{
		//	only add the bonus damage when the damage effect is applying the weapon's base damage
		//  or when ApplyToNonBaseDamage is explicitly set 
		DamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
		if( DamageEffect == none || (DamageEffect.bIgnoreBaseDamage && !ApplyToNonBaseDamage))
		{
			return 0;
		}
	}

	if( AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef )
	{
		return BonusDmg;
	}

	return 0; 
}

defaultproperties
{
	bDisplayInSpecialDamageMessageUI = true
}
