//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWHolotargeter.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for holotargeter Sharpshooter secondary weapon
//           
//---------------------------------------------------------------------------------------
class X2Item_LWHolotargeter extends X2Item config(GameData_WeaponData);

// ***** UI Image definitions  *****
var config string Holotargeter_CV_UIImage;
var config string Holotargeter_MG_UIImage;
var config string Holotargeter_BM_UIImage;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Holotargeter_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue Holotargeter_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue Holotargeter_BEAM_BASEDAMAGE;

// ***** Core properties and variables for weapons *****
var config int Holotargeter_CONVENTIONAL_AIM;
var config int Holotargeter_CONVENTIONAL_RADIUS;  // used only for multitargeting ability
var config int Holotargeter_CONVENTIONAL_CRITCHANCE;
var config int Holotargeter_CONVENTIONAL_ICLIPSIZE;
var config int Holotargeter_CONVENTIONAL_ISOUNDRANGE;
var config int Holotargeter_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int Holotargeter_CONVENTIONAL_ISUPPLIES;
var config int Holotargeter_CONVENTIONAL_TRADINGPOSTVALUE;
var config int Holotargeter_CONVENTIONAL_IPOINTS;

var config int Holotargeter_MAGNETIC_AIM;
var config int Holotargeter_MAGNETIC_RADIUS;  // used only for multitargeting ability
var config int Holotargeter_MAGNETIC_CRITCHANCE;
var config int Holotargeter_MAGNETIC_ICLIPSIZE;
var config int Holotargeter_MAGNETIC_ISOUNDRANGE;
var config int Holotargeter_MAGNETIC_IENVIRONMENTDAMAGE;
var config int Holotargeter_MAGNETIC_ISUPPLIES;
var config int Holotargeter_MAGNETIC_TRADINGPOSTVALUE;
var config int Holotargeter_MAGNETIC_IPOINTS;

var config int Holotargeter_BEAM_AIM;
var config int Holotargeter_BEAM_RADIUS;  // used only for multitargeting ability
var config int Holotargeter_BEAM_CRITCHANCE;
var config int Holotargeter_BEAM_ICLIPSIZE;
var config int Holotargeter_BEAM_ISOUNDRANGE;
var config int Holotargeter_BEAM_IENVIRONMENTDAMAGE;
var config int Holotargeter_BEAM_ISUPPLIES;
var config int Holotargeter_BEAM_TRADINGPOSTVALUE;
var config int Holotargeter_BEAM_IPOINTS;

// ***** Schematic properties *****
var config int Holotargeter_MAGNETIC_SCHEMATIC_SUPPLYCOST;
var config int Holotargeter_BEAM_SCHEMATIC_SUPPLYCOST;

var config int Holotargeter_MAGNETIC_SCHEMATIC_ALLOYCOST;
var config int Holotargeter_BEAM_SCHEMATIC_ALLOYCOST;

var config int Holotargeter_MAGNETIC_SCHEMATIC_ELERIUMCOST;
var config int Holotargeter_BEAM_SCHEMATIC_ELERIUMCOST;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2Item_LWHolotargeter.CreateTemplates()");
	
	//create all three tech tiers of weapons
	Templates.AddItem(CreateTemplate_Holotargeter_Conventional());
	Templates.AddItem(CreateTemplate_Holotargeter_Magnetic());
	Templates.AddItem(CreateTemplate_Holotargeter_Beam());

	//create two schematics used to upgrade weapons
	//Templates.AddItem(CreateTemplate_Holotargeter_Magnetic_Schematic());
	//Templates.AddItem(CreateTemplate_Holotargeter_Beam_Schematic());

	return Templates;
}

// Initial Holotargeter uses Pistol model and artwork until new artwork is complete
static function X2DataTemplate CreateTemplate_Holotargeter_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holotargeter_CV');
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'holotargeter';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.Holotargeter_CV_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.Holotargeter_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.Holotargeter_CONVENTIONAL_AIM;
	Template.iRadius = default.Holotargeter_CONVENTIONAL_RADIUS; // used only for multitargeting ability
	Template.CritChance = default.Holotargeter_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.Holotargeter_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.Holotargeter_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Holotargeter_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideDamageStat = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWHolotargeter.Archetypes.WP_Holotargeter_CV";

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	
	Template.DamageTypeTemplateName = 'Electrical';
	
	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_Holotargeter_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holotargeter_MG');

	Template.WeaponCat = 'holotargeter';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = default.Holotargeter_MG_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 2;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.Holotargeter_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.Holotargeter_MAGNETIC_AIM;
	Template.iRadius = default.Holotargeter_MAGNETIC_RADIUS; // used only for multitargeting ability
	Template.CritChance = default.Holotargeter_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.Holotargeter_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.Holotargeter_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Holotargeter_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideDamageStat = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWHolotargeter.Archetypes.WP_Holotargeter_MG";

	Template.iPhysicsImpulse = 5;
	
	Template.CreatorTemplateName = 'Holotargeter_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Holotargeter_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Electrical';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_Holotargeter_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Holotargeter_BM');

	Template.WeaponCat = 'holotargeter';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = default.Holotargeter_BM_UIImage;
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 4;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.Holotargeter_BEAM_BASEDAMAGE;
	Template.Aim = default.Holotargeter_BEAM_AIM;
	Template.iRadius = default.Holotargeter_BEAM_RADIUS; // used only for multitargeting ability
	Template.CritChance = default.Holotargeter_BEAM_CRITCHANCE;
	Template.iClipSize = default.Holotargeter_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.Holotargeter_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Holotargeter_BEAM_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideDamageStat = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWHolotargeter.Archetypes.WP_Holotargeter_BM";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Holotargeter_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Holotargeter_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Electrical';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_Holotargeter_Magnetic_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Holotargeter_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Holotargeter_MG_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Holotargeter_MG';
	Template.HideIfPurchased = 'Holotargeter_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);
	
	// only add elerium cost if configured value greater than 0
	if (default.Holotargeter_MAGNETIC_SCHEMATIC_ELERIUMCOST > 0) {
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.Holotargeter_MAGNETIC_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

static function X2DataTemplate CreateTemplate_Holotargeter_Beam_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Holotargeter_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Holotargeter_BM_UIImage;
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Holotargeter_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Holotargeter_BEAM_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.Holotargeter_BEAM_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'EleriumDust';
	Artifacts.Quantity = default.Holotargeter_BEAM_SCHEMATIC_ELERIUMCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
