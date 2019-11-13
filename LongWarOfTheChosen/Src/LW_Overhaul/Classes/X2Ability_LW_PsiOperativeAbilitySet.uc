class X2Ability_LW_PsiOperativeAbilitySet extends X2Ability config(LW_SoldierSkills);

var config int SOLACE_ACTION_POINTS;
var config int SOLACE_COOLDOWN;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_PsiOperativeAbilitySet.CreateTemplates --------------------------------");

	Templates.AddItem(PurePassive('QuickStudy', "img:///UILibrary_PerkIcons.UIPerk_mentalstrength", true));
	Templates.AddItem(AddSolace_LWAbility());
	return Templates;
}

static function X2AbilityTemplate AddSolace_LWAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown						Cooldown;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Effect_RemoveEffects                MentalEffectRemovalEffect;
	local X2Effect_RemoveEffects                MindControlRemovalEffect;
	local X2Condition_UnitProperty              EnemyCondition;
	local X2Condition_UnitProperty              FriendCondition;
	local X2Condition_Solace_LW					SolaceCondition;
    local X2Effect_StunRecover StunRecoverEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Solace_LW');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_solace";
    Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.DisplayTargetHitChance = false;
	Template.bLimitTargetIcons = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.SOLACE_ACTION_POINTS;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SOLACE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	SolaceCondition = new class'X2Condition_Solace_LW';
	Template.AbilityTargetConditions.AddItem(SolaceCondition);

	//Naming confusion: CreateMindControlRemoveEffects removes everything _except_ mind control, and is used when mind-controlling an enemy.
	//We want to remove all those other status effects on friendly units; we want to remove mind-control itself from enemy units.
	//(Enemy units with mind-control will be back on our team once it's removed.)

	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
    Template.AddTargetEffect(StunRecoverEffect);

	MentalEffectRemovalEffect = class'X2StatusEffects'.static.CreateMindControlRemoveEffects();
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	MentalEffectRemovalEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect(MentalEffectRemovalEffect);

	MindControlRemovalEffect = new class'X2Effect_RemoveEffects';
	MindControlRemovalEffect.EffectNamesToRemove.AddItem(class'X2Effect_MindControl'.default.EffectName);
	EnemyCondition = new class'X2Condition_UnitProperty';
	EnemyCondition.ExcludeFriendlyToSource = true;
	EnemyCondition.ExcludeHostileToSource = false;
	MindControlRemovalEffect.TargetConditions.AddItem(EnemyCondition);
	Template.AddTargetEffect(MindControlRemovalEffect);

	// Solace recovers action points like Revival Protocol
	Template.AddTargetEffect(new class'X2Effect_RestoreActionPoints');

    Template.ActivationSpeech = 'Inspire';
    Template.bShowActivation = true;
    Template.CustomFireAnim = 'HL_Psi_ProjectileMedium';
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}
