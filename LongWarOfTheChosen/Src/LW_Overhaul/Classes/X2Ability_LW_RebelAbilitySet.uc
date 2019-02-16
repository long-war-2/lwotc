//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_RebelAbilitySet.uc
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: Defines all Long War special ability for rebel units (incl. faceless rebels)
//---------------------------------------------------------------------------------------

class X2Ability_LW_RebelAbilitySet extends X2Ability config(LW_SoldierSkills);

// This is unfortunately private in the faceless ability set so we need a copy.
var privatewrite name ChangeFormCheckEffectName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	`LWTrace("  >> X2Ability_LW_RebelAbilitySet.CreateTemplates()");
	
	Templates.AddItem(CreateRebelChangeFormAbility());
	return Templates;
}

// 'Rebel' Change Form ability. Almost entirely a copy/paste of the civilian change form,
// except the rebel faceless don't reveal themselves when all other alien units are dead.
static function X2AbilityTemplate CreateRebelChangeFormAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2Condition_UnitValue NotAlreadyChangedFormCondition;
	local array<name> SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RebelChangeForm');

	Template.AdditionalAbilities.AddItem('ChangeFormSawEnemy');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.none";

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = class'X2Ability_Faceless'.default.CIVILIAN_MORPH_RANGE_METERS;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Only triggers from player controlled units moving in range
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.IsPlayerControlled = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	// May change form if the unit is burning or disoriented
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//If two of the following triggers occur simultaneously, the ability may try to trigger twice before the civilian unit is removed.
	//This conditional will catch and prevent this from happening.
	NotAlreadyChangedFormCondition = new class'X2Condition_UnitValue';
	NotAlreadyChangedFormCondition.AddCheckValue(class'X2Effect_SpawnFaceless'.default.SpawnedUnitValueName, 0);
	Template.AbilityShooterConditions.AddItem(NotAlreadyChangedFormCondition);

	// This ability fires when an enemy unit moves within range
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.CheckForVisibleMovementInRadius_Self;
	Trigger.ListenerData.EventID = 'UnitMoveFinished';
	Template.AbilityTriggers.AddItem(Trigger);
	
	// This ability fires can when the unit takes damage
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	// This ability fires can when the unit passes a check after seeing an enemy
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = class'X2Ability_Faceless'.default.ChangeFormTriggerEventName;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.AddTargetEffect(new class'X2Effect_SpawnFaceless');

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem(default.ChangeFormCheckEffectName);
	Template.AddTargetEffect(RemoveEffects);

	Template.AddMultiTargetEffect(new class'X2Effect_BreakUnitConcealment');

	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Always;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_Faceless'.static.ChangeForm_BuildVisualization;
	Template.CinescriptCameraType = "Faceless_ChangeForm";

	return Template;
}

DefaultProperties
{
	ChangeFormCheckEffectName="ChangeFormCheckEffect"
}

