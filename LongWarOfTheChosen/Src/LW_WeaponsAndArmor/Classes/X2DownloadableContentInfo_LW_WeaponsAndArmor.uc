//---------------------------------------------------------------------------------------
//  FILE:   X2DownloadableContentInfo_LW_WeaponsAndArmor.uc                            
//
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_LW_WeaponsAndArmor extends X2DownloadableContentInfo config(GameData);

var config array<name> TEMPLAR_SHIELDS;
var config array<name> TEMPLAR_GAUNTLETS_FOR_ONE_HANDED_USE;
var config array<name> AUTOPISTOL_ANIMS_WEAPONCATS_EXCLUDED;


/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{

}
static event OnPostTemplatesCreated()
{
	UpdateWeaponAttachmentsForGuns();
}


// ******** HANDLE UPDATING WEAPON ATTACHMENTS ************* //
// This provides the artwork/assets for weapon attachments for SMGs
static function UpdateWeaponAttachmentsForGuns()
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
	//SMG
	Template.AddUpgradeAttachment('Scope', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_LaserSight", "", 'Bullpup_LS', , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-laser", "img:///IRI_Bullpup_LS_LW.UI.Laser", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BemSMG.Meshes.SM_HOR_Bem_SMG_OpticB", "", 'Bullpup_CG', , "img:///IRI_Bullpup_CG_LW.UI.coil_bullop_laser", "img:///UILibrary_XPACK_StrategyImages.BeamSMG_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	
	Template.AddUpgradeAttachment('LaserSight', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "IRI_VektorRifle_LS_LW.Meshes.SM_VektorRifle_LS_LaserSight", "", 'Vektor_LS', , "img:///IRI_VektorRifle_LS_LW.UI.screen-laser-pointer", "img:///IRI_Bullpup_LS_LW.UI.Screen-LaserSight", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('LaserSight', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "IRI_VektorRifle_CG_LW.Meshes.SM_Vektor_CG_LaserSight", "", 'Vektor_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_OpticB", "img:///IRI_VektorRifle_CG_LW.UI.Scope", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

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

	//SMG
	Template.AddUpgradeAttachment('Scope', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_Scope", "", 'Bullpup_LS', , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-scopeB", "img:///IRI_Bullpup_LS_LW.UI.Scope", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BemSMG.Meshes.SM_HOR_Bem_SMG_OpticC", "", 'Bullpup_CG', , "img:///IRI_Bullpup_CG_LW.UI.coil_bullop_scope", "img:///UILibrary_XPACK_StrategyImages.BeamSMG_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "IRI_VektorRifle_LS_LW.Meshes.SM_VektorRifle_LS_ScopeB", "", 'Vektor_LS', , "img:///IRI_VektorRifle_LS_LW.UI.Laser-scopeB", "img:///UILibrary_LW_LaserPack.Inv_LaserSniper_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "IRI_VektorRifle_CG_LW.Meshes.SM_Vektor_CG_Scope", "", 'Vektor_CG', ,  "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_OpticA_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

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
	//SMG
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_MagB", "", 'Bullpup_LS', , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-magazineB", "img:///IRI_Bullpup_LS_LW.UI.Magazine", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagB", "", 'Bullpup_CG', , "img:///IRI_Bullpup_CG_LW.UI.coil_bullop_magB", "img:///IRI_Bullpup_CG_LW.UI.Inv_Bullpup_CG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "IRI_VektorRifle_LS_LW.Meshes.SM_VektorRifle_LS_MagB", "", 'Vektor_LS', , "img:///IRI_VektorRifle_LS_LW.UI.Laser-magazineB", "img:///UILibrary_LW_LaserPack.Inv_Laser_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "IRI_VektorRifle_CG_LW.Meshes.SM_Vektor_CG_ExtendedMag", "", 'Vektor_CG', ,  "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_MagB", "img:///UILibrary_LW_Coilguns.Inv_CoilRifleSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

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
	
	//SMG
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_ReargripB", "", 'Bullpup_LS', , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-triggerB", "img:///IRI_Bullpup_LS_LW.UI.Reargrip", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAttachments.Meshes.SM_MagTriggerB", "", 'Bullpup_CG', , "img:///IRI_Bullpup_CG_LW.UI.coil_bullop_triggerB", "img:///IRI_Bullpup_CG_LW.UI.Bullpup_CG_TriggerB_Inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	Template.AddUpgradeAttachment('Trigger', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerB", "", 'Vektor_LS', , "img:///IRI_VektorRifle_LS_LW.UI.Laser-triggerB", "img:///UILibrary_XPACK_StrategyImages.MagVektor_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	Template.AddUpgradeAttachment('Trigger', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerB", "", 'Vektor_CG', , "", "img:///UILibrary_XPACK_StrategyImages.ConvVektor_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

} 

static function AddReloadUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none) 
	{
		`Redscreen("LW BullpupPack : Failed to find upgrade template " $ string(TemplateName));
		return;
	}

	//Bullpup
	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_ForegripB", "", 'Bullpup_LS', , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-foregripB", "img:///IRI_Bullpup_LS_LW.UI.Foregrip", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagC", "", 'Bullpup_CG', , "img:///IRI_Bullpup_CG_LW.UI.coil_bullop_magC", "img:///IRI_Bullpup_CG_LW.UI.Inv_Bullpup_CG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagD", "", 'Bullpup_CG', , "img:///IRI_Bullpup_CG_LW.UI.coil_bullop_magD", "img:///IRI_Bullpup_CG_LW.UI.Inv_Bullpup_CG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Vektor Rifle
	Template.AddUpgradeAttachment('AutoLoader', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "IRI_VektorRifle_LS_LW.Meshes.SM_VektorRifle_LS_Autoloader", "", 'Vektor_LS', , "img:///IRI_VektorRifle_LS_LW.UI.Laser-autoloader", "img:///IRI_VektorRifle_LS_LW.UI.screen-autoloader", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "IRI_VektorRifle_CG_LW.Meshes.SM_Vektor_CG_MagA_AL", "", 'Vektor_CG', ,  "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_MagC", "img:///UILibrary_LW_Coilguns.Inv_CoilSniperRifle_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "IRI_VektorRifle_CG_LW.Meshes.SM_Vektor_CG_ExtendedMag_AL", "", 'Vektor_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_MagD", "img:///UILibrary_LW_Coilguns.Inv_CoilRifleSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
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

	//SMG -- switching to shared Shotgun stock to better differentiate profile compared to rifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_StockB", "", 'Bullpup_LS', , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-stockB", "img:///IRI_Bullpup_LS_LW.UI.Stock", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'Bullpup_CG', , "img:///IRI_Bullpup_CG_LW.UI.coil_bullop_stock", "img:///IRI_Bullpup_CG_LW.UI.Inv_Bullpup_CG__StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_StockB", "", 'Vektor_LS', , "img:///IRI_VektorRifle_LS_LW.UI.Laser-stockB", "img:///UILibrary_XPACK_StrategyImages.MagVektor_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_StockB", "", 'Vektor_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilSMG_StockB", "img:///UILibrary_XPACK_StrategyImages.BeamVektor_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

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


	//SMG
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_Suppressor", "", 'Bullpup_LS', , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-suppressor", "img:///IRI_Bullpup_LS_LW.UI.Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "LWSniperRifle_CG.Meshes.LW_CoilSniper_Suppressor", "", 'Bullpup_CG', , "img:///IRI_Bullpup_CG_LW.UI.coil_bullop_suppressor", "img:///IRI_Bullpup_CG_LW.UI.Inv_Bullpup_CG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "IRI_VektorRifle_LS_LW.Meshes.SM_VektorRifle_LS_Suppressor", "", 'Vektor_LS', , "img:///IRI_VektorRifle_LS_LW.UI.Laser-suppressor", "img:///IRI_VektorRifle_LS_LW.UI.screen-suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "IRI_VektorRifle_CG_LW.Meshes.SM_Vektor_CG_SuppressorB", "", 'Vektor_CG', , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_Suppressor", "img:///UILibrary_LW_Coilguns.Inv_CoilSniperRifle_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

} 

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);
	switch (Type)
	{
		case 'KnifeJugglerBonusDamage':
			OutString = string(class'X2Ability_ThrowingKnifeAbilitySet'.default.KNIFE_JUGGLER_BONUS_DAMAGE);
			return true;
		case 'KnifeJugglerExtraAmmo':
			OutString = string(class'X2Ability_ThrowingKnifeAbilitySet'.default.KNIFE_JUGGLER_EXTRA_AMMO);
			return true;
		case 'THROWING_KNIFE_CV_BLEED_CHANCE':
			OutString = string(class'X2Item_SecondaryThrowingKnives'.default.THROWING_KNIFE_CV_BLEED_CHANCE);
			return true;
		case 'THROWING_KNIFE_CV_BLEED_DURATION':
			OutString = string(class'X2Item_SecondaryThrowingKnives'.default.THROWING_KNIFE_CV_BLEED_DURATION);
			return true;
		case 'THROWING_KNIFE_CV_BLEED_DAMAGE':
			OutString = string(class'X2Item_SecondaryThrowingKnives'.default.THROWING_KNIFE_CV_BLEED_DAMAGE);
			return true;
		case 'THROWING_KNIFE_MG_BLEED_CHANCE':
			OutString = string(class'X2Item_SecondaryThrowingKnives'.default.THROWING_KNIFE_MG_BLEED_CHANCE);
			return true;
		case 'THROWING_KNIFE_MG_BLEED_DURATION':
			OutString = string(class'X2Item_SecondaryThrowingKnives'.default.THROWING_KNIFE_MG_BLEED_DURATION);
			return true;
		case 'THROWING_KNIFE_MG_BLEED_DAMAGE':
			OutString = string(class'X2Item_SecondaryThrowingKnives'.default.THROWING_KNIFE_MG_BLEED_DAMAGE);
			return true;
		case 'THROWING_KNIFE_BM_BLEED_CHANCE':
			OutString = string(class'X2Item_SecondaryThrowingKnives'.default.THROWING_KNIFE_BM_BLEED_CHANCE);
			return true;
		case 'THROWING_KNIFE_BM_BLEED_DURATION':
			OutString = string(class'X2Item_SecondaryThrowingKnives'.default.THROWING_KNIFE_BM_BLEED_DURATION);
			return true;
		case 'THROWING_KNIFE_BM_BLEED_DAMAGE':
			OutString = string(class'X2Item_SecondaryThrowingKnives'.default.THROWING_KNIFE_BM_BLEED_DAMAGE);
			return true;
		case 'KNIFE_ENCOUNTERS_MAX_TILES':
			OutString = string(class'X2Ability_ThrowingKnifeAbilitySet'.default.KNIFE_ENCOUNTERS_MAX_TILES);
			return true;
		case 'KNIFE_ENCOUNTERS_BANISHER_MAX_TILES':
			OutString = string(class'X2Ability_ThrowingKnifeAbilitySet'.default.KNIFE_ENCOUNTERS_BANISHER_MAX_TILES);
			return true;
	}

	return false;
}


// static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
// {
// 	local name Item;
// 	local X2WeaponTemplate PrimaryWeaponTemplate, SecondaryWeaponTemplate;
// 	local string AnimSetToLoad;

// 	PrimaryWeaponTemplate = X2WeaponTemplate(UnitState.GetPrimaryWeapon().GetMyTemplate());
// 	SecondaryWeaponTemplate = X2WeaponTemplate( UnitState.GetSecondaryWeapon().GetMyTemplate());

// 	if (!UnitState.IsSoldier()) return;

// 	if (UnitState.GetMyTemplateName() == 'TemplarSoldier')
// 	{
// 		if (UnitState.GetItemInSlot(eInvSlot_Pistol) != none)
// 		{
// 			if (UnitState.GetItemInSlot(eInvSlot_Pistol).GetWeaponCategory() == 'sidearm')
// 			{
// 				`LWTrace("[LW_WeaponsAndArmor] Adding animset 'AS_TemplarAutoPistol'");
// 				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Templar_ANIM.AS_TemplarAutoPistol")));
// 			}
// 			else if (UnitState.GetItemInSlot(eInvSlot_Pistol).GetWeaponCategory() == 'pistol')
// 			{
// 				`LWTrace("[LW_WeaponsAndArmor] Adding animset 'AS_Pistol'");
// 				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_ANIM.AS_Pistol")));
// 			}
// 		}
// 	}

// }

// Tedster - re-add Templar animations update

static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	local name Item;
	local X2WeaponTemplate PrimaryWeaponTemplate, SecondaryWeaponTemplate;
	local string AnimSetToLoad;

	PrimaryWeaponTemplate = X2WeaponTemplate(UnitState.GetPrimaryWeapon().GetMyTemplate());
	SecondaryWeaponTemplate = X2WeaponTemplate( UnitState.GetSecondaryWeapon().GetMyTemplate());

	if (!UnitState.IsSoldier()) return;

	foreach default.TEMPLAR_GAUNTLETS_FOR_ONE_HANDED_USE(Item)
	{
		if (UnitState.HasItemOfTemplateType(Item))
		{
			CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("OneHandedGauntlet_LW.Anims.AS_RightHandedTemplar")));
			if (UnitState.kAppearance.iGender == eGender_Female)
			{
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("OneHandedGauntlet_LW.Anims.AS_RightHandedTemplar_F")));
			}

			break;
		}
	}
	if (SecondaryWeaponTemplate.WeaponCat == 'templarshield')
	{
		CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("WoTC_Shield_Animations_LW.Anims.AS_Shield_Medkit")));
		CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("WoTC_Shield_Animations_LW.Anims.AS_Shield_Grenade")));

		switch (PrimaryWeaponTemplate.WeaponCat)
		{
			case 'rifle':
				AnimSetToLoad = "AnimSet'WoTC_Shield_Animations_LW.Anims.AS_Shield_AssaultRifle'";
				break;
			case 'sidearm':
				AnimSetToLoad = "AnimSet'WoTC_Shield_Animations_LW.Anims.AS_Shield_AutoPistol'";
				break;
			case 'pistol': 
			case 'sawedoff':
				AnimSetToLoad = "AnimSet'WoTC_Shield_Animations_LW.Anims.AS_Shield_Pistol'";
				break;
			case 'shotgun':
				AnimSetToLoad = "AnimSet'WoTC_Shield_Animations_LW.Anims.AS_Shield_Shotgun'";
				break;
			case 'bullpup':
				AnimSetToLoad = "AnimSet'WoTC_Shield_Animations_LW.Anims.AS_Shield_SMG'";
				break;
			case 'sword':
			case 'combatknife':
				AnimSetToLoad = "AnimSet'WoTC_Shield_Animations_LW.Anims.AS_Shield_Sword'";
				break;
		}
		
		if (AnimSetToLoad != "")
		{
			`LWTrace("[LW_WeaponsAndArmor] Adding animset '" $ AnimSetToLoad $"' for primary weapon type '" $ PrimaryWeaponTemplate.WeaponCat $ "'");
			CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype(AnimSetToLoad)));
		}
		if (PrimaryWeaponTemplate.WeaponCat == 'sword' || PrimaryWeaponTemplate.WeaponCat == 'gauntlet')
		{
			`LWTrace("[LW_WeaponsAndArmor] Adding animset 'AS_Shield_Melee' for primary weapon type '" $ PrimaryWeaponTemplate.WeaponCat $ "'");
			CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("WoTC_Shield_Animations_LW.Anims.AS_Shield_Melee")));
		}
		else
		{
			`LWTrace("[LW_WeaponsAndArmor] Adding animset 'AS_Shield' for primary weapon type '" $ PrimaryWeaponTemplate.WeaponCat $ "'");
			CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("WoTC_Shield_Animations_LW.Anims.AS_Shield")));
		}

		if (PrimaryWeaponTemplate.WeaponCat != 'gauntlet')
		{
			`LWTrace("[LW_WeaponsAndArmor] Adding animset 'AS_Shield_Armory' for primary weapon type '" $ PrimaryWeaponTemplate.WeaponCat $ "'");
			CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("WoTC_Shield_Animations_LW.Anims.AS_Shield_Armory")));
		}
	}

	if (UnitState.GetMyTemplateName() == 'TemplarSoldier')
	{
		if (UnitState.GetItemInSlot(eInvSlot_Pistol) != none)
		{
			if (UnitState.GetItemInSlot(eInvSlot_Pistol).GetWeaponCategory() == 'sidearm')
			{
				`LWTrace("[LW_WeaponsAndArmor] Adding animset 'AS_TemplarAutoPistol'");
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Templar_ANIM.AS_TemplarAutoPistol")));
			}
			else if (UnitState.GetItemInSlot(eInvSlot_Pistol).GetWeaponCategory() == 'pistol')
			{
				`LWTrace("[LW_WeaponsAndArmor] Adding animset 'AS_Pistol'");
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_ANIM.AS_Pistol")));
			}
		}
	}

}


static function WeaponInitialized(XGWeapon WeaponArchetype, XComWeapon Weapon, optional XComGameState_Item ItemState=none)
{
    local X2WeaponTemplate WeaponTemplate;
    local XComGameState_Unit UnitState;
    local XComGameState_Item InternalWeaponState;

		InternalWeaponState = ItemState;
		if (InternalWeaponState == none)
		{
			InternalWeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponArchetype.ObjectID));
		}
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(InternalWeaponState.OwnerStateObject.ObjectID));
		WeaponTemplate = X2WeaponTemplate(InternalWeaponState.GetMyTemplate());

		//Weapon.CustomUnitPawnAnimsets.Length = 0;
		//Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("WoTC_Shield_Animations_LW.Anims.AS_Shield_AutoPistol")));

		
		if(WeaponTemplate.WeaponCat == 'Sidearm')
		{
			if(!PrimaryWeaponExcluded(UnitState))
			{
				Weapon.CustomUnitPawnAnimsets.Length = 0;
				Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("AutopistolRebalance_LW.Anims.AS_Autopistol")));
			}

			Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("AutopistolRebalance_LW.Anims.AS_Autopistol_FanFire")));
		}
			
}

//For LWOTC I could just make this not work on templars but let's not potentially screw up any more RPGO compatibility
static function bool PrimaryWeaponExcluded(XComGameState_Unit UnitState)
{
	//	this convoluted function takes a UnitState, then fetches the Weapon Template for whatever the soldier has equipped in their primary weapon slot.
	//	it takes the weapon category of that weapon template, and looks for it in the configuration array
	//	it returns true if it finds it, or false if it doesn't
	//	I could declare a bunch of local values to store intermediate steps but meh
	//	blame Musashi for this kind of style =\
	return (default.AUTOPISTOL_ANIMS_WEAPONCATS_EXCLUDED.Find(X2WeaponTemplate(UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon).GetMyTemplate()).WeaponCat) != INDEX_NONE);
}
