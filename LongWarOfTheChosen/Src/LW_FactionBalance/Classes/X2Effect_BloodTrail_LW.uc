//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BloodTrail_LW
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Adds a dodge-reduction bonus to the target in addition to the normal
//           Blood Trail bonus damage.
//---------------------------------------------------------------------------------------
class X2Effect_BloodTrail_LW extends X2Effect_Persistent;

var int BonusDamage;
var int DodgeReductionBonus;

var bool bApplyToExplosives;
var bool bApplyToDOTs;
var bool bMatchSourceWeapon;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Unit TargetUnit;

    if (!bApplyToExplosives && IsExplosive(AbilityState))
    {
        return 0;
    }

    if (!bApplyToDOTs && AppliedData.EffectRef.ApplyOnTickIndex != INDEX_NONE)
    {
        return 0;
    }

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        return 0;
    }

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            TargetUnit = XComGameState_Unit(TargetDamageable);
            if (TargetUnit != none && ShouldApplyBonuses(EffectState, TargetUnit, AbilityState))
            {
                return BonusDamage;
            }
        }
    }

    return 0;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;
    local int DodgeReduction;

    if (bMatchSourceWeapon && AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        return;
    }

    if (ShouldApplyBonuses(EffectState, Target, AbilityState))
    {
        DodgeReduction = Clamp(Target.GetCurrentStat(eStat_Dodge), 0, DodgeReductionBonus);

        ShotInfo.ModType = eHit_Graze;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = -1 * DodgeReduction;
        ShotModifiers.AddItem(ShotInfo);
    }
}

private function bool ShouldApplyBonuses(XComGameState_Effect EffectState, XComGameState_Unit Target, XComGameState_Ability AbilityState)
{
    local UnitValue DamageUnitValue;

    Target.GetUnitValue('DamageThisTurn', DamageUnitValue);

    return DamageUnitValue.fValue > 0;
}

private function bool IsExplosive(XComGameState_Ability AbilityState)
{
    local XComGameState_Item    SourceWeapon;
    local X2GrenadeTemplate     GrenadeTemplate;

    SourceWeapon = AbilityState.GetSourceWeapon();
    
    if (SourceWeapon != none)
    {
        GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetMyTemplate());

        if (GrenadeTemplate == none)
        {
            GrenadeTemplate = X2GrenadeTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
        }

        if (GrenadeTemplate != none)
        {
            return true;
        }
    }

    if (class'X2Effect_BonusRocketDamage_LW'.default.VALID_ABILITIES.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        return true;
    }

    return false;
}

defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = "BloodTrail"
    bDisplayInSpecialDamageMessageUI = true

    bApplyToExplosives = false
    bApplyToDOTs = false
    bMatchSourceWeapon = false
}
