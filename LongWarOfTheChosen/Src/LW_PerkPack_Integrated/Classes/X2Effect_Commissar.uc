//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Commissar
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up accuracy and damage bonus for Commissar and executed popup
//---------------------------------------------------------------------------------------

class X2Effect_Commissar extends X2Effect_Persistent config (LW_SoldierSkills);

var config int COMMISSAR_HIT_BONUS;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Item SourceWeapon;
    local XComGameState_Unit TargetUnit;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if(SourceWeapon != none)
	{	
		if (SourceWeapon.GetWeaponCategory() == 'pistol')
		{
			TargetUnit = XComGameState_Unit(TargetDamageable);
			if(TargetUnit != none)
			{
				if (TargetUnit.IsSoldier() && TargetUnit.IsMindControlled())
				{
					if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
					{
						return int(TargetUnit.GetCurrentStat(eStat_HP)+TargetUnit.GetCurrentStat(eStat_ShieldHP));
					}
				}
            }
        }
	}
    return 0;
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Unit	TargetUnit, PrevTargetUnit;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;

	if (kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		History = `XCOMHISTORY;
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if(TargetUnit != none)		
		{
			PrevTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID));      //  get the most recent version from the history rather than our modified (attacked) version
			if ((TargetUnit.IsDead() || TargetUnit.IsBleedingOut()) && PrevTargetUnit != None && TargetUnit.IsSoldier() && PrevTargetUnit.IsMindControlled())
			{
				AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
				if (AbilityState != none)
				{	
					TargetUnit.DamageResults[TargetUnit.DamageResults.Length - 1].bFreeKill = true;
				}
			}
		}
	}
	return false;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item SourceWeapon;
    local ShotModifierInfo ShotInfo1, ShotInfo2;

    SourceWeapon = AbilityState.GetSourceWeapon();    
    if ((SourceWeapon != none) && (Target != none))
    {		
		if (SourceWeapon.GetWeaponCategory() == 'pistol')
		{
			if (Target.IsSoldier() && Target.IsMindControlled())
			{
				ShotInfo1.ModType = eHit_Success;
				ShotInfo1.Reason = FriendlyName;
				ShotInfo1.Value = default.COMMISSAR_HIT_BONUS;
				ShotModifiers.AddItem(ShotInfo1);

				ShotInfo2.ModType = eHit_Graze;
				ShotInfo2.Reason = FriendlyName;
				ShotInfo2.Value = -1000;
				ShotModifiers.AddItem(ShotInfo2);
			}
        }
    }    
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="Commissar"
}