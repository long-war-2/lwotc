class X2Item_MoreFlamethrowers extends X2Item config(GameData_WeaponData);

var config int ADVPURIFIER_FLAMETHROWER_ISOUNDRANGE;
var config int ADVPURIFIER_FLAMETHROWER_IENVIRONMENTDAMAGE;
var config int ADVPURIFIER_FLAMETHROWER_ICLIPSIZE;
var config int ADVPURIFIER_FLAMETHROWER_RANGE;
var config int ADVPURIFIER_FLAMETHROWER_RADIUS;
var config float ADVPURIFIER_FLAMETHROWER_TILE_COVERAGE_PERCENT;

var config WeaponDamageValue ADVPURIFIER_FLAMETHROWER_BASEDAMAGE;
var config WeaponDamageValue ADVPURIFIER_DEATH_EXPLOSION_BASEDAMAGE;


static function array<X2DataTemplate> CreateTemplates()
{

local array<X2DataTemplate> Weapons;
	Weapons.AddItem(CreateTemplate_AdvPurifierFlamethrowerM2());
	Weapons.AddItem(CreateTemplate_AdvPurifierFlamethrowerM3());
}

static function X2WeaponTemplate CreateTemplate_AdvPurifierFlamethrowerM2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvPurifierFlamethrowerM2');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Advent_Flamethrower";
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.BaseDamage = default.ADVPURIFIER_FLAMETHROWER_BASEDAMAGE;
	Template.iSoundRange = default.ADVPURIFIER_FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVPURIFIER_FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVPURIFIER_FLAMETHROWER_ICLIPSIZE;
	Template.iRange = default.ADVPURIFIER_FLAMETHROWER_RANGE;
	Template.iRadius = default.ADVPURIFIER_FLAMETHROWER_RADIUS;
	Template.fCoverage = default.ADVPURIFIER_FLAMETHROWER_TILE_COVERAGE_PERCENT;
	
	Template.InfiniteAmmo = true;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';
	

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype = "WP_AdvFlamethrower.WP_AdvFlamethrower";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('AdvPurifierFlamethrowerM2');

	Template.CanBeBuilt = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.ADVPURIFIER_FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.ADVPURIFIER_FLAMETHROWER_RADIUS);

	return Template;
}

static function X2WeaponTemplate CreateTemplate_AdvPurifierFlamethrowerM3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvPurifierFlamethrowerM3');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Advent_Flamethrower";
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.BaseDamage = default.ADVPURIFIER_FLAMETHROWER_BASEDAMAGE;
	Template.iSoundRange = default.ADVPURIFIER_FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVPURIFIER_FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVPURIFIER_FLAMETHROWER_ICLIPSIZE;
	Template.iRange = default.ADVPURIFIER_FLAMETHROWER_RANGE;
	Template.iRadius = default.ADVPURIFIER_FLAMETHROWER_RADIUS;
	Template.fCoverage = default.ADVPURIFIER_FLAMETHROWER_TILE_COVERAGE_PERCENT;
	
	Template.InfiniteAmmo = true;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';
	

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype = "WP_AdvFlamethrower.WP_AdvFlamethrower";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('AdvPurifierFlamethrowerM3');

	Template.CanBeBuilt = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.ADVPURIFIER_FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.ADVPURIFIER_FLAMETHROWER_RADIUS);

	return Template;
}