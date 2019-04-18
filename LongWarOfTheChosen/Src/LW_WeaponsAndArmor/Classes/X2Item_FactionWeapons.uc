// This is an Unreal Script
class X2Item_FactionWeapons extends X2Item config(GameData_WeaponData);

/******************************************************************
**
**  XPAC WEAPON STATS
**
******************************************************************/
var config WeaponDamageValue BULLPUP_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue BULLPUP_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue BULLPUP_BEAM_BASEDAMAGE;

var config WeaponDamageValue VEKTORRIFLE_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue VEKTORRIFLE_BEAM_BASEDAMAGE;

var config WeaponDamageValue WRISTBLADE_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue WRISTBLADE_BEAM_BASEDAMAGE;

var config WeaponDamageValue SHARDGAUNTLET_MAGNETIC_BASEDAMAGE;
var config array<WeaponDamageValue> SHARDGAUNTLET_MAGNETIC_EXTRADAMAGE;
var config WeaponDamageValue SHARDGAUNTLET_BEAM_BASEDAMAGE;
var config array<WeaponDamageValue> SHARDGAUNTLET_BEAM_EXTRADAMAGE;

var config WeaponDamageValue SIDEARM_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue SIDEARM_BEAM_BASEDAMAGE;

var config int BULLPUP_CONVENTIONAL_AIM;
var config int BULLPUP_CONVENTIONAL_CRITCHANCE;
var config int BULLPUP_CONVENTIONAL_ICLIPSIZE;
var config int BULLPUP_CONVENTIONAL_ISOUNDRANGE;
var config int BULLPUP_CONVENTIONAL_IENVIRONMENTDAMAGE;

var config int BULLPUP_MAGNETIC_AIM;
var config int BULLPUP_MAGNETIC_CRITCHANCE;
var config int BULLPUP_MAGNETIC_ICLIPSIZE;
var config int BULLPUP_MAGNETIC_ISOUNDRANGE;
var config int BULLPUP_MAGNETIC_IENVIRONMENTDAMAGE;

var config int BULLPUP_BEAM_AIM;
var config int BULLPUP_BEAM_CRITCHANCE;
var config int BULLPUP_BEAM_ICLIPSIZE;
var config int BULLPUP_BEAM_ISOUNDRANGE;
var config int BULLPUP_BEAM_IENVIRONMENTDAMAGE;

var config int VEKTORRIFLE_MAGNETIC_AIM;
var config int VEKTORRIFLE_MAGNETIC_CRITCHANCE;
var config int VEKTORRIFLE_MAGNETIC_ICLIPSIZE;
var config int VEKTORRIFLE_MAGNETIC_ISOUNDRANGE;
var config int VEKTORRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;

var config int VEKTORRIFLE_BEAM_AIM;
var config int VEKTORRIFLE_BEAM_CRITCHANCE;
var config int VEKTORRIFLE_BEAM_ICLIPSIZE;
var config int VEKTORRIFLE_BEAM_ISOUNDRANGE;
var config int VEKTORRIFLE_BEAM_IENVIRONMENTDAMAGE;

var config int WRISTBLADE_MAGNETIC_AIM;
var config int WRISTBLADE_MAGNETIC_CRITCHANCE;
var config int WRISTBLADE_MAGNETIC_ISOUNDRANGE;
var config int WRISTBLADE_MAGNETIC_IENVIRONMENTDAMAGE;
var config int WRISTBLADE_MAGNETIC_STUNCHANCE;

var config int WRISTBLADE_BEAM_AIM;
var config int WRISTBLADE_BEAM_CRITCHANCE;
var config int WRISTBLADE_BEAM_ISOUNDRANGE;
var config int WRISTBLADE_BEAM_IENVIRONMENTDAMAGE;

var config int SHARDGAUNTLET_MAGNETIC_AIM;
var config int SHARDGAUNTLET_MAGNETIC_CRITCHANCE;
var config int SHARDGAUNTLET_MAGNETIC_ISOUNDRANGE;
var config int SHARDGAUNTLET_MAGNETIC_IENVIRONMENTDAMAGE;

var config int SHARDGAUNTLET_BEAM_AIM;
var config int SHARDGAUNTLET_BEAM_CRITCHANCE;
var config int SHARDGAUNTLET_BEAM_ISOUNDRANGE;
var config int SHARDGAUNTLET_BEAM_IENVIRONMENTDAMAGE;

var config int SIDEARM_MAGNETIC_AIM;
var config int SIDEARM_MAGNETIC_CRITCHANCE;
var config int SIDEARM_MAGNETIC_ICLIPSIZE;
var config int SIDEARM_MAGNETIC_ISOUNDRANGE;
var config int SIDEARM_MAGNETIC_IENVIRONMENTDAMAGE;

var config int SIDEARM_BEAM_AIM;
var config int SIDEARM_BEAM_CRITCHANCE;
var config int SIDEARM_BEAM_ICLIPSIZE;
var config int SIDEARM_BEAM_ISOUNDRANGE;
var config int SIDEARM_BEAM_IENVIRONMENTDAMAGE;

var config array<int> VEKTOR_MAGNETIC_RANGE;
var config array<int> VEKTOR_BEAM_RANGE;

var config array<int> SKIRMISHER_SMG_RANGE;
var config array<int> TEMPLAR_PISTOL_RANGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_VektorRifle_Magnetic());
	Weapons.AddItem(CreateTemplate_VektorRifle_Beam());

	Weapons.AddItem(CreateTemplate_Bullpup_Conventional());
	Weapons.AddItem(CreateTemplate_Bullpup_Magnetic());
	Weapons.AddItem(CreateTemplate_Bullpup_Beam());

	Weapons.AddItem(CreateTemplate_WristBlade_Magnetic());
	Weapons.AddItem(CreateTemplate_WristBlade_Beam());

	Weapons.AddItem(CreateTemplate_ShardGauntlet_Magnetic());
	Weapons.AddItem(CreateTemplate_ShardGauntlet_Beam());	

	Weapons.AddItem(CreateTemplate_Sidearm_Magnetic());
	Weapons.AddItem(CreateTemplate_Sidearm_Beam());
	return Weapons;
}

/******************************************************************
**
**  XPAC WEAPONS
**
******************************************************************/
static function X2DataTemplate CreateTemplate_Bullpup_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Bullpup_CV');
	Template.WeaponPanelImage = "_ConventionalShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'bullpup';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_Common.ConvSMG_Base";
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.Tier = 0;

	Template.Abilities.AddItem('Bullpup_CV_StatBonus');
	Template.SetUIStatMarkup("Mobility", eStat_Mobility, class'X2Ability_WeaponAbilities'.default.BULLPUP_CONVENTIONAL_MOBILITY_BONUS);

	Template.RangeAccuracy = default.SKIRMISHER_SMG_RANGE;
	Template.BaseDamage = default.BULLPUP_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.BULLPUP_CONVENTIONAL_AIM;
	Template.CritChance = default.BULLPUP_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.BULLPUP_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.BULLPUP_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.BULLPUP_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SkirmisherSMG.WP_SkirmisherSMG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';
	Template.AddDefaultAttachment('Mag', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_MagA",, "img:///UILibrary_XPACK_Common.ConvSMG_MagazineA");
	Template.AddDefaultAttachment('Reargrip', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_ReargripA");
	Template.AddDefaultAttachment('Stock', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_StockA",, "img:///UILibrary_XPACK_Common.ConvSMG_StockA");
	Template.AddDefaultAttachment('Trigger', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_TriggerA",,"img:///UILibrary_XPACK_Common.ConvSMG_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_Bullpup_Magnetic()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Bullpup_MG');
	Template.WeaponPanelImage = "_MagneticShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'bullpup';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_XPACK_Common.MagSMG_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.Abilities.AddItem('Bullpup_MG_StatBonus');
	Template.SetUIStatMarkup("Mobility", eStat_Mobility, class'X2Ability_WeaponAbilities'.default.BULLPUP_MAGNETIC_MOBILITY_BONUS);

	Template.RangeAccuracy = default.SKIRMISHER_SMG_RANGE;
	Template.BaseDamage = default.BULLPUP_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.BULLPUP_MAGNETIC_AIM;
	Template.CritChance = default.BULLPUP_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.BULLPUP_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.BULLPUP_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.BULLPUP_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 3;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SkirmisherSMG_MG.WP_SkirmisherSMG_MG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';

	Template.AddDefaultAttachment('Mag', "MagSMG.Meshes.SM_HOR_Mag_SMG_MagA", , "img:///UILibrary_XPACK_Common.MagSMG_MagazineA");
	Template.AddDefaultAttachment('Reargrip', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_ReargripA");
	Template.AddDefaultAttachment('Stock', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_StockA", , "img:///UILibrary_XPACK_Common.MagSMG_StockA");
	Template.AddDefaultAttachment('Trigger', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_TriggerA", , "img:///UILibrary_XPACK_Common.MagSMG_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	/*
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 40;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);
	*/

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Bullpup_Beam()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Bullpup_BM');
	Template.WeaponPanelImage = "_BeamShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'bullpup';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_XPACK_Common.BeamSMG_Base";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.Abilities.AddItem('Bullpup_BM_StatBonus');
	Template.SetUIStatMarkup("Mobility", eStat_Mobility, class'X2Ability_WeaponAbilities'.default.BULLPUP_BEAM_MOBILITY_BONUS);

	Template.RangeAccuracy = default.SKIRMISHER_SMG_RANGE;
	Template.BaseDamage = default.BULLPUP_BEAM_BASEDAMAGE;
	Template.Aim = default.BULLPUP_BEAM_AIM;
	Template.CritChance = default.BULLPUP_BEAM_CRITCHANCE;
	Template.iClipSize = default.BULLPUP_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.BULLPUP_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.BULLPUP_BEAM_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 3;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SkirmisherSMG_BM.WP_SkirmisherSMG_BM";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';	
	Template.AddDefaultAttachment('Mag', "BemSMG.Meshes.SM_HOR_Bem_SMG_MagA", , "img:///UILibrary_XPACK_Common.BeamSMG_MagazineA");
	Template.AddDefaultAttachment('Suppressor', "BemSMG.Meshes.SM_HOR_Bem_SMG_SuppressorA", , "img:///UILibrary_XPACK_Common.BeamSMG_SuppressorA");
	Template.AddDefaultAttachment('Reargrip', "BemSMG.Meshes.SM_HOR_Bem_SMG_ReargripA");
	Template.AddDefaultAttachment('Trigger', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_TriggerA", , "img:///UILibrary_XPACK_Common.BeamSMG_TriggerA");
	Template.AddDefaultAttachment('Stock', "BemSMG.Meshes.SM_HOR_Bem_SMG_StockA", , "img:///UILibrary_XPACK_Common.BeamSMG_StockA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 70;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 6;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 6;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_VektorRifle_Magnetic()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'VektorRifle_MG');
	Template.WeaponPanelImage = "_MagneticSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponCat = 'vektor_rifle';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_XPACK_Common.MagVektor_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = default.VEKTOR_MAGNETIC_RANGE;
	Template.BaseDamage = default.VEKTORRIFLE_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.VEKTORRIFLE_MAGNETIC_AIM;
	Template.CritChance = default.VEKTORRIFLE_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.VEKTORRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.VEKTORRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.VEKTORRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ReaperRifle_MG.WP_ReaperRifle_MG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.AddDefaultAttachment('Mag', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_MagA", , "img:///UILibrary_XPACK_Common.MagVektor_MagazineA");
	Template.AddDefaultAttachment('Optic', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_OpticA", , "img:///UILibrary_XPACK_Common.MagVektor_OpticA");
	Template.AddDefaultAttachment('Reargrip', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_ReargripA");
	Template.AddDefaultAttachment('Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_StockA", , "img:///UILibrary_XPACK_Common.MagVektor_StockA");
	Template.AddDefaultAttachment('Trigger', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerA", , "img:///UILibrary_XPACK_Common.MagVektor_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");
	

	Template.iPhysicsImpulse = 5;

	Template.Requirements.RequiredTechs.AddItem('GaussWeapons');

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_VektorRifle_Beam()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'VektorRifle_BM');
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponCat = 'vektor_rifle';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_XPACK_Common.BeamVektor_Base";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.RangeAccuracy = default.VEKTOR_BEAM_RANGE;
	Template.BaseDamage = default.VEKTORRIFLE_BEAM_BASEDAMAGE;
	Template.Aim = default.VEKTORRIFLE_BEAM_AIM;
	Template.CritChance = default.VEKTORRIFLE_BEAM_CRITCHANCE;
	Template.iClipSize = default.VEKTORRIFLE_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.VEKTORRIFLE_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.VEKTORRIFLE_BEAM_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ReaperRifle_BM.WP_ReaperRifle_BM";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.AddDefaultAttachment('Optic', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_OpticA", , "img:///UILibrary_XPACK_Common.BeamVektor_OpticA");
	Template.AddDefaultAttachment('Mag', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_MagA", , "img:///UILibrary_XPACK_Common.BeamVektor_MagazineA");
	Template.AddDefaultAttachment('Suppressor', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_SuppressorA", , "img:///UILibrary_XPACK_Common.BeamVektor_SuppressorA");
	Template.AddDefaultAttachment('Reargrip', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_ReargripA");
	Template.AddDefaultAttachment('Trigger', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerA", , "img:///UILibrary_XPACK_Common.BeamVektor_TriggerA");
	Template.AddDefaultAttachment('Stock', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_StockA", , "img:///UILibrary_XPACK_Common.BeamVektor_StockA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");	

	Template.iPhysicsImpulse = 5;

	Template.Requirements.RequiredTechs.AddItem('PlasmaSniper');

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.CreatorTemplateName = 'VektorRifle_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'VektorRifle_MG'; // Which item this will be upgraded from

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 80;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 6;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 6;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_WristBlade_Magnetic()
{
	local X2PairedWeaponTemplate Template;
	local WeaponAttachment Attach;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'WristBlade_MG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'WristBladeLeft_MG';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'wristblade';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_MagSGauntlet";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SkirmisherGauntlet.WP_SkirmisherGauntlet_MG";
	Template.AltGameArchetype = "WP_SkirmisherGauntlet.WP_SkirmisherGauntlet_F_MG";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 3;
	Template.bUseArmorAppearance = true;

	Attach.AttachSocket = 'R_Claw';
	Attach.AttachMeshName = "SkirmisherGauntlet.Meshes.SM_SkirmisherGauntletR_Claw_M_MG";
	Attach.RequiredGender = eGender_Male;
	Attach.AttachToPawn = true;
	Template.DefaultAttachments.AddItem(Attach);

	Attach.AttachSocket = 'R_Claw';
	Attach.AttachMeshName = "SkirmisherGauntlet.Meshes.SM_SkirmisherGauntletR_Claw_F_MG";
	Attach.RequiredGender = eGender_Female;
	Attach.AttachToPawn = true;
	Template.DefaultAttachments.AddItem(Attach);

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 3;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.WRISTBLADE_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.WRISTBLADE_MAGNETIC_AIM;
	Template.CritChance = default.WRISTBLADE_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = default.WRISTBLADE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.WRISTBLADE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, default.WRISTBLADE_MAGNETIC_STUNCHANCE, false));

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 30;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseAdventStunLancer';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Template.DamageTypeTemplateName = 'Melee';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.StunChanceLabel, , default.WRISTBLADE_MAGNETIC_STUNCHANCE, , , "%");


	return Template;
}

static function X2DataTemplate CreateTemplate_WristBlade_Beam()
{
	local X2PairedWeaponTemplate Template;
	local WeaponAttachment Attach;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'WristBlade_BM');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'WristBladeLeft_BM';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'wristblade';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_BeamSGauntlet";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SkirmisherGauntlet.WP_SkirmisherGauntlet_BM";
	Template.AltGameArchetype = "WP_SkirmisherGauntlet.WP_SkirmisherGauntlet_F_BM";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 5;
	Template.bUseArmorAppearance = true;

	Attach.AttachSocket = 'R_Claw';
	Attach.AttachMeshName = "SkirmisherGauntlet.Meshes.SM_SkirmisherGauntletR_Claw_M_BM";
	Attach.RequiredGender = eGender_Male;
	Attach.AttachToPawn = true;
	Template.DefaultAttachments.AddItem(Attach);

	Attach.AttachSocket = 'R_Claw';
	Attach.AttachMeshName = "SkirmisherGauntlet.Meshes.SM_SkirmisherGauntletR_Claw_F_BM";
	Attach.RequiredGender = eGender_Female;
	Attach.AttachToPawn = true;
	Template.DefaultAttachments.AddItem(Attach);
	
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 3;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.WRISTBLADE_BEAM_BASEDAMAGE;
	Template.Aim = default.WRISTBLADE_BEAM_AIM;
	Template.CritChance = default.WRISTBLADE_BEAM_CRITCHANCE;
	Template.iSoundRange = default.WRISTBLADE_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.WRISTBLADE_BEAM_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';
	
	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0));

	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 4;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 4;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseArchon';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Template.DamageTypeTemplateName = 'Melee';


	return Template;
}

static function X2DataTemplate CreateTemplate_ShardGauntlet_Magnetic()
{
	local X2PairedWeaponTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'ShardGauntlet_MG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'ShardGauntletLeft_MG';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_MagTGauntlet";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_MG";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_F_MG";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 3;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.SHARDGAUNTLET_MAGNETIC_BASEDAMAGE;
	Template.ExtraDamage = default.SHARDGAUNTLET_MAGNETIC_EXTRADAMAGE;
	Template.Aim = default.SHARDGAUNTLET_MAGNETIC_AIM;
	Template.CritChance = default.SHARDGAUNTLET_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = default.SHARDGAUNTLET_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHARDGAUNTLET_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Psi';

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 35;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseAdventStunLancer';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_ShardGauntlet_Beam()
{
	local X2PairedWeaponTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'ShardGauntlet_BM');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'ShardGauntletLeft_BM';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_BeamTGauntlet";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_BM";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_F_BM";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 5;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.SHARDGAUNTLET_BEAM_BASEDAMAGE;
	Template.ExtraDamage = default.SHARDGAUNTLET_BEAM_EXTRADAMAGE;
	Template.Aim = default.SHARDGAUNTLET_BEAM_AIM;
	Template.CritChance = default.SHARDGAUNTLET_BEAM_CRITCHANCE;
	Template.iSoundRange = default.SHARDGAUNTLET_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHARDGAUNTLET_BEAM_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Psi';

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 55;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 4;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 4;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseArchon';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_Sidearm_Magnetic()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sidearm_MG');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sidearm';
	Template.WeaponTech = 'magnetic';
//BEGIN AUTOGENERATED CODE: Template Overrides 'Sidearm_MG'
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_MagTPistol_Base";
//END AUTOGENERATED CODE: Template Overrides 'Sidearm_MG'
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 3;

	Template.RangeAccuracy = default.TEMPLAR_PISTOL_RANGE;
	Template.BaseDamage = default.SIDEARM_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.SIDEARM_MAGNETIC_AIM;
	Template.CritChance = default.SIDEARM_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.SIDEARM_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.SIDEARM_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SIDEARM_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarAutoPistol_MG.WP_TemplarAutoPistol_MG";

	Template.iPhysicsImpulse = 5;

	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_Sidearm_Beam()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sidearm_BM');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sidearm';
	Template.WeaponTech = 'beam';
//BEGIN AUTOGENERATED CODE: Template Overrides 'Sidearm_BM'
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_BeamTPistol_Base";
//END AUTOGENERATED CODE: Template Overrides 'Sidearm_BM'
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.Tier = 5;

	Template.RangeAccuracy = default.TEMPLAR_PISTOL_RANGE;
	Template.BaseDamage = default.SIDEARM_BEAM_BASEDAMAGE;
	Template.Aim = default.SIDEARM_BEAM_AIM;
	Template.CritChance = default.SIDEARM_BEAM_CRITCHANCE;
	Template.iClipSize = default.SIDEARM_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.SIDEARM_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SIDEARM_BEAM_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotBeamA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarAutoPistol_BM.WP_TemplarAutoPistol_BM";

	Template.iPhysicsImpulse = 5;

	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
    
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 35;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}