//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWGauntlet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for Technical class Gauntlet weapon
//           
//---------------------------------------------------------------------------------------
class X2Item_LWGauntlet extends X2Item config(GameData_WeaponData);

// ***** UI Image definitions  *****
var config string Gauntlet_CV_UIImage;
var config string Gauntlet_MG_UIImage;
var config string Gauntlet_CG_UIImage;
var config string Gauntlet_BM_UIImage;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Gauntlet_Primary_CONVENTIONAL_BASEDAMAGE;  // Rocket
var config WeaponDamageValue Gauntlet_Secondary_CONVENTIONAL_BASEDAMAGE;  // Flamethrower

// ***** Core properties and variables for weapons *****
var config int Gauntlet_Primary_CONVENTIONAL_ICLIPSIZE;
var config int Gauntlet_Primary_CONVENTIONAL_ISOUNDRANGE;
var config int Gauntlet_Primary_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int Gauntlet_Primary_CONVENTIONAL_RANGE;
var config int Gauntlet_Primary_CONVENTIONAL_RADIUS;

var config int Gauntlet_Secondary_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_CONVENTIONAL_OPPOSED_STAT_STRENTH;
var config int Gauntlet_Secondary_CONVENTIONAL_RANGE;
var config int Gauntlet_Secondary_CONVENTIONAL_RADIUS;
var config int Gauntlet_Secondary_CONVENTIONAL_ISOUNDRANGE;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Gauntlet_Primary_MAG_BASEDAMAGE;  // Rocket
var config WeaponDamageValue Gauntlet_Secondary_MAG_BASEDAMAGE;  // Flamethrower

// ***** Core properties and variables for weapons *****
var config int Gauntlet_Primary_MAG_ICLIPSIZE;
var config int Gauntlet_Primary_MAG_ISOUNDRANGE;
var config int Gauntlet_Primary_MAG_IENVIRONMENTDAMAGE;
var config int Gauntlet_Primary_MAG_RANGE;
var config int Gauntlet_Primary_MAG_RADIUS;

var config int Gauntlet_Secondary_MAG_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_MAG_OPPOSED_STAT_STRENTH;
var config int Gauntlet_Secondary_MAG_RANGE;
var config int Gauntlet_Secondary_MAG_RADIUS;
var config int Gauntlet_Secondary_MAG_ISOUNDRANGE;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Gauntlet_Primary_COIL_BASEDAMAGE;  // Rocket
var config WeaponDamageValue Gauntlet_Secondary_COIL_BASEDAMAGE;  // Flamethrower

// ***** Core properties and variables for weapons *****
var config int Gauntlet_Primary_COIL_ICLIPSIZE;
var config int Gauntlet_Primary_COIL_ISOUNDRANGE;
var config int Gauntlet_Primary_COIL_IENVIRONMENTDAMAGE;
var config int Gauntlet_Primary_COIL_RANGE;
var config int Gauntlet_Primary_COIL_RADIUS;

var config int Gauntlet_Secondary_COIL_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_COIL_OPPOSED_STAT_STRENTH;
var config int Gauntlet_Secondary_COIL_RANGE;
var config int Gauntlet_Secondary_COIL_RADIUS;
var config int Gauntlet_Secondary_COIL_ISOUNDRANGE;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Gauntlet_Primary_BEAM_BASEDAMAGE;  // Rocket
var config WeaponDamageValue Gauntlet_Secondary_BEAM_BASEDAMAGE;  // Flamethrower

// ***** Core properties and variables for weapons *****
var config int Gauntlet_Primary_BEAM_ICLIPSIZE;
var config int Gauntlet_Primary_BEAM_ISOUNDRANGE;
var config int Gauntlet_Primary_BEAM_IENVIRONMENTDAMAGE;
var config int Gauntlet_Primary_BEAM_RANGE;
var config int Gauntlet_Primary_BEAM_RADIUS;

var config int Gauntlet_Secondary_BEAM_IENVIRONMENTDAMAGE;
var config int Gauntlet_Secondary_BEAM_OPPOSED_STAT_STRENTH;
var config int Gauntlet_Secondary_BEAM_RANGE;
var config int Gauntlet_Secondary_BEAM_RADIUS;
var config int Gauntlet_Secondary_BEAM_ISOUNDRANGE;

var localized string PrimaryRangeLabel;
var localized string PrimaryRadiusLabel;
var localized string SecondaryRangeLabel;
var localized string SecondaryRadiusLabel;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2Item_LWGauntlet.CreateTemplates()");
	
	Templates.AddItem(CreateTemplate_Gauntlet_Conventional());
	Templates.AddItem(CreateTemplate_Gauntlet_Mag());
	//Templates.AddItem(CreateTemplate_Gauntlet_Coil());
	Templates.AddItem(CreateTemplate_Gauntlet_Beam());
	Templates.AddItem(CreateNapalmDamageType());

	return Templates;
}

static function X2DamageTypeTemplate CreateNapalmDamageType()
{
	local X2DamageTypeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DamageTypeTemplate', Template, 'Napalm');

	Template.bCauseFracture = false;
	Template.MaxFireCount = 0; //Fire damage is the result of fire, not a cause
	Template.bAllowAnimatedDeath = true;

	return Template;
}

// Initial Gauntlet uses Pistol model and artwork until new artwork is complete
static function X2DataTemplate CreateTemplate_Gauntlet_Conventional()
{
	local X2MultiWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_CV');
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lw_gauntlet';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.Gauntlet_CV_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 0;

	Template.BaseDamage = default.Gauntlet_Primary_CONVENTIONAL_BASEDAMAGE;
	Template.iSoundRange = default.Gauntlet_Primary_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Gauntlet_Primary_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.Gauntlet_Primary_CONVENTIONAL_ICLIPSIZE;
	Template.InfiniteAmmo = true;
	Template.iRange = default.Gauntlet_Primary_CONVENTIONAL_RANGE;
	Template.iRadius = default.Gauntlet_Primary_CONVENTIONAL_RADIUS;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.iStatStrength=0;
	Template.bMergeAmmo=true;
    Template.bSoundOriginatesFromOwnerLocation=false;

	Template.AltBaseDamage = default.Gauntlet_Secondary_CONVENTIONAL_BASEDAMAGE;
	Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.iAltStatStrength=default.Gauntlet_Secondary_CONVENTIONAL_OPPOSED_STAT_STRENTH;
	Template.iAltRange = default.Gauntlet_Secondary_CONVENTIONAL_RANGE;
	Template.iAltRadius = default.Gauntlet_Secondary_CONVENTIONAL_RADIUS;
    Template.iAltSoundRange = default.Gauntlet_Secondary_CONVENTIONAL_ISOUNDRANGE;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_RocketLauncher_CV";

	Template.Abilities.AddItem('LWRocketLauncher');
	Template.Abilities.AddItem('RocketFuse');
	Template.Abilities.AddItem('LWFlamethrower');

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	
	Template.DamageTypeTemplateName = 'Electrical';

	Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_CONVENTIONAL_RANGE);
	Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_CONVENTIONAL_RADIUS);
	Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RANGE);
	Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RADIUS);

	return Template;
}

static function X2DataTemplate CreateTemplate_Gauntlet_Mag()
{
	local X2MultiWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_MG');
	Template.EquipSound = "MAG_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lw_gauntlet';
	Template.WeaponTech = 'Magnetic';
	Template.strImage = default.Gauntlet_MG_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	//Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 2;

	Template.BaseDamage = default.Gauntlet_Primary_MAG_BASEDAMAGE;
	Template.iSoundRange = default.Gauntlet_Primary_MAG_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Gauntlet_Primary_MAG_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.Gauntlet_Primary_MAG_ICLIPSIZE;
	Template.InfiniteAmmo = true;
	Template.iRange = default.Gauntlet_Primary_MAG_RANGE;
	Template.iRadius = default.Gauntlet_Primary_MAG_RADIUS;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.iStatStrength=0;
	Template.bMergeAmmo=true;
    Template.bSoundOriginatesFromOwnerLocation=false;

	Template.AltBaseDamage = default.Gauntlet_Secondary_MAG_BASEDAMAGE;
	Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_MAG_IENVIRONMENTDAMAGE;
	Template.iAltStatStrength=default.Gauntlet_Secondary_MAG_OPPOSED_STAT_STRENTH;
	Template.iAltRange = default.Gauntlet_Secondary_MAG_RANGE;
	Template.iAltRadius = default.Gauntlet_Secondary_MAG_RADIUS;
    Template.iAltSoundRange = default.Gauntlet_Secondary_MAG_ISOUNDRANGE;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_RocketLauncher_MG";

	Template.Abilities.AddItem('LWRocketLauncher');
	Template.Abilities.AddItem('RocketFuse');
	Template.Abilities.AddItem('LWFlamethrower');

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	
	Template.DamageTypeTemplateName = 'Electrical';

	Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_MAG_RANGE);
	Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_MAG_RADIUS);
	Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_MAG_RANGE);
	Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_MAG_RADIUS);

	return Template;
}

static function X2DataTemplate CreateTemplate_Gauntlet_COIL()
{
	local X2MultiWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_CG');
	Template.EquipSound = "Magnetic_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lw_gauntlet';
	Template.WeaponTech = 'Coil';
	Template.strImage = default.Gauntlet_CG_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_COIL";
	//Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 3;

	Template.BaseDamage = default.Gauntlet_Primary_COIL_BASEDAMAGE;
	Template.iSoundRange = default.Gauntlet_Primary_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Gauntlet_Primary_COIL_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.Gauntlet_Primary_COIL_ICLIPSIZE;
	Template.InfiniteAmmo = true;
	Template.iRange = default.Gauntlet_Primary_COIL_RANGE;
	Template.iRadius = default.Gauntlet_Primary_COIL_RADIUS;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.iStatStrength=0;
	Template.bMergeAmmo=true;
    Template.bSoundOriginatesFromOwnerLocation=false;

	Template.AltBaseDamage = default.Gauntlet_Secondary_COIL_BASEDAMAGE;
	Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_COIL_IENVIRONMENTDAMAGE;
	Template.iAltStatStrength=default.Gauntlet_Secondary_COIL_OPPOSED_STAT_STRENTH;
	Template.iAltRange = default.Gauntlet_Secondary_COIL_RANGE;
	Template.iAltRadius = default.Gauntlet_Secondary_COIL_RADIUS;
    Template.iAltSoundRange = default.Gauntlet_Secondary_COIL_ISOUNDRANGE;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_RocketLauncher_CG";

	Template.Abilities.AddItem('LWRocketLauncher');
	Template.Abilities.AddItem('RocketFuse');
	Template.Abilities.AddItem('LWFlamethrower');

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	
	Template.DamageTypeTemplateName = 'Electrical';

	Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_COIL_RANGE);
	Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_COIL_RADIUS);
	Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_COIL_RANGE);
	Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_COIL_RADIUS);

	return Template;
}

static function X2DataTemplate CreateTemplate_Gauntlet_Beam()
{
	local X2MultiWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2MultiWeaponTemplate', Template, 'LWGauntlet_BM');
	Template.EquipSound = "Beam_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lw_gauntlet';
	Template.WeaponTech = 'beam';
	Template.strImage = default.Gauntlet_BM_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	//Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 4;

	Template.BaseDamage = default.Gauntlet_Primary_BEAM_BASEDAMAGE;
	Template.iSoundRange = default.Gauntlet_Primary_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Gauntlet_Primary_BEAM_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.Gauntlet_Primary_BEAM_ICLIPSIZE;
	Template.InfiniteAmmo = true;
	Template.iRange = default.Gauntlet_Primary_BEAM_RANGE;
	Template.iRadius = default.Gauntlet_Primary_BEAM_RADIUS;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.iStatStrength=0;
	Template.bMergeAmmo=true;
    Template.bSoundOriginatesFromOwnerLocation=false;

	Template.AltBaseDamage = default.Gauntlet_Secondary_BEAM_BASEDAMAGE;
	Template.iAltEnvironmentDamage = default.Gauntlet_Secondary_BEAM_IENVIRONMENTDAMAGE;
	Template.iAltStatStrength=default.Gauntlet_Secondary_BEAM_OPPOSED_STAT_STRENTH;
	Template.iAltRange = default.Gauntlet_Secondary_BEAM_RANGE;
	Template.iAltRadius = default.Gauntlet_Secondary_BEAM_RADIUS;
    Template.iAltSoundRange = default.Gauntlet_Secondary_BEAM_ISOUNDRANGE;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_BlasterLauncher_BM";

	Template.Abilities.AddItem('LWBlasterLauncher');
	Template.Abilities.AddItem('RocketFuse');
	Template.Abilities.AddItem('LWFlamethrower');

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	
	Template.DamageTypeTemplateName = 'Electrical';

	Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_BEAM_RANGE);
	Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_BEAM_RADIUS);
	Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_BEAM_RANGE);
	Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_BEAM_RADIUS);

	return Template;
}


defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
