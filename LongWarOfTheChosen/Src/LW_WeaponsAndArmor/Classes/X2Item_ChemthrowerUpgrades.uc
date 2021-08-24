class X2Item_ChemthrowerUpgrades extends X2Item_DefaultUpgrades config(GameData_WeaponData);

var config array<name> ChemthrowerTemplateNames;
var config array<name> Sparkthrowers;

var config array<name> ChemthrowerUpgrades;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	//(Barrel Icon) Nozzle Upgrades - Width vs Length
	Items.AddItem(CreateBasicWidthNozzle());
	Items.AddItem(CreateBasicLengthNozzle());
	
	//(Mag Icon) Mag Upgrades - capacity vs autoloader
	Items.AddItem(CreateBasicClipSizeFuel());
	Items.AddItem(CreateBasicReloadFuel());

	//(Battery Icon) Fuel Line for extra canister charges.
	Items.AddItem(CreateBasicFuelLine());
	
	//(Stock Icon) Frames - Reaction fire vs flanking crit
	Items.AddItem(CreateBasicFlankCritFrame());
	Items.AddItem(CreateBasicReactionFireFrame());
	
	return Items;
}

static function bool CanApplyToChemthrower(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local X2WeaponTemplate WeaponTemplate;

	WeaponTemplate = X2WeaponTemplate(Weapon.GetMyTemplate());

	if (WeaponTemplate == none)
	{
		return false;
	}

	if ( WeaponTemplate.WeaponCat == 'lwchemthrower' || default.Sparkthrowers.Find(Weapon.GetMyTemplateName()) != INDEX_NONE )
	{
		return class'X2Item_DefaultUpgrades'.static.CanApplyUpgradeToWeapon(UpgradeTemplate, Weapon, SlotIndex);
	}

	return false;
}

/////////// Nozzles //////////
static function X2DataTemplate CreateBasicWidthNozzle()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'LWWidthNozzle_Bsc');
	SetUpTier1Upgrade(Template);
	SetUpWidthNozzleUpgrade(Template);
	Template.BonusAbilities.AddItem('LWWidthNozzleBsc');
	Template.strImage = "img:///LWIRIClausImmolator.UI_Upgrades.HighVolumeInjector_MG";
	Template.RewardDecks.AddItem('ChemthrowerUpgradeBsc');

	return Template;
}

static function X2DataTemplate CreateBasicLengthNozzle()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'LWLengthNozzle_Bsc');
	SetUpTier1Upgrade(Template);
	SetUpLengthNozzleUpgrade(Template);
	Template.BonusAbilities.AddItem('LWLengthNozzleBsc');
	Template.strImage = "img:///LWIRIClausImmolator.UI_Upgrades.PressurizedInjector_MG";
	Template.RewardDecks.AddItem('ChemthrowerUpgradeBsc');

	return Template;
}

static function SetUpWidthNozzleUpgrade(out X2WeaponUpgradeTemplate Template)
{
	local name ChemTemplateName;

	//Nozzles are kinda like barrels, right?
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWWidthNozzle_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWWidthNozzle_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWWidthNozzle_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWLengthNozzle_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWLengthNozzle_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWLengthNozzle_Sup');

	foreach default.ChemthrowerTemplateNames(ChemTemplateName)
	{
		Template.AddUpgradeAttachment('Suppressor', '', "", "", ChemTemplateName, , "img:///LWIRIClausImmolator.UI_MG.FlamerMG_HighCapacityInjector_MG_", Template.strImage, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	}

	Template.CanApplyUpgradeToWeaponFn = CanApplyToChemthrower;
}

static function SetUpLengthNozzleUpgrade(out X2WeaponUpgradeTemplate Template)
{
	local name ChemTemplateName;

	//Nozzles are kinda like barrels, right?
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWWidthNozzle_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWWidthNozzle_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWWidthNozzle_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWLengthNozzle_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWLengthNozzle_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWLengthNozzle_Sup');

	foreach default.ChemthrowerTemplateNames(ChemTemplateName)
	{
		Template.AddUpgradeAttachment('Suppressor', '', "", "", ChemTemplateName, , "img:///LWIRIClausImmolator.UI_MG.FlamerMG_PressurizedInjector_MG_", Template.strImage, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	}

	Template.CanApplyUpgradeToWeaponFn = CanApplyToChemthrower;
}


static function X2DataTemplate CreateBasicClipSizeFuel()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'LWClipSizeFuel_Bsc');
	SetUpClipSizeBonusFuel(Template);
	SetUpTier1Upgrade(Template);
	Template.strImage = "img:///LWIRIClausImmolator.UI_Upgrades.ExpandedFuelTank_MG";
	Template.ClipSizeBonus = default.CLIP_SIZE_ADV;
	Template.RewardDecks.AddItem('ChemthrowerUpgradeBsc');

	return Template;
}

static function SetUpClipSizeBonusFuel(X2WeaponUpgradeTemplate Template)
{
	local name ChemTemplateName;

	SetUpWeaponUpgrade(Template);

	Template.AdjustClipSizeFn = AdjustClipSize;
	Template.GetBonusAmountFn = GetClipSizeBonusAmount;

	//Clip Size and Autoloader compete for the "fuel" upgrade category.
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWClipSizeFuel_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWClipSizeFuel_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWClipSizeFuel_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReloadFuel_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReloadFuel_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReloadFuel_Sup');


	foreach default.ChemthrowerTemplateNames(ChemTemplateName)
	{
		Template.AddUpgradeAttachment('Mag', '', "", "", ChemTemplateName, , "img:///LWIRIClausImmolator.UI_MG.FlamerMG_ExpandedFuelTank_MG_", Template.strImage, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	}

	Template.CanApplyUpgradeToWeaponFn = CanApplyToChemthrower;
}


static function X2DataTemplate CreateBasicReloadFuel()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'LWReloadFuel_Bsc');

	SetUpReloadFuel(Template);
	SetUpTier1Upgrade(Template);
	Template.strImage = "img:///LWIRIClausImmolator.UI_Upgrades.AutoRefuelTank_MG";
	//Template.NumFreeReloads = default.FREE_RELOADS_BSC;
	Template.BonusAbilities.AddItem('LWAutoloaderFuelBsc');
	Template.RewardDecks.AddItem('ChemthrowerUpgradeBsc');
	
	return Template;
}


static function SetUpReloadFuel(out X2WeaponUpgradeTemplate Template)
{
	local name ChemTemplateName;

	SetUpWeaponUpgrade(Template);

	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReloadFuel_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReloadFuel_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReloadFuel_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWClipSizeFuel_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWClipSizeFuel_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWClipSizeFuel_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade_Sup');

	foreach default.ChemthrowerTemplateNames(ChemTemplateName)
	{
		Template.AddUpgradeAttachment('Mag', '', "", "", ChemTemplateName, , "img:///LWIRIClausImmolator.UI_MG.FlamerMG_AutoRefuelTank_MG_", Template.strImage, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	}

	Template.CanApplyUpgradeToWeaponFn = CanApplyToChemthrower;
}

static function X2DataTemplate CreateBasicFuelLine()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'LWFuelLine_Bsc');

	SetUpFuelLine(Template);
	SetUpTier1Upgrade(Template);
	Template.strImage = "img:///LWIRIClausImmolator.UI_Upgrades.FuelLine_MG";
	Template.BonusAbilities.AddItem('LWFuelLineBsc');
	Template.RewardDecks.AddItem('ChemthrowerUpgradeBsc');
	
	return Template;
}

static function SetUpFuelLine(out X2WeaponUpgradeTemplate Template)
{
	local name ChemTemplateName;

	SetUpWeaponUpgrade(Template);

	Template.MutuallyExclusiveUpgrades.AddItem('LWFuelLine_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWFuelLine_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWFuelLine_Sup');

	foreach default.ChemthrowerTemplateNames(ChemTemplateName)
	{
		Template.AddUpgradeAttachment('HeatSink', '', "", "", ChemTemplateName, , "img:///LWIRIClausImmolator.UI_MG.FlamerMG_FuelLine_MG_", Template.strImage, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_battery");
	}

	Template.CanApplyUpgradeToWeaponFn = CanApplyToChemthrower;
}

static function X2DataTemplate CreateBasicFlankCritFrame()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'LWFlankCritFrame_Bsc');

	SetUpLightFrameUpgrade(Template);
	SetUpTier1Upgrade(Template);
	Template.strImage = "img:///LWIRIClausImmolator.UI_Upgrades.LightBodyFrame_MG";
	//Template.NumFreeReloads = default.FREE_RELOADS_BSC;
	Template.BonusAbilities.AddItem('LWFlankCritFrameBsc');
	Template.RewardDecks.AddItem('ChemthrowerUpgradeBsc');
	
	return Template;
}

static function SetUpLightFrameUpgrade(out X2WeaponUpgradeTemplate Template)
{
	local name ChemTemplateName;

	SetUpWeaponUpgrade(Template);

	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWFlankCritFrame_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWFlankCritFrame_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWFlankCritFrame_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReactionFireFrame_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReactionFireFrame_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReactionFireFrame_Sup');

	foreach default.ChemthrowerTemplateNames(ChemTemplateName)
	{
		Template.AddUpgradeAttachment('Stock', '', "", "", ChemTemplateName, , "img:///LWIRIClausImmolator.UI_MG.FlamerMG_LightBodyFrame_MG_", Template.strImage, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	}

	Template.CanApplyUpgradeToWeaponFn = CanApplyToChemthrower;
}

static function X2DataTemplate CreateBasicReactionFireFrame()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'LWReactionFireFrame_Bsc');

	SetUpReactionFrameUpgrade(Template);
	SetUpTier1Upgrade(Template);
	Template.strImage = "img:///LWIRIClausImmolator.UI_Upgrades.Stabilizer_MG";
	//Template.NumFreeReloads = default.FREE_RELOADS_BSC;
	Template.BonusAbilities.AddItem('LWReactionFireFrameBsc');
	Template.RewardDecks.AddItem('ChemthrowerUpgradeBsc');
	
	return Template;
}


static function SetUpReactionFrameUpgrade(out X2WeaponUpgradeTemplate Template)
{
	local name ChemTemplateName;

	SetUpWeaponUpgrade(Template);

	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWFlankCritFrame_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWFlankCritFrame_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWFlankCritFrame_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReactionFireFrame_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReactionFireFrame_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('LWReactionFireFrame_Sup');

	foreach default.ChemthrowerTemplateNames(ChemTemplateName)
	{
		Template.AddUpgradeAttachment('Stock', '', "", "", ChemTemplateName, , "img:///LWIRIClausImmolator.UI_MG.FlamerMG_Stabilizer_MG_", Template.strImage, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	}

	Template.CanApplyUpgradeToWeaponFn = CanApplyToChemthrower;
}

