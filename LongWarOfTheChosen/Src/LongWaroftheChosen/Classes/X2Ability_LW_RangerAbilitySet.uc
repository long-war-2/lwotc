//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_RangerAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Ranger-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_RangerAbilitySet extends X2Ability config(LW_SoldierSkills);

var config int PUMP_ACTION_EXTRA_AMMO;
var config int COMBAT_FITNESS_HP;
var config int COMBAT_FITNESS_OFFENSE;
var config int COMBAT_FITNESS_MOBILITY;
var config int COMBAT_FITNESS_DODGE;
var config int COMBAT_FITNESS_WILL;
var config int COMBAT_FITNESS_DEFENSE;
var config int FORTIFY_COOLDOWN;
var config int FORTIFY_DEFENSE;
var config int SPRINTER_MOBILITY;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_RangerAbilitySet.CreateTemplates --------------------------------");
	
	Templates.AddItem(AddPointBlank());
	Templates.AddItem(AddBothBarrels());
	Templates.AddItem(AddPumpAction());
	Templates.AddItem(AddCombatFitness());
	Templates.AddItem(AddFortify());
	Templates.AddItem(AddSprinter());
	Templates.AddItem(AddPassSidearm());
	return Templates;
}

// Based on PistolShot, but with charges added and limited by weapon range (vice sight)
static function X2AbilityTemplate AddPointBlank()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityTarget_Single            SingleTarget;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'PointBlank');

	// Icon Properties
	//Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityPointBlank";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	SingleTarget.bAllowDestructibleObjects=true;
	SingleTarget.bShowAOE = true;
	Template.AbilityTargetStyle = SingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_QuickdrawActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 3;
	Template.AddTargetEffect(KnockbackEffect);

	Template.bUseAmmoAsChargesForHUD = true;

	return Template;	
}

// Based on PistolShot, but with charges added and limited by weapon range (vice sight)
static function X2AbilityTemplate AddBothBarrels()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityTarget_Single            SingleTarget;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'BothBarrels');

	// Icon Properties
	//Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityBothBarrels";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	SingleTarget.bAllowDestructibleObjects=true;
	SingleTarget.bShowAOE = true;
	Template.AbilityTargetStyle = SingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_QuickdrawActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 2;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                                            // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_DoubleDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 5;
	Template.AddTargetEffect(KnockbackEffect);

	Template.bUseAmmoAsChargesForHUD = true;

	return Template;	
}

//this ability grants extra ammo to the sawed-off shotgun
static function X2AbilityTemplate AddPumpAction()
{
	local X2AbilityTemplate						Template;
	local X2Effect_AddAmmo						AddAmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PumpAction');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityPumpAction";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AddAmmoEffect = new class 'X2Effect_AddAmmo';
	AddAmmoEffect.ExtraAmmoAmount = default.PUMP_ACTION_EXTRA_AMMO;
	Template.AddTargetEffect (AddAmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddCombatFitness()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			StatEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombatFitness');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityExtraConditioning";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange(eStat_HP, float(default.COMBAT_FITNESS_HP));
	StatEffect.AddPersistentStatChange(eStat_Offense, float(default.COMBAT_FITNESS_OFFENSE));
	StatEffect.AddPersistentStatChange(eStat_Mobility, float(default.COMBAT_FITNESS_MOBILITY));
	StatEffect.AddPersistentStatChange(eStat_Dodge, float(default.COMBAT_FITNESS_DODGE));
	StatEffect.AddPersistentStatChange(eStat_Will, float(default.COMBAT_FITNESS_WILL));
	StatEffect.AddPersistentStatChange(eStat_Defense, float(default.COMBAT_FITNESS_DEFENSE));
	StatEffect.BuildPersistentEffect(1, true, false, false);
	StatEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(StatEffect);
	Template.bCrossClassEligible = true;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, default.COMBAT_FITNESS_HP);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, default.COMBAT_FITNESS_OFFENSE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.COMBAT_FITNESS_MOBILITY);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, default.COMBAT_FITNESS_DODGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, default.COMBAT_FITNESS_WILL);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddFortify()
{
	local X2AbilityTemplate					Template;
	local X2Effect_PersistentStatChange		FortifyEffect;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Fortify');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityFortify";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = 401;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bIsPassive = false;
	Template.AddShooterEffectExclusions();
	Template.bSkipFireAction=true;
	Template.bShowActivation=true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bCrossClassEligible = true;
    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.FORTIFY_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	Template.AbilityCosts.AddItem(default.FreeActionCost);
	
	FortifyEffect = new class'X2Effect_PersistentStatChange';
	FortifyEffect.BuildPersistentEffect (1, false, true, false, eGameRule_PlayerTurnBegin);
	FortifyEffect.EffectName = 'FortifyEffect';
	FortifyEffect.AddPersistentStatChange(eStat_Defense, float(default.FORTIFY_DEFENSE));
	FortifyEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (FortifyEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}



static function X2AbilityTemplate AddSprinter()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			StatEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Sprinter');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilitySprinter";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange(eStat_Mobility, float(default.SPRINTER_MOBILITY));
	StatEffect.BuildPersistentEffect(1, true, false, false);
	StatEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(StatEffect);
	Template.bCrossClassEligible = true;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.SPRINTER_MOBILITY);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddPassSidearm()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	local X2AbilityTarget_Single				SingleTarget;
	local X2AbilityCharges_TakeThisCharge		Charges;
	local X2AbilityCost_Charges					ChargeCost;
	local X2Condition_UnitInventory				TargetWeaponCondition;
	local X2Effect_TemporaryItem				TemporaryItemEffect;
	local X2Effect_PersistentStatChange			StatEffect;
	local X2Condition_AbilityProperty			ShooterAbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TakeThis');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityTakeThis";
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bDisplayInUITooltip = false;
    Template.bLimitTargetIcons = true;
	
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.bIncludeSelf = false;
	Template.AbilityTargetStyle = SingleTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
    Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges_TakeThisCharge';
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.HideErrors.AddItem('AA_CannotAfford_Charges');

	Template.AddShooterEffectExclusions();

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeAlien = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.IsPlayerControlled = true;
	UnitPropertyCondition.IsImpaired = false;
	UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.ExcludeNonCivilian = true;
	UnitPropertyCondition.WithinRange = 96;	// 1 adjacent tile
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	ShooterAbilityCondition = new class'X2Condition_AbilityProperty';
	ShooterAbilityCondition.OwnerHasSoldierAbilities.AddItem ('PistolStandardShot');
	ShooterAbilityCondition.TargetMustBeInValidTiles = false;
	Template.AbilityShooterConditions.AddItem(ShooterAbilityCondition);

	TargetWeaponCondition = new class 'X2Condition_UnitInventory';
	TargetWeaponCondition.ExcludeWeaponCategory = 'pistol';
	TargetWeaponCondition.RelevantSlot = eInvSlot_Utility;
	Template.AbilityTargetConditions.AddItem (TargetWeaponCondition);
	
	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'TakeThisEffect';
	TemporaryItemEffect.ItemName = 'LWPistol_CV';
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	//simulated function SetDisplayInfo(X2TacticalGameRulesetDataStructures.EPerkBuffCategory BuffCat, string strName, string strDesc, string strIconLabel, optional bool DisplayInUI, optional string strStatusIcon, optional name opAbilitySource)

	StatEffect = new class 'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange (eStat_Offense, 50);
	StatEffect.AddPersistentStatChange (eStat_SightRadius, 15);
	StatEffect.AddPersistentStatChange (eStat_DetectionRadius, 9);
	StatEffect.AddPersistentStatChange (eStat_Mobility, -1);
	StatEffect.BuildPersistentEffect (1, true, false, false);
	StatEffect.SetDisplayInfo(ePerkBuff_Passive, class'X2TacticalGameRulesetDataStructures'.default.m_aCharStatLabels[eStat_Offense], Template.GetMyLongDescription(), Template.IconImage, false);
	Template.AddTargetEffect(StatEffect);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.CustomFireAnim = 'HL_SignalBark';
	Template.ActivationSpeech = 'HoldTheLine';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}
