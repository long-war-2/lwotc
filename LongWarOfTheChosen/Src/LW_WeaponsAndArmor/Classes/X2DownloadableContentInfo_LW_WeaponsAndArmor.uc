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

var config array<name> TEMPLAR_GAUNTLETS_FOR_ONE_HANDED_USE;
var config array<name> TEMPLAR_SHIELDS;
var config array<name> AUTOPISTOL_ANIMS_WEAPONCATS_EXCLUDED;

var localized string CannotEquipCanisterLabel, CannotEquipWithCanisterLabel;

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
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_LS.Meshes.SK_LaserSMG_Optic_C", "", 'Bullpup_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_OpticC", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticB", "", 'Bullpup_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSniperRifle_LS.Meshes.SK_LaserSniper_Optic_C", "", 'vektor_LS', , /*"img:///UILibrary*/"_BRPack.Attach.BR_LS_OpticB", /*"img:///UILibrary*/"_LW_LaserPack.Inv_Laser_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticB", "", 'vektor_CG', , /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.CoilSniperRifle_OpticB", /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

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
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_LS.Meshes.SK_LaserSMG_Optic_B", "", 'Bullpup_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_OpticB", "img:///UILibrary_LW_LaserPack.Inv_Laser_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticC", "", 'Bullpup_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSniperRifle_LS.Meshes.SK_LaserSniper_Optic_B", "", 'Vektor_LS', , /*"img:///UILibrary*/"_BRPack.Attach.BR_LS_OpticC", /*"img:///UILibrary*/"_LW_LaserPack.Inv_LaserSniper_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticC", "", 'Vektor_CG', ,  /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.CoilSniperRifle_OpticC", /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

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
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_B", "", 'Bullpup_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_MagB", "img:///UILibrary_LW_LaserPack.Inv_Laser_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagB", "", 'Bullpup_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_B", "", 'Vektor_LS', , /*"img:///UILibrary*/"_LW_LaserPack.LaserRifle_MagB", /*"img:///UILibrary*/"_LW_LaserPack.Inv_Laser_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagB", "", 'Vektor_CG', ,  /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.CoilSniperRifle_MagB", /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

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
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Trigger_B", "", 'Bullpup_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_TriggerB", "img:///UILibrary_LW_LaserPack.Inv_Laser_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'Bullpup_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Trigger_B", "", 'Vektor_LS', , /*"img:///UILibrary*/"_LW_LaserPack.LaserRifle_TriggerB", /*"img:///UILibrary*/"_LW_LaserPack.Inv_Laser_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	Template.AddUpgradeAttachment('Trigger', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "ConvAttachments.Meshes.SM_ConvTriggerB", "", 'Vektor_CG', , "", /*"img:///UILibrary*/"_StrategyImages.X2InventoryIcons.ConvAssault_ReargripB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'Vektor_CG', , /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.CoilSniperRifle_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

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
	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_B", "", 'Bullpup_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_ForegripB", "img:///UILibrary_LW_LaserPack.Inv_Laser_ForegripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagC", "", 'Bullpup_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagD", "", 'Bullpup_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_B", "", 'Vektor_LS', , /*"img:///UILibrary*/"_LW_LaserPack.LaserRifle_ForegripB", /*"img:///UILibrary*/"_LW_LaserPack.Inv_Laser_ForegripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagC", "", 'Vektor_CG', ,  /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.CoilSniperRifle_MagC", /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagD", "", 'Vektor_CG', , /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.CoilSniperRifle_MagD", /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
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
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWShotgun_LS.Meshes.SK_LaserShotgun_Stock_B", "", 'Bullpup_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_StockB", "img:///UILibrary_LW_LaserPack.Inv_LaserShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "LWAttachments_LS.Meshes.SK_Laser_Crossbar", "", 'Bullpup_LS', , "img:///UILibrary_LW_LaserPack.LaserBullpup_CrossBar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'Bullpup_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_StockB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAttachments_LS.Meshes.SK_Laser_Stock_B", "", 'Vektor_LS', , /*"img:///UILibrary*/"_LW_LaserPack.LaserRifle_StockB", /*"img:///UILibrary*/"_LW_LaserPack.LaserRifle_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "LWAttachments_LS.Meshes.SK_Laser_Crossbar", "", 'Vektor_LS', , /*"img:///UILibrary*/"_LW_LaserPack.LaserShotgun_CrossBar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);

	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockC", "", 'Vektor_CG', , /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.CoilSMG_StockB", /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

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
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWSMG_LS.Meshes.SK_LaserSMG_Suppressor", "", 'Bullpup_LS', , "img:///UILibrary_LW_LaserPack.LaserSMG_Suppressor", "img:///UILibrary_LW_LaserPack.Inv_LaserSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_Silencer", "", 'Bullpup_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWSniperRifle_LS.Meshes.SK_LaserSniper_Suppressor", "", 'Vektor_LS', , /*"img:///UILibrary*/"_LW_LaserPack.LaserRifle_Suppressor", /*"img:///UILibrary*/"_LW_LaserPack.Inv_LaserRifle_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWSniperRifle_CG.Meshes.LW_CoilSniper_Suppressor", "", 'Vektor_CG', , /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.CoilRifle_Suppressor", /*"img:///UILibrary*/"_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

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
	}

	return false;
}


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


static function bool CanAddItemToInventory_CH_Improved(out int bCanAddItem, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, int Quantity, XComGameState_Unit UnitState, optional XComGameState CheckGameState, optional out string DisabledReason, optional XComGameState_Item ItemState) 
{
    local bool                          OverrideNormalBehavior;
    local bool                          DoNotOverrideNormalBehavior;
    local XComGameState_Item            PrimaryWeapon; //, SecondaryWeapon;
    local X2WeaponTemplate              WeaponTemplate;
 
    OverrideNormalBehavior = CheckGameState != none;
    DoNotOverrideNormalBehavior = CheckGameState == none;
 
    if(DisabledReason != "")
        return DoNotOverrideNormalBehavior;
 
    WeaponTemplate = X2WeaponTemplate(ItemTemplate);
    if (WeaponTemplate != none)
    {
        //  Player is attempting to equip a Canister. Check if the unit has a valid primary weapon for that.
        if (WeaponTemplate.WeaponCat == 'lwcanister')
        {
            PrimaryWeapon = UnitState.GetPrimaryWeapon();
            if (PrimaryWeapon == none || !IsValidPrimaryWeaponCategoryForCanister(PrimaryWeapon.GetWeaponCategory(), PrimaryWeapon.GetMyTemplateName()) )
            {
                bCanAddItem = 0;
                DisabledReason = default.CannotEquipCanisterLabel;
                return OverrideNormalBehavior;
            }
        }   //  Player is attempting to equip a something into a primary weapon slot.
        else if (Slot == eInvSlot_PrimaryWeapon && DoesUnitHaveCanisterEquipped(UnitState) && !IsValidPrimaryWeaponCategoryForCanister(WeaponTemplate.WeaponCat, WeaponTemplate.DataName)) 
        {
            bCanAddItem = 0;
            DisabledReason = default.CannotEquipWithCanisterLabel;
            return OverrideNormalBehavior;
        }
    }

    return DoNotOverrideNormalBehavior;
}
 
//  Canisters can be equipped if the primary weapon is a Chemthrower or a SPARK Flamethrower
static private function bool IsValidPrimaryWeaponCategoryForCanister(const name WeaponCat, const name WeaponName)
{
    return WeaponCat == 'lwchemthrower' || class'X2Item_ChemthrowerUpgrades'.default.Sparkthrowers.Find(WeaponName) != INDEX_NONE;
}
 
static private function bool DoesUnitHaveCanisterEquipped(const XComGameState_Unit UnitState)
{
    local array<XComGameState_Item> InventoryItems;
    local XComGameState_Item        InventoryItem;
 
    InventoryItems = UnitState.GetAllInventoryItems();
 
    foreach InventoryItems(InventoryItem)
    {
        if (InventoryItem.GetWeaponCategory() == 'lwcanister')
        {
            return true;
        }
    }
    return false;
}


static function bool CanWeaponApplyUpgrade(XComGameState_Item WeaponState, X2WeaponUpgradeTemplate UpgradeTemplate)
{
	if ( X2WeaponTemplate(WeaponState.GetMyTemplate()).WeaponCat == 'lwchemthrower' || class'X2Item_ChemthrowerUpgrades'.default.Sparkthrowers.Find(WeaponState.GetMyTemplateName()) != INDEX_NONE )
	{
		if ( class'X2Item_ChemthrowerUpgrades'.default.ChemthrowerUpgrades.Find(UpgradeTemplate.DataName) == INDEX_NONE )
		{
			return false;
		}
	}

	return true;
}

static function string DLCAppendSockets(XComUnitPawn Pawn)
{
    local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Pawn.ObjectID));
    if (UnitState == none)
        return "";
    
    if (UnitState.IsSoldier())
    {
        if (UnitState.kAppearance.iGender == eGender_Male)
        {
            return "WP_XCOMCanisterMKII.Sockets.SM_SoldierSockets_M";
        }
        else
        {
            return "WP_XCOMCanisterMKII.Sockets.SM_SoldierSockets_F";
        }
    }
    return "";
}

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseOb, XComGameState GameState)
{
	local name					TagText, AbilityName;
	local array<string>			TagStrings;
	local XComGameState_Ability AbilityState;
	//local XComGameState_Effect	EffectState;
	local X2AbilityTemplate		AbilityTemplate;
	local int					Idx;
	local X2Effect_ApplyCanisterDamage ElemDamage;
	local X2AbilityTemplateManager				AbilityManager;
	
	ParseStringIntoArray(InString, TagStrings, "-", false);
	TagText = name(TagStrings[0]);
	if ( TagStrings.length > 1 )
	{
		AbilityName = name(TagStrings[1]);
	}

	switch (TagText)
	{
		case 'LWCanisterDamage':
			OutString = "0";
			if ( AbilityName != '' )
			{
				//get the canister activation ability
				AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
				AbilityTemplate = AbilityManager.FindAbilityTemplate(AbilityName);
			}
			else
			{
				AbilityTemplate = X2AbilityTemplate(ParseObj);
			}
			if (AbilityTemplate == none)
			{
				AbilityState = XComGameState_Ability(ParseObj);
				if (AbilityState != none)
					AbilityTemplate = AbilityState.GetMyTemplate();
			}
			if (AbilityTemplate != none)
			{
				for (Idx = 0; Idx < AbilityTemplate.AbilityMultiTargetEffects.Length; ++Idx)
				{
					ElemDamage = X2Effect_ApplyCanisterDamage(AbilityTemplate.AbilityMultiTargetEffects[Idx]);
					if ( ElemDamage != none )
					{
						OutString = string(Round(ElemDamage.Scalar *100)) $ "%";
						return true;
					}
				}
			}
			return true;
		default:
			return false;
	}

	return false;
}