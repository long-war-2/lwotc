//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_DefaultAbilitySet.uc
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: General new abilities for LW2
//---------------------------------------------------------------------------------------

class X2Ability_LW_DefaultAbilitySet extends X2Ability config(LW_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_DefaultAbilitySet.CreateTemplates --------------------------------");

	Templates.AddItem(CreateInteractSmashNGrabAbility());
	//Templates.AddItem(CreateReflexShotAbility());
	Templates.AddItem(CreateReflexShotModifier());
	Templates.AddItem(CreateMindControlCleanse());

	return Templates;
}

static function X2AbilityTemplate CreateInteractSmashNGrabAbility()
{
	local X2AbilityTemplate Template;
	local X2Condition_UnitDoesNotHaveItem ItemCondition;
	
	`Log("TRACE: Creating SmashNGrab ability");
	Template = class'X2Ability_DefaultAbilitySet'.static.AddInteractAbility('Interact_SmashNGrab');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.ConcealmentRule = eConceal_Never;

	
	`Log("TRACE: Adding a condition");
	ItemCondition = new class'X2Condition_UnitDoesNotHaveItem';
	ItemCondition.ItemTemplateName='SmashNGrabQuestItem';
	Template.AbilityShooterConditions.AddItem(ItemCondition);

	// Reaper should always lose Shadow when opening a Smash and Grab crate
	// to avoid cheesing the mission, especially for XP.
	Template.SuperConcealmentLoss = 100;

	`Log("TRACE: All done!");
	return Template;
}

static function X2AbilityTemplate CreateReflexShotAbility()
{
	local X2AbilityToHitCalc_StandardAim StandardAim;
	local X2AbilityTemplate Template, AbilityTemplate;
	local X2AbilityCost_Ammo AmmoCost;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local array<name> SkipExclusions;
	local X2Effect_Knockback KnockbackEffect;
	local X2Condition_Visibility VisibilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ReflexShot');

	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.ShotHUDPriority = 100;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	//StandardAim.bGuaranteedHit = true;
//	Template.bOverrideAim = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;


	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.length = 0;
	ActionPointCost.AllowedTypes.AddItem (class'Utilities_LW'.const.OffensiveReflexAction);
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;
	Template.bAllowFreeFireWeaponUpgrade = true;
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);
	Template.PostActivationEvents.AddItem('StandardShotActivated');

	AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('StandardShot');
	Template.LocFriendlyName = AbilityTemplate.LocFriendlyName;

	return Template;
}


static function X2AbilityTemplate CreateReflexShotModifier()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ReflexShotModifier		ReflexEffect;
	`Log("TRACE: Creating ReflexShot ability");
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ReflexShotModifier');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;

	`Log("TRACE: Adding more to ReflxShot");
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//prevents grazes and crits
	`Log("TRACE: Adding the target effect");
	ReflexEffect = new class'X2Effect_ReflexShotModifier';
	ReflexEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(ReflexEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	`Log("TRACE: Done!");
	return Template;	
}

// Passive ability that cleanses units of various debilitating effects
// when mind control wears off (just as happens when a unit is first
// mind controlled). This is basically to fix various issues with the
// interaction of the stunned effect with mind control.
static function X2AbilityTemplate CreateMindControlCleanse()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MindControlCleanse');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_solace";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Trigger when mind control is lost
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'MindControlLost';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}
