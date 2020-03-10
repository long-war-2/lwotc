//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultCovertActionRisks_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Creates new covert action risks for LWOTC.
//---------------------------------------------------------------------------------------

class X2StrategyElement_DefaultCovertActionRisks_LW extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Risks;

	Risks.AddItem(CreateFailureEasyRiskTemplate());
	Risks.AddItem(CreateFailureModerateRiskTemplate());
	Risks.AddItem(CreateFailureHardRiskTemplate());

	return Risks;
}

//---------------------------------------------------------------------------------------
// Common failure risks
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateFailureEasyRiskTemplate()
{
	local X2CovertActionRiskTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionRiskTemplate', Template, 'CovertActionRisk_Failure_Easy');

	return Template;
}

static function X2DataTemplate CreateFailureModerateRiskTemplate()
{
	local X2CovertActionRiskTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionRiskTemplate', Template, 'CovertActionRisk_Failure_Moderate');

	return Template;
}

static function X2DataTemplate CreateFailureHardRiskTemplate()
{
	local X2CovertActionRiskTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionRiskTemplate', Template, 'CovertActionRisk_Failure_Hard');

	return Template;
}
