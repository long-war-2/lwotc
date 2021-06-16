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
	CovertActions.AddItem(CreateIntenseTrainingTemplate());
	CovertActions.AddItem(CreateResistanceMecTemplate());
	CovertActions.AddItem(CreateRecruitRebelsTemplate());

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

	Template.Risks.AddItem('CovertActionRisk_Ambush');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');

	Template.Rewards.AddItem(class'X2StrategyElement_DefaultRewards_LW'.const.CORPSE_REWARD_NAME);

	return Template;
}

static function X2DataTemplate CreateIntenseTrainingTemplate()
{
	local X2CovertActionTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_IntenseTraining');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bMultiplesAllowed = true;
	Template.RequiredFactionInfluence = eFactionInfluence_Respected;

	Template.Narratives.AddItem('CovertActionNarrative_IntenseTraining_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_IntenseTraining_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_IntenseTraining_Templars');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionIntenseTrainingStaffSlot'));
	
	Resources.ItemTemplateName = 'AbilityPoint';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.Rewards.AddItem('Reward_Dummy_StatBoost');

	return Template;
}

static function X2DataTemplate CreateResistanceMecTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_ResistanceMec');

	Template.ChooseLocationFn = ChooseContactedRegionWithoutMEC;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_ResistanceMec_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_ResistanceMec_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_ResistanceMec_Templars');

    // NOTE: Soldier slots configured in `X2LWCovertActionsModTemplate` for consistency and
    // because some Firaxis developer keeps making functions private..... The template mod
    // also adds the Failure risk.

	Template.Risks.AddItem('CovertActionRisk_Ambush');

	Template.Rewards.AddItem(class'X2StrategyElement_DefaultRewards_LW'.const.RESISTANCE_MEC_REWARD_NAME);

	return Template;
}

static function X2DataTemplate CreateRecruitRebelsTemplate()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_RecruitRebels');

	Template.ChooseLocationFn = ChooseRandomContactedRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";

	Template.Narratives.AddItem('CovertActionNarrative_RecruitRebels_Skirmishers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitRebels_Reapers');
	Template.Narratives.AddItem('CovertActionNarrative_RecruitRebels_Templars');

	// NOTE: Soldier slots configured in `X2LWCovertActionsModTemplate` for consistency and
	// because some Firaxis developer keeps making functions private..... The template mod
	// also adds the Failure risk.

	Template.Risks.AddItem('CovertActionRisk_Ambush');
	Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');

	Template.Rewards.AddItem('Reward_Rebel');
	Template.Rewards.AddItem('Reward_Rebel');

	return Template;
}

static function CovertActionSlot CreateDefaultSoldierSlot(name SlotName, optional int iMinRank, optional bool bRandomClass, optional bool bFactionClass)
{
	local CovertActionSlot SoldierSlot;

	SoldierSlot.StaffSlot = SlotName;
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHP');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostAim');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostMobility');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostDodge');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostWill');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHacking');
	SoldierSlot.iMinRank = iMinRank;
	SoldierSlot.bChanceFame = false;
	SoldierSlot.bRandomClass = bRandomClass;
	SoldierSlot.bFactionClass = bFactionClass;

	if (SlotName == 'CovertActionRookieStaffSlot')
	{
		SoldierSlot.bChanceFame = false;
	}

	return SoldierSlot;
}

static function ChooseContactedRegionWithoutMEC(XComGameState NewGameState, XComGameState_CovertAction ActionState, out array<StateObjectReference> ExcludeLocations)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_LWOutpost OutpostState;
	local array<StateObjectReference> RegionRefs;
	local array<StateObjectReference> RegionRefsWithoutMECs;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if (ExcludeLocations.Find('ObjectID', RegionState.GetReference().ObjectID) == INDEX_NONE && RegionState.HaveMadeContact())
		{
			RegionRefs.AddItem(RegionState.GetReference());
			OutpostState = class'XComGameState_LWOutpostManager'.static.GetOutpostManager().GetOutpostForRegion(RegionState);
			if (OutpostState != none && OutpostState.GetResistanceMecCount() == 0)
			{
				RegionRefsWithoutMECs.AddItem(RegionState.GetReference());
			}
		}
	}

	// Prefer regions without any Resistance MECs
	if (RegionRefsWithoutMECs.Length > 0)
	{
		ActionState.LocationEntity = RegionRefsWithoutMECs[`SYNC_RAND_STATIC(RegionRefsWithoutMECs.Length)];
	}
	else
	{
		ActionState.LocationEntity = RegionRefs[`SYNC_RAND_STATIC(RegionRefs.Length)];
	}
}
