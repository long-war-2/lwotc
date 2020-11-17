//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Fatality_LW.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Sets up Fatality perk effect
//--------------------------------------------------------------------------------------- 

class X2Effect_Fatality_LW extends X2Effect_Persistent config (LW_SoldierSkills);

var int FatalityAimBonus;
var int FatalityCritBonus;
var float FatalityThreshold;
function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item SourceWeapon;
    local ShotModifierInfo ShotInfo;

    SourceWeapon = AbilityState.GetSourceWeapon();    
    if ((SourceWeapon != none) && (Target != none))
    {
        if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
        {
            if (Target.GetCurrentStat(eStat_HP) <= (Target.GetMaxStat(eStat_HP) * FatalityThreshold))
            {
                ShotInfo.ModType = eHit_Success;
                ShotInfo.Reason = FriendlyName;
                ShotInfo.Value = FatalityAimBonus;
                ShotModifiers.AddItem(ShotInfo);

                ShotInfo.ModType = eHit_Crit;
                ShotInfo.Reason = FriendlyName;
                ShotInfo.Value = FatalityCritBonus;
                ShotModifiers.AddItem(ShotInfo);
            }
        }
    }    
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="Fatality_LW"
}