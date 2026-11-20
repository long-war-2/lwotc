// This holds weapon config variables we're setting up to modify base game weapons in LWTemplateMods, but wanted them to go to the WeaponData ini to keep weapon stats centralized

class X2Item_DefaultWeaponMods_LW extends X2Item config (GameData_WeaponData);

var config array<int> LMG_ALL_RANGE;
var config array<int> MID_LONG_ALL_RANGE;

var config int BASIC_SUPPRESSOR_SOUND_REDUCTION_METERS;
var config int ADVANCED_SUPPRESSOR_SOUND_REDUCTION_METERS;
var config int ELITE_SUPPRESSOR_SOUND_REDUCTION_METERS;
var config int SUPPRESSOR_SOUND_REDUCTION_EMPOWER_BONUS;

var config int PROXIMITYMINE_iENVIRONMENTDAMAGE;
var config int MUTONGRENADE_iENVIRONMENTDAMAGE;

var config int SHAPEDCHARGE_RANGE;
var config int SHAPEDCHARGE_RADIUS;
var config WeaponDamageValue SHAPEDCHARGE_BASEDAMAGE;
var config int SHAPEDCHARGE_ISOUNDRANGE;
var config int SHAPEDCHARGE_IENVIRONMENTDAMAGE;

static function int GetScopeAimBonusAmount(X2WeaponUpgradeTemplate UpgradeTemplate)
{
    return UpgradeTemplate.AimBonus
        + (class'X2Item_DefaultUpgrades'.static.AreUpgradesEmpowered() ? class'X2Ability_LW_GearAbilities'.default.SCOPE_EMPOWER_BONUS : 0);
}

static function int GetTriggerAimBonusAmount(X2WeaponUpgradeTemplate UpgradeTemplate)
{
    return UpgradeTemplate.AimBonus
        + (class'X2Item_DefaultUpgrades'.static.AreUpgradesEmpowered() ? class'X2Ability_LW_GearAbilities'.default.TRIGGER_EMPOWER_BONUS : 0);
}

static function int GetStockBonusAmount(X2WeaponUpgradeTemplate UpgradeTemplate)
{
    return UpgradeTemplate.AimBonus
        + (class'X2Item_DefaultUpgrades'.static.AreUpgradesEmpowered() ? class'X2Ability_LW_GearAbilities'.default.STOCK_EMPOWER_BONUS : 0);
}

static function int GetSuppressorBonusAmount(X2WeaponUpgradeTemplate UpgradeTemplate)
{
    return -UpgradeTemplate.AimBonus
        - (class'X2Item_DefaultUpgrades'.static.AreUpgradesEmpowered() ? class'X2Item_DefaultWeaponMods_LW'.default.SUPPRESSOR_SOUND_REDUCTION_EMPOWER_BONUS : 0);
}
