//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Cutthroat
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up crit and Armor piercing bonus
//--------------------------------------------------------------------------------------- 

class X2Effect_Cutthroat extends X2Effect_Persistent config(LW_SoldierSkills);

var int BONUS_CRIT_CHANCE;
var int BONUS_CRIT_DAMAGE;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo      CritInfo;

    if (AbilityState.IsMeleeAbility())
    {
        if (Target != none && !Target.IsRobotic())
        {
            CritInfo.ModType = eHit_Crit;
            CritInfo.Reason = FriendlyName;
            CritInfo.Value = BONUS_CRIT_CHANCE;
            ShotModifiers.AddItem(CritInfo);
        }
    }
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Unit Target;

    if (AbilityState.IsMeleeAbility())
    {
        if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
        {
            Target = XComGameState_Unit(TargetDamageable);
            if (Target != none && !Target.IsRobotic())
            {
                if (CurrentDamage > 0)
                {
                    // remove from DOT effects
                    if (EffectState.ApplyEffectParameters.EffectRef.ApplyOnTickIndex != INDEX_NONE)
                        return 0;
                    
                    return BONUS_CRIT_DAMAGE;
                }
            }
        }
    }
    return 0;
}

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
    local XComGameState_Unit Target;

    if (AbilityState.IsMeleeAbility())
    {
        Target = XComGameState_Unit(TargetDamageable);
        if (Target != none && !Target.IsRobotic())
        {
            return 9999;
        }
    }

    return 0;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="Cutthroat"
}

