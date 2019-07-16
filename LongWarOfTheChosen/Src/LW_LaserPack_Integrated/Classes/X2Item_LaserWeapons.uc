//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LaserWeapons.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines weapon templates and updates base-game upgrade templates for Laser Weapons
//           
//---------------------------------------------------------------------------------------
class X2Item_LaserWeapons extends X2Item config(GameData_WeaponData);

//�Variables�from�config�-�GameData_WeaponData.ini
//�*****�Damage�arrays�for�attack�actions��*****

var config WeaponDamageValue ASSAULTRIFLE_LASER_BASEDAMAGE;
var config WeaponDamageValue SMG_LASER_BASEDAMAGE;
var config WeaponDamageValue LMG_LASER_BASEDAMAGE;
var config WeaponDamageValue SHOTGUN_LASER_BASEDAMAGE;
var config WeaponDamageValue SNIPERRIFLE_LASER_BASEDAMAGE;
var config WeaponDamageValue PISTOL_LASER_BASEDAMAGE;
var config WeaponDamageValue SWORD_LASER_BASEDAMAGE;

//�*****�Core properties and variables�for�weapons�*****
var config int ASSAULTRIFLE_LASER_AIM;
var config int ASSAULTRIFLE_LASER_CRITCHANCE;
var config int ASSAULTRIFLE_LASER_ICLIPSIZE;
var config int ASSAULTRIFLE_LASER_ISOUNDRANGE;
var config int ASSAULTRIFLE_LASER_IENVIRONMENTDAMAGE;
var config int ASSAULTRIFLE_LASER_ISUPPLIES;
var config int ASSAULTRIFLE_LASER_TRADINGPOSTVALUE;
var config int ASSAULTRIFLE_LASER_IPOINTS;
var config int ASSAULTRIFLE_LASER_UPGRADESLOTS;

var config int SMG_LASER_AIM;
var config int SMG_LASER_CRITCHANCE;
var config int SMG_LASER_ICLIPSIZE;
var config int SMG_LASER_ISOUNDRANGE;
var config int SMG_LASER_IENVIRONMENTDAMAGE;
var config int SMG_LASER_ISUPPLIES;
var config int SMG_LASER_TRADINGPOSTVALUE;
var config int SMG_LASER_IPOINTS;
var config int SMG_LASER_UPGRADESLOTS;

var config int LMG_LASER_AIM;
var config int LMG_LASER_CRITCHANCE;
var config int LMG_LASER_ICLIPSIZE;
var config int LMG_LASER_ISOUNDRANGE;
var config int LMG_LASER_IENVIRONMENTDAMAGE;
var config int LMG_LASER_ISUPPLIES;
var config int LMG_LASER_TRADINGPOSTVALUE;
var config int LMG_LASER_IPOINTS;
var config int LMG_LASER_UPGRADESLOTS;

var config int SHOTGUN_LASER_AIM;
var config int SHOTGUN_LASER_CRITCHANCE;
var config int SHOTGUN_LASER_ICLIPSIZE;
var config int SHOTGUN_LASER_ISOUNDRANGE;
var config int SHOTGUN_LASER_IENVIRONMENTDAMAGE;
var config int SHOTGUN_LASER_ISUPPLIES;
var config int SHOTGUN_LASER_TRADINGPOSTVALUE;
var config int SHOTGUN_LASER_IPOINTS;
var config int SHOTGUN_LASER_UPGRADESLOTS;

var config int SNIPERRIFLE_LASER_AIM;
var config int SNIPERRIFLE_LASER_CRITCHANCE;
var config int SNIPERRIFLE_LASER_ICLIPSIZE;
var config int SNIPERRIFLE_LASER_ISOUNDRANGE;
var config int SNIPERRIFLE_LASER_IENVIRONMENTDAMAGE;
var config int SNIPERRIFLE_LASER_ISUPPLIES;
var config int SNIPERRIFLE_LASER_TRADINGPOSTVALUE;
var config int SNIPERRIFLE_LASER_IPOINTS;
var config int SNIPERRIFLE_LASER_UPGRADESLOTS;

var config int PISTOL_LASER_AIM;
var config int PISTOL_LASER_CRITCHANCE;
var config int PISTOL_LASER_ICLIPSIZE;
var config int PISTOL_LASER_ISOUNDRANGE;
var config int PISTOL_LASER_IENVIRONMENTDAMAGE;
var config int PISTOL_LASER_ISUPPLIES;
var config int PISTOL_LASER_TRADINGPOSTVALUE;
var config int PISTOL_LASER_IPOINTS;
var config int PISTOL_LASER_UPGRADESLOTS;

var config int SWORD_LASER_AIM;
var config int SWORD_LASER_CRITCHANCE;
var config int SWORD_LASER_ICLIPSIZE;
var config int SWORD_LASER_ISOUNDRANGE;
var config int SWORD_LASER_IENVIRONMENTDAMAGE;
var config int SWORD_LASER_ISUPPLIES;
var config int SWORD_LASER_TRADINGPOSTVALUE;
var config int SWORD_LASER_IPOINTS;
var config int SWORD_LASER_UPGRADESLOTS;

var config array<int> SHORT_LASER_RANGE;
var config array<int> MIDSHORT_LASER_RANGE;
var config array<int> MEDIUM_LASER_RANGE;
var config array<int> LONG_LASER_RANGE;

var config string AssaultRifle_Laser_ImagePath;
var config string SMG_Laser_ImagePath;
var config string Cannon_Laser_ImagePath;
var config string Shotgun_Laser_ImagePath;
var config string SniperRifle_Laser_ImagePath;
var config string Pistol_Laser_ImagePath;
var config string Sword_Laser_ImagePath;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	`LWTrace("  >> X2Item_LaserWeapons.CreateTemplates()");
	
	//create weapon templates for laser tier
	Weapons.AddItem(CreateTemplate_AssaultRifle_Laser());
	Weapons.AddItem(CreateTemplate_SMG_Laser());
	Weapons.AddItem(CreateTemplate_Cannon_Laser());
	Weapons.AddItem(CreateTemplate_Shotgun_Laser());
	Weapons.AddItem(CreateTemplate_SniperRifle_Laser());
	Weapons.AddItem(CreateTemplate_Sword_Laser());

	return Weapons;
}

// **********************************************************************************************************
// ***                                            Laser Weapons                                           ***
// **********************************************************************************************************

static function X2DataTemplate CreateTemplate_AssaultRifle_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AssaultRifle_LS');

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'laser_lw'; 
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///" $ default.AssaultRifle_Laser_ImagePath; 
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = default.MEDIUM_LASER_RANGE;
	Template.BaseDamage = default.ASSAULTRIFLE_LASER_BASEDAMAGE;
	Template.Aim = default.ASSAULTRIFLE_LASER_AIM;
	Template.CritChance = default.ASSAULTRIFLE_LASER_CRITCHANCE;
	Template.iClipSize = default.ASSAULTRIFLE_LASER_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_LASER_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.ASSAULTRIFLE_LASER_UPGRADESLOTS; 
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWAssaultRifle_LS.Archetype.WP_AssaultRifle_LS";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_MagA");
	Template.AddDefaultAttachment('Stock', "LWAttachments_LS.Meshes.SK_Laser_Stock_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_StockA");
	Template.AddDefaultAttachment('Reargrip', "LWAttachments_LS.Meshes.SK_Laser_Trigger_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_TriggerA");
	Template.AddDefaultAttachment('Foregrip', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_ForegripA");
	//Template.AddDefaultAttachment('Optic', "LWRifle_LS.Meshes.SK_LaserRifle_Optic_A", , "img:///UILibrary_LW_LaserPack.LaserRifle__OpticA"); // no default optic

	Template.CreatorTemplateName = 'AssaultRifle_LS_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AssaultRifle_MG'; // Which item this will be upgraded from

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';  

	return Template;
}

static function X2DataTemplate CreateTemplate_SMG_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SMG_LS');

	Template.WeaponCat = 'smg';
	Template.WeaponTech = 'laser_lw';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///" $ default.SMG_Laser_ImagePath; 
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 4;

	Template.Abilities.AddItem('SMG_LS_StatBonus');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_LaserSMGAbilities'.default.SMG_LASER_MOBILITY_BONUS);

	Template.RangeAccuracy = default.MIDSHORT_LASER_RANGE;
	Template.BaseDamage = default.SMG_LASER_BASEDAMAGE;
	Template.Aim = default.SMG_LASER_AIM;
	Template.CritChance = default.SMG_LASER_CRITCHANCE;
	Template.iClipSize = default.SMG_LASER_ICLIPSIZE;
	Template.iSoundRange = default.SMG_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SMG_LASER_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SMG_LASER_UPGRADESLOTS; 
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSMG_LS.Archetype.WP_SMG_LS";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_A", , "img:///UILibrary_LW_LaserPack.LaserSMG_MagA");
	Template.AddDefaultAttachment('Stock', "LWShotgun_LS.Meshes.SK_LaserShotgun_Stock_A", , "img:///UILibrary_LW_LaserPack.LaserSMG_StockA"); // switching to use the shotgun-style stock to differentiate better from rifle
	Template.AddDefaultAttachment('Reargrip', "LWAttachments_LS.Meshes.SK_Laser_Trigger_A", , "img:///UILibrary_LW_LaserPack.LaserSMG_TriggerA");
	Template.AddDefaultAttachment('Foregrip', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_A", , "img:///UILibrary_LW_LaserPack.LaserSMG_ForegripA");
	//Template.AddDefaultAttachment('Optic', "LWSMG_LS.Meshes.SK_LaserSMG_Optic_A", , "img:///UILibrary_LW_LaserPack.LaserSMG__OpticA");  // no default optic
	Template.AddDefaultAttachment('Light', "LWAttachments_LS.Meshes.SK_Laser_Flashlight", , );

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.CreatorTemplateName = 'SMG_LS_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SMG_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';  

	return Template;
}

static function X2DataTemplate CreateTemplate_Cannon_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Cannon_LS');

	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'laser_lw'; 
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///" $ default.Cannon_Laser_ImagePath;
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.MEDIUM_LASER_RANGE;
	Template.BaseDamage = default.LMG_LASER_BASEDAMAGE;
	Template.Aim = default.LMG_LASER_AIM;
	Template.CritChance = default.LMG_LASER_CRITCHANCE;
	Template.iClipSize = default.LMG_LASER_ICLIPSIZE;
	Template.iSoundRange = default.LMG_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LMG_LASER_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.LMG_LASER_UPGRADESLOTS; 
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWCannon_LS.Archetype.WP_Cannon_LS";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	Template.AddDefaultAttachment('Mag', "LWCannon_LS.Meshes.SK_LaserCannon_Mag_A", , "img:///UILibrary_LW_LaserPack.LaserCannon_MagA");
	Template.AddDefaultAttachment('Stock', "LWCannon_LS.Meshes.SK_LaserCannon_Stock_A", , "img:///UILibrary_LW_LaserPack.LaserCannon_StockA");
	Template.AddDefaultAttachment('Reargrip', "LWCannon_LS.Meshes.SK_LaserCannon_Trigger_A", , "img:///UILibrary_LW_LaserPack.LaserCannon_TriggerA");
	Template.AddDefaultAttachment('Light', "LWAttachments_LS.Meshes.SK_Laser_Flashlight", , );

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.CreatorTemplateName = 'Cannon_LS_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Cannon_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom'; 

	return Template;
}

static function X2DataTemplate CreateTemplate_Shotgun_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shotgun_LS');

	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'laser_lw'; 
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///" $ default.Shotgun_Laser_ImagePath;
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.SHORT_LASER_RANGE;
	Template.BaseDamage = default.SHOTGUN_LASER_BASEDAMAGE;
	Template.Aim = default.SHOTGUN_LASER_AIM;
	Template.CritChance = default.SHOTGUN_LASER_CRITCHANCE;
	Template.iClipSize = default.SHOTGUN_LASER_ICLIPSIZE;
	Template.iSoundRange = default.SHOTGUN_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHOTGUN_LASER_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SHOTGUN_LASER_UPGRADESLOTS; 
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWShotgun_LS.Archetype.WP_Shotgun_LS";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';
	Template.AddDefaultAttachment('Mag', "LWShotgun_LS.Meshes.SK_LaserShotgun_Mag_A", , "img:///UILibrary_LW_LaserPack.LaserShotgun_MagA");
	Template.AddDefaultAttachment('Stock', "LWShotgun_LS.Meshes.SK_LaserShotgun_Stock_A", , "img:///UILibrary_LW_LaserPack.LaserShotgun_StockA");
	Template.AddDefaultAttachment('Reargrip', "LWAttachments_LS.Meshes.SK_Laser_Trigger_A", , "img:///UILibrary_LW_LaserPack.LaserShotgun_TriggerA");
	Template.AddDefaultAttachment('Foregrip', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_A", , "img:///UILibrary_LW_LaserPack.LaserShotgun_ForegripA");
	
	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.CreatorTemplateName = 'Shotgun_LS_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Shotgun_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';  

	return Template;
}

static function X2DataTemplate CreateTemplate_SniperRifle_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SniperRifle_LS');

	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'laser_lw'; 
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///" $ default.SniperRifle_Laser_ImagePath;
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.LONG_LASER_RANGE;
	Template.BaseDamage = default.SNIPERRIFLE_LASER_BASEDAMAGE;
	Template.Aim = default.SNIPERRIFLE_LASER_AIM;
	Template.CritChance = default.SNIPERRIFLE_LASER_CRITCHANCE;
	Template.iClipSize = default.SNIPERRIFLE_LASER_ICLIPSIZE;
	Template.iSoundRange = default.SNIPERRIFLE_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SNIPERRIFLE_LASER_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SNIPERRIFLE_LASER_UPGRADESLOTS; 
	Template.iTypicalActionCost = 2;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSniperRifle_LS.Archetype.WP_SniperRifle_LS";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.AddDefaultAttachment('Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_MagA");
	Template.AddDefaultAttachment('Stock', "LWAttachments_LS.Meshes.SK_Laser_Stock_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_StockA");
	Template.AddDefaultAttachment('Reargrip', "LWAttachments_LS.Meshes.SK_Laser_Trigger_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_TriggerA");
	Template.AddDefaultAttachment('Foregrip', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_ForegripA");
	Template.AddDefaultAttachment('Optic', "LWSniperRifle_LS.Meshes.SK_LaserSniper_Optic_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_OpticA");

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.CreatorTemplateName = 'SniperRifle_LS_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SniperRifle_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom'; 

	return Template;
}
static function X2DataTemplate CreateTemplate_Sword_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sword_LS');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'laser_lw'; 
	Template.strImage = "img:///" $ default.Sword_Laser_ImagePath; 
	Template.EquipSound = "Sword_Equip_Beam";  
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSword_LS.Archetype.WP_Sword_LS";
	Template.AddDefaultAttachment('R_Back', "BeamSword.Meshes.SM_BeamSword_Sheath", false); 
	Template.Tier = 4;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.SWORD_LASER_BASEDAMAGE;
	Template.Aim = default.SWORD_LASER_AIM;
	Template.CritChance = default.SWORD_LASER_CRITCHANCE;
	Template.iSoundRange = default.SWORD_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SWORD_LASER_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType='Melee';

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0));
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.CreatorTemplateName = 'Sword_LS_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Sword_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
