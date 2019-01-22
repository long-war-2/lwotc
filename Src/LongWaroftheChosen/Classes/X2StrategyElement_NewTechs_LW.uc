class X2StrategyElement_NewTechs_LW extends X2StrategyElement_DefaultTechs config(GameData);

`include(LW_Overhaul\Src\LW_Overhaul.uci)

var config int RENDER_REWARD_ELERIUM_CORE;
var config int RENDER_REWARD_SECTOID_CORPSE;
var config int RENDER_REWARD_VIPER_CORPSE;
var config int RENDER_REWARD_MUTON_CORPSE; 
var config int RENDER_REWARD_BERSERKER_CORPSE;
var config int RENDER_REWARD_ARCHON_CORPSE;
var config int RENDER_REWARD_GATEKEEPER_CORPSE;
var config int RENDER_REWARD_ANDROMEDON_CORPSE;
var config int RENDER_REWARD_FACELESS_CORPSE;
var config int RENDER_REWARD_CHRYSSALID_CORPSE;
var config int RENDER_REWARD_ADVENTTROOPER_CORPSE;
var config int RENDER_REWARD_ADVENTSTUNLANCER_CORPSE;
var config int RENDER_REWARD_ADVENTSHIELDBEARER_CORPSE;
var config int RENDER_REWARD_MEC_WRECK;
var config int RENDER_REWARD_TURRET_WRECK;
var config int RENDER_REWARD_SECTOPOD_WRECK;
var config int RENDER_REWARD_ADVENTOFFICER_CORPSE;
var config int RENDER_REWARD_DRONE_WRECK;
var config int RENDER_REWARD_MUTONELITE_CORPSE;

var config int BASIC_RESEARCH_SCIENCE_BONUS;
var config int BASIC_RESEARCH_ENGINEERING_BONUS;
var config int REPEAT_BASIC_RESEARCH_INCREASE;
var config int REPEAT_BASIC_ENGINEERING_INCREASE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	//New LW Overhaul techs
	Techs.AddItem(CreateLaserWeaponsTemplate());
	Techs.AddItem(CreateAdvancedLaserWeaponsTemplate());

	return Techs;
}


static function X2DataTemplate CreateLaserWeaponsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'LaserWeapons');
	Template.PointsToComplete = 5000;
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_LW_LaserPack.TECH_LaserWeapons"; 

	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedLaserWeaponsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedLasers');
	Template.PointsToComplete = 5000;
	Template.SortingTier = 1;
	Template.Requirements.RequiredTechs.AddItem('LaserWeapons');
	Template.strImage = "img:///UILibrary_LW_LaserPack.TECH_AdvancedLaserWeapons"; 

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
