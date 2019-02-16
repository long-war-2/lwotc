//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_ShinobiAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Shinobi-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_ShinobiAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(LW_SoldierSkills);

var config int WHIRLWIND_COOLDOWN;
var config int COUP_DE_GRACE_COOLDOWN;
var config int COUP_DE_GRACE_DISORIENTED_CHANCE;
var config int COUP_DE_GRACE_STUNNED_CHANCE;
var config int COUP_DE_GRACE_UNCONSCIOUS_CHANCE;
var config int TARGET_DAMAGE_CHANCE_MULTIPLIER;

var config int COUP_DE_GRACE_2_HIT_BONUS;
var config int COUP_DE_GRACE_2_CRIT_BONUS;
var config int COUP_DE_GRACE_2_DAMAGE_BONUS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_ShinobiAbilitySet.CreateTemplates --------------------------------");

	Templates.AddItem(AddWhirlwind());
	Templates.AddItem(AddWhirlwindSlash());
	Templates.AddItem(AddCoupDeGraceAbility());
	Templates.AddItem(AddCoupDeGracePassive());
	Templates.AddItem(AddCoupDeGrace2Ability());
	Templates.AddItem(PurePassive('Tradecraft', "img:///UILibrary_LW_Overhaul.LW_AbilityTradecraft", true));
	Templates.AddItem(AddWhirlwind2());
	return Templates;
}


static function X2AbilityTemplate AddCoupDeGrace2Ability()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_CoupdeGrace2				CoupDeGraceEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CoupDeGrace2');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityCoupDeGrace";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	CoupDeGraceEffect = new class'X2Effect_CoupDeGrace2';
	CoupDeGraceEffect.To_Hit_Modifier=default.COUP_DE_GRACE_2_HIT_BONUS;
	CoupDeGraceEffect.Crit_Modifier=default.COUP_DE_GRACE_2_CRIT_BONUS;
	CoupDeGraceEffect.Damage_Bonus=default.COUP_DE_GRACE_2_DAMAGE_BONUS;
	CoupDeGraceEffect.Half_for_Disoriented=true;
	CoupDeGraceEffect.BuildPersistentEffect (1, true, false);
	CoupDeGraceEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(CoupDeGraceEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//based on Slash_LW and Kubikuri
static function X2AbilityTemplate AddCoupDeGraceAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitProperty			UnitCondition;
	local X2AbilityCooldown                 Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CoupDeGrace');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityCoupDeGrace";
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
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.COUP_DE_GRACE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AddShooterEffectExclusions();

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.RequireWithinRange = true;
	UnitCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	UnitCondition.ExcludeRobotic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_CoupDeGrace'); // add condition that requires target to be disoriented, stunned or unconscious

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;

	// VGamepliz matters

	Template.ActivationSpeech = 'CoupDeGrace';
	Template.SourceMissSpeech = 'SwordMiss';

	Template.AdditionalAbilities.AddItem('CoupDeGracePassive');

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddCoupDeGracePassive()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CoupDeGrace				CoupDeGraceEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CoupDeGracePassive');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityCoupDeGrace";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.bIsPassive = true;

	// Coup de Grace effect
	CoupDeGraceEffect = new class'X2Effect_CoupDeGrace';
	CoupDeGraceEffect.DisorientedChance = default.COUP_DE_GRACE_DISORIENTED_CHANCE;
	CoupDeGraceEffect.StunnedChance = default.COUP_DE_GRACE_STUNNED_CHANCE;
	CoupDeGraceEffect.UnconsciousChance = default.COUP_DE_GRACE_UNCONSCIOUS_CHANCE;
	CoupDeGraceEffect.TargetDamageChanceMultiplier = default.TARGET_DAMAGE_CHANCE_MULTIPLIER;
	CoupDeGraceEffect.BuildPersistentEffect (1, true, false);
	Template.AddTargetEffect(CoupDeGraceEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddWhirlwind2()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Whirlwind2				WhirlwindEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Whirlwind2');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_riposte";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	WhirlwindEffect = new class'X2Effect_Whirlwind2';
    WhirlwindEffect.BuildPersistentEffect(1, true, false, false);
    WhirlwindEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
    WhirlwindEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(WhirlwindEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// No visualization function

	return Template;
}


//Based on Implacable and Bladestorm
//whirlwind is deprecated ability (couldn't get visualization to work)
// gamestate code works, but visualization is glitchy-looking
static function X2AbilityTemplate AddWhirlwind()
{

	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Whirlwind				WhirlwindEffect;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Whirlwind');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityWhirlwind";
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.WHIRLWIND_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// *** VALIDITY CHECKS *** //
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Action Point -- requires all points to activate -- refunds a move action in the effect
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1; // requires a full action
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	WhirlwindEffect = new class 'X2Effect_Whirlwind';
	WhirlwindEffect.BuildPersistentEffect (1, false, true);
	WhirlwindEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (WhirlwindEffect);

	Template.AdditionalAbilities.AddItem('WhirlwindSlash');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Whirlwind_BuildVisualization;

	return Template;
}

//whirlwind is deprecated ability (couldn't get visualization to work)
// WOTC TODO: Templar has Momentum which does the same thing. Perhaps we can use it?
function Whirlwind_BuildVisualization(XComGameState VisualizeGameState)
{

}

// this is the free attack action, only triggerable by the listener set up by Whirlwind
//whirlwind was deprecated because we couldn't get a visualization to work
static function X2AbilityTemplate AddWhirlwindSlash()
{
	local X2AbilityTemplate                 Template;
	local array<name>                       SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'WhirlwindSlash');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityWhirlwind";
	Template.CinescriptCameraType = "Ranger_Reaper";

	//free standard damage melee attack
	Template.AbilityCosts.AddItem(default.FreeActionCost);
	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

	//Triggered by persistent effect from Whirlwind only
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions -- re-add these in case something gets applied via reaction
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	Template.bAllowBonusWeaponEffects = true;
	//Template.bSkipMoveStop = true;

	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = WhirlwindSlash_BuildVisualization;

	return Template;
}

//whirlwind was deprecated because we couldn't get a visualization to work
function WhirlwindSlash_BuildVisualization(XComGameState VisualizeGameState)
{
	//local X2AbilityTemplate             AbilityTemplate;
	//local XComGameStateContext_Ability  Context;
	//local AbilityInputContext           AbilityContext;
	//local StateObjectReference          ShootingUnitRef;
	//local X2Action_Fire                 FireAction;
	//local X2Action_Fire_Faceoff         FireFaceoffAction;
	//local XComGameState_BaseObject      TargetStateObject;//Container for state objects within VisualizeGameState
	//
	//local Actor                     TargetVisualizer, ShooterVisualizer;
	//local X2VisualizerInterface     TargetVisualizerInterface;
	//local int                       EffectIndex, TargetIndex;
//
	//local VisualizationActionMetadata   EmptyTrack;
	//local VisualizationActionMetadata   BuildTrack;
	//local VisualizationActionMetadata   SourceTrack;
	//local XComGameStateHistory      History;
//
	//local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	//local name         ApplyResult;
//
	//local X2Action_StartCinescriptCamera CinescriptStartAction;
	//local X2Action_EndCinescriptCamera   CinescriptEndAction;
	//local X2Camera_Cinescript            CinescriptCamera;
	//local string                         PreviousCinescriptCameraType;
	//local X2Effect                       TargetEffect;
//
//
	//History = `XCOMHISTORY;
	//Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	//AbilityContext = Context.InputContext;
	//AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	//ShootingUnitRef = Context.InputContext.SourceObject;
//
	//ShooterVisualizer = History.GetVisualizer(ShootingUnitRef.ObjectID);
//
	//SourceTrack = EmptyTrack;
	//SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	//SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	//if (SourceTrack.StateObject_NewState == none)
		//SourceTrack.StateObject_NewState = SourceTrack.StateObject_OldState;
	//SourceTrack.VisualizeActor = ShooterVisualizer;
//
	//if (AbilityTemplate.ActivationSpeech != '')     //  allows us to change the template without modifying this function later
	//{
		//SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		//SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.ActivationSpeech, eColor_Good);
	//}
//
//
	//// Add a Camera Action to the Shooter's track.  Minor hack: To create a CinescriptCamera the AbilityTemplate
	//// must have a camera type.  So manually set one here, use it, then restore.
	//PreviousCinescriptCameraType = AbilityTemplate.CinescriptCameraType;
	//AbilityTemplate.CinescriptCameraType = "StandardGunFiring";
	//CinescriptCamera = class'X2Camera_Cinescript'.static.CreateCinescriptCameraForAbility(Context);
	//CinescriptStartAction = X2Action_StartCinescriptCamera( class'X2Action_StartCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded ) );
	//CinescriptStartAction.CinescriptCamera = CinescriptCamera;
	//AbilityTemplate.CinescriptCameraType = PreviousCinescriptCameraType;
//
//
	//class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded);
	//
	////  Fire at the primary target first
	//FireAction = X2Action_Fire(class'X2Action_Fire'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	//FireAction.SetFireParameters(Context.IsResultContextHit(), , false);
	////  Setup target response
	//TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
	//TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);
	//BuildTrack = EmptyTrack;
	//BuildTrack.VisualizeActor = TargetVisualizer;
	//TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
	//if( TargetStateObject != none )
	//{
		//History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.PrimaryTarget.ObjectID,
															//BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState,
															//eReturnType_Reference,
															//VisualizeGameState.HistoryIndex);
		//`assert(BuildTrack.StateObject_NewState == TargetStateObject);
	//}
	//else
	//{
		////If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
		////and show no change.
		//BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
		//BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
	//}
	//class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);
	//for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
	//{
		//ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);
//
		//// Target effect visualization
		//AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);
//
		//// Source effect visualization
		//AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
	//}
	//if( TargetVisualizerInterface != none )
	//{
		////Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		//TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
	//}
	//
	////  Now configure a fire action for each multi target
	//for (TargetIndex = 0; TargetIndex < AbilityContext.MultiTargets.Length; ++TargetIndex)
	//{
		//// Add an action to pop the previous CinescriptCamera off the camera stack.
		//CinescriptEndAction = X2Action_EndCinescriptCamera( class'X2Action_EndCinescriptCamera'.static.AddToVisualizationTree( SourceTrack, Context, false, SourceTrack.LastActionAdded ) );
		//CinescriptEndAction.CinescriptCamera = CinescriptCamera;
		//CinescriptEndAction.bForceEndImmediately = true;
//
		//// Add an action to push a new CinescriptCamera onto the camera stack.
		//AbilityTemplate.CinescriptCameraType = "StandardGunFiring";
		//CinescriptCamera = class'X2Camera_Cinescript'.static.CreateCinescriptCameraForAbility(Context);
		//CinescriptCamera.TargetObjectIdOverride = AbilityContext.MultiTargets[TargetIndex].ObjectID;
		//CinescriptStartAction = X2Action_StartCinescriptCamera( class'X2Action_StartCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded ) );
		//CinescriptStartAction.CinescriptCamera = CinescriptCamera;
		//AbilityTemplate.CinescriptCameraType = PreviousCinescriptCameraType;
//
		//// Add a custom Fire action to the shooter track.
		//TargetVisualizer = History.GetVisualizer(AbilityContext.MultiTargets[TargetIndex].ObjectID);
		//FireFaceoffAction = X2Action_Fire_Faceoff(class'X2Action_Fire_Faceoff'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		//FireFaceoffAction.SetFireParameters(Context.IsResultContextMultiHit(TargetIndex), AbilityContext.MultiTargets[TargetIndex].ObjectID, false);
		//FireFaceoffAction.vTargetLocation = TargetVisualizer.Location;
//
//
		////  Setup target response
		//TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);
		//BuildTrack = EmptyTrack;
		//BuildTrack.VisualizeActor = TargetVisualizer;
		//TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
		//if( TargetStateObject != none )
		//{
			//History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID,
																//BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState,
																//eReturnType_Reference,
																//VisualizeGameState.HistoryIndex);
			//`assert(BuildTrack.StateObject_NewState == TargetStateObject);
		//}
		//else
		//{
			////If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
			////and show no change.
			//BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
			//BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
		//}
//
		//// Add WaitForAbilityEffect. To avoid time-outs when there are many targets, set a custom timeout
		//class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded);
		//BuildTrack.TrackActions[BuildTrack.TrackActions.Length - 1].SetCustomTimeoutSeconds((10 + (10 * TargetIndex )));
//
		//for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityMultiTargetEffects.Length; ++EffectIndex)
		//{
			//TargetEffect = AbilityTemplate.AbilityMultiTargetEffects[EffectIndex];
			//ApplyResult = Context.FindMultiTargetEffectApplyResult(TargetEffect, TargetIndex);
//
			//// Target effect visualization
			//AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, BuildTrack, ApplyResult);
//
			//// If the last Effect applied was weapon damage, then a weapon damage Action was added to the track.
			//// Find that weapon damage action, and extend its timeout so that we won't timeout if there are many
			//// targets to visualize before this one.
			//if ( X2Effect_ApplyWeaponDamage(TargetEffect) != none )
			//{
				//if ( X2Action_ApplyWeaponDamageToUnit(BuildTrack.TrackActions[BuildTrack.TrackActions.Length - 1]) != none)
				//{
					//BuildTrack.TrackActions[BuildTrack.TrackActions.Length - 1].SetCustomTimeoutSeconds((10 + (10 * TargetIndex )));
				//}
			//}
//
			//// Source effect visualization
			//AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
		//}
		//if( TargetVisualizerInterface != none )
		//{
			////Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			//TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, BuildTrack);
		//}
	//}
	//class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded);
//
	//// Add an action to pop the last CinescriptCamera off the camera stack.
	//CinescriptEndAction = X2Action_EndCinescriptCamera( class'X2Action_EndCinescriptCamera'.static.AddToVisualizationTree( SourceTrack, Context, false, SourceTrack.LastActionAdded ) );
	//CinescriptEndAction.CinescriptCamera = CinescriptCamera;
//
}
