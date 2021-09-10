//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_PerkPackAbilitySet
//  AUTHOR:  Amineri / John Lumpkin (Pavonis Interactive)
//  PURPOSE: Defines general use ability templates
//--------------------------------------------------------------------------------------- 

class X2Ability_PerkPackAbilitySet extends X2Ability config (LW_SoldierSkills);

var config int CENTERMASS_DAMAGE;
var config int LETHAL_DAMAGE;
var config int DOUBLE_TAP_1ST_SHOT_AIM;
var config int DOUBLE_TAP_2ND_SHOT_AIM;
var config int DOUBLE_TAP_COOLDOWN;
var config int DOUBLE_TAP_MIN_ACTION_REQ;
var config int RESILIENCE_CRITDEF_BONUS;
var config int FORTIFIED_CRITDEF_BONUS;
var config int WALK_FIRE_AIM_BONUS;
var config int WALK_FIRE_CRIT_MALUS;
var config int WALK_FIRE_COOLDOWN;
var config int WALK_FIRE_AMMO_COST;
var config int WALK_FIRE_MIN_ACTION_REQ;
var config int PRECISION_SHOT_COOLDOWN;
var config int PRECISION_SHOT_AMMO_COST;
var config int PRECISION_SHOT_CRIT_BONUS;
var config int CYCLIC_FIRE_COOLDOWN;
var config int CYCLIC_FIRE_AIM_MALUS;
var config int CYCLIC_FIRE_MIN_ACTION_REQ;
var config int CYCLIC_FIRE_SHOTS;
var config int CYCLIC_FIRE_AMMO;
var config int STREET_SWEEPER_AMMO_COST;
var config int STREET_SWEEPER_COOLDOWN;
var config int STREET_SWEEPER_TILE_WIDTH;
var config int STREET_SWEEPER_MIN_ACTION_REQ;
var config float STREET_SWEEPER_CONE_LENGTH;
var config int SLUG_SHOT_COOLDOWN;
var config int SLUG_SHOT_AMMO_COST;
var config int SLUG_SHOT_MIN_ACTION_REQ;
var config int SLUG_SHOT_PIERCE;
var config int GRAZING_FIRE_SUCCESS_CHANCE;
var config int CLUTCH_SHOT_MIN_ACTION_REQ;
var config int CLUTCH_SHOT_AMMO_COST;
var config int CLUTCH_SHOT_CHARGES;
var config int GUNSLINGER_COOLDOWN;
var config int GUNSLINGER_METERS_RANGE;
var config int STEADY_WEAPON_AIM_BONUS;
var config int AREA_SUPPRESSION_AMMO_COST;
var config int AREA_SUPPRESSION_MAX_SHOTS;
var config int AREA_SUPPRESSION_SHOT_AMMO_COST;
var config float AREA_SUPPRESSION_RADIUS;
var config int SUPPRESSION_LW_SHOT_AIM_BONUS;
var config int AREA_SUPPRESSION_LW_SHOT_AIM_BONUS;
var config array<name> SUPPRESSION_LW_INVALID_WEAPON_CATEGORIES;
var config float DANGER_ZONE_BONUS_RADIUS;
var config int INTERFERENCE_CV_CHARGES;
var config int INTERFERENCE_MG_CHARGES;
var config int INTERFERENCE_BM_CHARGES;
var config int INTERFERENCE_ACTION_POINTS;
var config int DAMAGE_CONTROL_DURATION; 
var config int DAMAGE_CONTROL_ABLATIVE_HP;
var config int DAMAGE_CONTROL_BONUS_ARMOR;
var config float COVERT_DETECTION_RANGE_REDUCTION;
var config float GHOSTWALKER_DETECTION_RANGE_REDUCTION;
var config int GHOSTWALKER_DURATION;
var config int GHOSTWALKER_COOLDOWN;
var config int KUBIKURI_COOLDOWN;
var config int KUBIKURI_AMMO_COST;
var config int KUBIKURI_MIN_ACTION_REQ;
var config float KUBIKURI_MAX_HP_PCT;
var config float COMBAT_RUSH_RADIUS;
var config int COMBAT_RUSH_COOLDOWN;
var config int COMBAT_RUSH_AIM_BONUS;
var config int COMBAT_RUSH_CRIT_BONUS;
var config int COMBAT_RUSH_MOBILITY_BONUS;
var config int COMBAT_RUSH_DEFENSE_BONUS;
var config int COMBAT_RUSH_DODGE_BONUS;
var config int COMBAT_RUSH_DURATION;
var config int HEAVY_FRAGS_DAMAGE;
var config int IRON_CURTAIN_MIN_ACTION_REQ;
var config int IRON_CURTAIN_COOLDOWN;
var config int IRON_CURTAIN_ACTION_POINTS;
var config int IRON_CURTAIN_AMMO_COST;
var config int IRON_CURTAIN_TILE_WIDTH;
var config int IRON_CURTAIN_MOB_DAMAGE_DURATION;
var config int IRON_CURTAIN_MOBILITY_DAMAGE;
var config int ABSORPTION_FIELDS_COOLDOWN;
var config int ABSORPTION_FIELDS_ACTION_POINTS;
var config int ABSORPTION_FIELDS_DURATION;
var config int BODY_SHIELD_DEF_BONUS;
var config int BODY_SHIELD_ENEMY_CRIT_MALUS;
var config int BODY_SHIELD_COOLDOWN;
var config int BODY_SHIELD_DURATION;
var config int IRON_SKIN_MELEE_DAMAGE_REDUCTION;
var config int MIND_MERGE_MIN_ACTION_POINTS;
var config int MIND_MERGE_DURATION;
var config int MIND_MERGE_COOLDOWN;
var config int SOUL_MERGE_COOLDOWN_REDUCTION;
var config float MIND_MERGE_WILL_DIVISOR;
var config float MIND_MERGE_SHIELDHP_DIVISOR;
var config float SOUL_MERGE_WILL_DIVISOR;
var config float SOUL_MERGE_SHIELDHP_DIVISOR;
var config float MIND_MERGE_AMP_MG_WILL_BONUS;
var config float MIND_MERGE_AMP_MG_SHIELDHP_BONUS;
var config float MIND_MERGE_AMP_BM_WILL_BONUS;
var config float MIND_MERGE_AMP_BM_SHIELDHP_BONUS;
var config float MIND_MERGE_CRIT_DIVISOR;
var config float SOUL_MERGE_CRIT_DIVISOR;
var config float MIND_MERGE_AMP_MG_CRIT_BONUS;
var config float SOUL_MERGE_AMP_BM_CRIT_BONUS;
var config float FORMIDABLE_EXPLOSIVES_DR;
var config int FORMIDABLE_ARMOR_MITIGATION;
var config int FORMIDABLE_ABLATIVE_HP;
var config int WILLTOSURVIVE_WILLBONUS;
var config int CUTTHROAT_BONUS_CRIT_CHANCE;
var config int CUTTHROAT_BONUS_CRIT_DAMAGE;
var config int MAX_ABLATIVE_FROM_SOULSTEAL;
var config int SOULSTEAL_M1_SHIELD;
var config int SOULSTEAL_M2_SHIELD;
var config int SOULSTEAL_M3_SHIELD;
var config int CCS_AMMO_PER_SHOT;
var config int COVERING_FIRE_OFFENSE_MALUS;
var config bool NO_STANDARD_ATTACKS_WHEN_ON_FIRE;
var config bool NO_MELEE_ATTACKS_WHEN_ON_FIRE;
var config int BOMBARD_BONUS_RANGE_TILES;
var config int SHARPSHOOTERAIM_CRITBONUS;

var config int Overexertion_COOLDOWN;

var config int CE_USES_PER_TURN;
var config int CE_MAX_TILES;
var config array<name> CE_ABILITYNAMES;

var config int WILLTOSURVIVE_DEF_PENALTY;
var config float WTS_COVER_DR_PCT;
var config float WTS_WOUND_REDUCTION;


var localized string LocCoveringFire;
var localized string LocCoveringFireMalus;
var localized string LocSoulStealBuff;
var localized string LocSoulStealBuffHelpText;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2Ability_PerkPackAbilitySet.CreateTemplates()");
	
	Templates.AddItem(AddCenterMassAbility());
	Templates.AddItem(AddLethalAbility());
	Templates.AddItem(AddHitandRunAbility());
	Templates.AddItem(AddHitandSlitherAbility());
	Templates.AddItem(AddCloseCombatSpecialistAbility());
	Templates.AddItem(CloseCombatSpecialistAttack()); //Additional Ability
	Templates.AddItem(AddCloseandPersonalAbility());
	Templates.AddItem(AddDamnGoodGroundAbility());
	Templates.AddItem(AddExecutionerAbility());
	Templates.AddItem(AddResilienceAbility());
	Templates.AddItem(AddTacticalSenseAbility());
	Templates.AddItem(AddAggressionAbility());
	Templates.AddItem(AddBringEmOnAbility());
	Templates.AddItem(AddHardTargetAbility());
	Templates.AddItem(AddInfighterAbility());
	Templates.AddItem(AddDepthPerceptionAbility());
	Templates.AddItem(AddWilltoSurviveAbility()); 
	Templates.AddItem(AddLightEmUpAbility());
	Templates.AddItem(AddCloseEncountersAbility());
	Templates.AddItem(AddLoneWolfAbility());
	Templates.AddItem(AddLowProfileAbility());
	Templates.AddItem(AddDoubleTapAbility());
	Templates.AddItem(DoubleTap2ndShot()); //Additional Ability
	Templates.AddItem(AddTraverseFireAbility());
	Templates.AddItem(AddWalkFireAbility());
	Templates.AddItem(WalkFireDamage()); //Additional Ability
	Templates.AddItem(AddPrecisionShotAbility());
	Templates.AddItem(PrecisionShotCritDamage()); //Additional Ability
	Templates.AddItem(AddCyclicFireAbility());
	Templates.AddItem(CyclicFire2()); //Additional Ability
	Templates.AddItem(CyclicFire3()); //Additional Ability
	Templates.AddItem(AddStreetSweeperAbility());
	Templates.AddItem(AddSlugShotAbility());
	Templates.AddItem(SlugShotRangeEffect()); //Additional Ability
	Templates.AddItem(AddClutchShotAbility());
	Templates.AddItem(AddCommissarAbility());
	Templates.AddItem(AddGunslingerAbility());
	Templates.AddItem(GunslingerShot()); //Additional Ability
	Templates.AddItem(AddHyperReactivePupilsAbility());
	Templates.AddItem(AddSteadyWeaponAbility());
	Templates.AddItem(AddLockedOnAbility());
	Templates.AddItem(AddSentinel_LWAbility());
	Templates.AddItem(AddSentinelAbility());
	Templates.AddItem(AddRapidReactionAbility());
	Templates.AddItem(AddLightningReflexes_LWAbility());
	Templates.AddItem(AddCutthroatAbility());
	Templates.AddItem(AddRunAndGun_LWAbility());
	Templates.AddItem(AddKillerInstinctAbility());
	Templates.AddItem(AddExtraConditioningAbility());
	Templates.AddItem(AddSuppressionAbility_LW());
	Templates.AddItem(SuppressionShot_LW()); //Additional Ability
	Templates.AddItem(AddAreaSuppressionAbility());
	Templates.AddItem(AreaSuppressionShot_LW()); //Additional Ability
	Templates.AddItem(AddLockdownAbility());
	Templates.AddItem(AddDangerZoneAbility());
	Templates.AddItem(LockdownBonuses()); //Additional Ability
	Templates.AddItem(PurePassive('Mayhem', "img:///UILibrary_LW_PerkPack.LW_AbilityMayhem", false, 'eAbilitySource_Perk'));
	Templates.AddItem(MayhemBonuses()); // AdditionalAbility;
	Templates.AddItem(AddInterferenceAbility());
	Templates.AddItem(AddDamageControlAbility());
	Templates.AddItem(AddDamageControlAbilityPassive()); //Additional Ability
	Templates.AddItem(AddEvasiveAbility());
	Templates.AddItem(RemoveEvasive()); // Additional Ability
	Templates.AddItem(AddCovertAbility()); 
	Templates.AddItem(AddGhostwalkerAbility()); 
	Templates.AddItem(AddKubikuriAbility());
	Templates.AddItem(KubikiriDamage());
	Templates.AddItem(AddCombatAwarenessAbility());
	Templates.AddItem(AddCombatRushAbility());
	Templates.AddItem(BroadcastCombatRush()); //Additional Ability
	Templates.AddItem(AddGrazingFireAbility());
	Templates.AddItem(AddHeavyFragsAbility());
	Templates.AddItem(AddIronCurtainAbility());
	Templates.AddItem(IronCurtainShot()); //Additional Ability
	Templates.AddItem(AddSlash_LWAbility());
	Templates.AddItem(AddAbsorptionFieldsAbility());
	Templates.AddItem(AddBodyShieldAbility());
	Templates.AddItem(AddEmergencyLifeSupportAbility());
	Templates.AddItem(AddSmartMacrophagesAbility());
	Templates.AddItem(AddIronSkinAbility());
	Templates.AddItem(AddMindMergeAbility());
	Templates.AddItem(AddSoulMergeAbility());
	Templates.AddItem(AddShadowstrike_LWAbility());
	Templates.AddItem(AddFormidableAbility());
	Templates.AddItem(AddSoulStealTriggered2());
	Templates.AddItem(AddOverexertion());
	Templates.AddItem(AddFortifiedAbility());
	
	return Templates;
}

static function X2AbilityTemplate AddCenterMassAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PrimaryHitBonusDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'CenterMass');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCenterMass";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DamageEffect = new class'X2Effect_PrimaryHitBonusDamage';
	DamageEffect.BonusDmg = default.CENTERMASS_DAMAGE;
	DamageEffect.includepistols = true;
	DamageEffect.includesos = true;
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

static function X2AbilityTemplate AddLethalAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PrimaryHitBonusDamage        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Lethal');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityKinetic";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DamageEffect = new class'X2Effect_PrimaryHitBonusDamage';
	DamageEffect.BonusDmg = default.LETHAL_DAMAGE;
	DamageEffect.includepistols = false;
	DamageEffect.includesos = false;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// No visualization
	// NOTE: Limitation of this ability to PRIMARY weapons only must be configured in ClassData.ini, otherwise will apply to pistols/swords, etc., contrary to design and loc text
	// Ability parameter is ApplyToWeaponSlot=eInvSlot_PrimaryWeapon
	return Template;
}

static function X2AbilityTemplate AddHitandRunAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_HitandRun				HitandRunEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'HitandRun');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHitandRun";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	HitandRunEffect = new class'X2Effect_HitandRun';
	HitandRunEffect.BuildPersistentEffect(1, true, false, false);
	HitandRunEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	HitandRunEffect.DuplicateResponse = eDupe_Ignore;
	HitandRunEffect.HITANDRUN_FULLACTION = true;
	Template.AddTargetEffect(HitandRunEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: Visualization handled in X2Effect_HitandRun
	return Template;
}

static function X2AbilityTemplate AddHitandSlitherAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_HitandRun				HitandRunEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'HitandSlither');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHitandRun";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	HitandRunEffect = new class'X2Effect_HitandRun';
	HitandRunEffect.BuildPersistentEffect(1, true, false, false);
	HitandRunEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	HitandRunEffect.DuplicateResponse = eDupe_Ignore;
	HitandRunEffect.HITANDRUN_FULLACTION=false;
	Template.AddTargetEffect(HitandRunEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: Visualization handled in X2Effect_HitandRun
	return Template;
}

static function X2AbilityTemplate AddCloseCombatSpecialistAbility()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('CloseCombatSpecialist', "img:///UILibrary_LW_PerkPack.LW_AbilityCloseCombatSpecialist", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('CloseCombatSpecialistAttack');
	return Template;
}

static function X2AbilityTemplate CloseCombatSpecialistAttack()
{
	local X2AbilityTemplate								Template;
	local X2AbilityToHitCalc_StandardAim				ToHitCalc;
	local X2AbilityTrigger_Event						Trigger;
	local X2Effect_Persistent							CloseCombatSpecialistTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource		CloseCombatSpecialistTargetCondition;
	local X2AbilityTrigger_EventListener				EventListener;
	local X2Condition_UnitProperty						SourceNotConcealedCondition;
	local X2Condition_UnitEffects						SuppressedCondition;
	local X2Condition_Visibility						TargetVisibilityCondition;
	local X2AbilityCost_Ammo							AmmoCost;
	local X2AbilityTarget_Single_CCS					SingleTarget;
	//local X2AbilityCooldown								Cooldown;
	local X2Condition_NotItsOwnTurn 					NotItsOwnTurnCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CloseCombatSpecialistAttack');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseCombatSpecialist";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bCrossClassEligible = false;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bReactionFire = true;
	Template.AbilityToHitCalc = ToHitCalc;
	 
	//Cooldown = new class'X2AbilityCooldown';
	//Cooldown.iNumTurns = 1;
    //Template.AbilityCooldown = Cooldown;

	AmmoCost = new class 'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.CCS_AMMO_PER_SHOT;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	//  trigger on movement
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'PostBuildGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	//  trigger on an attack
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	//  it may be the case that enemy movement caused a concealment break, which made Bladestorm applicable - attempt to trigger afterwards
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = CloseCombatSpecialistConcealmentListener;
	EventListener.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(EventListener);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();

	//Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	SingleTarget = new class 'X2AbilityTarget_Single_CCS';
	//SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	Template.bAllowBonusWeaponEffects = true;
	Template.AddTargetEffect(class 'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	NotItsOwnTurnCondition = new class'X2Condition_NotItsOwnTurn';
	Template.AbilityShooterConditions.AddItem(NotItsOwnTurnCondition);

	//Prevent repeatedly hammering on a unit when CCS triggers.
	//(This effect does nothing, but enables many-to-many marking of which CCS attacks have already occurred each turn.)
	CloseCombatSpecialistTargetEffect = new class'X2Effect_Persistent';
	CloseCombatSpecialistTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	CloseCombatSpecialistTargetEffect.EffectName = 'CloseCombatSpecialistTarget';
	CloseCombatSpecialistTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(CloseCombatSpecialistTargetEffect);
	
	CloseCombatSpecialistTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	CloseCombatSpecialistTargetCondition.AddExcludeEffect('CloseCombatSpecialistTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(CloseCombatSpecialistTargetCondition);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

//Must be static, because it will be called with a different object (an XComGameState_Ability)
//Used to trigger Bladestorm when the source's concealment is broken by a unit in melee range (the regular movement triggers get called too soon)
static function EventListenerReturn CloseCombatSpecialistConcealmentListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit ConcealmentBrokenUnit;
	local StateObjectReference CloseCombatSpecialistRef;
	local XComGameState_Ability CloseCombatSpecialistState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	ConcealmentBrokenUnit = XComGameState_Unit(EventSource);	
	if (ConcealmentBrokenUnit == None)
		return ELR_NoInterrupt;

	//Do not trigger if the CloseCombatSpecialist soldier himself moved to cause the concealment break - only when an enemy moved and caused it.
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
	if (AbilityContext != None && AbilityContext.InputContext.SourceObject != ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef)
		return ELR_NoInterrupt;

	CloseCombatSpecialistRef = ConcealmentBrokenUnit.FindAbility('CloseCombatSpecialistAttack');
	if (CloseCombatSpecialistRef.ObjectID == 0)
		return ELR_NoInterrupt;

	CloseCombatSpecialistState = XComGameState_Ability(History.GetGameStateForObjectID(CloseCombatSpecialistRef.ObjectID));
	if (CloseCombatSpecialistState == None)
		return ELR_NoInterrupt;
	
	CloseCombatSpecialistState.AbilityTriggerAgainstSingleTarget(ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef, false);
	return ELR_NoInterrupt;
}

static function X2AbilityTemplate AddCloseandPersonalAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CloseandPersonal				CritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CloseandPersonal');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseandPersonal";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	CritModifier = new class 'X2Effect_CloseandPersonal';
	CritModifier.BuildPersistentEffect (1, true, false);
	CritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (CritModifier);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddDamnGoodGroundAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_DamnGoodGround			AimandDefModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DamnGoodGround');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDamnGoodGround";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimandDefModifiers = new class 'X2Effect_DamnGoodGround';
	AimandDefModifiers.BuildPersistentEffect (1, true, true);
	AimandDefModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandDefModifiers);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;		
}

static function X2AbilityTemplate AddExecutionerAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Executioner_LW			AimandCritModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Executioner_LW');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityExecutioner";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimandCritModifiers = new class 'X2Effect_Executioner_LW';
	AimandCritModifiers.BuildPersistentEffect (1, true, false);
	AimandCritModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandCritModifiers);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}

static function X2AbilityTemplate AddResilienceAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Resilience				MyCritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Resilience');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityResilience";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	MyCritModifier = new class 'X2Effect_Resilience';
	MyCritModifier.CritDef_Bonus = default.RESILIENCE_CRITDEF_BONUS;
	MyCritModifier.BuildPersistentEffect (1, true, false, true);
	MyCritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (MyCritModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}

static function X2AbilityTemplate AddFortifiedAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Resilience				MyCritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Fortified');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityResilience";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	MyCritModifier = new class 'X2Effect_Resilience';
	MyCritModifier.CritDef_Bonus = default.FORTIFIED_CRITDEF_BONUS;
	MyCritModifier.BuildPersistentEffect (1, true, false, true);
	MyCritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (MyCritModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}


static function X2AbilityTemplate AddTacticalSenseAbility()
{
	local X2AbilityTemplate				Template;
	local X2Effect_TacticalSense		MyDefModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TacticalSense');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityTacticalSense";	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bIsPassive = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	MyDefModifier = new class 'X2Effect_TacticalSense';
	MyDefModifier.BuildPersistentEffect (1, true, false);
	MyDefModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (MyDefModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate AddAggressionAbility()
{
	local X2AbilityTemplate				Template;
	local X2Effect_Aggression			MyCritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Aggression');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAggression";	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	MyCritModifier = new class 'X2Effect_Aggression';
	MyCritModifier.BuildPersistentEffect (1, true, false);
	MyCritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (MyCritModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate AddBringEmOnAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_BringEmOn		            DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'BringEmOn');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBringEmOn";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DamageEffect = new class'X2Effect_BringEmOn';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}


static function X2AbilityTemplate AddHardTargetAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_HardTarget					DodgeBonus;
		
	`CREATE_X2ABILITY_TEMPLATE (Template, 'HardTarget');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHardTarget";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DodgeBonus = new class 'X2Effect_HardTarget';
	DodgeBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DodgeBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(DodgeBonus);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization

	return Template;
}

static function X2AbilityTemplate AddInfighterAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Infighter					DodgeBonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Infighter');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityInfighter";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DodgeBonus = new class 'X2Effect_Infighter';
	DodgeBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DodgeBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(DodgeBonus);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}

static function X2AbilityTemplate AddDepthPerceptionAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_DepthPerception				AttackBonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'DepthPerception');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDepthPerception";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.bIsPassive = true;
	AttackBonus = new class 'X2Effect_DepthPerception';
	AttackBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	AttackBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(AttackBonus);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

	static function X2AbilityTemplate AddWilltoSurviveAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_WilltoSurvive				ArmorBonus;
	local X2Effect_PersistentStatChange			WillBonus;
	local X2Effect_GreaterPadding				GreaterPaddingEffect;
	`CREATE_X2ABILITY_TEMPLATE (Template, 'WilltoSurvive');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityWilltoSurvive";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	ArmorBonus = new class 'X2Effect_WilltoSurvive';
	ArmorBonus.WTS_DR = default.WTS_COVER_DR_PCT;
	ArmorBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ArmorBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(ArmorBonus);

	WillBonus = new class'X2Effect_PersistentStatChange';
	WillBonus.AddPersistentStatChange(eStat_Defense, default.WILLTOSURVIVE_DEF_PENALTY);
	ArmorBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	ArmorBonus.BuildPersistentEffect (1, true, false, false, 7);
	Template.AddTargetEffect(WillBonus);

	GreaterPaddingEffect = new class 'X2Effect_GreaterPadding';
	GreaterPaddingEffect.BuildPersistentEffect (1, true, false);
	GreaterPaddingEffect.Padding_HealHP = default.WTS_WOUND_REDUCTION;	
	Template.AddTargetEffect(GreaterPaddingEffect);

	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}

// - Generic Standard Shot rework
static function X2AbilityTemplate AddLightEmUpAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightEmUp');

	// Icon Properties
	Template.bDontDisplayInAbilitySummary = false;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityLightEmUp";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';                                       // color of the icon
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (!default.NO_STANDARD_ATTACKS_WHEN_ON_FIRE)
	{
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	}

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false; //THIS IS THE DIFFERENCE BETWEEN STANDARD SHOT
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.OverrideAbilities.AddItem('StandardShot');
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

static function X2AbilityTemplate AddCloseEncountersAbility()
{
	local X2AbilityTemplate							Template;
	local X2Effect_CloseEncounters					ActionEffect;
	
	`CREATE_X2ABILITY_TEMPLATE (Template, 'CloseEncounters');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCloseEncounters";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.bIsPassive = true;  // needs to be off to allow perks
	ActionEffect = new class 'X2Effect_CloseEncounters';
	ActionEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ActionEffect.BuildPersistentEffect(1, true, false);
	ActionEffect.MaxUsesPerTurn = default.CE_USES_PER_TURN;
	ActionEffect.MaxTiles = default.CE_MAX_TILES;
	ActionEffect.ApplicableAbilities = default.CE_ABILITYNAMES;
	Template.AddTargetEffect(ActionEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Visualization handled in Effect
	return Template;
}

static function X2AbilityTemplate AddLoneWolfAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LoneWolf					AimandDefModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LoneWolf');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityLoneWolf";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimandDefModifiers = new class 'X2Effect_LoneWolf';
	AimandDefModifiers.BuildPersistentEffect (1, true, false);
	AimandDefModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandDefModifiers);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;	
	//no visualization
	return Template;		
}

static function X2AbilityTemplate AddLowProfileAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_LowProfile_LW			DefModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LowProfile');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityLowProfile";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DefModifier = new class 'X2Effect_LowProfile_LW';
	DefModifier.BuildPersistentEffect (1, true, false);
	DefModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (DefModifier);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;	
	//no visualization
	return Template;
}

static function X2AbilityTemplate AddDoubleTapAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCostShow, AmmoCostActual;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown					Cooldown;	
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DoubleTap');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDoubleTap";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bCrossClassEligible = false;
	Template.bUsesFiringCamera = true;
	Template.bPreventsTargetTeleport = true;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.DOUBLE_TAP_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.DOUBLE_TAP_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	AmmoCostShow = new class'X2AbilityCost_Ammo';
	AmmoCostShow.iAmmo = 2;
	AmmoCostShow.bFreeCost = true; // just for show only
	Template.AbilityCosts.AddItem(AmmoCostShow);

	AmmoCostActual = new class'X2AbilityCost_Ammo';
	AmmoCostActual.iAmmo = 1; //Second shot charges 2nd
	Template.AbilityCosts.AddItem(AmmoCostActual);
 
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.DOUBLE_TAP_1ST_SHOT_AIM;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AddShooterEffectExclusions();

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = DoubleTap1_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('DoubleTap2ndShot');
	Template.PostActivationEvents.AddItem('DoubleTap2ndShot');
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

simulated function DoubleTap1_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr VisMgr;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateContext Context;
	local XComGameStateContext_Ability TestAbilityContext;
	local int EventChainIndex;
	local XComGameStateHistory History;
	local X2Action_EnterCover EnterCoverAction;
	local X2Action_EndCinescriptCamera EndCinescriptCameraAction;

	// Build the first shot of visualization
	TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;
	Context = VisualizeGameState.GetContext();
	AbilityContext = XComGameStateContext_Ability(Context);

	if( AbilityContext.EventChainStartIndex != 0 )
	{
		History = `XCOMHISTORY;

		// This GameState is part of a chain, which means there may be a second shot 
		for( EventChainIndex = AbilityContext.EventChainStartIndex; !Context.bLastEventInChain; ++EventChainIndex )
		{
			Context = History.GetGameStateFromHistory(EventChainIndex).GetContext();

			TestAbilityContext = XComGameStateContext_Ability(Context);

			if( TestAbilityContext.InputContext.AbilityTemplateName == 'DoubleTap2ndShot' &&
				TestAbilityContext.InputContext.SourceObject.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID &&
				TestAbilityContext.InputContext.PrimaryTarget.ObjectID == AbilityContext.InputContext.PrimaryTarget.ObjectID )
			{
				EnterCoverAction = X2Action_EnterCover(
					VisMgr.GetNodeOfType(
						VisMgr.BuildVisTree, class'X2Action_EnterCover', , TestAbilityContext.InputContext.SourceObject.ObjectID));
				if (EnterCoverAction != none)
				{
					VisMgr.DisconnectAction(EnterCoverAction);
				}
				
				EndCinescriptCameraAction = X2Action_EndCinescriptCamera(
					VisMgr.GetNodeOfType(
						VisMgr.BuildVisTree, class'X2Action_EndCinescriptCamera', , TestAbilityContext.InputContext.SourceObject.ObjectID));
				if (EndCinescriptCameraAction != none)
				{
					VisMgr.DisconnectAction(EndCinescriptCameraAction);
				}
			}
		}
	}
}

simulated function FastShot2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr VisMgr;
	local XComGameStateContext_Ability AbilityContext;
	local X2Action_ExitCover ExitCoverAction;
	local X2Action_StartCinescriptCamera StartCinescriptCameraAction;

	TypicalAbility_BuildVisualization(VisualizeGameState);
	
	VisMgr = `XCOMVISUALIZATIONMGR;
	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	
	ExitCoverAction = X2Action_ExitCover(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover', , AbilityContext.InputContext.SourceObject.ObjectID));
	if (ExitCoverAction != none)
	{
		VisMgr.DisconnectAction(ExitCoverAction);
	}
				
	StartCinescriptCameraAction = X2Action_StartCinescriptCamera(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_StartCinescriptCamera', , AbilityContext.InputContext.SourceObject.ObjectID));
	if (StartCinescriptCameraAction != none)
	{
		VisMgr.DisconnectAction(StartCinescriptCameraAction);
	}
}

Static function X2AbilityTemplate DoubleTap2ndShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Condition_Visibility            VisibilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DoubleTap2ndShot');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.DOUBLE_TAP_2ND_SHOT_AIM;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'DoubleTap2ndShot'; 
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = RapidFireListener;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_DoubleTap";
	Template.CinescriptCameraType = "StandardGunFiring";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = FastShot2_BuildVisualization;
	Template.bShowActivation = true;

	return Template;
}

static function X2AbilityTemplate AddTraverseFireAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_TraverseFire					ActionEffect;
	
	`CREATE_X2ABILITY_TEMPLATE (Template, 'TraverseFire');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityTraverseFire";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	ActionEffect = new class 'X2Effect_TraverseFire';
	ActionEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ActionEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(ActionEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Visualization handled in Effect
	return Template;
}

static function X2AbilityTemplate AddWalkFireAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown					Cooldown;	
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;
	local X2Condition_UnitInventory			InventoryCondition2;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'WalkFire');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_Ability_WalkingFire";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.Hostility = eHostility_Offensive;
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bCrossClassEligible = false;
	Template.bUsesFiringCamera = true;
	Template.bPreventsTargetTeleport = false;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	/*
	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.ExcludeWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);
	*/
	InventoryCondition2 = new class'X2Condition_UnitInventory';
	InventoryCondition2.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition2.ExcludeWeaponCategory = 'sniper_rifle';
	Template.AbilityShooterConditions.AddItem(InventoryCondition2);

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.WALK_FIRE_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.WALK_FIRE_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.WALK_FIRE_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);
 
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.WALK_FIRE_AIM_BONUS;
	ToHitCalc.BuiltInCritMod = -default.WALK_FIRE_CRIT_MALUS;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AddShooterEffectExclusions();

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 1;
	Template.AddTargetEffect(KnockbackEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('WalkFireDamage');

	//WOULDBENICE: Custom animation of firing/missing/firing again

	return Template;
}

static function X2AbilityTemplate WalkFireDamage()
{
    local X2AbilityTemplate Template;
    local X2Effect_WalkFireDamage DamageEffect;

    `CREATE_X2ABILITY_TEMPLATE (Template, 'WalkFireDamage');
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = 2;
    Template.Hostility = 2;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    DamageEffect = new class'X2Effect_WalkFireDamage';
    DamageEffect.BuildPersistentEffect(1, true, false, false);
    DamageEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
    Template.AddTargetEffect(DamageEffect);
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    return Template;

}

static function X2AbilityTemplate AddPrecisionShotAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown					Cooldown;	
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'PrecisionShot');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityPrecisionShot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bCrossClassEligible = true;
	Template.bUsesFiringCamera = true;
	Template.Hostility = eHostility_Offensive;
	Template.bPreventsTargetTeleport = false;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 0;
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInCritMod = default.PRECISION_SHOT_CRIT_BONUS;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.PRECISION_SHOT_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.PRECISION_SHOT_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;
		 
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
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('PrecisionShotCritDamage');

	return Template;
}

static function X2AbilityTemplate PrecisionShotCritDamage()
{
    local X2AbilityTemplate Template;
    local X2Effect_PrecisionShotCritDamage CritEffect;

    `CREATE_X2ABILITY_TEMPLATE (Template, 'PrecisionShotCritDamage');
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = 2;
    Template.Hostility = 2;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
    CritEffect = new class'X2Effect_PrecisionShotCritDamage';
    CritEffect.BuildPersistentEffect(1, true, false, false);
    CritEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
    Template.AddTargetEffect(CritEffect);
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    return Template;
}

static function X2AbilityTemplate AddCyclicFireAbility()

{	
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown					Cooldown;	
	local X2Effect_Knockback				KnockbackEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitInventory			InventoryCondition2;
	local X2Effect_Shredder					WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CyclicFire');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCyclicFire";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.DisplayTargetHitChance = true;
	Template.bCrossClassEligible = false;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;
/*
	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.ExcludeWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	*/
	InventoryCondition2 = new class'X2Condition_UnitInventory';
	InventoryCondition2.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition2.ExcludeWeaponCategory = 'sniper_rifle';
	Template.AbilityShooterConditions.AddItem(InventoryCondition2);

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.CYCLIC_FIRE_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.CYCLIC_FIRE_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 3;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	//  actually charge 1 ammo for this shot. the 2nd and 3rd shot will charge the extra ammo.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
 
	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = -default.CYCLIC_FIRE_AIM_MALUS;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	WeaponDamageEffect = new class'X2Effect_Shredder';
	Template.AddTargetEffect(WeaponDamageEffect);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	//Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	//Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.AdditionalAbilities.AddItem('CyclicFire2');
	Template.AdditionalAbilities.AddItem('CyclicFire3');

	Template.PostActivationEvents.AddItem('CyclicFire2');

	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.bUsesFiringCamera = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

static function X2AbilityTemplate CyclicFire2()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityTrigger_EventListener    Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CyclicFire2');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = -default.CYCLIC_FIRE_AIM_MALUS;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'CyclicFire2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_rapidfire";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'CyclicFire2'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'CyclicFire2'

	Template.PostActivationEvents.AddItem('CyclicFire3');

	return Template;
}

static function X2AbilityTemplate CyclicFire3()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityTrigger_EventListener    Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CyclicFire3');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = -default.CYCLIC_FIRE_AIM_MALUS;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'CyclicFire3';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_rapidfire";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'RapidFire2'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'RapidFire2'

	return Template;
}

static function X2AbilityTemplate AddSlugShotAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2Condition_UnitInventory			InventoryCondition;
	local X2Condition_Visibility			VisibilityCondition;
	local X2Effect_Knockback				KnockbackEffect;
	
	`CREATE_X2ABILITY_TEMPLATE (Template, 'SlugShot');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySlugShot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bCrossClassEligible = false;
	Template.bUsesFiringCamera = true;
	Template.bPreventsTargetTeleport = false;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AddShooterEffectExclusions();

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.SLUG_SHOT_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.SLUG_SHOT_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.SLUG_SHOT_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.RequireWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.AdditionalAbilities.AddItem('SlugShotRangeEffect');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;		
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate SlugShotRangeEffect()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_SlugShot					SlugShotEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SlugShotRangeEffect');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySlugShot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	SlugShotEffect = new class'X2Effect_SlugShot';
	SlugShotEffect.BuildPersistentEffect (1, true, false);
	SlugShotEffect.Pierce = default.SLUG_SHOT_PIERCE;
	SlugShotEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(SlugShotEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

static function X2AbilityTemplate AddClutchShotAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_QuickdrawActionPoints_LW        ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2Condition_Visibility			VisibilityCondition;
	local X2Effect_Knockback				KnockbackEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'ClutchShot');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityClutchShot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bCrossClassEligible = false;
	Template.bUsesFiringCamera = true;
	Template.Hostility = eHostility_Offensive;
	Template.bPreventsTargetTeleport = false;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AddShooterEffectExclusions();

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = false;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;
	Template.bAllowFreeFireWeaponUpgrade = true;

	ActionPointCost = new class 'X2AbilityCost_QuickdrawActionPoints_LW';
	ActionPointCost.iNumPoints = default.CLUTCH_SHOT_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bGuaranteedHit = true;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.CLUTCH_SHOT_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = default.CLUTCH_SHOT_CHARGES;
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;	
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddCommissarAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_Commissar				DamageModifier;
		
	`CREATE_X2ABILITY_TEMPLATE (Template, 'Commissar');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCommissar";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DamageModifier = new class 'X2Effect_Commissar';
	DamageModifier.BuildPersistentEffect (1, true, true);
	DamageModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (DamageModifier);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;	
	//visualization occurs in effect
	return Template;		
}
	
static function X2AbilityTemplate AddGunslingerAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_ReserveActionPoints		ReservePointsEffect;
	local X2Effect_MarkValidActivationTiles MarkTilesEffect;
	local X2Condition_UnitEffects           SuppressedCondition;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2Condition_UnitProperty 			UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Gunslinger');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityGunslinger";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Defensive;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
	Template.bSkipFireAction = true;
    Template.bShowActivation = true;
	Template.ActivationSpeech = 'KillZone';
	Template.bCrossClassEligible = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;   
	ActionPointCost.bFreeCost = true;    
	Template.AbilityCosts.AddItem(ActionPointCost);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.GUNSLINGER_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 1;
	CursorTarget.bRestrictToSquadsightRange = true;
	Template.AbilityTargetStyle = CursorTarget;


	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.GUNSLINGER_METERS_RANGE;
	//RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
	ReservePointsEffect.ReserveType = class'X2Ability_SharpshooterAbilitySet'.default.KillZoneReserveType;
	Template.AddShooterEffect(ReservePointsEffect);

	MarkTilesEffect = new class'X2Effect_MarkValidActivationTiles';
	MarkTilesEffect.AbilityToMark = 'GunslingerShot';
	Template.AddShooterEffect(MarkTilesEffect);

	Template.TargetingMethod = class'X2TargetingMethod_Grenade';
	Template.AdditionalAbilities.AddItem('GunslingerShot');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate GunslingerShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_AbilityProperty       AbilityCondition;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_Event	        Trigger;
	local X2Effect_Persistent               GunslingerEffect;
	local X2Condition_UnitEffectsWithAbilitySource  GunslingerCondition;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2Condition_UnitProperty          ShooterCondition;
	local X2Condition_RequiredToHitChance	RequiredHitChanceCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GunslingerShot');	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	RequiredHitChanceCondition = new class'X2Condition_RequiredToHitChance';
	RequiredHitChanceCondition.MinimumRequiredHitChance = class'X2Ability_PerkPackAbilitySet2'.default.REQUIRED_TO_HIT_FOR_OVERWATCH;  
	Template.AbilityTargetConditions.AddItem(RequiredHitChanceCondition);

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.bFreeCost = true;
	ReserveActionPointCost.AllowedTypes.AddItem('KillZone');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	StandardAim.bGuaranteedHit = true;
	StandardAim.bHitsAreCrits = true;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityToHitOwnerOnMissCalc = StandardAim;
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true;
	TargetVisibilityCondition.bAllowSquadsight = false;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.TargetMustBeInValidTiles = true;
	Template.AbilityTargetConditions.AddItem(AbilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);
	GunslingerCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	GunslingerCondition.AddExcludeEffect('GunslingerTarget', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(GunslingerCondition);
	GunslingerEffect = new class'X2Effect_Persistent';
	GunslingerEffect.EffectName = 'GunslingerTarget';
	GunslingerEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	GunslingerEffect.SetupEffectOnShotContextResult(true, true);      //  mark them regardless of whether the shot hit or missed
	Template.AddTargetEffect(GunslingerEffect);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddHyperReactivePupilsAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_HyperReactivePupils		HyperReactivePupilsEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'HyperReactivePupils');	
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHyperreactivePupils";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);		
	HyperReactivePupilsEffect = new class'X2Effect_HyperReactivePupils';
	HyperReactivePupilsEffect.BuildPersistentEffect(1, true, false,, eGameRule_TacticalGameStart);
	HyperReactivePupilsEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(HyperReactivePupilsEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate AddSteadyWeaponAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_SteadyWeapon				ToHitModifier;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SteadyWeapon');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySteadyWeapon";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bSkipFireAction=true;
	Template.bShowActivation=true;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
	Template.bCrossClassEligible = false;
	//Template.DefaultKeyBinding = 539;
	//Template.bNoConfirmationWithHotKey = true;
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;    
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.AddShooterEffectExclusions();
	Template.CinescriptCameraType = "Overwatch";
	ToHitModifier = new class'X2Effect_SteadyWeapon';
	ToHitModifier.BuildPersistentEffect(2, false, true, false, eGameRule_UseActionPoint);
	ToHitModifier.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ToHitModifier.Aim_Bonus = default.STEADY_WEAPON_AIM_BONUS;
	ToHitModifier.DuplicateResponse=eDupe_Refresh;
	Template.AddTargetEffect(ToHitModifier);	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddLockedOnAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LockedOn					LockedOnEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LockedOn');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityLockedOn";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;
	LockedOnEffect = new class'X2Effect_LockedOn';
	LockedOnEffect.BuildPersistentEffect(1, true, false,, eGameRule_TacticalGameStart);
	LockedOnEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(LockedOnEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddSentinel_LWAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_Sentinel_LW				PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Sentinel_LW');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySentinel";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	PersistentEffect = new class'X2Effect_Sentinel_LW';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible = false;
	return Template;
}


static function X2AbilityTemplate AddSentinelAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_Sentinel_LW				PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Sentinel');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySentinel";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	PersistentEffect = new class'X2Effect_Sentinel_LW';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible = false;
	return Template;
}

static function X2AbilityTemplate AddRapidReactionAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_RapidReaction			PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RapidReaction');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityRapidReaction3";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	PersistentEffect = new class'X2Effect_RapidReaction';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible = false;
	return Template;
}

static function X2AbilityTemplate AddLightningReflexes_LWAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_LightningReflexes_LW		PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightningReflexes_LW');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightningreflexes";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	PersistentEffect = new class'X2Effect_LightningReflexes_LW';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible = true;
	return Template;
}

static function X2AbilityTemplate AddCutthroatAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Cutthroat				ArmorPiercingBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Cutthroat');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCutthroat";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	ArmorPiercingBonus = new class 'X2Effect_Cutthroat';
	ArmorPiercingBonus.BuildPersistentEffect (1, true, false);
	ArmorPiercingBonus.Bonus_Crit_Chance = default.CUTTHROAT_BONUS_CRIT_CHANCE;
	ArmorPiercingBonus.Bonus_Crit_Damage = default.CUTTHROAT_BONUS_CRIT_DAMAGE;
	ArmorPiercingBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (ArmorPiercingBonus);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;	
	//no visualization
	return Template;		
}

static function X2AbilityTemplate AddRunAndGun_LWAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCooldown_RunAndGun_LW	Cooldown;
	local X2Effect_GrantActionPoints		ActionPointEffect;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_KillerInstinct			DamageEffect;
	local X2Condition_UnitValue				CECondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RunAndGun_LW');

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_runandgun";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";

	Cooldown = new class'X2AbilityCooldown_RunAndGun_LW';
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	class'X2Ability_RangerAbilitySet'.static.SuperKillRestrictions(Template, 'RunAndGun_SuperKillCheck');
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CECondition = new class 'X2Condition_UnitValue';
	CECondition.AddCheckValue ('CloseEncountersUses', 0, eCheck_Exact,,,'AA_AbilityUnavailable');
	CECondition.AddCheckValue ('HitandRunUses', 0, eCheck_Exact,,,'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(CECondition); 

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.RunAndGunActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'RunAndGun';
	
	DamageEffect = new class'X2Effect_KillerInstinct';
	DamageEffect.BuildPersistentEffect(1,false,false,false,eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(DamageEffect);
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = true;

	return Template;
}


static function X2AbilityTemplate AddOverexertion()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCooldown	Cooldown;
	local X2Effect_GrantActionPoints		ActionPointEffect;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_UnitValue				CECondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Overexertion');

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_loot_move";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Overexertion_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CECondition = new class 'X2Condition_UnitValue';
	Template.AbilityShooterConditions.AddItem(CECondition); 

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(ActionPointEffect);

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'RunAndGun';
	
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = true;

	return Template;
}


static function X2AbilityTemplate AddKillerInstinctAbility()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('KillerInstinct', "img:///UILibrary_LW_PerkPack.LW_AbilityKillerInstinct", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	return Template;
}

static function X2AbilityTemplate AddExtraConditioningAbility()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('ExtraConditioning', "img:///UILibrary_PerkIcons.UIPerk_stickandmove", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	return Template;
}

static function X2AbilityTemplate AddDangerZoneAbility()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('DangerZone', "img:///UILibrary_LW_PerkPack.LW_AbilityDangerZone", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	return Template;
}


static function X2AbilityTemplate AddLockdownAbility()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('Lockdown', "img:///UILibrary_LW_PerkPack.LW_AbilityLockdown", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	return Template;
}

static function X2AbilityTemplate AddSuppressionAbility_LW()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local X2Effect_Suppression              SuppressionEffect;
	local X2Condition_UnitInventory         UnitInventoryCondition;
	local name								WeaponCategory;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Suppression');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	Template.bCrossClassEligible = false;

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 2;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	foreach default.SUPPRESSION_LW_INVALID_WEAPON_CATEGORIES(WeaponCategory)
	{
		UnitInventoryCondition = new class'X2Condition_UnitInventory';
		UnitInventoryCondition.RelevantSlot = eInvSlot_PrimaryWeapon;
		UnitInventoryCondition.ExcludeWeaponCategory = WeaponCategory;
		Template.AbilityShooterConditions.AddItem(UnitInventoryCondition);
	}

	Template.AddShooterEffectExclusions();
	
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	ReserveActionPointsEffect = new class'X2Effect_ReserveActionPoints';
	ReserveActionPointsEffect.ReserveType = 'Suppression';
	Template.AddShooterEffect(ReserveActionPointsEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	SuppressionEffect = new class'X2Effect_Suppression';
	SuppressionEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	SuppressionEffect.bRemoveWhenTargetDies = true;
	SuppressionEffect.bRemoveWhenSourceDamaged = true;
	SuppressionEffect.bBringRemoveVisualizationForward = true;
	SuppressionEffect.DuplicateResponse=eDupe_Allow;
	SuppressionEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionTargetEffectDesc, Template.IconImage);
	SuppressionEffect.SetSourceDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionSourceEffectDesc, Template.IconImage);
	Template.AddTargetEffect(SuppressionEffect);
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	
	Template.AdditionalAbilities.AddItem('SuppressionShot_LW');
	Template.AdditionalAbilities.AddItem('LockdownBonuses');
	Template.AdditionalAbilities.AddItem('MayhemBonuses');

	Template.bIsASuppressionEffect = true;
	//Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.ActivationSpeech='Suppressing';

	Template.AssociatedPassives.AddItem('HoloTargeting');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Suppression_BuildVisualization_LW;
	Template.BuildAppliedVisualizationSyncFn = class'X2Ability_GrenadierAbilitySet'.static.SuppressionBuildVisualizationSync;
	Template.CinescriptCameraType = "StandardSuppression";

	Template.Hostility = eHostility_Offensive;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}


static function X2AbilityTemplate SuppressionShot_LW()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityTrigger_Event	        Trigger;
	local X2Condition_UnitEffectsWithAbilitySource TargetEffectCondition;
	local X2Effect_RemoveEffects            RemoveSuppression;
	local X2Effect                          ShotEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SuppressionShot_LW');

	Template.bDontDisplayInAbilitySummary = true;
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem('Suppression');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInHitMod = default.SUPPRESSION_LW_SHOT_AIM_BONUS;
	StandardAim.bReactionFire = true;

	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	TargetEffectCondition.AddRequireEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsNotSuppressed');
	Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

	TargetVisibilityCondition = new class'X2Condition_Visibility';	
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.bAllowAmmoEffects = true;

	RemoveSuppression = new class'X2Effect_RemoveEffects';
	RemoveSuppression.EffectNamesToRemove.AddItem(class'X2Effect_Suppression'.default.EffectName);
	RemoveSuppression.bCheckSource = true;
	RemoveSuppression.SetupEffectOnShotContextResult(true, true);
	Template.AddShooterEffect(RemoveSuppression);
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	//don't want to exit cover, we are already in suppression/alert mode.
	Template.bSkipExitCoverWhenFiring = true;

	Template.bAllowFreeFireWeaponUpgrade = true;	
//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect();
	ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	Template.AddTargetEffect(ShotEffect);
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	Template.AddTargetEffect(ShotEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

static function Suppression_BuildVisualization_LW(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;
	local XGUnit						UnitVisualizer;
	local XComUnitPawn					UnitPawn;
	local XComWeapon					WeaponPawn;

	local VisualizationActionMetadata	EmptyTrack;
	local VisualizationActionMetadata	BuildTrack;

	local XComGameState_Ability         Ability;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	
	//check and see if there's any sort of animation for suppression
	UnitVisualizer = XGUnit(BuildTrack.VisualizeActor);
	if(UnitVisualizer != none)
	{
		UnitPawn = UnitVisualizer.GetPawn();
		if(UnitPawn != none)
		{
			WeaponPawn = XComWeapon(UnitPawn.Weapon);
			if(WeaponPawn != none)
			{
				if(!UnitPawn.GetAnimTreeController().CanPlayAnimation(GetSuppressAnimName(UnitPawn)))
				{
					// no playable animation, so use the default firing animation
					WeaponPawn.WeaponSuppressionFireAnimSequenceName = WeaponPawn.WeaponFireAnimSequenceName;
				}
			}
		}
	}

	class'X2Action_ExitCover'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);
	class'X2Action_StartSuppression'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);

	//****************************************************************************************
	//Configure the visualization track for the target
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);
	if (XComGameState_Unit(BuildTrack.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(BuildTrack.StateObject_NewState).ReserveActionPoints.Length == 0)
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
	}
}

// code based on XComIdleAnimationStateMachine.state'Fire'.GetSuppressAnimName
static function Name GetSuppressAnimName(XComUnitPawn UnitPawn)
{
	local XComWeapon Weapon;

	Weapon = XComWeapon(UnitPawn.Weapon);
	if( Weapon != None && UnitPawn.GetAnimTreeController().CanPlayAnimation(Weapon.WeaponSuppressionFireAnimSequenceName) )
	{
		return Weapon.WeaponSuppressionFireAnimSequenceName;
	}
	else if( UnitPawn.GetAnimTreeController().CanPlayAnimation(class'XComWeapon'.default.WeaponSuppressionFireAnimSequenceName) )
	{
		return class'XComWeapon'.default.WeaponSuppressionFireAnimSequenceName;
	}
	return '';
}

static function X2AbilityTemplate AddAreaSuppressionAbility()
{
	local X2AbilityTemplate								Template;
	local X2AbilityCost_Ammo							AmmoCost;
	local X2AbilityCost_ActionPoints					ActionPointCost;
	local X2AbilityMultiTarget_Radius					RadiusMultiTarget;
	local X2Effect_ReserveActionPoints					ReserveActionPointsEffect;
	local X2Condition_UnitInventory						InventoryCondition, InventoryCondition2;
	local X2Effect_AreaSuppression						SuppressionEffect;
	local X2AbilityTarget_Single						PrimaryTarget;
	local AbilityGrantedBonusRadius						DangerZoneBonus;
	local X2Condition_UnitProperty						ShooterCondition;
	local X2Condition_UnitEffects						SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AreaSuppression');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AreaSuppression";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.Hostility = eHostility_Offensive;
	Template.bDisplayInUITooltip = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.bCrossClassEligible = false;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.ActivationSpeech='Suppressing';
	Template.bIsASuppressionEffect = true;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	ShooterCondition=new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	Template.AssociatedPassives.AddItem('HoloTargeting');

	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.ExcludeWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	InventoryCondition2 = new class'X2Condition_UnitInventory';
	InventoryCondition2.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition2.ExcludeWeaponCategory = 'sniper_rifle';
	Template.AbilityShooterConditions.AddItem(InventoryCondition2);

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.AREA_SUPPRESSION_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);

	ReserveActionPointsEffect = new class'X2Effect_ReserveActionPoints';
	ReserveActionPointsEffect.ReserveType = 'Suppression';
	ReserveActionPointsEffect.NumPoints = default.AREA_SUPPRESSION_MAX_SHOTS;
	Template.AddShooterEffect(ReserveActionPointsEffect);

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	PrimaryTarget = new class'X2AbilityTarget_Single';
	PrimaryTarget.OnlyIncludeTargetsInsideWeaponRange = false;
	PrimaryTarget.bAllowInteractiveObjects = false;
	PrimaryTarget.bAllowDestructibleObjects = false;
	PrimaryTarget.bIncludeSelf = false;
	PrimaryTarget.bShowAOE = true;
	Template.AbilityTargetSTyle = PrimaryTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = false;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.ftargetradius = default.AREA_SUPPRESSION_RADIUS;
	
	DangerZoneBonus.RequiredAbility = 'DangerZone';
	DangerZoneBonus.fBonusRadius = default.DANGER_ZONE_BONUS_RADIUS;
	RadiusMultiTarget.AbilityBonusRadii.AddItem (DangerZoneBonus);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	SuppressionEffect = new class'X2Effect_AreaSuppression';
	SuppressionEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	SuppressionEffect.bRemoveWhenTargetDies = true;
	SuppressionEffect.bRemoveWhenSourceDamaged = true;
	SuppressionEffect.bBringRemoveVisualizationForward = true;
	SuppressionEffect.DuplicateResponse=eDupe_Allow;
	SuppressionEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionTargetEffectDesc, Template.IconImage);
	SuppressionEffect.SetSourceDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionSourceEffectDesc, Template.IconImage);
	Template.AddTargetEffect(SuppressionEffect);
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddMultiTargetEffect(SuppressionEffect);
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	
	Template.AdditionalAbilities.AddItem('AreaSuppressionShot_LW');
	Template.AdditionalAbilities.AddItem('LockdownBonuses');
	Template.AdditionalAbilities.AddItem('MayhemBonuses');

	Template.TargetingMethod = class'X2TargetingMethod_AreaSuppression';

	Template.BuildVisualizationFn = AreaSuppression_BuildVisualization_LW;
	Template.BuildAppliedVisualizationSyncFn = AreaSuppression_BuildVisualizationSync;
	Template.CinescriptCameraType = "StandardSuppression";	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

//Adds multitarget visualization
simulated function AreaSuppression_BuildVisualization_LW(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;
	local VisualizationActionMetadata   EmptyTrack;
	local VisualizationActionMetadata   BuildTrack;
	local XComGameState_Ability         Ability;
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	
	class'X2Action_ExitCover'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);
	class'X2Action_StartSuppression'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);
	
	//****************************************************************************************
	//Configure the visualization track for the primary target

	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);
	if (XComGameState_Unit(BuildTrack.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(BuildTrack.StateObject_NewState).ReserveActionPoints.Length == 0)
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
	}

	//Configure for the rest of the targets in AOE Suppression
	if (Context.InputContext.MultiTargets.Length > 0)
	{
		foreach Context.InputContext.MultiTargets(InteractingUnitRef)
		{
			Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
			BuildTrack = EmptyTrack;
			BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
			BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
			BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);
			if (XComGameState_Unit(BuildTrack.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(BuildTrack.StateObject_NewState).ReserveActionPoints.Length == 0)
			{
				SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
				SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
			}
		}
	}
}

simulated function AreaSuppression_BuildVisualizationSync(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack)
{
	local X2Action_ExitCover ExitCover;

	if (EffectName == class'X2Effect_AreaSuppression'.default.EffectName)
	{
		ExitCover = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree( BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded ));
		ExitCover.bIsForSuppression = true;

		class'X2Action_StartSuppression'.static.AddToVisualizationTree( BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded );
	}
}


static function X2AbilityTemplate AreaSuppressionShot_LW()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityTrigger_EventListener    Trigger;
	local X2Condition_UnitEffectsWithAbilitySource TargetEffectCondition;
	local X2Effect_RemoveAreaSuppressionEffect	RemoveAreaSuppression;
	local X2Effect                          ShotEffect;
	local X2AbilityCost_Ammo				AmmoCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AreaSuppressionShot_LW');

	Template.bDontDisplayInAbilitySummary = true;
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem('Suppression');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.AREA_SUPPRESSION_SHOT_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.BuiltInHitMod = default.AREA_SUPPRESSION_LW_SHOT_AIM_BONUS;
	StandardAim.bReactionFire = true;

	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	TargetEffectCondition.AddRequireEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsNotSuppressed');
	Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

	TargetVisibilityCondition = new class'X2Condition_Visibility';	
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.bAllowAmmoEffects = true;

	// this handles the logic for removing just from the target (if should continue), or removing from all targets if running out of ammo
	RemoveAreaSuppression = new class'X2Effect_RemoveAreaSuppressionEffect';
	RemoveAreaSuppression.EffectNamesToRemove.AddItem(class'X2Effect_AreaSuppression'.default.EffectName);
	RemoveAreaSuppression.bCheckSource =  true;
	RemoveAreaSuppression.SetupEffectOnShotContextResult(true, true);
	Template.AddTargetEffect(RemoveAreaSuppression);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	//don't want to exit cover, we are already in suppression/alert mode.
	Template.bSkipExitCoverWhenFiring = true;

	Template.bAllowFreeFireWeaponUpgrade = true;	
//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect();
	ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	Template.AddTargetEffect(ShotEffect);
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	ShotEffect = class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect();
	ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	Template.AddTargetEffect(ShotEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;	
}

static function X2Effect_Persistent CoveringFireMalusEffect()
{
	local X2Effect_PersistentStatChange Effect;
    local X2Condition_AbilityProperty AbilityCondition;

    Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_Offense, -default.COVERING_FIRE_OFFENSE_MALUS);
	Effect.BuildPersistentEffect(2, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, default.LocCoveringFire, default.LocCoveringFireMalus, "img:///UILibrary_PerkIcons.UIPerk_coverfire", true);
    Effect.bRemoveWhenTargetDies = false;
    Effect.bUseSourcePlayerState = true;
	Effect.bApplyOnMiss = true;
	Effect.DuplicateResponse=eDupe_Refresh;
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
    Effect.TargetConditions.AddItem(AbilityCondition);
    return Effect;
}

static function X2AbilityTemplate LockdownBonuses()
{
	local X2Effect_LockdownDamage			DamageEffect;
	local X2AbilityTemplate                 Template;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LockdownBonuses');
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bIsASuppressionEffect = true;
	//  Effect code checks whether unit has Lockdown before providing aim and damage bonuses
	DamageEffect = new class'X2Effect_LockdownDamage';
	DamageEffect.BuildPersistentEffect(1,true,false,false,eGameRule_PlayerTurnBegin);
	DamageEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	Template.AddTargetEffect(DamageEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate MayhemBonuses()
{
	local X2Effect_Mayhem					DamageEffect;
	local X2AbilityTemplate                 Template;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MayhemBonuses');
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bIsASuppressionEffect = true;
	//  Effect code checks whether unit has Mayhem before providing aim and damage bonuses
	DamageEffect = new class'X2Effect_Mayhem';
	DamageEffect.BuildPersistentEffect(1,true,false,false,eGameRule_PlayerTurnBegin);
	DamageEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	Template.AddTargetEffect(DamageEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate AddInterferenceAbility()
{
	local X2AbilityTemplate						Template;	
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2AbilityCharges_Interference         Charges;
	local X2AbilityCost_Charges                 ChargeCost;
	local X2Condition_Visibility                VisCondition;
	local X2Effect_Interference					ActionPointsEffect;
	local X2Condition_UnitActionPoints			ValidTargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Interference');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityInterference";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.bStationaryWeapon = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.bSkipPerkActivationActions = true;
	Template.bCrossClassEligible = false;

	Charges = new class 'X2AbilityCharges_Interference';
	Charges.CV_Charges = default.INTERFERENCE_CV_CHARGES;
	Charges.MG_Charges = default.INTERFERENCE_MG_CHARGES;
	Charges.BM_Charges = default.INTERFERENCE_BM_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.INTERFERENCE_ACTION_POINTS;
	ActionPointCost.bFreeCost = true;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisCondition);
	
	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(1,class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint,true,eCheck_GreaterThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ActionPointsEffect = new class'X2Effect_Interference';
	Template.AddTargetEffect (ActionPointsEffect);
	
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.CinescriptCameraType = "Specialist_CombatProtocol";
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddDamageControlAbilityPassive()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('DamageControlPassive', "img:///UILibrary_LW_PerkPack.LW_AbilityDamageControl", true, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	//Template.AdditionalAbilities.AddItem('DamageControlAbilityActivated');
	return Template;
}

static function X2AbilityTemplate AddDamageControlAbility()
{
	local X2AbilityTemplate						Template;	
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_DamageControl 				DamageControlEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DamageControl');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDamageControl";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	//Template.bIsPassive = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	DamageControlEffect = new class'X2Effect_DamageControl';
	DamageControlEffect.BuildPersistentEffect(default.DAMAGE_CONTROL_DURATION,false,true,,eGameRule_PlayerTurnBegin);
	DamageControlEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DamageControlEffect.DuplicateResponse = eDupe_Refresh;
	DamageControlEffect.EffectName = 'DamageControlTrigger';
	DamageControlEffect.BonusArmor = default.DAMAGE_CONTROL_BONUS_ARMOR;
	Template.AddTargetEffect(DamageControlEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('DamageControlPassive');

	return Template;
}


static function X2AbilityTemplate AddEvasiveAbility()
{
	local X2AbilityTemplate						Template;	
	local X2Effect_PersistentStatChange			DodgeBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Evasive');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityEvasive";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bCrossClassEligible = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	DodgeBonus = new class'X2Effect_PersistentStatChange';
	DodgeBonus.BuildPersistentEffect(1,true,true,false);
	DodgeBonus.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	DodgeBonus.AddPersistentStatChange (eStat_Dodge, float (100));
	DodgeBonus.EffectName='EvasiveEffect';
	Template.AddTargetEffect(DodgeBonus);

	Template.AdditionalAbilities.AddItem('RemoveEvasive');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;  

	Return Template;
}


static function X2AbilityTemplate RemoveEvasive()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_RemoveEffects				RemoveEffect;
	local X2Condition_UnitEffects				RequireEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RemoveEvasive');	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityEvasive";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	RequireEffect = new class'X2Condition_UnitEffects';
    RequireEffect.AddRequireEffect('EvasiveEffect', 'AA_EvasiveEffectPresent');
	Template.AbilityTargetConditions.AddItem(RequireEffect);

	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem('EvasiveEffect');
	Template.AddTargetEffect(RemoveEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Return Template;
}

static function X2AbilityTemplate AddCovertAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_PersistentStatChange		CovertEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Covert');	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCovert";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	CovertEffect = new class'X2Effect_PersistentStatChange';
	CovertEffect.BuildPersistentEffect(1,true,false);
	CovertEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	CovertEffect.AddPersistentStatChange(eStat_DetectionModifier, default.COVERT_DETECTION_RANGE_REDUCTION);
	Template.AddTargetEffect(CovertEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddGhostwalkerAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_PersistentStatChange		StealthyEffect;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_RequireConcealed		ConcealedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Ghostwalker');	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityGhostwalker";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bCrossClassEligible = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.ActivationSpeech = 'ActivateConcealment';
	
	ConcealedCondition = new class'X2Condition_RequireConcealed';
	Template.AbilityTargetConditions.AddItem(ConcealedCondition);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.GHOSTWALKER_COOLDOWN;
    Template.AbilityCooldown = Cooldown; 
	
	StealthyEffect = new class'X2Effect_PersistentStatChange';
	StealthyEffect.BuildPersistentEffect(default.GHOSTWALKER_DURATION,false,true,false,eGameRule_PlayerTurnBegin);
	StealthyEffect.SetDisplayInfo (ePerkBuff_Bonus,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	StealthyEffect.AddPersistentStatChange(eStat_DetectionModifier, default.GHOSTWALKER_DETECTION_RANGE_REDUCTION);
	Template.AddTargetEffect(StealthyEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// Kubikiri
static function X2AbilityTemplate AddKubikuriAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2Condition_Visibility			VisibilityCondition;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_UnitStatCheck			TargetHPCondition;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Kubikuri');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityKubikuri";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bCrossClassEligible = false;
	Template.bUsesFiringCamera = true;
	Template.bPreventsTargetTeleport = false;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AddShooterEffectExclusions();
	Template.ActivationSpeech = 'Reaper';

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.KUBIKURI_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	TargetHPCondition = new class 'X2Condition_UnitStatCheck';
	TargetHPCondition.AddCheckStat(eStat_HP,default.KUBIKURI_MAX_HP_PCT,eCheck_LessThanOrEqual,,,true);
	Template.AbilityTargetConditions.AddItem(TargetHPCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.KUBIKURI_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.KUBIKURI_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.AdditionalAbilities.AddItem('KubikuriDamage');
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate KubikiriDamage()
{
	local X2Effect_Kubikuri					DamageEffect;
	local X2AbilityTemplate					Template;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'KubikuriDamage');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityKubikuri";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = 2;
    Template.Hostility = 2;
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	DamageEffect=new class'X2Effect_Kubikuri';
    DamageEffect.BuildPersistentEffect(1, true, false, false);
    DamageEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
    Template.AddTargetEffect(DamageEffect);
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    return Template;
}

static function X2AbilityTemplate AddCombatAwarenessAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_CombatAwareness			DefenseEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'CombatAwareness');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityThreatAssesment";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;

	DefenseEffect = new class'X2Effect_CombatAwareness';
	DefenseEffect.BuildPersistentEffect(1,true,false);
	DefenseEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	Template.AddTargetEffect(DefenseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;		
	return Template;
}

static function X2AbilityTemplate AddCombatRushAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_KilledEnemy				CombatRushEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'CombatRush');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAdrenalNeurosympathy";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bSkipFireAction = true;
	Template.bShowActivation = false;
	Template.bCrossClassEligible = false;

	//Effect serves to fire a custom event and that's it
	CombatRushEffect = new class'X2Effect_KilledEnemy';
	CombatRushEffect.eventid = 'CombatRush';
	CombatRushEffect.BShowActivation = false;
	CombatRushEffect.BuildPersistentEffect(1,true,false);
	CombatRushEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	Template.AddTargetEffect(CombatRushEffect);

	Template.AdditionalAbilities.AddItem('BroadcastCombatRush');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;		
	return Template;
}


static function X2AbilityTemplate BroadcastCombatRush()
{
	local X2AbilityTemplate					Template;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Condition_UnitProperty			AllyCondition;
	local X2AbilityCooldown					Cooldown;	
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Effect_PersistentStatChange		CombatRushBonuses;
	
	`CREATE_X2ABILITY_TEMPLATE (Template, 'BroadcastCombatRush');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAdrenalNeurosympathy";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	
	//Cooldowns work on passives
	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.COMBAT_RUSH_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.NumTargetsRequired = 1; 
	RadiusMultiTarget.bIgnoreBlockingCover = true; 
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = false; 
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	RadiusMultiTarget.bUseWeaponRadius = false; 
	RadiusMultiTarget.ftargetradius = default.COMBAT_RUSH_RADIUS * 1.5; 
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	
	AllyCondition = new class'X2Condition_UnitProperty';
	AllyCondition.RequireSquadmates = true;
	AllyCondition.ExcludeAlien = true;
	AllyCondition.ExcludeRobotic = true;
	AllyCondition.ExcludeHostileToSource = true;
	AllyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(AllyCondition);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'CombatRush';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	CombatRushBonuses = new class 'X2Effect_PersistentStatChange';
	CombatRushBonuses.AddPersistentStatChange (eStat_Offense, float(default.COMBAT_RUSH_AIM_BONUS));
	CombatRushBonuses.AddPersistentStatChange (eStat_CritChance, float(default.COMBAT_RUSH_CRIT_BONUS));
	CombatRushBonuses.AddPersistentStatChange (eStat_Mobility, float(default.COMBAT_RUSH_MOBILITY_BONUS));
	CombatRushBonuses.AddPersistentStatChange (eStat_Defense, float(default.COMBAT_RUSH_DEFENSE_BONUS));
	CombatRushBonuses.AddPersistentStatChange (eStat_Dodge, float(default.COMBAT_RUSH_DODGE_BONUS));
	CombatRushBonuses.BuildPersistentEffect(default.COMBAT_RUSH_DURATION,false,true,false,eGameRule_PlayerTurnEnd);
	CombatRushBonuses.SetDisplayInfo (ePerkBuff_Bonus,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	CombatRushBonuses.DuplicateResponse = eDupe_Refresh;
	Template.AddMultiTargetEffect(CombatRushBonuses);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = CombatRush_BuildVisualization;
	return Template;
}

function CombatRush_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack, TargetTrack;
    local X2Action_PlayAnimation			PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyoverTarget;
	local XComGameState_Ability				Ability;
	local XComGameState_Effect				EffectState;
	local XComGameState_Unit				UnitState;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    	
	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_SignalAngryA';
	PlayAnimationAction.bFinishAnimationWait = true;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'BroadcastCombatRush')
		{
			TargetTrack = EmptyTrack;
			UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			if (UnitState != none && EffectState.StatChanges.Length > 0 && InteractingUnitRef.ObjectID != UnitState.ObjectID)
			{
				TargetTrack.StateObject_NewState = UnitState;
				TargetTrack.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
				TargetTrack.VisualizeActor = UnitState.GetVisualizer();
				SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
				SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Good);
			}
		}
	}
}


static function X2AbilityTemplate AddGrazingFireAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_GrazingFire				GrazingEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'GrazingFire');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityGrazingFire";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bCrossClassEligible = true;
	GrazingEffect = new class'X2Effect_GrazingFire';
	GrazingEffect.SuccessChance = default.GRAZING_FIRE_SUCCESS_CHANCE;
	GrazingEffect.BuildPersistentEffect (1, true, false);
	GrazingEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	Template.AddTargetEffect(GrazingEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	return Template;
}

//Boosted Cores
static function X2AbilityTemplate AddHeavyFragsAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_GrenadeDamage			DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'HeavyFrags');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityHeavyFrags";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;

	DamageEffect = new class'X2Effect_GrenadeDamage';
	DamageEffect.BuildPersistentEffect(1, true, false);
	DamageEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	DamageEffect.BonusDamage = default.HEAVY_FRAGS_DAMAGE;
	DamageEffect.ApplyToNonBaseDamage = true;   // Apply to tick effects like poison and burning a la LW2
	Template.AddTargetEFfect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//This is "Trench Gun" in the loc
static function X2AbilityTemplate AddStreetSweeperAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitInventory			InventoryCondition;
	local X2Effect_Shredder					WeaponDamageEffect;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'StreetSweeper');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityStreetSweeper";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	
	Template.bAllowAmmoEffects = true;

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.STREET_SWEEPER_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.STREET_SWEEPER_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.STREET_SWEEPER_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.RequireWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	Template.AddShooterEffectExclusions();
	
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = false; 
	StandardAim.bGuaranteedHit = false;
	StandardAim.bOnlyMultiHitWithSuccess = false;
	StandardAim.bAllowCrit = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.bOverrideAim = false;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;	

	WeaponDamageEffect = new class'X2Effect_Shredder';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.bFragileDamageOnly = true;
	Template.bCheckCollision = true;

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.STREET_SWEEPER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bUseWeaponRangeForLength = false;
	ConeMultiTarget.ConeLength=default.STREET_SWEEPER_CONE_LENGTH;
	ConeMultiTarget.fTargetRadius = 99;     //  large number to handle weapon range - targets will get filtered according to cone constraints
	ConeMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}


static function X2AbilityTemplate AddIronCurtainAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_IronCurtain				WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'IronCurtain');	
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityIronCurtain";	
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bShowActivation = false;
	WeaponDamageEffect = new class'X2Effect_IronCurtain';
	WeaponDamageEffect.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(WeaponDamageEffect);	
	Template.AdditionalAbilities.AddItem('IronCurtainShot');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}	

static function X2AbilityTemplate IronCurtainShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Condition_UnitInventory			InventoryCondition, InventoryCondition2;
	local X2Effect_PersistentStatChange		MobilityDamageEffect;
	local X2Effect_Shredder					RegularDamage;
	local X2Effect_IronCurtainStatDamage	MobilityDamageAlert;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'IronCurtainShot');	

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityIronCurtain";
    Template.ActivationSpeech = 'SaturationFire';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Offensive;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	Template.AddShooterEffectExclusions();

	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.IRON_CURTAIN_MIN_ACTION_REQ;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.IRON_CURTAIN_AMMO_COST;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.IRON_CURTAIN_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = false; 
	StandardAim.bGuaranteedHit = false;
	StandardAim.bOnlyMultiHitWithSuccess = false; 
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;
	Template.bOverrideAim = false;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange=true;
	Template.AbilityTargetStyle = CursorTarget;
	Template.bFragileDamageOnly = false;
	Template.bCheckCollision = true; 
	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.IRON_CURTAIN_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bUseWeaponRangeForLength = true;
	ConeMultiTarget.fTargetRadius = 99;     //  large number to handle weapon range - targets will get filtered according to cone constraints
	ConeMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AddShooterEffectExclusions();
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.ExcludeWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	InventoryCondition2 = new class'X2Condition_UnitInventory';
	InventoryCondition2.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition2.ExcludeWeaponCategory = 'sniper_rifle';
	Template.AbilityShooterConditions.AddItem(InventoryCondition2);

	RegularDamage = new class'X2Effect_Shredder';
	RegularDamage.bApplyOnHit = true;
	RegularDamage.bApplyOnMiss = false;
	RegularDamage.bIgnoreBaseDamage = false;
	Template.AddTargetEffect(RegularDamage);
	Template.AddMultiTargetEffect(RegularDamage);
	
	MobilityDamageEffect = new class 'X2Effect_PersistentStatChange';
	MobilityDamageEffect.BuildPersistentEffect (default.IRON_CURTAIN_MOB_DAMAGE_DURATION, false, false, false, eGameRule_PlayerTurnEnd);
	MobilityDamageEffect.SetDisplayInfo(ePerkBuff_Penalty,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	MobilityDamageEffect.AddPersistentStatChange (eStat_Mobility, -default.IRON_CURTAIN_MOBILITY_DAMAGE);
	MobilityDamageEffect.DuplicateResponse = eDupe_Allow;
	MobilityDamageEffect.EffectName = 'IronCurtainEffect';
	Template.AddTargetEffect(MobilityDamageEffect);
	Template.AddMultiTargetEffect(MobilityDamageEffect);

	MobilityDamageAlert = new class 'X2Effect_IronCurtainStatDamage';
	Template.AddTargetEffect (MobilityDamageAlert);
	Template.AddMultiTargetEffect (MobilityDamageAlert);

	Template.CinescriptCameraType = "StandardGunFiring";
	Template.bUsesFiringCamera = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddSlash_LWAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Slash_LW');

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
	
	if (!default.NO_MELEE_ATTACKS_WHEN_ON_FIRE)
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

	Template.ConcealmentRule = eConceal_Always;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddAbsorptionFieldsAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_AbsorptionFields			AbsorptionFieldsEffect;
	local array<name>                       SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'AbsorptionFields');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAbsorptionFields";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;

	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.DisplayTargetHitChance = false;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.ABSORPTION_FIELDS_ACTION_POINTS;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ABSORPTION_FIELDS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
	
	// Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);

	AbsorptionFieldsEffect = new class'X2Effect_AbsorptionFields';
	AbsorptionFieldsEffect.BuildPersistentEffect(default.ABSORPTION_FIELDS_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	AbsorptionFieldsEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	AbsorptionFieldsEffect.EffectName='AbsorptionFields';
	Template.AddTargetEffect(AbsorptionFieldsEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddBodyShieldAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_BodyShield				BodyShieldEffect;
	local X2Condition_UnitProperty UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'BodyShield');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBodyShield";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.DisplayTargetHitChance = false;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BODY_SHIELD_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	BodyShieldEffect = new class'X2Effect_BodyShield';
	BodyShieldEffect.BodyShieldDefBonus = default.BODY_SHIELD_DEF_BONUS;
	BodyShieldEffect.BodyShieldCritMalus = default.BODY_SHIELD_ENEMY_CRIT_MALUS;
	BodyShieldEffect.BuildPersistentEffect(default.BODY_SHIELD_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	BodyShieldEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	BodyShieldEffect.EffectName='BodyShield';
	Template.AddTargetEffect(BodyShieldEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddEmergencyLifeSupportAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_EmergencyLifeSupport		LifeSupportEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'EmergencyLifeSupport');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityEmergencyLifeSupport";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	LifeSupportEffect = new class'X2Effect_EmergencyLifeSupport';
	LifeSupportEffect.BuildPersistentEffect(1, true, false);
	LifeSupportEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(LifeSupportEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	return Template;
}

static function X2AbilityTemplate AddIronSkinAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_MeleeDamageAdjust_LW		IronSkinEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'IronSkin');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityIronSkin";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.DisplayTargetHitChance = false;
	
	IronSkinEffect = new class'X2Effect_MeleeDamageAdjust_LW';
	IronSkinEffect.BuildPersistentEffect(1, true, false, true);
	IronSkinEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	IronSkinEffect.DamageMod=-default.IRON_SKIN_MELEE_DAMAGE_REDUCTION;
	Template.AddTargetEffect(IronSkinEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	

	return Template;
}

static function X2AbilityTemplate AddSmartMacrophagesAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_DamageImmunity			DamageImmunity;
	local X2Effect_SmartMacrophages			MacrophagesEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'SmartMacrophages');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySmartMacrophages";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;

	MacrophagesEffect = new class'X2Effect_SmartMacrophages';
	MacrophagesEffect.BuildPersistentEffect(1, true, false);
	MacrophagesEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(MacrophagesEffect);

	DamageImmunity = new class'X2Effect_DamageImmunity'; 
	DamageImmunity.ImmuneTypes.AddItem('Acid');
	DamageImmunity.ImmuneTypes.AddItem('Poison');
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType); //this is chryssalid poison, special because it spawns cocoons
	DamageImmunity.BuildPersistentEffect(1, true, false, true);
	Template.AddTargetEffect(DamageImmunity);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddMindMergeAbility()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown_MindMerge	Cooldown;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty		TargetCondition;
	local X2Effect_MindMerge			MindMergeEffect;	
	local X2Condition_UnitEffects		MMCondition;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'MindMerge');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityMindMerge";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.Hostility = eHostility_Neutral;
	Template.ShotHUDPriority = 320;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;

	TargetCondition = new class'X2Condition_UnitProperty';
    TargetCondition.ExcludeHostileToSource = true;
    TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.TreatMindControlledSquadmateAsHostile = true;
    TargetCondition.RequireSquadmates = true;
    TargetCondition.FailOnNonUnits = true;
    TargetCondition.ExcludeDead = true;
    TargetCondition.ExcludeRobotic = true;
    Template.AbilityTargetConditions.AddItem(TargetCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.MIND_MERGE_MIN_ACTION_POINTS;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_MindMerge';
	Cooldown.MIND_MERGE_COOLDOWN = default.MIND_MERGE_COOLDOWN;
	Cooldown.SOUL_MERGE_COOLDOWN_REDUCTION = default.SOUL_MERGE_COOLDOWN_REDUCTION;
	Template.AbilityCooldown = Cooldown;

	MMCondition = new class'X2Condition_UnitEffects';
	MMCondition.AddExcludeEffect('MindMergeEffect', 'AA_UnitIsMindMerged');
	Template.AbilityTargetConditions.AddItem(MMCondition);

	MindMergeEffect = new class 'X2Effect_MindMerge';
	MindMergeEffect.EffectName = 'MindMergeEffect';
	MindMergeEffect.BaseWillIncrease = 0;
	MindMergeEffect.BaseShieldHPIncrease = 1;
	MindMergeEffect.MindMergeWillDivisor = default.MIND_MERGE_WILL_DIVISOR;
	MindMergeEffect.MindMergeShieldHPDivisor = default.MIND_MERGE_SHIELDHP_DIVISOR;
	MindMergeEffect.SoulMergeWillDivisor = default.SOUL_MERGE_WILL_DIVISOR;
	MindMergeEffect.SoulMergeShieldHPDivisor = default.SOUL_MERGE_SHIELDHP_DIVISOR;
	MindMergeEffect.AmpMGWillBonus = default.MIND_MERGE_AMP_MG_WILL_BONUS;
	MindMergeEffect.AmpMGShieldHPBonus = default.MIND_MERGE_AMP_MG_SHIELDHP_BONUS;
	MindMergeEffect.AmpBMWillBonus = default.MIND_MERGE_AMP_BM_WILL_BONUS;
	MindMergeEffect.AmpBMShieldHPBonus = default.MIND_MERGE_AMP_BM_SHIELDHP_BONUS;
	MindMergeEffect.MindMergeCritDivisor= default.MIND_MERGE_CRIT_DIVISOR;
	MindMergeEffect.SoulMergeCritDivisor= default.SOUL_MERGE_CRIT_DIVISOR;
	MindMergeEffect.AmpMGCritBonus= default.MIND_MERGE_AMP_MG_CRIT_BONUS;
	MindMergeEffect.AMpBMCritBonus= default.SOUL_MERGE_AMP_BM_CRIT_BONUS;

	MindMergeEffect.bRemoveWhenTargetDies=true;
	MindMergeEffect.BuildPersistentEffect (1, false, true, false, eGameRule_PlayerTurnBegin);
	MindMergeEFfect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect (MindMergeEffect);

	Template.AssociatedPassives.AddItem('SoulMerge');

	Template.ActivationSpeech = 'PsionicsInspiration';
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.CustomFireAnim = 'HL_Psi_ProjectileMerge';
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate AddSoulMergeAbility()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('SoulMerge', "img:///UILibrary_LW_PerkPack.LW_AbilitySoulMerge", false, 'eAbilitySource_Psionic');
	Template.PrerequisiteAbilities.AddItem('MindMerge');
	return Template;
}

static function X2AbilityTemplate AddShadowstrike_LWAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ToHitModifier                Effect;
	local X2Condition_Visibility                VisCondition;
	local X2Condition_UnitProperty				StealthCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Shadowstrike_LW');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shadowstrike";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_ToHitModifier';
	Effect.EffectName = 'Shadowstrike';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Effect.AddEffectHitModifier(eHit_Success, class'X2Ability_RangerAbilitySet'.default.SHADOWSTRIKE_AIM, Template.LocFriendlyName);
	Effect.AddEffectHitModifier(eHit_Crit, class'X2Ability_RangerAbilitySet'.default.SHADOWSTRIKE_CRIT, Template.LocFriendlyName);
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bExcludeGameplayVisible = true;
	Effect.ToHitConditions.AddItem(VisCondition);
	StealthCondition = new class 'X2Condition_UnitProperty';
	StealthCondition.IsConcealed = true;
	Effect.ToHitConditions.AddItem(StealthCondition);

	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddFormidableAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_Formidable	                PaddingEffect;
	local X2EFfect_PersistentStatChange			HPEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Formidable');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_extrapadding";

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	PaddingEffect = new class'X2Effect_Formidable';
	PaddingEffect.ExplosiveDamageReduction = default.FORMIDABLE_EXPLOSIVES_DR;
	PaddingEffect.Armor_Mitigation = default.FORMIDABLE_ARMOR_MITIGATION;
	PaddingEffect.BuildPersistentEffect(1, true, false);
	PaddingEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(PaddingEffect);

	HPEFfect = new class'X2Effect_PersistentStatChange';
	HPEffect.BuildPersistentEffect(1, true, false);
	HPEffect.AddPersistentStatChange(eStat_ShieldHP, default.FORMIDABLE_ABLATIVE_HP);
	Template.AddTargetEFfect(HPEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = true;

	if (default.FORMIDABLE_ARMOR_MITIGATION > 0)
	{
		Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, PaddingEffect.ARMOR_MITIGATION);
	}

	return Template;
}


static function X2AbilityTemplate AddSoulStealTriggered2()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    EventListener;
	local X2Condition_UnitProperty          ShooterProperty;
	local X2Condition_UnitStatCheck			ShooterProperty3;
	local X2Effect_SoulSteal_LW             StealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SoulStealTriggered2');

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_soulsteal";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';

	ShooterProperty = new class'X2Condition_UnitProperty';
	ShooterProperty.ExcludeAlive = false;
	ShooterProperty.ExcludeDead = true;
	ShooterProperty.ExcludeFriendlyToSource = false;
	ShooterProperty.ExcludeHostileToSource = true;
	ShooterProperty.ExcludeFullHealth = false;
	Template.AbilityShooterConditions.AddItem(ShooterProperty);

	//ShooterProperty2 = new class'X2Condition_UnitStatCheck';
	//ShooterProperty2.AddCheckStat(eStat_HP, 100, eCheck_Exact,,, true);
	//Template.AbilityShooterConditions.AddItem(ShooterProperty2);

	ShooterProperty3 = new class'X2Condition_UnitStatCheck';
	ShooterProperty3.AddCheckStat(eStat_ShieldHP, default.MAX_ABLATIVE_FROM_SOULSTEAL, eCheck_LessThan);
	Template.AbilityShooterConditions.AddItem(ShooterProperty3);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.SoulStealListener;
	EventListener.ListenerData.EventID = class'X2Ability_PsiOperativeAbilitySet'.default.SoulStealEventName;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	StealEffect = new class'X2Effect_SoulSteal_LW';
	StealEffect.BuildPersistentEffect(3, false, true, false, eGameRule_PlayerTurnBegin);
	StealEffect.SetDisplayInfo (ePerkBuff_Bonus, default.LocSoulStealBuff, default.LocSoulStealBuffHelpText, Template.IconImage,,, Template.AbilitySourceName);
	StealEffect.SoulStealM1Shield = default.SOULSTEAL_M1_SHIELD;
	StealEffect.SoulStealM2Shield = default.SOULSTEAL_M2_SHIELD;
	StealEffect.SoulStealM3Shield = default.SOULSTEAL_M3_SHIELD;
	StealEffect.EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization;
	Template.AddShooterEffect(StealEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.bShowActivation = false;
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = '';
	//Template.ActionFireClass = class'X2Action_Fire_AdditiveAnim';

	return Template;
}


simulated function OnShieldRemoved_BuildVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	if (XGUnit(ActionMetadata.VisualizeActor).IsAlive())
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'XLocalizedData'.default.ShieldRemovedMsg, '', eColor_Bad, , 0.75, true);
	}
}

// WOTC: This stuff was in XComGameState_Ability under XComGame, but I don't see why it should
// be part of the highlander.
static function EventListenerReturn RapidFireListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Ability Ability;
	local XComGameStateContext_Ability AbilityContext;

	Ability = XComGameState_Ability(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	`Log("RapidFireListener: Trying to convert EventSource to Ability. Result = " $ Ability);
	if (AbilityContext != none && Ability != none)
	{
		AbilityTriggerAgainstSingleTarget(Ability.ObjectID, Ability.OwnerStateObject, AbilityContext.InputContext.PrimaryTarget, false);
	}
	return ELR_NoInterrupt;
}

static function bool AbilityTriggerAgainstSingleTarget(int AbilityID, StateObjectReference SourceRef, StateObjectReference TargetRef, bool bMustHaveAdditionalTargets, optional int VisualizeIndex = -1, optional array<vector> TargetLocations)
{
	local GameRulesCache_Unit UnitCache;
	local int i, j;
	local X2TacticalGameRuleset TacticalRules;
	local AvailableTarget AvailTarget;

	TacticalRules = `TACTICALRULES;

	if (TacticalRules.GetGameRulesCache_Unit(SourceRef, UnitCache))
	{
		for (i = 0; i < UnitCache.AvailableActions.Length; ++i)
		{
			if (UnitCache.AvailableActions[i].AbilityObjectRef.ObjectID == AbilityID)
			{
				for (j = 0; j < UnitCache.AvailableActions[i].AvailableTargets.Length; ++j)
				{
					AvailTarget = UnitCache.AvailableActions[i].AvailableTargets[j];
					if (AvailTarget.PrimaryTarget.ObjectID == TargetRef.ObjectID)
					{
						if (UnitCache.AvailableActions[i].AvailableCode == 'AA_Success')
						{
							if (bMustHaveAdditionalTargets ? AvailTarget.AdditionalTargets.Length > 0 : true)
							{
								class'XComGameStateContext_Ability'.static.ActivateAbility(UnitCache.AvailableActions[i], j, TargetLocations,,,, VisualizeIndex);

								return true;
							}
						}
						break;
					}
				}
				break;
			}
		}
	}
	return false;
}
