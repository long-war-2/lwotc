class X2Ability_HackRewards_LW extends X2Ability_HackRewards config(LW_SoldierSkills);

//Enum EffectTargetSelection
//{
//	EETS_Self,					// Target only the Hack instigator
//	EETS_Target,				// Target only the Hack target
//	EETS_AllAllies,				// Target the allies of the instigator
//	EETS_AllEnemies,			// Target the enemies of the instigator
//	EETS_AllRoboticEnemies,		// Target all robotic enemies
//	EETS_SingleEnemy,			// Target a single enemy
//	EETS_SingleRoboticEnemy,	// Target a single robotic enemy
//	EETS_AllADVENTEnemies,		// Target all ADVENT enemies
//};

var config int ADVENTSCOPES_APPLICATIONCHANCE;
var config int ADVENTSCOPES_OFFENSE_BONUS;

var config int ADVENTLASERSIGHTS_APPLICATIONCHANCE;
var config int ADVENTLASERSIGHTS_CRIT_BONUS;

var config int FIREWALLS_HACKDEFENSE_BONUS;

var config int CONDITIONING1_APPLICATIONCHANCE;
var config int CONDITIONING1_HITPOINTS_BONUS;
var config int CONDITIONING2_APPLICATIONCHANCE;
var config int CONDITIONING2_HITPOINTS_BONUS;
var config int CONDITIONING3_APPLICATIONCHANCE;
var config int CONDITIONING3_HITPOINTS_BONUS;

var config int VETERAN_UNITS_APPLICATIONCHANCE;
var config int TACTICAL_UPGRADES_APPLICATIONCHANCE;
var config int ADVANCED_SERVOS_APPLICATIONCHANCE;
var config int VETERAN_UNITS_OFFENSE_BONUS;
var config int TACTICAL_UPGRADES_DEFENSE_BONUS;
var config int ADVANCED_SERVOS_MOBILITY_BONUS;

var config int GREATER_FACELESS_HP_BONUS;
var config int GREATER_FACELESS_MOBILITY_BONUS;
var config int GREATER_FACELESS_OFFENSE_BONUS;
var config int GREATER_FACELESS_DEFENSE_BONUS;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2Ability_HackRewards_LW.CreateTemplates()");
	
	Templates.AddItem(BuildNetworkTowerStunAbility('NetworkTowerStun_LW', EETS_AllEnemies));
	Templates.AddItem(BuildStatModifyingAbility('ADVENTScopes',			"img:///UILibrary_PerkIcons.UIPerk_platform_stability",	EETS_AllADVENTEnemies,	default.ADVENTSCOPES_APPLICATIONCHANCE,			ePerkBuff_Bonus, eStat_Offense,		default.ADVENTSCOPES_OFFENSE_BONUS));
	Templates.AddItem(BuildStatModifyingAbility('ADVENTLaserSights',	"img:///UILibrary_PerkIcons.UIPerk_scope",				EETS_AllADVENTEnemies,	default.ADVENTLASERSIGHTS_APPLICATIONCHANCE,	ePerkBuff_Bonus, eStat_CritChance,	default.ADVENTLASERSIGHTS_CRIT_BONUS));
	Templates.AddItem(BuildStatModifyingAbility('ADVENTFirewalls',		"img:///UILibrary_PerkIcons.UIPerk_hack_reward_debuff", EETS_AllRoboticEnemies, 100,											ePerkBuff_Passive, eStat_HackDefense,	default.FIREWALLS_HACKDEFENSE_BONUS));
	Templates.AddItem(BuildStatModifyingAbility('AlienConditioning1',	"img:///UILibrary_PerkIcons.UIPerk_defend_health",		EETS_AllEnemies,		default.CONDITIONING1_APPLICATIONCHANCE,		ePerkBuff_Passive, eStat_HP,			default.CONDITIONING1_HITPOINTS_BONUS));
	Templates.AddItem(BuildStatModifyingAbility('AlienConditioning2',	"img:///UILibrary_PerkIcons.UIPerk_defend_health",		EETS_AllEnemies,		default.CONDITIONING2_APPLICATIONCHANCE,		ePerkBuff_Passive, eStat_HP,			default.CONDITIONING2_HITPOINTS_BONUS));
	Templates.AddItem(BuildStatModifyingAbility('AlienConditioning3',	"img:///UILibrary_PerkIcons.UIPerk_defend_health",		EETS_AllEnemies,		default.CONDITIONING3_APPLICATIONCHANCE,		ePerkBuff_Passive, eStat_HP,			default.CONDITIONING3_HITPOINTS_BONUS));
	Templates.AddItem(BuildStatModifyingAbility('VeteranUnits',			"img:///UILibrary_PerkIcons.UIPerk_nation_aim",			EETS_AllEnemies,		default.VETERAN_UNITS_APPLICATIONCHANCE,		ePerkBuff_Bonus, eStat_Offense,		default.VETERAN_UNITS_OFFENSE_BONUS));
	Templates.AddItem(BuildStatModifyingAbility('TacticalUpgrades',		"img:///UILibrary_PerkIcons.UIPerk_eaglesnest",			EETS_AllEnemies,		default.TACTICAL_UPGRADES_APPLICATIONCHANCE,	ePerkBuff_Bonus, eStat_Defense,		default.TACTICAL_UPGRADES_DEFENSE_BONUS));
	Templates.AddItem(BuildStatModifyingAbility('AdvancedServos',		"img:///UILibrary_PerkIcons.UIPerk_fleetfoot",			EETS_AllADVENTEnemies,	default.ADVANCED_SERVOS_APPLICATIONCHANCE,		ePerkBuff_Bonus, eStat_Mobility,	default.ADVANCED_SERVOS_MOBILITY_BONUS));
	Templates.AddItem(GreaterFacelessAbility());
	
	return Templates;
}

static function X2AbilityTemplate GreaterFacelessAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange StatEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'GreaterFacelessStatImprovements');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bCrossClassEligible = false;

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.BuildPersistentEffect (1, true);
	StatEffect.AddPersistentStatChange(eStat_HP, float(default.GREATER_FACELESS_HP_BONUS));
	StatEffect.AddPersistentStatChange(eStat_Mobility, float(default.GREATER_FACELESS_MOBILITY_BONUS));
	StatEffect.AddPersistentStatChange(eStat_Offense, float(default.GREATER_FACELESS_OFFENSE_BONUS));
	StatEffect.AddPersistentStatChange(eStat_Defense, float(default.GREATER_FACELESS_DEFENSE_BONUS));

	Template.AddTargetEffect (StatEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate BuildNetworkTowerStunAbility(Name TemplateName, EffectTargetSelection TargetType)
{
	local X2AbilityTemplate                 Template;
	local array<X2Effect>					SelectedEffects;
	local X2Condition_Soldier				SoldierCondition;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	SelectedEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(4, 100, false));
	ApplyEffectsToTemplate(Template, TargetType, 0, SelectedEffects);

	// The targets must not be soldiers -- this prevents mind-controlled units from getting stunned
	SoldierCondition = new class'X2Condition_Soldier';
	SoldierCondition.Exclude = true;
	Template.AbilityMultiTargetConditions.AddItem(SoldierCondition);

	// This should only trigger once per mission, so give it a charge to
	// ensure that happens. Otherwise any other hack on the mission will
	// trigger it.
	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.BuildVisualizationFn = NetworkTowerStunAbility_BuildVisualization;
	return Template;
}

simulated function NetworkTowerStunAbility_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  AbilityContext;
	local VisualizationActionMetadata	ActionMetadata;
	local X2Action_PlayNarrative        NetworkStunBink;

	History = `XCOMHISTORY;

	// In replay, just play the end mission bink and nothing else
	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID,, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(AbilityContext.InputContext.SourceObject.ObjectID);

	NetworkStunBink = X2Action_PlayNarrative(class'X2Action_PlayNarrative'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, ActionMetadata.LastActionAdded));
	NetworkStunBink.Moment = XComNarrativeMoment(DynamicLoadObject("LWNarrativeMoments_Bink.TACTICAL.CIN_HackNetworkTower_Cut", class'XComNarrativeMoment'));


	// bink is added to visualization track first, then the in-game effects
	TypicalAbility_BuildVisualization(VisualizeGameState);
}