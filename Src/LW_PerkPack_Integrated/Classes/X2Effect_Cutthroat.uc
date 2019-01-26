//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Cutthroat
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up crit and Armor piercing bonus
//--------------------------------------------------------------------------------------- 

class X2Effect_Cutthroat extends X2Effect_Persistent config (LW_SoldierSkills);

var int BONUS_CRIT_CHANCE;
var int BONUS_CRIT_DAMAGE;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item	SourceWeapon;
    local ShotModifierInfo		ShotInfo;

	//`LOG ("Cutthroat 1");
    if(AbilityState.GetMyTemplate().IsMelee())
	{
		//`LOG ("Cutthroat 2");
		if (Target != none && !Target.IsRobotic())
		{
			//`LOG ("Cutthroat 3");
			SourceWeapon = AbilityState.GetSourceWeapon();
			if (SourceWeapon != none)
			{
				//`LOG ("Cutthroat 4");
				ShotInfo.ModType = eHit_Crit;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = BONUS_CRIT_CHANCE;
				ShotModifiers.AddItem(ShotInfo);
			}
		}
	}
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit		Target;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	if(AbilityState.GetMyTemplate().IsMelee())
	{
	    if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{
			Target = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AppliedData.TargetStateObjectRef.ObjectID));
			if (Target != none && !Target.IsRobotic())
			{
				if (CurrentDamage > 0)
				{
					// remove from DOT effects
					WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
					if (WeaponDamageEffect != none)
					{			
						if (WeaponDamageEffect.bIgnoreBaseDamage)
						{	
							return 0;		
						}
					}
					return BONUS_CRIT_DAMAGE;
				}
			}
        }
    }
	return 0;
}

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local XComGameState_Item		SourceWeapon;
	local XComGameState_Unit		Target;

	if(AbilityState.GetMyTemplate().IsMelee())
	{
		Target = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AppliedData.TargetStateObjectRef.ObjectID));
		if (Target != none && !Target.IsRobotic())
		{		
			SourceWeapon = AbilityState.GetSourceWeapon();
			if (SourceWeapon != none)
			{				
				return 9999;
			}
		}
	}	
	return 0;
}

defaultproperties
{
    DuplicateResponse=eDupe_Allow
    EffectName="Cutthroat"
}

