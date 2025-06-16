//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_MeristLayeredArmorV2.uc
//  AUTHOR:  Merist
//  PURPOSE: Reduce all incoming damage for the rest of the turn
//           whenever a unit takes damage above a percent of their
//           max HP in a single turn
//---------------------------------------------------------------------------------------
class X2Effect_MeristLayeredArmorV2 extends X2Effect_MeristLayeredArmor;

// Damage cap per round:
// var float PrcDamageCap;
// var bool bUseDifficulySettings;
// var array<float> PrcDamageCapDifficulty;
// var protectedwrite array<AdditionalDamageCapInfo> AdditionalPrcDamageCap;

// Not used for this effect
// var private string strFlyoverMessage;
// var private string strFlyoverIcon;

// Damage reduction IN PERCENTS above the cap
var float FinalPrcDamageModifier;
var array<float> FinalPrcDamageModifierDifficulty;

function float GetFinalDamageModifierPercent(XComGameState_Unit Unit)
{
    local float DamageModifier;

    if (bUseDifficulySettings)
        DamageModifier = FinalPrcDamageModifierDifficulty[`TACTICALDIFFICULTYSETTING];
    else
        DamageModifier = FinalPrcDamageModifier;
    
    return DamageModifier;
}

function float GetPostDefaultDefendingDamageModifier_CH(
    XComGameState_Effect EffectState,
    XComGameState_Unit SourceUnit,
    XComGameState_Unit TargetUnit,
    XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
    float WeaponDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    XComGameState NewGameState)
{
    local X2AbilityTemplate AbilityTemplate;
    local X2AbilityMultiTarget_BurstFire BurstFire;
    local int MaxHealth;
    local int DamageTaken;
    local int MaxDamage;
    local int DamageOverflow;
    local int BurstFullDamage;
    local int BurstFireOverflow;
    local UnitValue UValue;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
    {
        if (WeaponDamage > 0)
        {
            if (TargetUnit != none)
            {
                MaxHealth = TargetUnit.GetMaxStat(eStat_HP);
                TargetUnit.GetUnitValue('DamageThisTurn', UValue);
                DamageTaken = int(UValue.fValue);
                MaxDamage = Max(Round(MaxHealth * GetPercentDamageCap(TargetUnit) / 100) - DamageTaken, 0);
                `LOG("==================================================", bLog, 'X2Effect_MeristLayeredArmorV2');
                `LOG("Remaining damage: " $ MaxDamage, bLog, 'X2Effect_MeristLayeredArmorV2');

                AbilityTemplate = AbilityState.GetMyTemplate();
                BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
                if (BurstFire == none || !bCapBurstFire)
                {
                    DamageOverflow = Clamp(WeaponDamage - MaxDamage, 0, WeaponDamage);
                    `LOG("Overflow: " $ DamageOverflow, bLog, 'X2Effect_MeristLayeredArmorV2');
                    
                    return -1 * Round(DamageOverflow * GetFinalDamageModifierPercent(TargetUnit) / 100);
                }
                else
                {
                    // Each of Burst Fire shots applies at the same time,
                    // causing Layred Armor to not apply.
                    // Use full Burst Fire damage to figure out how much of each shot should be ignored
                    BurstFullDamage = WeaponDamage * (1 + BurstFire.NumExtraShots);
                    DamageOverflow = Clamp(BurstFullDamage - MaxDamage, 0, BurstFullDamage);
                    `LOG("Expected Burst Fire DamageOverflow: " $ DamageOverflow, bLog, 'X2Effect_MeristLayeredArmorV2');

                    BurstFireOverflow = Clamp(Round(DamageOverflow / (1 + BurstFire.NumExtraShots)), 0, WeaponDamage);
                    `LOG("DamageOverflow per shot: " $ BurstFireOverflow, bLog, 'X2Effect_MeristLayeredArmorV2');

                    return -1 * Round(BurstFireOverflow * GetFinalDamageModifierPercent(TargetUnit) / 100);
                }
                `LOG("==================================================", bLog, 'X2Effect_MeristLayeredArmorV2');
            }
        }
    }

    return 0;
}

defaultproperties
{
    bDisplayInSpecialDamageMessageUI = true;
}