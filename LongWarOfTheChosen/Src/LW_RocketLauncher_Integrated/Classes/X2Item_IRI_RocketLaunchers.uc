class X2Item_IRI_RocketLaunchers extends X2Item config(RocketLaunchers);

var config array<int> CV_RL_RANGE_ACCURACY;
var config array<int> MG_RL_RANGE_ACCURACY;
var config array<int> BM_RL_RANGE_ACCURACY;

var config array<int> CV_RL_RANGE_ACCURACY_ONE_ACTION;
var config array<int> MG_RL_RANGE_ACCURACY_ONE_ACTION;
var config array<int> BM_RL_RANGE_ACCURACY_ONE_ACTION;

var config bool MOBILITY_PENALTY_IS_APPLIED_TO_HEAVY_ARMOR;
var config bool MOBILITY_PENALTY_IS_APPLIED_TO_SPARK_ARMOR;

var config array<name> MG_RL_UPGRADE_RESOURCE_COST_TYPE;
var config array<int> MG_RL_UPGRADE_RESOURCE_COST_QUANTITY;
var config array<name> MG_RL_UPGRADE_REQUIRED_TECH; //AddItem('GaussWeapons');
var config array<name> MG_RL_UPGRADE_REQUIRED_ITEM;
var config int MG_RL_UPGRADE_REQUIRED_ENGINEERING_SCORE; //15

var config int MG_RL_BONUS_ROCKET_RANGE_TILES;

var config array<name> BM_RL_UPGRADE_RESOURCE_COST_TYPE;
var config array<int> BM_RL_UPGRADE_RESOURCE_COST_QUANTITY;
var config array<name> BM_RL_UPGRADE_REQUIRED_TECH; //AddItem('HeavyPlasma');
var config array<name> BM_RL_UPGRADE_REQUIRED_ITEM;
var config int BM_RL_UPGRADE_REQUIRED_ENGINEERING_SCORE; //25

var config int BM_RL_BONUS_ROCKET_RANGE_TILES;

// Gauntlet Compatbility

var config WeaponDamageValue RL_CV_BASEDAMAGE;
var config WeaponDamageValue RL_MG_BASEDAMAGE;
var config WeaponDamageValue RL_BM_BASEDAMAGE;

var config int RL_CV_SOUNDRANGE;
var config int RL_CV_RANGE;
var config int RL_CV_RADIUS;
var config int RL_CV_CLIPSIZE;
var config int RL_CV_ENVIRONMENTAL_DAMAGE;

var config int RL_MG_SOUNDRANGE;
var config int RL_MG_RANGE;
var config int RL_MG_RADIUS;
var config int RL_MG_CLIPSIZE;
var config int RL_MG_ENVIRONMENTAL_DAMAGE;

var config int RL_BM_SOUNDRANGE;
var config int RL_BM_RANGE;
var config int RL_BM_RADIUS;
var config int RL_BM_CLIPSIZE;
var config int RL_BM_ENVIRONMENTAL_DAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Create_IRI_RocketLauncher_CV());
	Templates.AddItem(Create_IRI_RocketLauncher_MG());
	Templates.AddItem(Create_IRI_RocketLauncher_BM());

	Templates.AddItem(Create_IRI_RocketLauncher_MG_Schematic());
	Templates.AddItem(Create_IRI_RocketLauncher_BM_Schematic());

	return Templates;
}

static function X2GrenadeLauncherTemplate Create_IRI_RocketLauncher_CV()
{
	local X2GrenadeLauncherTemplate Template;	//	there's no real upside for using this

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'IRI_RocketLauncher_CV');

	Template.WeaponCat = 'iri_rocket_launcher';
	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Launcher_CV";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";

	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_TRADINGPOSTVALUE;
	Template.Tier = -3;

	//Template.RangeAccuracy = default.CV_RL_RANGE_ACCURACY;
	//Template.OneActionRangeAccuracy = default.CV_RL_RANGE_ACCURACY_ONE_ACTION;

	Template.WeaponTech = 'conventional';

	Template.IncreaseGrenadeRange = 0;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_RocketLauncher_CV";

	Template.CanBeBuilt = false;
	Template.StartingItem = true;
	Template.bInfiniteItem = true;

	Template.bSoundOriginatesFromOwnerLocation = false;
	Template.bMergeAmmo = true;
	Template.iPhysicsImpulse = 5;

	//	Gauntlet Compability
	//Template.Aim = 0;
	//Template.CritChance = 0;

	Template.iRange = default.RL_CV_RANGE;
	Template.iRadius = default.RL_CV_RADIUS;
	Template.iClipSize = default.RL_CV_CLIPSIZE;
	Template.iSoundRange = default.RL_CV_SOUNDRANGE;
	Template.iEnvironmentDamage = default.RL_CV_ENVIRONMENTAL_DAMAGE;
	Template.BaseDamage = default.RL_CV_BASEDAMAGE;
	Template.DamageTypeTemplateName = default.RL_CV_BASEDAMAGE.DamageType;	

	Template.Abilities.AddItem('IRI_FireRocketLauncher');
	Template.Abilities.AddItem('RocketFuse');
	//Template.Abilities.AddItem('LWRocketLauncher');
	//Template.Abilities.AddItem('HeavyArmaments');

	return Template;
}

static function X2GrenadeLauncherTemplate Create_IRI_RocketLauncher_MG()
{
	local X2GrenadeLauncherTemplate Template;	//	there's no real upside for using this

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'IRI_RocketLauncher_MG');

	Template.WeaponCat = 'iri_rocket_launcher';
	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Launcher_MG";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";

	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_TRADINGPOSTVALUE;
	Template.Tier = -2;

	//Template.RangeAccuracy = default.MG_RL_RANGE_ACCURACY;
	//Template.OneActionRangeAccuracy = default.MG_RL_RANGE_ACCURACY_ONE_ACTION;

	//Template.Abilities.AddItem('IRI_RocketLauncher_MG_Passive');

	Template.WeaponTech = 'magnetic';

	Template.IncreaseGrenadeRange = default.MG_RL_BONUS_ROCKET_RANGE_TILES;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_RocketLauncher_MG";

	Template.CreatorTemplateName = 'IRI_RocketLauncher_MG_Schematic';
	Template.BaseItem = 'IRI_RocketLauncher_CV';

	Template.CanBeBuilt = false;
	Template.StartingItem = false;
	Template.bInfiniteItem = true;

	Template.iRange = default.RL_MG_RANGE;
	Template.iRadius = default.RL_MG_RADIUS;
	Template.iClipSize = default.RL_MG_CLIPSIZE;
	Template.iSoundRange = default.RL_MG_SOUNDRANGE;
	Template.iEnvironmentDamage = default.RL_MG_ENVIRONMENTAL_DAMAGE;
	Template.BaseDamage = default.RL_MG_BASEDAMAGE;
	Template.DamageTypeTemplateName = default.RL_MG_BASEDAMAGE.DamageType;	

	Template.Abilities.AddItem('IRI_FireRocketLauncher');
	Template.Abilities.AddItem('RocketFuse');

	return Template;
}

static function X2GrenadeLauncherTemplate Create_IRI_RocketLauncher_BM()
{
	local X2GrenadeLauncherTemplate Template;	//	there's no real upside for using this

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'IRI_RocketLauncher_BM');

	Template.WeaponCat = 'iri_rocket_launcher';
	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Launcher_BM";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";

	//Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_ISOUNDRANGE;
	//Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_TRADINGPOSTVALUE;
	//Template.iClipSize = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_ICLIPSIZE;
	Template.Tier = -1;

	//Template.RangeAccuracy = default.BM_RL_RANGE_ACCURACY;
	//Template.OneActionRangeAccuracy = default.BM_RL_RANGE_ACCURACY_ONE_ACTION;

	//Template.Abilities.AddItem('IRI_RocketLauncher_BM_Passive');

	Template.WeaponTech = 'beam';

	Template.IncreaseGrenadeRange = default.BM_RL_BONUS_ROCKET_RANGE_TILES;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_RocketLauncher_BM";

	Template.CreatorTemplateName = 'IRI_RocketLauncher_BM_Schematic';
	Template.BaseItem = 'IRI_RocketLauncher_MG';

	Template.CanBeBuilt = false;
	Template.StartingItem = false;
	Template.bInfiniteItem = true;

	Template.iRange = default.RL_BM_RANGE;
	Template.iRadius = default.RL_BM_RADIUS;
	Template.iClipSize = default.RL_BM_CLIPSIZE;
	Template.iSoundRange = default.RL_BM_SOUNDRANGE;
	Template.iEnvironmentDamage = default.RL_BM_ENVIRONMENTAL_DAMAGE;
	Template.BaseDamage = default.RL_BM_BASEDAMAGE;
	Template.DamageTypeTemplateName = default.RL_BM_BASEDAMAGE.DamageType;	

	Template.Abilities.AddItem('IRI_FireRocketLauncher');
	Template.Abilities.AddItem('RocketFuse');

	return Template;
}

//	====================================
//				SCHEMATICS
//	====================================


static function X2DataTemplate Create_IRI_RocketLauncher_MG_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;
	local int i;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'IRI_RocketLauncher_MG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Launcher_MG";
	Template.PointsToComplete = 0;
	Template.Tier = 2;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'IRI_RocketLauncher_MG';
	//Template.HideIfPurchased = 'IRI_RocketLauncher_BM';

	// Requirements
	if (default.MG_RL_UPGRADE_REQUIRED_TECH.Length > 0) Template.Requirements.RequiredTechs = default.MG_RL_UPGRADE_REQUIRED_TECH; 
	if (default.MG_RL_UPGRADE_REQUIRED_ITEM.Length > 0) Template.Requirements.RequiredItems = default.MG_RL_UPGRADE_REQUIRED_ITEM;

	Template.Requirements.RequiredEngineeringScore = default.MG_RL_UPGRADE_REQUIRED_ENGINEERING_SCORE;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	for (i = 0; i < default.MG_RL_UPGRADE_RESOURCE_COST_TYPE.Length; i++)
	{
		if (default.MG_RL_UPGRADE_RESOURCE_COST_QUANTITY[i] > 0)
		{
			Resources.ItemTemplateName = default.MG_RL_UPGRADE_RESOURCE_COST_TYPE[i];
			Resources.Quantity = default.MG_RL_UPGRADE_RESOURCE_COST_QUANTITY[i];
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
	}

	return Template;
}

static function X2DataTemplate Create_IRI_RocketLauncher_BM_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;
	local int i;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'IRI_RocketLauncher_BM_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Launcher_BM";
	Template.PointsToComplete = 0;
	Template.Tier = 4;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'IRI_RocketLauncher_BM';

	// Requirements
	if (default.BM_RL_UPGRADE_REQUIRED_TECH.Length > 0) Template.Requirements.RequiredTechs = default.BM_RL_UPGRADE_REQUIRED_TECH; 
	if (default.BM_RL_UPGRADE_REQUIRED_ITEM.Length > 0) Template.Requirements.RequiredItems = default.BM_RL_UPGRADE_REQUIRED_ITEM;
	Template.Requirements.RequiredEngineeringScore = default.BM_RL_UPGRADE_REQUIRED_ENGINEERING_SCORE;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	for (i = 0; i < default.BM_RL_UPGRADE_RESOURCE_COST_TYPE.Length; i++)
	{
		if (default.BM_RL_UPGRADE_RESOURCE_COST_QUANTITY[i] > 0)
		{
			Resources.ItemTemplateName = default.BM_RL_UPGRADE_RESOURCE_COST_TYPE[i];
			Resources.Quantity = default.BM_RL_UPGRADE_RESOURCE_COST_QUANTITY[i];
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
	}

	return Template;
}


/*
static function X2WeaponTemplate Create_IRI_RocketLauncher()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'IRI_RocketLauncher_CV');

	Template.WeaponCat = 'iri_rocket_launcher';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.bSoundOriginatesFromOwnerLocation = false;

	Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.ConvGrenade";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";

	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_ICLIPSIZE;
	Template.Tier = 0;

	//Template.IncreaseGrenadeRadius = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_RADIUSBONUS;
	//Template.IncreaseGrenadeRange = class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_RANGEBONUS;

	Template.Abilities.AddItem('IRI_FireRocket');

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_RocketLauncher_CV";
	
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	//Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRangeBonusLabel, , class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_RANGEBONUS);
	//Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRadiusBonusLabel, , class'X2Item_DefaultGrenades'.default.GRENADELAUNCHER_RADIUSBONUS);

	return Template;
}*/

/*
{
	local X2GrenadeLauncherTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'IRI_RocketLauncher_CV');
	Template.WeaponCat = 'iri_rocket_launcher';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";

	Template.BaseDamage = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_IENVIRONMENTDAMAGE;
	Template.iClipSize = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_ICLIPSIZE;
	Template.iRange = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_RANGE;
	Template.iRadius = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_RADIUS;

	//Template.IncreaseGrenadeRange = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_RANGE
	
	//Template.PointsToComplete = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_IPOINTS;
	Template.TradingPostValue = class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_TRADINGPOSTVALUE;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_RocketLauncher_CV";
	//Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher";

	//Template.bMergeAmmo = true;
	Template.DamageTypeTemplateName = 'Explosion';

	Template.AddDefaultAttachment('Scope',"IRI_RocketLaunchers.Meshes.SM_RocketLauncher_IronSights");
	//Template.AddDefaultAttachment('Mag', "BeamCannon.Meshes.SM_BeamCannon_MagA", , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_MagA");
	//Template.Abilities.AddItem('IRI_FireRocket');
	//Template.Abilities.AddItem('RocketFuse');

	//Template.Abilities.AddItem('Squadsight');

	Template.CanBeBuilt = false;
	Template.StartingItem = true;
	Template.bInfiniteItem = true;
		
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_HeavyWeapons'.default.ROCKETLAUNCHER_RADIUS);
	
	return Template;
}*/
