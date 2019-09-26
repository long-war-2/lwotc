class X2StrategyElement_DarkEvents_LW extends X2StrategyElement_DefaultDarkEvents config (GameData);

var config float RURAL_PROPAGANDA_BLITZ_RECRUITING_MULTIPLIER;
var config float COUNTERINTELLIGENCE_SWEEP_INTEL_MULTIPLIER;
var config float RURAL_CHECKPOINTS_SUPPLY_MULTIPLIER;

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


	DarkEvents.AddItem(CreateAdventScopesTemplate());
	DarkEvents.AddItem(CreateAdventLaserSightsTemplate());
	DarkEvents.AddItem(CreateFirewallsTemplate());
	DarkEvents.AddItem(CreateAlienConditioning1Template());
	DarkEvents.AddItem(CreateAlienConditioning2Template());
	DarkEvents.AddItem(CreateAlienConditioning3Template());
	DarkEvents.AddItem(CreateVeteranUnitsTemplate());
	DarkEvents.AddItem(CreateAdvancedServosTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesDefenseTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesWilltoSurviveTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesCenterMassTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesInfighterTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesFormidableTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesLethalTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesShredderTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesHuntersInstinctTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesLightningReflexesTemplate());
	DarkEvents.AddItem(CreateTacticalUpgradesCloseCombatSpecialstTemplate());
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
	DarkEvents.AddItem(CreateGreaterFacelessDarkEventTemplte());
	
	//DarkEvents.AddItem(CreateTacticalUpgradesMutonEngineersTemplate()); Disabled for now


    return DarkEvents;
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


static function X2DataTemplate CreateTacticalUpgradesInfighterTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Infighter');
	GenericSettings(Template);
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowOfForce"; 
	Template.StartingWeight = 5;
    Template.MinActivationDays = 8;
    Template.MaxActivationDays = 10;
    Template.MaxWeight = Template.StartingWeight;
	TEmplate.CanActivateFn = CanActivateStunLancerUpgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesDefenseTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_TacticalUpgrades');
	GenericSettings(Template);
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowofForce"; 
	Template.StartingWeight = 5;
	Template.MinActivationDays = 12;
    Template.MaxActivationDays = 18;
    Template.MaxWeight = Template.StartingWeight;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesCenterMassTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_CenterMass');
	GenericSettings(Template);
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_RapidResponse"; 
	Template.StartingWeight = 5;
    Template.MinActivationDays = 18;
    Template.MaxActivationDays = 24;
    Template.MaxWeight = Template.StartingWeight;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesWilltoSurviveTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_WilltoSurvive');
	GenericSettings(Template);
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_NewArmor"; 
	Template.StartingWeight = 5;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 21;
    Template.MaxWeight = Template.StartingWeight;
	return Template;
}


static function X2DataTemplate CreateAdventScopesTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_ADVENTScopes');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_RapidResponse"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 21;
    Template.MaxActivationDays = 28;

	return Template;
}

static function X2DataTemplate CreateAdventLaserSightsTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_ADVENTLaserSights');
	GenericSettings(Template);
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	Template.StartingWeight = 5;
    Template.MinActivationDays = 21;
    Template.MaxActivationDays = 28;
	return Template;
}

static function X2DataTemplate CreateFirewallsTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Firewalls');

	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Cryptography"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 21;
    Template.MaxActivationDays = 28;
	return Template;
}

static function X2DataTemplate CreateAlienConditioning1Template()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_AlienConditioning1');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowOfForce"; 
	GenericSettings(Template);
	Template.StartingWeight = 100;
    Template.MinActivationDays = 7;
    Template.MaxActivationDays = 9;
	Template.CanActivateFn = CanActivateJune1;
	return Template;
}

static function X2DataTemplate CreateAlienConditioning2Template()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_AlienConditioning2');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_NewArmor"; 
	GenericSettings(Template);
	Template.StartingWeight = 100;
    Template.MinActivationDays = 7;
    Template.MaxActivationDays = 9;
	Template.CanActivateFn = CanActivateSept1;
	return Template;
}

static function X2DataTemplate CreateAlienConditioning3Template()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_AlienConditioning3');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_RapidResponse"; 
	GenericSettings(Template);
	Template.StartingWeight = 100;
    Template.MinActivationDays = 7;
    Template.MaxActivationDays = 9;
	Template.CanActivateFn = CanActivateDec1;
	return Template;
}

static function X2DataTemplate CreateVeteranUnitsTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_VeteranUnits');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_RapidResponse"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 12;
    Template.MaxActivationDays = 15;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesMutonEngineersTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_MutonEngineers');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	GenericSettings(Template);
	Template.StartingWeight = 5; // Disabled for the moment, Muton Grenades get 10 env damage
    Template.MinActivationDays = 12;
    Template.MaxActivationDays = 15;
	Template.CanActivateFn = CanActivateMutonUpgrade;
	return Template;
}

static function X2DataTemplate CreateAdvancedServosTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_AdvancedServos');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 18;
    Template.MaxActivationDays = 21;
	Template.CanActivateFn = CanActivateMECUpgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesFormidableTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Formidable');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_NewArmor"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 18;
    Template.MaxActivationDays = 21;
	Template.CanActivateFn = AlwaysFalse;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesLethalTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Lethal');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 18;
    Template.MaxActivationDays = 21;
	Template.CanActivateFn = CanActivateGatekeeperUpgrade;

	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesShredderTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Shredder');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowOfForce"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 18;
	Template.CanActivateFn = CanActivateAdvCaptainM2Upgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesHuntersInstinctTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_HuntersInstinct');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowOfForce"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 18;
	Template.CanActivateFn = CanActivateSnekUpgrade;
	
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesLightningReflexesTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_LightningReflexes');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowOfForce"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 18;
	Template.CanActivateFn = CanActivateStunLancerUpgrade;

	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesCloseCombatSpecialstTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_CloseCombatSpecialist');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowOfForce"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 12;
    Template.MaxActivationDays = 16;
	Template.CanActivateFn = CanActivateArchonUpgrade;

	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesGrazingFireTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_GrazingFire');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_ShowOfForce"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 18;
    Template.MaxActivationDays = 21;

	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesCutthroatTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Cutthroat');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_RapidResponse"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 12;
    Template.MaxActivationDays = 16;

	Template.CanActivateFn = CanActivateStunLancerUpgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesCombatAwarenessTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_CombatAwareness');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 18;
	Template.CanActivateFn = CanActivateSentryUpgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesIronSkinTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_IronSkin');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 12;
    Template.MaxActivationDays = 16;
	Template.CanActivateFn = CanActivateMECUpgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesTacticalSenseTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_TacticalSense');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 18;
    Template.MaxActivationDays = 21;
	Template.CanActivateFn = CanActivateAdvCaptainM2Upgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesAggressionTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Aggression');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_RapidResponse"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 21;
	Template.CanActivateFn = CanActivateMutonUpgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesResilienceTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Resilience');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 10;
    Template.MaxActivationDays = 14;
	Template.CanActivateFn = CanActivateCodexUpgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesShadowstepTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_Shadowstep');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 21;
	Template.CanActivateFn = CanActivateCodexUpgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesDamageControlTemplate()
{
	local X2DarkEventTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_DamageControl');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_Vigilance"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 21;
	Template.CanActivateFn = CanActivateCodexUpgrade;
	return Template;
}

static function X2DataTemplate CreateTacticalUpgradesHardTargetTemplate()
{
	local X2DarkEventTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DarkEventTemplate', Template, 'DarkEvent_HardTarget');
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.DarkEvent_RapidResponse"; 
	GenericSettings(Template);
	Template.StartingWeight = 5;
    Template.MinActivationDays = 14;
    Template.MaxActivationDays = 21;
	Template.CanActivateFn = CanActivateSnekUpgrade;
	return Template;
}

static function X2DataTemplate CreateGreaterFacelessDarkEventTemplte()
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

	`LWTrACE ("Checking activation criteria for Major Breakthrough Dark Event");
	bCanActivate = true;
	if (ResistanceHQ.NumMonths < 2)
	{
		`LWTrACE ("--- Major Breakthrough : Invalid because in first two months");
		bCanActivate = false;
	}
	if (AtMaxDoom())
	{
		`LWTrACE ("--- Major Breakthrough : Invalid because at max doom");
		bCanActivate = false;
	}
	if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'))
	{
		`LWTrACE ("--- Major Breakthrough : Invalid because at S0_RevealAvatarProject not complete");
		bCanActivate = false;
	}
	if (bCanActivate)
	{
		`LWTrACE ("--- Major Breakthrough : All conditions passed");
	}
	return bCanActivate;
}

function bool CanActivateMinorBreakthroughAlt(XComGameState_DarkEvent DarkEventState)
{
	local bool bCanActivate;

	`LWTrACE ("Checking activation criteria for Minor Breakthrough Dark Event");
	bCanActivate = true;
	if (AtFirstMonth())
	{
		`LWTrACE ("--- Minor Breakthrough : Invalid because in first month");
		bCanActivate = false;
	}
	if (AtMaxDoom())
	{
		`LWTrACE ("--- Minor Breakthrough : Invalid because at max doom");
		bCanActivate = false;
	}
	// Add condition that avatar project IS revealed
	if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'))
	{
		`LWTrACE ("--- Minor Breakthrough : Invalid because at S0_RevealAvatarProject not complete");
		bCanActivate = false;
	}
	if (bCanActivate)
	{
		`LWTrACE ("--- Minor Breakthrough : All conditions passed");
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