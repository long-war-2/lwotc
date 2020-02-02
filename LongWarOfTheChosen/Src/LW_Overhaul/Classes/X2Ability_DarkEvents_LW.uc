//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_DarkEvents_LW.uc
//  AUTHOR:  Peter Ledbrook
//	PURPOSE: Abilities that are added to enemy units as dark events.
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

	Templates.AddItem(DarkEventAbility_Aggression());
	Templates.AddItem(DarkEventAbility_CenterMass());
	Templates.AddItem(DarkEventAbility_CloseCombatSpecialist());
	Templates.AddItem(DarkEventAbility_CombatAwareness());
	Templates.AddItem(DarkEventAbility_Cutthroat());
	Templates.AddItem(DarkEventAbility_DamageControl());
	Templates.AddItem(DarkEventAbility_Formidable());
	Templates.AddItem(DarkEventAbility_GrazingFire());
	Templates.AddItem(DarkEventAbility_GreaterFaceless());
	Templates.AddItem(DarkEventAbility_HardTarget());
	Templates.AddItem(DarkEventAbility_HuntersInstinct());
	Templates.AddItem(DarkEventAbility_Infighter());
	Templates.AddItem(DarkEventAbility_IronSkin());
	Templates.AddItem(DarkEventAbility_Lethal());
	Templates.AddItem(DarkEventAbility_LightningReflexes());
	Templates.AddItem(DarkEventAbility_Resilience());
	Templates.AddItem(DarkEventAbility_Sapper());
	Templates.AddItem(DarkEventAbility_Shadowstep());
	Templates.AddItem(DarkEventAbility_Shredder());
	Templates.AddItem(DarkEventAbility_TacticalSense());
	Templates.AddItem(DarkEventAbility_WilltoSurvive());
	
	return Templates;
}

static function X2AbilityTemplate DarkEventAbility_Aggression(name BaseAbilityName = 'Aggression')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_CenterMass(name BaseAbilityName = 'CenterMass')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
}

static function X2AbilityTemplate DarkEventAbility_CloseCombatSpecialist(name BaseAbilityName = 'CloseCombatSpecialist')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
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

static function X2AbilityTemplate DarkEventAbility_GrazingFire(name BaseAbilityName = 'GrazingFire')
{
	return ConfigureDarkEventAbility(BaseAbilityName, name('DarkEvent_' $ BaseAbilityName));
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

static protected function X2AbilityTemplate ConfigureDarkEventAbility(name AbilityName, name TacticalTag)
{
	local X2AbilityTemplate					Template;
	local X2Condition_GameplayTag			GameplayCondition;
    local X2Condition_ChanceBasedTacticalDE	ChanceBasedCondition;
	local X2Condition_UnitPropsTacticalDE	UnitCondition;
	local DarkEventAbilityDefinition		AbilityDefinition;
	local int idx;

	`CREATE_X2ABILITY_TEMPLATE(Template, name("DarkEventAbility_" $ AbilityName));
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
