//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_MeristLayeredArmor.uc
//  AUTHOR:  Merist
//  PURPOSE: Clamp incoming damage to a percent of max HP 
//---------------------------------------------------------------------------------------
class X2Effect_MeristLayeredArmor extends X2Effect_Persistent;

struct AdditionalDamageCapInfo
{
    var name RequiredAbility;
    var float Modifier;

    var bool bModUseDifficulySettings;
    var array<float> ModifierDifficulty;
};

var protected bool bLog;

// Damage cap from max HP per attack IN PERCENTS:
var float PrcDamageCap;
var bool bUseDifficulySettings;
var array<float> PrcDamageCapDifficulty;
var protectedwrite array<AdditionalDamageCapInfo> AdditionalPrcDamageCap;

var string strFlyoverMessage;
var string strFlyoverIcon;

// Defines wether or not armor is included in the damage mitigation
// For example, if this is true, the target has 2 armor and the attack deals 3 damage,
// the incoming damage will be treated as 1 for Layered Armor calclulations
// However, it cannot account for armor piercing
// If the attack in the example above ignores all armor,
// the incoming damage will still be treated as 1

// Removed due to unreliablility
// It's impossible to guess how much of the armor will be applied to the attack
// and what the damage value per shot will be after the armor calculation
// var bool bAccountForArmor;

// Treat Burst Fire as a single attack
var bool bCapBurstFire;

function AddAdditionalDamageCapInfo(name RequiredAbility, optional float Modifier, optional bool bModUseDifficulySettings, optional array<float> ModifierDifficulty)
{
    local AdditionalDamageCapInfo AdditionalInfo;
    AdditionalInfo.RequiredAbility = RequiredAbility;
    AdditionalInfo.Modifier = Modifier;
    AdditionalInfo.bModUseDifficulySettings = bModUseDifficulySettings;
    AdditionalInfo.ModifierDifficulty = ModifierDifficulty;
    AdditionalPrcDamageCap.AddItem(AdditionalInfo);
}

function float GetPercentDamageCap(XComGameState_Unit Unit)
{
    local AdditionalDamageCapInfo AdditionalInfo;
    local float DamageCap;

    if (bUseDifficulySettings)
        DamageCap = PrcDamageCapDifficulty[`TACTICALDIFFICULTYSETTING];
    else
        DamageCap = PrcDamageCap;
    
    foreach AdditionalPrcDamageCap(AdditionalInfo)
    {
        if (Unit.HasSoldierAbility(AdditionalInfo.RequiredAbility, true))
        {
            if (AdditionalInfo.bModUseDifficulySettings)
                DamageCap += AdditionalInfo.ModifierDifficulty[`TACTICALDIFFICULTYSETTING];
            else
                DamageCap += AdditionalInfo.Modifier;
        }
    }

    return DamageCap;
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
    local int MaxDamage;
    local int DamageOverflow;
    local int BurstFullDamage;
    local int BurstFireOverflow;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
    {
        if (WeaponDamage > 0)
        {
            if (TargetUnit != none)
            {
                MaxHealth = TargetUnit.GetMaxStat(eStat_HP);
                MaxDamage = Max(Round(MaxHealth * GetPercentDamageCap(TargetUnit) / 100), 0);
                `LOG("==================================================", bLog, 'X2Effect_MeristLayeredArmor');
                `LOG("Remaining damage: " $ MaxDamage, bLog, 'X2Effect_MeristLayeredArmor');

                AbilityTemplate = AbilityState.GetMyTemplate();
                BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
                if (BurstFire == none || !bCapBurstFire)
                {
                    DamageOverflow = Clamp(WeaponDamage - MaxDamage, 0, WeaponDamage);
                    `LOG("Overflow: " $ DamageOverflow, bLog, 'X2Effect_MeristLayeredArmor');

                    return -1 * DamageOverflow;
                }
                else
                {
                    // Each of Burst Fire shots applies at the same time,
                    // causing Layred Armor to not apply
                    // Use full Burst Fire damage to figure out how much of each shot should be ignored
                    BurstFullDamage = WeaponDamage * (1 + BurstFire.NumExtraShots);
                    DamageOverflow = Clamp(BurstFullDamage - MaxDamage, 0, BurstFullDamage);
                    `LOG("Expected Burst Fire DamageOverflow: " $ DamageOverflow, bLog, 'X2Effect_MeristLayeredArmor');

                    // Example:
                    // Fan Fire takes 3 shots, each dealing 3 damage. A total of 9 damage
                    // The unit has 10 HP with a 40% cap. The cap is 4 damage per attack
                    // DamageOverflow is 5
                    // Each shot has to deal 1-2 damage depending on the rounding:
                    // Ceil -> 1
                    // Round -> 1
                    // Floor -> 2
                    BurstFireOverflow = Clamp(Round(DamageOverflow / (1 + BurstFire.NumExtraShots)), 0, WeaponDamage);
                    `LOG("DamageOverflow per shot: " $ BurstFireOverflow, bLog, 'X2Effect_MeristLayeredArmor');

                    return -1 * BurstFireOverflow;
                }
                `LOG("==================================================", bLog, 'X2Effect_MeristLayeredArmor');
            }
        }
    }

    return 0;
}

defaultproperties
{
    DuplicateResponse = eDupe_Refresh
    bLog = false
}