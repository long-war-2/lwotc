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
var config int OVERCHARGE_AIM_BONUS;
var config int OVERCHARGE_CRIT_BONUS;
var config int APOTHEOSIS_COOLDOWN;
var config int APOTHEOSIS_DODGE_BONUS;
var config int APOTHEOSIS_MOBILITY_BONUS;
var config float APOTHEOSIS_DAMAGE_MULTIPLIER;

var config int AMPLIFY_SHOTS;

var name PanicImpairingAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	//from Udaya
	Templates.AddItem(AddSupremeFocus());
	Templates.AddItem(AddSuperGigaOmegaFocus());
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
	Templates.AddItem(Indomitable());
	Templates.AddItem(AddVoltFocusOnKills());
	Templates.AddItem(VoltFocusKillTracker());
	Templates.AddItem(DoubleRendFocus());
	Templates.AddItem(DoubleRendFocusPassive());
	Templates.AddItem(SingleRendFocus());
	Templates.AddItem(TemplarShield());
	Templates.AddItem(SoulShot());
	Templates.AddItem(class'XComGame.X2Ability_TemplarAbilitySet'.static.Rend('Rend_LW'));
	Templates.AddItem(ArcWave_LW());
	Templates.AddItem(ArcWavePassive_LW());

	
	return Templates;
}

static function X2AbilityTemplate AddSupremeFocus()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('SupremeFocus', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_SupremeFocus", false, 'eAbilitySource_Psionic', false);
	Template.PrerequisiteAbilities.AddItem('DeepFocus');

	return Template;
}


static function X2AbilityTemplate AddSuperGigaOmegaFocus()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('AddSuperGigaOmegaFocus', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_SupremeFocus", false, 'eAbilitySource_Psionic', false);
	Template.PrerequisiteAbilities.AddItem('SupremeFocus');

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
	FlecheBonusDamageEffect.AbilityNames.AddItem('Rend_LW');
	FlecheBonusDamageEffect.AbilityNames.AddItem('ArcWave');
	FlecheBonusDamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
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
	local X2Effect_Overcharge_LW			OverchargeEffect;

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

	OverchargeEffect = new class'X2Effect_Overcharge_LW';
	OverchargeEffect.BuildPersistentEffect(1, true, false);
	OverchargeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false, , Template.AbilitySourceName);
	OverchargeEffect.AimBonusPerFocus = default.OVERCHARGE_AIM_BONUS;
	OverchargeEffect.CritBonusPerFocus = default.OVERCHARGE_CRIT_BONUS;
	Template.AddTargetEffect(OverchargeEffect);

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

	Template = PurePassive('TemplarTerror', "img:///UILibrary_LWOTC.LW_AbilityNapalmX", false, 'eAbilitySource_Perk');
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
	StatCheck.AttackerStat = eStat_Will;
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
	Template.IconImage = "img:///IRIPerkPack_UILibrary_LW.UIPerk_Apotheosis";
	Template.ActivationSpeech = 'IonicStorm';
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
	Effect.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	// Effect.AddPersistentStatChange(eStat_Dodge, float(default.APOTHEOSIS_DODGE_BONUS));
	Effect.FocusDamageMultiplier = default.APOTHEOSIS_DAMAGE_MULTIPLIER;
	Effect.arrFocusModifiers.AddItem(EmptyFocusLevelModifiers);
	Effect.arrFocusModifiers.AddItem(EmptyFocusLevelModifiers);
	Effect.arrFocusModifiers.AddItem(EmptyFocusLevelModifiers);
	Effect.arrFocusModifiers.AddItem(CreateFocusLevelModifiers(default.APOTHEOSIS_DODGE_BONUS, default.APOTHEOSIS_MOBILITY_BONUS));
	Effect.arrFocusModifiers.AddItem(CreateFocusLevelModifiers(2 * default.APOTHEOSIS_DODGE_BONUS, 2 * default.APOTHEOSIS_MOBILITY_BONUS));
	Template.AddTargetEffect(Effect);

	// State and Viz
	Template.Hostility = eHostility_Neutral;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bShowActivation = false; // Don't show flyover, it obscures the fancy animation.
	Template.CustomSelfFireAnim = 'HL_Apotheosis';
	Template.CustomFireAnim = 'HL_Apotheosis';
	Template.CinescriptCameraType = "Templar_Ghost";
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = false;

	return Template;
}

static function X2AbilityTemplate TemplarShield()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Effect_TemplarShieldAnimations		AnimSetEffect;
	local X2Effect_TemplarShield				ShieldedEffect;
	local X2Effect_TemplarShieldCritDefense		AntiFlankEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_TemplarShield');

	// Icon Setup
	Template.IconImage = "img:///IRIPerkPack_UILibrary_LW.UIPerk_TemplarShield";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
 	Template.AddShooterEffectExclusions();

	// Triggering and Targeting
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Costs
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	//ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('Momentum');
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Effects
	AnimSetEffect = new class'X2Effect_TemplarShieldAnimations';
	AnimSetEffect.BuildPersistentEffect(1, false, true,, eGameRule_PlayerTurnBegin);
	AnimSetEffect.AddAnimSetWithPath("IRIParryReworkAnims.Anims.AS_BallisticShield");
	AnimSetEffect.AddAnimSetWithPath("IRIParryReworkAnims.Anims.AS_TemplarShield");
	Template.AddTargetEffect(AnimSetEffect);

	ShieldedEffect = new class'X2Effect_TemplarShield';
	ShieldedEffect.BuildPersistentEffect(1, false, true,, eGameRule_PlayerTurnBegin);
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	ShieldedEffect.EffectName = class'X2Effect_TemplarShield'.default.EffectName;
	Template.AddTargetEffect(ShieldedEffect);

	AntiFlankEffect = new class'X2Effect_TemplarShieldCritDefense';
	AntiFlankEffect.BuildPersistentEffect(1, false, true,, eGameRule_PlayerTurnBegin);
	AntiFlankEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddShooterEffect(AntiFlankEffect);

	// State and Viz
	Template.Hostility = eHostility_Defensive;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bShowActivation = false; // Don't show flyover, it obscures the fancy animation.
	Template.CustomSelfFireAnim = 'HL_Shield_Extend';
	Template.CustomFireAnim = 'HL_Shield_Extend';
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = false;
	Template.OverrideAbilityAvailabilityFn = TemplarShield_OverrideAbilityAvailability;

	Template.OverrideAbilities.AddItem('ParryActivate');
	Template.OverrideAbilities.AddItem('Parry');
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

private static function TemplarShield_OverrideAbilityAvailability(out AvailableAction Action, XComGameState_Ability AbilityState, XComGameState_Unit OwnerState)
{
	if (Action.AvailableCode == 'AA_Success')
	{
		if (OwnerState.ActionPoints.Length == 1 && OwnerState.ActionPoints[0] == 'Momentum')
			Action.ShotHUDPriority = class'UIUtilities_Tactical'.const.PARRY_PRIORITY;
	}
}

static function X2AbilityTemplate SoulShot()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityToHitCalc_StandardAim	ToHitCalc;
	local X2AbilityCost_Focus				FocusCost;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_SoulShot');

	// Icon Setup
	Template.IconImage = "img:///IRIPerkPack_UILibrary_LW.UIPerk_SoulShot";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Target Conditions
	TargetProperty = new class'X2Condition_UnitProperty';
	//TargetProperty.ExcludeRobotic = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Costs
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	FocusCost = new class'X2AbilityCost_Focus';
	FocusCost.FocusAmount = 1;
	Template.AbilityCosts.AddItem(FocusCost);

	// Effects
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.DamageTag = 'IRI_SoulShot';
	//WeaponDamageEffect.bBypassShields = true;
	//WeaponDamageEffect.bIgnoreArmor = true;
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddTargetEffect(new class'X2Effect_SoulShot_ArrowHit');

	// State and Viz
	Template.bShowActivation = false;
	Template.CustomFireAnim = 'HL_SoulShot';
	Template.CustomFireKillAnim = 'HL_SoulShot';
	Template.CustomMovingFireAnim = 'HL_SoulShot';
	Template.CustomMovingFireKillAnim = 'HL_SoulShot';
	Template.CustomMovingTurnLeftFireAnim = 'HL_SoulShot';
	Template.CustomMovingTurnLeftFireKillAnim = 'HL_SoulShot';
	Template.CustomMovingTurnRightFireAnim = 'HL_SoulShot';
	Template.CustomMovingTurnRightFireKillAnim = 'HL_SoulShot';


	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.ActivationSpeech = 'IonicStorm';
	Template.CinescriptCameraType = "IRI_SoulShot";

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.Hostility = eHostility_Offensive;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	return Template;
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


static function X2AbilityTemplate Indomitable()
{
	local X2AbilityTemplate				Template;
	local X2Effect_Indomitable	IndomitableEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Indomitable');

//BEGIN AUTOGENERATED CODE: Template Overrides 'MeditationPreparation'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
//END AUTOGENERATED CODE: Template Overrides 'MeditationPreparation'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_meditation";
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;


	IndomitableEffect = new class'X2Effect_Indomitable';
	Template.AddShooterEffect(IndomitableEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	// Template.AdditionalAbilities.AddItem('MeditationPreparationPassive');

	return Template;
}

static function X2AbilityTemplate AddVoltFocusOnKills()
{
	local X2AbilityTemplate Template;	

	Template = PurePassive('VoltFocusOnKills', "img:///UILibrary_LW_PerkPack.LW_AbilityDangerZone", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	Template.AdditionalAbilities.AddItem('VoltFocusKillTracker');
	return Template;
}

static function X2AbilityTemplate VoltFocusKillTracker()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventTrigger;
	local X2Effect_ModifyTemplarFocus		FocusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'VoltFocusKillTracker');

	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_templarFocus";
//BEGIN AUTOGENERATED CODE: Template Overrides 'FocusKillTracker'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
//END AUTOGENERATED CODE: Template Overrides 'FocusKillTracker'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'KillMail';
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = VoltFocusKillTracker_Listener;
	Template.AbilityTriggers.AddItem(EventTrigger);

	FocusEffect = new class'X2Effect_ModifyTemplarFocus';
	FocusEffect.TargetConditions.AddItem(new class'X2Condition_GhostShooter');
	Template.AddTargetEffect(FocusEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = class'X2Ability_TemplarAbilitySet'.static.DesiredVisualizationBlock_MergeVisualization;

	return Template;
}



static function EventListenerReturn VoltFocusKillTracker_Listener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateContext FindContext;
	local int VisualizeIndex;
	local XComGameStateHistory History;
	local XComGameState_Ability Ability;
	local XComGameState_Unit SourceUnit;

	History = `XCOMHISTORY;

	FindContext = GameState.GetContext();
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

	Ability = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility('VoltFocusKillTracker', AbilityContext.InputContext.ItemObject).ObjectID));
	if (AbilityContext != None && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		if (AbilityContext.InputContext.AbilityTemplateName == 'Volt')
		{
			VisualizeIndex = GameState.HistoryIndex;
			while (FindContext.InterruptionHistoryIndex > -1)
			{
				FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
				VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
			}
			Ability.AbilityTriggerAgainstSingleTarget(SourceUnit.GetReference(), false, VisualizeIndex);
		}
	}
	return ELR_NoInterrupt;
}

	static function X2AbilityTemplate SingleRendFocus()
{
	local X2AbilityTemplate Template;
	local X2Effect_ModifyTemplarFocus FocusEffect;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SingleRendFocus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_advent_commandaura";
	Template.Hostility = eHostility_Neutral;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Overcharge'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
//END AUTOGENERATED CODE: Template Overrides 'Overcharge'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'RendActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	//	Grants Focus on Rend hit
	FocusEffect = new class'X2Effect_ModifyTemplarFocus';
	FocusEffect.TargetConditions.AddItem(new class'X2Condition_GhostShooter');
	Template.AddShooterEffect(FocusEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bShowPostActivation = true;
	Template.bSkipFireAction = true;

	return Template;
}


static function X2AbilityTemplate DoubleRendFocus()
{
	local X2AbilityTemplate Template;
	local X2Effect_ModifyTemplarFocus FocusEffect;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DoubleRendFocus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_advent_commandaura";
	Template.Hostility = eHostility_Neutral;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Overcharge'
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
//END AUTOGENERATED CODE: Template Overrides 'Overcharge'
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AdditionalAbilities.AddItem('DoubleRendFocusPassive');
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'RendActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	//	Grants Focus on Rend hit
	FocusEffect = new class'X2Effect_ModifyTemplarFocus';
	FocusEffect.TargetConditions.AddItem(new class'X2Condition_GhostShooter');
	Template.AddShooterEffect(FocusEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bShowPostActivation = true;
	Template.bSkipFireAction = true;

	return Template;
}

static function X2AbilityTemplate DoubleRendFocusPassive()
{
	local X2AbilityTemplate Template;	

	Template = PurePassive('DoubleRendFocusPassive', "img:///UILibrary_PerkIcons.UIPerk_advent_commandaura", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	return Template;
}

static function X2AbilityTemplate ArcWave_LW()
{
	local X2AbilityTemplate					Template;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;

	Template = Rend('ArcWave_LW');
	Template.OverrideAbilities.AddItem('Rend_LW');
	Template.TargetingMethod = class'X2TargetingMethod_ArcWave';
	Template.ActionFireClass = class'X2Action_Fire_Wave';

	//	These are all handled in the editor if you want to change them!
//BEGIN AUTOGENERATED CODE: Template Overrides 'ArcWave'
	Template.bSkipMoveStop = false;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.CustomFireAnim = 'FF_ArcWave_MeleeA';
	Template.CustomFireKillAnim = 'FF_ArcWave_MeleeKillA';
	Template.CustomMovingFireAnim = 'MV_ArcWave_MeleeA';
	Template.CustomMovingFireKillAnim = 'MV_ArcWave_MeleeKillA';
	Template.CustomMovingTurnLeftFireAnim = 'MV_ArcWave_RunTurn90LeftMeleeA';
	Template.CustomMovingTurnLeftFireKillAnim = 'MV_ArcWave_RunTurn90LeftMeleeKillA';
	Template.CustomMovingTurnRightFireAnim = 'MV_ArcWave_RunTurn90RightMeleeA';
	Template.CustomMovingTurnRightFireKillAnim = 'MV_ArcWave_RunTurn90RightMeleeKillA';
	Template.ActivationSpeech = 'Rend';
	Template.CinescriptCameraType = "Templar_Rend";
	Template.bSkipExitCoverWhenFiring = false;
//END AUTOGENERATED CODE: Template Overrides 'ArcWave'
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	//Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Arcwave";

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.ConeEndDiameter = default.ArcWaveConeEndDiameterTiles * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.ArcWaveConeLengthTiles * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = Sqrt(Square(ConeMultiTarget.ConeEndDiameter / 2) + Square(ConeMultiTarget.ConeLength)) * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.bLockShooterZ = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);

	Template.AddMultiTargetEffect(new class'X2Effect_ArcWaveMultiDamage');
	
	return Template;
}

static function X2AbilityTemplate ArcWavePassive_LW()
{
	local X2AbilityTemplate						Template;

	Template = PurePassive('ArcWavePassive_LW', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Arcwave", , 'eAbilitySource_Psionic');

	Template.AdditionalAbilities.AddItem('ArcWave_LW');
	Template.PrerequisiteAbilities.AddItem('Rend_LW');

	return Template;
}


defaultproperties
{
	PanicImpairingAbilityName = "TemplarTerrorPanic"
}
