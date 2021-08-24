// This holds weapon config variables we're setting up to modify base game weapons in LWTemplateMods, but wanted them to go to the WeaponData ini to keep weapon stats centralized

class X2Item_DefaultWeaponMods_LW extends X2Item config (GameData_WeaponData);

var config array<int> LMG_ALL_RANGE;
var config array<int> MID_LONG_ALL_RANGE;
var config array<int> MEDIUM_ALL_RANGE;
var config array<int> MIDSHORT_ALL_RANGE;
var config array<int> SHORT_ALL_RANGE;
var config array<int> LONG_ALL_RANGE;


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
