//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_ReaperAbilitySet_LW
//  AUTHOR:  martox
//  PURPOSE: New Reaper abilities added by LWOTC.
//--------------------------------------------------------------------------------------- 

class X2Ability_ReaperAbilitySet_LW extends X2Ability config(LW_FactionBalance);

var config int LINGERING_DURATION;
var config int LINGERING_DEFENSE;
var config int LINGERING_DODGE;

var config int CRIPPLING_STRIKE_COOLDOWN;

var config int TrackingRadius;

var config int BloodTrailBleedingTurns;
var config int BloodTrailBleedingDamage;
var config int BloodTrailBleedingChance;

var config int DisablingShotCooldown;
var config int DisablingShotAmmoCost;
var config int DisablingShotBaseStunActions;
var config int DisablingShotCritStunActions;
var config float DisablingShotDamagePenalty;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddLingeringShadow());
	Templates.AddItem(AddLingeringShadowTrigger());
	Templates.AddItem(AddRemoveShadowOnConcealmentLostTrigger());
	Templates.AddItem(AddTracking());
	Templates.AddItem(AddTrackingTrigger());
	Templates.AddItem(AddTrackingSpawnTrigger());
	Templates.AddItem(AddDistraction_LW());
	Templates.AddItem(AddClaymoreDisorient());
	Templates.AddItem(AddBloodTrailBleedingAbility());
	Templates.AddItem(AddDisablingShot());
	Templates.AddItem(AddDisablingShotCritRemoval());
	Templates.AddItem(AddDemolitionist());
	Templates.AddItem(AddSilentKillerCooldownReduction());
	Templates.AddItem(AddCripplingStrike());

	return Templates;
}

static function X2AbilityTemplate AddLingeringShadow()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('LingeringShadow', "img:///UILibrary_LW_Overhaul.PerkIcons.UIPerk_LingeringShadow", false);
	Template.AdditionalAbilities.AddItem('LingeringShadowTrigger');

	return Template;
}


static function X2AbilityTemplate AddLingeringShadowTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Effect_PersistentStatChange		DefensiveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LingeringShadowTrigger');

	Template.IconImage = "img:///UILibrary_LW_Overhaul.PerkIcons.UIPerk_LingeringShadow";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Trigger on Shadow expiring (at the beginning of the turn)
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'ShadowExpired';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	DefensiveEffect = new class'X2Effect_PersistentStatChange';
	DefensiveEffect.EffectName = 'LingeringShadowDefense';
	DefensiveEffect.BuildPersistentEffect(default.LINGERING_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	DefensiveEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	DefensiveEffect.AddPersistentStatChange(eStat_Defense, default.LINGERING_DEFENSE);
	DefensiveEffect.AddPersistentStatChange(eStat_Dodge, default.LINGERING_DODGE);
	DefensiveEffect.bRemoveWhenTargetDies = true;
	DefensiveEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(DefensiveEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}

static function X2AbilityTemplate AddRemoveShadowOnConcealmentLostTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Effect_RemoveEffects			RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RemoveShadowOnConcealmentLostTrigger');

	Template.IconImage = "img:///UILibrary_LW_Overhaul.PerkIcons.UIPerk_LingeringShadow";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Trigger on losing concealment so that we can remove the temporary
	// concealment effect.
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	// Remove the temporary Shadow concealment effect if Shadow is lost from
	// concealment being broken.
	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('TemporaryShadowConcealment');
	RemoveEffects.bApplyOnHit = true;
	RemoveEffects.bApplyOnMiss = true;
	Template.AddShooterEffect(RemoveEffects);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}

static function X2AbilityTemplate AddTracking()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('Hero_Tracking', "img:///HeroClassesReb.UIPerk_tracking", true);
	Template.AdditionalAbilities.AddItem('Hero_TrackingTrigger');
	Template.AdditionalAbilities.AddItem('Hero_TrackingSpawnTrigger');

	return Template;
}

static function X2AbilityTemplate AddTrackingTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local XMBEffect_RevealUnit_LW			TrackingEffect;
	local X2Condition_UnitProperty			TargetProperty;
	local X2Condition_UnitEffects			EffectsCondition;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Hero_TrackingTrigger');

	Template.IconImage = "img:///HeroClassesReb.UIPerk_tracking";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsNotPlayerControlled');
	Template.AbilityShooterConditions.AddItem(EffectsCondition);

	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.TrackingRadius;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(TargetProperty);

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect(class'X2Effect_Burrowed'.default.EffectName, 'AA_UnitIsBurrowed');
	Template.AbilityMultiTargetConditions.AddItem(EffectsCondition);

	TrackingEffect = new class'XMBEffect_RevealUnit_LW';
	TrackingEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Template.AddMultiTargetEffect(TrackingEffect);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'PlayerTurnBegun';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Player;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.bSkipFireAction = true;
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// This triggers whenever a unit is spawned within tracking radius. The most likely
// reason for this to happen is a Faceless transforming due to tracking being applied.
// The newly spawned Faceless unit won't have the tracking effect when this happens,
// so we apply it here.
static function X2AbilityTemplate AddTrackingSpawnTrigger()
{
	local X2AbilityTemplate					Template;
	local XMBEffect_RevealUnit_LW			TrackingEffect;
	local X2Condition_UnitProperty			TargetProperty;
	local X2AbilityTrigger_EventListener	EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Hero_TrackingSpawnTrigger');

	Template.IconImage = "img:///UILibrary_SOHunter.UIPerk_tracking";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = default.TrackingRadius * class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	TrackingEffect = new class'XMBEffect_RevealUnit_LW';
	TrackingEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Template.AddTargetEffect(TrackingEffect);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitSpawned';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	EventListener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.bSkipFireAction = true;
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddDistraction_LW()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ClaymoreDistraction			ClaymoreDistractionEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Distraction_LW');	
	
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_distraction";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AdditionalAbilities.AddItem('ClaymoreDisorient');

	ClaymoreDistractionEffect = new class'X2Effect_ClaymoreDistraction';
	ClaymoreDistractionEffect.AbilityToTrigger = 'ClaymoreDisorient';
	ClaymoreDistractionEffect.BuildPersistentEffect(1, true, false);
	ClaymoreDistractionEffect.SetDisplayInfo(
		ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription,
		Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(ClaymoreDistractionEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	return Template;	
}

static function X2AbilityTemplate AddClaymoreDisorient()
{
	local X2AbilityTemplate				Template;
	local X2AbilityMultiTarget_Radius	RadiusMultiTarget;
	local X2Condition_UnitProperty		UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ClaymoreDisorient');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.fTargetRadius = class'X2Ability_ReaperAbilitySet'.default.HomingMineRadius;
	RadiusMultiTarget.AddAbilityBonusRadius('Shrapnel', class'X2Ability_ReaperAbilitySet'.default.HomingShrapnelBonusRadius);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false));

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = ClaymoreDisorient_MergeVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

	return Template;
}

// Copied and modified from HomingMineDetonation_MergeVisualization
//
// Makes sure the disorient effect and flyover appear after the Claymore explosion.
static function ClaymoreDisorient_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisMgr;
	local Array<X2Action> DamageActions;
	local int ScanAction;
	local X2Action_ApplyWeaponDamageToTerrain TestDamage;
	local X2Action_MarkerNamed NamedMarkerAction;
	local X2Action_MarkerNamed PlaceWithAction;
	local X2Action_MarkerTreeInsertBegin MarkerStart;
	local XComGameStateContext_Ability Context;
	local XComGameState_Destructible Destructible;

	VisMgr = `XCOMVISUALIZATIONMGR;

	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	Context = XComGameStateContext_Ability(MarkerStart.StateChangeContext);

	// Jwats: Find the apply weapon damage to unit that caused us to explode and put our visualization with it
	// WaitForFireEvent = X2Action_WaitForAbilityEffect(VisMgr.GetNodeOfType(BuildTree, class'X2Action_AbilityPerkStart'));
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', DamageActions, , Context.InputContext.PrimaryTarget.ObjectID);
	for (ScanAction = 0; ScanAction < DamageActions.Length; ++ScanAction)
	{
		TestDamage = X2Action_ApplyWeaponDamageToTerrain(DamageActions[ScanAction]);
		Destructible = XComGameState_Destructible(TestDamage.MetaData.StateObject_NewState);
		if (Destructible != none &&
			InStr(Destructible.SpawnedDestructibleArchetype, "ReaperClaymore.Archetypes.ARC_ReaperClaymore") != INDEX_NONE)
		{
			break;
		}
	}

	for (ScanAction = 0; ScanAction < TestDamage.ChildActions.Length; ++ScanAction)
	{
		NamedMarkerAction = X2Action_MarkerNamed(TestDamage.ChildActions[ScanAction]);
		if (NamedMarkerAction.MarkerName == 'Join')
		{
			PlaceWithAction = NamedMarkerAction;
			break;
		}
	}

	if (PlaceWithAction != none)
	{
		VisMgr.DisconnectAction(MarkerStart);
		VisMgr.ConnectAction(MarkerStart, VisualizationTree, false, PlaceWithAction);
	}
	else
	{
		Context.SuperMergeIntoVisualizationTree(BuildTree, VisualizationTree);
	}
}

static function X2DataTemplate AddBloodTrailBleedingAbility()
{
	local X2AbilityTemplate Template;
	local X2Effect_Persistent BleedingEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ApplyBloodTrailBleeding');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(default.BloodTrailBleedingTurns, default.BloodTrailBleedingDamage);
	BleedingEffect.ApplyChance = default.BloodTrailBleedingChance;
	Template.AddTargetEffect(BleedingEffect);

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddDisablingShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2Condition_Visibility			VisibilityCondition;
	local X2Effect_DisablingShotStunned		StunEffect;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_UnitType				ImmuneUnitCondition;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'DisablingShot');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityElectroshock";
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
	Template.AdditionalAbilities.AddItem('DisablingShotCritRemoval');

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;

	StunEffect = CreateDisablingShotStunnedEffect(default.DisablingShotBaseStunActions);
	StunEffect.BonusStunActionsOnCrit = default.DisablingShotCritStunActions;
	Template.AddTargetEffect(StunEffect);

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 0;
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Can't target dead; Can't target friendlies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	ImmuneUnitCondition = new class'X2Condition_UnitType';
	ImmuneUnitCondition.ExcludeTypes.AddItem('PsiZombie');
	ImmuneUnitCondition.ExcludeTypes.AddItem('AdvPsiWitchM2');
	ImmuneUnitCondition.ExcludeTypes.AddItem('AdvPsiWitchM3');
	Template.AbilityTargetConditions.AddItem(ImmuneUnitCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DisablingShotCooldown;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.DisablingShotAmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2Effect_DisablingShotStunned CreateDisablingShotStunnedEffect(int StunLevel)
{
	local X2Effect_DisablingShotStunned StunnedEffect;
	local X2Condition_UnitProperty UnitPropCondition;

	StunnedEffect = new class'X2Effect_DisablingShotStunned';
	StunnedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_UnitGroupTurnBegin);
	StunnedEffect.ApplyChance = 100;
	StunnedEffect.StunLevel = StunLevel;
	StunnedEffect.bIsImpairing = true;
	StunnedEffect.EffectHierarchyValue = class'X2StatusEffects'.default.STUNNED_HIERARCHY_VALUE;
	StunnedEffect.EffectName = class'X2AbilityTemplateManager'.default.StunnedName;
	StunnedEffect.VisualizationFn = class'X2StatusEffects'.static.StunnedVisualization;
	StunnedEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationTicked;
	StunnedEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationRemoved;
	StunnedEffect.EffectRemovedFn = class'X2StatusEffects'.static.StunnedEffectRemoved;
	StunnedEffect.bRemoveWhenTargetDies = true;
	StunnedEffect.bCanTickEveryAction = true;

	if (class'X2StatusEffects'.default.StunnedParticle_Name != "")
	{
		StunnedEffect.VFXTemplateName = class'X2StatusEffects'.default.StunnedParticle_Name;
		StunnedEffect.VFXSocket = class'X2StatusEffects'.default.StunnedSocket_Name;
		StunnedEffect.VFXSocketsArrayName = class'X2StatusEffects'.default.StunnedSocketsArray_Name;
	}

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = false;
	UnitPropCondition.FailOnNonUnits = true;
	StunnedEffect.TargetConditions.AddItem(UnitPropCondition);

	return StunnedEffect;
}

// Passive ability that applies an effect that converts crits to normal
// hits if the current ability is DisablingShot.
static function X2AbilityTemplate AddDisablingShotCritRemoval()
{
	local X2AbilityTemplate Template;
	local X2Effect_CritRemoval CritRemovalEffect;
	local X2Effect_AbilityDamageMult DamageReductionEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DisablingShotCritRemoval');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	CritRemovalEffect = new class'X2Effect_CritRemoval';
	CritRemovalEffect.AbilityToActOn = 'DisablingShot';
	Template.AddShooterEffect(CritRemovalEffect);

	// Also add damage reduction, similar to Kubikiri on a non-crit, but
	// applies to all damage types.
	DamageReductionEffect = new class'X2Effect_AbilityDamageMult';
	DamageReductionEffect.Mult = true;
	DamageReductionEffect.Penalty = true;
	DamageReductionEffect.DamageMod = default.DisablingShotDamagePenalty;
	DamageReductionEffect.ActiveAbility = 'DisablingShot';
	Template.AddShooterEffect(DamageReductionEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddDemolitionist()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('Demolitionist', "img:///UILibrary_LW_Overhaul.PerkIcons.UIPerk_Demolitionist", true);
	Template.PrerequisiteAbilities.AddItem('RemoteStart');

	return Template;
}

static function X2AbilityTemplate AddSilentKillerCooldownReduction()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Effect_ReduceCooldowns ReduceCooldownsEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SilentKillerCooldownReduction');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_silentkiller";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Trigger on Shadow expiring (at the beginning of the turn)
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'SilentKillerActivated';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	ReduceCooldownsEffect = new class'X2Effect_ReduceCooldowns';
	ReduceCooldownsEffect.AbilitiesToTick.AddItem('Shadow');
	Template.AddTargetEffect(ReduceCooldownsEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// No visualization on purpose!

	return Template;
}

static function X2DataTemplate AddCripplingStrike()
{
	local X2AbilityTemplate					Template;
	local X2AbilityToHitCalc_StandardAim	ToHitCalc;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2Condition_Visibility			VisibilityCondition;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local array<name>                       SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CripplingStrike');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.UIPerk_CripplingStrike";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
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

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddTargetEffect(class'X2StatusEffects_LW'.static.CreateMaimedStatusEffect(, Template.AbilitySourceName));

	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.CRIPPLING_STRIKE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowBonusWeaponEffects = true;
	Template.bUseAmmoAsChargesForHUD = true;

	// Can't target dead; Can't target friendlies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}
