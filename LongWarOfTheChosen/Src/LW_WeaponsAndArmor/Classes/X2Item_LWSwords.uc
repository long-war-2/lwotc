// This is an Unreal Script
class X2Item_LWSwords extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue RANGERSWORD_LASER_BASEDAMAGE;

var config int RANGERSWORD_LASER_AIM;
var config int RANGERSWORD_LASER_CRITCHANCE;
var config int RANGERSWORD_LASER_ICLIPSIZE;
var config int RANGERSWORD_LASER_ISOUNDRANGE;
var config int RANGERSWORD_LASER_IENVIRONMENTDAMAGE;

var config WeaponDamageValue RANGERSWORD_COIL_BASEDAMAGE;

var config int RANGERSWORD_COIL_AIM;
var config int RANGERSWORD_COIL_CRITCHANCE;
var config int RANGERSWORD_COIL_ICLIPSIZE;
var config int RANGERSWORD_COIL_ISOUNDRANGE;
var config int RANGERSWORD_COIL_IENVIRONMENTDAMAGE;


static function array<X2DataTemplate> CreateTemplates()
{	local array<X2DataTemplate> Weapons;
	Weapons.AddItem(CreateTemplate_Sword_Laser());
	Weapons.AddItem(CreateTemplate_Sword_Coil());
	
	return Weapons;
}

static function X2DataTemplate CreateTemplate_Sword_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sword_LS');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'laser_lw';
	Template.strImage = "img:///UILibrary_Common.BeamSecondaryWeapons.BeamSword";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Sword_BM.WP_Sword_BM";
	Template.Tier = 4;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.RANGERSWORD_LASER_BASEDAMAGE;
	Template.Aim = default.RANGERSWORD_LASER_AIM;
	Template.CritChance = default.RANGERSWORD_LASER_CRITCHANCE;
	Template.iSoundRange = default.RANGERSWORD_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.RANGERSWORD_LASER_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType='Melee';

	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;
}


static function X2DataTemplate CreateTemplate_Sword_Coil()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sword_CG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'coilgun_lw';
	Template.strImage = "img:///UILibrary_Common.BeamSecondaryWeapons.BeamSword";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Sword_BM.WP_Sword_BM";
	Template.Tier = 4;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.RANGERSWORD_COIL_BASEDAMAGE;
	Template.Aim = default.RANGERSWORD_COIL_AIM;
	Template.CritChance = default.RANGERSWORD_COIL_CRITCHANCE;
	Template.iSoundRange = default.RANGERSWORD_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.RANGERSWORD_COIL_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType='Melee';

	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;
}
