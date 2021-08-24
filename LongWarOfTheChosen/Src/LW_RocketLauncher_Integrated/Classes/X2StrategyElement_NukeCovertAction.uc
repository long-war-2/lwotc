class X2StrategyElement_NukeCovertAction extends X2StrategyElement_DefaultCovertActions config(GameBoard);

var config name RequiredTechForCovertAction;
var config bool	bRequireFactionSoldier;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Create_NukeCovertAction());

	Templates.AddItem(Create_NuclearMaterialReward());

	return Templates;
}

static function X2DataTemplate Create_NukeCovertAction()
{
	local X2CovertActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2CovertActionTemplate', Template, 'CovertAction_IRI_Nuke');

	Template.ChooseLocationFn = ChooseRandomRegion;
	Template.OverworldMeshPath = "UI_3D.Overwold_Final.CovertAction";
	Template.bForceCreation = true;
	Template.bUnique = true;  // If true, this Covert Action can only be completed once per faction per game.
	Template.bMultiplesAllowed = false; // If true, this Covert Action can appear be presented by multiple factions at the same time

	Template.RequiredFactionInfluence = eFactionInfluence_Influential;
	//Template.RequiredFactionInfluence = eFactionInfluence_Minimal;

	Template.Narratives.AddItem('CovertActionNarrative_IRI_Nuke');

	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 6,, default.bRequireFactionSoldier));
	Template.Slots.AddItem(CreateDefaultSoldierSlot('CovertActionSoldierStaffSlot', 6));
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionScientistStaffSlot'));
	Template.Slots.AddItem(CreateDefaultStaffSlot('CovertActionEngineerStaffSlot'));
	
	Template.Risks.AddItem('CovertActionRisk_SoldierWounded');
	Template.Risks.AddItem('CovertActionRisk_Ambush');
	//Template.Risks.AddItem('CovertActionRisk_SoldierCaptured');

	Template.Rewards.AddItem('Reward_IRI_NuclearMaterial');

	return Template;
}

static function X2DataTemplate Create_NuclearMaterialReward()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_IRI_NuclearMaterial');

	Template.rewardObjectTemplateName = 'IRI_NuclearMaterial';

	Template.IsRewardAvailableFn = IsTacticalNukeAvailable;
	Template.GenerateRewardFn = class'X2StrategyElement_DefaultRewards'.static.GenerateItemReward;
	Template.SetRewardFn = class'X2StrategyElement_DefaultRewards'.static.SetItemReward;
	Template.GiveRewardFn = GiveItemReward;
	Template.GetRewardStringFn = class'X2StrategyElement_DefaultRewards'.static.GetItemRewardString;
	Template.GetRewardImageFn = class'X2StrategyElement_DefaultRewards'.static.GetItemRewardImage;
	Template.GetBlackMarketStringFn = class'X2StrategyElement_DefaultRewards'.static.GetItemBlackMarketString;
	Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;
	Template.RewardPopupFn = class'X2StrategyElement_DefaultRewards'.static.ItemRewardPopup;

	return Template;
}

static function bool IsTacticalNukeAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory				History;
	local XComGameState_HeadquartersXCom	XComHQ;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

	if (default.RequiredTechForCovertAction == '') return true;

	if (XComHQ != none && XComHQ.IsTechResearched(default.RequiredTechForCovertAction))
	{
		return true;
	}
	else
	{
		return false;
	}
}

//	Give the item, then show popup that Tactical Nuke Proving Grounds project is available.
static function GiveItemReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_Tech				TechState;
	local XComGameStateHistory				History;
	local XComGameState_HeadquartersXCom	XComHQ;

	class'X2StrategyElement_DefaultRewards'.static.GiveItemReward(NewGameState, RewardState, AuxRef, bOrder, OrderHours);

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom', true));

	if (XComHQ != none)
	{
		foreach History.IterateByClassType(class'XComGameState_Tech', TechState)
		{
			//	Project should be automatically available since Covert Action won't appear unless Powered Rocket was done at least once.
			if (TechState.GetMyTemplateName() == 'IRI_TacticalNuke_Tech' /* && XComHQ.IsTechAvailableForResearch(TechState.GetReference(), false, true)*/)
			{
				`HQPRES.UIProvingGroundProjectAvailable(TechState.GetReference());
				break;
			}
		}
	}
}

//	These have to be copypasted because they're private (confused_jackie.jpg)

private static function CovertActionSlot CreateDefaultSoldierSlot(name SlotName, optional int iMinRank, optional bool bRandomClass, optional bool bFactionClass)
{
	local CovertActionSlot SoldierSlot;

	SoldierSlot.StaffSlot = SlotName;
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHP');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostAim');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostMobility');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostDodge');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostWill');
	SoldierSlot.Rewards.AddItem('Reward_StatBoostHacking');
	SoldierSlot.Rewards.AddItem('Reward_RankUp');
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

private static function CovertActionSlot CreateDefaultStaffSlot(name SlotName)
{
	local CovertActionSlot StaffSlot;
	
	// Same as Soldier Slot, but no rewards
	StaffSlot.StaffSlot = SlotName;
	StaffSlot.bReduceRisk = false;
	
	return StaffSlot;
}