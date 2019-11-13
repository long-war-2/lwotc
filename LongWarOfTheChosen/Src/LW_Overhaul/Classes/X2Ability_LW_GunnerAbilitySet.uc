//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_GunnerAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Gunner-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_GunnerAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(LW_SoldierSkills);

var localized string CounterattackDodgeName;
var config int COUNTERATTACK_DODGE_AMOUNT;

var config float FLUSH_DAMAGE_PENALTY;
var config int FLUSH_COOLDOWN;
var config int FLUSH_AMMO_COST;
var config int FLUSH_AIM_BONUS;
var config int FLUSH_STATEFFECT_DURATION;
var config int FLUSH_DODGE_REDUCTION;
var config int FLUSH_DEFENSE_REDUCTION;

var config int COMBATIVES_DODGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_GunnerAbilitySet.CreateTemplates --------------------------------");

	Templates.AddItem(AddKnifeFighter());
	Templates.AddItem(AddCombatives());
	Templates.AddItem(AddCombativesAttack());
	Templates.AddItem(AddCombativesPreparationAbility());
	Templates.AddItem(AddCombativesCounterattackAbility());
	Templates.AddItem(CombativesStats());
	Templates.AddItem(AddFlushAbility());
	Templates.AddItem(FlushDamage());
	//Templates.AddItem(AddHeavyReloadAbility());
	return Templates;
}

static function X2AbilityTemplate AddCombatives()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('Combatives', "img:///UILibrary_LW_Overhaul.LW_AbilityCombatives", false, 'eAbilitySource_Perk');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, default.COMBATIVES_DODGE, true);
	Template.AdditionalAbilities.AddItem('CombativesAttack');
	Template.AdditionalAbilities.AddiTEm('CombativesPreparation');
	Template.AdditionalAbilities.AddItem('CombativesCounterattack');
	Template.AdditionalAbilities.AddItem('CombativesStats');
	return Template;
}

static function X2AbilityTemplate CombativesStats()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			StatEffect;
	local X2Effect_AdditionalAnimSets			AnimSetEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombativesStats');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_Ability_Combatives";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.AddPersistentStatChange(eStat_Dodge, float(default.COMBATIVES_DODGE));
	StatEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(StatEffect);
	Template.bCrossClassEligible = false;

	AnimSetEffect = new class'X2Effect_AdditionalAnimSets';
	AnimSetEffect.AddAnimSetWithPath("LWCombatKnife.Anims.AS_CombatKnife_CounterAttack");
	Template.AddTargetEffect(AnimSetEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.DodgeLabel, eStat_Dodge, default.COMBATIVES_DODGE);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate AddCombativesAttack()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee MeleeHitCalc;
	local X2Effect_ApplyWeaponDamage PhysicalDamageEffect;
	local X2Effect_SetUnitValue SetUnitValEffect;
	//local X2Effect_ImmediateAbilityActivation ImpairingAbilityEffect;
	local X2Effect_RemoveEffects RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombativesAttack');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_Ability_Combatives";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Offensive;

	//Template.AdditionalAbilities.AddItem(class'X2Ability_Impairing'.default.ImpairingAbilityName);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;

	ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.CounterattackActionPoint);
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDontDisplayInAbilitySummary = true;

	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	MeleeHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = MeleeHitCalc;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	//Impairing effects need to come before the damage. This is needed for proper visualization ordering.
	//Effect on a successful melee attack is triggering the Apply Impairing Effect Ability
	//ImpairingAbilityEffect = new class 'X2Effect_ImmediateAbilityActivation';
	//ImpairingAbilityEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	//ImpairingAbilityEffect.EffectName = 'ImmediateStunImpair';
	//ImpairingAbilityEffect.AbilityName = class'X2Ability_Impairing'.default.ImpairingAbilityName;
	//ImpairingAbilityEffect.bRemoveWhenTargetDies = true;
	//ImpairingAbilityEffect.VisualizationFn = class'X2Ability_Impairing'.static.ImpairingAbilityEffectTriggeredVisualization;
	//Template.AddTargetEffect(ImpairingAbilityEffect);

	// Damage Effect
	//
	PhysicalDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(PhysicalDamageEffect);

	// The Unit gets to counterattack once
	SetUnitValEffect = new class'X2Effect_SetUnitValue';
	SetUnitValEffect.UnitName = class'X2Ability'.default.CounterattackDodgeEffectName;
	SetUnitValEffect.NewValueToSet = 0;
	SetUnitValEffect.CleanupType = eCleanup_BeginTurn;
	SetUnitValEffect.bApplyOnHit = true;
	SetUnitValEffect.bApplyOnMiss = true;
	Template.AddShooterEffect(SetUnitValEffect);

	// Remove the dodge increase (happens with a counter attack, which is one time per turn)
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2Ability'.default.CounterattackDodgeEffectName);
	RemoveEffects.bApplyOnHit = true;
	RemoveEffects.bApplyOnMiss = true;
	Template.AddShooterEffect(RemoveEffects);

	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CinescriptCameraType = "Ranger_Reaper";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NormalChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddCombativesPreparationAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_ToHitModifier DodgeEffect;
	local X2Effect_SetUnitValue SetUnitValEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombativesPreparation');

	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'PlayerTurnEnded';
	Trigger.ListenerData.Filter = eFilter_Player;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

	// During the Enemy player's turn, the Unit gets a dodge increase
	DodgeEffect = new class'X2Effect_ToHitModifier';
	DodgeEffect.EffectName = class'X2Ability'.default.CounterattackDodgeEffectName;
	DodgeEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	//DodgeEffect.SetDisplayInfo(ePerkBuff_Bonus, default.CounterattackDodgeName, default.CounterattackDodgeDescription, Template.IconImage);
	DodgeEffect.AddEffectHitModifier(eHit_Graze, default.COUNTERATTACK_DODGE_AMOUNT, default.CounterattackDodgeName, class'X2AbilityToHitCalc_StandardMelee', true, false, true, true, , false);
	DodgeEffect.bApplyAsTarget = true;
	Template.AddShooterEffect(DodgeEffect);

	// The Unit gets to counterattack once
	SetUnitValEffect = new class'X2Effect_SetUnitValue';
	SetUnitValEffect.UnitName = class'X2Ability'.default.CounterattackDodgeEffectName;
	SetUnitValEffect.NewValueToSet = class'X2Ability'.default.CounterattackDodgeUnitValue;
	SetUnitValEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(SetUnitValEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddCombativesCounterattackAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombativesCounterattack');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_Ability_Combatives";

	Template.bDontDisplayInAbilitySummary = true;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.MeleeCounterattackListener;  // this probably has to change
	Template.AbilityTriggers.AddItem(EventListener);

	// Add dead eye to guarantee the explosion occurs
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.CinescriptCameraType = "Muton_Counterattack";  // might need to change this to ranger or stun lancer ...

	return Template;
}

static function X2AbilityTemplate AddKnifeFighter()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KnifeFighter');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityKnifeFighter";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	AdjacencyCondition.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	if (!class'X2Ability_PerkPackAbilitySet'.default.NO_MELEE_ATTACKS_WHEN_ON_FIRE)
	{
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	}

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddFlushAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_Visibility            VisibilityCondition;
	local X2Effect_FallBack					FallBackEffect;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2Condition_UnitProperty			ShooterCondition;
	local X2Effect_PersistentStatChange		NerfEffect;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Flush');

	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityFlush";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.bCrossClassEligible = true;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY - 1;
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bPreventsTargetTeleport = true;
	Template.bUsesFiringCamera = true;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 0;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.bAddWeaponTypicalCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.FLUSH_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.FLUSH_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	ShooterCondition=new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.FLUSH_AIM_BONUS;
	ToHitCalc.bAllowCrit = false;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AddShooterEffectExclusions();

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.bAllowAmmoEffects = false;

	FallBackEffect = new class'X2Effect_FallBack';
	FallBackEffect.BehaviorTree = 'FlushRoot';
	Template.AddTargetEffect(FallBackEffect);

	NerfEffect = new class'X2Effect_PersistentStatChange';
	NerfEffect.BuildPersistentEffect(default.FLUSH_STATEFFECT_DURATION, false, false, true, eGameRule_PlayerTurnBegin);
	NerfEffect.AddPersistentStatChange(eStat_Dodge, -float(default.FLUSH_DODGE_REDUCTION));
	NerfEffect.AddPersistentStatChange(eStat_Defense, -float(default.FLUSH_DEFENSE_REDUCTION));
	NerfEffect.SetDisplayInfo (ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	NerfEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(NerfEffect);

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    Template.AddTargetEffect(WeaponDamageEffect);

	Template.AdditionalAbilities.AddItem('FlushDamage');

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}


static function X2AbilityTemplate FlushDamage()
{
    local X2AbilityTemplate						Template;
	local X2Effect_AbilityDamageMult			DamagePenalty;

    `CREATE_X2ABILITY_TEMPLATE (Template, 'FlushDamage');
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = 2;
    Template.Hostility = 2;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamagePenalty = new class'X2Effect_AbilityDamageMult';
	DamagePenalty.Penalty = true;
	DamagePenalty.Mult = true;
	DamagePenalty.DamageMod = default.FLUSH_DAMAGE_PENALTY;
	DamagePenalty.ActiveAbility = 'Flush';
    DamagePenalty.BuildPersistentEffect(1, true, false, false);
    Template.AddTargetEffect(DamagePenalty);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

static function X2AbilityTemplate AddHeavyReloadAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2Condition_AbilitySourceWeapon   WeaponCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local array<name>                       SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HeavyReload');

	Template.bDontDisplayInAbilitySummary = true;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';
	ShooterPropertyCondition.ExcludeDead = true;                    //Can't reload while dead
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);
	WeaponCondition = new class'X2Condition_AbilitySourceWeapon';
	WeaponCondition.WantsReload = true;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);
	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_R;

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.RELOAD_PRIORITY;
	Template.bNoConfirmationWithHotKey = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.ActivationSpeech = 'Reloading';

	Template.BuildNewGameStateFn = class'X2Ability_DefaultAbilitySet'.static.ReloadAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.ReloadAbility_BuildVisualization;


	Template.Hostility = eHostility_Neutral;

	Template.CinescriptCameraType="GenericAccentCam";

	return Template;
}
