//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_XMBPerkAbilitySet
//  AUTHOR:  Grobobobo
//  PURPOSE: File that creates new ability templates which use XMB tools.
//--------------------------------------------------------------------------------------- 
class X2Ability_XMBPerkAbilitySet extends XMBAbility config(LW_SoldierSkills);

var config int RAPID_STUN_COOLDOWN;

var config int THATS_CLOSE_ENOUGH_TILE_RANGE;
var config int THATS_CLOSE_ENOUGH_COOLDOWN;
var config int THATS_CLOSE_ENOUGH_PER_TARGET_COOLDOWN;

var config int SPARE_BATTERY_COOLDOWN;
var config int SPARE_BATTERY_ACTION_POINT_COST;

var config int NONE_SHALL_PASS_TILE_RANGE;
var config int NONE_SHALL_PASS_COOLDOWN;

var config float BRUTALITY_TILE_RADIUS;
var config int BRUTALITY_PANIC_CHANCE;

var config int OverkillBonusDamage;

var config int SurvivalInstinctCritBonus;
var config int SurvivalInstinctDefenseBonus;
var config int STILETTO_ARMOR_PIERCING;

var config int WATCHTHEMRUN_ACTIVATIONS_PER_TURN;

var config int PREDATOR_AIM_BONUS;
var config int PREDATOR_CRIT_BONUS;

var config int OPENFIRE_AIM;
var config int OPENFIRE_CRIT;

var config int AVENGER_RADIUS;

var config int DEDICATION_MOBILITY;

var config int IMPULSE_AIM_BONUS;
var config int IMPULSE_CRIT_BONUS;

var config int LICKYOURWOUNDS_HEALAMOUNT;
var config int LICKYOURWOUNDS_MAXHEALAMOUNT;

var config int PRESERVATION_DEFENSE_BONUS;
var config int PRESERVATION_DURATION;

var config int INSPIRE_DODGE;

var config int LIGHTNINGSLASH_COOLDOWN;

var config int LEAD_TARGET_COOLDOWN;

var config int DEDICATION_COOLDOWN;

var config int LOCKNLOAD_AMMO_TO_RELOAD;

var name ZONE_CONTROL_RADIUS_NAME;

var config int LEAD_TARGET_AIM_BONUS;

var config float BLIND_PROTOCOL_RADIUS_T1_BASE;
var config float BLIND_PROTOCOL_RADIUS_T2_BONUS;
var config float BLIND_PROTOCOL_RADIUS_T3_BONUS;
var config int BLINDING_PROTOCOL_COOLDOWN;

var config int ZONE_CONTROL_MOBILITY_PENALTY;
var config int ZONE_CONTROL_AIM_PENALTY;
var config float ZONE_CONTROL_RADIUS_SQ;

var config int AIM_ASSIST_AIM_BONUS;
var config int AIM_ASSIST_CRIT_BONUS;

var config int TARGET_FOCUS_PIERCE;
var config int TARGET_FOCUS_AIM_BONUS;

var config int SS_PIERCE;

var config int SS_AIM_BONUS;

var config float WEAPONHANDLING_MULTIPLIER;

var config float APEX_PREDATOR_PANIC_RADIUS;
var config int APEX_PREDATOR_BASE_PANIC_CHANCE;

var config int DISSASSEMBLY_HACK;

var config int SUPERCHARGE_CHARGES;
var config int SUPERCHARGE_HEAL;

var config int MAIM_AMMO_COST;
var config int MAIM_COOLDOWN;

var config int SCRAP_METAL_AMMO_AMOUNT;

var config int MOVING_TARGET_DEFENSE;
var config int MOVING_TARGET_DODGE;

var config int COMBATREADINESS_DEF;
var config int COMBATREADINESS_AIM;

var config int XCOM_BLOOD_THIRST_DURATION;

var config array<name> AgentsHealEffectTypes;    

var string Dissassemblybonustext;
var name LeadTheTargetReserveActionName;
var name LeadTheTargetMarkEffectName;

var config int FATALITY_AIM;
var config int FATALITY_CRIT;
var config float FATALITY_THRESHOLD;

var const name QuickZapEffectName;
var const name VampUnitValue;
var const string CombatReadinessBonusText;

var config int CRUSADER_WOUND_HP_REDUCTTION;

var config array<name> COMBAT_READINESS_EFFECTS_TO_REMOVE;
var config array<name> BANZAI_EFFECTS_TO_REMOVE;

var config int QUICKDRAW_MOBILITY_INCREASE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
    Templates.AddItem(RapidStun());
	Templates.AddItem(ThatsCloseEnough());
	Templates.AddItem(Hipfire());	
	Templates.Additem(SawedOffOverwatch());
	Templates.Additem(ScrapMetal());
	Templates.Additem(ScrapMetalTrigger());
	Templates.Additem(Brutality());
    Templates.Additem(Ruthless());
    
	Templates.AddItem(LeadTheTarget_LW());
	Templates.AddItem(LeadTheTargetShot_LW());
	Templates.AddItem(BlindingProtocol_LW());
	Templates.AddItem(ApexPredator_LW());
	Templates.AddItem(ApexPredatorPanic_LW());
	Templates.AddItem(NeutralizingAgents());
	Templates.AddItem(ZoneOfControl_LW());
	Templates.AddItem(AddZoCPassive());
	Templates.AddItem(AddZoCCleanse());

	
	Templates.AddItem(Concentration());
	Templates.AddItem(LikeLightning());
	Templates.AddItem(Preservation());
	Templates.AddItem(LockNLoad());
	Templates.AddItem(TrenchWarfare());
	Templates.AddItem(Dedication());
	Templates.AddItem(WatchThemRun());
    Templates.AddItem(Avenger());
	Templates.AddItem(Predator());
	Templates.AddItem(Stiletto());
    Templates.AddItem(OpenFire());
	Templates.AddItem(Impulse());
	Templates.AddItem(Maim());
	Templates.AddItem(SurvivalInstinct());
	Templates.AddItem(Reposition());
	Templates.AddItem(Overkill());
	Templates.AddItem(LickYourWounds());

	Templates.AddItem(UnlimitedPower());
	Templates.AddItem(SuperCharge());
	Templates.AddItem(Disassembly());
	Templates.AddItem(DisassemblyPassive());
	Templates.AddItem(ShootingSharp());
	Templates.AddItem(WeaponHandling());
	Templates.AddItem(AimingAssist());
	Templates.AddItem(TargetFocus());
	

	Templates.AddItem(LightningSlash());
	Templates.AddItem(InspireAgility());
	Templates.AddItem(InspireAgilityTrigger());
	Templates.AddItem(PrimaryReturnFire());
	Templates.AddItem(PrimaryReturnFireShot());
	Templates.AddItem(DeadeyeSnapshotAbility());
	Templates.AddItem(DeadeyeSnapShotDamage());

	Templates.AddItem(PsychoticRage());
	Templates.AddItem(PreciseStrike());
	Templates.AddItem(YouCannotHide());

	Templates.AddItem(HunterMark());
	Templates.AddItem(HunterMarkHit());
	Templates.AddItem(OverbearingSuperiority());
	Templates.AddItem(CreateXCOMBloodThirst());
	Templates.AddItem(XCOMBloodThirstPassive());
	Templates.AddItem(Fatality());
	Templates.AddItem(Vampirism());
	Templates.AddItem(VampirismPassive());
	
	Templates.AddItem(ComplexReload());

	Templates.AddItem(AddBrawler());
	Templates.AddItem(AddInstantReactionTime());
	Templates.AddItem(MovingTarget());

	Templates.AddItem(AddCombatReadiness());
	Templates.AddItem(CombatReadinessPassive());

	Templates.AddItem(AddBanzai());
	Templates.AddItem(BanzaiPassive());
	Templates.AddItem(Magnum());
	Templates.AddItem(CrusaderRage());
	Templates.AddItem(QuickdrawMobility());


	
	
	return Templates;
}

// Quick Zap - Next Arcthrower action is free
static function X2AbilityTemplate RapidStun()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AbilityCostRefund Effect;
	local X2Condition_ArcthrowerAbilities_LW Condition;

	// Create effect that will refund actions points
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = default.QuickZapEffectName;
	Effect.TriggeredEvent = 'QuickZap_LW';
	Effect.bShowFlyOver = true;
	Effect.CountValueName = 'QuickZap_LW_Uses';
	Effect.MaxRefundsPerTurn = 1;
	Effect.bFreeCost = true;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);

	// Action points are only refunded if using a support grenade (or battlescanner)
	Condition = new class'X2Condition_ArcthrowerAbilities_LW';
	Effect.AbilityTargetConditions.AddItem(Condition);

	// Show a flyover over the target unit when the effect is added
	Effect.VisualizationFn = EffectFlyOver_Visualization;

	// Create activated ability that adds the refund effect
	Template = SelfTargetActivated('QuickZap_LW', "img:///BstarsPerkPack_Icons.UIPerk_RapidStun", true, Effect,, eCost_Free);
	AddCooldown(Template, default.RAPID_STUN_COOLDOWN);

	// Cannot be used while burning, etc.
	Template.AddShooterEffectExclusions();

	return Template;
}

static function X2AbilityTemplate ThatsCloseEnough()
{
	local X2AbilityTemplate Template;
	local X2AbilityToHitCalc_StandardAim ToHit;
	local X2Effect StunnedEffect;
	local X2AbilityCooldown_Shared Cooldown;
	// Create a stun effect that removes 2 actions and has a 100% chance of success if the attack hits.
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);

	Template = Attack('ThatsCloseEnough_LW', "img:///Texture2D'BstarsPerkPack_Icons.UIPerk_ThatsCloseEnough'", false, StunnedEffect, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_None);
	
	HidePerkIcon(Template);
	AddIconPassive(Template);

	ToHit = new class'X2AbilityToHitCalc_StandardAim';
	ToHit.bReactionFire = true;
	Template.AbilityToHitCalc = ToHit;
	Template.AbilityTriggers.Length = 0;
	AddMovementTrigger(Template);
	Template.AbilityTargetConditions.AddItem(TargetWithinTiles(default.THATS_CLOSE_ENOUGH_TILE_RANGE));
	AddPerTargetCooldown(Template, default.THATS_CLOSE_ENOUGH_PER_TARGET_COOLDOWN);

	Cooldown = new class'X2AbilityCooldown_Shared';
	Cooldown.iNumTurns = default.THATS_CLOSE_ENOUGH_COOLDOWN;
	Cooldown.SharingCooldownsWith.AddItem('ArcThrowerStun'); //Now shares the cooldown with Arc thrower main ability
	Template.AbilityCooldown = Cooldown;
	
	return Template;
}

static function X2AbilityTemplate SawedOffOverwatch()
{
	local X2AbilityTemplate 				Template;
	local X2AbilityToHitCalc_StandardAim 	ToHit;

	Template = Attack('NoneShallPass_LW', "img:///'BstarsPerkPack_Icons.UIPerk_SawedOffOverwatch'", false, none, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_None);
	
	HidePerkIcon(Template);
	AddIconPassive(Template);

	ToHit = new class'X2AbilityToHitCalc_StandardAim';
	Template.bAllowAmmoEffects = true; 
	ToHit.bReactionFire = true;
	ToHit.bAllowCrit = true;
	Template.AbilityToHitCalc = ToHit;
	Template.AbilityTriggers.Length = 0;
	AddMovementTrigger(Template);
	Template.AbilityTargetConditions.AddItem(TargetWithinTiles(default.NONE_SHALL_PASS_TILE_RANGE));
	AddCooldown(Template, default.NONE_SHALL_PASS_COOLDOWN);

	return Template;
}

static function X2AbilityTemplate Hipfire()
{
	local X2AbilityTemplate		Template;
	
	Template = PurePassive('Hipfire_LW', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_strike", false, 'eAbilitySource_Perk', true);


	return Template;
}

static function X2AbilityTemplate ScrapMetal()
{
	local X2AbilityTemplate 			Template;
		
	Template = PurePassive('ScrapMetal_LW', "img:///'BstarsPerkPack_Icons.UIPerk_ScrapMetal'", false, 'eAbilitySource_Perk', true);
	Template.AdditionalAbilities.AddItem('ScrapMetalTrigger_LW');
	
	return Template;
}	
	
static function X2AbilityTemplate ScrapMetalTrigger()
{
	local X2AbilityTemplate 			Template;
	local X2Effect_AddAmmo 				AmmoEffect;
	local X2Condition_UnitProperty		UnitPropertyCondition;
	
	AmmoEffect = new class'X2Effect_AddAmmo';
	AmmoEffect.ExtraAmmoAmount = default.SCRAP_METAL_AMMO_AMOUNT;
	
	Template = SelfTargetTrigger('ScrapMetalTrigger_LW', "img:///'BstarsPerkPack_Icons.UIPerk_ScrapMetal'", false, AmmoEffect, 'KillMail');
	    
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	AddTriggerTargetCondition(Template, UnitPropertyCondition);

	Template.bShowActivation = true;
	
	return Template;
}

// Brutality - Killing an organic target with your sawed-off shotgun has a chance to panic nearby organic targets.
static function X2AbilityTemplate Brutality()
{
	local X2AbilityTemplate 				Template;
	local X2AbilityToHitCalc_PercentChance 	ToHitCalc;
	local XMBAbilityTrigger_EventListener 	EventListener;
	local X2AbilityMultiTarget_Radius 		Radius;
	local X2Effect_Persistent 				Effect;
	local X2Condition_PanicOnPod 			PanicCondition;
	//local X2AbilityTarget_Single 			PrimaryTarget;
	local X2Condition_UnitProperty 			TargetCondition, UnitPropertyCondition;

	Template = TargetedDebuff('Brutality_LW', "img:///'BstarsPerkPack_Icons.UIPerk_Brutality'", false, none,, eCost_None);
	Template.bSkipFireAction = true;
	Template.SourceMissSpeech = '';
	Template.SourceHitSpeech = '';

	PanicCondition = new class'X2Condition_PanicOnPod';
	PanicCondition.MaxPanicUnitsPerPod = 2;

	Effect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	Effect.TargetConditions.AddItem(PanicCondition);
	Effect.EffectName = class'X2AbilityTemplateManager'.default.PanickedName;
//	Effect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
//  Effect.SetDisplayInfo(ePerkBuff_Penalty, "Panicking", "This unit is losing control of the situation", "img:///UILibrary_PerkIcons.panicky_icon_here");
	
	Template.AddTargetEffect(Effect);
	Template.AddMultiTargetEffect(Effect);
	
	Template.AbilityTriggers.Length = 0;
	EventListener = new class'XMBAbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'KillMail';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeDead = false;
	TargetCondition.ExcludeRobotic = true;
	TargetCondition.ExcludeFriendlyToSource = true;
	TargetCondition.ExcludeHostileToSource = false;
	
	Template.AbilityTargetConditions.Length = 0;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	Template.AbilityShooterConditions.Length = 0;

	Template.AbilityMultiTargetConditions.Length = 0;
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	
	Radius = new class'X2AbilityMultiTarget_Radius';
	Radius.fTargetRadius = default.BRUTALITY_TILE_RADIUS;
	Radius.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = Radius;
		
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	AddTriggerTargetCondition(Template, UnitPropertyCondition);
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);
	
	HidePerkIcon(Template);
	AddIconPassive(Template);

	ToHitCalc = new class'X2AbilityToHitCalc_PercentChance';
	ToHitCalc.PercentToHit = default.BRUTALITY_PANIC_CHANCE;
	Template.AbilityToHitCalc = ToHitCalc;

	Template.bShowActivation = true;

	return Template;
}

// Ruthless - Killing a stunned, panicked or mind-controlled enemy with your sawed-off shotgun refunds one action point. 
// There is not limit to the number of activations per turn.
static function X2AbilityTemplate Ruthless()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Ruthless               		ActionPointEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Ruthless_LW');
	Template.IconImage = "img:///'BstarsPerkPack_Icons.UIPerk_Ruthless'";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bCrossClassEligible = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ActionPointEffect = new class'X2Effect_Ruthless';
	ActionPointEffect.BuildPersistentEffect(1, true, false, false);
	ActionPointEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(ActionPointEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	return Template;
}
// Lead The Target - Active: Queue a shot on a target that will be taken on the enemy's turn with an increased chance to hit. Does not count as reaction fire.
static function X2AbilityTemplate LeadTheTarget_LW()
{

	local X2AbilityTemplate										Template;
	local X2AbilityCooldown										Cooldown;
	local X2AbilityCost_Ammo									AmmoCost;
	local X2AbilityCost_ActionPoints							ActionPointCost;
	local X2Effect_ReserveActionPoints							ReservePointsEffect;
	local X2Condition_Visibility								TargetVisibilityCondition;
	local X2Effect_Persistent									MarkEffect;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, 'LeadTheTarget_LW');
	Template.IconImage = "img:///UILibrary_WOTC_APA_Class_Pack.perk_LeadTheTarget";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bShowPostActivation = true;
	Template.bSkipFireAction = true;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;

	// Set ability costs, cooldowns, and restrictions
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LEAD_TARGET_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	ActionPointCost.DoNotConsumeAllEffects.Length = 0;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
	ActionPointCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
	Template.AbilityCosts.AddItem(ActionPointCost);

	ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
	ReservePointsEffect.ReserveType = default.LeadTheTargetReserveActionName;
	Template.AddShooterEffect(ReservePointsEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);


	// Create effect to identify the SourceUnit and facilitate charge counting post-mission and to show a passive icon in the tactical UI
	MarkEffect = new class'X2Effect_Persistent';
	MarkEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	MarkEffect.EffectName = default.LeadTheTargetMarkEffectName;
	MarkEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(MarkEffect);

	Template.AdditionalAbilities.AddItem('LeadTheTargetShot_LW');


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	return Template;
}

// Lead The Target Shot - Passive: Triggered Lead the Target shot fired at the enemy
static function X2AbilityTemplate LeadTheTargetShot_LW()
{
	local X2AbilityTemplate										Template;
	local X2AbilityCost_Ammo									AmmoCost;
	local X2AbilityCost_ReserveActionPoints						ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim						StandardAim;
	local X2AbilityTarget_Single								SingleTarget;
	local X2AbilityTrigger_EventListener						Trigger;
	local X2Condition_Visibility								TargetVisibilityCondition;
	local X2Condition_UnitEffectsWithAbilitySource				TargetEffectCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LeadTheTargetShot_LW');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(default.LeadTheTargetReserveActionName);
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = false;
	StandardAim.BuiltInHitMod = default.LEAD_TARGET_AIM_BONUS;
	Template.AbilityToHitCalc = StandardAim;
		
	TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	TargetEffectCondition.AddRequireEffect(default.LeadTheTargetMarkEffectName, 'AA_MissingRequiredEffect');
	Template.AbilityTargetConditions.AddItem(TargetEffectCondition);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	//Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	//  trigger on an attack
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'AbilityActivated';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalAttackListener;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.IconImage = "img:///UILibrary_WOTC_APA_Class_Pack.perk_LeadTheTarget";
	Template.bUsesFiringCamera = true;
	Template.bShowActivation = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function X2AbilityTemplate BlindingProtocol_LW()
{
	
	local X2AbilityTemplate										Template;
	local X2Condition_Visibility								VisCondition;
	local X2AbilityCost_ActionPoints							ActionPointCost;
	local X2AbilityCooldown										Cooldown;
	local X2Condition_UnitProperty								TargetProperty;
	local X2AbilityTarget_Single								PrimaryTarget;
	local X2AbilityMultiTarget_Radius							RadiusMultiTarget;
	local X2Condition_UnitInventory								InventoryCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BlindingProtocol_LW');
	Template.IconImage = "img:///UILibrary_WOTC_APA_Class_Pack.perk_BlindingProtocol"; 
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 2;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bLimitTargetIcons = true;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bStationaryWeapon = true;
	Template.CustomSelfFireAnim = 'NO_DefenseProtocolA';
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bCrossClassEligible = false;
	Template.ConcealmentRule = eConceal_Never;


	// Costs, Conditions, and Requirements:
	// A Gremlin must be equipped in the inventory slot the ability is assigned to

	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot = eInvSlot_SecondaryWeapon;
	InventoryCondition.RequireWeaponCategory = 'gremlin';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Target must be a non-robotic enemy
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = true;
	TargetProperty.ExcludeRobotic = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	// Visibility/Range restrictions and Targeting
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisCondition);

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
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = 1.5 * default.BLIND_PROTOCOL_RADIUS_T1_BASE;
	RadiusMultiTarget.AddAbilityBonusRadius('LW_T2GremlinIndicator', 1.5 * default.BLIND_PROTOCOL_RADIUS_T2_BONUS);
	RadiusMultiTarget.AddAbilityBonusRadius('LW_T3GremlinIndicator', 1.5 * default.BLIND_PROTOCOL_RADIUS_T3_BONUS);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityMultiTargetConditions.AddItem(TargetProperty);
	Template.TargetingMethod = class'X2TargetingMethod_HomingMine';


	// Ability's Action Point cost and Cooldown
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('LW_ABCProtocols_DoNotConsumeAllActionsEffect');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BLINDING_PROTOCOL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Apply the Disoriented effect to valid targets
	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false));
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false));

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;


	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = ProtocolSingleTarget_BuildVisualization;
	//Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	return Template;
}

static simulated function ProtocolSingleTarget_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local X2AbilityTemplate             AbilityTemplate;
	local StateObjectReference          InteractingUnitRef;
	local XComGameState_Item			GremlinItem;
	local XComGameState_Unit			TargetUnitState;
	local XComGameState_Unit			AttachedUnitState;
	local XComGameState_Unit			GremlinUnitState;
	local array<PathPoint> Path;
	local TTile							TargetTile;
	local TTile							StartTile;

	local VisualizationActionMetadata	EmptyTrack;
	local VisualizationActionMetadata	ActionMetadata;
	local X2Action_WaitForAbilityEffect DelayAction;
	local X2Action_AbilityPerkStart		PerkStartAction;
	local X2Action_CameraLookAt			CameraAction;

	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int							EffectIndex, i, j;
	local PathingInputData              PathData;
	local PathingResultData				ResultData;
	local X2Action_PlayAnimation		PlayAnimation;

	local X2VisualizerInterface			TargetVisualizerInterface;

	local X2Action_CameraLookAt			TargetCameraAction;
	local Actor							TargetVisualizer;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

	TargetUnitState = XComGameState_Unit( VisualizeGameState.GetGameStateForObjectID( Context.InputContext.PrimaryTarget.ObjectID ) );

	GremlinItem = XComGameState_Item( History.GetGameStateForObjectID( Context.InputContext.ItemObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1 ) );
	if( GremlinItem == none )
	{
		`RedScreen("Attempting GremlinSingleTarget_BuildVisualization with a GremlinItem of none");
		return;
	}

	GremlinUnitState = XComGameState_Unit( History.GetGameStateForObjectID( GremlinItem.CosmeticUnitRef.ObjectID ) );
	if( GremlinUnitState == none )
	{
		`RedScreen("Attempting GremlinSingleTarget_BuildVisualization with a GremlinUnitState of none");
		return;
	}

	AttachedUnitState = XComGameState_Unit( History.GetGameStateForObjectID( GremlinItem.AttachedUnitRef.ObjectID ) );	
	//Configure the visualization track for the shooter
	//****************************************************************************************

	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.SourceObject;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID( InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1 );
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID( InteractingUnitRef.ObjectID );
	ActionMetadata.VisualizeActor = History.GetVisualizer( InteractingUnitRef.ObjectID );

	CameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	CameraAction.LookAtActor = ActionMetadata.VisualizeActor;
	CameraAction.BlockUntilActorOnScreen = true;

	class'X2Action_IntrusionProtocolSoldier'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	if (AbilityTemplate.ActivationSpeech != '')
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.ActivationSpeech, eColor_Good);
	}

	// make sure he waits for the gremlin to come back, so that the cinescript camera doesn't pop until then
	X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded)).SetCustomTimeOutSeconds(30);

	//Configure the visualization track for the gremlin
	//****************************************************************************************

	InteractingUnitRef = GremlinUnitState.GetReference( );

	ActionMetadata = EmptyTrack;
	History.GetCurrentAndPreviousGameStatesForObjectID(GremlinUnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
	ActionMetadata.VisualizeActor = GremlinUnitState.GetVisualizer();
	TargetVisualizer = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	if (AttachedUnitState.TileLocation != TargetUnitState.TileLocation)
	{
		// Given the target location, we want to generate the movement data.  

		//Handle tall units.
		TargetTile = TargetUnitState.GetDesiredTileForAttachedCosmeticUnit();
		StartTile = AttachedUnitState.GetDesiredTileForAttachedCosmeticUnit();

		class'X2PathSolver'.static.BuildPath(GremlinUnitState, StartTile, TargetTile, PathData.MovementTiles);
		class'X2PathSolver'.static.GetPathPointsFromPath( GremlinUnitState, PathData.MovementTiles, Path );
		class'XComPath'.static.PerformStringPulling(XGUnitNativeBase(ActionMetadata.VisualizeActor), Path);

		PathData.MovingUnitRef = GremlinUnitState.GetReference();
		PathData.MovementData = Path;
		Context.InputContext.MovementPaths.AddItem(PathData);

		class'X2TacticalVisibilityHelpers'.static.FillPathTileData(PathData.MovingUnitRef.ObjectID,	PathData.MovementTiles,	ResultData.PathTileData);
		Context.ResultContext.PathResults.AddItem(ResultData);

		class'X2VisualizerHelpers'.static.ParsePath( Context, ActionMetadata);

		if( TargetVisualizer != none )
		{
			TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
			TargetCameraAction.LookAtActor = TargetVisualizer;
			TargetCameraAction.BlockUntilActorOnScreen = true;
			TargetCameraAction.LookAtDuration = 10.0f;		// longer than we need - camera will be removed by tag below
			TargetCameraAction.CameraTag = 'TargetFocusCamera';
			TargetCameraAction.bRemoveTaggedCamera = false;
		}
	}

	PerkStartAction = X2Action_AbilityPerkStart(class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PerkStartAction.NotifyTargetTracks = true;

	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree( ActionMetadata, Context ));
	if( AbilityTemplate.CustomSelfFireAnim != '' )
	{
		PlayAnimation.Params.AnimName = AbilityTemplate.CustomSelfFireAnim;
	}
	else
	{
		PlayAnimation.Params.AnimName = 'NO_CombatProtocol';
	}

	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree( ActionMetadata, Context );

	//****************************************************************************************
	//Configure the visualization track for the targets
	//****************************************************************************************
	for (i = 0; i < Context.InputContext.MultiTargets.Length; ++i)
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree( ActionMetadata, Context );

		for( j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}
	//****************************************************************************************

	//Configure the visualization track for the target
	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = TargetVisualizer;

	DelayAction = X2Action_WaitForAbilityEffect( class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree( ActionMetadata, Context ) );
	DelayAction.ChangeTimeoutLength( class'X2Ability_SpecialistAbilitySet'.default.GREMLIN_ARRIVAL_TIMEOUT );       //  give the gremlin plenty of time to show up
	
	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityTargetEffects[ EffectIndex ].AddX2ActionsForVisualization( VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult( AbilityTemplate.AbilityTargetEffects[ EffectIndex ] ) );
	}

	TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
	if (TargetVisualizerInterface != none)
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	if( TargetCameraAction != none )
	{
		TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		TargetCameraAction.CameraTag = 'TargetFocusCamera';
		TargetCameraAction.bRemoveTaggedCamera = true;
	}

	//****************************************************************************************
}

static function X2AbilityTemplate NeutralizingAgents()
{
	local X2AbilityTemplate		Template;
	
	Template = PurePassive('NeutralizingAgents_LW', "img:///UILibrary_WOTC_APA_Class_Pack.perk_NeutralizingAgents", false, 'eAbilitySource_Perk', true);

	return Template;
}

/*
static function X2AbilityTemplate ZoneOfControl_LW()
{

	local X2AbilityTemplate										Template;
	local X2Condition_UnitProperty								TargetProperty;
	local X2Condition_LW_WithinCQBRange							RangeCondition;
	local XMBEffect_ConditionalStatChange						ZOCEffect;
	local X2Effect_Persistent									IconEffect;
	local X2Effect_SetUnitValue									SetUnitValue;					
	local X2AbilityTrigger_EventListener						EventListener;
	`CREATE_X2ABILITY_TEMPLATE (Template, 'ZoneOfControl_LW');
	Template.IconImage = "img:///UILibrary_WOTC_APA_Class_Pack.perk_ZoneOfControl";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bUniqueSource = true;
	Template.bIsPassive = true;

	EventListener = new class'X2AbilityTrigger_EventListener';
    EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
    EventListener.ListenerData.EventID = 'PlayerTurnBegun';
    EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    EventListener.ListenerData.Filter = eFilter_Player;
    Template.AbilityTriggers.AddItem(EventListener);


	// Dummy effect to show a passive icon in the tactical UI for the SourceUnit
	IconEffect = new class'X2Effect_Persistent';
	IconEffect.BuildPersistentEffect(1, true, false);
	IconEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true,, Template.AbilitySourceName);
	IconEffect.EffectName = 'ZoneofcontrolIcon';
	Template.AddTargetEffect(IconEffect);

	// Set CQB Range according to rank conditions
	SetUnitValue = new class'X2Effect_SetUnitValue';
	SetUnitValue.UnitName = default.ZONE_CONTROL_RADIUS_NAME;
	SetUnitValue.NewValueToSet = default.ZONE_CONTROL_RADIUS_SQ;
	SetUnitValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetUnitValue);


	// Setup MultiTarget and conditions
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllUnits';

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = true;

	RangeCondition = new class'X2Condition_LW_WithinCQBRange';
	RangeCondition.bLimitToActivatedTargets = true;


	// Create the Zone of Control effect
	ZOCEffect = new class'XMBEffect_ConditionalStatChange';
	ZOCEffect.EffectName = 'ZoneOfControl_LWEffect';
	ZOCEffect.AddPersistentStatChange(eStat_Mobility, default.ZONE_CONTROL_MOBILITY_PENALTY);
	ZOCEffect.AddPersistentStatChange(eStat_Offense, default.ZONE_CONTROL_AIM_PENALTY);
	ZOCEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true,,Template.AbilitySourceName);
	ZOCEffect.DuplicateResponse = eDupe_Refresh;
	ZOCEffect.Conditions.AddItem(RangeCondition);
	ZOCEffect.TargetConditions.AddItem(TargetProperty);
	Template.AddMultiTargetEffect(ZOCEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	Template.AbilityShooterConditions.AddItem(TargetProperty);

	return Template;
}

*/
static function X2AbilityTemplate ZoneOfControl_LW()
{
	local X2AbilityTemplate             Template;
	//local X2Effect_ZoneOfControl        Effect;
	local X2AbilityMultiTarget_AllUnits	TargetStyle;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ZoneOfControl_LW');

	Template.IconImage = "img:///UILibrary_WOTC_APA_Class_Pack.perk_ZoneOfControl";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bCrossClassEligible = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	TargetStyle = new class'X2AbilityMultiTarget_AllUnits';
	TargetStyle.bAcceptEnemyUnits = true;
	Template.AbilityMultiTargetStyle = TargetStyle;
	/*
	Effect = new class'X2Effect_ZoneOfControl';
	Effect.ZoC_Distance = default.ZONE_CONTROL_RADIUS_SQ;
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);
	*/
	Template.AdditionalAbilities.AddItem('ZoCCleanse');
	Template.AdditionalAbilities.AddItem('ZoCPassive');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddZoCPassive()
{
	return PurePassive('ZoCPassive', "img:///UILibrary_WOTC_APA_Class_Pack.perk_ZoneOfControl", , 'eAbilitySource_Perk');
}

static function X2AbilityTemplate AddZoCCleanse()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityTrigger_EventListener        EventListener;
	local X2Condition_UnitProperty              DistanceCondition;
	local XMBEffect_ConditionalStatChange		ZOCEffect;
	local X2Effect_RemoveEffects RemoveEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ZoCCleanse');

	Template.IconImage = "img:///UILibrary_WOTC_APA_Class_Pack.perk_ZoneOfControl";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	DistanceCondition = new class'X2Condition_UnitProperty';
	DistanceCondition.RequireWithinRange = true;
	DistanceCondition.WithinRange = Sqrt(default.ZONE_CONTROL_RADIUS_SQ) *  class'XComWorldData'.const.WORLD_StepSize; // same as Solace for now
	DistanceCondition.ExcludeFriendlyToSource = true;
	DistanceCondition.ExcludeHostileToSource = false;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.SolaceCleanseListener;  // keep this, since it's generically just calling the associate ability
	Template.AbilityTriggers.AddItem(EventListener);

	//Remove the ZOC Effect in case it already exists, becuse eDupe_Refresh only refreshes duration and not the entire effect data.
	//It's important in case of multiple units with Zone of control.
	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem('ZoneOfControl_LWEffect');
	RemoveEffect.TargetConditions.AddItem(DistanceCondition);
	RemoveEffect.bDoNotVisualize = true;
	Template.AddTargetEffect(RemoveEffect);


	ZOCEffect = new class'XMBEffect_ConditionalStatChange';
	ZOCEffect.EffectName = 'ZoneOfControl_LWEffect';
	ZOCEffect.AddPersistentStatChange(eStat_Mobility, default.ZONE_CONTROL_MOBILITY_PENALTY);
	ZOCEffect.AddPersistentStatChange(eStat_Offense, default.ZONE_CONTROL_AIM_PENALTY);
	ZOCEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true,,Template.AbilitySourceName);
	ZOCEffect.DuplicateResponse = eDupe_Refresh;
	ZOCEffect.bRemoveWhenSourceDies = true;
	ZOCEffect.Conditions.AddItem(DistanceCondition);
	Template.AddTargetEffect(ZOCEffect);

	Template.AbilityTargetConditions.AddItem(DistanceCondition);



	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}


static function X2AbilityTemplate ApexPredator_LW()
{

	local X2AbilityTemplate										Template;
	local X2Effect_ApexPredator_LW						PanicTrigger;


	// Create a persistent effect that triggers status effects on Crit
	PanicTrigger = new class'X2Effect_ApexPredator_LW';
	PanicTrigger.BuildPersistentEffect(1, true, false, false);

	Template = Passive('ApexPredator_LW', "img:///UILibrary_WOTC_APA_Class_Pack.perk_ApexPredator", true, PanicTrigger);

	Template.AdditionalAbilities.AddItem('ApexPredatorPanic_LW');

	return Template;
}

// Apex Predator Panic - Passive: Applies Panic to enemies on critical hits
static function X2AbilityTemplate ApexPredatorPanic_LW()
{

	local X2AbilityTemplate										Template;	
	local X2AbilityTrigger_EventListener						EventListener;
	local X2AbilityMultiTarget_Radius							RadiusMultiTarget;
	local X2Condition_UnitProperty								UnitPropertyCondition;
	local X2Effect_Persistent									PanickedEffect;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'ApexPredatorPanic_LW');
	Template.IconImage = "img:///UILibrary_WOTC_APA_Class_Pack.perk_ApexPredator";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.bCrossClassEligible = false;


	// This ability triggers after a Critical Hit
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = class'X2Effect_ApexPredator_LW'.default.ApexPredator_LW_TriggeredName;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	Template.AbilityTriggers.AddItem(EventListener);


	// Setup Multitarget attributes
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	//RadiusMultiTarget.bAddPrimaryTargetAsMultiTarget = true;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = false;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = false;
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = 1.5 * (default.APEX_PREDATOR_PANIC_RADIUS + 0.1);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;


	// Don't apply to allies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);


	// Create the Panic effect on the targets
	PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanickedEffect.ApplyChanceFn = ApplyChance_ApexPredatorPanic;
	Template.AddMultiTargetEffect(PanickedEffect);
	Template.AddTargetEffect(PanickedEffect);

	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	return Template;
}

function name ApplyChance_ApexPredatorPanic(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	local name ImmuneName;
	local int AttackVal, DefendVal, TargetRoll, RandRoll;
	
	TargetUnit = XComGameState_Unit(kNewTargetState);
	if( TargetUnit != none )
	{
		foreach class'X2AbilityToHitCalc_PanicCheck'.default.PanicImmunityAbilities(ImmuneName)
		{
			if( TargetUnit.FindAbility(ImmuneName).ObjectID != 0 )
				{
				return 'AA_UnitIsImmune';
			}
		}
	
		AttackVal = default.APEX_PREDATOR_BASE_PANIC_CHANCE;
		DefendVal = TargetUnit.GetCurrentStat(eStat_Will);
		TargetRoll = class'X2AbilityToHitCalc_PanicCheck'.default.BaseValue + AttackVal - DefendVal;
		TargetRoll = Clamp(TargetRoll,0, 100);
		RandRoll = `SYNC_RAND(100);
		if( RandRoll < TargetRoll )
		{
			return 'AA_Success';
		}
	}
	return 'AA_EffectChanceFailed';
}


static function X2AbilityTemplate Concentration()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ChangeHitResultForAttacker Effect;

	// Create an effect that will change attack hit results
	Effect = new class'XMBEffect_ChangeHitResultForAttacker';
	Effect.EffectName = 'Concentration';
    Effect.IncludeHitResults.AddItem(eHit_Graze);
	Effect.NewResult = eHit_Success;

	// Create the template using a helper function
	Template = Passive('Concentration_LW', "img:///UILibrary_FavidsPerkPack.UIPerk_Concentration", true, Effect);

	return Template;
}

static function X2AbilityTemplate LikeLightning()
{
	local X2Effect_ReduceCooldowns ReduceCooldownEffect;
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;

	// Effect that reduces the cooldown of arc thrower abilities
	ReduceCooldownEffect = new class'X2Effect_ReduceCooldowns';
	ReduceCooldownEffect.ReduceAll = true;
	ReduceCooldownEffect.AbilitiesToTick.AddItem('ArcthrowerStun');
	ReduceCooldownEffect.AbilitiesToTick.AddItem('EMPulser');

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('LikeLightning_LW', "img:///UILibrary_XPerkIconPack.UIPerk_lightning_chevron", false, ReduceCooldownEffect, 'AbilityActivated');

	// Only when Run and Gun abilities are used
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('RunAndGun');
	NameCondition.IncludeAbilityNames.AddItem('LW2WotC_RunAndGun');
	NameCondition.IncludeAbilityNames.AddItem('RunAndGun_LW');
	AddTriggerTargetCondition(Template, NameCondition);

	// Show a flyover when activated
	Template.bShowActivation = true;

	// Add secondary ability that will refund arc thrower action points when used while Run and Gun is active
	//AddSecondaryAbility(Template, LikeLightningRefund());

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}
/*
static function X2AbilityTemplate LikeLightningRefund()
{
	local XMBEffect_AbilityCostRefund Effect;
	local XMBCondition_AbilityName AbilityNameCondition;
	local X2Condition_UnitValue RunAndGunCondition;
	
	// Create an effect that will refund the cost of attacks
	Effect = new class'XMBEffect_AbilityCostRefund';
	Effect.EffectName = 'LikeLightning_LW_Refund';
	Effect.TriggeredEvent = 'LikeLightning_LW_Refund';
	Effect.CountValueName = 'LikeLightning_LW_RefundCounter';
	Effect.MaxRefundsPerTurn = 1;

	// The bonus only applies to arc thrower shots
	AbilityNameCondition = new class'XMBCondition_AbilityName';
	AbilityNameCondition.IncludeAbilityNames.AddItem('ArcThrowerStun');
	AbilityNameCondition.IncludeAbilityNames.AddItem('EMPulser');
	Effect.AbilityTargetConditions.AddItem(AbilityNameCondition);

	// Only refunds if Run and Gun has been activated
	RunAndGunCondition = new class'X2Condition_UnitValue';
	RunAndGunCondition.AddCheckValue('RunAndGun_SuperKillCheck', 0, eCheck_GreaterThan,,,'AA_RunAndGunNotUsed');
	Effect.AbilityShooterConditions.AddItem(RunAndGunCondition);

	// Create the template using a helper function
	return Passive('LikeLightning_LW_Refund', "img:///UILibrary_XPerkIconPack.UIPerk_lightning_chevron", false, Effect);
}
*/

static function X2AbilityTemplate Maim()
{
	local X2AbilityTemplate Template;
	local X2Effect_Immobilize MaimedEffect;
	
	// Create the template using a helper function
	Template = Attack('Maim_LW', "img:///UILibrary_XPerkIconPack.UIPerk_shot_blossom", false, none, class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY, eCost_WeaponConsumeAll, default.MAIM_AMMO_COST);

	// Cooldown
	AddCooldown(Template, default.MAIM_COOLDOWN);

	// Maimed consists of two effects, one for Chosen and one for everyone else
	MaimedEffect = class'X2StatusEffects_LW'.static.CreateMaimedStatusEffect(, Template.AbilitySourceName);
	Template.AddTargetEffect(MaimedEffect);
	
	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Preservation
// (AbilityName="Preservation_LW")
// When your concealment is broken, gain a bonus to defense for a few turns. Passive.
static function X2AbilityTemplate Preservation()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange DefenseEffect;

	// Create a persistent stat change effect that grants a defense bonus
	DefenseEffect = new class'X2Effect_PersistentStatChange';
	DefenseEffect.EffectName = 'PreservationEffect';
	DefenseEffect.AddPersistentStatChange(eStat_Defense, default.PRESERVATION_DEFENSE_BONUS);
	
	// Prevent the effect from applying to a unit more than once
	DefenseEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts for a specified duration
	DefenseEffect.BuildPersistentEffect(default.PRESERVATION_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	
	// Add a visualization that plays a flyover over the target unit
	DefenseEffect.VisualizationFn = EffectFlyOver_Visualization;

	// Ability is triggered when concealment is broken
	Template = SelfTargetTrigger('Preservation_LW', "img:///UILibrary_XPerkIconPack.UIPerk_stealth_defense2", true, DefenseEffect, 'UnitConcealmentBroken', eFilter_Unit);
	
	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	return Template;
}

static function X2AbilityTemplate LickYourWounds()
{
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;
	local X2Effect_ApplyHeal HealEffect;
	
	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('LickYourWounds_LW', "img:///UILibrary_FavidsPerkPack.UIPerk_LickYourWounds", true, none, 'AbilityActivated');

	// Only trigger with Hunker Down
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('HunkerDown');
	NameCondition.IncludeAbilityNames.AddItem('ShieldWall');
	AddTriggerTargetCondition(Template, NameCondition);

	// Restore health effect
	HealEffect = new class'X2Effect_ApplyHeal';
	HealEffect.HealAmount = default.LICKYOURWOUNDS_HEALAMOUNT;
	HealEffect.MaxHealAmount = default.LICKYOURWOUNDS_MAXHEALAMOUNT;
	HealEffect.HealthRegeneratedName = 'LickYourWoundsHeal';
	Template.AddTargetEffect(HealEffect);

	// Heal the status effects that a Medkit would heal
	Template.AddTargetEffect(class'X2Ability_SpecialistAbilitySet'.static.RemoveAllEffectsByDamageType());
	
	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	return Template;
}

static function X2AbilityTemplate Impulse()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus OffenseEffect;
	local X2Condition_UnitValue Condition;

	// Create a conditional bonus effect
	OffenseEffect = new class'XMBEffect_ConditionalBonus';

	// Add the aim and crit bonuses
	OffenseEffect.AddToHitModifier(default.IMPULSE_AIM_BONUS, eHit_Success);
	OffenseEffect.AddToHitModifier(default.IMPULSE_CRIT_BONUS, eHit_Crit);

	// Only if you have moved this turn
	Condition = new class'X2Condition_UnitValue';
	Condition.AddCheckValue('MovesThisTurn', 0, eCheck_GreaterThan);
	OffenseEffect.AbilityShooterConditions.AddItem(Condition);
	
	OffenseEffect.AbilityTargetConditions.AddItem(default.RangedCondition);

	// Create the template using a helper function
	Template = Passive('Impulse_LW', "img:///UILibrary_XPerkIconPack.UIPerk_shot_move2", false, OffenseEffect);

	return Template;
}

static function X2AbilityTemplate LockNLoad()
{
	local X2AbilityTemplate Template;
	local X2Effect_ReloadPrimaryWeapon Effect;

	// Create an effect that restores some ammo
	Effect = new class'X2Effect_ReloadPrimaryWeapon';
	Effect.AmmoToReload = default.LOCKNLOAD_AMMO_TO_RELOAD;
	
	// Create a triggered ability that activates whenever the unit gets a kill
	Template = SelfTargetTrigger('LockNLoad_LW', "img:///UILibrary_XPerkIconPack.UIPerk_reload_shot", true, Effect, 'KillMail');
    
	// Effect only applies to matching weapon
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Show a flyover when activated
	Template.bShowActivation = true;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate TrenchWarfare()
{
	local X2AbilityTemplate				Template;
	local X2Effect_IncrementUnitValue   ValueEffect;
	
	// Increments counter by one at the start of each turn
	ValueEffect = new class'X2Effect_IncrementUnitValue';
	ValueEffect.UnitName = 'TrenchWarfare_LW_KillsThisTurn';
	ValueEffect.NewValueToSet = 1;
	ValueEffect.CleanupType = eCleanup_BeginTurn;
    
	// Create a triggered ability that runs when the owner gets a kill
	Template = SelfTargetTrigger('TrenchWarfare_LW', "img:///UILibrary_FavidsPerkPack.UIPerk_TrenchWarfare", true, ValueEffect, 'KillMail');

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

    // Show flyover after a kill
    Template.bShowActivation = true;

    // Secondary ability that activates Hunker Down at the end of the turn if you got a kill
    AddSecondaryAbility(Template, TrenchWarfareActivator());

	return Template;
}

static function X2AbilityTemplate TrenchWarfareActivator()
{
    local X2Effect_GrantActionPoints ActionPointEffect;
	local X2Effect_ImmediateAbilityActivation HunkerDownEffect;
	local X2Effect_ImmediateAbilityActivation ShieldWallEffect;
	local X2AbilityTemplate Template;
	local X2Condition_UnitEffects EffectsCondition;
	local X2Condition_UnitValue ValueCondition;

	// Create a triggered ability that runs at the end of the player's turn
	Template = SelfTargetTrigger('TrenchWarfare_Activator_LW', "img:///UILibrary_FavidsPerkPack.UIPerk_TrenchWarfare", false, none, 'PlayerTurnEnded', eFilter_Player);

	// Require not already hunkered down
	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect('HunkerDown', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectsCondition);

	// Require that a kill has been made
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('TrenchWarfare_LW_KillsThisTurn', 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);

	// Hunkering requires an action point, so grant one if the unit is out of action points
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.DeepCoverActionPoint;
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.bApplyOnlyWhenOut = true;
	AddSecondaryEffect(Template, ActionPointEffect);

	// Activate the Hunker Down ability
	HunkerDownEffect = new class'X2Effect_ImmediateAbilityActivation';
	HunkerDownEffect.EffectName = 'ImmediateHunkerDown';
	HunkerDownEffect.AbilityName = 'HunkerDown';
	HunkerDownEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	AddSecondaryEffect(Template, HunkerDownEffect);

	// Activate the Shield Wall Ability
	ShieldWallEffect = new class'X2Effect_ImmediateAbilityActivation';
	ShieldWallEffect.EffectName = 'ImmediateShieldWall';
	ShieldWallEffect.AbilityName = 'ShieldWall';
	ShieldWallEffect.BuildPersistentEffect(1, false, true, , eGameRule_PlayerTurnBegin);
	AddSecondaryEffect(Template, ShieldWallEffect);

	return Template;
}

	static function X2AbilityTemplate Dedication()
{
	local X2AbilityTemplate             Template;
	local X2Effect_PersistentStatChange Effect;
	
	// Activated ability that targets user
	Template = SelfTargetActivated('Dedication_LW', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Dedication", true, none, class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY, eCost_Free);
	Template.bShowActivation = true;

	// Create a persistent stat change effect that grants a mobility bonus - naming the effect Shadowstep lets you ignore reaction fire
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'Shadowstep';
	Effect.AddPersistentStatChange(eStat_Mobility, default.DEDICATION_MOBILITY);
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    Template.AddTargetEffect(Effect);

	// Cannot be used while burning, etc.
	Template.AddShooterEffectExclusions();

	// Cooldown
	AddCooldown(Template, default.DEDICATION_COOLDOWN);

	return Template;
}

static function X2AbilityTemplate Corpsman()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AddUtilityItem TemporaryItemEffect;
	
	// Effect granting a free medkit
	TemporaryItemEffect = new class'XMBEffect_AddUtilityItem';
	TemporaryItemEffect.EffectName = 'Corpsman_LW';
	TemporaryItemEffect.DataName = 'Medikit';

	// Create the template using a helper function
	Template = Passive('Corpsman_LW', "img:///UILibrary_XPerkIconPack.UIPerk_medkit_box", true, TemporaryItemEffect);

	return Template;
}

	static function X2AbilityTemplate OpenFire()
{
	local X2AbilityTemplate Template;
    local X2Condition_UnitStatCheck Condition;
	local XMBEffect_ConditionalBonus Effect;

    // Aim and crit bonus
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(default.OPENFIRE_AIM, eHit_Success);
	Effect.AddToHitModifier(default.OPENFIRE_CRIT, eHit_Crit);
    
    // Only applies to full health targets
    Condition = new class'X2Condition_UnitStatCheck';
    Condition.AddCheckStat(eStat_HP, 100, eCheck_Exact, 100, 100, true);
	Effect.AbilityTargetConditions.AddItem(Condition);
	Effect.AbilityTargetConditions.AddItem(default.RangedCondition);

	Template = Passive('OpenFire_LW', "img:///UILibrary_XPerkIconPack.UIPerk_stabilize_shot_2", true, Effect);

    return Template;
}

static function X2AbilityTemplate WatchThemRun()
{
	local X2AbilityTemplate                 Template;
	local X2Condition_PrimaryWeapon   AmmoCondition;
	local XMBCondition_AbilityName   NameCondition;
    local X2Effect_AddOverwatchActionPoints   Effect;
    local X2Condition_UnitValue ValueCondition;
    local X2Effect_IncrementUnitValue IncrementEffect;
	
    // Effect granting an overwatch shot
	Effect = new class'X2Effect_AddOverwatchActionPoints';
    
	Template = SelfTargetTrigger('WatchThemRun_LW', "img:///UILibrary_XPerkIconPack.UIPerk_overwatch_grenade", true, Effect, 'AbilityActivated');
    Template.bShowActivation = true;

	// Only when Throw/Launch Grenade abilities are used
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('ThrowGrenade');
	NameCondition.IncludeAbilityNames.AddItem('LaunchGrenade');
	AddTriggerTargetCondition(Template, NameCondition);

    // Require that the user has ammo left
	AmmoCondition = new class'X2Condition_PrimaryWeapon';
	AmmoCondition.AddAmmoCheck(0, eCheck_GreaterThan);
	AddTriggerTargetCondition(Template, AmmoCondition);
    
	// Limit activations
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('WatchThemRun_LW_Activations', default.WATCHTHEMRUN_ACTIVATIONS_PER_TURN, eCheck_LessThan);
	Template.AbilityTargetConditions.AddItem(ValueCondition);

    // Create an effect that will increment the unit value
	IncrementEffect = new class'X2Effect_IncrementUnitValue';
	IncrementEffect.UnitName = 'WatchThemRun_LW_Activations';
	IncrementEffect.NewValueToSet = 1; // This means increment by one -- stupid property name
	IncrementEffect.CleanupType = eCleanup_BeginTurn;
    Template.AddTargetEffect(IncrementEffect);
	
	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

    return Template;
}


static function X2AbilityTemplate Avenger()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ReturnFireAOE                FireEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Avenger_LW');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_pistol_circle";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FireEffect = new class'X2Effect_ReturnFireAOE';
    FireEffect.RequiredAllyRange = default.AVENGER_RADIUS;
    FireEffect.bAllowSelf = false;
	FireEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(FireEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	
	Template.AdditionalAbilities.AddItem('PrimaryReturnFireShot');

	Template.bCrossClassEligible = false;

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate Predator()
{
	local XMBEffect_ConditionalBonus Effect;

	// Create a conditional bonus
	Effect = new class'XMBEffect_ConditionalBonus';

	// The bonus adds the aim and crit chance
	Effect.AddToHitModifier(default.PREDATOR_AIM_BONUS, eHit_Success);
	Effect.AddToHitModifier(default.PREDATOR_CRIT_BONUS, eHit_Crit);

	// The bonus only applies while flanking
	Effect.AbilityTargetConditions.AddItem(default.FlankedCondition);
	Effect.AbilityTargetConditions.AddItem(default.RangedCondition);

	// Create the template using a helper function
	return Passive('Predator_LW', "img:///UILibrary_FavidsPerkPack.Perk_Ph_Predator", true, Effect);
}

static function X2AbilityTemplate Stiletto()
{
	local XMBEffect_ConditionalBonus ShootingEffect;
	local X2AbilityTemplate Template;

	// Create an armor piercing bonus
	ShootingEffect = new class'XMBEffect_ConditionalBonus';
	ShootingEffect.EffectName = 'Stiletto_LW_Bonuses';
	ShootingEffect.AddArmorPiercingModifier(default.STILETTO_ARMOR_PIERCING);

	// Only with the associated weapon
	ShootingEffect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	// Prevent the effect from applying to a unit more than once
	ShootingEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts forever
	ShootingEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	
	// Activated ability that targets user
	Template = Passive('Stiletto_LW', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Needle", true, ShootingEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate SurvivalInstinct()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2Condition_UnitStatCheck Condition;

	// Create a condition that checks that the unit is at less than 100% HP.
	// X2Condition_UnitStatCheck can also check absolute values rather than percentages, by
	// using "false" instead of "true" for the last argument.
	Condition = new class'X2Condition_UnitStatCheck';
	Condition.AddCheckStat(eStat_HP, 100, eCheck_LessThan,,, true);

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';

	// The effect grants +10 Crit chance and +20 Defense
	Effect.AddToHitModifier(default.SurvivalInstinctCritBonus, eHit_Crit);
	Effect.AddToHitAsTargetModifier(-default.SurvivalInstinctDefenseBonus, eHit_Success);

	// The effect only applies while wounded
	EFfect.AbilityShooterConditions.AddItem(Condition);
	Effect.AbilityTargetConditionsAsTarget.AddItem(Condition);
	
	// Create the template using a helper function
	return Passive('SurvivalInstinct_LW', "img:///UILibrary_SOHunter.UIPerk_survivalinstinct", true, Effect);
}



static function X2AbilityTemplate Reposition()
{
	local X2AbilityTemplate					Template;
	local X2Effect_HitandRun				HitandRunEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Reposition_LW');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_SOCombatEngineer.UIPerk_skirmisher";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	HitandRunEffect = new class'X2Effect_HitandRun';
	HitandRunEffect.HNRUsesName = 'RepositionUses';
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

static function X2AbilityTemplate Overkill()
{
	local X2Effect_Overkill Effect;

	Effect = new class'X2Effect_Overkill';
	Effect.BonusDamage = default.OverkillBonusDamage;

	return Passive('Overkill_LW', "img:///UILibrary_SODragoon.UIPerk_overkill", true, Effect);
}

static function X2AbilityTemplate UnlimitedPower()
{
	local X2AbilityTemplate		Template;
	
	Template = PurePassive('Unlimitedpower_LW', "img:///UILibrary_XPerkIconPack.UIPerk_lightning_pistol", false, 'eAbilitySource_Perk', true);

	return Template;
}

static function X2AbilityTemplate SuperCharge()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges                 ChargeCost;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2Effect_ApplyMedikitHeal             HealEffect;
	local X2Condition_UnitProperty              UnitCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SuperCharge_LW');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_lightning_stabilize";

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.SUPERCHARGE_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Unlimitedpower_LW');
	ActionPointCost.bConsumeAllPoints = true;

	Template.AbilityCosts.AddItem(ActionPointCost);

	HealEffect = new class'X2Effect_ApplyMedikitHeal';
	HealEffect.PerUseHP = default.SUPERCHARGE_HEAL;
	Template.AddTargetEffect(HealEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeFullHealth = true;
	UnitCondition.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate Disassembly()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			StatChangeEffect;
	local X2AbilityTrigger_EventListener		EventListenerTrigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Disassembly_LW');
//BEGIN AUTOGENERATED CODE: Template Overrides 'FullThrottle'
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_gremlin_crit2";
	Template.ActivationSpeech = 'FullThrottle';
//END AUTOGENERATED CODE: Template Overrides 'FullThrottle'

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	EventListenerTrigger = new class'X2AbilityTrigger_EventListener';
	EventListenerTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListenerTrigger.ListenerData.EventID = 'UnitDied';
	EventListenerTrigger.ListenerData.Filter = eFilter_None;
	EventListenerTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.FullThrottleListener;
	Template.AbilityTriggers.AddItem(EventListenerTrigger);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.AddPersistentStatChange(eStat_Hacking, default.DISSASSEMBLY_HACK);	
	StatChangeEffect.BuildPersistentEffect(3, false, true, false, eGameRule_PlayerTurnEnd);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.Dissassemblybonustext, Template.IconImage, true, , Template.AbilitySourceName);
	StatChangeEffect.EffectName = 'DisassemblyStats';
	Template.AddTargetEffect(StatChangeEffect);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.AdditionalAbilities.AddItem('DisassemblyPassive_LW');

	return Template;
}

static function X2AbilityTemplate DisassemblyPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('DisassemblyPassive_LW', "img:///UILibrary_XPerkIconPack.UIPerk_gremlin_crit2", , 'eAbilitySource_Perk');

	return Template;
}

static function X2AbilityTemplate WeaponHandling()
{
	local X2Effect_ModifyRangePenalties Effect;

	Effect = new class'X2Effect_ModifyRangePenalties';
	Effect.RangePenaltyMultiplier = default.WEAPONHANDLING_MULTIPLIER;
	Effect.BaseRange = 18;
	Effect.bShortRange = true;
	Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	return Passive('WeaponHandling_LW', "img:///UILibrary_SOHunter.UIPerk_point_blank", false, Effect);
}

static function X2AbilityTemplate ShootingSharp()
{
	local XMBEffect_ConditionalBonus ShootingEffect;
	local X2AbilityTemplate Template;
	local XMBCondition_CoverType CoverCondition;

	// Create an armor piercing bonus
	ShootingEffect = new class'XMBEffect_ConditionalBonus';
	ShootingEffect.EffectName = 'ShootingSharp_LW_Bonuses';
	ShootingEffect.AddArmorPiercingModifier(default.SS_PIERCE);

	ShootingEffect.AddToHitModifier(default.SS_AIM_BONUS, eHit_Success);

	
	// Only with the associated weapon
	
	CoverCondition = new class'XMBCondition_CoverType';
	CoverCondition.ExcludedCoverTypes.AddItem(CT_None);

	ShootingEffect.AbilityTargetConditions.AddItem(CoverCondition);

	ShootingEffect.AbilityTargetConditions.AddItem(default.RangedCondition);

	// Prevent the effect from applying to a unit more than once
	ShootingEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts forever
	ShootingEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	
	// Activated ability that targets user
	Template = Passive('ShootingSharp_LW', "img:///UILibrary_XPerkIconPack.UIPerk_shot_box", true, ShootingEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate TargetFocus()
{
	local XMBEffect_ConditionalBonus ShootingEffect;
	local X2AbilityTemplate Template;

	// Create an armor piercing bonus
	ShootingEffect = new class'XMBEffect_ConditionalBonus';
	ShootingEffect.EffectName = 'TargetFocus_LW_Bonuses';
	ShootingEffect.AddArmorPiercingModifier(default.TARGET_FOCUS_PIERCE);

	ShootingEffect.AddToHitModifier(default.TARGET_FOCUS_AIM_BONUS, eHit_Success);

	// Only with the associated weapon
	
	ShootingEffect.AbilityTargetConditions.AddItem(default.NoCoverCondition);

	ShootingEffect.AbilityTargetConditions.AddItem(default.RangedCondition);

	// Prevent the effect from applying to a unit more than once
	ShootingEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts forever
	ShootingEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	
	// Activated ability that targets user
	Template = Passive('TargetFocus_LW', "img:///UILibrary_XPerkIconPack.UIPerk_enemy_shot_overwatch", true, ShootingEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate AimingAssist()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2Condition_TargetHasOneOfTheEffects NeedOneOfTheEffects;
	// Create a conditional bonus
	Effect = new class'XMBEffect_ConditionalBonus';

	// The bonus adds the aim and crit chance
	Effect.AddToHitModifier(default.AIM_ASSIST_AIM_BONUS, eHit_Success);
	Effect.AddToHitModifier(default.AIM_ASSIST_CRIT_BONUS, eHit_Crit);

	// The bonus only applies while flanking
	NeedOneOfTheEffects=new class'X2Condition_TargetHasOneOfTheEffects';
	NeedOneOfTheEffects.EffectNames.AddItem(class'X2Effect_LWHolotarget'.default.EffectName);
	NeedOneOfTheEffects.EffectNames.AddItem(class'X2Effect_Holotarget'.default.EffectName);

	Effect.AbilityTargetConditions.AddItem(NeedOneOfTheEffects);

	// Create the template using a helper function
	return Passive('AimAssist_LW', "img:///UILibrary_XPerkIconPack.UIPerk_shot_circle", true, Effect);
}

static function X2AbilityTemplate LightningSlash()
{
	local X2AbilityTemplate									Template;
	local X2AbilityToHitCalc_StandardMelee					StandardMelee;
	local X2AbilityTarget_MovingMelee						MeleeTarget;
	local X2Effect_ApplyWeaponDamage						WeaponDamageEffect;
	local array<name>										SkipExclusions;
	local X2AbilityCooldown									Cooldown;
	local X2AbilityCost_ActionPoints						ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightningSlash_LW');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_lightning_knife";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LIGHTNINGSLASH_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
	
	MeleeTarget = new class'X2AbilityTarget_MovingMelee';
	MeleeTarget.MovementRangeAdjustment = 1;
	Template.AbilityTargetStyle = MeleeTarget;
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	
	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	return Template;
}

static function X2AbilityTemplate InspireAgility()
{
	local X2Effect_PersistentStatChange Effect;
	local X2AbilityTemplate Template;
	local X2AbilityCooldown Cooldown;
	// Create a persistent stat change effect that grants +50 Dodge
	Effect = new class'X2Effect_PersistentStatChange';
	Effect.EffectName = 'InspireAgility';
	Effect.AddPersistentStatChange(eStat_Dodge, default.INSPIRE_DODGE);

	// Prevent the effect from applying to a unit more than once
	Effect.DuplicateResponse = eDupe_Ignore;

	// The effect lasts until the beginning of the player's next turn
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);

	// Add a visualization that plays a flyover over the target unit
	Effect.VisualizationFn = EffectFlyOver_Visualization;

	// Create a targeted buff that affects allies
	Template = TargetedBuff('InspireAgility_LW', "img:///UILibrary_XPerkIconPack.UIPerk_move_command", true, Effect, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_Free);

	// The ability starts out with a single charge
	AddCharges(Template, 1);

	// By default, you can target a unit with an ability even if it already has the effect the
	// ability adds. This helper function prevents targetting units that already have the effect.
	PreventStackingEffects(Template);
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;
	// Add a secondary ability that will grant the bonus charges on kills
	AddSecondaryAbility(Template, InspireAgilityTrigger());

	return Template;
}
	
static function X2AbilityTemplate InspireAgilityTrigger()
{
	local XMBEffect_AddAbilityCharges Effect;

	// Create an effect that will add a bonus charge to the Inspire Agility ability
	Effect = new class'XMBEffect_AddAbilityCharges';
	Effect.AbilityNames.AddItem('InspireAgility_LW');
	Effect.BonusCharges = 1;

	// Create a triggered ability that activates when the unit gets a kill
	return SelfTargetTrigger('InspireAgilityTrigger_LW', "img:///UILibrary_XPerkIconPack.UIPerk_move_command", false, Effect, 'KillMail');
}

static function X2AbilityTemplate PrimaryReturnFire()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ReturnFire                   FireEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PrimaryReturnFire');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_returnfire";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FireEffect = new class'X2Effect_ReturnFire';
	FireEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	FireEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	FireEffect.EffectName = 'PrimaryReturnFireShot';
	FireEffect.AbilityToActivate = 'PrimaryReturnFireShot';
	FireEffect.bDirectAttackOnly = true;
	FireEffect.bOnlyWhenAttackMisses = false;
	Template.AddTargetEffect(FireEffect);

	Template.AdditionalAbilities.AddItem('PrimaryReturnFireShot');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = false;       //  this can only work with pistols, which only sharpshooters have

	return Template;
}


static function X2AbilityTemplate PrimaryReturnFireShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_UnitProperty          ShooterCondition;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Effect_Knockback				KnockbackEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityCost_Ammo				AmmoCost;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'PrimaryReturnFireShot');

	Template.bDontDisplayInAbilitySummary = true;
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint);
	ReserveActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.ReturnFireActionPoint);
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	//	pistols are typically infinite ammo weapons which will bypass the ammo cost automatically.
	//  but if this ability is attached to a weapon that DOES use ammo, it should use it.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);	
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = false; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant');
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.CinescriptCameraType = "StandardGunFiring";	
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.PISTOL_OVERWATCH_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bAllowFreeFireWeaponUpgrade = false;	
	Template.bAllowAmmoEffects = true;

	// Damage Effect
	//
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowBonusWeaponEffects = true;
	
	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_returnfire";
	Template.bShowPostActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

static function X2AbilityTemplate DeadeyeSnapshotAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown_Shared          Cooldown;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_AbilityProperty   	AbilityCondition;
	local X2Condition_UnitActionPoints		ActionPointCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DeadeyeSnapShot');

	Template.AdditionalAbilities.AddItem('DeadeyeDamage_SnapShot');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_deadeye";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";

	Cooldown = new class'X2AbilityCooldown_Shared';
	Cooldown.iNumTurns = class'X2Ability_SharpshooterAbilitySet'.default.DEADEYE_COOLDOWN;
	Cooldown.SharingCooldownsWith.AddItem('Deadeye');
	Template.AbilityCooldown = Cooldown;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.FinalMultiplier = class'X2Ability_SharpshooterAbilitySet'.default.DEADEYE_AIM_MULTIPLIER;
	Template.AbilityToHitCalc = ToHitCalc;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.bCrossClassEligible = true;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActivationSpeech = 'DeadEye';

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('SnapShot');
	Template.AbilityShooterConditions.Additem(AbilityCondition);

	ActionPointCondition = new class'X2Condition_UnitActionPoints';
	ActionPointCondition.AddActionPointCheck(1,class'X2CharacterTemplateManager'.default.StandardActionPoint,false,eCheck_LessThanOrEqual);
	Template.AbilityShooterConditions.AddItem(ActionPointCondition);
	ActionPointCondition = new class'X2Condition_UnitActionPoints';
	ActionPointCondition.AddActionPointCheck(1,class'X2CharacterTemplateManager'.default.RunAndGunActionPoint,false,eCheck_LessThanOrEqual);
	Template.AbilityShooterConditions.AddItem(ActionPointCondition);


	return Template;
}	

static function X2AbilityTemplate DeadeyeSnapShotDamage()
{
	local X2AbilityTemplate						Template;
	local X2Effect_DeadeyeDamage_SnapShot                DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'DeadeyeDamage_SnapShot');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_momentum";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_DeadeyeDamage_Snapshot';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2AbilityTemplate YouCannotHide()
{
	local XMBEffect_ConditionalBonus Effect;
	// Create a conditional bonus

	Effect = new class'XMBEffect_ConditionalBonus';

	// The bonus adds the aim and crit chance
	Effect.AddToHitModifier(100, eHit_Success);

	Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	// Create the template using a helper function
	return Passive('YouCannotHide_LW', "img:///UILibrary_XPerkIconPack.UIPerk_enemy_overwatch_shot", true, Effect);
}


static function X2AbilityTemplate PsychoticRage()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2Condition_UnitStatCheck Condition;

	// Create a condition that checks that the unit is at less than 100% HP.
	// X2Condition_UnitStatCheck can also check absolute values rather than percentages, by
	// using "false" instead of "true" for the last argument.
	Condition = new class'X2Condition_UnitStatCheck';
	Condition.AddCheckStat(eStat_HP, 36, eCheck_LessThan,,, true);

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';

	//Need to add for all of them because apparently if you crit you don't hit lol
	Effect.AddPercentDamageModifier(50, eHit_Success);
	Effect.AddPercentDamageModifier(50, eHit_Graze);
	Effect.AddPercentDamageModifier(50, eHit_Crit);
	Effect.EffectName = 'PsychoticRage_Bonus';

	// The effect only applies while wounded
	EFfect.AbilityShooterConditions.AddItem(Condition);
	Effect.AbilityTargetConditionsAsTarget.AddItem(Condition);
	
	// Create the template using a helper function
	return Passive('PsychoticRage_LW', "img:///UILibrary_XPerkIconPack.UIPerk_melee_adrenaline", true, Effect);
}

static function X2AbilityTemplate PreciseStrike()
{
	local XMBEffect_ConditionalBonus ShootingEffect;
	local X2AbilityTemplate Template;

	// Create an armor piercing bonus
	ShootingEffect = new class'XMBEffect_ConditionalBonus';
	ShootingEffect.EffectName = 'PreciseStrike_Bonus';
	ShootingEffect.AddArmorPiercingModifier(3);

	// Only with the melee weapon
	ShootingEffect.AbilityTargetConditions.AddItem(default.MeleeCondition);

	// Prevent the effect from applying to a unit more than once
	ShootingEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts forever
	ShootingEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	
	// Activated ability that targets user
	Template = Passive('PreciseStrike_LW', "img:///UILibrary_XPerkIconPack.UIPerk_knife_shot", true, ShootingEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
	return Template;
}

static function X2AbilityTemplate HunterMark()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_Visibility		TargetVisibilityCondition;
	local X2Condition_UnitEffects		UnitEffectsCondition;
	local X2Effect_Persistent			TrackingShotMarkSource;
	local X2Effect_TrackingShotMarkTarget TrackingShotMarkTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'XCOMHunterMark_LW');

	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_trackingshot";

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Source cannot already be targeting
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	//UnitEffectsCondition.AddExcludeEffect(class'X2Ability_ChosenSniper'.default.TrackingShotMarkSourceEffectName, 'AA_DuplicateEffectIgnored');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	// Source Effect
	TrackingShotMarkSource = new class 'X2Effect_Persistent';
	TrackingShotMarkSource.EffectName = class'X2Ability_ChosenSniper'.default.TrackingShotMarkSourceEffectName;
	TrackingShotMarkSource.DuplicateResponse = eDupe_Refresh;
	TrackingShotMarkSource.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	TrackingShotMarkSource.bRemoveWhenTargetDies = true;
	Template.AddShooterEffect(TrackingShotMarkSource);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	// Target cannot already be targeted
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Ability_ChosenSniper'.default.TrackingShotMarkTargetEffectName, 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	// Target must be visible
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Target Effect
	TrackingShotMarkTarget = new class 'X2Effect_TrackingShotMarkTarget';
	TrackingShotMarkTarget.EffectName = class'X2Ability_ChosenSniper'.default.TrackingShotMarkTargetEffectName;
	TrackingShotMarkTarget.DuplicateResponse = eDupe_Refresh;
	TrackingShotMarkTarget.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnEnd);
	TrackingShotMarkTarget.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, , , Template.AbilitySourceName);
	TrackingShotMarkTarget.bRemoveWhenTargetDies = true;
	TrackingShotMarkTarget.VisualizationFn = class'X2Ability_ChosenSniper'.static.TrackingShotMarkTarget_VisualizationFn;
	TrackingShotMarkTarget.EffectRemovedVisualizationFn = class'X2Ability_ChosenSniper'.static.TrackingShotMarkTarget_RemovedVisualizationFn;
	Template.AddTargetEffect(TrackingShotMarkTarget);

	Template.ActivationSpeech = 'TargetDefinition';
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_ChosenSniper'.static.TrackingShotMark_BuildVisualization;
	Template.CinescriptCameraType = "ChosenSniper_TrackingShotMark";


	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.ConcealmentRule = eConceal_Never;
	Template.SuperConcealmentLoss = 0;
	Template.AdditionalAbilities.AddItem('MarkedForDeath');
	return Template;
}

static function X2AbilityTemplate HunterMarkHit()
{
	local X2AbilityTemplate                 Template;
	local X2Condition_TargetHasOneOfTheEffects NeedOneOfTheEffects;
	local XMBEffect_AbilityCostRefund	RefundEffect;
	local XMBCondition_AbilityName	NameCondition;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MarkedForDeath');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_trackingshot";

	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	RefundEffect = new class'XMBEffect_AbilityCostRefund';
	RefundEffect.EffectName = 'MarkedForDeath';
	RefundEffect.TriggeredEvent = 'MarkedForDeath';
	RefundEffect.bShowFlyOver=true;
	NeedOneOfTheEffects=new class'X2Condition_TargetHasOneOfTheEffects';
	NeedOneOfTheEffects.EffectNames.AddItem(class'X2Ability_ChosenSniper'.default.TrackingShotMarkTargetEffectName);

	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('SniperStandardFire');
	NameCondition.IncludeAbilityNames.AddITem('SnapShot');


	RefundEffect.AbilityTargetConditions.AddItem(NeedOneOfTheEffects);
	RefundEffect.AbilityTargetConditions.AddItem(NameCondition);

	Template.AddTargetEffect(RefundEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate OverbearingSuperiority()
{
	local X2AbilityTemplate Template;
	local XMBEffect_AbilityCostRefund SuperiorityEffect;

	// Create an effect that refunds the action point cost of abilities
	SuperiorityEffect = new class'XMBEffect_AbilityCostRefund';
	SuperiorityEffect.EffectName = 'OverbearingSuperiority';
	SuperiorityEffect.TriggeredEvent = 'OverbearingSuperiority';

	// Require that the activated ability use the weapon associated with this ability
	SuperiorityEffect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	// Require that the activated ability get a critical hit
	SuperiorityEffect.AbilityTargetConditions.AddItem(default.CritCondition);

	// The effect lasts until the end of the turn
	SuperiorityEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);

	// Create the template for an activated ability using a helper function.
	Template = Passive('OverbearingSuperiority_LW', "img:///UILibrary_XPerkIconPack.UIPerk_enemy_crit_chevron_x3", true, SuperiorityEffect);

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	// Don't allow multiple ability-refunding abilities to be used in the same turn (e.g. Slam Fire and Serial)
	class'X2Ability_RangerAbilitySet'.static.SuperKillRestrictions(Template, 'Serial_SuperKillCheck');

	return Template;
}

static function X2AbilityTemplate CreateXCOMBloodThirst()
{
	local X2AbilityTemplate						Template;
	local X2Effect_BloodThirst            		DamageEffect;
	local X2AbilityTrigger_EventListener		EventListener;	
	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'XCOMBloodThirst_LW');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_rage";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'SlashActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'BladestormActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	DamageEffect = new class'X2Effect_BloodThirst';
	DamageEffect.BuildPersistentEffect(default.XCOM_BLOOD_THIRST_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	DamageEffect.DuplicateResponse = eDupe_Allow;
	DamageEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.bShowActivation=true;
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	Template.AdditionalAbilities.AddItem('XCOMBloodThirstPassive_LW');

	return Template;
}

static function X2AbilityTemplate XCOMBloodThirstPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('XCOMBloodThirstPassive_LW', "img:///UILibrary_PerkIcons.UIPerk_beserker_rage", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate Fatality()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Fatality_LW			AimandCritModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Fatality_LW');
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_panic_crit";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimandCritModifiers = new class 'X2Effect_Fatality_LW';
	AimandCritModifiers.FatalityAimBonus=default.FATALITY_AIM;
	AimandCritModifiers.FatalityCritBonus=default.FATALITY_CRIT;
	AimandCritModifiers.FatalityThreshold=default.FATALITY_THRESHOLD;

	AimandCritModifiers.BuildPersistentEffect (1, true, false);
	AimandCritModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandCritModifiers);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}

static function X2AbilityTemplate Vampirism()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    EventListener;
	local X2Condition_UnitProperty          ShooterProperty;
	local X2Effect_SoulSteal                StealEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Vampirism_LW');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.str_soulstealer";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';

	ShooterProperty = new class'X2Condition_UnitProperty';
	ShooterProperty.ExcludeAlive = false;
	ShooterProperty.ExcludeDead = true;
	ShooterProperty.ExcludeFriendlyToSource = false;
	ShooterProperty.ExcludeHostileToSource = true;
	ShooterProperty.ExcludeFullHealth = true;
	Template.AbilityShooterConditions.AddItem(ShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = VampirismListener;
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(EventListener);

	StealEffect = new class'X2Effect_SoulSteal';
	StealEffect.UnitValueToRead = default.VampUnitValue;
	Template.AddShooterEffect(StealEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.AdditionalAbilities.AddItem('VampirismPassive_LW');

	return Template;
}

static function EventListenerReturn VampirismListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Unit AbilityOwnerUnit, TargetUnit, SourceUnit;
	local int DamageDealt, DmgIdx;
	local float StolenHP;
	local XComGameState_Ability AbilityState, InputAbilityState;
	local X2TacticalGameRuleset Ruleset;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	AbilityState = XComGameState_Ability(CallbackData);
	InputAbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		Ruleset = `TACTICALRULES;
		TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

		if (TargetUnit != none)
		{
			if(SourceUnit.ObjectID == AbilityState.OwnerStateObject.ObjectID)
			{
				if(InputAbilityState.SourceWeapon.ObjectID == AbilityState.SourceWeapon.ObjectID)
				{
					for (DmgIdx = 0; DmgIdx < TargetUnit.DamageResults.Length; ++DmgIdx)
					{
						if (TargetUnit.DamageResults[DmgIdx].Context == AbilityContext)
						{
							DamageDealt += TargetUnit.DamageResults[DmgIdx].DamageAmount;
						}
					}
					if (DamageDealt > 0)
					{
						StolenHP = DamageDealt;
						if (StolenHP > 0)
						{
							NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Chosen Soul Steal Amount");
							AbilityOwnerUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AbilityState.OwnerStateObject.ObjectID));
							AbilityOwnerUnit.SetUnitFloatValue(default.VampUnitValue, StolenHP);
							Ruleset.SubmitGameState(NewGameState);

							AbilityState.AbilityTriggerAgainstSingleTarget(AbilityState.OwnerStateObject, false);

						}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2AbilityTemplate VampirismPassive()
{
	local X2AbilityTemplate         Template;

	Template = PurePassive('VampirismPassive_LW', "img:///UILibrary_PerkIcons.UIPerk_soulsteal", false, 'eAbilitySource_Perk');

	return Template;
}
static function X2AbilityTemplate ComplexReload()
{
	local X2AbilityTemplate Template;
	Template = class'X2Ability_DefaultAbilitySet'.static.AddReloadAbility('ComplexReload_LW');
	X2AbilityCost_ActionPoints(Template.AbilityCosts[0]).bConsumeAllPoints = true;

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	return Template;
}

static function X2AbilityTemplate AddBrawler()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Brawler					DamageReduction;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'Brawler');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_enemy_defense_chevron";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	DamageReduction = new class 'X2Effect_Brawler';
	DamageReduction.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DamageReduction.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(DamageReduction);

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}

static function X2AbilityTemplate AddInstantReactionTime()
{
	local X2AbilityTemplate						Template;
	local X2Effect_InstantReactionTime			DodgeBonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'InstantReactionTime');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_move_blossom";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	DodgeBonus = new class 'X2Effect_InstantReactionTime';
	DodgeBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DodgeBonus.BuildPersistentEffect(1, true, false);
	Template.AddTargetEffect(DodgeBonus);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  No visualization
	return Template;
}

static function X2AbilityTemplate AddCombatReadiness()
{
	local X2AbilityTemplate						Template;
	local XMBEffect_ConditionalBonus			DefenseBonus;
	local X2Effect_PersistentStatChange 			AimBonus;
	local X2Effect_RemoveEffects	RemoveEffects;
	local name	EffectName;
	local XMBCondition_CoverType CoverCondition;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombatReadiness');
//BEGIN AUTOGENERATED CODE: Template Overrides 'FullThrottle'
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_command_defense";
	Template.ActivationSpeech = 'FullThrottle';
//END AUTOGENERATED CODE: Template Overrides 'FullThrottle'

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	CoverCondition = new class'XMBCondition_CoverType';
	CoverCondition.ExcludedCoverTypes.AddItem(CT_None);
	// Add Defense in cover
	DefenseBonus = new class'XMBEffect_ConditionalBonus';

	DefenseBonus.AddToHitAsTargetModifier(-default.COMBATREADINESS_DEF, eHit_Success);
	DefenseBonus.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	DefenseBonus.AbilityTargetConditionsAsTarget.AddItem(CoverCondition);
	DefenseBonus.DuplicateResponse = eDupe_Allow;
	DefenseBonus.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.CombatReadinessBonusText, Template.IconImage, true, , Template.AbilitySourceName);
	DefenseBonus.EffectName = 'CombatReadinessDef';
	Template.AddTargetEffect(DefenseBonus);

	AimBonus = new class 'X2Effect_PersistentStatChange';
	AimBonus.AddPersistentStatChange(eStat_Offense, default.COMBATREADINESS_AIM);	
	AimBonus.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	AimBonus.DuplicateResponse = eDupe_Allow;
	AimBonus.EffectName = 'CombatReadiness';
	Template.AddTargetEffect(AimBonus);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	foreach default.COMBAT_READINESS_EFFECTS_TO_REMOVE(EffectName)
	{
		RemoveEffects.EffectNamesToRemove.AddItem(EffectName);
	}
	Template.AddTargetEffect(RemoveEffects);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('CombatReadinessPassive');

	return Template;
}

static function X2AbilityTemplate AddBanzai()
{
	local X2AbilityTemplate						Template;
	local XMBEffect_ConditionalBonus			DefenseBonus;
	local X2Effect_PersistentStatChange			AimBonus;
	local X2Effect_RemoveEffects				RemoveEffects;
	local XMBCondition_CoverType				CoverCondition;
	local name EffectName;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Banzai_LW');
//BEGIN AUTOGENERATED CODE: Template Overrides 'FullThrottle'
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_command_defense";
	Template.ActivationSpeech = 'FullThrottle';
//END AUTOGENERATED CODE: Template Overrides 'FullThrottle'

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	CoverCondition = new class'XMBCondition_CoverType';
	CoverCondition.ExcludedCoverTypes.AddItem(CT_None);

	// Add Defense in cover
	DefenseBonus = new class'XMBEffect_ConditionalBonus';

	DefenseBonus.AddToHitAsTargetModifier(-default.COMBATREADINESS_DEF, eHit_Success);
	DefenseBonus.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	DefenseBonus.AbilityTargetConditionsAsTarget.AddItem(CoverCondition);
	DefenseBonus.DuplicateResponse = eDupe_Allow;
	DefenseBonus.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.CombatReadinessBonusText, Template.IconImage, true, , Template.AbilitySourceName);
	DefenseBonus.EffectName = 'BanzaiDef';
	Template.AddTargetEffect(DefenseBonus);

	AimBonus = new class 'X2Effect_PersistentStatChange';
	AimBonus.AddPersistentStatChange(eStat_Offense, default.COMBATREADINESS_AIM);	
	AimBonus.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	AimBonus.DuplicateResponse = eDupe_Allow;
	AimBonus.EffectName = 'Banzai';
	Template.AddTargetEffect(AimBonus);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	RemoveEffects = new class'X2Effect_RemoveEffects';
	foreach default.BANZAI_EFFECTS_TO_REMOVE(EffectName)
	{
		RemoveEffects.EffectNamesToRemove.AddItem(EffectName);
	}
	Template.AddTargetEffect(RemoveEffects);

	Template.AdditionalAbilities.AddItem('BanzaiPassive_LW');

	return Template;
}

static function X2AbilityTemplate BanzaiPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('BanzaiPassive_LW', "img:///UILibrary_XPerkIconPack.UIPerk_command_defense", , 'eAbilitySource_Perk');

	return Template;
}

static function X2AbilityTemplate CombatReadinessPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('CombatReadinessPassive', "img:///UILibrary_XPerkIconPack.UIPerk_command_defense", , 'eAbilitySource_Perk');

	return Template;
}

static function X2AbilityTemplate MovingTarget()
{
	local X2Effect_MovingTarget_LW Effect;

	// Create a conditional bonus
	Effect = new class'X2Effect_MovingTarget_LW';

	// Create the template using a helper function
	return Passive('MovingTarget_LW', "img:///UILibrary_PerkIcons.UIPerk_lightningreflexes", false, Effect);
}


static function X2AbilityTemplate Magnum()
{
	local X2Effect_ModifyRangePenalties Effect;
	local XMBCondition_AbilityName	NameCondition;
	// Remove Long range penalties from pistols
	Effect = new class'X2Effect_ModifyRangePenalties';
	Effect.RangePenaltyMultiplier = -1;
	Effect.BaseRange = 11;
	Effect.bLongRange = true;
	Effect.EffectName = 'Magnum';

	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('PistolStandardShot');
	NameCondition.IncludeAbilityNames.AddItem('PistolOverwatchShot');

	Effect.AbilityTargetConditions.AddItem(NameCondition);

	return Passive('Magnum_LW', "img:///UILibrary_XPerkIconPack.UIPerk_pistol_sniper", false, Effect);
}

static function X2AbilityTemplate QuickdrawMobility()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange  MobilityIncreaseEffect;
	local X2Condition_UnitInventory WeaponCatCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'QuickdrawMobilityIncrease');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	WeaponCatCondition = new class'X2Condition_UnitInventory';
	WeaponCatCondition.RelevantSlot = eInvSlot_Pistol;
	WeaponCatCondition.RequireWeaponCategory = 'pistol';
	Template.AbilityTargetConditions.AddItem(WeaponCatCondition);

	MobilityIncreaseEffect = new class'X2Effect_PersistentStatChange';
	MobilityIncreaseEffect.BuildPersistentEffect(1, true, false);
	
	MobilityIncreaseEffect.AddPersistentStatChange(eStat_Mobility, default.QUICKDRAW_MOBILITY_INCREASE);
	Template.AddTargetEffect(MobilityIncreaseEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	Template.bCrossClassEligible = false;

	//Template = Passive('QuickdrawMobilityIncrease',"img:///UILibrary_PerkIcons.UIPerk_quickdraw", false, MobilityIncreaseEffect);
	return Template;
}

static function X2AbilityTemplate CrusaderRage()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2Condition_UnitStatCheck Condition;
	local X2Effect_GreaterPadding GreaterPaddingEffect;
	local X2AbilityTemplate Template;

	// Create a condition that checks that the unit is at less than 100% HP.
	// X2Condition_UnitStatCheck can also check absolute values rather than percentages, by
	// using "false" instead of "true" for the last argument.
	Condition = new class'X2Condition_UnitStatCheck';
	Condition.AddCheckStat(eStat_HP, 51, eCheck_LessThan,,, true);

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';

	//Need to add for all of them because apparently if you crit you don't hit lol
	Effect.AddPercentDamageModifier(20, eHit_Success);
	Effect.AddPercentDamageModifier(20, eHit_Graze);
	Effect.AddPercentDamageModifier(20, eHit_Crit);
	Effect.EffectName = 'CrusaderRage_Bonus2';

	// The effect only applies while wounded
	EFfect.AbilityShooterConditions.AddItem(Condition);
	Effect.AbilityTargetConditionsAsTarget.AddItem(Condition);

	GreaterPaddingEffect = new class 'X2Effect_GreaterPadding';
	GreaterPaddingEffect.BuildPersistentEffect (1, true, false);
	GreaterPaddingEffect.Padding_HealHP = default.CRUSADER_WOUND_HP_REDUCTTION;	
	
	// Create the template using a helper function
	Template = Passive('CrusaderRage_LW', "img:///UILibrary_XPerkIconPack.UIPerk_melee_adrenaline", true, Effect);
	Template.AddTargetEffect(GreaterPaddingEffect);

	Condition = new class'X2Condition_UnitStatCheck';
	Condition.AddCheckStat(eStat_HP, 76, eCheck_LessThan,,, true);

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';

	//Need to add for all of them because apparently if you crit you don't hit lol
	Effect.AddPercentDamageModifier(25, eHit_Success);
	Effect.AddPercentDamageModifier(25, eHit_Graze);
	Effect.AddPercentDamageModifier(25, eHit_Crit);
	Effect.EffectName = 'CrusaderRage_Bonus';
	EFfect.AbilityShooterConditions.AddItem(Condition);
	Effect.AbilityTargetConditionsAsTarget.AddItem(Condition);

	Template.AddTargetEffect(Effect);

	return Template;
}



defaultproperties
{
	LeadTheTargetReserveActionName = "leadthetarget"
	LeadTheTargetMarkEffectName ="Leathetargetmark"
	ZONE_CONTROL_RADIUS_NAME = "LW_CQBDominanceRadius"
	Dissassemblybonustext = "Hack Bonus"
	QuickZapEffectName="QuickZapCostRefund"
	VampUnitValue="VampAmount"
	CombatReadinessBonusText="Aim and defense bonus"
}
