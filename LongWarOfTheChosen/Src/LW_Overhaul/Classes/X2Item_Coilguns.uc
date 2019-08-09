class X2Item_Coilguns extends X2Item config (GameData_WeaponData);

var config WeaponDamageValue ASSAULTRIFLE_COIL_BASEDAMAGE;
var config WeaponDamageValue SMG_COIL_BASEDAMAGE;
var config WeaponDamageValue CANNON_COIL_BASEDAMAGE;
var config WeaponDamageValue SHOTGUN_COIL_BASEDAMAGE;
var config WeaponDamageValue SNIPERRIFLE_COIL_BASEDAMAGE;

var config array<int> SHORT_COIL_RANGE;
var config array<int> MIDSHORT_COIL_RANGE;
var config array<int> MEDIUM_COIL_RANGE;
var config array<int> LONG_COIL_RANGE;

var config int ASSAULTRIFLE_COIL_AIM;
var config int ASSAULTRIFLE_COIL_CRITCHANCE;
var config int ASSAULTRIFLE_COIL_ICLIPSIZE;
var config int ASSAULTRIFLE_COIL_ISOUNDRANGE;
var config int ASSAULTRIFLE_COIL_IENVIRONMENTDAMAGE;

var config int SMG_COIL_AIM;
var config int SMG_COIL_CRITCHANCE;
var config int SMG_COIL_ICLIPSIZE;
var config int SMG_COIL_ISOUNDRANGE;
var config int SMG_COIL_IENVIRONMENTDAMAGE;

var config int CANNON_COIL_AIM;
var config int CANNON_COIL_CRITCHANCE;
var config int CANNON_COIL_ICLIPSIZE;
var config int CANNON_COIL_ISOUNDRANGE;
var config int CANNON_COIL_IENVIRONMENTDAMAGE;

var config int SHOTGUN_COIL_AIM;
var config int SHOTGUN_COIL_CRITCHANCE;
var config int SHOTGUN_COIL_ICLIPSIZE;
var config int SHOTGUN_COIL_ISOUNDRANGE;
var config int SHOTGUN_COIL_IENVIRONMENTDAMAGE;

var config int SNIPERRIFLE_COIL_AIM;
var config int SNIPERRIFLE_COIL_CRITCHANCE;
var config int SNIPERRIFLE_COIL_ICLIPSIZE;
var config int SNIPERRIFLE_COIL_ISOUNDRANGE;
var config int SNIPERRIFLE_COIL_IENVIRONMENTDAMAGE;

var config string AssaultRifle_Coil_ImagePath;
var config string SMG_Coil_ImagePath;
var config string Cannon_Coil_ImagePath;
var config string Shotgun_Coil_ImagePath;
var config string SniperRifle_Coil_ImagePath;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Weapons;
	local X2ItemTemplateManager ItemTemplateManager;

	`LWTrace("  >> X2Item_Coilguns.CreateTemplates()");
	
	Weapons.AddItem(CreateAssaultRifle_Coil_Template());
	Weapons.AddItem(CreateSMG_Coil_Template());
	Weapons.AddITem(CreateCannon_Coil_Template());
	Weapons.AddItem(CreateShotgun_Coil_Template());
	Weapons.AddItem(CreateSniperRifle_Coil_Template());

	return Weapons;
}

static function X2DataTemplate CreateAssaultRifle_Coil_Template()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AssaultRifle_CG');

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'coilgun_lw';
	Template.ItemCat = 'weapon';
	Template.strImage ="img:///" $ default.AssaultRifle_Coil_ImagePath;
	Template.WeaponPanelImage = "";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.MEDIUM_COIL_RANGE;
	Template.BaseDamage = default.ASSAULTRIFLE_COIL_BASEDAMAGE;
	Template.Aim = default.ASSAULTRIFLE_COIL_AIM;
	Template.CritChance = default.ASSAULTRIFLE_COIL_CRITCHANCE;
	Template.iClipSize = default.ASSAULTRIFLE_COIL_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.GameArchetype = "LWAssaultRifle_CG.Archetypes.WP_AssaultRifle_CG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_MagA");
	Template.AddDefaultAttachment('Stock', "LWAccessories_CG.Meshes.LW_Coil_StockA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_StockA");
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_ReargripA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateSMG_Coil_Template()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SMG_CG');

	Template.WeaponCat = 'smg';
	Template.WeaponTech = 'coilgun_lw';
	Template.ItemCat = 'weapon';
	Template.strImage ="img:///" $ default.SMG_Coil_ImagePath;
	Template.WeaponPanelImage = "";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;
	Template.Abilities.Additem('SMG_CG_StatBonus');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_SMGAbilities'.default.SMG_COIL_MOBILITY_BONUS);

	Template.RangeAccuracy = default.MIDSHORT_COIL_RANGE;
	Template.BaseDamage = default.SMG_COIL_BASEDAMAGE;
	Template.Aim = default.SMG_COIL_AIM;
	Template.CritChance = default.SMG_COIL_CRITCHANCE;
	Template.iClipSize = default.SMG_COIL_ICLIPSIZE;
	Template.iSoundRange = default.SMG_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SMG_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.GameArchetype = "LWSMG_CG.Archetypes.WP_SMG_CG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagA");
	Template.AddDefaultAttachment('Stock', "LWAccessories_CG.Meshes.LW_Coil_StockA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_StockA");
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_ReargripA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateCannon_Coil_Template()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Cannon_CG');

	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'coilgun_lw';
	Template.ItemCat = 'weapon';
	Template.strImage ="img:///" $ default.Cannon_Coil_ImagePath;
	Template.WeaponPanelImage = "";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.MEDIUM_COIL_RANGE;
	Template.BaseDamage = default.CANNON_COIL_BASEDAMAGE;
	Template.Aim = default.CANNON_COIL_AIM;
	Template.CritChance = default.CANNON_COIL_CRITCHANCE;
	Template.iClipSize = default.CANNON_COIL_ICLIPSIZE;
	Template.iSoundRange = default.CANNON_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CANNON_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.GameArchetype = "LWCannon_CG.Archetypes.WP_Cannon_CG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	Template.AddDefaultAttachment('Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagA");
	Template.AddDefaultAttachment('Stock', "LWCannon_CG.Meshes.LW_CoilCannon_StockA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_StockA");
	Template.AddDefaultAttachment('StockSupport', "LWCannon_CG.Meshes.LW_CoilCannon_StockSupportA");
	Template.AddDefaultAttachment('Reargrip', "LWCannon_CG.Meshes.LW_CoilCannon_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_ReargripA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateShotgun_Coil_Template()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shotgun_CG');

	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'coilgun_lw';
	Template.ItemCat = 'weapon';
	Template.strImage ="img:///" $ default.Shotgun_Coil_ImagePath;
	Template.WeaponPanelImage = "";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.SHORT_COIL_RANGE;
	Template.BaseDamage = default.SHOTGUN_COIL_BASEDAMAGE;
	Template.Aim = default.SHOTGUN_COIL_AIM;
	Template.CritChance = default.SHOTGUN_COIL_CRITCHANCE;
	Template.iClipSize = default.SHOTGUN_COIL_ICLIPSIZE;
	Template.iSoundRange = default.SHOTGUN_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHOTGUN_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.GameArchetype = "LWShotgun_CG.Archetypes.WP_Shotgun_CG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';
	Template.AddDefaultAttachment('Stock', "LWAccessories_CG.Meshes.LW_Coil_StockA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_StockA");
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_ReargripA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateSniperRifle_Coil_Template()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SniperRifle_CG');

	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'coilgun_lw';
	Template.ItemCat = 'weapon';
	Template.strImage ="img:///" $ default.SniperRifle_Coil_ImagePath;
	Template.WeaponPanelImage = "";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;
	Template.iTypicalActionCost = 2;

	Template.RangeAccuracy = default.LONG_COIL_RANGE;
	Template.BaseDamage = default.SNIPERRIFLE_COIL_BASEDAMAGE;
	Template.Aim = default.SNIPERRIFLE_COIL_AIM;
	Template.CritChance = default.SNIPERRIFLE_COIL_CRITCHANCE;
	Template.iClipSize = default.SNIPERRIFLE_COIL_ICLIPSIZE;
	Template.iSoundRange = default.SNIPERRIFLE_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SNIPERRIFLE_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.GameArchetype = "LWSniperRifle_CG.Archetypes.WP_SniperRifle_CG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_MagA");
	Template.AddDefaultAttachment('Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_OpticA");
	Template.AddDefaultAttachment('Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_StockB");
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_ReargripA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

