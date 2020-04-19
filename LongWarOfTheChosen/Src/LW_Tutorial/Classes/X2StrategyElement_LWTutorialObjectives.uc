//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_LWTutorialObjectives.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Objectives used for the LWOTC in-game tutorial
//---------------------------------------------------------------------------------------
class X2StrategyElement_LWTutorialObjectives extends X2StrategyElement_DefaultObjectives;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Objectives;

	Objectives.AddItem(CreateLW_TUT_GatecrasherStartTemplate());
	Objectives.AddItem(CreateLW_TUT_DroneSightedTemplate());
	Objectives.AddItem(CreateLW_TUT_EngineerSightedTemplate());
	Objectives.AddItem(CreateLW_TUT_SentrySightedTemplate());
	Objectives.AddItem(CreateLW_TUT_GunnerSightedTemplate());
	Objectives.AddItem(CreateLW_TUT_RocketeerSightedTemplate());
	Objectives.AddItem(CreateLW_TUT_CampaignStartTemplate());
	Objectives.AddItem(CreateLW_TUT_HavenOnGeoscape());
	Objectives.AddItem(CreateLW_TUT_HavenManagement());

	return Objectives;
}

// #######################################################################################
// -------------------- Gatecrasher ---------------------------------------------------
static function X2DataTemplate CreateLW_TUT_GatecrasherStartTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_GatecrasherStart');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.Steps.AddItem('LW_TUT_DroneSighted');
	Template.Steps.AddItem('LW_TUT_EngineerSighted');
	Template.Steps.AddItem('LW_TUT_SentrySighted');
	Template.Steps.AddItem('LW_TUT_GunnerSighted');

	Template.CompletionEvent = '';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_DroneSightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_DroneSighted');
	Template.bMainObjective = false;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'DroneSighted';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_EngineerSightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_EngineerSighted');
	Template.bMainObjective = false;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'EngineerSighted';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_SentrySightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_SentrySighted');
	Template.bMainObjective = false;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'SentrySighted';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_GunnerSightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_GunnerSighted');
	Template.bMainObjective = false;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'GunnerSighted';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_RocketeerSightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_RocketeerSighted');
	Template.bMainObjective = false;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'RocketeerSighted';

	return Template;
}

// #######################################################################################
// -------------------- Campaign Start -------------------------------------------------
static function X2DataTemplate CreateLW_TUT_CampaignStartTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_CampaignStart');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.NextObjectives.AddItem('LW_TUT_HavenOnGeoscape');

	Template.CompletionEvent = '';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_HavenOnGeoscape()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_HavenOnGeoscape');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.NextObjectives.AddItem('LW_TUT_HavenManagement');

	Template.CompletionEvent = '';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_HavenManagement()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_HavenManagement');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = '';

	return Template;
}
