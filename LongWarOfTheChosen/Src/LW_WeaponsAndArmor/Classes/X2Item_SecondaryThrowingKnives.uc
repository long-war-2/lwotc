//---------------------------------------------------------------------------------------
//  FILE:    X2Item_SecondaryThrowingKnives.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Based on Musashi's class of the same name from the Combat Knives mod,
//           this creates secondary weapon versions of throwing knives. This was
//           originally added to grant throwing knives as a secondary weapon for
//           Reapers, but they can be configured for any soldier class. Note that
//           Musashi's mod does NOT create these templates itself, it just has the
//           code to do so.
//---------------------------------------------------------------------------------------
class X2Item_SecondaryThrowingKnives extends X2Item config(GameData_WeaponData);

var config int THROWING_KNIFE_CHARGES;
var config int THROWING_KNIFE_AIM;
var config int THROWING_KNIFE_CRITCHANCE;
var config int THROWING_KNIFE_ISOUNDRANGE;
var config int THROWING_KNIFE_IENVIRONMENTDAMAGE;

var config WeaponDamageValue THROWING_KNIFE_CV_BASEDAMAGE;
var config WeaponDamageValue THROWING_KNIFE_MG_BASEDAMAGE;
var config WeaponDamageValue THROWING_KNIFE_BM_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ModWeapons;
	ModWeapons.AddItem(CreateTemplate_ThrowingKnife_CV_Secondary());
	ModWeapons.AddItem(CreateTemplate_ThrowingKnife_MG_Secondary());
	ModWeapons.AddItem(CreateTemplate_ThrowingKnife_BM_Secondary());
	return ModWeapons;
}

static function X2DataTemplate CreateTemplate_ThrowingKnife_CV_Secondary()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ThrowingKnife_CV_Secondary');

	InitializeThrowingKnifeTemplate(Template);
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///MusashiCombatKnifeMod_LW.UI.UI_Kunai_CV";
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "MusashiCombatKnifeMod_LW.Archetypes.WP_Kunai";
	Template.Tier = 1;

	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;

	Template.BaseDamage = default.THROWING_KNIFE_CV_BASEDAMAGE;

	return Template;
}

static function X2DataTemplate CreateTemplate_ThrowingKnife_MG_Secondary()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ThrowingKnife_MG_Secondary');

	InitializeThrowingKnifeTemplate(Template);
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///MusashiCombatKnifeMod_LW.UI.UI_Kunai_MG";
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "MusashiCombatKnifeMod_LW.Archetypes.WP_Kunai_MG";
	Template.Tier = 3;

	Template.StartingItem = false;
	Template.bInfiniteItem = false;
	Template.CanBeBuilt = true;
	Template.BaseItem = 'ThrowingKnife_CV_Secondary'; // Which item this will be upgraded from

	Template.BaseDamage = default.THROWING_KNIFE_MG_BASEDAMAGE;

	return Template;
}

static function X2DataTemplate CreateTemplate_ThrowingKnife_BM_Secondary()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ThrowingKnife_BM_Secondary');

	InitializeThrowingKnifeTemplate(Template);
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///MusashiCombatKnifeMod_LW.UI.UI_Kunai_BM";
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "MusashiCombatKnifeMod_LW.Archetypes.WP_Kunai_BM";
	Template.Tier = 5;

	Template.StartingItem = false;
	Template.bInfiniteItem = false;
	Template.CanBeBuilt = true;
	Template.BaseItem = 'ThrowingKnife_MG_Secondary'; // Which item this will be upgraded from

	Template.BaseDamage = default.THROWING_KNIFE_BM_BASEDAMAGE;

	return Template;
}

static function X2WeaponTemplate InitializeThrowingKnifeTemplate(X2WeaponTemplate Template)
{
	Template.WeaponPanelImage = "_Sword";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'throwingknife';
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_BeltHolster;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;

	Template.RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_CONVENTIONAL_RANGE;
	Template.Aim = default.THROWING_KNIFE_AIM;
	Template.CritChance = default.THROWING_KNIFE_CRITCHANCE;
	Template.iSoundRange = default.THROWING_KNIFE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.THROWING_KNIFE_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.InfiniteAmmo = false;
	Template.iClipSize = default.THROWING_KNIFE_CHARGES;
	Template.iPhysicsImpulse = 5;
	Template.bHideWithNoAmmo = false;
	Template.bMergeAmmo = true;
	Template.DamageTypeTemplateName = 'DefaultProjectile';

	Template.WeaponPrecomputedPathData.InitialPathTime = 1.50;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.Abilities.AddItem('MusashiThrowKnifeSecondary_LW');

	Template.SetAnimationNameForAbility('Hailstorm', 'FF_HailStormA');

	return Template;
}
