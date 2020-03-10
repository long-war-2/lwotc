//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultCovertActions_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Creates new covert actions for LWOTC.
//---------------------------------------------------------------------------------------

class X2StrategyElement_DefaultCovertActions_LW extends X2StrategyElement_DefaultCovertActions;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> CovertActions;

	CovertActions.AddItem(CreateEnemyCorpsesTemplate());

	return CovertActions;
}

static function X2DataTemplate CreateEnemyCorpsesTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_EnemyCorpses');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_EnemyCorpses_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_EnemyCorpses_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_EnemyCorpses_Templars');

    // NOTE: Soldier slots configured in `X2LWCovertActionsModTemplate` for consistency and
    // because some Firaxis developer keeps making functions private..... The template mod
    // also adds the Failure risk.

	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');

	Template.Rewards.AddItem(class'X2StrategyElement_DefaultRewards_LW'.const.CORPSE_REWARD_NAME);

	return Template;
}
