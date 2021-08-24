class X2Item_LWGrenades extends X2Item_DefaultGrenades config(GameData_WeaponData);

var config int MAG_GRENADE_ISOUNDRANGE;
var config int MAG_GRENADE_IENVIRONMENTDAMAGE;
var config int MAG_GRENADE_TRADINGPOSTVALUE;
var config int MAG_GRENADE_IPOINTS;
var config int MAG_GRENADE_ICLIPSIZE;
var config int MAG_GRENADE_RANGE;
var config int MAG_GRENADE_RADIUS;
var config WeaponDamageValue MAG_GRENADE_BASEDAMAGE;

static function X2DataTemplate CreateMagGrenade()
{
	local X2GrenadeTemplate                  Template;
	local X2Effect_ApplyWeaponDamage         WeaponDamageEffect;
	local ArtifactCost                       Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'MagGrenade_LW');

	Template.strImage = "img:///WoTC_Advent_Assault_Trooper_UI_LW.Inv_Xcom_MagGrenade"; //Texture2D'WoTC_Advent_Assault_Trooper_UI_LW.Inv_Xcom_MagGrenade'
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///WoTC_Advent_Assault_Trooper_UI_LW.UIPerk_grenade_Mag");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///WoTC_Advent_Assault_Trooper_UI_LW.UIPerk_grenade_Mag"); //Texture2D'WoTC_Advent_Assault_Trooper_UI_LW.UIPerk_grenade_Mag'

	Template.iRange = default.MAG_GRENADE_RANGE;
	Template.iRadius = default.MAG_GRENADE_RADIUS;
	//Template.fCoverage = 50;

	Template.BaseDamage = default.MAG_GRENADE_BASEDAMAGE;
	Template.iSoundRange = default.MAG_GRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.MAG_GRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = default.MAG_GRENADE_TRADINGPOSTVALUE;
	Template.PointsToComplete = default.MAG_GRENADE_IPOINTS;
	Template.iClipSize = default.MAG_GRENADE_ICLIPSIZE;
	Template.Tier = 1;



	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');


	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;


	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);
	
	Template.GameArchetype = "WoTC_Advent_Assault_Trooper_Grenades_LW.Archetypes.WP_Grenade_Mag_Xcom"; //XComWeapon'WoTC_Advent_Assault_Trooper_Grenades_LW.Archetypes.WP_Grenade_Mag_Xcom'

	Template.iPhysicsImpulse = 10;
	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 10.0f;

	Template.CanBeBuilt = true;
	
	//Template.RewardDecks.AddItem('ExperimentalGrenadeRewards');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.MAG_GRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.MAG_GRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , default.MAG_GRENADE_BASEDAMAGE.Shred);

	return Template;
}