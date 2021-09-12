class X2Rocket_Sabot extends X2Item config(Rockets);

var name TemplateName;
var config bool CREATE_ROCKET;
var config bool SLOMO_ONLY_ON_DEATH;

var config int AIM_BONUS;
var config int CRIT_BONUS;

var config int SIZE_SCALING_AIM_BONUS;
var config int SIZE_SCALING_CRIT_BONUS;
var config bool SIZE_SCALING_CRIT_BONUS_IS_INVERTED;

var config int PIERCE_DISTANCE_TILES;

var config int BLEED_DAMAGE;
var config int BLEED_DURATION_TURNS;

var config WeaponDamageValue BaseDamage;
var config int iEnvironmentDamage;
var config int iClipSize;
var config int iSoundRange;
var config int Range;
var config int Radius;
var config int MOBILITY_PENALTY;

var config bool REQUIRE_ARMING;
var config int TYPICAL_ACTION_COST;

var config string Image;
var config string GAME_ARCHETYPE;

var config name WEAPON_TECH;
var config int Tier;

var config array<name> COMPATIBLE_LAUNCHERS;

var config bool STARTING_ITEM;
var config bool INFINITE_ITEM;
var config name CREATOR_TEMPLATE_NAME;
var config name HIDE_IF_TECH_RESEARCHED;
var config name HIDE_IF_ITEM_PURCHASED;
var config name BASE_ITEM;
var config bool CAN_BE_BUILT;
var config array<name> REQUIRED_TECHS;
var config array<name> REWARD_DECKS;
var config array<name> RESOURCE_COST_TYPE;
var config array<int> RESOURCE_COST_QUANTITY;
var config int BLACKMARKET_VALUE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	if (default.CREATE_ROCKET)
	{
		Templates.AddItem(Create_Rocket_Main());
		Templates.AddItem(Create_Rocket_Pair());
	}
	return Templates;
}

static function X2DataTemplate Create_Rocket_Main()
{
	local X2RocketTemplate 				Template;
	local ArtifactCost					Resources;
	local int i;
	
	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, default.TemplateName);

	Template.strImage = default.IMAGE;
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";

	//Template.AddAbilityIconOverride('IRI_FireRocket', "img:///IRI_RocketLaunchers.UI.Fire_Sabot");
	Template.AddAbilityIconOverride('IRI_GiveRocket', "img:///IRI_RocketLaunchers.UI.Give_Sabot");
	Template.AddAbilityIconOverride('IRI_ArmRocket', "img:///IRI_RocketLaunchers.UI.Arm_Sabot");
	
	Template.WeaponTech = default.WEAPON_TECH;
	Template.Tier = default.TIER;

	Template.COMPATIBLE_LAUNCHERS = default.COMPATIBLE_LAUNCHERS;

	Template.RequireArming = default.REQUIRE_ARMING;
	Template.iTypicalActionCost = default.TYPICAL_ACTION_COST;

	Template.Aim = default.AIM_BONUS;
	Template.CritChance = default.CRIT_BONUS;
	
	Template.GameArchetype = default.GAME_ARCHETYPE;
	Template.BaseDamage = default.BASEDAMAGE;
	Template.iEnvironmentDamage = default.IENVIRONMENTDAMAGE;
	Template.iRange = default.RANGE;
	Template.iRadius = default.RADIUS;
	Template.iSoundRange = default.ISOUNDRANGE;
	Template.iClipSize = default.ICLIPSIZE;
	if (Template.iClipSize <= 1) Template.bHideClipSizeStat = true;
	Template.MobilityPenalty = default.MOBILITY_PENALTY;

	Template.PierceDistance = default.PIERCE_DISTANCE_TILES;
	Template.CanBeBuilt = default.CAN_BE_BUILT;
	Template.bInfiniteItem = default.INFINITE_ITEM;
	Template.StartingItem = default.STARTING_ITEM;
	
	Template.CreatorTemplateName = default.CREATOR_TEMPLATE_NAME;
	Template.BaseItem = default.BASE_ITEM;
	
	Template.RewardDecks = default.REWARD_DECKS;
	Template.HideIfResearched = default.HIDE_IF_TECH_RESEARCHED;
	Template.HideIfPurchased = default.HIDE_IF_ITEM_PURCHASED;
	
	if (!Template.bInfiniteItem)
	{
		Template.TradingPostValue = default.BLACKMARKET_VALUE;
		
		if (Template.CanBeBuilt)
		{
			Template.Requirements.RequiredTechs = default.REQUIRED_TECHS;
			
			for (i = 0; i < default.RESOURCE_COST_TYPE.Length; i++)
			{
				if (default.RESOURCE_COST_QUANTITY[i] > 0)
				{
					Resources.ItemTemplateName = default.RESOURCE_COST_TYPE[i];
					Resources.Quantity = default.RESOURCE_COST_QUANTITY[i];
					Template.Cost.ResourceCosts.AddItem(Resources);
				}
			}
		}
	}
	
	Template.OnThrowBarkSoundCue = 'RocketLauncher';
	Template.DamageTypeTemplateName = Template.BaseDamage.DamageType;

	//Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireSabot');
	//Template.Abilities.AddItem('IRI_RocketMobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');
	Template.Abilities.AddItem('IRI_AggregateRocketAmmo');
	//Template.Abilities.AddItem('IRI_ArmRocket');
	Template.Abilities.AddItem('IRI_SabotHitBonus');
	//Template.Abilities.AddItem('IRI_DisarmRocket');

	Template.iPhysicsImpulse = 10;

	//Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel,, default.RANGE);
	//Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel,, default.RADIUS);
	//Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,, default.BASEDAMAGE.Shred);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, Template.MobilityPenalty);

	Template.PairedTemplateName = name(default.TemplateName $ "_Pair");

	return Template;
}

static function X2DataTemplate Create_Rocket_Pair()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, name(default.TemplateName $ "_Pair"));

	Template.GameArchetype = default.GAME_ARCHETYPE;
	
	Template.ItemCat = 'cosmetic_rocket';
	Template.WeaponCat = 'rocket';

	return Template;
}

static function FireSabot_BuildVisualization(XComGameState VisualizeGameState)
{	
	local XComGameStateVisualizationMgr		VisMgr;
	local X2Action							Action;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;
	local X2Action_TimedWait				TimedWait;
	local X2Action_SetGlobalTimeDilation	TimeDilation;
	local XComGameState_Unit				TargetUnit;

	class'X2Ability'.static.TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;

	Action = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover');
	AbilityContext = XComGameStateContext_Ability(Action.StateChangeContext);
	ActionMetaData = Action.Metadata;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

	if (TargetUnit.IsDead() || !default.SLOMO_ONLY_ON_DEATH)
	{
		//	In this amount of time after Fire Action starts
		TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, Action));
		TimedWait.DelayTimeSec = 4.9f;

		//	Slow down time
		TimeDilation = X2Action_SetGlobalTimeDilation(class'X2Action_SetGlobalTimeDilation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, TimedWait));
		TimeDilation.TimeDilation = 0.2f;

		//	For this amount of time. The actual duration will be longer due to Time Dilation. Duh.
		TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, TimeDilation));
		TimedWait.DelayTimeSec = 0.4f;

		//	Then restore normal speed.
		TimeDilation = X2Action_SetGlobalTimeDilation(class'X2Action_SetGlobalTimeDilation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, TimedWait));
		TimeDilation.TimeDilation = 1.0f;
	}
}

static function FireSabot_BuildVisualization_Spark(XComGameState VisualizeGameState)
{	
	local XComGameStateVisualizationMgr		VisMgr;
	local X2Action							Action;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;
	local X2Action_TimedWait				TimedWait;
	local X2Action_SetGlobalTimeDilation	TimeDilation;
	local XComGameState_Unit				TargetUnit;

	class'X2Ability'.static.TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;

	Action = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover');
	AbilityContext = XComGameStateContext_Ability(Action.StateChangeContext);
	ActionMetaData = Action.Metadata;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

	if (TargetUnit.IsDead() || !default.SLOMO_ONLY_ON_DEATH)
	{
		//	In this amount of time after Fire Action starts
		TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, Action));
		TimedWait.DelayTimeSec = 1.725f;

		//	Slow down time
		TimeDilation = X2Action_SetGlobalTimeDilation(class'X2Action_SetGlobalTimeDilation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, TimedWait));
		TimeDilation.TimeDilation = 0.2f;

		//	For this amount of time. The actual duration will be longer due to Time Dilation. Duh.
		TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, TimeDilation));
		TimedWait.DelayTimeSec = 0.4f;

		//	Then restore normal speed.
		TimeDilation = X2Action_SetGlobalTimeDilation(class'X2Action_SetGlobalTimeDilation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, TimedWait));
		TimeDilation.TimeDilation = 1.0f;
	}
}


defaultproperties
{
	TemplateName = "IRI_X2Rocket_Sabot"
}