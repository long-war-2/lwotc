//---------------------------------------------------------------------------------------
//  FILE:    X2Item_ArcthrowerWeapon.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for Arcthrower secondary weapon
//           
//---------------------------------------------------------------------------------------
class X2Item_ArcthrowerWeapon extends X2Item config(GameData_WeaponData);

// ***** UI Image definitions  *****
var config string Arcthrower_CV_UIImage;
var config string Arcthrower_MG_UIImage;
var config string Arcthrower_BM_UIImage;

// ***** Damage arrays for attack actions  *****
var config WeaponDamageValue Arcthrower_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue Arcthrower_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue Arcthrower_BEAM_BASEDAMAGE;

// ***** Core properties and variables for weapons *****
var config int Arcthrower_CONVENTIONAL_AIM;
var config int Arcthrower_CONVENTIONAL_CRITCHANCE;
var config int Arcthrower_CONVENTIONAL_ICLIPSIZE;
var config int Arcthrower_CONVENTIONAL_ISOUNDRANGE;
var config int Arcthrower_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int Arcthrower_CONVENTIONAL_ISUPPLIES;
var config int Arcthrower_CONVENTIONAL_TRADINGPOSTVALUE;
var config int Arcthrower_CONVENTIONAL_IPOINTS;

var config int Arcthrower_MAGNETIC_AIM;
var config int Arcthrower_MAGNETIC_CRITCHANCE;
var config int Arcthrower_MAGNETIC_ICLIPSIZE;
var config int Arcthrower_MAGNETIC_ISOUNDRANGE;
var config int Arcthrower_MAGNETIC_IENVIRONMENTDAMAGE;
var config int Arcthrower_MAGNETIC_ISUPPLIES;
var config int Arcthrower_MAGNETIC_TRADINGPOSTVALUE;
var config int Arcthrower_MAGNETIC_IPOINTS;

var config int Arcthrower_BEAM_AIM;
var config int Arcthrower_BEAM_CRITCHANCE;
var config int Arcthrower_BEAM_ICLIPSIZE;
var config int Arcthrower_BEAM_ISOUNDRANGE;
var config int Arcthrower_BEAM_IENVIRONMENTDAMAGE;
var config int Arcthrower_BEAM_ISUPPLIES;
var config int Arcthrower_BEAM_TRADINGPOSTVALUE;
var config int Arcthrower_BEAM_IPOINTS;

// ***** Schematic properties *****
var config int Arcthrower_MAGNETIC_SCHEMATIC_SUPPLYCOST;
var config int Arcthrower_BEAM_SCHEMATIC_SUPPLYCOST;

var config int Arcthrower_MAGNETIC_SCHEMATIC_ALLOYCOST;
var config int Arcthrower_BEAM_SCHEMATIC_ALLOYCOST;

var config int Arcthrower_MAGNETIC_SCHEMATIC_ELERIUMCOST;
var config int Arcthrower_BEAM_SCHEMATIC_ELERIUMCOST;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	//create all three tech tiers of weapons
	Templates.AddItem(CreateTemplate_Arcthrower_Conventional());
	Templates.AddItem(CreateTemplate_Arcthrower_Magnetic());
	Templates.AddItem(CreateTemplate_Arcthrower_Beam());

	//create two schematics used to upgrade weapons
	//Templates.AddItem(CreateTemplate_Arcthrower_Magnetic_Schematic());
	//Templates.AddItem(CreateTemplate_Arcthrower_Beam_Schematic());

	return Templates;
}

// Initial Arcthrower uses Pistol model and artwork until new artwork is complete
static function X2DataTemplate CreateTemplate_Arcthrower_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Arcthrower_CV');
	Template.AddAbilityIconOverride('EMPulser', "img:///UILibrary_LW_Overhaul.LW_AbilityArcthrowerStun");
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'arcthrower';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.Arcthrower_CV_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 0;


	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.Arcthrower_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.Arcthrower_CONVENTIONAL_AIM;
	Template.CritChance = default.Arcthrower_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.Arcthrower_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.Arcthrower_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Arcthrower_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWArcthrower.Archetypes.WP_Arcthrower_CV";

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	
	Template.DamageTypeTemplateName = 'Electrical';

	return Template;
}

static function X2DataTemplate CreateTemplate_Arcthrower_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Arcthrower_MG');
	Template.AddAbilityIconOverride('EMPulser', "img:///UILibrary_LW_Overhaul.LW_AbilityArcthrowerStun");
	Template.WeaponCat = 'arcthrower';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = default.Arcthrower_MG_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 2;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
	Template.BaseDamage = default.Arcthrower_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.Arcthrower_MAGNETIC_AIM;
	Template.CritChance = default.Arcthrower_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.Arcthrower_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.Arcthrower_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Arcthrower_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWArcthrower.Archetypes.WP_Arcthrower_MG";

	Template.iPhysicsImpulse = 5;
	
	Template.CreatorTemplateName = 'Arcthrower_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Arcthrower_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Electrical';

	return Template;
}

static function X2DataTemplate CreateTemplate_Arcthrower_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Arcthrower_BM');
	Template.AddAbilityIconOverride('EMPulser', "img:///UILibrary_LW_Overhaul.LW_AbilityArcthrowerStun");
	Template.WeaponCat = 'arcthrower';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = default.Arcthrower_BM_UIImage; 
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 4;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
	Template.BaseDamage = default.Arcthrower_BEAM_BASEDAMAGE;
	Template.Aim = default.Arcthrower_BEAM_AIM;
	Template.CritChance = default.Arcthrower_BEAM_CRITCHANCE;
	Template.iClipSize = default.Arcthrower_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.Arcthrower_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.Arcthrower_BEAM_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWArcthrower.Archetypes.WP_Arcthrower_BM";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Arcthrower_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Arcthrower_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Electrical';

	return Template;
}

static function X2DataTemplate CreateTemplate_Arcthrower_Magnetic_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Arcthrower_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Arcthrower_MG_UIImage; 
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Arcthrower_MG';
	Template.HideIfPurchased = 'Arcthrower_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);
	
	// only add elerium cost if configured value greater than 0
	if (default.Arcthrower_MAGNETIC_SCHEMATIC_ELERIUMCOST > 0) {
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.Arcthrower_MAGNETIC_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

static function X2DataTemplate CreateTemplate_Arcthrower_Beam_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Arcthrower_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = default.Arcthrower_BM_UIImage; 
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Arcthrower_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Arcthrower_BEAM_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.Arcthrower_BEAM_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'EleriumDust';
	Artifacts.Quantity = default.Arcthrower_BEAM_SCHEMATIC_ELERIUMCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
