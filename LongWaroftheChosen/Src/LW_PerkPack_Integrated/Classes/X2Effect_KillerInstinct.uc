//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Killer_Instinct
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up damage bonuses for KI
//---------------------------------------------------------------------------------------
class X2Effect_KillerInstinct extends X2Effect_BonusWeaponDamage config (LW_SoldierSkills);

var config float KILLER_INSTINCT_CRIT_DAMAGE_BONUS_PCT;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Item SourceWeapon;
    local XComGameState_Unit TargetUnit;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	
	WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (WeaponDamageEffect != none)
	{			
		if (WeaponDamageEffect.bIgnoreBaseDamage)
		{	
			return 0;		
		}
	}
    if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
    {
        SourceWeapon = AbilityState.GetSourceWeapon();
        if(SourceWeapon != none) 
        {
			TargetUnit = XComGameState_Unit(TargetDamageable);
            if(TargetUnit != none)
            {
				if (Attacker.HasSoldierAbility('KillerInstinct'))
				{
					return int (CurrentDamage * (default.KILLER_INSTINCT_CRIT_DAMAGE_BONUS_PCT / 100));
				}
            }
        }
    }
    return 0;
}

