//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_LongWaroftheChosen.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_LongWaroftheChosen extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	`Log("*********************** Starting OnLoadedSavedGame *************************");
	class'XComGameState_LWListenerManager'.static.CreateListenerManager();
	class'X2DownloadableContentInfo_LWSMGPack'.static.OnLoadedSavedGame();
	class'X2DownloadableContentInfo_LWLaserPack'.static.OnLoadedSavedGame();
	class'X2DownloadableContentInfo_LWOfficerPack'.static.OnLoadedSavedGame();

	UpdateUtilityItemSlotsForAllSoldiers();
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
	class'XComGameState_LWListenerManager'.static.CreateListenerManager(StartState);

	UpdateUtilityItemSlotsForStartingSoldiers(StartState);
	LimitStartingSquadSize(StartState);
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	class'LWTemplateMods_Utilities'.static.UpdateTemplates();
	UpdateWeaponAttachmentsForCoilgun();
}


// ******** Give soldiers 3 utility item slots ************* //
//
static function UpdateUtilityItemSlotsForAllSoldiers()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local bool bUpdatedAnySoldier;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating Soldier Initial Inventory");
	bUpdatedAnySoldier = false;

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.IsSoldier())
		{
			if (UpdateSoldierUtilityItemSlots(UnitState, NewGameState))
			{
				bUpdatedAnySoldier = true;
			}
		}
	}

	if (bUpdatedAnySoldier)
	{
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

static function UpdateUtilityItemSlotsForStartingSoldiers(XComGameState StartState)
{
	local XComGameState_Unit UnitState;

	foreach StartState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.IsSoldier())
		{
			UpdateSoldierUtilityItemSlots(UnitState, StartState);
		}
	}
}

static function bool UpdateSoldierUtilityItemSlots(XComGameState_Unit UnitState, XComGameState StartState)
{
	UnitState.SetBaseMaxStat(eStat_UtilityItems, 3.0f);
	UnitState.SetCurrentStat(eStat_UtilityItems, 3.0f);

	class'XComGameState_LWListenerManager'.static.GiveDefaultUtilityItemsToSoldier(UnitState, StartState);
	return true;
}



// ******** HANDLE UPDATING WEAPON ATTACHMENTS ************* //
// This provides the artwork/assets for weapon attachments for SMGs
static function UpdateWeaponAttachmentsForCoilgun()
{
	local X2ItemTemplateManager ItemTemplateManager;

	//get access to item template manager to update existing upgrades
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if (ItemTemplateManager == none) {
		`Redscreen("LW Coilguns : failed to retrieve ItemTemplateManager to configure upgrades");
		return;
	}

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
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticB", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SMG
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticB", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Shotgun
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BeamShotgun.Meshes.SM_BeamShotgun_OpticB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticB", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Cannon
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "LWCannon_CG.Meshes.LW_CoilCannon_OpticB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_OpticB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

}

static function AddAimBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticC", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	//SMG
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticC", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Shotgun
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BeamShotgun.Meshes.SM_BeamShotgun_OpticC", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticC", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Cannon
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "LWCannon_CG.Meshes.LW_CoilCannon_OpticC", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_OpticC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

}

static function AddClipSizeBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagB", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	//SMG
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagB", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	// Shotgun
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	// Sniper Rifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagB", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

	// Cannon
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);

}

static function AddFreeFireBonusUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	//SMG
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Shotgun
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Sniper
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWAccessories_CG.Meshes.LW_Coil_ReargripB", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgunSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Cannon
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_ReargripB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_ReargripB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_ReargripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

}

static function AddReloadUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagC", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagD", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	//SMG
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagC", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagD", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Shotgun
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagC", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagC", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagD", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Sniper
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagC", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagD", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

	// Cannon
	//Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagC", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagC", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagD", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagD", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);

}

static function AddMissDamageUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_StockB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	//SMG
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_StockB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Shotgun
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_StockB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMGShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "LWAccessories_CG.Meshes.LW_Coil_StockC", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_StockC", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_StockC", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Cannon
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "LWCannon_CG.Meshes.LW_CoilCannon_StockB", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_StockB", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('StockSupport', '', "LWCannon_CG.Meshes.LW_CoilCannon_StockSupportB", "", 'Cannon_CG');

}

static function AddFreeKillUpgrade(X2ItemTemplateManager ItemTemplateManager, Name TemplateName)
{
	local X2WeaponUpgradeTemplate Template;

	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template == none)
	{
		`Redscreen("LW Coilguns : Failed to find upgrade template " $ string(TemplateName));
		return;
	}
	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	// Assault Rifle
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_Silencer", "", 'AssaultRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	//SMG
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_Silencer", "", 'SMG_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilRifleSMG_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Shotgun
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "LWShotgun_CG.Meshes.LW_CoilShotgun_Suppressor", "", 'Shotgun_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilShotgun_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Sniper Rifle
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "LWSniperRifle_CG.Meshes.LW_CoilSniper_Suppressor", "", 'SniperRifle_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilSniperRifle_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Cannon
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Cannon_Suppressor', "LWCannon_CG.Meshes.LW_CoilCannon_Suppressor", "", 'Cannon_CG', , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_Suppressor", "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_CoilCannon_Suppressor", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

}


//=========================================================================================
//================= BEGIN LONG WAR ABILITY TAG HANDLER ====================================
//=========================================================================================

// PLEASE LEAVE THIS FUNCTION AT THE BOTTOM OF THE FILE FOR EASY FINDING - JL

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;
	local UITacticalHUD TacticalHUD;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local int NumTiles;

	Type = name(InString);
	switch(Type)
	{
		/* WOTC TODO: Restore these when the corresponding classes are added back in
		case 'EVACDELAY_LW':
			OutString = string(class'X2Ability_PlaceDelayedEvacZone'.static.GetEvacDelay());
			return true;
		case 'INDEPENDENT_TRACKING_BONUS_TURNS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.INDEPENDENT_TARGETING_NUM_BONUS_TURNS);
			return true;
		case 'HOLO_CV_AIM_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HOLO_CV_AIM_BONUS);
			return true;
		case 'HOLO_MG_AIM_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HOLO_MG_AIM_BONUS);
			return true;
		case 'HOLO_BM_AIM_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HOLO_BM_AIM_BONUS);
			return true;
		case 'HDHOLO_CV_CRIT_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HDHOLO_CV_CRIT_BONUS);
			return true;
		case 'HDHOLO_MG_CRIT_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HDHOLO_MG_CRIT_BONUS);
			return true;
		case 'HDHOLO_BM_CRIT_BONUS_LW':
			OutString = string(class'X2Effect_LWHoloTarget'.default.HDHOLO_BM_CRIT_BONUS);
			return true;
		case 'VITAL_POINT_CV_BONUS_DMG_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_BASEDAMAGE.Damage);
			if (class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_BASEDAMAGE.PlusOne > 0)
			{
				Outstring $= ".";
				Outstring $= string (class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_BASEDAMAGE.PlusOne);
			}
			return true;
		case 'VITAL_POINT_MG_BONUS_DMG_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_BASEDAMAGE.Damage);
			if (class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_BASEDAMAGE.PlusOne > 0)
			{
				Outstring $= ".";
				Outstring $= string (class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_BASEDAMAGE.PlusOne);
			}
			return true;
		case 'VITAL_POINT_BM_BONUS_DMG_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_BASEDAMAGE.Damage);
			if (class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_BASEDAMAGE.PlusOne > 0)
			{
				Outstring $= ".";
				Outstring $= string (class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_BASEDAMAGE.PlusOne);
			}
			return true;
		case 'MULTI_HOLO_CV_RADIUS_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_CONVENTIONAL_RADIUS);
			return true;
		case 'MULTI_HOLO_MG_RADIUS_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_MAGNETIC_RADIUS);
			return true;
		case 'MULTI_HOLO_BM_RADIUS_LW':
			OutString = string(class'X2Item_LWHolotargeter'.default.Holotargeter_BEAM_RADIUS);
			return true;
		*/
		case 'RAPID_TARGETING_COOLDOWN_LW':
			OutString = string(class'X2Ability_LW_SharpshooterAbilitySet'.default.RAPID_TARGETING_COOLDOWN);
			return true;
		case 'MULTI_TARGETING_COOLDOWN_LW':
			OutString = string(class'X2Ability_LW_SharpshooterAbilitySet'.default.MULTI_TARGETING_COOLDOWN);
			return true;
		case 'HIGH_PRESSURE_CHARGES_LW':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.FLAMETHROWER_HIGH_PRESSURE_CHARGES);
			return true;
		case 'FLAMETHROWER_CHARGES_LW':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.FLAMETHROWER_CHARGES);
			return true;
		case 'FIRESTORM_DAMAGE_BONUS_LW':
			Outstring = string(class'X2Ability_LW_TechnicalAbilitySet'.default.FIRESTORM_DAMAGE_BONUS);
			return true;
		case 'NANOFIBER_HEALTH_BONUS_LW':
			Outstring = string(class'X2Ability_ItemGrantedAbilitySet'.default.NANOFIBER_VEST_HP_BONUS);
			return true;
		case 'NANOFIBER_CRITDEF_BONUS_LW':
			Outstring = string(class'X2Ability_LW_GearAbilities'.default.NANOFIBER_CRITDEF_BONUS);
			return true;
		case 'ALPHA_MIKE_FOXTROT_DAMAGE_LW':
			Outstring = string(class'X2Ability_LW_SharpshooterAbilitySet'.default.ALPHAMIKEFOXTROT_DAMAGE);
			return true;
		case 'ROCKETSCATTER':
			TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
			if (TacticalHUD != none)
				UnitRef = XComTacticalController(TacticalHUD.PC).GetActiveUnitStateRef();
			if (UnitRef.ObjectID > 0)
				UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

			if (TacticalHUD != none && TacticalHUD.GetTargetingMethod() != none && UnitState != none)
			{
				NumTiles = class'X2Ability_LW_TechnicalAbilitySet'.static.GetNumAimRolls(UnitState);
				Outstring = class'X2Ability_LW_TechnicalAbilitySet'.default.strMaxScatter $ string(NumTiles);
			}
			else
			{
				Outstring = "";
			}
			return true;
		case 'FORTIFY_DEFENSE_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.FORTIFY_DEFENSE);
			return true;
		case 'FORTIFY_COOLDOWN_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.FORTIFY_COOLDOWN);
			return true;
		case 'COMBAT_FITNESS_HP_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_HP);
			return true;
		case 'COMBAT_FITNESS_OFFENSE_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_OFFENSE);
			return true;
		case 'COMBAT_FITNESS_MOBILITY_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_MOBILITY);
			return true;
		case 'COMBAT_FITNESS_DODGE_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_DODGE);
			return true;
		case 'COMBAT_FITNESS_WILL_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_WILL);
			return true;
		case 'COMBAT_FITNESS_DEFENSE_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.COMBAT_FITNESS_DEFENSE);
			return true;
		case 'COMBATIVES_DODGE_LW':
			Outstring = string(class'X2Ability_LW_GunnerAbilitySet'.default.COMBATIVES_DODGE);
			return true;
		case 'SPRINTER_MOBILITY_LW':
			Outstring = string(class'X2Ability_LW_RangerAbilitySet'.default.SPRINTER_MOBILITY);
			return true;
		default:
			return false;
	}
}