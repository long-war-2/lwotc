//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_ApexPredator_LW.uc
//  AUTHOR:  Grobobobo/Taken  from shiremct
//  PURPOSE: Effect that Panics the target on crit.
//---------------------------------------------------------------------------------------
class X2Effect_ApexPredator_LW extends X2Effect_Persistent;

var name ApexPredator_LW_TriggeredName;


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{
	local X2Effect_ApplyWeaponDamage		DamageEffect;

	// Only apply when the damage effect is applying the weapon's base damage
	if (NewGameState != none)
	{
		DamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
		if (DamageEffect == none || DamageEffect.bIgnoreBaseDamage)
		{
			return 0;
	}	}

	// Only trigger on the actual shot
	if (NewGameState != none)
	{
		// Must be attack with Primary Weapon
		if (AbilityState.SourceWeapon == Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon).GetReference())
		{
			if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
			{
				`XEVENTMGR.TriggerEvent(default.ApexPredator_LW_TriggeredName, XComGameState_Unit(TargetDamageable), Attacker, NewGameState);
	}	}	}

	return 0;
}


DefaultProperties
{
	ApexPredator_LW_TriggeredName = "ApexPredator_LW_Triggered"
	bDisplayInSpecialDamageMessageUI = false
}
