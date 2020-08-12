
class X2Effect_LW_ApexPredator extends X2Effect_Persistent;

var name LW_ApexPredator_TriggeredName;


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
				`XEVENTMGR.TriggerEvent(default.LW_ApexPredator_TriggeredName, XComGameState_Unit(TargetDamageable), Attacker, NewGameState);
	}	}	}

	return 0;
}


DefaultProperties
{
	LW_ApexPredator_TriggeredName = "LW_ApexPredator_Triggered"
	bDisplayInSpecialDamageMessageUI = false
}
