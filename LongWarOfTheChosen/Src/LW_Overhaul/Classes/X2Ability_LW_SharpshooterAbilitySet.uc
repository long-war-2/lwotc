//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_SharpshooterAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Sharpshooter-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_SharpshooterAbilitySet extends X2Ability config(LW_SoldierSkills);

var config int RAPID_TARGETING_COOLDOWN;
var config int HOLOTARGETING_COOLDOWN;
var config float ALPHAMIKEFOXTROT_DAMAGE;
var config int DOUBLE_TAP_2_COOLDOWN;

var name DoubleTapActionPoint;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_SharpshooterAbilitySet.CreateTemplates --------------------------------");
	
	//temporary common abilities so the UI will load
	Templates.AddItem(AddHolotarget());
	//Templates.AddItem(AddRapidTargeting());
	Templates.AddItem(AddMultiTargeting());

	Templates.AddItem(PurePassive('HDHolo', "img:///UILibrary_LW_Overhaul.LW_AbilityHDHolo", true));
	Templates.AddItem(PurePassive('IndependentTracking', "img:///UILibrary_LW_Overhaul.LW_AbilityIndependentTracking", true));
	Templates.AddItem(PurePassive('VitalPointTargeting', "img:///UILibrary_LW_Overhaul.LW_AbilityVitalPointTargeting", true));
	Templates.AddItem(PurePassive('RapidTargeting', "img:///UILibrary_LW_Overhaul.LW_AbilityRapidTargeting", true));

	Templates.AddItem(AddAlphaMikeFoxtrot());
	Templates.AddItem(AddDoubleTap2());
	Templates.AddItem(AddDoubleTap2ActionPoint());

	return Templates;
}

static function X2AbilityTemplate AddHolotarget()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_LWHoloTarget				Effect;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2AbilityCooldown_Holotarget	Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Holotarget');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityHolotargeting";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	//Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.Hostility = eHostility_Neutral;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = false;
	Template.ConcealmentRule = eConceal_Always;
	//Template.ActivationSpeech = 'TracerBeams';

	Cooldown = new class'X2AbilityCooldown_Holotarget';
	Cooldown.iNumTurns = default.HOLOTARGETING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	//ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('RapidTargeting');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AddShooterEffectExclusions();

	// Can only shoot visible enemies

	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Can't target dead; Can't target friendlies, can't target inanimate objects
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
		
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	// Holotarget Effect
	Effect = new class'X2Effect_LWHoloTarget';
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Effect_LWHolotarget'.default.HoloTargetEffectName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Effect.bApplyOnHit = true;
	Effect.bApplyOnMiss = true;
	Template.AddTargetEffect(Effect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddRapidTargeting()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_LWHoloTarget				Effect;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Rapidtargeting');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityRapidTargeting";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	//Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = false;
	Template.ConcealmentRule = eConceal_Always;

	Template.AbilityCosts.AddItem(default.FreeActionCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RAPID_TARGETING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Targeting Details
	// Can only shoot visible enemies
	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);


	// Can't target dead; Can't target friendlies, can't target inanimate objects
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	Template.AddShooterEffectExclusions();

	// Holotarget Effect
	Effect = new class'X2Effect_LWHoloTarget';
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Effect_LWHolotarget'.default.HoloTargetEffectName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Effect.bApplyOnHit = true;
	Effect.bApplyOnMiss = true;
	Template.AddTargetEffect(Effect);

	Template.AdditionalAbilities.AddItem('RapidTargeting_Passive');

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddMultiTargeting()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_LWHoloTarget				Effect;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityCooldown_Holotarget                 Cooldown;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Multitargeting');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityMultiTargeting";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	//Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.Hostility = eHostility_Neutral;

	Cooldown = new class'X2AbilityCooldown_Holotarget';
	Cooldown.iNumTurns = default.HOLOTARGETING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = false;
	Template.ConcealmentRule = eConceal_Always;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	// Can only shoot visible enemies
	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible = true;
    TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Can't target dead; Can't target friendlies, can't target inanimate objects
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AddShooterEffectExclusions();

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	//RadiusMultiTarget.NumTargetsRequired = 1; 
	RadiusMultiTarget.bIgnoreBlockingCover = true; 
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = false; 
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	RadiusMultiTarget.bUseWeaponRadius = true; 
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Holotarget Effect
	Effect = new class'X2Effect_LWHoloTarget';
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Effect_LWHolotarget'.default.HoloTargetEffectName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Effect.bApplyOnHit = true;
	Effect.bApplyOnMiss = true;
	Template.AddTargetEffect(Effect);
	Template.AddMultiTargetEffect(Effect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.OverrideAbilities.AddItem('Holotarget');

	return Template;
}

static function X2AbilityTemplate AddAlphaMikeFoxtrot()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PrimaryPCTBonusDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'AlphaMikeFoxtrot');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityAMF";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DamageEffect = new class'X2Effect_PrimaryPCTBonusDamage';
	DamageEffect.BonusDmg = default.ALPHAMIKEFOXTROT_DAMAGE;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	// NOTE: Limitation of this ability to PRIMARY weapons only must be configured in ClassData.ini, otherwise will apply to pistols/swords, etc., contrary to design and loc text
	// Ability parameter is ApplyToWeaponSlot=eInvSlot_PrimaryWeapon
	return Template;
}


static function X2AbilityTemplate AddDoubleTap2()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCostShow, AmmoCostActual;
	local X2AbilityCooldown					Cooldown;	
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DoubleTap2');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDoubleTap";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.DisplayTargetHitChance = true;
	Template.bCrossClassEligible = false;
	Template.bPreventsTargetTeleport = false;
	Template.Hostility = eHostility_Offensive;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.SimpleStandardAim;
    Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.DOUBLE_TAP_2_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	AmmoCostShow = new class'X2AbilityCost_Ammo';
	AmmoCostShow.iAmmo = 2;
	AmmoCostShow.bFreeCost = true; // just for show only
	Template.AbilityCosts.AddItem(AmmoCostShow);

	AmmoCostActual = new class'X2AbilityCost_Ammo';
	AmmoCostActual.iAmmo = 1; //Second shot charges 2nd
	Template.AbilityCosts.AddItem(AmmoCostActual);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AddShooterEffectExclusions();
	Template.bAllowAmmoEffects = true;
    Template.bAllowBonusWeaponEffects = true;

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.bUsesFiringCamera = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('DoubleTap2Bonus');

	return Template;
}

static function X2AbilityTemplate AddDoubleTap2ActionPoint()
{
	local X2AbilityTemplate					Template;
	local X2Effect_DoubleTap				ActionPointEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DoubleTap2Bonus');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDoubleTap";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	ActionPointEffect = new class 'X2Effect_DoubleTap';
	ActionPointEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(ActionPointEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;

}
defaultproperties
{
	DoubleTapActionPoint=DoubleTap;
}