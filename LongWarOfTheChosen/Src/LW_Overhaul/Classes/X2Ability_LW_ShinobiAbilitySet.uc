//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_ShinobiAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Shinobi-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_ShinobiAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(LW_SoldierSkills);

var config int WHIRLWIND_COOLDOWN;
var config int COUP_DE_GRACE_COOLDOWN;
var config int COUP_DE_GRACE_DISORIENTED_CHANCE;
var config int COUP_DE_GRACE_STUNNED_CHANCE;
var config int COUP_DE_GRACE_UNCONSCIOUS_CHANCE;
var config int TARGET_DAMAGE_CHANCE_MULTIPLIER;

var config int COUP_DE_GRACE_2_HIT_BONUS;
var config int COUP_DE_GRACE_2_CRIT_BONUS;
var config int COUP_DE_GRACE_2_DAMAGE_BONUS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_ShinobiAbilitySet.CreateTemplates --------------------------------");

	Templates.AddItem(AddWhirlwind());
	Templates.AddItem(AddWhirlwindPassive());
	Templates.AddItem(AddCoupDeGraceAbility());
	Templates.AddItem(AddCoupDeGracePassive());
	Templates.AddItem(AddCoupDeGrace2Ability());
	Templates.AddItem(PurePassive('Tradecraft', "img:///UILibrary_LWOTC.LW_AbilityTradecraft", true));
	return Templates;
}


static function X2AbilityTemplate AddCoupDeGrace2Ability()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_CoupdeGrace2				CoupDeGraceEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CoupDeGrace2');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityCoupDeGrace";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	CoupDeGraceEffect = new class'X2Effect_CoupDeGrace2';
	CoupDeGraceEffect.To_Hit_Modifier=default.COUP_DE_GRACE_2_HIT_BONUS;
	CoupDeGraceEffect.Crit_Modifier=default.COUP_DE_GRACE_2_CRIT_BONUS;
	CoupDeGraceEffect.Damage_Bonus=default.COUP_DE_GRACE_2_DAMAGE_BONUS;
	CoupDeGraceEffect.Half_for_Disoriented=true;
	CoupDeGraceEffect.BuildPersistentEffect (1, true, false);
	CoupDeGraceEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(CoupDeGraceEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//based on Slash_LW and Kubikuri
static function X2AbilityTemplate AddCoupDeGraceAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitProperty			UnitCondition;
	local X2AbilityCooldown                 Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CoupDeGrace');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityCoupDeGrace";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.COUP_DE_GRACE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AddShooterEffectExclusions();

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.RequireWithinRange = true;
	UnitCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	UnitCondition.ExcludeRobotic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_CoupDeGrace'); // add condition that requires target to be disoriented, stunned or unconscious

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	// VGamepliz matters

	Template.ActivationSpeech = 'CoupDeGrace';
	Template.SourceMissSpeech = 'SwordMiss';

	Template.AdditionalAbilities.AddItem('CoupDeGracePassive');

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddCoupDeGracePassive()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CoupDeGrace				CoupDeGraceEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CoupDeGracePassive');
	Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityCoupDeGrace";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.bIsPassive = true;

	// Coup de Grace effect
	CoupDeGraceEffect = new class'X2Effect_CoupDeGrace';
	CoupDeGraceEffect.DisorientedChance = default.COUP_DE_GRACE_DISORIENTED_CHANCE;
	CoupDeGraceEffect.StunnedChance = default.COUP_DE_GRACE_STUNNED_CHANCE;
	CoupDeGraceEffect.UnconsciousChance = default.COUP_DE_GRACE_UNCONSCIOUS_CHANCE;
	CoupDeGraceEffect.TargetDamageChanceMultiplier = default.TARGET_DAMAGE_CHANCE_MULTIPLIER;
	CoupDeGraceEffect.BuildPersistentEffect (1, true, false);
	Template.AddTargetEffect(CoupDeGraceEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddWhirlwind()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Whirlwind2				WhirlwindEffect;
	
	// LWOTC: For historical and backwards compatibility reasons, this is called
	// Whirlwind2 rather than Whirlwind, even though the original Whirlwind has
	// been removed.
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Whirlwind2');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_riposte";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	WhirlwindEffect = new class'X2Effect_Whirlwind2';
	WhirlwindEffect.BuildPersistentEffect(1, true, false, false);
	WhirlwindEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	WhirlwindEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(WhirlwindEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bShowActivation = true;
	Template.bShowPostActivation = false;

	return Template;
}

static function X2AbilityTemplate AddWhirlwindPassive()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('WhirlwindPassive', "img:///UILibrary_PerkIcons.UIPerk_riposte", , 'eAbilitySource_Perk');

	return Template;
}
