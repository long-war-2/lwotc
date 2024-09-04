// This is an Unreal Script
class X2Item_SparkWeapons extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue SPARKRIFLE_LASER_BASEDAMAGE;
var config int SPARKRIFLE_LASER_AIM;
var config int SPARKRIFLE_LASER_CRITCHANCE;
var config int SPARKRIFLE_LASER_ICLIPSIZE;
var config int SPARKRIFLE_LASER_ISOUNDRANGE;
var config int SPARKRIFLE_LASER_IENVIRONMENTDAMAGE;
var config int SPARKRIFLE_LASER_ISUPPLIES;
var config int SPARKRIFLE_LASER_TRADINGPOSTVALUE;
var config int SPARKRIFLE_LASER_IPOINTS;
var config int SPARKRIFLE_LASER_UPGRADESLOTS;
var config string SparkRifle_Laser_ImagePath;
var config array<int> MEDIUM_LASER_RANGE;


var config WeaponDamageValue SPARKRIFLE_COIL_BASEDAMAGE;
var config int SPARKRIFLE_COIL_AIM;
var config int SPARKRIFLE_COIL_CRITCHANCE;
var config int SPARKRIFLE_COIL_ICLIPSIZE;
var config int SPARKRIFLE_COIL_ISOUNDRANGE;
var config int SPARKRIFLE_COIL_IENVIRONMENTDAMAGE;
var config int SPARKRIFLE_COIL_ISUPPLIES;
var config int SPARKRIFLE_COIL_TRADINGPOSTVALUE;
var config int SPARKRIFLE_COIL_IPOINTS;
var config int SPARKRIFLE_COIL_UPGRADESLOTS;
var config string SparkRifle_Coil_ImagePath;
var config array<int> MEDIUM_COIL_RANGE;

var config int TIER2_HEAVYINTIMIDATE_STRENGTH, TIER2_LIGHTINTIMIDATE_STRENGTH, TIER3_HEAVYINTIMIDATE_STRENGTH, TIER3_LIGHTINTIMIDATE_STRENGTH;
var config WeaponDamageValue TIER2_HEAVYSTRIKE_DMG, TIER2_LIGHTSTRIKE_DMG, TIER3_HEAVYSTRIKE_DMG, TIER3_LIGHTSTRIKE_DMG;

var config int SPARK_PLATED_HEAVY_HEALTH_BONUS;
var config int SPARK_PLATED_HEAVY_MOBILITY_BONUS;
var config int SPARK_PLATED_HEAVY_MITIGATION_AMOUNT;
var config int SPARK_PLATED_HEAVY_MITIGATION_CHANCE;
var config int SPARK_PLATED_HEAVY_DEF_BONUS;

var config int SPARK_PLATED_LIGHT_HEALTH_BONUS;
var config int SPARK_PLATED_LIGHT_MOBILITY_BONUS;
var config int SPARK_PLATED_LIGHT_MITIGATION_AMOUNT;
var config int SPARK_PLATED_LIGHT_MITIGATION_CHANCE;
var config int SPARK_PLATED_LIGHT_DEF_BONUS;

var config int SPARK_POWERED_HEAVY_HEALTH_BONUS;
var config int SPARK_POWERED_HEAVY_MOBILITY_BONUS;
var config int SPARK_POWERED_HEAVY_MITIGATION_AMOUNT;
var config int SPARK_POWERED_HEAVY_MITIGATION_CHANCE;
var config int SPARK_POWERED_HEAVY_DEF_BONUS;

var config int SPARK_POWERED_LIGHT_HEALTH_BONUS;
var config int SPARK_POWERED_LIGHT_MOBILITY_BONUS;
var config int SPARK_POWERED_LIGHT_MITIGATION_AMOUNT;
var config int SPARK_POWERED_LIGHT_MITIGATION_CHANCE;
var config int SPARK_POWERED_LIGHT_DEF_BONUS;


static function array<X2DataTemplate> CreateTemplates()
{	local array<X2DataTemplate> Weapons;
	Weapons.AddItem(Create_SparkRifle_Laser());
	Weapons.AddItem(Create_SparkRifle_Coil());
	Weapons.AddItem(Create_SPARKChaingun());
	
	Weapons.AddItem(CreatePlatedSparkHeavyArmor());
	Weapons.AddItem(CreatePlatedSparkLightArmor());
	Weapons.AddItem(CreatePoweredSparkHeavyArmor());
	Weapons.AddItem(CreatePoweredSparkLightArmor());
	
	return Weapons;
}


static function X2DataTemplate Create_SPARKChaingun()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SPARKChaingun');

	Template.strImage = "img:///EW_MEC_Weapons.UI.HeavyChaingun";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.WeaponPanelImage = "_ConventionalRifle";
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sparkrifle';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Tier = 0;

	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
	Template.BaseDamage = class'X2Item_DLC_Day90Weapons'.default.SPARKRIFLE_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = class'X2Item_DLC_Day90Weapons'.default.SPARKRIFLE_CONVENTIONAL_AIM;
	Template.CritChance = class'X2Item_DLC_Day90Weapons'.default.SPARKRIFLE_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = class'X2Item_DLC_Day90Weapons'.default.SPARKRIFLE_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DLC_Day90Weapons'.default.SPARKRIFLE_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DLC_Day90Weapons'.default.SPARKRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 3;
	
		
	Template.GameArchetype = "EW_MEC_Weapons.Archetypes.WP_MEC_Chaingun";

	Template.bIsLargeWeapon = true;	//Used in Weapon Upgrade UI to determine distance from camera.
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.iPhysicsImpulse = 5;
	Template.fKnockbackDamageAmount = 5.0f;
	Template.fKnockbackDamageRadius = 0.0f;
	Template.DamageTypeTemplateName = 'Projectile_Conventional';
	
	return Template;
}


static function X2DataTemplate Create_SparkRifle_Laser()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SparkRifle_LS');

	Template.strImage = "img:///" $ default.SparkRifle_Laser_ImagePath;
	
	Template.WeaponCat = 'sparkrifle';
	Template.WeaponTech = 'laser_lw';
	Template.ItemCat = 'weapon';
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.WeaponPanelImage = "_MagneticRifle";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.iPhysicsImpulse = 5;

	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');


	Template.BaseDamage = default.SPARKRIFLE_LASER_BASEDAMAGE;
	Template.RangeAccuracy = default.MEDIUM_LASER_RANGE;
	Template.Aim = default.SPARKRIFLE_LASER_AIM;
	Template.CritChance = default.SPARKRIFLE_LASER_CRITCHANCE;
	Template.iClipSize = default.SPARKRIFLE_LASER_ICLIPSIZE;
	Template.iSoundRange = default.SPARKRIFLE_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SPARKRIFLE_LASER_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = default.SPARKRIFLE_LASER_UPGRADESLOTS;
	

	Template.GameArchetype = "IRI_Sparkgun_LS_LW.Archetype.WP_SparkRifle_LS";
	Template.AddDefaultAttachment('Light', "LWAttachments_LS.Meshes.SK_Laser_Flashlight", ,);
	Template.AddDefaultAttachment('Mag', "IRI_Sparkgun_LS_LW.Meshes.SM_SparkRifle_LS_MagA", , "img:///IRI_Sparkgun_LS_LW.UI.SPARK_Laser_magazine_base");
	Template.AddDefaultAttachment('Reargip', "IRI_Sparkgun_LS_LW.Meshes.SM_SparkRifle_LS_ReargripA", ,);

	
	Template.CreatorTemplateName = 'SparkRifle_LS_Schematic'; // The schematic which creates this item
	
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Template.bIsLargeWeapon = true;	//Used in Weapon Upgrade UI to determine distance from camera.
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.Requirements.RequiredTechs.AddItem('AdvancedLasers');


	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate Create_SparkRifle_Coil()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SparkRifle_CG');

	Template.strImage = "img:///" $ default.SparkRifle_Coil_ImagePath;
	
	Template.WeaponCat = 'sparkrifle';
	Template.WeaponTech = 'coilgun_lw';
	Template.ItemCat = 'weapon';
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.WeaponPanelImage = "_MagneticRifle";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.iPhysicsImpulse = 5;

	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('CoilgunBonusShredAbility');


	Template.BaseDamage = default.SPARKRIFLE_COIL_BASEDAMAGE;
	Template.RangeAccuracy = default.MEDIUM_COIL_RANGE;
	Template.Aim = default.SPARKRIFLE_COIL_AIM;
	Template.CritChance = default.SPARKRIFLE_COIL_CRITCHANCE;
	Template.iClipSize = default.SPARKRIFLE_COIL_ICLIPSIZE;
	Template.iSoundRange = default.SPARKRIFLE_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SPARKRIFLE_COIL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = default.SPARKRIFLE_COIL_UPGRADESLOTS;
	

	Template.GameArchetype = "IRI_Sparkgun_CG_LW.Archetypes.WP_SparkGunl_CG_Fixed";

	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight", ,);
	Template.AddDefaultAttachment('Mag', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_MagA", , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_MagA");
	Template.AddDefaultAttachment('Trigger', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_TriggerA", , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_TriggerA");
	Template.AddDefaultAttachment('Stock', "IRI_Sparkgun_CG_LW.Meshes.SM_SparkRifle_CG_StockA", , "img:///IRI_Sparkgun_CG_LW.UI.SparkGun_StockA");



	
	Template.CreatorTemplateName = 'SparkRifle_CG_Schematic'; // The schematic which creates this item

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 60;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Template.bIsLargeWeapon = true;	//Used in Weapon Upgrade UI to determine distance from camera.
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.Requirements.RequiredTechs.AddItem('AdvancedCoilguns');

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}


static function X2DataTemplate CreatePlatedSparkHeavyArmor()
{
	local X2SparkArmorTemplate_DLC_3 Template;

	`CREATE_X2TEMPLATE(class'X2SparkArmorTemplate_DLC_3', Template, 'PlatedSparkHeavyArmor_LW');
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Spark_Plated_A";
	Template.ItemCat = 'armor';
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 20;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('PlatedSparkHeavyArmorStats_LW');
	Template.ArmorTechCat = 'plated';
	Template.ArmorCat = 'spark';
	Template.Tier = 1;
	Template.AkAudioSoldierArmorSwitch = 'Predator';
	Template.EquipSound = "StrategyUI_Armor_Equip_Plated_Spark";

	Template.IntimidateStrength = default.TIER2_HEAVYINTIMIDATE_STRENGTH;
	Template.StrikeDamage = default.TIER2_HEAVYSTRIKE_DMG;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, default.SPARK_PLATED_HEAVY_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, default.SPARK_PLATED_HEAVY_MITIGATION_AMOUNT);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.SPARK_PLATED_HEAVY_MOBILITY_BONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DefenseLabel, eStat_Defense, default.SPARK_PLATED_HEAVY_DEF_BONUS);

	return Template;
}


static function X2DataTemplate CreatePlatedSparkLightArmor()
{
	local X2SparkArmorTemplate_DLC_3 Template;

	`CREATE_X2TEMPLATE(class'X2SparkArmorTemplate_DLC_3', Template, 'PlatedSparkLightArmor_LW');
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Spark_Plated_A";
	Template.ItemCat = 'armor';
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 20;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('PlatedSparkLightArmorStats_LW');
	Template.Abilities.AddItem('Dedication_LW');
	Template.ArmorTechCat = 'plated';
	Template.ArmorCat = 'spark';
	Template.Tier = 1;
	Template.AkAudioSoldierArmorSwitch = 'Predator';
	Template.EquipSound = "StrategyUI_Armor_Equip_Plated_Spark";

	Template.IntimidateStrength = default.TIER2_LIGHTINTIMIDATE_STRENGTH;
	Template.StrikeDamage = default.TIER2_LIGHTSTRIKE_DMG;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, default.SPARK_PLATED_LIGHT_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, default.SPARK_PLATED_LIGHT_MITIGATION_AMOUNT);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.SPARK_PLATED_LIGHT_MOBILITY_BONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DefenseLabel, eStat_Defense, default.SPARK_PLATED_LIGHT_DEF_BONUS);

	return Template;
}


static function X2DataTemplate CreatePoweredSparkHeavyArmor()
{
	local X2SparkArmorTemplate_DLC_3 Template;

	`CREATE_X2TEMPLATE(class'X2SparkArmorTemplate_DLC_3', Template, 'PoweredSparkHeavyArmor_LW');
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Spark_Powered_A";
	Template.ItemCat = 'armor';
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 60;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('PoweredSparkHeavyArmorStats_LW');
	Template.ArmorTechCat = 'powered';
	Template.ArmorCat = 'spark';
	Template.Tier = 3;
	Template.AkAudioSoldierArmorSwitch = 'Warden';
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered_Spark";

	Template.IntimidateStrength = default.TIER3_HEAVYINTIMIDATE_STRENGTH;
	Template.StrikeDamage = default.TIER3_HEAVYSTRIKE_DMG;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, default.SPARK_POWERED_HEAVY_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, default.SPARK_POWERED_HEAVY_MITIGATION_AMOUNT);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.SPARK_POWERED_HEAVY_MOBILITY_BONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DefenseLabel, eStat_Defense, default.SPARK_POWERED_HEAVY_DEF_BONUS);

	return Template;
}


static function X2DataTemplate CreatePoweredSparkLightArmor()
{
	local X2SparkArmorTemplate_DLC_3 Template;

	`CREATE_X2TEMPLATE(class'X2SparkArmorTemplate_DLC_3', Template, 'PoweredSparkLightArmor_LW');
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Spark_Powered_A";
	Template.ItemCat = 'armor';
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 60;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('PoweredSparkLightArmorStats_LW');
	Template.Abilities.AddItem('Dedication_LW');
	Template.ArmorTechCat = 'powered';
	Template.ArmorCat = 'spark';
	Template.Tier = 3;
	Template.AkAudioSoldierArmorSwitch = 'Warden';
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered_Spark";

	Template.IntimidateStrength = default.TIER3_LIGHTINTIMIDATE_STRENGTH;
	Template.StrikeDamage = default.TIER3_LIGHTSTRIKE_DMG;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, default.SPARK_POWERED_LIGHT_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, default.SPARK_POWERED_LIGHT_MITIGATION_AMOUNT);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.SPARK_POWERED_LIGHT_MOBILITY_BONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DefenseLabel, eStat_Defense, default.SPARK_POWERED_LIGHT_DEF_BONUS);

	return Template;
}