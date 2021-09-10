//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWCombatKnife.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines everything needed for CombatKnife Gunner secondary weapon
//           
//---------------------------------------------------------------------------------------
class X2Item_LWCombatKnife extends X2Item config(GameData_WeaponData);

// ***** UI Image definitions *****
var config string CombatKnife_CV_UIImage;
var config string CombatKnife_MG_UIImage;
var config string CombatKnife_BM_UIImage;

// ***** Damage arrays for attack actions *****
var config WeaponDamageValue CombatKnife_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue CombatKnife_LASER_BASEDAMAGE;
var config WeaponDamageValue CombatKnife_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue CombatKnife_COIL_BASEDAMAGE;
var config WeaponDamageValue CombatKnife_BEAM_BASEDAMAGE;

// ***** Core properties and variables for weapons *****
var config int CombatKnife_CONVENTIONAL_AIM;
var config int CombatKnife_CONVENTIONAL_CRITCHANCE;
var config int CombatKnife_CONVENTIONAL_ICLIPSIZE;
var config int CombatKnife_CONVENTIONAL_ISOUNDRANGE;
var config int CombatKnife_CONVENTIONAL_IENVIRONMENTDAMAGE;
var config int CombatKnife_CONVENTIONAL_ISUPPLIES;
var config int CombatKnife_CONVENTIONAL_TRADINGPOSTVALUE;
var config int CombatKnife_CONVENTIONAL_IPOINTS;

var config int CombatKnife_LASER_AIM;
var config int CombatKnife_LASER_CRITCHANCE;
var config int CombatKnife_LASER_ICLIPSIZE;
var config int CombatKnife_LASER_ISOUNDRANGE;
var config int CombatKnife_LASER_IENVIRONMENTDAMAGE;
var config int CombatKnife_LASER_ISUPPLIES;
var config int CombatKnife_LASER_TRADINGPOSTVALUE;
var config int CombatKnife_LASER_IPOINTS;

var config int CombatKnife_MAGNETIC_AIM;
var config int CombatKnife_MAGNETIC_CRITCHANCE;
var config int CombatKnife_MAGNETIC_ICLIPSIZE;
var config int CombatKnife_MAGNETIC_ISOUNDRANGE;
var config int CombatKnife_MAGNETIC_IENVIRONMENTDAMAGE;
var config int CombatKnife_MAGNETIC_ISUPPLIES;
var config int CombatKnife_MAGNETIC_TRADINGPOSTVALUE;
var config int CombatKnife_MAGNETIC_IPOINTS;

var config int CombatKnife_COIL_AIM;
var config int CombatKnife_COIL_CRITCHANCE;
var config int CombatKnife_COIL_ICLIPSIZE;
var config int CombatKnife_COIL_ISOUNDRANGE;
var config int CombatKnife_COIL_IENVIRONMENTDAMAGE;
var config int CombatKnife_COIL_ISUPPLIES;
var config int CombatKnife_COIL_TRADINGPOSTVALUE;
var config int CombatKnife_COIL_IPOINTS;

var config int CombatKnife_BEAM_AIM;
var config int CombatKnife_BEAM_CRITCHANCE;
var config int CombatKnife_BEAM_ICLIPSIZE;
var config int CombatKnife_BEAM_ISOUNDRANGE;
var config int CombatKnife_BEAM_IENVIRONMENTDAMAGE;
var config int CombatKnife_BEAM_ISUPPLIES;
var config int CombatKnife_BEAM_TRADINGPOSTVALUE;
var config int CombatKnife_BEAM_IPOINTS;

// ***** Schematic properties *****
var config int CombatKnife_MAGNETIC_SCHEMATIC_SUPPLYCOST;

var config int CombatKnife_MAGNETIC_SCHEMATIC_ALLOYCOST;

var config int CombatKnife_MAGNETIC_SCHEMATIC_ELERIUMCOST;



static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2Item_LWCombatKnife.CreateTemplates()");
	
	//create all three tech tiers of weapons
	Templates.AddItem(CreateTemplate_CombatKnife_Conventional());
	Templates.AddItem(CreateTemplate_CombatKnife_Laser());
	Templates.AddItem(CreateTemplate_CombatKnife_Magnetic());
	Templates.AddItem(CreateTemplate_CombatKnife_Coil());
	Templates.AddItem(CreateTemplate_CombatKnife_Beam()); 

	//create two schematics used to upgrade weapons
	//Templates.AddItem(CreateTemplate_CombatKnife_Magnetic_Schematic());
	//Templates.AddItem(CreateTemplate_CombatKnife_Beam_Schematic()); Not used -- JL

	return Templates;
}

// Initial CombatKnife uses Pistol model and artwork until new artwork is complete
static function X2DataTemplate CreateTemplate_CombatKnife_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CombatKnife_CV');
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'combatknife';
	Template.WeaponTech = 'conventional';
	Template.strImage = default.CombatKnife_CV_UIImage; 
	//Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.Sword"; 
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.Tier = 0;
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 1;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CombatKnife_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.CombatKnife_CONVENTIONAL_AIM;
	Template.CritChance = default.CombatKnife_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.CombatKnife_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.CombatKnife_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CombatKnife_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.bHideClipSizeStat = true;
	Template.InfiniteAmmo = true;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWCombatKnifeWOTC.Archetypes.WP_CombatKnife_CV";

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	
	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;
}


static function X2DataTemplate CreateTemplate_CombatKnife_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CombatKnife_LS');

	Template.WeaponCat = 'combatknife';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.EquipSound = "Sword_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 4;
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CombatKnife_LASER_BASEDAMAGE;
	Template.Aim = default.CombatKnife_LASER_AIM;
	Template.CritChance = default.CombatKnife_LASER_CRITCHANCE;
	Template.iClipSize = default.CombatKnife_LASER_ICLIPSIZE;
	Template.iSoundRange = default.CombatKnife_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CombatKnife_LASER_IENVIRONMENTDAMAGE;
	Template.bHideClipSizeStat = true;
	Template.InfiniteAmmo = true;
	
	
	Template.GameArchetype = "LWCombatKnifeWOTC.Archetypes.WP_CombatKnife_CV";

	Template.CreatorTemplateName = 'CombatKnife_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'CombatKnife_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}


static function X2DataTemplate CreateTemplate_CombatKnife_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CombatKnife_MG');

	Template.WeaponCat = 'combatknife';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = default.CombatKnife_MG_UIImage; 
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 2;
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CombatKnife_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.CombatKnife_MAGNETIC_AIM;
	Template.CritChance = default.CombatKnife_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.CombatKnife_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.CombatKnife_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CombatKnife_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.bHideClipSizeStat = true;
	Template.InfiniteAmmo = true;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWCombatKnifeWOTC.Archetypes.WP_CombatKnife_MG";
	
	Template.CreatorTemplateName = 'CombatKnife_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'CombatKnife_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate CreateTemplate_CombatKnife_Coil()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CombatKnife_CG');

	Template.WeaponCat = 'combatknife';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.EquipSound = "Sword_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 4;
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CombatKnife_COIL_BASEDAMAGE;
	Template.Aim = default.CombatKnife_COIL_AIM;
	Template.CritChance = default.CombatKnife_COIL_CRITCHANCE;
	Template.iClipSize = default.CombatKnife_COIL_ICLIPSIZE;
	Template.iSoundRange = default.CombatKnife_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CombatKnife_COIL_IENVIRONMENTDAMAGE;
	Template.bHideClipSizeStat = true;
	Template.InfiniteAmmo = true;
	
	
	Template.GameArchetype = "LWCombatKnifeWOTC.Archetypes.WP_CombatKnife_CV";

	Template.CreatorTemplateName = 'CombatKnife_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'CombatKnife_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}


static function X2DataTemplate CreateTemplate_CombatKnife_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CombatKnife_BM');

	Template.WeaponCat = 'combatknife';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = default.CombatKnife_BM_UIImage; 
	Template.EquipSound = "Sword_Equip_Beam";
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 4;
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CombatKnife_BEAM_BASEDAMAGE;
	Template.Aim = default.CombatKnife_BEAM_AIM;
	Template.CritChance = default.CombatKnife_BEAM_CRITCHANCE;
	Template.iClipSize = default.CombatKnife_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.CombatKnife_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CombatKnife_BEAM_IENVIRONMENTDAMAGE;
	Template.bHideClipSizeStat = true;
	Template.InfiniteAmmo = true;
	
	
	Template.GameArchetype = "LWCombatKnifeWOTC.Archetypes.WP_CombatKnife_CV";

	Template.CreatorTemplateName = 'CombatKnife_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'CombatKnife_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate CreateTemplate_CombatKnife_Magnetic_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'CombatKnife_MG_Schematic');


	Template.ItemCat = 'weapon';
	Template.strImage = default.CombatKnife_MG_UIImage; 
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.HideIfPurchased = 'CombatKnife_BM';
	Template.ReferenceItemTemplate = 'CombatKnife_MG';

	// Requirements
	//Template.Requirements.RequiredTechs.AddItem('MagnetizedWeapons');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');  // same as sword
	Template.Requirements.RequiredEngineeringScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.CombatKnife_MAGNETIC_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.CombatKnife_MAGNETIC_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);
	
	// only add elerium cost if configured value greater than 0
	if (default.CombatKnife_MAGNETIC_SCHEMATIC_ELERIUMCOST > 0) {
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.CombatKnife_MAGNETIC_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

//static function X2DataTemplate CreateTemplate_CombatKnife_Beam_Schematic()
//{
	//local X2SchematicTemplate Template;
	//local ArtifactCost Resources, Artifacts;
//
	//`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'CombatKnife_BM_Schematic');
//
	//Template.ItemCat = 'weapon';
	//Template.strImage = default.CombatKnife_BM_UIImage; 
	//Template.CanBeBuilt = true;
	//Template.bOneTimeBuild = true;
	//Template.HideInInventory = true;
	//Template.PointsToComplete = 0;
	//Template.Tier = 3;
	//Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
//
	//// Reference Item
	//Template.ReferenceItemTemplate = 'CombatKnife_BM';
//
	//// Requirements
	////Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');
	//Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');  // same as sword
	//Template.Requirements.RequiredEngineeringScore = 20;
	//Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
//
	//// Cost
	//Resources.ItemTemplateName = 'Supplies';
	//Resources.Quantity = default.CombatKnife_BEAM_SCHEMATIC_SUPPLYCOST;
	//Template.Cost.ResourceCosts.AddItem(Resources);
//
	//Artifacts.ItemTemplateName = 'AlienAlloy';
	//Artifacts.Quantity = default.CombatKnife_BEAM_SCHEMATIC_ALLOYCOST;
	//Template.Cost.ResourceCosts.AddItem(Artifacts);
//
	//Artifacts.ItemTemplateName = 'EleriumDust';
	//Artifacts.Quantity = default.CombatKnife_BEAM_SCHEMATIC_ELERIUMCOST;
	//Template.Cost.ResourceCosts.AddItem(Artifacts);
//
	//return Template;
//}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
