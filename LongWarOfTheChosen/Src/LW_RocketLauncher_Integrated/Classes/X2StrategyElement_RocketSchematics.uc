class X2StrategyElement_RocketSchematics extends X2StrategyElement config (Schematics);

var config array<name> EXPERIMENTAL_ROCKET_RESOURCE_COST_TYPE;
var config array<int> EXPERIMENTAL_ROCKET_RESOURCE_COST_QUANTITY;
var config int EXPERIMENTAL_ROCKET_BUILD_TIME_DAYS;
var config array<name> EXPERIMENTAL_ROCKET_REQUIRED_TECH;
var config array<name> EXPERIMENTAL_ROCKET_REQUIRED_ITEM;
var config int EXPERIMENTAL_ROCKET_ENGINEERING_SCORE;
var config int EXPERIMENTAL_ROCKET_SCIENTIST_SCORE;

var config array<name> POWERED_ROCKET_RESOURCE_COST_TYPE;
var config array<int> POWERED_ROCKET_RESOURCE_COST_QUANTITY;
var config int POWERED_ROCKET_BUILD_TIME_DAYS;
var config array<name> POWERED_ROCKET_REQUIRED_TECH;
var config array<name> POWERED_ROCKET_REQUIRED_ITEM;
var config int POWERED_ROCKET_ENGINEERING_SCORE;
var config int POWERED_ROCKET_SCIENTIST_SCORE;

var config array<name> IMPROVED_ROCKETS_RESOURCE_COST_TYPE;
var config array<int> IMPROVED_ROCKETS_RESOURCE_COST_QUANTITY;
var config int IMPROVED_ROCKETS_BUILD_TIME_DAYS;
var config array<name> IMPROVED_ROCKETS_REQUIRED_TECH;
var config array<name> IMPROVED_ROCKET_REQUIRED_ITEM;
var config int IMPROVED_ROCKETS_ENGINEERING_SCORE;
var config int IMPROVED_ROCKETS_SCIENTIST_SCORE;

var config array<name> TACTICAL_NUKE_RESOURCE_COST_TYPE;
var config array<int> TACTICAL_NUKE_RESOURCE_COST_QUANTITY;
var config int TACTICAL_NUKE_BUILD_TIME_DAYS;
var config array<name> TACTICAL_NUKE_REQUIRED_TECH;
var config array<name> TACTICAL_NUKE_REQUIRED_ITEM;
var config int TACTICAL_NUKE_ENGINEERING_SCORE;
var config int TACTICAL_NUKE_SCIENTIST_SCORE;
var config bool TACTICAL_NUKE_REPEATABLE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	// Proving Grounds Projects
	Techs.AddItem(Create_Experimental_Rocket_Tech());
	Techs.AddItem(Create_Powered_Rocket_Tech());
	Techs.AddItem(Create_Improved_Rockets_Tech());
	Techs.AddItem(Create_Tactical_Nuke_Tech());

	return Techs;
}

static function X2DataTemplate Create_Experimental_Rocket_Tech()
{
	local X2TechTemplate Template;
	local ArtifactCost					Resources;
	local int i;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'IRI_ExperimentalRocket');

	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.EXPERIMENTAL_ROCKET_BUILD_TIME_DAYS);
	Template.strImage = "img:///IRI_RocketLaunchers.UI.PG_Experimental_Rocket";
	Template.SortingTier = 2;
	
	// Created Item
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveDeckedItemReward;
	Template.RewardDeck = 'IRI_ExperimentalRocketRewards';
	Template.bRandomGrenade = true; // for the purposes of instant completion due to Resistance Order / Continent Bonus

	//	Requirements
	if(default.EXPERIMENTAL_ROCKET_REQUIRED_TECH.Length > 0) Template.Requirements.RequiredTechs = default.EXPERIMENTAL_ROCKET_REQUIRED_TECH;
	if(default.EXPERIMENTAL_ROCKET_REQUIRED_ITEM.Length > 0) Template.Requirements.RequiredItems = default.EXPERIMENTAL_ROCKET_REQUIRED_ITEM;
	
	if (default.EXPERIMENTAL_ROCKET_ENGINEERING_SCORE > 0) Template.Requirements.RequiredEngineeringScore = default.EXPERIMENTAL_ROCKET_ENGINEERING_SCORE;

	if (default.EXPERIMENTAL_ROCKET_SCIENTIST_SCORE > 0) Template.Requirements.RequiredScienceScore = default.EXPERIMENTAL_ROCKET_SCIENTIST_SCORE;

	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	for (i = 0; i < default.EXPERIMENTAL_ROCKET_RESOURCE_COST_TYPE.Length; i++)
	{
		if (default.EXPERIMENTAL_ROCKET_RESOURCE_COST_QUANTITY[i] > 0)
		{
			Resources.ItemTemplateName = default.EXPERIMENTAL_ROCKET_RESOURCE_COST_TYPE[i];
			Resources.Quantity = default.EXPERIMENTAL_ROCKET_RESOURCE_COST_QUANTITY[i];
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
	}

	Template.bProvingGround = true;
	Template.bRepeatable = true;

	return Template;
}

static function X2DataTemplate Create_Powered_Rocket_Tech()
{
	local X2TechTemplate Template;
	local ArtifactCost					Resources;
	local int i;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'IRI_PoweredRocket');

	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.POWERED_ROCKET_BUILD_TIME_DAYS);
	Template.strImage = "img:///IRI_RocketLaunchers.UI.PG_POWERED_Rocket";
	Template.SortingTier = 2;
	
	// Created Item
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveDeckedItemReward;
	Template.RewardDeck = 'IRI_PoweredRocketRewards';
	Template.bRandomGrenade = true; // for the purposes of instant completion due to Resistance Order / Continent Bonus

	//	Requirements
	if(default.POWERED_ROCKET_REQUIRED_TECH.Length > 0) Template.Requirements.RequiredTechs = default.POWERED_ROCKET_REQUIRED_TECH;
	if(default.POWERED_ROCKET_REQUIRED_ITEM.Length > 0) Template.Requirements.RequiredItems = default.POWERED_ROCKET_REQUIRED_ITEM;

	if (default.POWERED_ROCKET_ENGINEERING_SCORE > 0) Template.Requirements.RequiredEngineeringScore = default.POWERED_ROCKET_ENGINEERING_SCORE;

	if (default.POWERED_ROCKET_SCIENTIST_SCORE > 0) Template.Requirements.RequiredScienceScore = default.POWERED_ROCKET_SCIENTIST_SCORE;

	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	for (i = 0; i < default.POWERED_ROCKET_RESOURCE_COST_TYPE.Length; i++)
	{
		if (default.POWERED_ROCKET_RESOURCE_COST_QUANTITY[i] > 0)
		{
			Resources.ItemTemplateName = default.POWERED_ROCKET_RESOURCE_COST_TYPE[i];
			Resources.Quantity = default.POWERED_ROCKET_RESOURCE_COST_QUANTITY[i];
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
	}

	Template.bProvingGround = true;
	Template.bRepeatable = true;

	return Template;
}

static function X2DataTemplate Create_Improved_Rockets_Tech()
{
	local X2TechTemplate Template;
	local ArtifactCost					Resources;
	local int i;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'IRI_ImprovedRockets');

	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.IMPROVED_ROCKETS_BUILD_TIME_DAYS);
	Template.strImage = "img:///IRI_RocketNuke.UI.PG_ImprovedRockets";
	Template.SortingTier = 3;
	
	// Created Item
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.UpgradeItems;

	//	Requirements
	if(default.IMPROVED_ROCKETS_REQUIRED_TECH.Length > 0) Template.Requirements.RequiredTechs = default.IMPROVED_ROCKETS_REQUIRED_TECH;
	if(default.IMPROVED_ROCKET_REQUIRED_ITEM.Length > 0) Template.Requirements.RequiredItems = default.IMPROVED_ROCKET_REQUIRED_ITEM;

	if (default.IMPROVED_ROCKETS_ENGINEERING_SCORE > 0) Template.Requirements.RequiredEngineeringScore = default.IMPROVED_ROCKETS_ENGINEERING_SCORE;

	if (default.IMPROVED_ROCKETS_SCIENTIST_SCORE > 0) Template.Requirements.RequiredScienceScore = default.IMPROVED_ROCKETS_SCIENTIST_SCORE;

	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	for (i = 0; i < default.IMPROVED_ROCKETS_RESOURCE_COST_TYPE.Length; i++)
	{
		if (default.IMPROVED_ROCKETS_RESOURCE_COST_QUANTITY[i] > 0)
		{
			Resources.ItemTemplateName = default.IMPROVED_ROCKETS_RESOURCE_COST_TYPE[i];
			Resources.Quantity = default.IMPROVED_ROCKETS_RESOURCE_COST_QUANTITY[i];
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
	}

	Template.bProvingGround = true;
	Template.bRepeatable = false;

	return Template;
}

static function X2DataTemplate Create_Tactical_Nuke_Tech()
{
	local X2TechTemplate Template;
	local ArtifactCost	 Resources;
	local int i;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'IRI_TacticalNuke_Tech');

	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, default.TACTICAL_NUKE_BUILD_TIME_DAYS);
	Template.strImage = "img:///IRI_RocketNuke.UI.PG_Nuke";
	Template.SortingTier = 3;
	
	// Created Item
	Template.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveDeckedItemReward;
	Template.RewardDeck = 'IRI_TacticalNuke_Deck';
	//Template.bRandomGrenade = true; // for the purposes of instant completion due to Resistance Order / Continent Bonus

	//	Requirements
	if(default.TACTICAL_NUKE_REQUIRED_TECH.Length > 0) Template.Requirements.RequiredTechs = default.TACTICAL_NUKE_REQUIRED_TECH;
	if(default.TACTICAL_NUKE_REQUIRED_ITEM.Length > 0) Template.Requirements.RequiredItems = default.TACTICAL_NUKE_REQUIRED_ITEM;

	if (default.TACTICAL_NUKE_ENGINEERING_SCORE > 0) Template.Requirements.RequiredEngineeringScore = default.TACTICAL_NUKE_ENGINEERING_SCORE;

	if (default.TACTICAL_NUKE_SCIENTIST_SCORE > 0) Template.Requirements.RequiredScienceScore = default.TACTICAL_NUKE_SCIENTIST_SCORE;

	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	for (i = 0; i < default.TACTICAL_NUKE_RESOURCE_COST_TYPE.Length; i++)
	{
		if (default.TACTICAL_NUKE_RESOURCE_COST_QUANTITY[i] > 0)
		{
			Resources.ItemTemplateName = default.TACTICAL_NUKE_RESOURCE_COST_TYPE[i];
			Resources.Quantity = default.TACTICAL_NUKE_RESOURCE_COST_QUANTITY[i];
			Template.Cost.ResourceCosts.AddItem(Resources);
		}
	}

	Template.bProvingGround = true;
	Template.bRepeatable = default.TACTICAL_NUKE_REPEATABLE;

	return Template;
}

static function CleanupNukeRocketResoruces(XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom	XComHQ;
	local XComGameState_Item				ItemState;
	local name								ResourceName;

	XComHQ = `XCOMHQ;
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.GetGameStateForObjectID(XComHQ.ObjectID));
	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	}
	if (XComHQ == none)
	{
		`redscreen("Rocket Launchers::GiveNukeItemReward: ERROR, could not find XCOM HQ object!");
		return;
	}

	//	This loop will clean up any leftover Item States for 
	foreach default.TACTICAL_NUKE_RESOURCE_COST_TYPE(ResourceName)
	{
		ItemState = XComHQ.GetItemByName(ResourceName);
		//`LOG("Found:" @ ResourceName @ ", quantity:" @ ItemState.Quantity,, 'IRINUKE');
		if (ItemState != none && ItemState.Quantity <= 0)
		{
			//ItemState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', ItemState.ObjectID));
			if (XComHQ.GetItemFromInventory(NewGameState, ItemState.GetReference(), ItemState))
			{
				//`LOG("Removing item",, 'IRINUKE');
				NewGameState.RemoveStateObject(ItemState.ObjectID);
			}
		}
	}
}