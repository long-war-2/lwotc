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

	`LWTrace("  >> X2Item_LWPistol.CreateTemplates()");

	Weapons.AddItem(CreateTemplate_LWPistol_Laser());
	Weapons.AddItem(CreateTemplate_LWPistol_Coil());

	return Weapons;
}

// **************************************************************************
// ***                          LWPistol                                  ***
// **************************************************************************
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

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RearBackPack;
	// PistolStandardShot is added by Pistol Slot mod
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

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RearBackPack;
	// PistolStandardShot is added by Pistol Slot mod
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
