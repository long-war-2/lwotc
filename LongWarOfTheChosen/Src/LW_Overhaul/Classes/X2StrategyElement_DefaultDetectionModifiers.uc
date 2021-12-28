//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultDetectionModifiers.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Sets up the standard LWOTC mission detection modifier templates
//---------------------------------------------------------------------------------------
class X2StrategyElement_DefaultDetectionModifiers extends X2StrategyElement config(LW_Overhaul);

var config array<name> ACTIVITIES_WITH_INTEL_JOB_BONUS;
var config array<name> ACTIVITIES_WITH_RECRUIT_JOB_BONUS;
var config array<name> ACTIVITIES_WITH_SUPPLY_JOB_BONUS;
var config array<name> ACTIVITIES_FOR_LIBERATION;

var config float INTEL_JOB_MULTIPLIER_PER_REBEL;
var config float RECRUIT_JOB_MULTIPLIER_PER_REBEL;
var config float SUPPLY_JOB_MULTIPLIER_PER_REBEL;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2StrategyElement_DefaultDetectionModifiers.CreateTemplates()");

	Templates.AddItem(CreateIntelRebelJobModifier());
	Templates.AddItem(CreateRecruitRebelJobModifier());
	Templates.AddItem(CreateSupplyRebelJobModifier());
	Templates.AddItem(CreateLiberationDetectionBonus());

	return Templates;
}

static function X2LWMissionDetectionModifierTemplate CreateIntelRebelJobModifier()
{
	local X2LWMissionDetectionModifierTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWMissionDetectionModifierTemplate', Template, 'IntelJobDetectionModifier');

	Template.GetModifierFn = GetIntelJobDetectionModifier;

	return Template;
}

static function float GetIntelJobDetectionModifier(XComGameState_LWOutpost OutpostState, XComGameState_LWAlienActivity ActivityState, float BaseModifier)
{
	local int RebelsOnJobCount;

	// Bonus only applies if the activity is in the configured set
	if (default.ACTIVITIES_WITH_INTEL_JOB_BONUS.Find(ActivityState.GetMyTemplateName()) == INDEX_NONE)
	{
		return 0.0;
	}

	// Check that we have some rebels on the Intel job, otherwise there is no bonus
	RebelsOnJobCount = OutpostState.GetRebelLevelsOnJob(class'LWRebelJob_DefaultJobSet'.const.INTEL_JOB);

	`LWTrace("Applying intel job modifier bonus: [" $ BaseModifier $ ", " $ RebelsOnJobCount $ ", " $ default.INTEL_JOB_MULTIPLIER_PER_REBEL $ "]");
	return BaseModifier * RebelsOnJobCount * default.INTEL_JOB_MULTIPLIER_PER_REBEL;
}

static function X2LWMissionDetectionModifierTemplate CreateRecruitRebelJobModifier()
{
	local X2LWMissionDetectionModifierTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWMissionDetectionModifierTemplate', Template, 'RecruitJobDetectionModifier');

	Template.GetModifierFn = GetRecruitJobDetectionModifier;

	return Template;
}

static function float GetRecruitJobDetectionModifier(XComGameState_LWOutpost OutpostState, XComGameState_LWAlienActivity ActivityState, float BaseModifier)
{
	local int RebelsOnJobCount;

	// Bonus only applies if the activity is in the configured set
	if (default.ACTIVITIES_WITH_RECRUIT_JOB_BONUS.Find(ActivityState.GetMyTemplateName()) == INDEX_NONE)
	{
		return 0.0;
	}

	// Check that we have some rebels on the Intel job, otherwise there is no bonus
	RebelsOnJobCount = OutpostState.GetRebelLevelsOnJob(class'LWRebelJob_DefaultJobSet'.const.RECRUIT_JOB);

	`LWTrace("Applying recruit job modifier bonus: [" $ BaseModifier $ ", " $ RebelsOnJobCount $ ", " $ default.RECRUIT_JOB_MULTIPLIER_PER_REBEL $ "]");
	return BaseModifier * RebelsOnJobCount * default.RECRUIT_JOB_MULTIPLIER_PER_REBEL;
}

static function X2LWMissionDetectionModifierTemplate CreateSupplyRebelJobModifier()
{
	local X2LWMissionDetectionModifierTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWMissionDetectionModifierTemplate', Template, 'SupplyJobDetectionModifier');

	Template.GetModifierFn = GetSupplyJobDetectionModifier;

	return Template;
}

static function float GetSupplyJobDetectionModifier(XComGameState_LWOutpost OutpostState, XComGameState_LWAlienActivity ActivityState, float BaseModifier)
{
	local int RebelsOnJobCount;

	// Bonus only applies if the activity is in the configured set
	if (default.ACTIVITIES_WITH_SUPPLY_JOB_BONUS.Find(ActivityState.GetMyTemplateName()) == INDEX_NONE)
	{
		return 0.0;
	}

	// Check that we have some rebels on the Intel job, otherwise there is no bonus
	RebelsOnJobCount = OutpostState.GetRebelLevelsOnJob(class'LWRebelJob_DefaultJobSet'.const.SUPPLY_JOB);

	`LWTrace("Applying supply job modifier bonus: [" $ BaseModifier $ ", " $ RebelsOnJobCount $ ", " $ default.SUPPLY_JOB_MULTIPLIER_PER_REBEL $ "]");
	return BaseModifier * RebelsOnJobCount * default.SUPPLY_JOB_MULTIPLIER_PER_REBEL;
}

static function X2LWMissionDetectionModifierTemplate CreateLiberationDetectionBonus()
{
	local X2LWMissionDetectionModifierTemplate Template;
	local X2LWDetectionModifierCondition_Activity ActivityCondition;

	`CREATE_X2TEMPLATE(class'X2LWMissionDetectionModifierTemplate', Template, 'LiberationMissionDetectionModifier');

	ActivityCondition = new class'X2LWDetectionModifierCondition_Activity';
	ActivityCondition.ActivityNames = default.ACTIVITIES_FOR_LIBERATION;
	Template.Conditions.AddItem(ActivityCondition);

	// Bonus detection configuration is provided in INIs.

	return Template;
}
