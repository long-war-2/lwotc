class X2Effect_CoupDeGrace2 extends X2Effect_Persistent;

var int AimBonus;
var int CritBonus;
var int DamageBonus;
var float fDisorientedModifier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Unit Target;
    
    if (AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
        return 0;

    if (AbilityState.SourceWeapon.ObjectID != EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        return 0;
    
    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            Target = XComGameState_Unit(TargetDamageable);
            
            if (Target != none)
            {
                if (Target.IsStunned() || Target.IsPanicked() || Target.IsUnconscious())
                    return DamageBonus;

                if (Target.IsDisoriented())
                    return Round(fDisorientedModifier * DamageBonus);
            }
        }
    }
    
    return 0;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo AimInfo;
    local ShotModifierInfo CritInfo;
    
    if (AbilityState.SourceWeapon.ObjectID != EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
        return;
    
    if (Target.IsStunned() || Target.IsPanicked() || Target.IsUnconscious())
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = AimBonus;
        ShotModifiers.AddItem(AimInfo);
        
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = CritBonus;
        ShotModifiers.AddItem(CritInfo);
    }	
    else if (Target.IsDisoriented())
    {
        AimInfo.ModType = eHit_Success;
        AimInfo.Reason = FriendlyName;
        AimInfo.Value = Round(fDisorientedModifier * AimBonus);
        ShotModifiers.AddItem(AimInfo);
        
        CritInfo.ModType = eHit_Crit;
        CritInfo.Reason = FriendlyName;
        CritInfo.Value = Round(fDisorientedModifier * CritBonus);
        ShotModifiers.AddItem(CritInfo);
    }
}

defaultproperties
{
    fDisorientedModifier = 1.0f
}