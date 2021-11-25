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
	Objectives.AddItem(CreateLW_TUT_RainbowTrooperSightedTemplate());
	Objectives.AddItem(CreateLW_TUT_CampaignStartTemplate());
	Objectives.AddItem(CreateLW_TUT_CommandersQuarters());
	Objectives.AddItem(CreateLW_TUT_HavenOnGeoscape());
	Objectives.AddItem(CreateLW_TUT_HavenManagement());
	Objectives.AddItem(CreateLW_TUT_FirstMissionDiscovered());
	Objectives.AddItem(CreateLW_TUT_FirstMissionBrief());
	Objectives.AddItem(CreateLW_TUT_SquadSelect());
	Objectives.AddItem(CreateLW_TUT_InfiltratingMission());
	Objectives.AddItem(CreateLW_TUT_FirstRetaliation());
	Objectives.AddItem(CreateLW_TUT_CovertActions());
	Objectives.AddItem(CreateLW_TUT_PistolAbilities());

	Objectives.AddItem(CreateLW_TUT_GeneralChosen());
	Objectives.AddItem(CreateLW_TUT_ChosenTactical());
	
	Objectives.AddItem(CreateLW_TUT_AssassinSightedTemplate());
	Objectives.AddItem(CreateLW_TUT_WarlockSightedTemplate());
	Objectives.AddItem(CreateLW_TUT_HunterSightedTemplate());


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

	Template.NextObjectives.AddItem('LW_TUT_DroneSighted');
	Template.NextObjectives.AddItem('LW_TUT_RainbowTrooperSighted');
	Template.NextObjectives.AddItem('LW_TUT_ChosenTactical');
	Template.NextObjectives.AddItem('LW_TUT_AssassinSighted');
	Template.NextObjectives.AddItem('LW_TUT_WarlockSighted');
	Template.NextObjectives.AddItem('LW_TUT_HunterSighted');
	// Template.Steps.AddItem('LW_TUT_EngineerSighted');
	// Template.Steps.AddItem('LW_TUT_SentrySighted');
	// Template.Steps.AddItem('LW_TUT_GunnerSighted');

	Template.CompletionEvent = 'OnTacticalBeginPlay';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_DroneSightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_DroneSighted');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'DroneSighted';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_RainbowTrooperSightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_RainbowTrooperSighted');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'BlehBleh';

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

	Template.NextObjectives.AddItem('LW_TUT_CommandersQuarters');
	Template.NextObjectives.AddItem('LW_TUT_HavenOnGeoscape');
	Template.NextObjectives.AddItem('LW_TUT_FirstMissionDiscovered');
	Template.NextObjectives.AddItem('LW_TUT_FirstMissionBrief');
	Template.NextObjectives.AddItem('LW_TUT_SquadSelect');
	Template.NextObjectives.AddItem('LW_TUT_InfiltratingMission');
	Template.NextObjectives.AddItem('LW_TUT_FirstRetaliation');
	Template.NextObjectives.AddItem('LW_TUT_CovertActions');
	Template.NextObjectives.AddItem('LW_TUT_PistolAbilities');
	Template.NextObjectives.AddItem('LW_TUT_GeneralChosen');

	return Template;
}

static function X2DataTemplate CreateLW_TUT_CommandersQuarters()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_CommandersQuarters');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

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

	return Template;
}

static function X2DataTemplate CreateLW_TUT_HavenManagement()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_HavenManagement');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}

static function X2DataTemplate CreateLW_TUT_FirstMissionDiscovered()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_FirstMissionDiscovered');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}

static function X2DataTemplate CreateLW_TUT_FirstMissionBrief()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_FirstMissionBrief');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}

static function X2DataTemplate CreateLW_TUT_SquadSelect()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_SquadSelect');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}

static function X2DataTemplate CreateLW_TUT_InfiltratingMission()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_InfiltratingMission');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}
	
static function X2DataTemplate CreateLW_TUT_FirstRetaliation()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_FirstRetaliation');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}

static function X2DataTemplate CreateLW_TUT_CovertActions()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_CovertActions');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}

static function X2DataTemplate CreateLW_TUT_PistolAbilities()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_PistolAbilities');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}

static function X2DataTemplate CreateLW_TUT_ChosenTactical()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_ChosenTactical');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}

static function X2DataTemplate CreateLW_TUT_GeneralChosen()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_GeneralChosen');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	return Template;
}

static function X2DataTemplate CreateLW_TUT_AssassinSightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_AssassinSighted');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'AssassinSighted';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_WarlockSightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_WarlockSighted');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'WarlockSighted';

	return Template;
}

static function X2DataTemplate CreateLW_TUT_HunterSightedTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_TUT_HunterSighted');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.CompletionEvent = 'HunterSighted';

	return Template;
}