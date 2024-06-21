//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ControlCivilian.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Swaps an approached civilian to the xcom team to be controllable for evac.
//---------------------------------------------------------------------------------------

class X2StrategyElement_DefaultRewards_LW extends X2StrategyElement_DefaultRewards config(GameData);

const REBEL_REWARD_NAME='Reward_Rebel';
const RESISTANCE_MEC_REWARD_NAME='Reward_ResistanceMEC';
const NEW_RESOURCES_REWARD_NAME='Reward_NewResources';
const CORPSE_REWARD_NAME='Reward_EnemyCorpses';

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Rewards;

	`LWTrace("  >> X2StrategyElement_DefaultRewards_LW.CreateTemplates()");
	
	Rewards.AddItem(CreateRebelRewardTemplate());
	Rewards.AddItem(CreatePOIRewardTemplate());
	Rewards.AddItem(CreateNewResourcesRewardTemplate());
	Rewards.AddItem(CreateDummyEnemyMaterielRewardTemplate());
	Rewards.AddItem(CreateDummyUnknownRewardTemplate());
	Rewards.AddItem(CreateDummyUnhinderedRewardTemplate());
	Rewards.AddItem(CreateDummyPOIRewardTemplate());
	Rewards.AddItem(CreateResistanceMECRewardTemplate());
	Rewards.AddItem(CreateDummyRegionalNetworkTowerRewardTemplate());
	Rewards.AddItem(CreateRadioRelayRewardTemplate());
	Rewards.AddItem(CreateFactionInfluenceRewardTemplate());
	Rewards.AddItem(CreateEnemyCorpsesRewardTemplate());
	Rewards.AddItem(CreateDummyStatBoostRewardTemplate());
	Rewards.AddItem(CreateSupplyMissionRewardTemplate());
	Rewards.AddItem(CreateDetachmentMissionRewardTemplate());
	Rewards.AddItem(CreateRevealChosenStrongholdRewardTemplate());
	return Rewards;
}

static function X2DataTemplate CreateRebelRewardTemplate()
{
    local X2RewardTemplate Template;

    `CREATE_X2Reward_TEMPLATE(Template, REBEL_REWARD_NAME);
    Template.rewardObjectTemplateName = 'Rebel';

    // Rebels are never available or needed. This isn't checked by the activity manager system, only the black market and
    // resistance HQ. This prevents rebels from appearing for purchase in these places.
    Template.IsRewardAvailableFn = AvailableForCovertActionsOnly;
    Template.IsRewardNeededFn = AlwaysFalseNeeded;
    Template.GenerateRewardFn = GenerateRebelReward;
    Template.SetRewardFn = class'X2StrategyElement_DefaultRewards'.static.SetPersonnelReward;
    Template.GiveRewardFn = GiveRebelReward;
    Template.GetRewardStringFn = GetRebelRewardString;
    Template.GetRewardImageFn = class'X2StrategyElement_DefaultRewards'.static.GetPersonnelRewardImage;
    Template.GetBlackMarketStringFn = GetRebelBlackMarketString;
    Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

static function bool AlwaysFalseAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
    return false;
}

static function bool AlwaysFalseNeeded()
{
    return false;
}

static function bool AvailableForCovertActionsOnly(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
    return XComGameState_ResistanceFaction(`XCOMHISTORY.GetGameStateForObjectID(AuxRef.ObjectID)) != none;
}

function GenerateRebelReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference RegionRef)
{
    local XComGameStateHistory History;
    local StateObjectReference NewUnitRef;
    local XComGameState_WorldRegion RegionState;
	local XComGameState_CovertAction CovertAction;
    local XComGameState_LWOutpostManager OutpostManager;
    local XComGameState_LWOutpost Outpost;

    History = `XCOMHISTORY;

    // ActivityManager must pass a region state for reward generation for these rewards, even though the vanilla template only makes them
    // optional.
    RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));
	if (RegionState == none)
	{
		CovertAction = XComGameState_CovertAction(History.GetGameStateForObjectID(RegionRef.ObjectID));
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(CovertAction.LocationEntity.ObjectID));
	}
    OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
    Outpost = OutpostManager.GetOutpostForRegion(RegionState);

    `assert(RegionState != none);

    NewUnitRef = Outpost.CreateRebel(NewGameState, RegionState, true);
    RewardState.RewardObjectReference = NewUnitRef;
}

function GiveRebelReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion Region;
	local XComGameState_CovertAction CovertAction;
	local XComGameState_LWOutpostManager OutpostManager;
	local XComGameState_LWOutpost Outpost;

	History = `XCOMHISTORY;
	Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(AuxRef.ObjectID));
	if (Region == none)
	{
		CovertAction = XComGameState_CovertAction(History.GetGameStateForObjectID(AuxRef.ObjectID));
		Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(CovertAction.LocationEntity.ObjectID));
	}

	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	Outpost = OutpostManager.GetOutpostForRegion(Region);

	Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
	NewGameState.AddStateObject(Outpost);

	Outpost.AddRebel(RewardState.RewardObjectReference, NewGameState);
}

function String GetRebelRewardString(XComGameState_Reward RewardState)
{
    local XComGameStateHistory History;
    local XComGameState_Unit Unit;

    History = `XCOMHISTORY;
    Unit = XComGameState_Unit(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));

    if (Unit != none)
    {
        return Unit.GetName(eNameType_Full) @ "-" @ RewardState.GetMyTemplate().DisplayName;
    }

    return "";
}

function String GetRebelBlackMarketString(XComGameState_Reward RewardState)
{
    `redscreen("GetRebelBlackMarketString called. Rebels should not be available in the black market!");
    return "";
}

static function X2DataTemplate CreatePOIRewardTemplate()
{
    local X2RewardTemplate Template;

   	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_POI_LW');
	Template.rewardObjectTemplateName = 'POI';

	Template.GenerateRewardFn = GeneratePOIReward;
	Template.SetRewardFn = SetPOIReward;
	Template.GiveRewardFn = GivePOIReward;
	Template.GetRewardStringFn = GetPOIRewardString;
	
	Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

function string GetPOIRewardString(XComGameState_Reward RewardState)
{
	return RewardState.GetMyTemplate().DisplayName;
}

function GeneratePOIReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference RegionRef)
{
	RewardState.Quantity = 1;
}

function SetPOIReward(XComGameState_Reward RewardState, optional StateObjectReference RewardObjectRef, optional int Amount)
{
	RewardState.Quantity = Amount;
}

function GivePOIReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool border = false, optional int OrderHours = -1)
{
}

function string GetSimpleRewardString(XComGameState_Reward RewardState)
{
	return RewardState.GetMyTemplate().DisplayName;
}

static function X2DataTemplate CreateDummyEnemyMaterielRewardTemplate()
{
    local X2RewardTemplate Template;

   	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_Dummy_Materiel');

	Template.GenerateRewardFn = none;
	Template.SetRewardFn = none;
	Template.GiveRewardFn = none;
	Template.GetRewardStringFn = GetSimpleRewardString;
	Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

static function X2DataTemplate CreateDummyUnknownRewardTemplate()
{
    local X2RewardTemplate Template;

   	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_Dummy_Unknown');
	Template.GenerateRewardFn = none;
	Template.SetRewardFn = none;
	Template.GiveRewardFn = none;
	Template.GetRewardStringFn = GetSimpleRewardString;
	Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}


static function X2DataTemplate CreateDummyRegionalNetworkTowerRewardTemplate()
{
    local X2RewardTemplate Template;

   	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_Dummy_RegionalTower');
	Template.GenerateRewardFn = none;
	Template.SetRewardFn = none;
	Template.GiveRewardFn = none;
	Template.GetRewardStringFn = GetSimpleRewardString;
	Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

static function X2DataTemplate CreateDummyUnhinderedRewardTemplate()
{
    local X2RewardTemplate Template;

   	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_Dummy_Unhindered');
	Template.GenerateRewardFn = none;
	Template.SetRewardFn = none;
	Template.GiveRewardFn = none;
	Template.GetRewardStringFn = GetSimpleRewardString;
	Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

static function X2DataTemplate CreateDummyPOIRewardTemplate()
{
    local X2RewardTemplate Template;

   	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_Dummy_POI');
	Template.GenerateRewardFn = none;
	Template.SetRewardFn = none;
	Template.GiveRewardFn = none;
	Template.GetRewardStringFn = GetPOIRewardString;
	Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

static function X2DataTemplate CreateResistanceMECRewardTemplate()
{
    local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, RESISTANCE_MEC_REWARD_NAME);
	Template.rewardObjectTemplateName = 'ResistanceMEC';
	//Template.GenerateRewardFn = GenerateResistanceMECReward;
	Template.GiveRewardFn = GiveResistanceMECReward;
	//Template.SetRewardFn = class'X2StrategyElement_DefaultRewards'.static.SetPersonnelReward;

	Template.IsRewardAvailableFn = AvailableForCovertActionsOnly;
    Template.IsRewardNeededFn = AlwaysFalseNeeded;
	Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;
	Template.GetRewardStringFn = GetSimpleRewardString;

    return Template;
}

function GiveResistanceMECReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion Region;
	local XComGameState_CovertAction CovertAction;
	local XComGameState_LWOutpostManager OutpostManager;
	local XComGameState_LWOutpost Outpost;

	History = `XCOMHISTORY;
	Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(AuxRef.ObjectID));
	if (Region == none)
	{
		CovertAction = XComGameState_CovertAction(History.GetGameStateForObjectID(AuxRef.ObjectID));
		Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(CovertAction.LocationEntity.ObjectID));
	}

	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	Outpost = OutpostManager.GetOutpostForRegion(Region);
	Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
	NewGameState.AddStateObject(Outpost);
	Outpost.AddResistanceMEC(Outpost.CreateResistanceMec(NewGameState), NewGameState);
}


static function X2DataTemplate CreateNewResourcesRewardTemplate()
{
    local X2RewardTemplate Template;

    `CREATE_X2Reward_TEMPLATE(Template, NEW_RESOURCES_REWARD_NAME);
    Template.IsRewardAvailableFn = AlwaysFalseAvailable;
    Template.IsRewardNeededFn = AlwaysFalseNeeded;
    Template.GiveRewardFn = GiveResetSupplyCapReward;
    Template.GetRewardStringFn = GetSimpleRewardString;
    Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

function GiveResetSupplyCapReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
    local XComGameStateHistory History;
    local XComGameState_WorldRegion Region;
    local XComGameState_LWOutpostManager OutpostManager;
    local XComGameState_LWOutpost Outpost;

	History = `XCOMHISTORY;
    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(AuxRef.ObjectID));
    OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
    Outpost = OutpostManager.GetOutpostForRegion(Region);
    Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
    NewGameState.AddStateObject(Outpost);
	OutPost.SuppliesTaken = 0;

	// this applies a fix to campaigns with 0 cap
	if (OutPost.SupplyCap <= 0)
	{
		OutPost.SupplyCap = class'XComGameState_LWOutpost'.default.SupplyCap_Min;
	}
}

function GiveRadioRelayReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
    local XComGameStateHistory History;
    local XComGameState_WorldRegion Region;

	History = `XCOMHISTORY;
    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(AuxRef.ObjectID));
	Region.SetResistanceLevel(NewGameState, eResLevel_Outpost);
}

static function X2DataTemplate CreateRadioRelayRewardTemplate()
{
    local X2RewardTemplate Template;

    `CREATE_X2Reward_TEMPLATE(Template, 'Reward_Radio_Relay');
    Template.IsRewardAvailableFn = AlwaysFalseAvailable;
    Template.IsRewardNeededFn = AlwaysFalseNeeded;
    Template.GiveRewardFn = GiveRadioRelayReward;
    Template.GetRewardStringFn = GetSimpleRewardString;
    Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;
    return Template;
}

static function X2DataTemplate CreateFactionInfluenceRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_FactionInfluence_LW');

	Template.IsRewardAvailableFn = AlwaysFalseAvailable;
	Template.IsRewardNeededFn = AlwaysFalseNeeded;
	Template.GenerateRewardFn = GenerateFactionInfluenceReward;
	Template.GiveRewardFn = GiveFactionInfluenceReward;
	Template.GetRewardImageFn = GetFactionInfluenceRewardImage;
	Template.GetRewardStringFn = GetFactionInfluenceRewardString;
	Template.CleanUpRewardFn = class'X2StrategyElement_DefaultRewards'.static.CleanUpRewardWithoutRemoval;

	return Template;
}

static function GenerateFactionInfluenceReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference RegionRef)
{
	RewardState.RewardObjectReference = RegionRef;
}

static function GiveFactionInfluenceReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference RegionRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_ResistanceFaction FactionState;

	FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(
        class'XComGameState_ResistanceFaction', class'Helpers_LW'.static.GetFactionFromRegion(RegionRef).ObjectID));
	FactionState.IncreaseInfluenceLevel(NewGameState);
}

static function string GetFactionInfluenceRewardImage(XComGameState_Reward RewardState)
{
	local XComGameState_AdventChosen ChosenState;

	ChosenState = class'Helpers_LW'.static.GetFactionFromRegion(RewardState.RewardObjectReference).GetRivalChosen();

	return ChosenState.GetHuntChosenImage(0);
}

static function string GetFactionInfluenceRewardString(XComGameState_Reward RewardState)
{
	return RewardState.GetMyTemplate().DisplayName;
}

static function X2DataTemplate CreateEnemyCorpsesRewardTemplate()
{
    local X2RewardTemplate Template;

    `CREATE_X2Reward_TEMPLATE(Template, const.CORPSE_REWARD_NAME);
    Template.rewardObjectTemplateName = 'EnemyCorpses';

    // Corpses are never available or needed. This isn't checked by the activity manager system, only the black market and
    // resistance HQ. This prevents corpses from appearing for purchase in these places.
    Template.IsRewardAvailableFn = IsCorpseRewardAvailable;
    Template.IsRewardNeededFn = AlwaysFalseNeeded;
    Template.SetRewardByTemplateFn = SetLootTableReward;
    Template.GiveRewardFn = GiveLootTableReward;
    Template.GetRewardStringFn = GetLootTableRewardString;

    return Template;
}

static function bool IsCorpseRewardAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
    return AuxRef.ObjectID != 0 && AlienHQ.GetForceLevel() >= 5;
}

static function X2DataTemplate CreateDummyStatBoostRewardTemplate()
{
    local X2RewardTemplate Template;

    `CREATE_X2Reward_TEMPLATE(Template, 'Reward_Dummy_StatBoost');
    Template.GenerateRewardFn = none;
    Template.SetRewardFn = none;
    Template.GiveRewardFn = none;
    Template.GetRewardStringFn = none;
    Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

static function X2DataTemplate CreateSupplyMissionRewardTemplate()
{
    local X2RewardTemplate Template;

    `CREATE_X2Reward_TEMPLATE(Template, 'Reward_Supply_Mission');
    Template.GenerateRewardFn = none;
    Template.SetRewardFn = none;
    Template.GiveRewardFn = CreateSupplyMissionReward;
    Template.GetRewardStringFn = none;
    Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

static function X2DataTemplate CreateRevealChosenStrongholdRewardTemplate()
{
	local X2RewardTemplate Template;

	`CREATE_X2Reward_TEMPLATE(Template, 'Reward_LWRevealStronghold');

	Template.IsRewardAvailableFn = AlwaysTrue;
	Template.GenerateRewardFn = GenerateChosenStrongholdReward;
	Template.GiveRewardFn = CreateRevealActivateStrongholdReward;
	Template.GetRewardImageFn = GetUnlockStrongholdRewardImage;
	Template.CleanUpRewardFn = CleanUpRewardWithoutRemoval;
	Template.RewardPopupFn = FactionInfluenceRewardPopup;

	return Template;
}

static function CreateSupplyMissionReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_LWAlienActivity NewActivityState;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local X2StrategyElementTemplateManager StrategyElementTemplateMgr;
	local XComGameState_CovertAction ActionState;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(AuxRef.ObjectID));

	`LWTrace("Trying to spawn Big Supply Extract Mission");
	StrategyElementTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	ActivityTemplate = X2LWAlienActivityTemplate(StrategyElementTemplateMgr.FindStrategyElementTemplate('BigSupplyExtraction_LW'));

	NewActivityState = ActivityTemplate.CreateInstanceFromTemplate(ActionState.Region, NewGameState);
	NewActivityState.bNeedsUpdateDiscovery = true;
	NewGameState.AddStateObject(NewActivityState);
}

static function X2DataTemplate CreateDetachmentMissionRewardTemplate()
{
    local X2RewardTemplate Template;

    `CREATE_X2Reward_TEMPLATE(Template, 'Reward_Detachment_Mission');
    Template.GenerateRewardFn = none;
    Template.SetRewardFn = none;
    Template.GiveRewardFn = CreateDetachmentMissionReward;
    Template.GetRewardStringFn = none;
    Template.GetRewardIconFn = class'X2StrategyElement_DefaultRewards'.static.GetGenericRewardIcon;

    return Template;
}

static function CreateDetachmentMissionReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_LWAlienActivity NewActivityState;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local X2StrategyElementTemplateManager StrategyElementTemplateMgr;
	local XComGameState_CovertAction ActionState;

	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(AuxRef.ObjectID));

	`LWTrace("Trying to spawn Advent Detachment Mission");
	StrategyElementTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	ActivityTemplate = X2LWAlienActivityTemplate(StrategyElementTemplateMgr.FindStrategyElementTemplate('CovertOpsTroopManeuvers'));

	NewActivityState = ActivityTemplate.CreateInstanceFromTemplate(ActionState.Region, NewGameState);
	NewActivityState.bNeedsUpdateDiscovery = true;
	NewGameState.AddStateObject(NewActivityState);
}

static function GenerateChosenStrongholdReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference RegionRef)
{
	RewardState.RewardObjectReference = RegionRef;
}

static function FactionInfluenceRewardPopup(XComGameState_Reward RewardState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_ResistanceFaction FactionState;

	RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));	
	FactionState = RegionState.GetControllingChosen().GetRivalFaction();
	
	`HQPRES.UIChosenFragmentRecovered(FactionState.GetRivalChosen().GetReference(), 3);
}

static function string GetUnlockStrongholdRewardImage(XComGameState_Reward RewardState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_AdventChosen ChosenState;

	RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));	

	ChosenState = RegionState.GetControllingChosen();

	return ChosenState.GetHuntChosenImage(2);
}

static function CreateRevealActivateStrongholdReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder = false, optional int OrderHours = -1)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_AdventChosen ChosenState;

	RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));	

	ChosenState = RegionState.GetControllingChosen();

	ChosenState.MakeStrongholdMissionVisible(NewGameState);
	ChosenState.MakeStrongholdMissionAvailable(NewGameState);

}

static function bool AlwaysTrue(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	return true;
}