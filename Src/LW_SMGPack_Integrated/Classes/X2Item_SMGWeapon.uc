//---------------------------------------------------------------------------------------
//  FILE:    X2Item_SMGSchematics.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines weapon templates and updates base-game upgrade templates for SMGs
//
//---------------------------------------------------------------------------------------
class X2Item_SMGWeapon extends X2Item config(GameData_WeaponData);

// Variables from config - GameData_WeaponData.ini
// ***** Damage arrays for attack actions  *****

var config WeaponDamageValue SMG_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue SMG_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue SMG_BEAM_BASEDAMAGE;

// ***** Core properties and variables for weapons *****
var config int SMG_CONVENTIONAL_AIM;
var config int SMG_CONVENTIONAL_CRITCHANCE;
var config int SMG_CONVENTIONAL_ICLIPSIZE;
var config int SMG_CONVENTIONAL_ISOUNDRANGE;
var config int SMG_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int SMG_CONVENTIONAL_ISUPPLIES;
var config int SMG_CONVENTIONAL_TRADINGPOSTVALUE;
var config int SMG_CONVENTIONAL_IPOINTS;
var config int SMG_CONVENTIONAL_UPGRADESLOTS;

var config int SMG_MAGNETIC_AIM;
var config int SMG_MAGNETIC_CRITCHANCE;
var config int SMG_MAGNETIC_ICLIPSIZE;
var config int SMG_MAGNETIC_ISOUNDRANGE;
var config int SMG_MAGNETIC_IENVIRONMENTDAMAGE;
var config int SMG_MAGNETIC_ISUPPLIES;
var config int SMG_MAGNETIC_TRADINGPOSTVALUE;
var config int SMG_MAGNETIC_IPOINTS;
var config int SMG_MAGNETIC_UPGRADESLOTS;

var config int SMG_BEAM_AIM;
var config int SMG_BEAM_CRITCHANCE;
var config int SMG_BEAM_ICLIPSIZE;
var config int SMG_BEAM_ISOUNDRANGE;
var config int SMG_BEAM_IENVIRONMENTDAMAGE;
var config int SMG_BEAM_ISUPPLIES;
var config int SMG_BEAM_TRADINGPOSTVALUE;
var config int SMG_BEAM_IPOINTS;
var config int SMG_BEAM_UPGRADESLOTS;

// ***** Range Modifier Tables *****
var config array<int> MIDSHORT_CONVENTIONAL_RANGE;
var config array<int> MIDSHORT_MAGNETIC_RANGE;
var config array<int> MIDSHORT_BEAM_RANGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	//create all three tech tiers of weapons
	Weapons.AddItem(CreateTemplate_SMG_Conventional());
	Weapons.AddItem(CreateTemplate_SMG_Magnetic());
	Weapons.AddItem(CreateTemplate_SMG_Beam());

	return Weapons;
}

// **********************************************************************************************************
// ***                                            Player Weapons                                          ***
// **********************************************************************************************************

// **************************************************************************
// ***                          SMG                                        ***
// **************************************************************************

// Initial SMG uses Assault Rifle model and artwork until new artwork is complete
static function X2DataTemplate CreateTemplate_SMG_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SMG_CV');
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_SMG.conventional.LWConvSMG_Base";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 0;

	Template.Abilities.AddItem('SMG_CV_StatBonus');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_SMGAbilities'.default.SMG_CONVENTIONAL_MOBILITY_BONUS);

	Template.RangeAccuracy = default.MIDSHORT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.SMG_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.SMG_CONVENTIONAL_AIM;
	Template.CritChance = default.SMG_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.SMG_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.SMG_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SMG_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SMG_CONVENTIONAL_UPGRADESLOTS;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSMG_CV.WP_SMG_CV";

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWSMG_CV.Meshes.SK_LWConvSMG_MagA", , "img:///UILibrary_SMG.conventional.LWConvSMG_MagA");
	Template.AddDefaultAttachment('Optic', "LWSMG_CV.Meshes.SK_LWConvSMG_OpticA", , "img:///UILibrary_SMG.conventional.LWConvSMG_OpticA");
	Template.AddDefaultAttachment('Stock', "LWSMG_CV.Meshes.SK_LWConvSMG_Stock");  // renamed to just 'Stock' when fixing seaming issues for TTP 52
	Template.AddDefaultAttachment('StockB', "", , "img:///UILibrary_SMG.conventional.LWConvSMG_StockA");  // attach image to StockB so it gets replaced with ugprade
	Template.AddDefaultAttachment('Trigger', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_TriggerA", , "img:///UILibrary_SMG.conventional.LWConvSMG_TriggerA"); // re-use Assault Rifle trigger
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.bInfiniteItem = true;  // post-AlienHunters, Starting items are no longer assumed to be infinite
	Template.CanBeBuilt = false;

	//Template.UpgradeItem = 'SMG_MG';

	Template.fKnockbackDamageAmount = 4.0f;
	Template.fKnockbackDamageRadius = 0.0f;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_SMG_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SMG_MG');

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_SMG.magnetic.LWMagSMG_Base";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 2;

	Template.Abilities.AddItem('SMG_MG_StatBonus');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_SMGAbilities'.default.SMG_MAGNETIC_MOBILITY_BONUS);

	Template.RangeAccuracy = default.MIDSHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.SMG_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.SMG_MAGNETIC_AIM;
	Template.CritChance = default.SMG_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.SMG_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.SMG_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SMG_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SMG_MAGNETIC_UPGRADESLOTS;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSMG_MG.WP_SMG_MG";

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagA", , "img:///UILibrary_SMG.magnetic.LWMagSMG_MagA");
	Template.AddDefaultAttachment('Optic', "LWSMG_MG.Meshes.SK_LWMagSMG_OpticA", , "img:///UILibrary_SMG.magnetic.LWMagSMG_OpticA");
	//turn off SuppressorA, as it is built in to the base mesh now
	//Template.AddDefaultAttachment('Suppressor', "LWSMG_MG.Meshes.SK_LWMagSMG_SuppressorA"); //, , "img:///UILibrary_SMG.magnetic.LWMagSMG_SuppressorA"); // included with base
	Template.AddDefaultAttachment('Reargrip', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_ReargripA", , /* included with TriggerA */);
	Template.AddDefaultAttachment('Stock', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_StockA", , "img:///UILibrary_SMG.magnetic.LWMagSMG_StockA");
	Template.AddDefaultAttachment('Trigger', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_TriggerA", , "img:///UILibrary_SMG.magnetic.LWMagSMG_TriggerA");
	Template.AddDefaultAttachment('Light', "LWSMG_MG.Meshes.SK_MagFlashLight");  // alternative -- use mag flashlight, unused in base-game, converted to skeletal mesh

	Template.iPhysicsImpulse = 5;

	//Template.UpgradeItem = 'SMG_BM';
	Template.CreatorTemplateName = 'SMG_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SMG_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_SMG_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SMG_BM');

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_SMG.Beam.LWBeamSMG_Base";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 4;

	Template.Abilities.AddItem('SMG_BM_StatBonus');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_SMGAbilities'.default.SMG_BEAM_MOBILITY_BONUS);

	Template.RangeAccuracy = default.MIDSHORT_BEAM_RANGE;
	Template.BaseDamage = default.SMG_BEAM_BASEDAMAGE;
	Template.Aim = default.SMG_BEAM_AIM;
	Template.CritChance = default.SMG_BEAM_CRITCHANCE;
	Template.iClipSize = default.SMG_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.SMG_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SMG_BEAM_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SMG_BEAM_UPGRADESLOTS;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSMG_BM.WP_SMG_BM";

	//Parameters are : 	AttachSocket, UIArmoryCameraPointTag, MeshName, ProjectileName, MatchWeaponTemplate, AttachToPawn, IconName, InventoryIconName, InventoryCategoryIcon, ValidateAttachmentFn
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagA", , "img:///UILibrary_SMG.Beam.LWBeamSMG_MagA");
	//Template.AddDefaultAttachment('Suppressor', "LWSMG_BM.Meshes.SM_LWBeamSMG_SuppressorA", , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_SupressorA");
	Template.AddDefaultAttachment('Core', "LWSMG_BM.Meshes.SK_LWBeamSMG_CoreB", , "img:///UILibrary_SMG.Beam.LWBeamSMG_CoreA");
	Template.AddDefaultAttachment('HeatSink', "LWSMG_BM.Meshes.SK_LWBeamSMG_HeatsinkA", , "img:///UILibrary_SMG.Beam.LWBeamSMG_HeatsinkA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'SMG_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SMG_MG'; // Which item this will be upgraded from
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
