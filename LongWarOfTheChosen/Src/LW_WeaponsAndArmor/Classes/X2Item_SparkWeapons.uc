// This is an Unreal Script
class X2Item_SPARKWeapons extends X2Item config(GameData_WeaponData);

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
var config string SparkRifle_COIL_ImagePath;
var config array<int> MEDIUM_COIL_RANGE;


static function array<X2DataTemplate> CreateTemplates()
{	local array<X2DataTemplate> Weapons;
	Weapons.AddItem(Create_SparkRifle_Laser());
	Weapons.AddItem(Create_SparkRifle_Coil());
	Weapons.AddItem(Create_SPARKChaingun());
	

	
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
	

	Template.GameArchetype = "EW_MEC_Weapons.Archetypes.WP_MEC_Railgun";
	
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


	Template.BaseDamage = default.SPARKRIFLE_COIL_BASEDAMAGE;
	Template.RangeAccuracy = default.MEDIUM_COIL_RANGE;
	Template.Aim = default.SPARKRIFLE_COIL_AIM;
	Template.CritChance = default.SPARKRIFLE_COIL_CRITCHANCE;
	Template.iClipSize = default.SPARKRIFLE_COIL_ICLIPSIZE;
	Template.iSoundRange = default.SPARKRIFLE_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SPARKRIFLE_COIL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = default.SPARKRIFLE_COIL_UPGRADESLOTS;
	

	Template.GameArchetype = "EW_MEC_Weapons.Archetypes.WP_MEC_PPC";
	
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
