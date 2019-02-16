//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Kubikuri
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up Damage bonus and flyover for Kubikuri
//---------------------------------------------------------------------------------------

class X2Effect_Kubikuri extends X2Effect_Persistent config (LW_SoldierSkills);

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config float KUBIKURI_KILLFAIL_DAMAGE_MODIFIER;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Item SourceWeapon;
    local XComGameState_Unit TargetUnit;
	local StateObjectReference AbilityRef;

	//`LOG ("Kubikiri testing");

	if (AppliedData.AbilityResultContext.CalculatedHitChance <= 0) 
		return 0;

	if (AbilityState.GetMyTemplateName() == 'Kubikuri')
	{
	    if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{
			SourceWeapon = AbilityState.GetSourceWeapon();
			if(SourceWeapon != none) 
			{
				TargetUnit = XComGameState_Unit(TargetDamageable);
				if(TargetUnit != none)
				{
					AbilityRef = TargetUnit.FindAbility('AlienRulerPassive');
					if (AbilityRef.ObjectID != 0)
					{
						return (CurrentDamage * 2);
					}
					//`LOG ("Kubikiri Target" @ TargetUnit.GetMyTemplateName() @ "CurrentHP:" @ string(TargetUnit.GetCurrentStat(eStat_HP)) @ "MAXHP:" @ string (TargetUnit.GetMaxStat(eStat_HP)) @ "Current HP must be less than " @ string (TargetUnit.GetMaxStat(eStat_HP) * class'X2Ability_PerkPackAbilitySet'.default.KUBIKURI_MAX_HP_PCT/100));
					if (TargetUnit.GetCurrentStat(eStat_HP) <= TargetUnit.GetMaxStat(eStat_HP) * class'X2Ability_PerkPackAbilitySet'.default.KUBIKURI_MAX_HP_PCT / 100)	
					{				
						//`LOG ("Kubikiri dealing" @ int(2 * (TargetUnit.GetCurrentStat(eStat_HP)+TargetUnit.GetCurrentStat(eStat_ShieldHP)+TargetUnit.GetCurrentStat(eStat_ArmorMitigation)+CurrentDamage)) @ "damage.");
						return int(2 * (TargetUnit.GetCurrentStat(eStat_HP)+TargetUnit.GetCurrentStat(eStat_ShieldHP)+TargetUnit.GetCurrentStat(eStat_ArmorMitigation)+CurrentDamage));
					}
				}
            }
        }
		if(AppliedData.AbilityResultContext.HitResult == eHit_Success || AppliedData.AbilityResultContext.HitResult == eHit_Graze)
		{
			SourceWeapon = AbilityState.GetSourceWeapon();
			if(SourceWeapon != none) 
			{
				TargetUnit = XComGameState_Unit(TargetDamageable);
				if(TargetUnit != none)
				{
					return (-1 * (float(CurrentDamage) * default.KUBIKURI_KILLFAIL_DAMAGE_MODIFIER));
				}
			}
		}
	}
    return 0;
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Unit	TargetUnit, PrevTargetUnit;
	local XComGameStateHistory History;

	if (kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef && kAbility.GetMyTemplateName() == 'Kubikuri')
	{
		History = `XCOMHISTORY;
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if(TargetUnit != none)		
		{
			PrevTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID));      //  get the most recent version from the history rather than our modified (attacked) version
			if ((TargetUnit.IsDead() || TargetUnit.IsBleedingOut()) && PrevTargetUnit != None)
			{
				TargetUnit.DamageResults[TargetUnit.DamageResults.Length - 1].bFreeKill = true;
				return false;
			}
		}
	}
	return false;
}