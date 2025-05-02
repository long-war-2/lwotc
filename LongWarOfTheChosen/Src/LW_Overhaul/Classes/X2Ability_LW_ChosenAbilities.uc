//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_SpecialistAbilitySet.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Defines all Long War Chosen-specific abilities, Credit to DerBK for some abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_ChosenAbilities extends XMBAbility config(LW_SoldierSkills);

var localized string ShieldedStatBuffsLocDescription;
var localized string ImpactCompensationBuffDescription;

var config int COOLDOWN_AMMO_DUMP;
var config int COOLDOWN_SHIELD_ALLY;
var config int MSTERROR_STAT_CHECK_BASE_VALUE;
var config int KIDNAP_COOLDOWN;
var config int SHIELDALLYM1_SHIELD;
var config int SHIELDALLYM2_SHIELD;
var config int SHIELDALLYM3_SHIELD;
var config int SHIELDALLYM4_SHIELD;
var config int SHIELDALLYM5_SHIELD;


var config array<name> KIDNAP_ELIGIBLE_CHARTYPES;
var config array<name> COMBAT_READINESS_EFFECTS_TO_REMOVE;

var config array<name> CHOSEN_SUMMON_RNF_DATA;

var config int GREATEST_CHAMPION_AIM;
var config int GREATEST_CHAMPION_CRIT;
var config int GREATEST_CHAMPION_WILL;
var config int GREATEST_CHAMPION_PSIOFFENSE;
var config float UNHOLY_ASCENSION_MOD;
var config float SHIELD_ALLY_PCT_DR;
var config float IMPACT_COMPENSATION_PCT_DR;
var config int IMPACT_COMPENSATION_MAX_STACKS;
var config array<float> IMPACT_V2_DAMAGE_CAP;
var config array<float> IMPACT_V2_PCT_DR;

var config array<float> IMPACT_V2XCOM_DAMAGE_CAP;
var config array<float> IMPACT_V2XCOM_PCT_DR;


var config float WARLOCK_MOBILITY_DEBUFF;
var config float HUNTER_MOBILITY_DEBUFF;
var config int HUNTER_MOB_PER_ATTACK;

var config int UNSTOPPABLE_MIN_MOB;
var const string ChosenSummonContextDesc;

var private name ExtractKnowledgeMarkSourceEffectName, ExtractKnowledgeMarkTargetEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_ChosenAbilities.CreateTemplates --------------------------------");	
	Templates.AddItem(CreateWarlockReaction());
	Templates.AddItem(CreateAssassinReaction());
	Templates.AddItem(CreateHunterReaction());
	Templates.AddItem(CreateAmmoDump());
	Templates.AddItem(CreateShieldAlly('ShieldAllyM1',default.SHIELDALLYM1_SHIELD));
	Templates.AddItem(CreateShieldAlly('ShieldAllyM2',default.SHIELDALLYM2_SHIELD));
	Templates.AddItem(CreateShieldAlly('ShieldAllyM3',default.SHIELDALLYM3_SHIELD));
	Templates.AddItem(CreateShieldAlly('ShieldAllyM4',default.SHIELDALLYM4_SHIELD));
	Templates.AddItem(CreateShieldAlly('ShieldAllyM5',default.SHIELDALLYM5_SHIELD));
	Templates.AddItem(CreateTraitResilience());
	Templates.AddItem(CreateChosenKidnap());
	Templates.AddItem(CreateKeen());
	Templates.AddItem(CreateFollowerDefeatedEscape());

	Templates.AddItem(CreateTrackingShotMark());
	Templates.AddItem(CreateMarkForDeathHunter());
	Templates.AddItem(CreateTrackingShotLW());

	Templates.AddItem(ChosenDragonRounds());
	Templates.AddItem(ChosenDragonRoundsPassive());

	Templates.AddItem(ChosenVenomRounds());
	Templates.AddItem(ChosenVenomRoundsPassive());


	Templates.AddItem(ChosenBleedingRounds());
	Templates.AddItem(ChosenBleedingRoundsPassive());

	Templates.AddItem(AddMindScorchDangerZoneAbility());
	Templates.AddItem(AddTerrorPanicAbility());
	Templates.AddItem(CreateBloodThirst());
	Templates.AddItem(BloodThirstPassive());
	Templates.AddItem(AddMindScorchTerror());

	Templates.AddItem(UnholyAscension_LW());
	Templates.AddItem(CreaterRuptureImmunity());
	Templates.AddItem(AddBloodBath());
	Templates.AddItem(AddMistyMadness());
	Templates.AddItem(AddImpenetrable());
	
	Templates.AddItem(FreeGrenades());
	Templates.AddItem(AssassinPrimeReactionPassive());
	Templates.AddItem(WarlockPrimeReactionPassive());
	Templates.AddItem(HunterPrimeReactionPassive());

	Templates.AddItem(ChosenImmunitiesPassive());
	Templates.AddItem(AssassinSlash_LW());
	Templates.AddItem(ImpactCompensation());
	Templates.AddItem(ImpactCompensationPassive());
	Templates.AddItem(ImpactCompensationV2());
	Templates.AddItem(ImpactCompensationPassiveV2());
	Templates.AddItem(ImpactCompensationV2XCOM());
	Templates.AddItem(ClearUnitValueEachTurnAbility());

	Templates.AddItem(CreateDisabler());

	Templates.AddItem(CreateChosenLootAbility());
	
	Templates.AddItem(AssassinBladestorm());
	Templates.AddItem(AssassinBladestormAttack());
	Templates.AddItem(CreateUnstoppable());
	Templates.AddItem(CreateUnstoppablePassive());
	Templates.AddItem(CreateTriggerDamagedTeleportAbility_LW());

	Templates.AddItem(CreateWarlockMobilityAbility());
	Templates.AddItem(CreateWarlockMobilityAbility2());
	Templates.AddItem(CreateHunterMobilityAbility());
	Templates.AddItem(CreateHunterMobilityBoostAbility());
	
	return Templates;
}

static function X2AbilityTemplate CreateWarlockReaction()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_RunBehaviorTree ReactionEffect;
	local X2Effect_GrantActionPoints AddAPEffect;
	local array<name> SkipExclusions;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_OnlyOnXCOMTurn TurnCondition;
	local X2Condition_SecondWave SecondWaveCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'WarlockReaction');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SecondWaveCondition = new class'X2Condition_SecondWave';
	SecondWaveCondition.RequireSecondWavesDisabled.AddItem('BabyChosen');
	Template.AbilityShooterConditions.AddItem(SecondWaveCondition);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.Priority = 2;
	Template.AbilityTriggers.AddItem(Trigger);

	TurnCondition =new class'X2Condition_OnlyOnXCOMTurn';
	Template.AbilityShooterConditions.AddItem(TurnCondition);
	
	// The unit must be alive and not stunned
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeStunned = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	AddAPEffect = new class'X2Effect_GrantActionPoints';
	AddAPEffect.NumActionPoints = 1;
	AddAPEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(AddAPEffect);

	ReactionEffect = new class'X2Effect_RunBehaviorTree';
	ReactionEffect.BehaviorTreeName = 'WarlockReaction';
	Template.AddTargetEffect(ReactionEffect);

	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;

	Template.FrameAbilityCameraType = eCameraFraming_Always;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('WarlockPrimeReactionPassive');

	return Template;
}

static function X2AbilityTemplate CreateAssassinReaction()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_RunBehaviorTree ReactionEffect;
	local X2Effect_GrantActionPoints AddAPEffect;
	local array<name> SkipExclusions;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_OnlyOnXCOMTurn TurnCondition;
	local X2Condition_SecondWave SecondWaveCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AssassinReaction');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SecondWaveCondition = new class'X2Condition_SecondWave';
	SecondWaveCondition.RequireSecondWavesDisabled.AddItem('BabyChosen');
	Template.AbilityShooterConditions.AddItem(SecondWaveCondition);

	TurnCondition =new class'X2Condition_OnlyOnXCOMTurn';
	Template.AbilityShooterConditions.AddItem(TurnCondition);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.Priority = 2;
	Template.AbilityTriggers.AddItem(Trigger);

	// The unit must be alive and not stunned
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeStunned = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	AddAPEffect = new class'X2Effect_GrantActionPoints';
	AddAPEffect.NumActionPoints = 1;
	AddAPEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(AddAPEffect);

	ReactionEffect = new class'X2Effect_RunBehaviorTree';
	ReactionEffect.BehaviorTreeName = 'AssassinReaction';
	Template.AddTargetEffect(ReactionEffect);

	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;

	Template.FrameAbilityCameraType = eCameraFraming_Always;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('AssassinPrimeReactionPassive');

	return Template;
}

static function X2AbilityTemplate CreateHunterReaction()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_RunBehaviorTree ReactionEffect;
	local X2Effect_GrantActionPoints AddAPEffect;
	local array<name> SkipExclusions;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_OnlyOnXCOMTurn TurnCondition;
	local X2Condition_SecondWave SecondWaveCondition;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'HunterReaction');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	TurnCondition =new class'X2Condition_OnlyOnXCOMTurn';
	Template.AbilityShooterConditions.AddItem(TurnCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SecondWaveCondition = new class'X2Condition_SecondWave';
	SecondWaveCondition.RequireSecondWavesDisabled.AddItem('BabyChosen');
	Template.AbilityShooterConditions.AddItem(SecondWaveCondition);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.Priority = 2;
	Template.AbilityTriggers.AddItem(Trigger);

	// The unit must be alive and not stunned
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeStunned = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	AddAPEffect = new class'X2Effect_GrantActionPoints';
	AddAPEffect.NumActionPoints = 1;
	AddAPEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	Template.AddTargetEffect(AddAPEffect);

	ReactionEffect = new class'X2Effect_RunBehaviorTree';
	ReactionEffect.BehaviorTreeName = 'HunterReaction';
	Template.AddTargetEffect(ReactionEffect);

	Template.bShowActivation = true;
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;

	Template.FrameAbilityCameraType = eCameraFraming_Always;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AdditionalAbilities.AddItem('HunterPrimeReactionPassive');

	return Template;
}

static function X2AbilityTemplate WarlockPrimeReactionPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('WarlockPrimeReactionPassive', "img:///UILibrary_PerkIcons.UIPerk_combatstims", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate HunterPrimeReactionPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('HunterPrimeReactionPassive', "img:///UILibrary_PerkIcons.UIPerk_combatstims", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate AssassinPrimeReactionPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('AssassinPrimeReactionPassive', "img:///UILibrary_PerkIcons.UIPerk_combatstims", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate ChosenImmunitiesPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('ChosenImmunitiesPassive', "img:///UILibrary_XPACK_Common.PerkIcons.str_taxing", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate CreateAmmoDump()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Condition_UnitProperty TargetCondition;
	local array<name> SkipExclusions;
	local X2Effect_DisableWeapon DisableWeapon;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AmmoDump_LW');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mindscorch";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.bfreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.COOLDOWN_AMMO_DUMP;
	Cooldown.NumGlobalTurns = default.COOLDOWN_AMMO_DUMP;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.Deadeye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeFriendlyToSource = true;
	TargetCondition.ExcludeHostileToSource = false;
	TargetCondition.ExcludeCivilian = true;
	TargetCondition.ExcludeCosmetic = true;
	TargetCondition.ExcludeRobotic = false;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	DisableWeapon = new class'X2Effect_DisableWeapon';
	Template.AddTargetEffect(DisableWeapon);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
		
	Template.ActionFireClass = class'XComGame.X2Action_Fire_MindScorch';
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CustomFireAnim = 'HL_MindScorch';
	Template.CinescriptCameraType = "Warlock_SpectralZombie";

	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;
	//Template.CinescriptCameraType = "ChosenWarlock_MindScorch";

	return Template;
}

static function X2AbilityTemplate CreateShieldAlly(name Templatename, int ShieldAmount)
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Condition_UnitProperty TargetCondition;
	local array<name> SkipExclusions;
	local X2Effect_PersistentStatChange ShieldedEffect;
	local X2Effect_GreatestChampion StatBuffsEffect;
	local X2Effect_PCTDamageReduction ImpactEffect;
	local X2Condition_Visibility	VisibilityCondition;
	local X2Condition_AbilityProperty AbilityCondition;
	local X2Effect_Resilience MyCritModifier;
	local X2Condition_OwnerDoesNotHaveAbility DoesNotHaveAbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, Templatename);
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_mindscorch";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.bfreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.COOLDOWN_SHIELD_ALLY;
	Cooldown.NumGlobalTurns = default.COOLDOWN_SHIELD_ALLY;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.Deadeye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = false;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeCivilian = true;
	TargetCondition.ExcludeCosmetic = true;
	TargetCondition.ExcludeRobotic = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.TreatMindControlledSquadmateAsHostile = true;
	TargetCondition.ExcludeUnrevealedAI = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	DoesNotHaveAbilityCondition = new class 'X2Condition_OwnerDoesNotHaveAbility';
	DoesNotHaveAbilityCondition.AbilityName = 'UnholyAscension_LW';

	AbilityCondition = new class 'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('UnholyAscension_LW');


	ShieldedEffect = CreateShieldedEffect(Template.LocFriendlyName, Template.GetMyLongDescription(), ShieldAmount);
	ShieldedEffect.TargetConditions.AddItem(DoesNotHaveAbilityCondition);
	Template.AddTargetEffect(ShieldedEffect);

	StatBuffsEffect = new class'X2Effect_GreatestChampion';
	StatBuffsEffect.BuildPersistentEffect(default.COOLDOWN_SHIELD_ALLY, false, true, , eGameRule_PlayerTurnBegin);
	StatBuffsEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.ShieldedStatBuffsLocDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	StatBuffsEffect.bRemoveWhenTargetDies = true;
	//StatBuffsEffect.bRemoveWhenTargetUnconscious = true;
	StatBuffsEffect.AddPersistentStatChange(eStat_Offense, default.GREATEST_CHAMPION_AIM);
	StatBuffsEffect.AddPersistentStatChange(eStat_CritChance, default.GREATEST_CHAMPION_CRIT);
	StatBuffsEffect.AddPersistentStatChange(eStat_Will, default.GREATEST_CHAMPION_WILL);
	StatBuffsEffect.AddPersistentStatChange(eStat_PsiOffense, default.GREATEST_CHAMPION_PSIOFFENSE);
	StatBuffsEffect.TargetConditions.AddItem(DoesNotHaveAbilityCondition);
	Template.AddTargetEffect(StatBuffsEffect);


	ShieldedEffect = CreateShieldedEffect(Template.LocFriendlyName, Template.GetMyLongDescription(), ShieldAmount);
	ShieldedEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(ShieldedEffect);

	StatBuffsEffect = new class'X2Effect_GreatestChampion';
	StatBuffsEffect.BuildPersistentEffect(1, true, true);
	StatBuffsEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.ShieldedStatBuffsLocDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	StatBuffsEffect.bRemoveWhenTargetDies = true;
	//StatBuffsEffect.bRemoveWhenTargetUnconscious = true;
	StatBuffsEffect.AddPersistentStatChange(eStat_Offense, int(default.GREATEST_CHAMPION_AIM * default.UNHOLY_ASCENSION_MOD));
	StatBuffsEffect.AddPersistentStatChange(eStat_CritChance, int(default.GREATEST_CHAMPION_CRIT * default.UNHOLY_ASCENSION_MOD));
	StatBuffsEffect.AddPersistentStatChange(eStat_Will, int(default.GREATEST_CHAMPION_WILL * default.UNHOLY_ASCENSION_MOD));
	StatBuffsEffect.AddPersistentStatChange(eStat_PsiOffense, int(default.GREATEST_CHAMPION_PSIOFFENSE * default.UNHOLY_ASCENSION_MOD));
	StatBuffsEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(StatBuffsEffect);

	MyCritModifier = new class 'X2Effect_Resilience';
	MyCritModifier.CritDef_Bonus = 200;
	MyCritModifier.BuildPersistentEffect(default.COOLDOWN_SHIELD_ALLY, false, true, , eGameRule_PlayerTurnBegin);
	MyCritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	MyCritModifier.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect (MyCritModifier);


	ImpactEffect = new class'X2Effect_PCTDamageReduction';
	ImpactEffect.PCTDamage_Reduction = default.SHIELD_ALLY_PCT_DR;
	ImpactEffect.bDisplayInSpecialDamageMessageUI = true;
	ImpactEffect.BuildPersistentEffect(default.COOLDOWN_SHIELD_ALLY, false, true, , eGameRule_PlayerTurnBegin);
	ImpactEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	ImpactEffect.DuplicateResponse = eDupe_Allow;
	ImpactEffect.EffectName = 'WarlockDamageReduction_LW';
	Template.AddShooterEffect(ImpactEffect);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
		
	Template.ActionFireClass = class'XComGame.X2Action_Fire_MindScorch';
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CustomFireAnim = 'HL_MindScorch';
	Template.CinescriptCameraType = "Warlock_SpectralZombie";
	//Template.CinescriptCameraType = "ChosenWarlock_MindScorch";

	return Template;
}

static function X2Effect_PersistentStatChange CreateShieldedEffect(string FriendlyName, string LongDescription, int ShieldHPAmount)
{
	local X2Effect_EnergyShield ShieldedEffect;

	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(default.COOLDOWN_SHIELD_ALLY, false, true, , eGameRule_PlayerTurnBegin);
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, FriendlyName, LongDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, ShieldHPAmount);
	//ShieldedEffect.bRemoveWhenTargetUnconscious = true;
	ShieldedEffect.EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization;

	return ShieldedEffect;
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

static function X2AbilityTemplate CreateTraitResilience()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Resilience				MyCritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenCritImmune');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityResilience";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	MyCritModifier = new class 'X2Effect_Resilience';
	MyCritModifier.CritDef_Bonus = 200;
	MyCritModifier.BuildPersistentEffect (1, true, false, true);
	MyCritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (MyCritModifier);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}

static function X2AbilityTemplate CreateFollowerDefeatedEscape()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventTrigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FollowerDefeatedEscape');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'UnitDied';
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventTrigger);

	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.BuildNewGameStateFn = FollowerDefeatedEscape_BuildGameState;
	Template.BuildVisualizationFn = FollowerDefeatedEscape_BuildVisualization;
	Template.AssociatedPlayTiming = SPT_AfterParallel;  // play after the follower death that initiated this ability

	return Template;
}

static function XComGameState FollowerDefeatedEscape_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local X2EventManager EventManager;

	EventManager = `XEVENTMGR;
	History = `XCOMHISTORY;

	NewGameState = History.CreateNewGameState(true, Context);

	TypicalAbility_FillOutGameState(NewGameState);

	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComGameStateContext_Ability(Context).InputContext.SourceObject.ObjectID));

	EventManager.TriggerEvent('UnitRemovedFromPlay', UnitState, UnitState, NewGameState);

	return NewGameState;
}

simulated function FollowerDefeatedEscape_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_PlayEffect EffectAction;
	local X2Action_Delay DelayAction;
	
	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(Context.InputContext.SourceObject.ObjectID);
	
	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false));
	EffectAction.EffectName = "FX_Chosen_Teleport.P_Chosen_Teleport_Out_w_Sound";
	EffectAction.EffectLocation = ActionMetadata.VisualizeActor.Location;
	EffectAction.bWaitForCompletion = false;

	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, Context, false));
	DelayAction.Duration = 0.25;

	class'X2Action_RemoveUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, DelayAction);
	//****************************************************************************************
}

static function X2AbilityTemplate CreateNoLootAndCorpseAbility()
{
	local X2AbilityTemplate Template;
	local X2Effect_NoLootAndCorpse NoLootAndCorpseEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'NoLootAndCorpse');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	NoLootAndCorpseEffect = new class'X2Effect_NoLootAndCorpse';
	NoLootAndCorpseEffect.BuildPersistentEffect(1, true, true, true);
	NoLootAndCorpseEffect.bRemoveWhenTargetDies = true;
	Template.AddShooterEffect(NoLootAndCorpseEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

function XComGameState ChosenSummonFollowers_BuildGameState(XComGameStateContext Context)
{
	local XComGameState NewGameState;
	local PodSpawnInfo SpawnInfo;
	local XComAISpawnManager SpawnManager;
	local int AlertLevel, ForceLevel;
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local XComGameState_MissionSite MissionSiteState;
	local XComGameState_Unit UnitState;
	local TTile ChosenTileLocation;
	local XComWorldData WorldData;
	local Name FollowerEncounterGroupID;
	local X2EventManager EventManager;
	local Object UnitObject;

	EventManager = `XEVENTMGR;
	History = `XCOMHISTORY;

	NewGameState = History.CreateNewGameState(true, Context);
	TypicalAbility_FillOutGameState(NewGameState);

	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComGameStateContext_Ability(Context).InputContext.SourceObject.ObjectID));
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	ForceLevel = BattleData.GetForceLevel();
	AlertLevel = BattleData.GetAlertLevel();
	FollowerEncounterGroupID = GetReinforcementGroupName(AlertLevel);

	if (FollowerEncounterGroupID != '')
	{
		SpawnInfo.EncounterID = FollowerEncounterGroupID;

		WorldData = `XWORLD;
		UnitState.GetKeystoneVisibilityLocation(ChosenTileLocation);
		SpawnInfo.SpawnLocation = WorldData.GetPositionFromTileCoordinates(ChosenTileLocation);

		if (BattleData.m_iMissionID > 0)
		{
			MissionSiteState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));

			if (MissionSiteState != None && MissionSiteState.SelectedMissionData.SelectedMissionScheduleName != '')
			{
				AlertLevel = MissionSiteState.SelectedMissionData.AlertLevel;
				ForceLevel = MissionSiteState.SelectedMissionData.ForceLevel;
			}
		}

		// build a character selection that will work at this location
		SpawnManager = `SPAWNMGR;
		SpawnManager.SelectPodAtLocation(SpawnInfo, ForceLevel, AlertLevel, BattleData.ActiveSitReps);
		SpawnManager.SpawnPodAtLocation(NewGameState, SpawnInfo, false, false, true);

		if (SpawnInfo.SpawnedPod.m_arrUnitIDs.Length > 0)
		{
			UnitObject = UnitState;
			EventManager.RegisterForEvent(UnitObject, 'ChosenSpawnReinforcementsComplete', UnitState.OnSpawnReinforcementsComplete, ELD_OnStateSubmitted, , UnitState);
			EventManager.TriggerEvent('ChosenSpawnReinforcementsComplete', SpawnInfo.SpawnedPod.GetGroupState(), UnitState, NewGameState);
		}
	}

	return NewGameState;
}

static function ChosenSummonFollowers_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local VisualizationActionMetadata EmptyTrack, ActionMetadata, NewUnitActionMetadata;
	local StateObjectReference InteractingUnitRef;
	local XComGameStateContext_Ability  AbilityContext;
	local X2Action_CameraLookAt LookAtAction;
	local XComGameState_Unit UnitState;
	local array<XComGameState_Unit> FreshlySpawnedUnitStates;
	local TTile SpawnedUnitTile;
	local X2Action_RevealArea RevealAreaAction;
	local X2Action_PlayAnimation PlayAnimAction;
	local XComWorldData WorldData;
	local X2Action_PlayEffect SpawnEffectAction;
	local X2Action_Delay RandomDelay;
	local float OffsetVisDuration;
	local array<X2Action>					LeafNodes;
	local XComContentManager ContentManager;
	local XComGameStateVisualizationMgr VisualizationMgr;
	local X2Action_MarkerNamed SyncAction;

	VisualizationMgr = `XCOMVISUALIZATIONMGR;
	ContentManager = `CONTENT;
	History = `XCOMHISTORY;

	TypicalAbility_BuildVisualization(VisualizeGameState);
	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = AbilityContext.InputContext.SourceObject;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(InteractingUnitRef.ObjectID));

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (History.GetGameStateForObjectID(UnitState.ObjectID, , VisualizeGameState.HistoryIndex - 1) == None)
		{
			FreshlySpawnedUnitStates.AddItem(UnitState);
		}
	}

	// if any units spawned in as part of this action, visualize the spawning as part of this sequence
	if (FreshlySpawnedUnitStates.Length > 0)
	{
		WorldData = `XWORLD;

		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		// Pan to Chosen if not already there.
		LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, ActionMetadata.LastActionAdded));
		LookAtAction.UseTether = false;
		LookAtAction.LookAtObject = ActionMetadata.StateObject_NewState;
		LookAtAction.BlockUntilActorOnScreen = true;

		RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, ActionMetadata.LastActionAdded));
		RevealAreaAction.ScanningRadius = class'XComWorldData'.const.WORLD_StepSize * 5.0f;
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(InteractingUnitRef.ObjectID));
		UnitState.GetKeystoneVisibilityLocation(SpawnedUnitTile);
		RevealAreaAction.TargetLocation = WorldData.GetPositionFromTileCoordinates(SpawnedUnitTile);
		RevealAreaAction.bDestroyViewer = false;
		RevealAreaAction.AssociatedObjectID = InteractingUnitRef.ObjectID;
		
		// Trigger the Chosen's narrative line for summoning
		class'XComGameState_NarrativeManager'.static.BuildVisualizationForDynamicNarrative(VisualizeGameState, false, 'ChosenSummonBegin', ActionMetadata.LastActionAdded);

		// play an animation on the chosen showing them summoning in their followers
		PlayAnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, , ActionMetadata.LastActionAdded));
		PlayAnimAction.bFinishAnimationWait = true;
		PlayAnimAction.Params.AnimName = 'HL_Summon';

		SyncAction = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, ActionMetadata.LastActionAdded));
		SyncAction.SetName("SpawningStart");
		SyncAction.AddInputEvent('Visualizer_AbilityHit');

		foreach FreshlySpawnedUnitStates(UnitState)
		{
			if (UnitState.GetVisualizer() == none)
			{
				UnitState.FindOrCreateVisualizer();
				UnitState.SyncVisualizer();

				//Make sure they're hidden until ShowSpawnedUnit makes them visible (SyncVisualizer unhides them)
				XGUnit(UnitState.GetVisualizer()).m_bForceHidden = true;
			}

			NewUnitActionMetadata = EmptyTrack;
			NewUnitActionMetadata.StateObject_OldState = None;
			NewUnitActionMetadata.StateObject_NewState = UnitState;
			NewUnitActionMetadata.VisualizeActor = History.GetVisualizer(UnitState.ObjectID);

			// if multiple units are spawning, apply small random delays between each
			if (UnitState != FreshlySpawnedUnitStates[0])
			{
				RandomDelay = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(NewUnitActionMetadata, AbilityContext, false, SyncAction));
				OffsetVisDuration += 0.5f + `SYNC_FRAND_STATIC() * 0.5f;
				RandomDelay.Duration = OffsetVisDuration;
			}

			X2Action_ShowSpawnedUnit(class'X2Action_ShowSpawnedUnit'.static.AddToVisualizationTree(NewUnitActionMetadata, AbilityContext, false, ActionMetadata.LastActionAdded));

			UnitState.GetKeystoneVisibilityLocation(SpawnedUnitTile);

			SpawnEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(NewUnitActionMetadata, AbilityContext, false, ActionMetadata.LastActionAdded));
			SpawnEffectAction.EffectName = ContentManager.ChosenReinforcementsEffectPathName;
			SpawnEffectAction.EffectLocation = WorldData.GetPositionFromTileCoordinates(SpawnedUnitTile);
			SpawnEffectAction.bStopEffect = false;
		}

		VisualizationMgr.GetAllLeafNodes(VisualizationMgr.BuildVisTree, LeafNodes);

		RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, none, LeafNodes));
		RevealAreaAction.bDestroyViewer = true;
		RevealAreaAction.AssociatedObjectID = InteractingUnitRef.ObjectID;
	}
}

static function name GetReinforcementGroupName(int AlertLevel)
{
	local name GroupName;
	if (default.CHOSEN_SUMMON_RNF_DATA.Length == 0)
	{
		return '';
	}

	if (AlertLevel < 0)
	{
		GroupName = default.CHOSEN_SUMMON_RNF_DATA[0];
	}
	else if (AlertLevel >= default.CHOSEN_SUMMON_RNF_DATA.Length)
	{
		GroupName = default.CHOSEN_SUMMON_RNF_DATA[default.CHOSEN_SUMMON_RNF_DATA.Length - 1];
	}
	else
	{
		GroupName = default.CHOSEN_SUMMON_RNF_DATA[AlertLevel];
	}

	return GroupName;
}

static function X2DataTemplate CreateKeen()
{
	local X2AbilityTemplate Template;
	local X2Effect_ChosenKeen KeenEffect;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenKeen');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_adrenaline_defense";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	//fire this after any unit spawns
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'OnUnitBeginPlay';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(EventListener);

	//fire it when the Chosen spawns.
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	KeenEffect = new class'X2Effect_ChosenKeen';
	KeenEffect.BuildPersistentEffect(1, true, true);
	KeenEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	KeenEffect.DuplicateResponse = eDupe_Refresh; // to handle it being applied multiple times

	Template.AddMultiTargetEffect(KeenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreateTrackingShotLW()
{
	local X2AbilityTemplate					Template;
	local X2Condition_UnitValue				UnitValueCheck;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_Visibility			VisibilityCondition;
	local array<name> 						SkipExclusions;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'TrackingShot_LW');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_trackingshot";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk'; 
	Template.Hostility = eHostility_Offensive;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	
	UnitValueCheck = new class'X2Condition_UnitValue';
	UnitValueCheck.AddCheckValue('GrappledThisTurn', 1, eCheck_LessThan);
	Template.AbilityShooterConditions.AddItem(UnitValueCheck);
	
	Template.AbilityTargetConditions.AddItem(default.FlankedCondition);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AddAmmoCost(Template, 1);
	AddCooldown(Template, 1);

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	Template.AbilityToHitCalc = default.DeadEye;
		
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "ChosenSniper_TrackingShot";	

	Template.AssociatedPassives.AddItem('HoloTargeting');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.bCrossClassEligible = false;

	return Template;
}

static function X2DataTemplate CreateTrackingShotMark()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_Visibility TargetVisibilityCondition;
	local X2Condition_UnitProperty TargetCondition;
	local X2Condition_UnitEffects UnitEffectsCondition;
	local X2Effect_Persistent TrackingShotMarkSource;
	local X2Effect_TrackingShotMarkTarget TrackingShotMarkTarget;
	local array<name> SkipExclusions;
	local X2AbilityCooldown Cooldown;
	local X2Condition_UnitValue UnitValueCheck;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'TrackingShotMark');

//BEGIN AUTOGENERATED CODE: Template Overrides 'TrackingShotMark'
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_trackingshot";
//END AUTOGENERATED CODE: Template Overrides 'TrackingShotMark'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Neutral;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	UnitValueCheck = new class'X2Condition_UnitValue';
	UnitValueCheck.AddCheckValue('GrappledThisTurn', 1, eCheck_LessThan);
	Template.AbilityShooterConditions.AddItem(UnitValueCheck);


	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityTargetConditions.AddItem(default.FlankedCondition);

	// Source cannot already be targeting
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Ability_ChosenSniper'.default.TrackingShotMarkSourceEffectName, 'AA_DuplicateEffectIgnored');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	// Source Effect
	TrackingShotMarkSource = new class 'X2Effect_Persistent';
	TrackingShotMarkSource.EffectName = class'X2Ability_ChosenSniper'.default.TrackingShotMarkSourceEffectName;
	TrackingShotMarkSource.DuplicateResponse = eDupe_Ignore;
	TrackingShotMarkSource.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	TrackingShotMarkSource.bRemoveWhenTargetDies = true;
	Template.AddShooterEffect(TrackingShotMarkSource);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	// Target cannot already be targeted
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Ability_ChosenSniper'.default.TrackingShotMarkTargetEffectName, 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Target must be visible
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireLOS = true;
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// And not concealed
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeConcealed = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	// Target Effect
	TrackingShotMarkTarget = new class 'X2Effect_TrackingShotMarkTarget';
	TrackingShotMarkTarget.EffectName = class'X2Ability_ChosenSniper'.default.TrackingShotMarkTargetEffectName;
	//TrackingShotMarkTarget.ConeEndDiameter = default.TRACKINGSHOT_END_DIAMETER_TILES * class'XComWorldData'.const.WORLD_StepSize;
	//TrackingShotMarkTarget.ConeLength = default.TRACKINGSHOT_LENGTH_TILES * class'XComWorldData'.const.WORLD_StepSize;
	TrackingShotMarkTarget.DuplicateResponse = eDupe_Ignore;
	TrackingShotMarkTarget.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	TrackingShotMarkTarget.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, , , Template.AbilitySourceName);
	TrackingShotMarkTarget.bRemoveWhenTargetDies = true;
	//TrackingShotMarkTarget.EffectTickedFn = TrackingShotMark_EffectTicked;
	TrackingShotMarkTarget.VisualizationFn = class'X2Ability_ChosenSniper'.static.TrackingShotMarkTarget_VisualizationFn;
	TrackingShotMarkTarget.EffectRemovedVisualizationFn = class'X2Ability_ChosenSniper'.static.TrackingShotMarkTarget_RemovedVisualizationFn;
	Template.AddTargetEffect(TrackingShotMarkTarget);

	Template.bSkipFireAction = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_ChosenSniper'.static.TrackingShotMark_BuildVisualization;

	Template.CinescriptCameraType = "ChosenSniper_TrackingShotMark";

	//Template.AdditionalAbilities.AddItem('MarkedForDeath_Hunter');

	return Template;
}


static function X2AbilityTemplate CreateMarkForDeathHunter()
{
	local X2AbilityTemplate                 Template;
	local X2Condition_TargetHasOneOfTheEffects NeedOneOfTheEffects;
	local XMBEffect_AbilityCostRefund	RefundEffect;
	local XMBCondition_AbilityName	NameCondition;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MarkedForDeath_Hunter');

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
	RefundEffect.bShowFlyOver=false;
	NeedOneOfTheEffects=new class'X2Condition_TargetHasOneOfTheEffects';
	NeedOneOfTheEffects.EffectNames.AddItem(class'X2Ability_ChosenSniper'.default.TrackingShotMarkTargetEffectName);

	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('HunterRifleShot');


	RefundEffect.AbilityTargetConditions.AddItem(NeedOneOfTheEffects);
	RefundEffect.AbilityTargetConditions.AddItem(NameCondition);

	Template.AddTargetEffect(RefundEffect);

	Template.AddTargetEffect(new class'X2Effect_LW_RemoveMark');

	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate ChosenDragonRounds()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenDragonRounds');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_incendiary";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = AbilityTriggerEventListener_DragonRounds;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Priority = 40;
	EventListener.ListenerData.Filter = eFilter_Unit;

	Template.AbilityTriggers.AddItem(EventListener);

	//	putting the burn effect first so it visualizes correctly
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;	//	this fire action will be merged by Merge Vis function
	Template.bShowActivation = true;
	Template.bUsesFiringCamera = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = ApplyEffect_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	Template.AdditionalAbilities.AddItem('ChosenDragonRoundsPassive');

	Template.ChosenExcludeTraits.AddItem('ChosenBleedingRounds');
	Template.ChosenExcludeTraits.AddItem('ChosenVenomRounds');

	return Template;
}

static function X2AbilityTemplate ChosenDragonRoundsPassive()
{
	local X2AbilityTemplate	Template;

	Template = PurePassive('ChosenDragonRoundsPassive', "img:///UILibrary_LWOTC.UIPerk_ammo_incendiary", false);

	return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_DragonRounds(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	return HandleApplyEffectEventTrigger('ChosenDragonRounds', EventData, EventSource, GameState);
}

static function X2AbilityTemplate ChosenBleedingRounds()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenBleedingRounds');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_incendiary";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = AbilityTriggerEventListener_BleedingRounds;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Priority = 40;
	EventListener.ListenerData.Filter = eFilter_Unit;

	Template.AbilityTriggers.AddItem(EventListener);

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBleedingStatusEffect(3, 2));

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;	//	this fire action will be merged by Merge Vis function
	Template.bShowActivation = true;
	Template.bUsesFiringCamera = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = ApplyEffect_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	Template.AdditionalAbilities.AddItem('ChosenBleedingRoundsPassive');
	
	Template.ChosenExcludeTraits.AddItem('ChosenDragonRounds');
	Template.ChosenExcludeTraits.AddItem('ChosenVenomRounds');

	return Template;
}

static function X2AbilityTemplate ChosenBleedingRoundsPassive()
{
	local X2AbilityTemplate	Template;

	Template = PurePassive('ChosenBleedingRoundsPassive', "img:///UILibrary_LWOTC.UIPerk_ammo_incendiary", false);

	return Template;
}

static function EventListenerReturn AbilityTriggerEventListener_BleedingRounds(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	return HandleApplyEffectEventTrigger('ChosenBleedingRounds', EventData, EventSource, GameState);
}
static function X2AbilityTemplate ChosenVenomRounds()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenVenomRounds');

	Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityVenomRounds";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	// Trigger on Damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'AbilityActivated';
	EventListener.ListenerData.EventFn = AbilityTriggerEventListener_VenomRounds;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Priority = 40;
	EventListener.ListenerData.Filter = eFilter_Unit;

	Template.AbilityTriggers.AddItem(EventListener);

	//	putting the burn effect first so it visualizes correctly
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;	//	this fire action will be merged by Merge Vis function
	Template.bShowActivation = true;
	Template.bUsesFiringCamera = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = ApplyEffect_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	Template.AdditionalAbilities.AddItem('ChosenVenomRoundsPassive');

	return Template;
}

static function X2AbilityTemplate ChosenVenomRoundsPassive()
{
	local X2AbilityTemplate	Template;

	Template = PurePassive('ChosenVenomRoundsPassive', "img:///UILibrary_LWOTC.LW_AbilityVenomRounds", false);

	return Template;
}

function ApplyEffect_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local array<X2Action>					arrActions;
	local X2Action_MarkerTreeInsertBegin	MarkerStart;
	local X2Action_MarkerTreeInsertEnd		MarkerEnd;
	local X2Action							WaitAction;
	local X2Action_MarkerNamed				MarkerAction;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;
	local bool bFoundHistoryIndex;
	local int i;


	VisMgr = `XCOMVISUALIZATIONMGR;
	
	// Find the start of the Singe's Vis Tree
	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	AbilityContext = XComGameStateContext_Ability(MarkerStart.StateChangeContext);

	//	Find all Fire Actions in the Triggering Shot's Vis Tree
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_Fire', arrActions);

	//	Cycle through all of them to find the Fire Action we need, which will have the same History Index as specified in Singe's Context, which gets set in the Event Listener
	for (i = 0; i < arrActions.Length; i++)
	{
		if (arrActions[i].StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{
			bFoundHistoryIndex = true;
			break;
		}
	}
	//	If we didn't find the correct action, we call the failsafe Merge Vis Function, which will make both Singe's Target Effects apply seperately after the ability finishes.
	//	Looks bad, but at least nothing is broken.
	if (!bFoundHistoryIndex)
	{
		AbilityContext.SuperMergeIntoVisualizationTree(BuildTree, VisualizationTree);
		return;
	}

	//`LOG("Num of Fire Actions: " @ arrActions.Length,, 'IRISINGE');

	//	Add a Wait For Effect Action after the Triggering Shot's Fire Action. This will allow Singe's Effects to visualize the moment the Triggering Shot connects with the target.
	AbilityContext = XComGameStateContext_Ability(arrActions[i].StateChangeContext);
	ActionMetaData = arrActions[i].Metadata;
	WaitAction = class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext,, arrActions[i]);

	//	Insert the Singe's Vis Tree right after the Wait For Effect Action
	VisMgr.ConnectAction(MarkerStart, VisualizationTree,, WaitAction);

	//	Main part of Merge Vis is done, now we just tidy up the ending part. As I understood from MrNice, this is necessary to make sure Vis will look fine if Fire Action ends before Singe finishes visualizing
	//	which tbh sounds like a super edge case, but okay
	//	Find all marker actions in the Triggering Shot Vis Tree.
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_MarkerNamed', arrActions);

	//	Cycle through them and find the 'Join' Marker that comes after the Triggering Shot's Fire Action.
	for (i = 0; i < arrActions.Length; i++)
	{
		MarkerAction = X2Action_MarkerNamed(arrActions[i]);

		if (MarkerAction.MarkerName == 'Join' && MarkerAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{
			//	Grab the last Action in the Singe Vis Tree
			MarkerEnd = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd'));

			//	TBH can't imagine circumstances where MarkerEnd wouldn't exist, but okay
			if (MarkerEnd != none)
			{
				//	"tie the shoelaces". Vis Tree won't move forward until both Singe Vis Tree and Triggering Shot's Fire action are not fully visualized.
				VisMgr.ConnectAction(MarkerEnd, VisualizationTree,,, MarkerAction.ParentActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,, MarkerEnd);
			}
			else
			{
				//	not sure what this does
				VisMgr.GetAllLeafNodes(BuildTree, arrActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,,, arrActions);
			}

			//VisMgr.ConnectAction(MarkerAction, VisualizationTree,, MarkerEnd);
			break;
		}
	}
}

static function EventListenerReturn AbilityTriggerEventListener_VenomRounds(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	return HandleApplyEffectEventTrigger('ChosenVenomRounds', EventData, EventSource, GameState);
}

static function EventListenerReturn HandleApplyEffectEventTrigger(
	name AbilityName,
	Object EventData,
	Object EventSource,
	XComGameState GameState)
{
	local XComGameStateContext_Ability		AbilityContext;
	local XComGameState_Ability				AbilityState, SlagAbilityState;
	local XComGameState_Unit				SourceUnit, TargetUnit;
	local XComGameStateContext				FindContext;
	local int								VisualizeIndex;
	local XComGameStateHistory				History;
	local X2AbilityTemplate					AbilityTemplate;
	local X2Effect							Effect;
	local X2AbilityMultiTarget_BurstFire	BurstFire;
	local bool bDealsDamage;
	local int NumShots;
	local int i;

	History = `XCOMHISTORY;

	AbilityState = XComGameState_Ability(EventData);	// Ability State that triggered this Event Listener
	SourceUnit = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	if (AbilityState != none && SourceUnit != none && TargetUnit != none && AbilityTemplate != none && AbilityContext.InputContext.ItemObject.ObjectID != 0)
	{	
		//	try to find the ability on the source weapon of the same ability
		SlagAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility(AbilityName, AbilityContext.InputContext.ItemObject).ObjectID));

		//	if this is an offensive ability that actually hit the enemy, the same weapon has a Singe ability, and the enemy is still alive
		if (SlagAbilityState != none && AbilityContext.IsResultContextHit() && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && TargetUnit.IsAlive())
		{
			//	check if the ability deals damage
			foreach AbilityTemplate.AbilityTargetEffects(Effect)
			{
				if (X2Effect_ApplyWeaponDamage(Effect) != none)
				{
					bDealsDamage = true;
					break;
				}
			}

			if (bDealsDamage)
			{
				//	account for abilities like Fan Fire and Cyclic Fire that take multiple shots within one ability activation
				NumShots = 1;
				BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
				if (BurstFire != none)
				{
					NumShots += BurstFire.NumExtraShots;
				}
				//	
				for (i = 0; i < NumShots; i++)
				{
					//	pass the Visualize Index to the Context for later use by Merge Vis Fn
					VisualizeIndex = GameState.HistoryIndex;
					FindContext = AbilityContext;
					while (FindContext.InterruptionHistoryIndex > -1)
					{
						FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
						VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
					}
					//`LOG("Singe activated by: " @ AbilityState.GetMyTemplateName() @ "from: " @ AbilityState.GetSourceWeapon().GetMyTemplateName() @ "Singe source weapon: " @ SlagAbilityState.GetSourceWeapon().GetMyTemplateName(),, 'IRISINGE');
					SlagAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2AbilityTemplate AddMindScorchDangerZoneAbility()
{
	local X2AbilityTemplate Template;	

	Template = PurePassive('MindScorchDangerZone', "img:///UILibrary_LW_PerkPack.LW_AbilityDangerZone", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	return Template;
}

static function X2AbilityTemplate AddMindScorchTerror()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('MindScorchTerror', "img:///UILibrary_LWOTC.LW_AbilityNapalmX", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	return Template;
}


static function X2AbilityTemplate AddBloodBath()
{
	local X2AbilityTemplate		Template;
	
	Template = PurePassive('BloodBath_LW', "img:///UILibrary_XPerkIconPack.UIPerk_adrenaline_x2", false, 'eAbilitySource_Perk', true);

	return Template;
}

static function X2AbilityTemplate AddMistyMadness()
{
	local X2AbilityTemplate		Template;
	
	Template = PurePassive('MistyMadness_LW', "img:///UILibrary_XPerkIconPack.UIPerk_smoke_chevron_x3", false, 'eAbilitySource_Perk', true);

	return Template;
}


static function X2AbilityTemplate AddImpenetrable()
{
	local X2AbilityTemplate		Template;
	
	Template = PurePassive('Impenetrable_LW', "img:///UILibrary_XPerkIconPack.UIPerk_defense_blossom", false, 'eAbilitySource_Perk', true);

	return Template;
}

static function X2DataTemplate AddTerrorPanicAbility()
{
	local X2AbilityTemplate			Template;
	local X2Condition_UnitProperty	UnitPropertyCondition;
	local X2Effect_Panicked			PanicEffect;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MSTerrorPanic');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');      //  ability is activated by another ability that hits

	// Target Conditions
	//
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	StatCheck = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatCheck.BaseValue = default.MSTERROR_STAT_CHECK_BASE_VALUE;
	Template.AbilityToHitCalc = StatCheck;

	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.MinStatContestResult = 1;
	PanicEffect.MaxStatContestResult = 0;
	PanicEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(PanicEffect);

	Template.bSkipPerkActivationActions = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2DataTemplate CreateChosenKidnap()
{
	local X2AbilityTemplate Template;
	local X2Effect_Persistent KidnapEffect;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_TargetHasOneOfTheEffects NeedOneOfTheEffects;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2Condition_Character	AllowedUnitCondition;
	local X2Effect_RemoveEffects RemoveEffects;
	local array<name> SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenKidnap'); //intentionally same template so kismet can disable it on special missions without changes to it
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_kidnap";
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.CinescriptCameraType = "StandardGunFiring";

//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenKidnap'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
//END AUTOGENERATED CODE: Template Overrides 'ChosenKidnap'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.KIDNAP_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	KidnapEffect = new class'X2Effect_Persistent';
	KidnapEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	KidnapEffect.bPersistThroughTacticalGameEnd = true;
	KidnapEffect.DuplicateResponse = eDupe_Allow;
	KidnapEffect.EffectName = 'ChosenKidnap';
	KidnapEffect.EffectAddedFn = ChosenKidnap_AddedFn;
	Template.AddShooterEffect(KidnapEffect);

	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	NeedOneOfTheEffects=new class'X2Condition_TargetHasOneOfTheEffects';
	NeedOneOfTheEffects.EffectNames.AddItem(class'X2StatusEffects'.default.BleedingOutName);
	NeedOneOfTheEffects.EffectNames.AddItem(class'X2StatusEffects'.default.UnconsciousName);
	Template.AbilityTargetConditions.AddItem(NeedOneOfTheEffects);

	KidnapEffect = new class'X2Effect_Persistent';
	KidnapEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	KidnapEffect.bPersistThroughTacticalGameEnd = true;
	KidnapEffect.DuplicateResponse = eDupe_Allow;
	KidnapEffect.EffectName = 'ChosenKidnapTarget';
	KidnapEffect.EffectAddedFn = ChosenKidnapTarget_AddedFn;
	Template.AddTargetEffect(KidnapEffect);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('BloodThirst');
	Template.AddShooterEffect(RemoveEffects);

	// Clear bleedout from the target unit?
	// Being done in ChosenKidnapTarget_AddedFn anyways.
	//RemoveEffects = new class'X2Effect_RemoveEffects';
	//RemoveEffects.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BleedingOutName);
	//Template.AddTargetEffect(RemoveEffects);

	// Cannot target units being carried.
	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_UnitIsImmune');
	ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BeingCarriedEffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(ExcludeEffects);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = ChosenKidnap_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

	AllowedUnitCondition = new class'X2Condition_Character';
	AllowedUnitCondition.IncludeCharacterTemplates = default.KIDNAP_ELIGIBLE_CHARTYPES;
	Template.AbilityTargetConditions.AddItem(AllowedUnitCondition);
	
	Template.PostActivationEvents.AddItem('ChosenKidnap');
	
	return Template;
}

static function ChosenKidnap_AddedFn(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit ChosenUnitState;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_HeadquartersAlien AlienHQ;


	ChosenUnitState = XComGameState_Unit(kNewTargetState);

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien', true));
	if( AlienHQ != none )
	{
		ChosenState = AlienHQ.GetChosenOfTemplate(ChosenUnitState.GetMyTemplateGroupName());
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
		ChosenState.CaptureSoldier(NewGameState, ApplyEffectParameters.AbilityInputContext.PrimaryTarget);
	}
}

static function ChosenKidnapTarget_AddedFn(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit KidnappedUnitState;
	local X2EventManager EventManager;
	local XComGameState_Effect BleedOutEffect;

	EventManager = `XEVENTMGR;

	KidnappedUnitState = XComGameState_Unit(kNewTargetState);

	if (KidnappedUnitState.IsBleedingOut())
	{
				//  cleanse the effect so the unit is rendered unconscious
		BleedOutEffect = KidnappedUnitState.GetUnitAffectedByEffectState(class'X2StatusEffects'.default.BleedingOutName);
		BleedOutEffect.RemoveEffect(NewGameState, NewGameState, true);
	}
	
	EventManager.TriggerEvent('UnitRemovedFromPlay', KidnappedUnitState, KidnappedUnitState, NewGameState);
	EventManager.TriggerEvent('UnitCaptured', KidnappedUnitState, KidnappedUnitState, NewGameState);
}

simulated function ChosenKidnap_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata SourceActionMetadata, TargetActionMetadata;
	local X2Action_PlayEffect EffectAction;
	local X2Action_Delay DelayAction;
	local X2Action_PlayAnimation PlayAnimAction;
	local StateObjectReference InteractingUnitRef;
	local X2Action_MarkerNamed SyncAction;
	local X2Action_PlayMessageBanner MessageAction;
	local X2Action_ExitCover ExitCoverAction;
	local X2Action_RemoveUnit RemoveUnitAction;
	local XGParamTag kTag;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;


	//Configure the visualization track for the shooter
	//****************************************************************************************
	SourceActionMetadata = EmptyTrack;
	SourceActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	SourceActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);


	TargetActionMetadata = EmptyTrack;
	TargetActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	TargetActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID);
	TargetActionMetadata.VisualizeActor = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);

	ExitCoverAction = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceActionMetadata, Context));

	// Trigger the Chosen's narrative line before they start the capture
	class'XComGameState_NarrativeManager'.static.BuildVisualizationForDynamicNarrative(VisualizeGameState, false, 'ChosenTacticalEscape', ExitCoverAction);

	PlayAnimAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(SourceActionMetadata, Context, , SourceActionMetadata.LastActionAdded));
	PlayAnimAction.bFinishAnimationWait = true;
	PlayAnimAction.Params.AnimName = 'HL_Summon';

	SyncAction = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(SourceActionMetadata, Context, false, SourceActionMetadata.LastActionAdded));
	SyncAction.SetName("SpawningStart");
	SyncAction.AddInputEvent('Visualizer_AbilityHit');


	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(TargetActionMetadata, Context, false, SyncAction));
	EffectAction.EffectName = "FX_Chosen_Teleport.P_Chosen_Teleport_Out_w_Sound";
	EffectAction.EffectLocation = TargetActionMetadata.VisualizeActor.Location;
	EffectAction.bWaitForCompletion = false;

	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(TargetActionMetadata, Context, false));
	DelayAction.Duration = 0.25;

	RemoveUnitAction = X2Action_RemoveUnit(class'X2Action_RemoveUnit'.static.AddToVisualizationTree(TargetActionMetadata, VisualizeGameState.GetContext(), false, DelayAction));
	//****************************************************************************************

	class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceActionMetadata, Context, false, RemoveUnitAction);

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = XComGameState_Unit(SourceActionMetadata.StateObject_NewState).GetFullName(); // chosen name
	kTag.StrValue1 = XComGameState_Unit(TargetActionMetadata.StateObject_NewState).GetFullName(); // chosen target

	MessageAction = X2Action_PlayMessageBanner(class'X2Action_PlayMessageBanner'.static.AddToVisualizationTree(SourceActionMetadata, Context, false, TargetActionMetadata.LastActionAdded));
	MessageAction.AddMessageBanner(`XEXPAND.ExpandString(class'X2Ability_Chosen'.default.KidnapHeader), , `XEXPAND.ExpandString(class'X2Ability_Chosen'.default.KidnapTargetHeader), `XEXPAND.ExpandString(class'X2Ability_Chosen'.default.KidnapMessageBody), eUIState_Bad);

}

static function X2AbilityTemplate CreateBloodThirst()
{
	local X2AbilityTemplate						Template;
	local X2Effect_BloodThirst            		DamageEffect;
	local X2AbilityTrigger_EventListener		EventListener;	
	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'BloodThirst_LW');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_beserker_rage";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'PartingSilkActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'BladestormActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'HarborWaveDealtDamage';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'SlashActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	
	DamageEffect = new class'X2Effect_BloodThirst';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.DuplicateResponse = eDupe_Allow;
	DamageEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.bShowActivation=true;
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	Template.AdditionalAbilities.AddItem('BloodThirstPassive_LW');

	return Template;
}

static function X2AbilityTemplate BloodThirstPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('BloodThirstPassive_LW', "img:///UILibrary_PerkIcons.UIPerk_beserker_rage", , 'eAbilitySource_Perk');

	return Template;
}

static function X2AbilityTemplate UnholyAscension_LW()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('UnholyAscension_LW', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Corrupt", , 'eAbilitySource_Perk');

	return Template;
}

static function X2DataTemplate FreeGrenades()
{
	local X2AbilityTemplate Template;
	local X2Effect_FreeGrenades GrenadeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FreeGrenades');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_adrenaline_defense";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	GrenadeEffect = new class'X2Effect_FreeGrenades';
	GrenadeEffect.BuildPersistentEffect(1, true, true);

	Template.AddTargetEffect(GrenadeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//like slash but guaranteed to hit
static function X2DataTemplate AssassinSlash_LW()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AssassinSlash_LW');

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
	

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_Deadeye';

	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	AdjacencyCondition.TreatMindControlledSquadmateAsHostile = true;
	AdjacencyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	

	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	//Event that activates blood thirst
	Template.PostActivationEvents.AddItem('SlashActivated');

	return Template;
}

static function X2AbilityTemplate ImpactCompensationPassive()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('ImpactCompensationPassive_LW', "img:///UILibrary_LW_PerkPack.LW_AbilityDamageControl", true, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	//Template.AdditionalAbilities.AddItem('DamageControlAbilityActivated');
	return Template;
}

static function X2AbilityTemplate ImpactCompensation()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ImpactCompensation		ImpactEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ImpactCompensation_LW');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_defense_blossom";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ImpactEffect = new class'X2Effect_ImpactCompensation';
	ImpactEffect.DamageModifier = default.IMPACT_COMPENSATION_PCT_DR;
	ImpactEffect.MaxStacks = default.IMPACT_COMPENSATION_MAX_STACKS;
	ImpactEffect.BuildPersistentEffect(1, true, false);
	ImpactEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.ImpactCompensationBuffDescription, Template.IconImage, true,,Template.AbilitySourceName);
	ImpactEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ImpactEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('DamageInstanceTracker');
	Template.AdditionalAbilities.AddItem('ImpactCompensationPassive_LW');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate ImpactCompensationV2()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ImpactCompensationCapped		ImpactEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ImpactCompensationV2_LW');
	Template.IconImage = "img:///UILibrary_MW.UIPerk_intimidate";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ImpactEffect = new class'X2Effect_ImpactCompensationCapped';
	ImpactEffect.DamageModifier = default.IMPACT_V2_PCT_DR;
	ImpactEffect.MaxCap = default.IMPACT_V2_DAMAGE_CAP;
	ImpactEffect.BuildPersistentEffect(1, true, false);
	ImpactEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);

	ImpactEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ImpactEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('ClearDamageThisTurnAbility_LW');

	Template.ConcealmentRule = eConceal_Always;

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate ImpactCompensationPassiveV2()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('ImpactCompensationPassiveV2_LW', "img:///UILibrary_MW.UIPerk_intimidate", true, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	//Template.AdditionalAbilities.AddItem('DamageControlAbilityActivated');
	return Template;
}

static function X2AbilityTemplate ImpactCompensationV2XCOM()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ImpactCompensationCapped		ImpactEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ImpactCompensationV2XCOM_LW');
	Template.IconImage = "img:///UILibrary_MW.UIPerk_intimidate";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ImpactEffect = new class'X2Effect_ImpactCompensationCapped';
	ImpactEffect.DamageModifier = default.IMPACT_V2XCOM_PCT_DR;
	ImpactEffect.MaxCap = default.IMPACT_V2XCOM_DAMAGE_CAP;
	ImpactEffect.BuildPersistentEffect(1, true, false);
	ImpactEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);

	ImpactEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ImpactEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.ConcealmentRule = eConceal_Always;

	Template.AdditionalAbilities.AddItem('ClearDamageThisTurnAbility_LW');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate ClearUnitValueEachTurnAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_ClearUnitValue ClearUnitValue;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'ClearDamageThisTurnAbility_LW');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bShowActivation = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'PlayerTurnEnded';
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

	Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'PlayerTurnBegun';
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

	Template.ConcealmentRule = eConceal_Always;

	ClearUnitValue = new class'X2Effect_ClearUnitValue';
	ClearUnitValue.UnitValueName = 'DamageThisTurn';
	Template.AddTargetEffect(ClearUnitValue);

	Template.Hostility = eHostility_Neutral;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate ImpactCompensationPassiveV2XCOM()
{
	local X2AbilityTemplate                 Template;	

	Template = PurePassive('ImpactCompensationPassiveV2XCOM_LW', "img:///UILibrary_MW.UIPerk_intimidate", true, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	//Template.AdditionalAbilities.AddItem('DamageControlAbilityActivated');
	return Template;
}

static function X2AbilityTemplate CreateDisabler()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('Disabler', "img:///UILibrary_XPerkIconPack.UIPerk_reload_shot", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

	static function X2AbilityTemplate CreateChosenLootAbility()
{
	local X2AbilityTemplate Template;
	local X2Effect_ChosenLoot ChosenLootEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenLootAbility');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ChosenLootEffect = new class'X2Effect_ChosenLoot';
	ChosenLootEffect.BuildPersistentEffect(1, true, true, true);
	Template.AddShooterEffect(ChosenLootEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AssassinBladestorm()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('AssassinBladestorm', "img:///UILibrary_PerkIcons.UIPerk_bladestorm", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('AssassinBladestormAttack');

	return Template;
}

static function X2AbilityTemplate AssassinBladestormAttack()
{
	local X2AbilityTemplate                 Template;
	local array<name> SkipExclusions;
	local X2Condition_NotItsOwnTurn Condition;

	Template = class'X2Ability_RangerAbilitySet'.static.BladestormAttack('AssassinBladestormAttack');

	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Condition = new class'X2Condition_NotItsOwnTurn';
	Template.AbilityShooterConditions.AddItem(Condition);

	return Template;
}

static function X2AbilityTemplate CreateUnstoppable()
{
	local X2AbilityTemplate						Template;	
	local X2Effect_Unstoppable 					UnstoppableEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Unstoppable_LW');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_move_blaze";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	//Template.bIsPassive = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);


	UnstoppableEffect = new class'X2Effect_Unstoppable';
	UnstoppableEffect.BuildPersistentEffect(1, true, true,, eGameRule_PlayerTurnBegin);
	UnstoppableEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	UnstoppableEffect.AddStatCap(eStat_Mobility,default.UNSTOPPABLE_MIN_MOB,true);
	Template.AddTargetEffect(UnstoppableEffect);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	//Template.AdditionalAbilities.AddItem('UnstoppablePassive_LW');
	//Template.AdditionalAbilities.AddItem('ImmobilizeClear_LW');
	//Template.AdditionalAbilities.AddItem('ReaddImmobilize_LW');

	return Template;
}


static function X2AbilityTemplate CreateUnstoppablePassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('UnstoppablePassive_LW', "img:///UILibrary_XPerkIconPack.UIPerk_move_blaze", , 'eAbilitySource_Perk');

	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	return Template;
}

static function X2AbilityTemplate CreaterRuptureImmunity()
{
	local X2AbilityTemplate						Template;	
	local X2Effect_RuptureImmunity 					RuptureImmunityEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RuptureImmunity');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_knife_defense";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	//Template.bIsPassive = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);


	RuptureImmunityEffect = new class'X2Effect_RuptureImmunity';
	RuptureImmunityEffect.BuildPersistentEffect(1, true, true,, eGameRule_PlayerTurnBegin);
	RuptureImmunityEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(RuptureImmunityEffect);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}
//Because the vanilla ability has a listener at the end of the move which breaks reactions against reaction fire
static function X2AbilityTemplate CreateTriggerDamagedTeleportAbility_LW()
{
	local X2AbilityTemplate Template;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local array<name> SkipExclusions;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'TriggerDamagedTeleport_LW');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_codex_teleport";

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// The unit must be alive and not stunned
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeStunned = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Template.bSkipFireAction = true;
	Template.ModifyNewContextFn = class'X2Ability_PsiWitch'.static.TriggerDamagedTeleport_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = class'X2Ability_PsiWitch'.static.TriggerDamagedTeleport_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_PsiWitch'.static.TriggerDamagedTeleport_BuildVisualization;
	Template.CinescriptCameraType = "Avatar_TriggerDamagedTeleport";
//BEGIN AUTOGENERATED CODE: Template Overrides 'TriggerDamagedTeleport'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'TriggerDamagedTeleport'

	return Template;
}

static function X2AbilityTemplate CreateWarlockMobilityAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_PersistentStatChange StatChangeEffect;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'WarlockReactionMobility_LW');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bShowActivation = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'PlayerTurnEnded';
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.BuildPersistentEffect(1,false, false, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.AddPersistentStatChange(eStat_Mobility,default.WARLOCK_MOBILITY_DEBUFF, MODOP_Multiplication);
	StatChangeEffect.DuplicateResponse = eDupe_Refresh;
	StatChangeEffect.bDisplayInUI = false;
	Template.AddTargetEffect(StatChangeEffect);

	Template.bSkipFireAction = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization; // Intentionally commented out

	return Template;
}

static function X2AbilityTemplate CreateWarlockMobilityAbility2()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_PersistentStatChange StatChangeEffect;
	local X2Condition_NotItsOwnTurn NotItsOwnTurnCondition;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'WarlockReactionMobility2_LW');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bShowActivation = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger= new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = class'X2Ability_ChosenWarlock'.default.SpawnSpectralArmyRemovedTriggerName;
	Trigger.ListenerData.Priority = 10;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	Trigger= new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = class'X2Ability_ChosenWarlock'.default.SpectralArmyLinkRemovedTriggerName;
	Trigger.ListenerData.Priority = 10;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	NotItsOwnTurnCondition = new class'X2Condition_NotItsOwnTurn';
	Template.AbilityShooterConditions.AddItem(NotItsOwnTurnCondition);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.BuildPersistentEffect(1,false, false, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.AddPersistentStatChange(eStat_Mobility,default.WARLOCK_MOBILITY_DEBUFF, MODOP_Multiplication);
	StatChangeEffect.DuplicateResponse = eDupe_Refresh;
	StatChangeEffect.bDisplayInUI = false;
	Template.AddTargetEffect(StatChangeEffect);

	Template.bSkipFireAction = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization; // Intentionally commented out

	return Template;
}

static function X2AbilityTemplate CreateHunterMobilityAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_PersistentStatChange StatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HunterReactionMobility_LW');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bShowActivation = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = 'PlayerTurnEnded';
    Trigger.ListenerData.Filter = eFilter_Player;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.BuildPersistentEffect(1,false, false, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.AddPersistentStatChange(eStat_Mobility,default.HUNTER_MOBILITY_DEBUFF, MODOP_Multiplication);
	StatChangeEffect.bDisplayInUI = false;
	Template.AddTargetEffect(StatChangeEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization; // Intentionally commented out
	
	return Template;
}

static function X2AbilityTemplate CreateHunterMobilityBoostAbility()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange StatChangeEffect;
	local X2AbilityTrigger_EventListener Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HunterReactionMobBoost_LW');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bShowActivation = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;


	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.Priority = 2;
	Template.AbilityTriggers.AddItem(Trigger);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.BuildPersistentEffect(1,false, false, false, eGameRule_PlayerTurnBegin);
	StatChangeEffect.AddPersistentStatChange(eStat_Mobility,default.HUNTER_MOB_PER_ATTACK, MODOP_Addition);
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(StatChangeEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

defaultproperties
{
	ExtractKnowledgeMarkSourceEffectName="ExtractKnowledgeMarkSourceEffect"
	ExtractKnowledgeMarkTargetEffectName="ExtractKnowledgeMarkTargetEffect"

	ChosenSummonContextDesc="ChosenSummonContext"
}
