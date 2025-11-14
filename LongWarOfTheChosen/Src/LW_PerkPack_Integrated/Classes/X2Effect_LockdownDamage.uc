//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_LockdownDamage
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up to hit bonuses for Lockdown
//---------------------------------------------------------------------------------------
class X2Effect_LockdownDamage extends X2Effect_ModifyReactionFire config (LW_SoldierSkills);

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config int LOCKDOWN_TOHIT_BONUS;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

    if (class'X2Ability_PerkPackAbilitySet'.default.SUPPRESSION_SHOT_ABILITIES.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        if (Attacker.HasSoldierAbility('Lockdown'))
        {
            // The value in config should take into account the reaction fire
            // aim penalty, so we don't adjust it here
            ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
            ShotInfo.Value = default.LOCKDOWN_TOHIT_BONUS;
            ShotModifiers.AddItem(ShotInfo);
        }
    }
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
}
