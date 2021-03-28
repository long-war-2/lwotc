//---------------------------------------------------------------------------------------
//  FILE:    X2Item_PurifierWeapons.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Creating additional purifier weapon templates
//---------------------------------------------------------------------------------------
class X2Item_PurifierWeapons extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue ADV_PURIFIER_PISTOL_M1_WPN_BASEDAMAGE;
var config WeaponDamageValue ADV_PURIFIER_PISTOL_M2_WPN_BASEDAMAGE;
var config WeaponDamageValue ADV_PURIFIER_PISTOL_M3_WPN_BASEDAMAGE;

var config WeaponDamageValue ADVPURIFIERM2_FLAMETHROWER_BASEDAMAGE;
var config WeaponDamageValue ADVPURIFIERM3_FLAMETHROWER_BASEDAMAGE;


static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Weapons;
    
    Weapons.AddItem(CreateTemplate_AdvPurifierPistolM1_WPN());
    Weapons.AddItem(CreateTemplate_AdvPurifierPistolM2_WPN());
    Weapons.AddItem(CreateTemplate_AdvPurifierPistolM3_WPN());
    Weapons.AddItem(CreateTemplate_AdvPurifierM2Flamethrower());
    Weapons.AddItem(CreateTemplate_AdvPurifierM3Flamethrower());

    return Weapons;
}


static function X2DataTemplate CreateTemplate_AdvPurifierPistolM1_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvPurifierPistolM1_WPN');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.
	 
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";

	Template.RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADV_PURIFIER_PISTOL_M1_WPN_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;


	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('PistolReturnFire');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG.WP_Pistol_MG_Advent";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvPurifierPistolM2_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvPurifierPistolM2_WPN');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";

	Template.RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADV_PURIFIER_PISTOL_M2_WPN_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;


	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('PistolReturnFire');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG.WP_Pistol_MG_Advent";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvPurifierPistolM3_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvPurifierPistolM3_WPN');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";

	Template.RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADV_PURIFIER_PISTOL_M2_WPN_BASEDAMAGE;
	Template.Aim = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;


	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('PistolReturnFire');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG.WP_Pistol_MG_Advent";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}


static function X2WeaponTemplate CreateTemplate_AdvPurifierM2Flamethrower()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvPurifierM2Flamethrower');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Advent_Flamethrower";
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.BaseDamage = default.ADVPURIFIERM2_FLAMETHROWER_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_ICLIPSIZE;
	Template.iRange = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_RANGE;
	Template.iRadius = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_RADIUS;
	Template.fCoverage = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_TILE_COVERAGE_PERCENT;
	Template.iIdealRange = 7;
	Template.InfiniteAmmo = true;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';
	

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype = "WP_AdventFlamethrower_Rusty.Archetypes.WP_AdvFlamethrower_Rusty";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('AdvPurifierFlamethrower');

	Template.CanBeBuilt = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_RADIUS);

	return Template;
}

	static function X2WeaponTemplate CreateTemplate_AdvPurifierM3Flamethrower()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvPurifierM3Flamethrower');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Advent_Flamethrower";
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.BaseDamage = default.ADVPURIFIERM3_FLAMETHROWER_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_ICLIPSIZE;
	Template.iRange = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_RANGE;
	Template.iRadius = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_RADIUS;
	Template.fCoverage = class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_TILE_COVERAGE_PERCENT;
	Template.iIdealRange = 7;

	Template.InfiniteAmmo = true;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';
	

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype = "WP_AdventFlamethrower_Rusty.Archetypes.WP_AdvFlamethrower_Rusty";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('AdvPurifierFlamethrower');

	Template.CanBeBuilt = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_XpackWeapons'.default.ADVPURIFIER_FLAMETHROWER_RADIUS);

	return Template;
}