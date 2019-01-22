//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_LWSMGPack.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Initializes Officer mod settings on campaign start or when loading campaign without mod previously active
//--------------------------------------------------------------------------------------- 

class X2DownloadableContentInfo_LWSMGPack extends X2DownloadableContentInfo;	

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	`Log("LW SMGPack : Starting OnLoadedSavedGame");
	UpdateStorage();
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
//static event InstallNewCampaign(XComGameState StartState);

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	UpdateWeaponAttachments();
}


// ******** HANDLE UPDATING STORAGE ************* //
// This handles updating storage in order to create variations of various SMGs based on techs unlocked
static function UpdateStorage()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateMgr;
	local X2ItemTemplate ItemTemplate;
	//local X2SchematicTemplate SchematicTemplate_MG, SchematicTemplate_BM;
	local XComGameState_Item NewItemState;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add SMGs");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	//add Conventional SMG always
	`Log("LW SMGPack : Updated Conventional SMG");
	ItemTemplate = ItemTemplateMgr.FindItemTemplate('SMG_CV');
	if(ItemTemplate != none)
	{
		`Log("LW SMGPack : Found SMG_CV item template");
		if (!XComHQ.HasItem(ItemTemplate))
		{
			`Log("LW SMGPack : SMG_CV not found, adding to inventory");
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);
			History.AddGameStateToHistory(NewGameState);
		} else {
			`Log("LW SMGPack : SMG_CV found, skipping inventory add");
			History.CleanupPendingGameState(NewGameState);
		}
	}

	//schematics should be handled already, as the BuildItem UI draws from ItemTemplates, which are automatically loaded



}

// ******** HANDLE UPDATING WEAPON ATTACHMENTS ************* //
// This provides the artwork/assets for weapon attachments for SMGs
static function UpdateWeaponAttachments()
{
	local X2ItemTemplateManager ItemTemplateMgr;

	//get access to item template manager to update existing upgrades
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	`Log("LW SMGPack : Retrieved ItemTemplateManager");

	if (ItemTemplateMgr == none) {
		`Redscreen("LW SMGPack : failed to retrieve ItemTemplateManager to configure upgrades");
		return;
	}

	//add SMG to the DefaultUpgrades Templates so that upgrades work with new weapon
	//this doesn't make the upgrade available, it merely configures the art
	AddCritUpgrade(ItemTemplateMgr, 'CritUpgrade_Bsc');
	AddCritUpgrade(ItemTemplateMgr, 'CritUpgrade_Adv');
	AddCritUpgrade(ItemTemplateMgr, 'CritUpgrade_Sup');

	AddAimBonusUpgrade(ItemTemplateMgr, 'AimUpgrade_Bsc');
	AddAimBonusUpgrade(ItemTemplateMgr, 'AimUpgrade_Adv');
	AddAimBonusUpgrade(ItemTemplateMgr, 'AimUpgrade_Sup');

	AddClipSizeBonusUpgrade(ItemTemplateMgr, 'ClipSizeUpgrade_Bsc');
	AddClipSizeBonusUpgrade(ItemTemplateMgr, 'ClipSizeUpgrade_Adv');
	AddClipSizeBonusUpgrade(ItemTemplateMgr, 'ClipSizeUpgrade_Sup');

	AddFreeFireBonusUpgrade(ItemTemplateMgr, 'FreeFireUpgrade_Bsc');
	AddFreeFireBonusUpgrade(ItemTemplateMgr, 'FreeFireUpgrade_Adv');
	AddFreeFireBonusUpgrade(ItemTemplateMgr, 'FreeFireUpgrade_Sup');

	AddReloadUpgrade(ItemTemplateMgr, 'ReloadUpgrade_Bsc');
	AddReloadUpgrade(ItemTemplateMgr, 'ReloadUpgrade_Adv');
	AddReloadUpgrade(ItemTemplateMgr, 'ReloadUpgrade_Sup');

	AddMissDamageUpgrade(ItemTemplateMgr, 'MissDamageUpgrade_Bsc');
	AddMissDamageUpgrade(ItemTemplateMgr, 'MissDamageUpgrade_Adv');
	AddMissDamageUpgrade(ItemTemplateMgr, 'MissDamageUpgrade_Sup');

	AddFreeKillUpgrade(ItemTemplateMgr, 'FreeKillUpgrade_Bsc');
	AddFreeKillUpgrade(ItemTemplateMgr, 'FreeKillUpgrade_Adv');
	AddFreeKillUpgrade(ItemTemplateMgr, 'FreeKillUpgrade_Sup');
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
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_CV.Meshes.SK_LWConvSMG_OpticB", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_MG.Meshes.SK_LWMagSMG_OpticB", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_BM.Meshes.SK_LWBeamSMG_OpticB", "", 'SMG_BM', , "img:///UILibrary_SMG.Beam.LWBeamSMG_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_OpticA_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
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
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_CV.Meshes.SK_LWConvSMG_OpticC", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_MG.Meshes.SK_LWMagSMG_OpticC", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_BM.Meshes.SK_LWBeamSMG_OpticC", "", 'SMG_BM', , "img:///UILibrary_SMG.Beam.LWBeamSMG_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
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
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_CV.Meshes.SK_LWConvSMG_MagB", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_MagB", "img:///UILibrary_SMG.conventional.LWConvSMG_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagB", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagB", "", 'SMG_BM', , "img:///UILibrary_SMG.Beam.LWBeamSMG_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
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
	Template.AddUpgradeAttachment('Trigger', '', "ConvAttachments.Meshes.SM_ConvTriggerB", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_TriggerA", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_ReargripB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger"); // use conventional trigger attachment
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAttachments.Meshes.SM_MagReargripB", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_BM.Meshes.SK_LWBeamSMG_CoreA", "", 'SMG_BM', , "img:///UILibrary_SMG.Beam.LWBeamSMG_CoreB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_CoreB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core_Teeth', '', "LWSMG_BM.Meshes.SK_LWBeamSMG_TeethA", "", 'SMG_BM', , "img:///UILibrary_SMG.Beam.LWBeamSMG_TeethA", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_Teeth_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	Template.AddUpgradeAttachment('Trigger', '', "MagAttachments.Meshes.SM_MagTriggerB", "", 'SMG_MG');

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
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_CV.Meshes.SK_LWConvSMG_MagC", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_MagC", "img:///UILibrary_SMG.conventional.LWConvSMG_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_CV.Meshes.SK_LWConvSMG_MagD", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_MagD", "img:///UILibrary_SMG.conventional.LWConvSMG_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagC", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagD", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('AutoLoader', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagC", "", 'SMG_BM', , "img:///UILibrary_SMG.Beam.LWBeamSMG_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_AutoLoader_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
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
	//Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "LWSMG_CV.Meshes.SM_LWConvSMG_StockB", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_StockB", "img:///UILibrary_SMG.conventional.LWConvSMG_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('StockB', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_StockB", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_StockB_alt", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_StockB", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('HeatSink', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "LWSMG_BM.Meshes.SK_LWBeamSMG_HeatsinkB", "", 'SMG_BM', , "img:///UILibrary_SMG.Beam.LWBeamSMG_HeatsinkB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_HeatsinkB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	//Template.AddUpgradeAttachment('Crossbar', '', "ConvAttachments.Meshes.SM_ConvCrossbar", "", 'SMG_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_CrossbarA", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);
	Template.AddUpgradeAttachment('Crossbar', '', "MagAttachments.Meshes.SM_MagCrossbar", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_Crossbar", , , class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent);
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
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWSMG_CV.Meshes.SK_LWConvSMG_SuppressorB", "", 'SMG_CV', , "img:///UILibrary_SMG.conventional.LWConvSMG_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('SuppressorB', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "MagShotgun.Meshes.SM_MagShotgun_SuppressorB", "", 'SMG_MG', , "img:///UILibrary_SMG.magnetic.LWMagSMG_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "LWSMG_BM.Meshes.SK_LWBeamSMG_SuppressorA", "", 'SMG_BM', , "img:///UILibrary_SMG.Beam.LWBeamSMG_SuppressorA", "img:///UILibrary_SMG.Beam.Inv_LWBeamSMG_SuppressorA", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
}
