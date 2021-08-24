//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_DarkEvents_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Abilities that are added to enemy units as dark events.
//---------------------------------------------------------------------------------------

class X2Ability_DarkEvents_LW extends X2Ability config(GameCore);

enum ApplicationRulesType
{
	eAR_ADVENTClones,
	eAR_AllADVENT,
	eAR_Robots,
	eAR_Aliens,
	eAR_AllEnemies,
	eAR_CustomList
};

struct DarkEventAbilityDefinition
{
	var name AbilityName;
	var int ApplicationChance;
	var ApplicationRulesType ApplicationRules;
	var array<name> ApplicationTargetArray;
};

var config array<DarkEventAbilityDefinition> DarkEventAbilityDefinitions;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateDarkEventAbility('CloseCombatSpecialist','Captain'));
	Templates.AddItem(CreateDarkEventAbility('CloseCombatSpecialist','Drone'));
	Templates.AddItem(CreateDarkEventAbility('CloseCombatSpecialist','Andromdedon'));

	Templates.AddItem(CreateDarkEventAbility('CombatAwareness','Gunner'));
	Templates.AddItem(CreateDarkEventAbility('CombatAwareness','Sentry'));

	Templates.AddItem(CreateDarkEventAbility('Concentration_LW','Sentry'));

	Templates.AddItem(CreateDarkEventAbility('CoolUnderPressure','Sentry'));

	Templates.AddItem(CreateDarkEventAbility('RapidReaction','Sentry'));

	Templates.AddItem(CreateDarkEventAbility('HuntersInstinct','Sentry'));
	Templates.AddItem(CreateDarkEventAbility('HuntersInstinct','Drone'));
	Templates.AddItem(CreateDarkEventAbility('HuntersInstinct','Spectre'));

	Templates.AddItem(CreateDarkEventAbility('SurvivalInstinct_LW','Viper'));

	Templates.AddItem(CreateDarkEventAbility('GrazingFire','Gunner'));
	Templates.AddItem(CreateDarkEventAbility('GrazingFire','Sentry'));

	Templates.AddItem(CreateDarkEventAbility('Entwine_LW','Viper'));

	Templates.AddItem(CreateDarkEventAbility('Serpentine','Viper'));
	Templates.AddItem(CreateDarkEventAbility('Serpentine','Sidewinder'));

	Templates.AddItem(CreateDarkEventAbility('Infighter','StunLancer'));
	Templates.AddItem(CreateDarkEventAbility('Infighter','Viper'));
	Templates.AddItem(CreateDarkEventAbility('Infighter','Priest'));
	Templates.AddItem(CreateDarkEventAbility('Infighter','Spectre'));
	Templates.AddItem(CreateDarkEventAbility('Infighter','Chryssalid'));

	Templates.AddItem(CreateDarkEventAbility('Formidable','Trooper'));
	Templates.AddItem(CreateDarkEventAbility('Formidable','Sidewinder'));
	Templates.AddItem(CreateDarkEventAbility('Formidable','Shieldbearer'));

	Templates.AddItem(CreateDarkEventAbility('Impulse_LW','Trooper'));
	Templates.AddItem(CreateDarkEventAbility('Impulse_LW','Priest'));

	Templates.AddItem(CreateDarkEventAbility('LockedOn','Trooper'));

	Templates.AddItem(CreateDarkEventAbility('OpenFire_LW','Trooper'));
	Templates.AddItem(CreateDarkEventAbility('OpenFire_LW','Gunner'));
	Templates.AddItem(CreateDarkEventAbility('OpenFire_LW','Viper'));

	Templates.AddItem(CreateDarkEventAbility('ChosenVenomRounds','Trooper'));

	Templates.AddItem(CreateDarkEventAbility('Evasive','Trooper'));

	Templates.AddItem(CreateDarkEventAbility('Mayhem','Gunner'));

	Templates.AddItem(CreateDarkEventAbility('Holotargeting','Gunner'));

	Templates.AddItem(CreateDarkEventAbility('Shredder','Gunner'));
	Templates.AddItem(CreateDarkEventAbility('Shredder','Mec'));
	Templates.AddItem(CreateDarkEventAbility('Shredder','Sectopod'));


	Templates.AddItem(CreateDarkEventAbility('ShootingSharp_LW','Sectoid'));
	Templates.AddItem(CreateDarkEventAbility('ShootingSharp_LW','Captain'));

	Templates.AddItem(CreateDarkEventAbility('Aggression','Sectoid'));

	Templates.AddItem(CreateDarkEventAbility('Predator_LW','Sectoid'));
	Templates.AddItem(CreateDarkEventAbility('Predator_LW','Drone'));
	Templates.AddItem(CreateDarkEventAbility('Predator_LW','Sidewinder'));
	Templates.AddItem(CreateDarkEventAbility('Predator_LW','Muton'));

	Templates.AddItem(CreateDarkEventAbility('ApexPredator_LW','Sectoid'));
	Templates.AddItem(CreateDarkEventAbility('ApexPredator_LW','Drone'));

	Templates.AddItem(CreateDarkEventAbility('MindShield','Sectoid'));
	Templates.AddItem(CreateDarkEventAbility('MindShield','Priest'));

	Templates.AddItem(CreateDarkEventAbility('Solace','Priest'));
	Templates.AddItem(CreateDarkEventAbility('Solace','Sectoid'));


	Templates.AddItem(CreateDarkEventAbility('Dominant_LW','Sectoid'));
	Templates.AddItem(CreateDarkEventAbility('Dominant_LW','Priest'));

	Templates.AddItem(CreateDarkEventAbility('AimAssist_LW','Captain'));

	Templates.AddItem(CreateDarkEventAbility('Executioner_LW','Captain'));


	Templates.AddItem(CreateDarkEventAbility('OverBearingSuperiority_LW','Captain'));

	Templates.AddItem(CreateDarkEventAbility('Brawler','Drone'));



	Templates.AddItem(CreateDarkEventAbility('FreeGrenades','StunLancer'));

	Templates.AddItem(CreateDarkEventAbility('Bladestorm','StunLancer'));

	Templates.AddItem(CreateDarkEventAbility('ParalyzingBlows','StunLancer'));
	Templates.AddItem(CreateDarkEventAbility('ParalyzingBlows','Drone'));
	Templates.AddItem(CreateDarkEventAbility('ParalyzingBlows','Berserker'));

	Templates.AddItem(CreateDarkEventAbility('HazmatVestBonus_LW','Viper'));

	Templates.AddItem(CreateDarkEventAbility('Grit_LW','Priest'));
	Templates.AddItem(CreateDarkEventAbility('Grit_LW','Muton'));
	Templates.AddItem(CreateDarkEventAbility('Grit_LW','Chryssalid'));

	Templates.AddItem(CreateDarkEventAbility('SuperiorHolyWarrior','Priest'));

	Templates.AddItem(CreateDarkEventAbility('ChosenDragonRounds','Priest'));

	Templates.AddItem(CreateDarkEventAbility('QuickRetreat','Sidewinder'));

	Templates.AddItem(CreateDarkEventAbility('Magnum_LW','Purifier'));

	Templates.AddItem(CreateDarkEventAbility('LowProfile','Purifier'));

	Templates.AddItem(CreateDarkEventAbility('Overkill_LW','Purifier'));

	Templates.AddItem(CreateDarkEventAbility('Sprinter','Purifier'));
	Templates.AddItem(CreateDarkEventAbility('Sprinter','Muton'));
	Templates.AddItem(CreateDarkEventAbility('Sprinter','Mec'));
	Templates.AddItem(CreateDarkEventAbility('Sprinter','Spectre'));
	Templates.AddItem(CreateDarkEventAbility('Sprinter','Berserker'));

	Templates.AddItem(CreateDarkEventAbility('ReturnFire','Purifier'));

	Templates.AddItem(CreateDarkEventAbility('InstantReactionTime','Purifier'));
	Templates.AddItem(CreateDarkEventAbility('InstantReactionTime','Sectoid'));
	Templates.AddItem(CreateDarkEventAbility('InstantReactionTime','Chryssalid'));

	Templates.AddItem(CreateDarkEventAbility('Bladestorm','Muton'));

	Templates.AddItem(CreateDarkEventAbility('TotalCombat','Muton'));

	Templates.AddItem(CreateDarkEventAbility('FreeGrenades','Trooper'));

	Templates.AddItem(CreateDarkEventAbility('ZoneOfControl_LW','Muton'));
	Templates.AddItem(CreateDarkEventAbility('ZoneOfControl_LW','Berserker'));
	Templates.AddItem(CreateDarkEventAbility('ZoneOfControl_LW','StunLancer'));

	Templates.AddItem(CreateDarkEventAbility('Resilience','Mec'));
	Templates.AddItem(CreateDarkEventAbility('Resilience','Cyberus'));
	Templates.AddItem(CreateDarkEventAbility('Resilience','Berserker'));

	Templates.AddItem(CreateDarkEventAbility('VolatileMix','Mec'));
	Templates.AddItem(CreateDarkEventAbility('VolatileMix','Andromedon'));

	Templates.AddItem(CreateDarkEventAbility('AbsorptionFields_LW','Mec'));

	Templates.AddItem(CreateDarkEventAbility('PrimaryReturnFire','Mec'));
	Templates.AddItem(CreateDarkEventAbility('PrimaryReturnFire','Sectopod'));

	Templates.AddItem(CreateDarkEventAbility('Predator_LW','Cyberus'));

	Templates.AddItem(CreateDarkEventAbility('ApexPredator_LW','Cyberus'));

	Templates.AddItem(CreateDarkEventAbility('LowProfile','Cyberus'));
	Templates.AddItem(CreateDarkEventAbility('LowProfile','Spectre'));
	Templates.AddItem(CreateDarkEventAbility('LowProfile','Shieldbearer'));

	Templates.AddItem(CreateDarkEventAbility('Brawler','Shieldbearer'));
	
	Templates.AddItem(CreateDarkEventAbility('Formidable','Shieldbearer'));

	Templates.AddItem(CreateDarkEventAbility('ChosenDragonRounds','Shieldbearer'));

	Templates.AddItem(CreateDarkEventAbility('ReadyForAnything','Shieldbearer'));

	Templates.AddItem(CreateDarkEventAbility('Bladestorm','Berserker'));

	Templates.AddItem(CreateDarkEventAbility('DamageControl','Berserker'));

	Templates.AddItem(DarkEventAbility_GreaterFaceless());

	Templates.AddItem(CreateDarkEventAbility('MovingTarget_LW','Chryssalid'));

	Templates.AddItem(CreateDarkEventAbility('ParalyzingBlows','Chryssalid'));

	Templates.AddItem(CreateDarkEventAbility('Sprinter','Andromedon'));
	
	Templates.AddItem(CreateDarkEventAbility('CoolUnderPressure','Archon'));

	Templates.AddItem(CreateDarkEventAbility('HardTarget','Archon'));
	Templates.AddItem(CreateDarkEventAbility('HardTarget','Gatekeeper'));

	Templates.AddItem(CreateDarkEventAbility('SuperDuperRobot','AndromdedonRobot'));

	Templates.AddItem(CreateDarkEventAbility('Defilade','Gatekeeper'));

	/*	

	//Templates.AddItem(CreateDarkEventAbility('Cutthroat','StunLancer');
	//Templates.AddItem(CreateDarkEventAbility('Cutthroat','Motun');

	//Templates.AddItem(DarkEventAbility_Aggression());
	//Templates.AddItem(DarkEventAbility_CenterMass());
	//Templates.AddItem(DarkEventAbility_CombatAwareness());
	Templates.AddItem(DarkEventAbility_Cutthroat());
	Templates.AddItem(DarkEventAbility_DamageControl());
	Templates.AddItem(DarkEventAbility_Formidable());
	Templates.AddItem(DarkEventAbility_GrazingFire(,'Sentry'));
	Templates.AddItem(DarkEventAbility_GrazingFire(,'Gunner'));
	Templates.AddItem(DarkEventAbility_HardTarget());
	Templates.AddItem(DarkEventAbility_HuntersInstinct());

	Templates.AddItem(DarkEventAbility_LightningReflexes());
	Templates.AddItem(DarkEventAbility_Resilience());
	Templates.AddItem(DarkEventAbility_Sapper());
	Templates.AddItem(DarkEventAbility_TacticalSense());
	Templates.AddItem(DarkEventAbility_SurvivalInstinct_LW());
	*/
	return Templates;
}

static function X2AbilityTemplate CreateDarkEventAbility(name BaseAbilityName = 'Aggression', name EnemyTag = '')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ EnemyTag $ BaseAbilityName), EnemyTag);
}

static function X2AbilityTemplate DarkEventAbility_CenterMass(name BaseAbilityName = 'CenterMass')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_CloseCombatSpecialist(name BaseAbilityName = 'CloseCombatSpecialist', name EnemyTag = '')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ EnemyTag $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_CombatAwareness(name BaseAbilityName = 'CombatAwareness')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_Cutthroat(name BaseAbilityName = 'Cutthroat')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_DamageControl(name BaseAbilityName = 'DamageControl')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_Formidable(name BaseAbilityName = 'Formidable')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_GrazingFire(name BaseAbilityName = 'GrazingFire', name EnemyTag = '')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ EnemyTag $  BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_GreaterFaceless(name BaseAbilityName = 'GreaterFacelessStatImprovements')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_HardTarget(name BaseAbilityName = 'HardTarget')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_HuntersInstinct(name BaseAbilityName = 'HuntersInstinct')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_Infighter(name BaseAbilityName = 'Infighter')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_IronSkin(name BaseAbilityName = 'IronSkin')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_Lethal(name BaseAbilityName = 'Lethal')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_LightningReflexes(name BaseAbilityName = 'LightningReflexes_LW')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_Resilience(name BaseAbilityName = 'Resilience')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_Sapper(name BaseAbilityName = 'Sapper')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_Shadowstep(name BaseAbilityName = 'Shadowstep')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_Shredder(name BaseAbilityName = 'Shredder')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_TacticalSense(name BaseAbilityName = 'TacticalSense')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_WilltoSurvive(name BaseAbilityName = 'WillToSurvive')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static protected function X2AbilityTemplate ConfigureDarkEventAbility(name AbilityName, name TacticalTag, name EnemyTag = '')
{
	local X2AbilityTemplate					Template;
	local X2Condition_GameplayTag			GameplayCondition;
    local X2Condition_ChanceBasedTacticalDE	ChanceBasedCondition;
	local X2Condition_UnitPropsTacticalDE	UnitCondition;
	local DarkEventAbilityDefinition		AbilityDefinition;
	local int idx;

	`CREATE_X2ABILITY_TEMPLATE(Template, name("DarkEventAbility_" $ EnemyTag $ AbilityName));
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AdditionalAbilities.AddItem(AbilityName);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	GameplayCondition = new class'X2Condition_GameplayTag';
	GameplayCondition.RequiredGameplayTag = TacticalTag;
	Template.AbilityShooterConditions.AddItem(GameplayCondition);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	idx = default.DarkEventAbilityDefinitions.Find('AbilityName', Template.DataName);
	if (idx == INDEX_NONE)
	{
		return Template;
	}

	AbilityDefinition = default.DarkEventAbilityDefinitions[idx];

    ChanceBasedCondition = new class'X2Condition_ChanceBasedTacticalDE';
	ChanceBasedCondition.SuccessChance = AbilityDefinition.ApplicationChance;
	Template.AbilityShooterConditions.AddItem(ChanceBasedCondition);

	UnitCondition = new class'X2Condition_UnitPropsTacticalDE';
	UnitCondition.ApplicationRules = AbilityDefinition.ApplicationRules;
	UnitCondition.ApplicationTargets = AbilityDefinition.ApplicationTargetArray;
	Template.AbilityShooterConditions.AddItem(UnitCondition);

	return Template;
}

static protected function X2AbilityTemplate CloneAbilityTemplate(X2AbilityTemplate Template, string NewTemplateName)
{
	local X2AbilityTemplate NewTemplate;

	NewTemplate = new(None, NewTemplateName) class'X2AbilityTemplate' (Template);
	NewTemplate.SetTemplateName(name(NewTemplateName));
	return NewTemplate;
}
