//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_SkirmisherAbilitySet_LW.uc
//  AUTHOR:  martox
//	PURPOSE: New Skirmisher abilities for LWOTC.
//---------------------------------------------------------------------------------------
class X2Ability_SkirmisherAbilitySet_LW extends X2Ability_SkirmisherAbilitySet config(LW_FactionBalance);

var config int RECKONING_LW_COOLDOWN;
var config int RECKONING_LW_SLASH_COOLDOWN;
var config int MANUAL_OVERRIDE_COOLDOWN;
var config int REFLEX_COOLDOWN;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates; 

	Templates.AddItem(AddBattlemaster());
	//from Alterd-Rushnano
	Templates.AddItem(AddSkirmisherFleche());
	Templates.AddItem(AddSkirmisherSlash());
	Templates.AddItem(AddReckoning_LW());
	Templates.AddItem(AddManualOverride_LW());
	Templates.AddItem(AddReflexTrigger());

	return Templates;
}

static function X2AbilityTemplate AddBattlemaster()
{
	local X2AbilityTemplate       Template;

	Template = PurePassive('Battlemaster', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ManualOverride", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	return Template;
}

static function X2AbilityTemplate AddReckoning_LW()
{
	local X2AbilityTemplate	Template;
	local X2AbilityCooldown	Cooldown;

	Template = PurePassive('Reckoning_LW', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Reckoning");
	Template.AdditionalAbilities.AddItem('SkirmisherFleche');
	Template.AdditionalAbilities.AddItem('SkirmisherSlash');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RECKONING_LW_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	return Template;
}

static function X2AbilityTemplate AddSkirmisherFleche()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCooldown				Cooldown;
	local int i;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('SkirmisherFleche');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CinescriptCameraType = "Skirmisher_Melee";
	
	for (i = 0; i < Template.AbilityCosts.Length; ++i)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);
		if (ActionPointCost != none)
			ActionPointCost.bConsumeAllPoints = false;
	}
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RECKONING_LW_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	return Template;
}


static function X2AbilityTemplate AddSkirmisherSlash()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SkirmisherSlash');

	// Standard melee attack setup
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	// Costs one action and doesn't end turn
	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RECKONING_LW_SLASH_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
	
	// Targetted melee attack against a single target
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target must be alive and adjacent
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	// Typical melee visualizations
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	// Standard interactions with Shadow, Chosen, and the Lost
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddManualOverride_LW()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty      	TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ManualOverride_LW');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ManualOverride";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = false;
	TargetCondition.ExcludeUnableToAct = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MANUAL_OVERRIDE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
	
	Template.AddTargetEffect(new class'X2Effect_ManualOverride_LW');

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
//BEGIN AUTOGENERATED CODE: Template Overrides 'ManualOverride'
	Template.AbilityConfirmSound = "Manual_Override_Activate";
	Template.ActivationSpeech = 'ManualOverride';
//END AUTOGENERATED CODE: Template Overrides 'ManualOverride'

	return Template;
}

// Creates a new ability that triggers at the start of each turn, but
// only if Reflex triggered in the previous enemy turn. If that happens,
// the ability clears the unit value that Reflex uses to track how many
// times it has activated during the mission. This ability then goes on
// cooldown.
static function X2AbilityTemplate AddReflexTrigger()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ResetReflex				ResetEffect;
	local X2Condition_UnitValue				ReflexTriggeredCondition;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SkirmisherReflexTrigger');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.REFLEX_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'PlayerTurnBegun';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Player;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	ReflexTriggeredCondition = new class'X2Condition_UnitValue';
	ReflexTriggeredCondition.AddCheckValue(class'X2Effect_SkirmisherReflex'.default.TotalEarnedValue, 1.0);
	Template.AbilityShooterConditions.AddItem(ReflexTriggeredCondition);

	ResetEffect = new class'X2Effect_ResetReflex';
	// ResetEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	// ResetEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(ResetEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bSkipFireAction = true;

	return Template;
}
