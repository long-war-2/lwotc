//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_LWSMGPack.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Initializes Laser Weapon mod settings on campaign start or when loading campaign without mod previously active
//--------------------------------------------------------------------------------------- 

//DEPRECATED FOR OVERHAUL

class X2DownloadableContentInfo_LWLaserPack extends X2DownloadableContentInfo;	

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	UpdateWeaponAttachments();
}


// ******** HANDLE UPDATING WEAPON ATTACHMENTS ************* //
// This provides the artwork/assets for weapon attachments for SMGs
static function UpdateWeaponAttachments()
{
	local X2ItemTemplateManager ItemTemplateManager;

	//get access to item template manager to update existing upgrades
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if (ItemTemplateManager == none) {
		`Redscreen("LW LaserWeapons : failed to retrieve ItemTemplateManager to configure upgrades");
		return;
	}

	//add Laser Weapons to the DefaultUpgrades Templates so that upgrades work with new weapons
	//this doesn't make the upgrade available, it merely configures the art
	AddCritUpgrade(ItemTemplateManager, 'CritUpgrade_Bsc');
	AddCritUpgrade(ItemTemplateManager, 'CritUpgrade_Adv');
	AddCritUpgrade(ItemTemplateManager, 'CritUpgrade_Sup');

	AddAimBonusUpgrade(ItemTemplateManager, 'AimUpgrade_Bsc');
	AddAimBonusUpgrade(ItemTemplateManager, 'AimUpgrade_Adv');
	AddAimBonusUpgrade(ItemTemplateManager, 'AimUpgrade_Sup');

	AddClipSizeBonusUpgrade(ItemTemplateManager, 'ClipSizeUpgrade_Bsc');
	AddClipSizeBonusUpgrade(ItemTemplateManager, 'ClipSizeUpgrade_Adv');
	AddClipSizeBonusUpgrade(ItemTemplateManager, 'ClipSizeUpgrade_Sup');

	AddFreeFireBonusUpgrade(ItemTemplateManager, 'FreeFireUpgrade_Bsc');
	AddFreeFireBonusUpgrade(ItemTemplateManager, 'FreeFireUpgrade_Adv');
	AddFreeFireBonusUpgrade(ItemTemplateManager, 'FreeFireUpgrade_Sup');

	AddReloadUpgrade(ItemTemplateManager, 'ReloadUpgrade_Bsc');
	AddReloadUpgrade(ItemTemplateManager, 'ReloadUpgrade_Adv');
	AddReloadUpgrade(ItemTemplateManager, 'ReloadUpgrade_Sup');

	AddMissDamageUpgrade(ItemTemplateManager, 'MissDamageUpgrade_Bsc');
	AddMissDamageUpgrade(ItemTemplateManager, 'MissDamageUpgrade_Adv');
	AddMissDamageUpgrade(ItemTemplateManager, 'MissDamageUpgrade_Sup');

	AddFreeKillUpgrade(ItemTemplateManager, 'FreeKillUpgrade_Bsc');
	AddFreeKillUpgrade(ItemTemplateManager, 'FreeKillUpgrade_Adv');
	AddFreeKillUpgrade(ItemTemplateManager, 'FreeKillUpgrade_Sup');
}

static function AddCritUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("LW SMGPack : Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWAssaultRifle_LS.Meshes.SK_LaserRifle_Optic_C", "", 'AssaultRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserRifle_OpticC", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SMG
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_LS.Meshes.SK_LaserSMG_Optic_C", "", 'SMG_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_OpticC", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Shotgun
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "LWShotgun_LS.Meshes.SK_LaserShotgun_Optic_B", "", 'Shotgun_LS', , "img:///UILibrary_LW_LaserPack.LaserShotgun_OpticC", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	
	// Sniper Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "LWSniperRifle_LS.Meshes.SK_LaserSniper_Optic_C", "", 'SniperRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserSniper_OpticC", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Cannon
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "LWCannon_LS.Meshes.SK_LaserCannon_Optic_B", "", 'Cannon_LS', , "img:///UILibrary_LW_LaserPack.LaserCannon_OpticB", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

}

static function AddAimBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("LW SMGPack : Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWAssaultRifle_LS.Meshes.SK_LaserRifle_Optic_B", "", 'AssaultRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserRifle_OpticB", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SMG
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_LS.Meshes.SK_LaserSMG_Optic_B", "", 'SMG_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_OpticB", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Shotgun
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "LWShotgun_LS.Meshes.SK_LaserShotgun_Optic_A", "", 'Shotgun_LS', , "img:///UILibrary_LW_LaserPack.LaserShotgun_OpticB", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "LWSniperRifle_LS.Meshes.SK_LaserSniper_Optic_B", "", 'SniperRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserSniper_OpticB", "img:///UILibrary_LW_LaserPack.Inv_LaserSniper_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	
	// Cannon
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "LWCannon_LS.Meshes.SK_LaserCannon_Optic_A", "", 'Cannon_LS', , "img:///UILibrary_LW_LaserPack.LaserCannon_OpticA", "img:///UILibrary_LW_LaserPack.Inv_LaserCannon_OpticA", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
}

static function AddClipSizeBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("LW SMGPack : Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_B", "", 'AssaultRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserRifle_MagB", "img:///UILibrary_LW_LaserPack.Inv_Laser_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	//SMG
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_B", "", 'SMG_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_MagB", "img:///UILibrary_LW_LaserPack.Inv_Laser_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Shotgun
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_LS.Meshes.SK_LaserShotgun_Mag_B", "", 'Shotgun_LS', , "img:///UILibrary_LW_LaserPack.LaserShotgun_MagB", "img:///UILibrary_LW_LaserPack.Inv_LaserShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_B", "", 'SniperRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserSniper_MagB", "img:///UILibrary_LW_LaserPack.Inv_Laser_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Cannon
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_LS.Meshes.SK_LaserCannon_Mag_B", "", 'Cannon_LS', , "img:///UILibrary_LW_LaserPack.LaserCannon_MagB", "img:///UILibrary_LW_LaserPack.Inv_LaserCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
}

static function AddFreeFireBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("LW SMGPack : Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Trigger_B", "", 'AssaultRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserRifle_TriggerB", "img:///UILibrary_LW_LaserPack.Inv_Laser_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	
	//SMG
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Trigger_B", "", 'SMG_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_TriggerB", "img:///UILibrary_LW_LaserPack.Inv_Laser_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Shotgun
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWAttachments_LS.Meshes.SK_Laser_Trigger_B", "", 'Shotgun_LS', , "img:///UILibrary_LW_LaserPack.LaserShotgun_TriggerB", "img:///UILibrary_LW_LaserPack.Inv_Laser_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	
	// Sniper
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWAttachments_LS.Meshes.SK_Laser_Trigger_B", "", 'SniperRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserSniper_TriggerB", "img:///UILibrary_LW_LaserPack.Inv_Laser_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Cannon
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_LS.Meshes.SK_LaserCannon_Trigger_B", "", 'Cannon_LS', , "img:///UILibrary_LW_LaserPack.LaserCannon_TriggerB", "img:///UILibrary_LW_LaserPack.Inv_LaserCannon_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
} 

static function AddReloadUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("LW SMGPack : Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_B", "", 'AssaultRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserRifle_ForegripB", "img:///UILibrary_LW_LaserPack.Inv_Laser_ForegripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	//SMG
	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_B", "", 'SMG_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_ForegripB", "img:///UILibrary_LW_LaserPack.Inv_Laser_ForegripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Shotgun
	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_B", "", 'Shotgun_LS', , "img:///UILibrary_LW_LaserPack.LaserShotgun_ForegripB", "img:///UILibrary_LW_LaserPack.Inv_Laser_ForegripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	
	// Sniper
	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_B", "", 'SniperRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserSniper_ForegripB", "img:///UILibrary_LW_LaserPack.Inv_Laser_ForegripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Cannon
	Template.AddUpgradeAttachment('Reload', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_LS.Meshes.SK_LaserCannon_Reload", "", 'Cannon_LS', , "img:///UILibrary_LW_LaserPack.LaserCannon_Reload", "img:///UILibrary_LW_LaserPack.Inv_LaserCannon_Reload", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
}

static function AddMissDamageUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("LW SMGPack : Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAttachments_LS.Meshes.SK_Laser_Stock_B", "", 'AssaultRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserRifle_StockB", "img:///UILibrary_LW_LaserPack.Inv_LaserRifle_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "LWAttachments_LS.Meshes.SK_Laser_Crossbar", "", 'AssaultRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserRifle_CrossBar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);

	//SMG -- switching to shared Shotgun stock to better differentiate profile compared to rifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWShotgun_LS.Meshes.SK_LaserShotgun_Stock_B", "", 'SMG_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_StockB", "img:///UILibrary_LW_LaserPack.Inv_LaserShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "LWAttachments_LS.Meshes.SK_Laser_Crossbar", "", 'SMG_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_CrossBar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);

	// Shotgun
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWShotgun_LS.Meshes.SK_LaserShotgun_Stock_B", "", 'Shotgun_LS', , "img:///UILibrary_LW_LaserPack.LaserShotgun_StockB", "img:///UILibrary_LW_LaserPack.Inv_LaserShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "LWAttachments_LS.Meshes.SK_Laser_Crossbar", "", 'Shotgun_LS', , "img:///UILibrary_LW_LaserPack.LaserShotgun_CrossBar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);

	// Sniper Rifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "LWAttachments_LS.Meshes.SK_Laser_Stock_B", "", 'SniperRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserSniper_StockB", "img:///UILibrary_LW_LaserPack.Inv_LaserRifle_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "LWAttachments_LS.Meshes.SK_Laser_Crossbar", "", 'SniperRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserSniper_CrossBar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);

	// Cannon
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "LWCannon_LS.Meshes.SK_LaserCannon_Stock_B", "", 'Cannon_LS', , "img:///UILibrary_LW_LaserPack.LaserCannon_StockB", "img:///UILibrary_LW_LaserPack.Inv_LaserCannon_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
} 

static function AddFreeKillUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("LW SMGPack : Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWAssaultRifle_LS.Meshes.SK_LaserRifle_Suppressor", "", 'AssaultRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserRifle_Suppressor", "img:///UILibrary_LW_LaserPack.Inv_LaserRifle_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	//SMG
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWSMG_LS.Meshes.SK_LaserSMG_Suppressor", "", 'SMG_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_Suppressor", "img:///UILibrary_LW_LaserPack.Inv_LaserSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Shotgun
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "LWShotgun_LS.Meshes.SK_LaserShotgun_Suppressor", "", 'Shotgun_LS', , "img:///UILibrary_LW_LaserPack.LaserShotgun_Suppressor", "img:///UILibrary_LW_LaserPack.Inv_LaserShotgun_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "LWSniperRifle_LS.Meshes.SK_LaserSniper_Suppressor", "", 'SniperRifle_LS', , "img:///UILibrary_LW_LaserPack.LaserSniper_Suppressor", "img:///UILibrary_LW_LaserPack.Inv_LaserSniper_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	
	// Cannon
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Cannon_Suppressor', "LWCannon_LS.Meshes.SK_LaserCannon_Suppressor", "", 'Cannon_LS', , "img:///UILibrary_LW_LaserPack.LaserCannon_Suppressor", "img:///UILibrary_LW_LaserPack.Inv_LaserCannon_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
} 
