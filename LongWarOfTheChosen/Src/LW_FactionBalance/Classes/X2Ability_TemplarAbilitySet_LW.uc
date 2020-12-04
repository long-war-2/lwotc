//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_TemplarAbilitySet_LW.uc
//  AUTHOR:  martox
//  PURPOSE: Additional Templar abilities for use in LWOTC.
//---------------------------------------------------------------------------------------
class X2Ability_TemplarAbilitySet_LW extends X2Ability_TemplarAbilitySet config(LW_FactionBalance);

var config int SOLACE_ACTION_POINTS;
var config int SOLACE_COOLDOWN;
var config int GRAZE_MIN_FOCUS, GRAZE_PER_FOCUS_CHANCE;
var config int MEDITATION_FOCUS_RECOVERY;
var config int MEDITATION_MAX_CHARGES;
var config float BONUS_REND_DAMAGE_PER_TILE;
var config int MAX_REND_FLECHE_DAMAGE;
var config int VIGILANCE_MIN_POD_SIZE;
var config int TERROR_STAT_CHECK_BASE_VALUE;
var config int APOTHEOSIS_COOLDOWN;
var config int APOTHEOSIS_DODGE_BONUS;
var config int APOTHEOSIS_MOBILITY_BONUS;
var config float APOTHEOSIS_DAMAGE_MULTIPLIER;

var config int FOCUS1AIM;
var config int FOCUS1DEFENSE;
var config int FOCUS2AIM;
var config int FOCUS2DEFENSE;
var config int FOCUS3AIM;
var config int FOCUS3DEFENSE;
var config int FOCUS4AIM;
var config int FOCUS4DEFENSE;

var name PanicImpairingAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	//from Udaya
	Templates.AddItem(AddSupremeFocus());
	Templates.AddItem(AddTemplarSolace());
	Templates.AddItem(AddTemplarFleche());
	Templates.AddItem(AddTemplarGrazingFireAbility());
	Templates.AddItem(AddMeditation());
	Templates.AddItem(AddMeditationKillTracker());
	Templates.AddItem(AddOvercharge_LW());
	Templates.AddItem(AddVoltDangerZoneAbility());
	Templates.AddItem(AddTemplarVigilance());
	Templates.AddItem(AddTemplarVigilanceTrigger());
	Templates.AddItem(AddTemplarTerror());
	Templates.AddItem(AddTerrorPanicAbility());
	Templates.AddItem(AddApotheosis());

	return Templates;
}

static function X2AbilityTemplate AddSupremeFocus()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('SupremeFocus', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_SupremeFocus", false, 'eAbilitySource_Psionic', false);
	Template.PrerequisiteAbilities.AddItem('DeepFocus');

	return Template;
}

static function X2AbilityTemplate AddTemplarSolace()
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

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TemplarSolace');

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

	Template.ActivationSpeech = 'StunStrike';
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Volt';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate AddTemplarFleche()
{
	local X2AbilityTemplate				Template;
	local X2Effect_FlecheBonusDamage	FlecheBonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TemplarFleche');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bHideOnClassUnlock = true;
	Template.bCrossClassEligible = false;
	FlecheBonusDamageEffect = new class 'X2Effect_FlecheBonusDamage';
	FlecheBonusDamageEffect.BonusDmgPerTile = default.BONUS_REND_DAMAGE_PER_TILE;
	FlecheBonusDamageEffect.MaxBonusDamage = default.MAX_REND_FLECHE_DAMAGE;
	FlecheBonusDamageEffect.AbilityNames.AddItem('Rend');
	FlecheBonusDamageEffect.AbilityNames.AddItem('ArcWave');
	FlecheBonusDamageEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	FlecheBonusDamageEffect.BuildPersistentEffect (1, true, false);
	Template.AddTargetEffect (FlecheBonusDamageEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddTemplarGrazingFireAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_TemplarGrazingFire		GrazingEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'TemplarGrazingFire');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityGrazingFire";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bCrossClassEligible = true;
	GrazingEffect = new class'X2Effect_TemplarGrazingFire';
	GrazingEffect.GrazeMinFocus = default.GRAZE_MIN_FOCUS;
	GrazingEffect.SuccessChance = class'X2Ability_PerkPackAbilitySet'.default.GRAZING_FIRE_SUCCESS_CHANCE;
	GrazingEffect.GrazePerFocusChance = default.GRAZE_PER_FOCUS_CHANCE;
	GrazingEffect.BuildPersistentEffect (1, true, false);
	GrazingEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	Template.AddTargetEffect(GrazingEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	return Template;
}

static function X2AbilityTemplate AddMeditation()
{
	local X2AbilityTemplate				Template;
	local X2Effect_ModifyTemplarFocus	FocusEffect;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCharges 				Charges;
	local X2AbilityCost_Charges 		ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Meditation');

//BEGIN AUTOGENERATED CODE: Template Overrides 'MeditationPreparation'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
//END AUTOGENERATED CODE: Template Overrides 'MeditationPreparation'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_meditation";

	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AdditionalAbilities.AddItem('MeditationKillTracker');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Start with 0 charges. You need to get kills in order to get
	// charges and use Meditation.
	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = 0;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	FocusEffect = new class'X2Effect_ModifyTemplarFocus';
	FocusEffect.ModifyFocus = default.MEDITATION_FOCUS_RECOVERY;
	Template.AddShooterEffect(FocusEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	// Template.AdditionalAbilities.AddItem('MeditationPreparationPassive');

	return Template;
}

static function X2AbilityTemplate AddOvercharge_LW()
{
	local X2AbilityTemplate					Template;
	local X2Effect_TemplarFocusStatBonuses	FocusEffect;
	local array<StatChange>					StatChanges;
	local StatChange						NewStatChange;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Overcharge_LW');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Overcharge";
	Template.Hostility = eHostility_Neutral;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Overcharge'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
//END AUTOGENERATED CODE: Template Overrides 'Overcharge'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	FocusEffect = new class'X2Effect_TemplarFocusStatBonuses';
	FocusEffect.BuildPersistentEffect(1, true, false);
	FocusEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false, , Template.AbilitySourceName);

	//	focus 0
	StatChanges.Length = 0;
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);
	//	focus 1
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Offense;
	NewStatChange.StatAmount = default.FOCUS1AIM;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Defense;
	NewStatChange.StatAmount = default.FOCUS1DEFENSE;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);
	//	focus 2
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Offense;
	NewStatChange.StatAmount = default.FOCUS2AIM;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Defense;
	NewStatChange.StatAmount = default.FOCUS2DEFENSE;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);
	//	focus 3
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Offense;
	NewStatChange.StatAmount = default.FOCUS3AIM;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Defense;
	NewStatChange.StatAmount = default.FOCUS3DEFENSE;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);
	//	focus 3
	StatChanges.Length = 0;
	NewStatChange.StatType = eStat_Offense;
	NewStatChange.StatAmount = default.FOCUS4AIM;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Defense;
	NewStatChange.StatAmount = default.FOCUS4DEFENSE;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, 0);

	Template.AddTargetEffect(FocusEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bShowPostActivation = true;
	Template.bSkipFireAction = true;

	return Template;
}

static function X2AbilityTemplate AddVoltDangerZoneAbility()
{
	local X2AbilityTemplate Template;	

	Template = PurePassive('VoltDangerZone', "img:///UILibrary_LW_PerkPack.LW_AbilityDangerZone", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	Template.PrerequisiteAbilities.AddItem('Volt');
	return Template;
}

static function X2AbilityTemplate AddMeditationKillTracker()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventTrigger;
	local XMBEffect_AddAbilityCharges		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MeditationKillTracker');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_templarFocus";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'KillMail';
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventTrigger);

	Effect = new class'XMBEffect_AddAbilityCharges';
	Effect.AbilityNames.AddItem('Meditation');
	Effect.BonusCharges = 1;
	Effect.MaxCharges = 1;
	Template.AddTargetEffect(Effect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	// Template.MergeVisualizationFn = DesiredVisualizationBlock_MergeVisualization;

	return Template;
}

static function X2AbilityTemplate AddTemplarVigilance()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('TemplarVigilance', "img:///UILibrary_PerkIcons.UIPerk_advent_commandaura", false, 'eAbilitySource_Psionic');
	Template.bCrossClassEligible = false;
	Template.AdditionalAbilities.AddItem('TemplarVigilanceTrigger');
	return Template;
}

static function X2AbilityTemplate AddTemplarVigilanceTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventTrigger;
	local X2Effect_ModifyTemplarFocus		FocusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TemplarVigilanceTrigger');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_templarFocus";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'ScamperEnd';
	EventTrigger.ListenerData.EventFn = TemplarVigilanceListener;
	Template.AbilityTriggers.AddItem(EventTrigger);

	FocusEffect = new class'X2Effect_ModifyTemplarFocus';
	Template.AddTargetEffect(FocusEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	// Template.MergeVisualizationFn = DesiredVisualizationBlock_MergeVisualization;

	return Template;
}

// Listener for the ScamperEnd event that activates vigilance if, and
// only if, the scampering pod has at least VIGILANCE_MIN_POD_SIZE
// members.
static function EventListenerReturn TemplarVigilanceListener(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState_Ability AbilityState;
	local XComGameState_AIGroup GroupState;

	AbilityState = XComGameState_Ability(CallbackData);
	GroupState = XComGameState_AIGroup(EventData);
	if (AbilityState != none && GroupState != none)
	{
		// Was the killing blow dealt by a unit during an interrupt turn?
		if (GroupState.m_arrMembers.Length >= default.VIGILANCE_MIN_POD_SIZE)
		{
			return AbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
		}
	}

	return ELR_NoInterrupt;
}

static function X2AbilityTemplate AddTemplarTerror()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('TemplarTerror', "img:///UILibrary_LW_Overhaul.LW_AbilityNapalmX", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	Template.PrerequisiteAbilities.AddItem('Volt');
	return Template;
}

static function X2DataTemplate AddTerrorPanicAbility()
{
	local X2AbilityTemplate			Template;
	local X2Condition_UnitProperty	UnitPropertyCondition;
	local X2Effect_Panicked			PanicEffect;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit StatCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.PanicImpairingAbilityName);

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
	StatCheck.BaseValue = default.TERROR_STAT_CHECK_BASE_VALUE;
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

static function X2AbilityTemplate AddApotheosis()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityCost_Focus	 		FocusCost;
	local X2Effect_Apotheosis			Effect;
	local FocusLevelModifiers 			EmptyFocusLevelModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Apotheosis');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_andromedon_robotbattlesuit";

	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = 3;
	FocusCost.ConsumeAllFocus = true;
	Template.AbilityCosts.AddItem(FocusCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.APOTHEOSIS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Effect = new class'X2Effect_Apotheosis';
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	// Effect.AddPersistentStatChange(eStat_Dodge, float(default.APOTHEOSIS_DODGE_BONUS));
	Effect.FocusDamageMultiplier = default.APOTHEOSIS_DAMAGE_MULTIPLIER;
	Effect.arrFocusModifiers.AddItem(EmptyFocusLevelModifiers);
	Effect.arrFocusModifiers.AddItem(EmptyFocusLevelModifiers);
	Effect.arrFocusModifiers.AddItem(EmptyFocusLevelModifiers);
	Effect.arrFocusModifiers.AddItem(CreateFocusLevelModifiers(default.APOTHEOSIS_DODGE_BONUS, default.APOTHEOSIS_MOBILITY_BONUS));
	Effect.arrFocusModifiers.AddItem(CreateFocusLevelModifiers(default.APOTHEOSIS_DODGE_BONUS, 2 * default.APOTHEOSIS_MOBILITY_BONUS));
	Template.AddTargetEffect(Effect);

	Template.bSkipFireAction = false;
	Template.CustomFireAnim = 'HL_IonicStorm';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Apotheosis_BuildVisualization;

	// Template.AdditionalAbilities.AddItem('MeditationPreparationPassive');

	return Template;
}

static function Apotheosis_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local StateObjectReference				InteractingUnitRef;
	local VisualizationActionMetadata		EmptyTrack, BuildTrack;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover;
	local XComGameState_Ability				Ability;

	class'X2Ability'.static.TypicalAbility_BuildVisualization(VisualizeGameState);

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
	InteractingUnitRef = Context.InputContext.SourceObject;
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));
	SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Good);
}

static function FocusLevelModifiers CreateFocusLevelModifiers(int DodgeBonus, int MobilityBonus)
{
	local FocusLevelModifiers FocusLevelModifiers;
	local StatChange NewStatChange;

	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = DodgeBonus;
	FocusLevelModifiers.StatChanges.AddItem(NewStatChange);

	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = MobilityBonus;
	FocusLevelModifiers.StatChanges.AddItem(NewStatChange);

	return FocusLevelModifiers;
}

defaultproperties
{
	PanicImpairingAbilityName = "TemplarTerrorPanic"
}
