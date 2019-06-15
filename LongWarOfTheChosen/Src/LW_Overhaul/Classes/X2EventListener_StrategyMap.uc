class X2EventListener_StrategyMap extends X2EventListener config(LW_Overhaul);

var localized string strTimeRemainingHoursOnly;
var localized string strTimeRemainingDaysAndHours;

var config int LISTENER_PRIORITY;

// Black market stuff
var config array<float> BLACK_MARKET_PROFIT_MARGIN;

var config int BLACK_MARKET_2ND_SOLDIER_FL;
var config int BLACK_MARKET_3RD_SOLDIER_FL;
var config float BLACK_MARKET_PERSONNEL_INFLATION_PER_FORCE_LEVEL;
var config float BLACK_MARKET_SOLDIER_DISCOUNT;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateMissionSiteListeners());
	Templates.AddItem(CreateMiscellaneousListeners());
	Templates.AddItem(CreateBlackMarketListeners());
	Templates.AddItem(CreateEndOfMonthListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateMissionSiteListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'MissionSiteListeners');
	Template.AddCHEvent('StrategyMapMissionSiteSelected', OnMissionSiteSelected, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('OverrideMissionSiteTooltip', OnOverrideMissionSiteTooltip, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('MissionIconSetMissionSite', CustomizeMissionSiteIcon, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('OverrideMissionSiteIconImage', CustomizeMissionSiteIconImage, ELD_Immediate, GetListenerPriority());
	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateMiscellaneousListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'GeoscapeEntryListeners');
	Template.AddCHEvent('OnGeoscapeEntry', StopFirstPOISpawn, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('OnGeoscapeEntry', ShowBlackMarket, ELD_Immediate, GetListenerPriority());

	//Added for fix to issue #100
	Template.AddCHEvent('OverrideCurrentDoom', OverrideCurrentDoom, ELD_Immediate, GetListenerPriority());

	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateBlackMarketListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'BlackMarketListeners');
	Template.AddCHEvent('BlackMarketGoodsReset', OnBlackMarketGoodsReset, ELD_Immediate, GetListenerPriority());

	Template.RegisterInStrategy = true;

	return Template;
}

// Various end of month handling, especially for supply income determination.
// Note: this is very fiddly. There are several events fired from different parts of the end-of-month processing
// in the HQ. For most of this, there is an outstanding game state being generated but which hasn't yet been added
// to the history. This state persists over several of these events before finally being submitted, so care must be
// taken to check if the object we want to change is already present in the game state rather than fetching the
// latest submitted one from the history, which would be stale.
static function CHEventListenerTemplate CreateEndOfMonthListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'EndOfMonthListeners');
	Template.AddCHEvent('PostEndOfMonth', OnMonthEnd, ELD_OnStateSubmitted, GetListenerPriority());

	// Pre end of month. Called before we begin any end of month processing, but after the new game state is created.
	// This is used to make sure we trigger one last update event on all the outposts so the income for the last
	// day of the month is computed. This updates the outpost but the won't be submitted yet.
	Template.AddCHEvent('PreEndOfMonth', PreEndOfMonth, ELD_Immediate, GetListenerPriority());

	// A request was made for the real monthly supply reward. This is called twice: first from the HQ to get the true
	// number of supplies to reward, and then again by UIResistanceReport to display the value in the report screen.
	// The first one is called while the game state is still pending and so needs to pull the outpost from the pending
	// game state. The second is called after the update is submitted and is passed a null game state, so it can read the
	// outpost from the history.
	Template.AddCHEvent('OverrideSupplyDrop', OnMonthlySuppliesReward, ELD_Immediate, GetListenerPriority());

	//process negative monthly income -- this happens after deductions for maint, so can't go into the OnMonthlySuppliesReward
	Template.AddCHEvent('NegativeMonthlyIncome', OnMonthlyNegativeSupplyIncome, ELD_Immediate, GetListenerPriority());

	// After closing the monthly report dialog. This is responsible for doing outpost end-of-month processing including
	// resetting the supply state.
	Template.AddCHEvent('PostEndOfMonth', PostEndOfMonth, ELD_OnStateSubmitted, GetListenerPriority());

	// Supply loss monthly report string replacement
	Template.AddCHEvent('OverrideSupplyLossStrings', OnGetSupplyDropDecreaseStrings, ELD_Immediate, GetListenerPriority());

	Template.RegisterInStrategy = true;

	return Template;
}

static protected function int GetListenerPriority()
{
	return default.LISTENER_PRIORITY != -1 ? default.LISTENER_PRIORITY : class'XComGameState_LWListenerManager'.default.DEFAULT_LISTENER_PRIORITY;
}

//Issue #100. This just iterates through all of the missions that have doom (whether the mission is available or not) and adds their doom values up
//and adds that total value to the current doom for overall doom so that the game displays the correct amount of current doom in the avatar meter.
static function EventListenerReturn OverrideCurrentDoom(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_MissionSite MissionState;
	local int DoomMod;
	local XComLWTuple Tuple;

	Tuple = XComLWTuple(EventData);
	if(Tuple == none)
		return ELR_NoInterrupt;

	if( class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject') ) // only show activity doom if AVATAR project revealed
	{
		History = `XCOMHISTORY;
		foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
		{
			if(ActivityState.Doom > 0)
				DoomMod += ActivityState.Doom;

			// base game only adds doom for visible missions, so add doom for hidden missions here
			if (ActivityState.CurrentMissionRef.ObjectID > 0)
			{
				MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(ActivityState.CurrentMissionRef.ObjectID));
				if (MissionState != none && !MissionState.Available)
				{
					if (MissionState.Doom > 0)
						DoomMod += MissionState.Doom;
				}
			}
		}
	}
	
	Tuple.Data[0].i += DoomMod;

	return ELR_NoInterrupt;
}

// Launches the mission information screen on the Geoscape for missions that don't
// have squads infiltrating them yet.
static function EventListenerReturn OnMissionSiteSelected(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameState_MissionSite		MissionSite;
	local XComGameState_LWAlienActivity ActivityState;

	MissionSite = XComGameState_MissionSite(EventData);
	if(MissionSite == none)
		return ELR_NoInterrupt;

	ActivityState = `LWACTIVITYMGR.FindAlienActivityByMission(MissionSite);

	if(ActivityState != none)
	{
		ActivityState.TriggerMissionUI(MissionSite);
	}

	return ELR_NoInterrupt;
}

// Overrides the mission icon tooltip to display expiry time.
static function EventListenerReturn OnOverrideMissionSiteTooltip(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComLWTuple Tuple;
	local UIStrategyMap_MissionIcon MissionIcon;
	local string Title, Body;
	
	Tuple = XComLWTuple(EventData);
	if(Tuple == none)
		return ELR_NoInterrupt;

	MissionIcon = UIStrategyMap_MissionIcon(EventSource);
	if(MissionIcon == none)
	{
		`REDSCREEN("OnOverrideMissionSiteTooltip event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	GetMissionSiteUIButtonToolTip(Title, Body, MissionIcon);
	Tuple.Data[0].Kind = XComLWTVString;
	Tuple.Data[0].s = Title;
	Tuple.Data[1].Kind = XComLWTVString;
	Tuple.Data[1].s = Body;
	return ELR_NoInterrupt;
}

// Overrides the mission icon image path so that the mission icon displays
// the appropriate GOp or Council mission image.
static function EventListenerReturn CustomizeMissionSiteIconImage(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_MissionSite MissionSite;
	local XComGameState_LWAlienActivity AlienActivity;
	
	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
		return ELR_NoInterrupt;

	MissionSite = XComGameState_MissionSite(EventSource);
	if (MissionSite == none)
	{
		`REDSCREEN("CustomizeMissionSiteIconImage event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	AlienActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionSite);
	if (AlienActivity != none )
	{
		Tuple.Data[0].s = AlienActivity.GetMissionIconImage(MissionSite);
	}

	return ELR_NoInterrupt;
}

// Ensures that clicking a mission icon pops up the mission infiltration screen if that mission
// has a squad currently infiltrating.
static function EventListenerReturn CustomizeMissionSiteIcon(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComGameState_LWAlienActivity AlienActivity;
	local UIStrategyMap_MissionIcon MissionIcon;
	local XComGameState_LWPersistentSquad InfiltratingSquad;
	local string Title, Body;
	
	MissionIcon = UIStrategyMap_MissionIcon(EventSource);
	if (MissionIcon == none)
	{
		`REDSCREEN("CustomizeMissionSiteIcon event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	InfiltratingSquad = `LWSQUADMGR.GetSquadOnMission(MissionIcon.MissionSite.GetReference());
	if (InfiltratingSquad != none && UIStrategyMapItem_Mission_LW(MissionIcon.MapItem) != none)
	{
		// A squad is infiltrating this mission, so bring up the infiltration screen
		// (UIMission_LWDelayedLaunch) so that the player can launch it or just see
		// details of the squad, etc.
		MissionIcon.OnClickedDelegate = UIStrategyMapItem_Mission_LW(MissionIcon.MapItem).OpenInfiltrationMissionScreen;
	}

	GetMissionSiteUIButtonToolTip(Title, Body, MissionIcon);
	MissionIcon.SetMissionIconTooltip(Title, Body);

	return ELR_NoInterrupt;
}

// Returns the time left before the mission for the given icon expires. Also sets the
// body to the mission objective.
protected static function GetMissionSiteUIButtonToolTip(out string Title, out string Body, UIStrategyMap_MissionIcon MissionIcon)
{
	local XComGameState_LWPersistentSquad InfiltratingSquad;
	local X2MissionTemplate MissionTemplate;
	local float RemainingSeconds;
	local int Hours, Days;
	local XComGameState_LWAlienActivity AlienActivity;
	local XGParamTag ParamTag;
	local XComGameState_MissionSite MissionSite;

	MissionSite = MissionIcon.MissionSite;

	InfiltratingSquad = `LWSQUADMGR.GetSquadOnMission(MissionSite.GetReference());
	if(InfiltratingSquad != none)
	{
		Title = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(InfiltratingSquad.sSquadName);
	}
	else
	{
		MissionTemplate = class'X2MissionTemplateManager'.static.GetMissionTemplateManager().FindMissionTemplate(MissionSite.GeneratedMission.Mission.MissionName);
		Title = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(MissionTemplate.PostMissionType);
	}

	AlienActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionSite);
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

	if(AlienActivity != none)
		RemainingSeconds = AlienActivity.SecondsRemainingCurrentMission();
	else
		if (MissionSite.ExpirationDateTime.m_iYear >= 2050)
			RemainingSeconds = 2147483640;
		else
			RemainingSeconds = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(MissionSite.ExpirationDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime());

	Days = int(RemainingSeconds / 86400.0);
	Hours = int(RemainingSeconds / 3600.0) % 24;

	if(Days < 730)
	{
		Title $= ": ";

		ParamTag.IntValue0 = Hours;
		ParamTag.IntValue1 = Days;

		if(Days >= 1)
			Title $= `XEXPAND.ExpandString(default.strTimeRemainingDaysAndHours);
		else
			Title $= `XEXPAND.ExpandString(default.strTimeRemainingHoursOnly);
	}

	Body = MissionSite.GetMissionObjectiveText();
}

// On Geoscape Entry, hack the resistance HQ so that it appears to have spawned the
// first POI.
static function EventListenerReturn StopFirstPOISpawn(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameState_HeadquartersResistance ResHQ;
	
	ResHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	ResHQ.bFirstPOISpawned = true;
	
	return ELR_NoInterrupt;	
}

static function EventListenerReturn ShowBlackMarket(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_BlackMarket BlackMarket;
	local bool AddGameStateToHistory;

	History = `XCOMHISTORY;
	BlackMarket = XComGameState_BlackMarket(History.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));

	// Check whether the black market is already visible on the geoscape or not
	if(!BlackMarket.bIsOpen && !BlackMarket.bNeedsScan)
	{
		// It's not, so force it to show now
		if (NewGameState.bReadOnly)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Opening up Black Market");
			AddGameStateToHistory = true;
		}
		
		BlackMarket = XComGameState_BlackMarket(NewGameState.ModifyStateObject(class'XComGameState_BlackMarket', BlackMarket.ObjectID));
		BlackMarket.ShowBlackMarket(NewGameState, true);

		if (AddGameStateToHistory)
		{
			History.AddGameStateToHistory(NewGameState);
		}
	}
}

// Override the Black Market to make items purchasable with supplies and
// remove the supplies reward from inventory
static function EventListenerReturn OnBlackMarketGoodsReset(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_BlackMarket BlackMarket;
	local XComGameState_Reward RewardState;
	local int ResourceIdx, Idx, ItemIdx;
 	local bool bStartState;
	local XComGameState_Item ItemState;
	local XComPhotographer_Strategy Photo;
	local X2StrategyElementTemplateManager StratMgr;
	local X2RewardTemplate RewardTemplate;
	local array<XComGameState_Tech> TechList;
	local Commodity ForSaleItem, EmptyForSaleItem;
	local array<name> PersonnelRewardNames;
	local array<XComGameState_Item> ItemList;
	local ArtifactCost ResourceCost;
	local XComGameState_HeadquartersAlien AlienHQ;
	//local array<StateObjectReference> AllItems, InterestCandidates;
	//local name InterestName;
	//local int i,k;

	BlackMarket = XComGameState_BlackMarket(EventData);

	if (BlackMarket == none)
	{
		`REDSCREEN("BlackMarketGoodsReset called with no object");
		return ELR_NoInterrupt;
	}

	if (NewGameState == none)
	{
		`REDSCREEN("No game state context provided for BlackMarketGoodsReset");
		return ELR_NoInterrupt;
	}

	// We can't use the event data as our BlackMarket game state as the event
	// manager is providing us with the last state in the history, rather than
	// the one `ResetBlackMarketGoods` sends us. So we have to pull the game state
	// from `NewGameState` instead.	
	BlackMarket = XComGameState_BlackMarket(NewGameState.ModifyStateObject(class'XComGameState_BlackMarket', BlackMarket.ObjectID));
	History = `XCOMHISTORY;
	bStartState = (NewGameState.GetContext().IsStartState());

	// WOTC DEBUGGING:
	`LWTrace("  >> Processing Black Market goods");
	// END

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	BlackMarket.ForSaleItems.Length = 0;

	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_TechRush'));
	TechList = BlackMarket.RollForTechRushItems();

	// Tech Rush Rewards
	for(idx = 0; idx < TechList.Length; idx++)
	{
		ForSaleItem = EmptyForSaleItem;
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		RewardState.SetReward(TechList[idx].GetReference());
		ForSaleItem.RewardRef = RewardState.GetReference();

		ForSaleItem.Title = RewardState.GetRewardString();
		ForSaleItem.Cost = BlackMarket.GetTechRushCost(TechList[idx], NewGameState);
		for (ResourceIdx = 0; ResourceIdx < ForSaleItem.Cost.ResourceCosts.Length; ResourceIdx ++)
		{
			if (ForSaleItem.Cost.ResourceCosts[ResourceIdx].ItemTemplateName == 'Intel')
			{
				ForSaleItem.Cost.ResourceCosts[ResourceIdx].ItemTemplateName = 'Supplies';
			}
		}
		ForSaleItem.Desc = RewardState.GetBlackMarketString();
		ForSaleItem.Image = RewardState.GetRewardImage();
		ForSaleItem.CostScalars = BlackMarket.GoodsCostScalars;
		ForSaleItem.DiscountPercent = BlackMarket.GoodsCostPercentDiscount;

		BlackMarket.ForSaleItems.AddItem(ForSaleItem);
	}

	// Dudes, one each per month
	PersonnelRewardNames.AddItem('Reward_Scientist');
	PersonnelRewardNames.AddItem('Reward_Engineer');
	PersonnelRewardNames.AddItem('Reward_Soldier');

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	if (AlienHQ.GetForceLevel() >= default.BLACK_MARKET_2ND_SOLDIER_FL)
		PersonnelRewardNames.AddItem('Reward_Soldier');

	if (AlienHQ.GetForceLevel() >= default.BLACK_MARKET_3RD_SOLDIER_FL)
		PersonnelRewardNames.AddItem('Reward_Soldier');

	for (idx=0; idx < PersonnelRewardNames.Length; idx++)
	{
		ForSaleItem = EmptyForSaleItem;
		RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate(PersonnelRewardNames[idx]));
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		RewardState.GenerateReward(NewGameState,, BlackMarket.Region);
		ForSaleItem.RewardRef = RewardState.GetReference();
		ForSaleItem.Title = RewardState.GetRewardString();
		ForSaleItem.Cost = BlackMarket.GetPersonnelForSaleItemCost();

		for (ResourceIdx = 0; ResourceIdx < ForSaleItem.Cost.ResourceCosts.Length; ResourceIdx ++)
		{
			if (ForSaleItem.Cost.ResourceCosts[ResourceIdx].ItemTemplateName == 'Intel')
			{
				ForSaleItem.Cost.ResourceCosts[ResourceIdx].ItemTemplateName = 'Supplies'; // add 10% per force level, soldiers 1/4 baseline, baseline
				ForSaleItem.Cost.ResourceCosts[ResourceIdx].Quantity *= 1 + ((AlienHQ.GetForceLevel() - 1) * default.BLACK_MARKET_PERSONNEL_INFLATION_PER_FORCE_LEVEL);
				if (PersonnelRewardNames[idx] == 'Reward_Soldier')
					ForSaleItem.Cost.ResourceCosts[ResourceIdx].Quantity *= default.BLACK_MARKET_SOLDIER_DISCOUNT;
			}
		}

		ForSaleItem.Desc = RewardState.GetBlackMarketString();
		ForSaleItem.Image = RewardState.GetRewardImage();
		ForSaleItem.CostScalars = BlackMarket.GoodsCostScalars;
		ForSaleItem.DiscountPercent = BlackMarket.GoodsCostPercentDiscount;
		if(ForSaleItem.Image == "")
		{
			`HQPRES.GetPhotoboothAutogen().AddHeadshotRequest(
					RewardState.RewardObjectReference,
					512, 512,
					None);
			`HQPRES.GetPhotoboothAutogen().RequestPhotos();
		}
		BlackMarket.ForSaleItems.AddItem(ForSaleItem);
	}

	ItemList = BlackMarket.RollForBlackMarketLoot (NewGameState);

	//`LOG ("ItemList Length:" @ string(ItemList.Length));

	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Item'));
	for (Idx = 0; idx < ItemList.Length; idx++)
	{
		ForSaleItem = EmptyForSaleItem;
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		RewardState.SetReward(ItemList[Idx].GetReference());
		ForSaleItem.RewardRef = RewardState.GetReference();
		ForSaleItem.Title = RewardState.GetRewardString();

		//ForSaleItem.Title = class'UIUtilities_Text_LW'.static.StripHTML (ForSaleItem.Title); // StripHTML not needed and doesn't work yet

		ItemState = XComGameState_Item (History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
		ForSaleItem.Desc = RewardState.GetBlackMarketString() $ "\n\n" $ ItemState.GetMyTemplate().GetItemBriefSummary();// REPLACE WITH ITEM DESCRIPTION!
		ForSaleItem.Image = RewardState.GetRewardImage();
		ForSaleItem.CostScalars = BlackMarket.GoodsCostScalars;
		ForSaleItem.DiscountPercent = BlackMarket.GoodsCostPercentDiscount;

		ResourceCost.ItemTemplateName = 'Supplies';
		ResourceCost.Quantity = ItemState.GetMyTemplate().TradingPostValue * default.BLACK_MARKET_PROFIT_MARGIN[`STRATEGYDIFFICULTYSETTING];

		`LWTRACE (ForSaleItem.Title @ ItemState.Quantity);

		if (ItemState.Quantity > 1)
		{
			ResourceCost.Quantity *= ItemState.Quantity;
		}
		ForSaleItem.Cost.ResourceCosts.AddItem (ResourceCost);
		BlackMarket.ForSaleItems.AddItem(ForSaleItem);
	}

	// switch to supplies cost, fix items sale price to TPV
	for (ItemIdx = BlackMarket.ForSaleItems.Length - 1; ItemIdx >= 0; ItemIdx--)
	{
		if (bStartState)
		{
			RewardState = XComGameState_Reward(NewGameState.GetGameStateForObjectID(BlackMarket.ForSaleItems[ItemIdx].RewardRef.ObjectID));
		}
		else
		{
			RewardState = XComGameState_Reward(History.GetGameStateForObjectID(BlackMarket.ForSaleItems[ItemIdx].RewardRef.ObjectID));
		}
		if (RewardState.GetMyTemplateName() == 'Reward_Supplies')
		{
			BlackMarket.ForSaleItems.Remove(ItemIdx, 1);
			RewardState.CleanUpReward(NewGameState);
			NewGameState.RemoveStateObject(RewardState.ObjectID);
		}
	}

	return ELR_NoInterrupt;
}

// Pre end-of month processing. The HQ object responsible for triggering end of month gets ticked before our outposts, so
// we haven't yet run the update routine for the last day of the month. Run it now.
static function EventListenerReturn PreEndOfMonth(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
	local XComGameState_LWOutpost Outpost, NewOutpost;
	local XComGameState_WorldRegion WorldRegion;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
	{
		WorldRegion = Outpost.GetWorldRegionForOutpost();

		// Skip uncontacted regions.
		if (WorldRegion.ResistanceLevel < eResLevel_Contact)
		{
			continue;
		}

		// See if we already have an outstanding state for this outpost, and create one if not. (This shouldn't ever
		// be the case as this is the first thing done in the end-of-month processing.)
		NewOutpost = XComGameState_LWOutpost(NewGameState.GetGameStateForObjectID(Outpost.ObjectID));
		if (NewOutpost != none)
		{
			`LWTrace("PreEndOfMonth: Found existing outpost");
			Outpost = NewOutpost;
		}
		else
		{
			Outpost = XComGameState_LWOutpost(NewGameState.ModifyStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
		}

		if (Outpost.Update(NewGameState))
		{
			`LWTrace("Update succeeded");
		}
		else
		{
			`LWTrace("Update failed");
		}
	}

	return ELR_NoInterrupt;
}

// Retreive the amount of supplies to reward for the month by summing up the income pools in each region. This is called twice:
// first to get the value to put in the supply cache, and then again to get the string to display in the UI report. The first
// time will have a non-none GameState that must be used to get the latest outpost states rather than the history, as the history
// won't yet have the state including the last day update from the pre event above.
static function EventListenerReturn OnMonthlySuppliesReward(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_LWOutpost Outpost, NewOutpost;
	local XComLWTuple Tuple;
	local int Supplies;

	History = `XCOMHISTORY;
	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
	{
		// Not an expected tuple, or another mod has already done the override: return
		return ELR_NoInterrupt;
	}

	foreach History.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
	{
		// Look for a more recent version in the outstanding game state, if one exists. We don't need to add this to the
		// pending game state if one doesn't exist cause this is a read-only operation on the outpost. We should generally
		// find an existing state here cause the pre event above should have created one and added it.
		if (GameState != none)
		{
			NewOutpost = XComGameState_LWOutpost(GameState.GetGameStateForObjectID(Outpost.ObjectID));
			if (NewOutpost != none)
			{
				`LWTrace("OnMonthlySuppliesReward: Found existing outpost");
				Outpost = NewOutpost;
			}
		}
		Supplies += Outpost.GetEndOfMonthSupply();
	}

	`LWTrace("OnMonthlySuppliesReward: Returning " $ Supplies);
	Tuple.Data[0].b = true;
	Tuple.Data[1].i = Supplies;

	return ELR_NoInterrupt;
}

// Process Negative Supply income events on EndOfMonth processing
static function EventListenerReturn OnMonthlyNegativeSupplyIncome(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComLWTuple Tuple;
	local int RemainingSupplyLoss, AvengerSupplyLoss;
	local int CacheSupplies;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_ResourceCache CacheState;

	History = `XCOMHISTORY;
	Tuple = XComLWTuple(EventData);
	if (Tuple == none || Tuple.Id != 'NegativeMonthlyIncome')
	{
		// Not an expected tuple
		return ELR_NoInterrupt;
	}

	Tuple.Data[0].b = true; // allow display of negative supplies

	if (GameState == none)
	{
		return ELR_NoInterrupt;
	}

	// retrieve XComHQ object, since we'll be modifying supplies resource
	foreach GameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}
	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		GameState.AddStateObject(XComHQ);
	}

	RemainingSupplyLoss = -Tuple.Data[1].i;
	AvengerSupplyLoss = Min (RemainingSupplyLoss, XComHQ.GetResourceAmount('Supplies'));
	XComHQ.AddResource(GameState, 'Supplies', -AvengerSupplyLoss);
	`LWTrace("OnNegativeMonthlySupplies : Removed " $ AvengerSupplyLoss $ " supplies from XComHQ");

	RemainingSupplyLoss -= AvengerSupplyLoss;
	if (RemainingSupplyLoss <= 0) { return ELR_NoInterrupt; }

	// retrieve supplies cache, in case there are persisting supplies to be removed
	foreach GameState.IterateByClassType(class'XComGameState_ResourceCache', CacheState)
	{
		break;
	}
	if (CacheState == none)
	{
		CacheState = XComGameState_ResourceCache(History.GetSingleGameStateObjectForClass(class'XComGameState_ResourceCache'));
		GameState.AddStateObject(CacheState);
	}
	CacheSupplies = CacheState.ResourcesRemainingInCache + CacheState.ResourcesToGiveNextScan;

	if (CacheSupplies > 0)
	{
		if (RemainingSupplyLoss > CacheSupplies) // unlikely, but just in case
		{
			// remove all resources, and hide it
			CacheState.ResourcesToGiveNextScan = 0;
			CacheState.ResourcesRemainingInCache = 0;
			CacheState.bNeedsScan = false;
			CacheState.NumScansCompleted = 999;
			`LWTrace("OnNegativeMonthlySupplies : Removed existing supply cache");
		}
		else
		{
			CacheState.ShowResourceCache(GameState, -RemainingSupplyLoss); // just reduce the existing one
			`LWTrace("OnNegativeMonthlySupplies : Removed " $ RemainingSupplyLoss $ " supplies from existing supply cache");
		}
	}

	return ELR_NoInterrupt;
}

// Recruit updating.
static function EventListenerReturn OnMonthEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local XComGameState_Unit UnitState;
	local StateObjectReference UnitRef;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("");

	// Add utility items to each recruit
	foreach ResistanceHQ.Recruits(UnitRef)
	{
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitRef.ObjectID));
		NewGameState.AddStateObject(UnitState);
		class'Utilities_LW'.static.GiveDefaultUtilityItemsToSoldier(UnitState, NewGameState);
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	return ELR_NoInterrupt;
}

// Post end of month processing: called after closing the report UI.
static function EventListenerReturn PostEndOfMonth(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_LWOutpost Outpost, NewOutpost;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("");

	`LWTrace("Running post end of month update");

	// Do end-of-month processing on each outpost.
	foreach History.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
	{
		// Check for existing game states (there shouldn't be any, since this is invoked after the HQ updates are
		// submitted to history.)
		NewOutpost = XComGameState_LWOutpost(NewGameState.GetGameStateForObjectID(Outpost.ObjectID));
		if (NewOutpost != none)
		{
			Outpost = NewOutpost;
			`LWTrace("PostEndOfMonth: Found existing outpost");
		}
		else
		{
			Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
			NewGameState.AddStateObject(Outpost);
		}

		Outpost.OnMonthEnd(NewGameState);
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnGetSupplyDropDecreaseStrings(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComGameState_LWOutpost Outpost;
	local XComGameStateHistory History;
	local XComLWTuple Tuple;
	local int NetSupplies;
	local int GrossSupplies;
	local int SupplyDelta;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
	{
		return ELR_NoInterrupt;
	}

	// Figure out how many supplies we have lost.
	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
	{
		GrossSupplies += Outpost.GetIncomePoolForJob('Resupply');
		NetSupplies += Outpost.GetEndOfMonthSupply();
	}

	SupplyDelta = GrossSupplies - NetSupplies;

	if (SupplyDelta > 0)
	{
		Tuple.Data[0].s = class'UIBarMemorial_Details'.default.m_strUnknownCause;
		Tuple.Data[1].s = class'UIUtilities_Strategy'.default.m_strCreditsPrefix $ String(int(Abs(SupplyDelta)));
	}

	return ELR_NoInterrupt;
}
