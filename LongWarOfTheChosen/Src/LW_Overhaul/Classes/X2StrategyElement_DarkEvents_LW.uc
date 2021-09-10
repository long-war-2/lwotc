class X2StrategyElement_DarkEvents_LW extends X2StrategyElement_DefaultDarkEvents config (GameData);

var config float RURAL_PROPAGANDA_BLITZ_RECRUITING_MULTIPLIER;
var config float COUNTERINTELLIGENCE_SWEEP_INTEL_MULTIPLIER;
var config float RURAL_CHECKPOINTS_SUPPLY_MULTIPLIER;

var config int T1_UPGRADES_WEIGHT;
var config int T2_UPGRADES_WEIGHT;
var config int T3_UPGRADES_WEIGHT;
var config int T4_UPGRADES_WEIGHT;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> DarkEvents;

	`LWTrace("  >> X2StrategyElement_DarkEvents_LW.CreateTemplates()");
	
	DarkEvents.AddItem(CreateCounterintelligenceSweepTemplate());
	DarkEvents.AddItem(CreateRuralPropagandaBlitzTemplate());
	DarkEvents.AddItem(CreateHavenInfiltrationTemplate());
	DarkEvents.AddItem(CreateAirPatrolsTemplate());
	DarkEvents.AddItem(CreateRuralCheckpointsLWTemplate());
	DarkEvents.AddItem(CreatePreRevealMinorBreakthrough());
	DarkEvents.AddItem(CreatePreRevealMajorBreakthrough());


	//DarkEvents.AddItem(CreateFirewallsTemplate());
		//DarkEvents.AddItem(CreateAdventScopesTemplate());
	//DarkEvents.AddItem(CreateAdventLaserSightsTemplate());
	//DarkEvents.AddItem(CreateAlienConditioning1Template());
	//DarkEvents.AddItem(CreateAlienConditioning2Template());
	//DarkEvents.AddItem(CreateAlienConditioning3Template());
	//DarkEvents.AddItem(CreateVeteranUnitsTemplate());
	//DarkEvents.AddItem(CreateAdvancedServosTemplate());
	//DarkEvents.AddItem(CreateTacticalUpgradesDefenseTemplate());
	//DarkEvents.AddItem(CreateTacticalUpgradesWilltoSurviveTemplate());
	//DarkEvents.AddItem(CreateTacticalUpgradesCenterMassTemplate());


	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Impulse_LW','Trooper',TrooperM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Formidable','Trooper',TrooperM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('LockedOn','Trooper',TrooperM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('OpenFire_LW','Trooper',TrooperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Evasive','Trooper',TrooperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ChosenVenomRounds','Trooper',TrooperM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('CombatAwareness','Sentry',TrooperM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('GrazingFire','Sentry',TrooperM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('CoolUnderPressure','Sentry',TrooperM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Concentration_LW','Sentry',TrooperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('RapidReaction','Sentry',TrooperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('HuntersInstinct','Sentry',TrooperM3,default.T3_UPGRADES_WEIGHT));


	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('GrazingFire','Gunner',TrooperM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('OpenFire_LW','Gunner',TrooperM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('CombatAwareness','Gunner',TrooperM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Mayhem','Gunner',TrooperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Holotargeting','Gunner',TrooperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Shredder','Gunner',TrooperM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('InstantReactionTime','Sectoid',TrooperM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Predator_LW','Sectoid',TrooperM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ShootingSharp_LW','Sectoid',TrooperM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Aggression','Sectoid',TrooperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Dominant_LW','Sectoid',TrooperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('MindShield','Sectoid',TrooperM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ApexPredator_LW','Sectoid',TrooperM4,default.T4_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Solace','Sectoid',TrooperM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ShootingSharp_LW','Captain',TrooperM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('AimAssist_LW','Captain',TrooperM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Executioner_LW','Captain',TrooperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('CloseCombatSpecialist','Captain',TrooperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('OverBearingSuperiority_LW','Captain',TrooperM3,default.T3_UPGRADES_WEIGHT));


	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Predator_LW','Drone',TrooperM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Brawler','Drone',TrooperM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('HuntersInstinct','Drone',TrooperM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ApexPredator_LW','Drone',TrooperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('CloseCombatSpecialist','Drone',TrooperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ParalyzingBlows','Drone',TrooperM3,default.T3_UPGRADES_WEIGHT));


	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Infighter','StunLancer',LancerM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ZoneOfControl_LW','StunLancer',LancerM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('FreeGrenades','StunLancer',LancerM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Bladestorm','StunLancer',LancerM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ParalyzingBlows','StunLancer',LancerM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('CoupDeGrace2','StunLancer',LancerM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Infighter','Viper',ViperM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('OpenFire_LW','Viper',ViperM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('SurvivalInstinct_LW','Viper',ViperM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('SteadyHands','Viper',ViperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('SteadyHands','Viper',ViperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Serpentine','Viper',ViperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Entwine_LW','Viper',ViperM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('HazmatVestBonus_LW','Viper',ViperM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Impulse_LW','Priest',ViperM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Infighter','Priest',ViperM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('SuperiorHolyWarrior','Priest',ViperM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Grit_LW','Priest',ViperM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('MindShield','Priest',ViperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Dominant_LW','Priest',ViperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ChosenDragonRounds','Priest',ViperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Solace','Priest',ViperM3,default.T3_UPGRADES_WEIGHT));


	//DarkEvents.AddItem(CreateTacticalUpgradesTemplate('OverBearingSuperiority_LW','Priest',ViperM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('InstantReactionTime','Sidewinder',PurifierM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Formidable','Sidewinder',PurifierM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Predator_LW','Sidewinder',PurifierM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('QuickRetreat','Sidewinder',PurifierM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Serpentine','Sidewinder',PurifierM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Magnum_LW','Purifier',PurifierM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('LowProfile','Purifier',PurifierM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('OverKill_LW','Purifier',PurifierM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Sprinter','Purifier',PurifierM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ReturnFire','Purifier',PurifierM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('InstantReactionTime','Purifier',PurifierM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Sprinter','Muton',MutonM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Shredder','Muton',MutonM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Bladestorm','Muton',MutonM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Predator_LW','Muton',MutonM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ZoneOfControl_LW','Muton',MutonM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('TotalCombat','Muton',MutonM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Grit_LW','Muton',MutonM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Resilience','Mec',MutonM1,default.T1_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Shredder','Mec',MutonM1,default.T1_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('VolatileMix','Mec',MutonM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Sprinter','Mec',MutonM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ReturnFire','Mec',MutonM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('AbsorptionFields_LW','Mec',MutonM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Resilience','Cyberus',Cyberus,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Predator','Cyberus',Cyberus,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('LowProfile','Cyberus',Cyberus,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ApexPredator_LW','Cyberus',Cyberus,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Infighter','Spectre',LancerM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Predator_LW','Spectre',LancerM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('LowProfile','Spectre',LancerM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Sprinter','Spectre',LancerM4,default.T4_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('HuntersInstinct','Spectre',LancerM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Brawler','Shieldbearer',ViperM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Formidable','Shieldbearer',ViperM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ChosenDragonRounds','Shieldbearer',ViperM4,default.T4_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ReadyForAnything','Shieldbearer',ViperM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Resilience','Berserker',PurifierM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ParalyzingBlows','Berserker',PurifierM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ZoneOfControl_LW','Berserker',PurifierM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Sprinter','Berserker',PurifierM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Bladestorm','Berserker',PurifierM4,default.T4_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('DamageControl','Berserker',PurifierM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Infighter','Chryssalid',MutonM2,default.T2_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('MovingTarget_LW','Chryssalid',MutonM2,default.T2_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('InstantReactionTime','Chryssalid',MutonM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Sprinter','Chryssalid',MutonM3,default.T3_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Grit_LW','Chryssalid',MutonM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ParalyzingBlows','Chryssalid',MutonM3,default.T3_UPGRADES_WEIGHT));

	//DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ReadyForAnything','Shieldbearer',ViperM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Sprinter','Andromdedon',LancerM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('VolatileMix','Andromdedon',LancerM3,default.T3_UPGRADES_WEIGHT));


	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('CloseCombatSpecialist','Andromdedon',LancerM4,default.T4_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('SuperDuperRobot','AndromdedonRobot',LancerM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('CoolUnderPressure','Archon',ViperM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('HardTarget','Archon',ViperM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Shredder','Sectopod',PurifierM3,default.T3_UPGRADES_WEIGHT));
	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('ReturnFire','Sectopod',PurifierM4,default.T4_UPGRADES_WEIGHT));

	DarkEvents.AddItem(CreateTacticalUpgradesTemplate('Defilade','Gatekeeper',MutonM3,default.T3_UPGRADES_WEIGHT));
/*
	DarkEvents.AddItem(CreateTacticalUpgradesFormidableTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesLethalTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesShredderTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesHuntersInstinctTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesLightningReflexesTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesGrazingFireTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesCutthroatTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesCombatAwarenessTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesIronSkinTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesTacticalSenseTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesAggressionTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesResilienceTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesShadowstepTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesDamageControlTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesHardTargetTemplate());
	DarkEvents.AddItem(CreateGreaterFacelessDarkEventTemplate());
	*/
	//DarkEvents.AddItem(CreateTacticalUpgradesMutonEngineersTemplate()); Disabled for now


    return DarkEvents;
}


static function X2DataTemplate CreateTacticalUpgradesTemplate(name BaseAbilityName,
name EnemyTag,
Delegate <X2DarkEventTemplate.CanActivateDelegate> Activation,
int StartingWeight = 5,
 String IconImage ="img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowOfForce",
int MinActivationDays = 12,
int MaxActivationDays = 18)
{
local X2DarkEventTemplate Template;

`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, name('DarkEvent_' $ EnemyTag $  BaseAbilityName));
Template.ImagePath = IconImage; 
GenericSettings(Template);
Template.StartingWeight = StartingWeight;
Template.MinActivationDays = MinActivationDays;
Template.MaxActivationDays = MaxActivationDays;
Template.CanActivateFn = Activation;

return Template;
}

static function X2DataTemplate CreateAirPatrolsTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_AirPatrols');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_UFO";
	Template.Category = "DarkEvent";
	Template.bRepeatable = true;
    Template.bTactical = false;
    Template.bLastsUntilNextSupplyDrop = false;
    Template.MaxSuccesses = 0;
    Template.MinActivationDays = 8;
    Template.MaxActivationDays = 15;
    Template.MinDurationDays = 14;
    Template.MaxDurationDays = 16;
    Template.bInfiniteDuration = false;
    Template.StartingWeight = 5;
    Template.MinWeight = 1;
    Template.MaxWeight = 5;
    Template.WeightDeltaPerPlay = -1;
    Template.WeightDeltaPerActivate = 0;
	return Template;
}

static function X2DataTemplate CreateRuralCheckpointsLWTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_RuralCheckpoints_LW');
    Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_SuppliesSeized";
	Template.Category = "DarkEvent";
	Template.bRepeatable = true;
    Template.bTactical = false;
    Template.bLastsUntilNextSupplyDrop = false;
    Template.MaxSuccesses = 0;
    Template.MinActivationDays = 10;
    Template.MaxActivationDays = 15;
    Template.MinDurationDays = 14;
    Template.MaxDurationDays = 16;
    Template.bInfiniteDuration = false;
    Template.StartingWeight = 5;
    Template.MinWeight = 1;
    Template.MaxWeight = 5;
    Template.WeightDeltaPerPlay = -1;
    Template.WeightDeltaPerActivate = 0;
	return Template;
}


static function X2DataTemplate CreateCounterintelligenceSweepTemplate() 
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_CounterintelligenceSweep');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Crackdown"; 
	Template.Category = "DarkEvent";
	Template.bRepeatable = true;
    Template.bTactical = false;
    Template.bLastsUntilNextSupplyDrop = false;
    Template.MaxSuccesses = 0;
    Template.MinActivationDays = 12;
    Template.MaxActivationDays = 16;
    Template.MinDurationDays = 14;
    Template.MaxDurationDays = 16;
    Template.bInfiniteDuration = false;
    Template.StartingWeight = 5;
    Template.MinWeight = 1;
    Template.MaxWeight = 5;
    Template.WeightDeltaPerPlay = -1;
    Template.WeightDeltaPerActivate = 0;
	return Template;
}

static function X2DataTemplate CreateRuralPropagandaBlitzTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_RuralPropagandaBlitz');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_SuppliesSeized"; 
	Template.Category = "DarkEvent";
	Template.bRepeatable = true;
    Template.bTactical = false;
    Template.bLastsUntilNextSupplyDrop = false;
    Template.MaxSuccesses = 0;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 20;
    Template.MinDurationDays = 14;
    Template.MaxDurationDays = 16;
    Template.bInfiniteDuration = false;
    Template.StartingWeight = 5;
    Template.MinWeight = 1;
    Template.MaxWeight = 5;
    Template.WeightDeltaPerPlay = -1;
    Template.WeightDeltaPerActivate = 0;

	return Template;
}

static function X2DataTemplate CreateHavenInfiltrationTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_HavenInfiltration');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Faceless"; 
	Template.Category = "DarkEvent";
	Template.bRepeatable = true;
    Template.bTactical = false;
    Template.bLastsUntilNextSupplyDrop = false;
    Template.MaxSuccesses = 0;
    Template.MinActivationDays = 10;
    Template.MaxActivationDays = 15;
    Template.MinDurationDays = 45;
    Template.MaxDurationDays = 60;
    Template.bInfiniteDuration = false;
    Template.StartingWeight = 5;
    Template.MinWeight = 1;
    Template.MaxWeight = 5;
    Template.WeightDeltaPerPlay = -1;
    Template.WeightDeltaPerActivate = 0;
	Template.CanActivateFn = CanActivateFacelessUpgrade;
	return Template;
}


static function X2DataTemplate CreateGreaterFacelessDarkEventTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_GreaterFaceless');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Faceless"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 10;
    Template.MaxActivationDays = 14;
	Template.CanActivateFn = CanActivateFacelessUpgrade;
	return Template;
}

function bool CanActivateHunterClass_LW (XComGameState_DarkEvent DarkEventState)
{
	//local XComGameStateHistory History;
	//local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	//History = `XCOMHISTORY;
	//AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	return  (ResistanceHQ.NumMonths >= (7 - `STRATEGYDIFFICULTYSETTING));
}

function bool CanActivateJune1 (XComGameState_DarkEvent DarkEventState)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;

    ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	if (ResistanceHQ.NumMonths >= 3)
		return true;
	return false;
}

function bool CanActivateSept1 (XComGameState_DarkEvent DarkEventState)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;

    ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	if (ResistanceHQ.NumMonths >= 6)
		return true;
	return false;
}

function bool CanActivateDec1 (XComGameState_DarkEvent DarkEventState)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;

    ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	if (ResistanceHQ.NumMonths >= 9)
		return true;
	return false;
}

function bool SeenAnyofThem(array<name> Charlist)
{
	local bool Result;
	local int k;
	
	Result = false;
	for (k = 0; k < CharList.Length; ++k)
	{
		if (`XCOMHQ.HasSeenCharacterTemplate(class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate(CharList[k])))
		{
			Result = true;
		}
	}
	return Result;
}


function bool TrooperM1(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvTrooperM1');
	CharList.AddItem('AdvCaptainM1');
	CharList.AddItem('AdvSentryM1');
	CharList.AddItem('AdvGunnerM1');
	CharList.AddItem('LWDroneM1');
	return SeenAnyofThem(Charlist);
}

function bool TrooperM2(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvTrooperM2');
	CharList.AddItem('AdvCaptainM2');
	CharList.AddItem('AdvSentryM2');
	CharList.AddItem('AdvGunnerM2');
	CharList.AddItem('LWDroneM2');
	return SeenAnyofThem(Charlist);
}

function bool TrooperM3(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvTrooperM3');
	CharList.AddItem('AdvCaptainM3');
	CharList.AddItem('AdvSentryM3');
	CharList.AddItem('AdvGunnerM3');
	CharList.AddItem('LWDroneM3');
	return SeenAnyofThem(Charlist);
}

function bool TrooperM4(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvTrooperM3');
	CharList.AddItem('AdvCaptainM3');
	CharList.AddItem('AdvSentryM3');
	CharList.AddItem('AdvGunnerM3');
	CharList.AddItem('LWDroneM3');
	return SeenAnyofThem(Charlist);
}
function bool LancerM1(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvStunLancerM1');
	return SeenAnyofThem(Charlist);
}

function bool LancerM2(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvStunLancerM2');
	CharList.AddItem('SpecreM2');
	return SeenAnyofThem(Charlist);
}

function bool LancerM3(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvStunLancerM2');
	CharList.AddItem('SpecreM3');

	return SeenAnyofThem(Charlist);
}

function bool LancerM4(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvStunLancerM2');
	CharList.AddItem('SpecreM4');

	return SeenAnyofThem(Charlist);
}

function bool ViperM1(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('Viper');
	CharList.AddItem('AdvPriestM1');

	return SeenAnyofThem(Charlist);
}

function bool ViperM2(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('ViperM2_LW');
	CharList.AddItem('AdvPriestM2');

	return SeenAnyofThem(Charlist);
}


function bool ViperM3(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('ViperM3_LW');
	CharList.AddItem('AdvPriestM3');

	return SeenAnyofThem(Charlist);
}

function bool ViperM4(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('ViperM4_LW');
	CharList.AddItem('AdvPriestM4');

	return SeenAnyofThem(Charlist);
}

function bool ViperM5(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('ViperM4_LW');
	CharList.AddItem('AdvPriestM4');

	return SeenAnyofThem(Charlist);
}

function bool PurifierM1(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvPurifierM1');
	CharList.AddItem('SideWinderM1');

	return SeenAnyofThem(Charlist);
}

function bool PurifierM2(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvPurifierM2');
	CharList.AddItem('SideWinderM2');

	return SeenAnyofThem(Charlist);
}


function bool PurifierM3(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvPurifierM3');
	CharList.AddItem('SideWinderM3');

	return SeenAnyofThem(Charlist);
}

function bool PurifierM4(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvPurifierM4');
	CharList.AddItem('SideWinderM4');

	return SeenAnyofThem(Charlist);
}

function bool PurifierM5(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvPurifierM5');
	CharList.AddItem('SideWinderM5');

	return SeenAnyofThem(Charlist);
}


function bool MutonM1(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('Muton');
	CharList.AddItem('AdvMec_M1');

	return SeenAnyofThem(Charlist);
}

function bool MutonM2(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('MutonM2_LW');
	CharList.AddItem('AdvMec_M2');

	return SeenAnyofThem(Charlist);
}

function bool MutonM3(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('MutonM3_LW');
	CharList.AddItem('AdvMec_M3');

	return SeenAnyofThem(Charlist);
}

function bool MutonM4(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('MutonM4_LW');
	CharList.AddItem('AdvMec_M4');

	return SeenAnyofThem(Charlist);
}

function bool MutonM5(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('MutonM5_LW');
	CharList.AddItem('AdvMec_M5');

	return SeenAnyofThem(Charlist);
}


function bool CanActivateStunLancerUpgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvStunLancerM1');
	CharList.AddItem('AdvStunLancerM2');
	CharList.AddItem('AdvStunLancerM3');
	return SeenAnyofThem(Charlist);
}

function bool CanActivateMECUpgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvMEC_M1');
	CharList.AddItem('AdvMEC_M2');
	CharList.AddItem('AdvMEC_M3_LW');
	CharList.AddItem('AdvMECArcherM1');
	CharList.AddItem('AdvMECArcherM2');
	return SeenAnyofThem(Charlist);
}

function bool CanActivateAdvCaptainM2Upgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvCaptainM2');
	CharList.AddItem('AdvCaptainM3');
	return SeenAnyofThem(Charlist);
}

function bool CanActivateCodexUpgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('Cyberus');
	return SeenAnyofThem(Charlist);
}

function bool Cyberus(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('Cyberus');
	return SeenAnyofThem(Charlist);
}

function bool CanActivateMutonUpgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('Muton');
	CharList.AddItem('MutonM2_LW');
	CharList.AddItem('MutonM3_LW');
	CharList.AddItem('Berserker');
	return SeenAnyofThem(Charlist);
}

function bool CanActivateSentryUpgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('AdvSentryM1');
	CharList.AddItem('AdvSentryM2');
	CharList.AddItem('AdvSentryM3');
	return SeenAnyofThem(Charlist);
}

function bool CanActivateFacelessUpgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('Faceless');
	return SeenAnyofThem(Charlist);
}

function bool CanActivateSnekUpgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('Viper');
	CharList.AddItem('ViperM2_LW');
	CharList.AddItem('ViperM3_LW');
	CharList.AddItem('NajaM1');
	CharList.AddItem('NajaM2');
	CharList.AddItem('NajaM3');
	CharList.AddItem('SidewinderM1');
	CharList.AddItem('SidewinderM2');
	CharList.AddItem('SidewinderM3');
	return SeenAnyofThem(Charlist);
}

function bool CanActivateArchonUpgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('Archon');
	CharList.AddItem('ArchonM2_LW');
	return SeenAnyofThem(Charlist);
}

function bool CanActivateGatekeeperUpgrade(XComGameState_DarkEvent DarkEventState)
{
	local array<name> CharList;

	CharList.AddItem('Gatekeeper');
	return SeenAnyofThem(Charlist);
}


function bool AlwaysFalse(XComGameState_DarkEvent DarkEventState)
{
	return false;
}


static function GenericSettings (out X2DarkEventTemplate Template)
{
	Template.Category = "DarkEvent";
	Template.bRepeatable = false;
    Template.bTactical = true;
    Template.bLastsUntilNextSupplyDrop = false;
	Template.StartingWeight = 5;
	Template.MaxWeight = Template.StartingWeight;
    Template.MaxSuccesses = 0;
    Template.MinDurationDays = 9999;
    Template.MaxDurationDays = 99999;
    Template.bInfiniteDuration = true;
    Template.WeightDeltaPerActivate = 0;
	Template.WeightDeltaPerPlay = 0;
    Template.MinActivationDays = 21;
    Template.MaxActivationDays = 28;
	Template.MinWeight = 1;
	Template.OnActivatedFn = ActivateTacticalDarkEvent;
    Template.OnDeactivatedFn = DeactivateTacticalDarkEvent;
}

// This only pops before first objective is finished
static function X2DataTemplate CreatePreRevealMinorBreakthrough()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_MinorBreakthrough2');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Avatar";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 15;
	Template.MaxActivationDays = 20;
	Template.MinDurationDays = 0;
	Template.MaxDurationDays = 0;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 10;
	Template.MinWeight = 1;
	Template.MaxWeight = 10;
	Template.WeightDeltaPerPlay = 0;
	Template.WeightDeltaPerActivate = -2;
	Template.MutuallyExclusiveEvents.AddItem('DarkEvent_MajorBreakthrough');
	Template.MutuallyExclusiveEvents.AddItem('DarkEvent_MajorBreakthrough2');
	Template.MutuallyExclusiveEvents.AddItem('DarkEvent_MinorBreakthrough');
	Template.bNeverShowObjective = true;

	Template.OnActivatedFn = ActivateMinorBreakthroughMod;
	Template.CanActivateFn = CanActivateMinorBreakthrough2;
	Template.CanCompleteFn = CanCompleteMinorBreakthrough;
	Template.GetSummaryFn = GetMinorBreakthroughSummary2;
	Template.GetPreMissionTextFn = GetMinorBreakthroughPreMissionText2;

	return Template;
}

function ActivateMinorBreakthroughMod(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	`LWACTIVITYMGR.AddDoomToRandomFacility(NewGameState, GetMinorBreakthroughDoom(), default.MinorBreakthroughDoomLabel);
}

function bool CanActivateMinorBreakthrough2(XComGameState_DarkEvent DarkEventState)
{
	// Add condition that avatar project is not revealed
	return (!AtFirstMonth() && !AtMaxDoom() && !class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'));
}

function string GetMinorBreakthroughSummary2(string strSummaryText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetBlocksString(GetMinorBreakthroughDoom());
	return `XEXPAND.ExpandString(strSummaryText);
}

function string GetMinorBreakthroughPreMissionText2(string strPreMissionText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetBlocksString(GetMinorBreakthroughDoom());
	return `XEXPAND.ExpandString(strPreMissionText);
}

static function X2DataTemplate CreatePreRevealMajorBreakthrough()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_MajorBreakthrough2');
	Template.Category = "DarkEvent";
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Avatar2";
	Template.bRepeatable = true;
	Template.bTactical = false;
	Template.bLastsUntilNextSupplyDrop = false;
	Template.MaxSuccesses = 0;
	Template.MinActivationDays = 21;
	Template.MaxActivationDays = 28;
	Template.MinDurationDays = 0;
	Template.MaxDurationDays = 0;
	Template.bInfiniteDuration = false;
	Template.StartingWeight = 6;
	Template.MinWeight = 1;
	Template.MaxWeight = 6;
	Template.WeightDeltaPerPlay = 0;
	Template.WeightDeltaPerActivate = -2;
	Template.MutuallyExclusiveEvents.AddItem('DarkEvent_MinorBreakthrough');
	Template.MutuallyExclusiveEvents.AddItem('DarkEvent_MajorBreakthrough');
	Template.MutuallyExclusiveEvents.AddItem('DarkEvent_MinorBreakthrough2');
	Template.bNeverShowObjective = true;

	Template.OnActivatedFn = ActivateMajorBreakthroughMod;
	Template.CanActivateFn = CanActivateMajorBreakthrough2;
	Template.CanCompleteFn = CanCompleteMajorBreakthrough;
	Template.GetSummaryFn = GetMajorBreakthroughSummary2;
	Template.GetPreMissionTextFn = GetMajorBreakthroughPreMissionText2;

	return Template;
}

function ActivateMajorBreakthroughMod(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	`LWACTIVITYMGR.AddDoomToRandomFacility(NewGameState, GetMajorBreakthroughDoom(), default.MajorBreakthroughDoomLabel);
}

function bool CanActivateMajorBreakthrough2(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	// Add condition that avatar project is not revealed

	return (ResistanceHQ.NumMonths >= 2 && !AtMaxDoom() && !class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'));
}

function string GetMajorBreakthroughSummary2(string strSummaryText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetBlocksString(GetMajorBreakthroughDoom());
	return `XEXPAND.ExpandString(strSummaryText);
}

function string GetMajorBreakthroughPreMissionText2(string strPreMissionText)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetBlocksString(GetMajorBreakthroughDoom());
	return `XEXPAND.ExpandString(strPreMissionText);
}

function bool CanActivateMajorBreakthroughAlt(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local bool bCanActivate;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	`LWTRACE ("Checking activation criteria for Major Breakthrough Dark Event");
	bCanActivate = true;
	if (ResistanceHQ.NumMonths < 2)
	{
		`LWTRACE ("--- Major Breakthrough : Invalid because in first two months");
		bCanActivate = false;
	}
	if (AtMaxDoom())
	{
		`LWTRACE ("--- Major Breakthrough : Invalid because at max doom");
		bCanActivate = false;
	}
	if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'))
	{
		`LWTRACE ("--- Major Breakthrough : Invalid because at S0_RevealAvatarProject not complete");
		bCanActivate = false;
	}
	if (bCanActivate)
	{
		`LWTRACE ("--- Major Breakthrough : All conditions passed");
	}
	return bCanActivate;
}

function bool CanActivateMinorBreakthroughAlt(XComGameState_DarkEvent DarkEventState)
{
	local bool bCanActivate;

	`LWTRACE ("Checking activation criteria for Minor Breakthrough Dark Event");
	bCanActivate = true;
	if (AtFirstMonth())
	{
		`LWTRACE ("--- Minor Breakthrough : Invalid because in first month");
		bCanActivate = false;
	}
	if (AtMaxDoom())
	{
		`LWTRACE ("--- Minor Breakthrough : Invalid because at max doom");
		bCanActivate = false;
	}
	// Add condition that avatar project IS revealed
	if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'))
	{
		`LWTRACE ("--- Minor Breakthrough : Invalid because at S0_RevealAvatarProject not complete");
		bCanActivate = false;
	}
	if (bCanActivate)
	{
		`LWTRACE ("--- Minor Breakthrough : All conditions passed");
	}
	return bCanActivate;
}

// Removes BlackMarket impact
function ActivateAlienCypher_LW(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate)
{
    local StrategyCostScalar IntelScalar;
	IntelScalar.ItemTemplateName = 'Intel';
	IntelScalar.Scalar = GetAlienCypherScalar();
	IntelScalar.Difficulty = `STRATEGYDIFFICULTYSETTING; // Set to the current difficulty

	GetAlienHQ().CostScalars.AddItem(IntelScalar);
}

function DeactivateAlienCypher_LW(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local int idx;

	AlienHQ = GetAlienHQ();

	for(idx = 0; idx < AlienHQ.CostScalars.Length; idx++)
	{
		if(AlienHQ.CostScalars[idx].ItemTemplateName == 'Intel' && AlienHQ.CostScalars[idx].Scalar == GetAlienCypherScalar())
		{
			AlienHQ.CostScalars.Remove(idx, 1);
			break;
		}
	}
}

function XComGameState_HeadquartersAlien GetAlienHQ()
{
	return XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
}