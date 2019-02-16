//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Executioner
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up Executioner perk effect
//--------------------------------------------------------------------------------------- 

class X2Effect_Executioner_LW extends X2Effect_Persistent config (LW_SoldierSkills);

var config int EXECUTIONER_AIM_BONUS;
var config int EXECUTIONER_CRIT_BONUS;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item SourceWeapon;
    local ShotModifierInfo ShotInfo;

    SourceWeapon = AbilityState.GetSourceWeapon();    
    if ((SourceWeapon != none) && (Target != none))
    {
		if (Target.GetCurrentStat(eStat_HP) <= (Target.GetMaxStat(eStat_HP) / 2))
		{
		    ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = default.EXECUTIONER_AIM_BONUS;
            ShotModifiers.AddItem(ShotInfo);

			ShotInfo.ModType = eHit_Crit;
            ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = default.EXECUTIONER_CRIT_BONUS;
            ShotModifiers.AddItem(ShotInfo);
        }
    }    
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="Executioner_LW"
}