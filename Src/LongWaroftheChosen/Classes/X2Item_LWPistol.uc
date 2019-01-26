//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWPistol.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for pistols in utility slots (vice secondary slots on Sharpshooter)
//---------------------------------------------------------------------------------------
class X2Item_LWPistol extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue LWPISTOL_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue LWPISTOL_LASER_BASEDAMAGE;
var config WeaponDamageValue LWPISTOL_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue LWPISTOL_COIL_BASEDAMAGE;
var config WeaponDamageValue LWPISTOL_BEAM_BASEDAMAGE;

var config int LWPISTOL_CONVENTIONAL_AIM;
var config int LWPISTOL_CONVENTIONAL_CRITCHANCE;
var config int LWPISTOL_CONVENTIONAL_ICLIPSIZE;
var config int LWPISTOL_CONVENTIONAL_ISOUNDRANGE;
var config int LWPISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;

var config int LWPISTOL_MAGNETIC_AIM;
var config int LWPISTOL_MAGNETIC_CRITCHANCE;
var config int LWPISTOL_MAGNETIC_ICLIPSIZE;
var config int LWPISTOL_MAGNETIC_ISOUNDRANGE;
var config int LWPISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

var config int LWPISTOL_LASER_AIM;
var config int LWPISTOL_LASER_CRITCHANCE;
var config int LWPISTOL_LASER_ICLIPSIZE;
var config int LWPISTOL_LASER_ISOUNDRANGE;
var config int LWPISTOL_LASER_IENVIRONMENTDAMAGE;

var config int LWPISTOL_COIL_AIM;
var config int LWPISTOL_COIL_CRITCHANCE;
var config int LWPISTOL_COIL_ICLIPSIZE;
var config int LWPISTOL_COIL_ISOUNDRANGE;
var config int LWPISTOL_COIL_IENVIRONMENTDAMAGE;

var config int LWPISTOL_BEAM_AIM;
var config int LWPISTOL_BEAM_CRITCHANCE;
var config int LWPISTOL_BEAM_ICLIPSIZE;
var config int LWPISTOL_BEAM_ISOUNDRANGE;
var config int LWPISTOL_BEAM_IENVIRONMENTDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_LWPistol_Conventional());
	Weapons.AddItem(CreateTemplate_LWPistol_Laser());
	Weapons.AddItem(CreateTemplate_LWPistol_Magnetic());
	Weapons.AddItem(CreateTemplate_LWPistol_Coil());
	Weapons.AddItem(CreateTemplate_LWPistol_Beam());

	return Weapons;
}

// **************************************************************************
// ***                          LWPistol                                    ***
// **************************************************************************
static function X2DataTemplate CreateTemplate_LWPistol_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWPistol_CV');
	Template.WeaponPanelImage = "_LWPistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.ConvPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.LWPistol_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.LWPistol_CONVENTIONAL_AIM;
	Template.CritChance = default.LWPistol_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.LWPistol_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.LWPistol_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LWPistol_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 1;

	Template.InfiniteAmmo = true;
	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotConvA');	
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_CV.WP_Pistol_CV";

	Template.iPhysicsImpulse = 5;
	
	Template.StartingItem = true;
	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_LWPistol_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWPistol_LS');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'pulse';
	Template.strImage = "img:///UILibrary_LW_LaserPack.Inv_Laser_Pistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = class'X2Item_LaserWeapons'.default.MIDSHORT_LASER_RANGE;
	Template.BaseDamage = default.LWPistol_LASER_BASEDAMAGE;
	Template.Aim = default.LWPistol_LASER_AIM;
	Template.CritChance = default.LWPistol_LASER_CRITCHANCE;
	Template.iClipSize = default.LWPistol_LASER_ICLIPSIZE;
	Template.iSoundRange = default.LWPistol_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LWPistol_LASER_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 0;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddiTem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWPistol_LS.Archetype.WP_Pistol_LS";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Pistol_LS_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Pistol_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';  

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_LWPistol_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWPistol_MG');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.LWPistol_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.LWPistol_MAGNETIC_AIM;
	Template.CritChance = default.LWPistol_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.LWPistol_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.LWPistol_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LWPistol_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddiTem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG.WP_Pistol_MG";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'LWPistol_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'LWPistol_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_LWPistol_Coil()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWPistol_CG');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_Coil_Pistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 4;

	Template.RangeAccuracy = class'X2Item_Coilguns'.default.MIDSHORT_COIL_RANGE;
	Template.BaseDamage = default.LWPistol_COIL_BASEDAMAGE;
	Template.Aim = default.LWPistol_COIL_AIM;
	Template.CritChance = default.LWPistol_COIL_CRITCHANCE;
	Template.iClipSize = default.LWPistol_COIL_ICLIPSIZE;
	Template.iSoundRange = default.LWPistol_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LWPistol_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddiTem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWPistol_CG.Archetypes.WP_Pistol_CG";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Pistol_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Pistol_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';  

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_LWPistol_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWPistol_BM');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.BeamSecondaryWeapons.BeamPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.Tier = 5;

	Template.RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_BEAM_RANGE;
	Template.BaseDamage = default.LWPistol_BEAM_BASEDAMAGE;
	Template.Aim = default.LWPistol_BEAM_AIM;
	Template.CritChance = default.LWPistol_BEAM_CRITCHANCE;
	Template.iClipSize = default.LWPistol_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.LWPistol_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LWPistol_BEAM_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;
	
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.Abilities.AddiTem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotBeamA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_BM.WP_Pistol_BM";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'LWPistol_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'LWPistol_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}