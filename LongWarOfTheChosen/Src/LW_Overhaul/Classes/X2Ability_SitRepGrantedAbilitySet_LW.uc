//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_SitRepGrantedAbilitySet_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Defines abilities that are granted through sit reps, typically at
//           the start of a mission.
//---------------------------------------------------------------------------------------
class X2Ability_SitRepGrantedAbilitySet_LW extends X2Ability config(LW_Overhaul);

var config int LETHARGY_AIM_PENALTY;
var config int LETHARGY_MOBILITY_PENALTY;

var config array<int> UNDERINFILTRATION_AIM_MODS;
var config array<int> UNDERINFILTRATION_DEFENSE_MODS;
var config array<int> UNDERINFILTRATION_DODGE_MODS;
var config array<float> UNDERINFILTRATION_HP_MODS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CreateLethargyTemplate());
	Templates.AddItem(CreateCombatRushOnCritTemplate());
	Templates.AddItem(CreateToughTemplate());
	Templates.AddItem(CreateButchTemplate());
	Templates.AddItem(CreateRockHardTemplate());
	Templates.AddItem(CreateMonstrousTemplate());

	return Templates;
}

static function X2AbilityTemplate CreateLethargyTemplate()
{
	local X2AbilityTemplate             Template;
	local X2Effect_PersistentStatChange PersistentStatChangeEffect;
	local X2Condition_UnitProperty		UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lethargy');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_advent_marktarget";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

	// Makes non-robotic units lethargic
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, true);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, default.LETHARGY_AIM_PENALTY, MODOP_Addition);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.LETHARGY_MOBILITY_PENALTY, MODOP_Addition);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreateCombatRushOnCritTemplate()
{
	local X2AbilityTemplate			Template;
	local X2Effect_FireEventOnCrit	CombatRushEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'CombatRushOnCrit');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAdrenalNeurosympathy";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bSkipFireAction = true;
	Template.bShowActivation = false;
	Template.bCrossClassEligible = false;

	//Effect serves to fire a custom event and that's it
	CombatRushEffect = new class'X2Effect_FireEventOnCrit';
	CombatRushEffect.Eventid = 'CombatRush';
	CombatRushEffect.bShowActivation = false;
	CombatRushEffect.BuildPersistentEffect(1, true, false);
	CombatRushEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(CombatRushEffect);

	Template.AdditionalAbilities.AddItem('BroadcastCombatRush');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;		
	return Template;
}

static function X2AbilityTemplate CreateToughTemplate()
{
	return CreateEnemyScalingTemplate('ToughScaling', 0);
}

static function X2AbilityTemplate CreateButchTemplate()
{
	return CreateEnemyScalingTemplate('ButchScaling', 1);
}

static function X2AbilityTemplate CreateRockHardTemplate()
{
	return CreateEnemyScalingTemplate('RockHardScaling', 2);
}

static function X2AbilityTemplate CreateMonstrousTemplate()
{
	return CreateEnemyScalingTemplate('MonstrousScaling', 3);
}

static function X2AbilityTemplate CreateEnemyScalingTemplate(name TemplateName, int DifficultyIndex)
{
	local X2AbilityTemplate             Template;
	local X2Effect_PersistentStatChange PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_advent_marktarget";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, true);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, default.UNDERINFILTRATION_AIM_MODS[DifficultyIndex], MODOP_Addition);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, default.UNDERINFILTRATION_DEFENSE_MODS[DifficultyIndex], MODOP_Addition);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.UNDERINFILTRATION_DODGE_MODS[DifficultyIndex], MODOP_Addition);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, default.UNDERINFILTRATION_HP_MODS[DifficultyIndex], MODOP_Multiplication);
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}
