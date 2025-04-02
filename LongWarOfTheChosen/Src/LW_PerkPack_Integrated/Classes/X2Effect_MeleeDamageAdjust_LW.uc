///---------------------------------------------------------------------------------------
//  FILE:    XEffect_MeleeDamageAdjust_LW
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Rework of base-game effect of same name to fix bug where stun lancer attacks don't count as melee damage
///---------------------------------------------------------------------------------------
class X2Effect_MeleeDamageAdjust_LW extends X2Effect_Persistent;

var int DamageMod;
var float Assassin_Dmg_Mod;

var name MeleeDamageTypeName;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, 
										const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local X2AbilityToHitCalc_StandardAim ToHitCalc;
	local bool bIsMeleeDamage;
	local XComGameState_Item SourceItem;
	local WeaponDamageValue BaseDamageValue;

	SourceItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AppliedData.ItemStateObjectRef.ObjectID));

	// The damage effect's DamageTypes must be empty or have melee in order to adjust the damage
	// Tedster - added support for Assassin (charactertemplate + check for PartingSilk damage type)
	if (WeaponDamageEffect.EffectDamageValue.DamageType == MeleeDamageTypeName)
	{
		//`LWTrace("WeaponDamageEffect.EffectDamageValue.DamageType == MeleeDamageTypeName true");
		bIsMeleeDamage = true;
	}
	else if (WeaponDamageEffect.DamageTypes.Find(MeleeDamageTypeName) != INDEX_NONE)
	{
		//`LWTrace("WeaponDamageEffect.DamageTypes.Find(MeleeDamageTypeName) != INDEX_NONE true");
		bIsMeleeDamage = true;
	}
	else if ((WeaponDamageEffect.EffectDamageValue.DamageType == '') && (WeaponDamageEffect.DamageTypes.Length == 0))
	{
		//`LWTrace("(WeaponDamageEffect.EffectDamageValue.DamageType == '') && (WeaponDamageEffect.DamageTypes.Length == 0)");
		if(SourceItem != None )
		{
			// Let's check the weapon's damage type
			SourceItem.GetBaseWeaponDamageValue(XComGameState_BaseObject(TargetDamageable), BaseDamageValue);
			if(BaseDamageValue.DamageType == MeleeDamageTypeName)
			{
				bIsMeleeDamage = true;
			}
		}
		else
		{
			// No weapon attached to the ability, assume it's melee
			bIsMeleeDamage = true;
		}
			
	}
	else if ((Attacker.GetMyTemplate().CharacterGroupName == 'AdventStunLancer') && WeaponDamageEffect.DamageTypes.Find('Electrical') != INDEX_NONE)
	{
		//`LWTrace("(Attacker.GetMyTemplate().CharacterGroupName == 'AdventStunLancer') && WeaponDamageEffect.DamageTypes.Find('Electrical') != INDEX_NONE true");
		bIsMeleeDamage = true;
	}
	else if((Attacker.GetMyTemplate().CharacterGroupName == 'ChosenAssassin') && WeaponDamageEffect.DamageTypes.Find('PartingSilk') != INDEX_NONE)
	{
		//`LWTrace("(Attacker.GetMyTemplate().CharacterGroupName == 'ChosenAssassin') && WeaponDamageEffect.DamageTypes.Find('PartingSilk') != INDEX_NONE true");
		bIsMeleeDamage = true;
	}

	// remove from DOT effects
	if (WeaponDamageEffect != none) 
	{
		// PartingSilk ignores base damage on the weapon
		if (WeaponDamageEffect.bIgnoreBaseDamage && WeaponDamageEffect.DamageTag != 'PartingSilk')
		{	
			return 0;
		}
	}

	if (bIsMeleeDamage)
	{
		//`LWTrace("IronSkin: IsMeleeDamage true");
		ToHitCalc = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (ToHitCalc != none && ToHitCalc.bMeleeAttack)
		{
			//`LWTrace("IronSkin: ToHitCalc.bMeleeAttack true");
			// Don't let a damage reduction effect reduce damage to less than 1 (or worse, heal).
			if (DamageMod < 0 && (CurrentDamage + DamageMod < 1))
			{
				if (CurrentDamage <= 1)
					return 0;

				return (CurrentDamage - 1) * -1;
			}
			return DamageMod;
		}
		else // Assassin handling since she uses the Deadeye hitcalc to bypass combatives.
		{
			//`LWTrace("IronSkin: ToHitCalc.bMeleeAttack false");
			// Assassin + melee and not caught by the other one.
			if(Attacker.GetMyTemplate().CharacterGroupName == 'ChosenAssassin')
			{
				//`LWTrace("IronSkin: Assassin character template passed");
				if (DamageMod < 0 && (CurrentDamage + (round(DamageMod * Assassin_Dmg_Mod)) < 1))
				{
					if (CurrentDamage <= 1)
						return 0;

					return (CurrentDamage - 1) * -1;
				}
				//`LWTrace("DamageMod:" @DamageMod @ "; Assassin_Dmg_Mod" @Assassin_Dmg_Mod);
				//`LWTrace("Returning:"@round(DamageMod * Assassin_Dmg_Mod));
				return round(DamageMod * Assassin_Dmg_Mod);
			}
		}
	}

	
	return 0;
}

defaultproperties
{
	MeleeDamageTypeName="melee"
	DuplicateResponse=eDupe_Refresh;
}