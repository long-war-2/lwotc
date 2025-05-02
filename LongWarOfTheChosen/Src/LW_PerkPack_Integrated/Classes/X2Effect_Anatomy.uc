// Code from Merist

class X2Effect_Anatomy extends X2Effect_Persistent;

var int CritBonus;
var int PierceBonus;
var bool bCheckSourceWeapon;
var bool bAllowCritOverride;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo CritInfo;

    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return;

    if (CritBonus != 0)
    {
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = CritBonus;
        ShotModifiers.AddItem(CritInfo);
    }
}

function int GetExtraArmorPiercing(
    XComGameState_Effect EffectState,
    XComGameState_Unit Attacker,
    Damageable TargetDamageable,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData AppliedData)
{
    if (bCheckSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    return PierceBonus;
}

function bool AllowCritOverride()
{
    return bAllowCritOverride;
}