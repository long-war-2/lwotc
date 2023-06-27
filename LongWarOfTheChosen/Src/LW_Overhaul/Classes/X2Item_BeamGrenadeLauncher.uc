//---------------------------------------------------------------------------------------
//  FILE:   X2Item_BeamGrenadeLauncher.uc
//  AUTHOR:  InternetExploder
//  PURPOSE: Beam variant of the grenade launcher
//---------------------------------------------------------------------------------------
class X2Item_BeamGrenadeLauncher extends X2Item config(GameData_WeaponData);

var config int BEAMGRENADELAUNCHER_ISOUNDRANGE;
var config int BEAMGRENADELAUNCHER_IENVIRONMENTDAMAGE;
var config int BEAMGRENADELAUNCHER_ICLIPSIZE;
var config int BEAMGRENADELAUNCHER_RANGEBONUS;
var config int BEAMGRENADELAUNCHER_RADIUSBONUS;

var config array<name> BEAMGRENADELAUNCHER_SCHEMATIC_REQUIREDTECHS;
var config int BEAMGRENADELAUNCHER_SCHEMATIC_REQUIREDENGINEERINGSCORE;
var config array<ArtifactCost> BEAMGRENADELAUNCHER_SCHEMATIC_RESOURCECOSTS;
var config array<ArtifactCost> BEAMGRENADELAUNCHER_SCHEMATIC_ARTIFACTCOSTS;

/// <summary>
/// Override this method in sub classes to create new templates by creating new X2<Type>Template
/// objects and filling them out.
/// </summary>
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ModWeapons;

	ModWeapons.AddItem(CreateTemplate_BeamGrenadeLauncher());
	//ModWeapons.AddItem(CreateTemplate_BeamGrenadeLauncher_Schematic());

	return ModWeapons;
}

/// <summary>
/// Creates the Beam Grenade Launcher secondary weapon template.
/// </summary>
static function X2GrenadeLauncherTemplate CreateTemplate_BeamGrenadeLauncher()
{
	local X2GrenadeLauncherTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'GrenadeLauncher_BM');

	Template.strImage = "img:///WP_BeamGrenadeLauncher_LW.UI.BeamLauncher";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";

	Template.iSoundRange = default.BEAMGRENADELAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.BEAMGRENADELAUNCHER_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 18;
	Template.iClipSize = default.BEAMGRENADELAUNCHER_ICLIPSIZE;
	Template.Tier = 2;

	Template.IncreaseGrenadeRadius = default.BEAMGRENADELAUNCHER_RADIUSBONUS;
	Template.IncreaseGrenadeRange = default.BEAMGRENADELAUNCHER_RANGEBONUS;

	Template.GameArchetype = "WP_BeamGrenadeLauncher_LW.WP_BeamGrenadeLauncher";
	// Template.GameArchetype = "WP_BeamGrenadeLauncher_LW.WP_BeamGrenadeLauncher_LW";

	Template.CreatorTemplateName = 'GrenadeLauncher_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'GrenadeLauncher_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRangeBonusLabel, , default.BEAMGRENADELAUNCHER_RANGEBONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRadiusBonusLabel, , default.BEAMGRENADELAUNCHER_RADIUSBONUS);

	return Template;
}

/// <summary>
/// Creates the Beam Grenade Launcher item schematic template.
/// </summary>
static function X2SchematicTemplate CreateTemplate_BeamGrenadeLauncher_Schematic()
{
	local X2SchematicTemplate Template;
	local name RequiredTech;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'GrenadeLauncher_BM_Schematic');

	Template.ItemCat = 'weapon'; 
	Template.strImage = "img:///WP_BeamGrenadeLauncher_LW.UI.BeamLauncher";
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'GrenadeLauncher_BM';

	// Requirements
	foreach default.BEAMGRENADELAUNCHER_SCHEMATIC_REQUIREDTECHS(RequiredTech)
	{
		Template.Requirements.RequiredTechs.AddItem(RequiredTech);
	}
	
	Template.Requirements.RequiredEngineeringScore = default.BEAMGRENADELAUNCHER_SCHEMATIC_REQUIREDENGINEERINGSCORE;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
	
	// Costs
	foreach default.BEAMGRENADELAUNCHER_SCHEMATIC_RESOURCECOSTS(Resources)
	{
		Template.Cost.ResourceCosts.AddItem(Resources);
	}
	foreach default.BEAMGRENADELAUNCHER_SCHEMATIC_ARTIFACTCOSTS(Artifacts)
	{
		Template.Cost.ArtifactCosts.AddItem(Artifacts);
	}

	return Template;
}