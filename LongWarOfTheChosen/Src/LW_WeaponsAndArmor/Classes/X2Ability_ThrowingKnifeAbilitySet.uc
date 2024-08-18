//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_ThrowingKnifeAbilitySet.uc
//  AUTHOR:  Musashi  --  04/18/2016 (copied by Peter Ledbrook)
//  PURPOSE: This is a copy of the throwing-knife abilities from
//           Musashi_CK_AbilitySet.uc in Musashi's Combat Knives mod.
//---------------------------------------------------------------------------------------
class X2Ability_ThrowingKnifeAbilitySet extends XMBAbility
	dependson (XComGameStateContext_Ability) config(LW_SoldierSkills);

var config int KNIFE_JUGGLER_EXTRA_AMMO;
var config int KNIFE_JUGGLER_BONUS_DAMAGE;
var config int HAILSTORM_COOLDOWN;
var config int THOUSAND_DAGGERS_COOLDOWN;
var config int REND_THE_MARKED_CRIT;
var config int IMPERSONAL_EDGE_AIM;
var config int BLUESCREEN_KNIVES_PIERCE;
var config int KNIFE_ENCOUNTERS_MAX_TILES;
var config int KNIFE_ENCOUNTERS_BANISHER_MAX_TILES;
var config array<name> KNIFE_ENCOUNTERS_ABILITY_NAMES;

var localized string RendTheMarkedEffectName;
var localized string RendTheMarkedEffectDesc;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddThrowKnife('MusashiThrowKnifeSecondary_LW'));
	Templates.AddItem(AddKnifeJuggler());
	Templates.AddItem(AddKnifeJugglerTrigger());
	Templates.AddItem(AddHailstorm());
	Templates.AddItem(AddThrowingKnifeFaceoff());
	Templates.AddItem(AddKnifeEncounters());
	Templates.AddItem(AddKnifeEncountersExtendedRange());
	Templates.AddItem(ImpersonalEdgePassive());
	Templates.AddItem(ImpersonalEdge());
	Templates.AddItem(RendTheMarked());
	Templates.AddItem(BlueScreenKnives());

	return Templates;
}

static function X2AbilityTemplate AddHailstorm()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Hailstorm_LW');

	// Icon Properties
	Template.IconImage = "img:///MusashiCombatKnifeMod_LW.UI.UIPerk_hailstorm";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	Template.AddShooterEffectExclusions();

	// Targeting Details
	// Can only shoot visible enemies
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.HAILSTORM_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 3;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = false;
	Template.bAllowBonusWeaponEffects = true;
	Template.bUseAmmoAsChargesForHUD = true;

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;

	// Poison effect if soldier has Poisoned Blades
	AddPoisonedBladesEffect(Template);

	// Targeting Method
	Template.bUsesFiringCamera = true;
	Template.bHideWeaponDuringFire = true;
	Template.SkipRenderOfTargetingTemplate = true;
	Template.TargetingMethod = class'X2TargetingMethod_ThrowingKnife';
	Template.CinescriptCameraType = "StandardGunFiring";

	// Voice events
	Template.ActivationSpeech = 'FanFire';

	// Treat throwing knives as if they're as noisy as moving
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentMoveLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.MoveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MoveLostSpawnIncreasePerUse;

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	

	return Template;	
}

static function X2AbilityTemplate AddThrowingKnifeFaceoff()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCharges                  Charges;
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ThrowingKnifeFaceoff_LW');

	Template.IconImage = "img:///MusashiCombatKnifeMod_LW.UI.UIPerk_faceoff";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bOnlyMultiHitWithSuccess = false;
	Template.AbilityToHitCalc = ToHitCalc;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	// Poison effect if soldier has Poisoned Blades
	AddPoisonedBladesEffect(Template);

	Template.bAllowAmmoEffects = false;
	Template.bAllowBonusWeaponEffects = true;

	Template.bUsesFiringCamera = true;
	Template.bHideWeaponDuringFire = true;
	Template.SkipRenderOfTargetingTemplate = true;
	Template.TargetingMethod = class'X2TargetingMethod_ThrowingKnife';
	Template.CinescriptCameraType = "StandardGunFiring";

	// Treat throwing knives as if they're as noisy as moving
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentMoveLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.MoveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MoveLostSpawnIncreasePerUse;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = ThrowingKnifeFaceoff_BuildVisualization;

	return Template;
}

function ThrowingKnifeFaceoff_BuildVisualization(XComGameState VisualizeGameState)
{
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local StateObjectReference          ShootingUnitRef;
	local X2Action_Fire                 FireAction;
	local X2Action_Fire_Faceoff         FireFaceoffAction;
	local XComGameState_BaseObject      TargetStateObject;//Container for state objects within VisualizeGameState	

	local Actor                     TargetVisualizer, ShooterVisualizer;
	local X2VisualizerInterface     TargetVisualizerInterface;
	local int                       EffectIndex, TargetIndex;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        ActionMetadata;
	local VisualizationActionMetadata        SourceTrack;
	local XComGameStateHistory      History;

	local X2Action_PlaySoundAndFlyOver SoundAndFlyover;
	local name         ApplyResult;

	local X2Action_StartCinescriptCamera CinescriptStartAction;
	local X2Action_EndCinescriptCamera   CinescriptEndAction;
	local X2Camera_Cinescript            CinescriptCamera;
	local string                         PreviousCinescriptCameraType;
	local X2Effect                       TargetEffect;

	local X2Action_MarkerNamed				JoinActions;
	local array<X2Action>					LeafNodes;
	local XComGameStateVisualizationMgr		VisualizationMgr;
	local X2Action_ApplyWeaponDamageToUnit	ApplyWeaponDamageAction;


	History = `XCOMHISTORY;
	VisualizationMgr = `XCOMVISUALIZATIONMGR;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	ShootingUnitRef = Context.InputContext.SourceObject;

	ShooterVisualizer = History.GetVisualizer(ShootingUnitRef.ObjectID);

	SourceTrack = EmptyTrack;
	SourceTrack.StateObject_OldState = History.GetGameStateForObjectID(ShootingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShootingUnitRef.ObjectID);
	if( SourceTrack.StateObject_NewState == none )
		SourceTrack.StateObject_NewState = SourceTrack.StateObject_OldState;
	SourceTrack.VisualizeActor = ShooterVisualizer;

	if( AbilityTemplate.ActivationSpeech != '' )     //  allows us to change the template without modifying this function later
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(SourceTrack, Context));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.ActivationSpeech, eColor_Good);
	}


	// Add a Camera Action to the Shooter's Metadata.  Minor hack: To create a CinescriptCamera the AbilityTemplate 
	// must have a camera type.  So manually set one here, use it, then restore.
	PreviousCinescriptCameraType = AbilityTemplate.CinescriptCameraType;
	AbilityTemplate.CinescriptCameraType = "StandardGunFiring";
	CinescriptCamera = class'X2Camera_Cinescript'.static.CreateCinescriptCameraForAbility(Context);
	CinescriptStartAction = X2Action_StartCinescriptCamera(class'X2Action_StartCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	CinescriptStartAction.CinescriptCamera = CinescriptCamera;
	AbilityTemplate.CinescriptCameraType = PreviousCinescriptCameraType;


	class'X2Action_ExitCover'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded);

	//  Fire at the primary target first
	FireAction = X2Action_Fire(class'X2Action_Fire'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	FireAction.SetFireParameters(Context.IsResultContextHit(), , false);
	//  Setup target response
	TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
	TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);
	ActionMetadata = EmptyTrack;
	ActionMetadata.VisualizeActor = TargetVisualizer;
	TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
	if( TargetStateObject != none )
	{
		History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.PrimaryTarget.ObjectID,
														   ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState,
														   eReturnType_Reference,
														   VisualizeGameState.HistoryIndex);
		`assert(ActionMetadata.StateObject_NewState == TargetStateObject);
	}
	else
	{
		//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
		//and show no change.
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.PrimaryTarget.ObjectID);
		ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
	}

	for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex )
	{
		ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

		// Target effect visualization
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, ApplyResult);

		// Source effect visualization
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
	}
	if( TargetVisualizerInterface != none )
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	ApplyWeaponDamageAction = X2Action_ApplyWeaponDamageToUnit(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', TargetVisualizer));
	if ( ApplyWeaponDamageAction != None)
	{
		VisualizationMgr.DisconnectAction(ApplyWeaponDamageAction);
		VisualizationMgr.ConnectAction(ApplyWeaponDamageAction, VisualizationMgr.BuildVisTree, false, FireAction);
	}

	//  Now configure a fire action for each multi target
	for( TargetIndex = 0; TargetIndex < AbilityContext.MultiTargets.Length; ++TargetIndex )
	{
		// Add an action to pop the previous CinescriptCamera off the camera stack.
		CinescriptEndAction = X2Action_EndCinescriptCamera(class'X2Action_EndCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		CinescriptEndAction.CinescriptCamera = CinescriptCamera;
		CinescriptEndAction.bForceEndImmediately = true;

		// Add an action to push a new CinescriptCamera onto the camera stack.
		AbilityTemplate.CinescriptCameraType = "StandardGunFiring";
		CinescriptCamera = class'X2Camera_Cinescript'.static.CreateCinescriptCameraForAbility(Context);
		CinescriptCamera.TargetObjectIdOverride = AbilityContext.MultiTargets[TargetIndex].ObjectID;
		CinescriptStartAction = X2Action_StartCinescriptCamera(class'X2Action_StartCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		CinescriptStartAction.CinescriptCamera = CinescriptCamera;
		AbilityTemplate.CinescriptCameraType = PreviousCinescriptCameraType;

		// Add a custom Fire action to the shooter Metadata.
		TargetVisualizer = History.GetVisualizer(AbilityContext.MultiTargets[TargetIndex].ObjectID);
		FireFaceoffAction = X2Action_Fire_Faceoff(class'X2Action_Fire_Faceoff'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
		FireFaceoffAction.SetFireParameters(Context.IsResultContextMultiHit(TargetIndex), AbilityContext.MultiTargets[TargetIndex].ObjectID, false);
		FireFaceoffAction.vTargetLocation = TargetVisualizer.Location;


		//  Setup target response
		TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = TargetVisualizer;
		TargetStateObject = VisualizeGameState.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
		if( TargetStateObject != none )
		{
			History.GetCurrentAndPreviousGameStatesForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID,
															   ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState,
															   eReturnType_Reference,
															   VisualizeGameState.HistoryIndex);
			`assert(ActionMetadata.StateObject_NewState == TargetStateObject);
		}
		else
		{
			//If TargetStateObject is none, it means that the visualize game state does not contain an entry for the primary target. Use the history version
			//and show no change.
			ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(AbilityContext.MultiTargets[TargetIndex].ObjectID);
			ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
		}

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityMultiTargetEffects.Length; ++EffectIndex )
		{
			TargetEffect = AbilityTemplate.AbilityMultiTargetEffects[EffectIndex];
			ApplyResult = Context.FindMultiTargetEffectApplyResult(TargetEffect, TargetIndex);

			// Target effect visualization
			AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, ApplyResult);

			// Source effect visualization
			AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, SourceTrack, ApplyResult);
		}
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}

		ApplyWeaponDamageAction = X2Action_ApplyWeaponDamageToUnit(VisualizationMgr.GetNodeOfType(VisualizationMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', TargetVisualizer));
		if( ApplyWeaponDamageAction != None )
		{
			VisualizationMgr.DisconnectAction(ApplyWeaponDamageAction);
			VisualizationMgr.ConnectAction(ApplyWeaponDamageAction, VisualizationMgr.BuildVisTree, false, FireFaceoffAction);
		}
	}
	class'X2Action_EnterCover'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded);

	// Add an action to pop the last CinescriptCamera off the camera stack.
	CinescriptEndAction = X2Action_EndCinescriptCamera(class'X2Action_EndCinescriptCamera'.static.AddToVisualizationTree(SourceTrack, Context, false, SourceTrack.LastActionAdded));
	CinescriptEndAction.CinescriptCamera = CinescriptCamera;

	//Add a join so that all hit reactions and other actions will complete before the visualization sequence moves on. In the case
	// of fire but no enter cover then we need to make sure to wait for the fire since it isn't a leaf node
	VisualizationMgr.GetAllLeafNodes(VisualizationMgr.BuildVisTree, LeafNodes);

	if( VisualizationMgr.BuildVisTree.ChildActions.Length > 0 )
	{
		JoinActions = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(SourceTrack, Context, false, none, LeafNodes));
		JoinActions.SetName("Join");
	}
}

static function X2AbilityTemplate AddKnifeJuggler()
{
	local X2AbilityTemplate Template;
	local X2Effect_AddAmmo AddAmmoEffect;
	local X2Effect_BonusWeaponDamage DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KnifeJuggler_LW');
	Template.IconImage = "img:///MusashiCombatKnifeMod_LW.UIPerk_throwknife";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	AddAmmoEffect = new class 'X2Effect_AddAmmo';
	AddAmmoEffect.ExtraAmmoAmount = default.KNIFE_JUGGLER_EXTRA_AMMO;
	Template.AddTargetEffect(AddAmmoEffect);

	DamageEffect = new class'X2Effect_BonusWeaponDamage';
	DamageEffect.BonusDmg = default.KNIFE_JUGGLER_BONUS_DAMAGE;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	DamageEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(DamageEffect);

	Template.AdditionalAbilities.AddItem('KnifeJugglerTrigger_LW');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate AddThrowKnife(name AbilityName)
{
	local X2AbilityTemplate                   Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Effect_ApplyWeaponDamage          WeaponDamageEffect;
	local array<name>                         SkipExclusions;
	local X2AbilityCost_Ammo                  AmmoCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	// Icon Properties
	Template.IconImage = "img:///MusashiCombatKnifeMod_LW.UIPerk_throwknife";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bUseAmmoAsChargesForHUD = true;

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
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.bAllowBonusWeaponEffects = true;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;

	Template.bUsesFiringCamera = true;
	Template.bHideWeaponDuringFire = true;
	Template.SkipRenderOfTargetingTemplate = true;
	Template.TargetingMethod = class'X2TargetingMethod_ThrowingKnife';
	Template.CinescriptCameraType = "Huntman_ThrowAxe";

	// Poison effect if soldier has Poisoned Blades
	AddPoisonedBladesEffect(Template);
	AddRendTheMarkedEffect(Template);
	AddBlueScreenKnivesEffect(Template);
	// Disabling standard VO for now, until we get axe specific stuff
	Template.TargetKilledByAlienSpeech='';
	Template.TargetKilledByXComSpeech='';
	Template.MultiTargetsKilledByAlienSpeech='';
	Template.MultiTargetsKilledByXComSpeech='';
	Template.TargetWingedSpeech='';
	Template.TargetArmorHitSpeech='';
	Template.TargetMissedSpeech='';

	// Treat throwing knives as if they're as noisy as moving
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentMoveLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.MoveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MoveLostSpawnIncreasePerUse;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function AddPoisonedBladesEffect(X2AbilityTemplate Template)
{
	local X2Condition_AbilityProperty AbilityCondition;
	local X2Effect                    PoisonEffect;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('PoisonedBlades');

	PoisonEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	PoisonEffect.TargetConditions.AddItem(AbilityCondition);

	Template.AddTargetEffect(PoisonEffect);
	Template.AddMultiTargetEffect(PoisonEffect);
}

static function AddRendTheMarkedEffect(X2AbilityTemplate Template)
{
	local X2Condition_AbilityProperty AbilityCondition;
	local X2Effect_ToHitModifier      ToHitModifier;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('RendTheMarked');

	ToHitModifier = new class'X2Effect_ToHitModifier';
	ToHitModifier.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnBegin);
	ToHitModifier.DuplicateResponse = eDupe_Allow;
	ToHitModifier.bApplyAsTarget = true;
	ToHitModifier.SetDisplayInfo(ePerkBuff_Penalty, default.RendTheMarkedEffectName, `XEXPAND.ExpandString(default.RendTheMarkedEffectDesc), "img:///UILibrary_XPerkIconPack.UIPerk_knife_crit");
	ToHitModifier.AddEffectHitModifier(eHit_Crit, default.REND_THE_MARKED_CRIT, default.RendTheMarkedEffectName);
	ToHitModifier.TargetConditions.AddItem(AbilityCondition);

	Template.AddTargetEffect(ToHitModifier);
	Template.AddMultiTargetEffect(ToHitModifier);
}

static function X2AbilityTemplate AddKnifeJugglerTrigger()
{
	local X2AbilityTemplate 			Template;
	local X2Effect_AddAmmo 				AmmoEffect;
	local X2Condition_UnitProperty		UnitPropertyCondition;
	local X2Condition_PrimaryWeapon PrimaryWeaponCondition;

	AmmoEffect = new class'X2Effect_AddAmmo';
	AmmoEffect.ExtraAmmoAmount = 1;

	
	Template = SelfTargetTrigger('KnifeJugglerTrigger_LW', "img:///'BstarsPerkPack_Icons.UIPerk_ScrapMetal'", false, AmmoEffect, 'KillMail');
	    

	PrimaryWeaponCondition = new class'X2Condition_PrimaryWeapon';
	PrimaryWeaponCondition.RequirePrimary = true;
	AddTriggerTargetCondition(Template, PrimaryWeaponCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	AddTriggerTargetCondition(Template, UnitPropertyCondition);

	Template.bShowActivation = true;
	
	return Template;
}

static function X2AbilityTemplate AddKnifeEncounters()
{
	local X2AbilityTemplate							Template;
	local X2Effect_CloseEncounters					ActionEffect;
	//local X2Condition_AbilityProperty				AbilityProperty;
	
	`CREATE_X2ABILITY_TEMPLATE (Template, 'KnifeEncounters');
	Template.IconImage = "img:///MusashiCombatKnifeMod_LW.UI.UIPerk_faceoff";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	ActionEffect = new class 'X2Effect_CloseEncounters';
	ActionEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ActionEffect.BuildPersistentEffect(1, true, false);
	ActionEffect.MaxTiles = default.KNIFE_ENCOUNTERS_MAX_TILES;
	ActionEffect.ApplicableAbilities = default.KNIFE_ENCOUNTERS_ABILITY_NAMES;
	Template.AddTargetEffect(ActionEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Visualization handled in Effect
	return Template;
}


static function X2AbilityTemplate AddKnifeEncountersExtendedRange()
{
	local X2AbilityTemplate							Template;
	local X2Effect_CloseEncounters					ActionEffect;
	//local X2Condition_AbilityProperty				AbilityProperty;

	
	`CREATE_X2ABILITY_TEMPLATE (Template, 'KnifeEncountersExtendedRange');
	Template.IconImage = "img:///MusashiCombatKnifeMod_LW.UI.UIPerk_faceoff";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.OverrideAbilities.AddItem('KnifeEncounters');
	//Template.bIsPassive = true;  // needs to be off to allow perks

	ActionEffect = new class 'X2Effect_CloseEncounters';
	ActionEffect.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ActionEffect.BuildPersistentEffect(1, true, false);
	ActionEffect.MaxTiles = default.KNIFE_ENCOUNTERS_BANISHER_MAX_TILES;
	ActionEffect.ApplicableAbilities = default.KNIFE_ENCOUNTERS_ABILITY_NAMES;
	Template.AddTargetEffect(ActionEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Visualization handled in Effect
	return Template;
}


static function X2AbilityTemplate ImpersonalEdge()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			StatChangeEffect;
	local X2AbilityTrigger_EventListener		EventListenerTrigger;
	local X2Effect_ImpersonalEdge	CooldownReductionEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ImpersonalEdge');
//BEGIN AUTOGENERATED CODE: Template Overrides 'FullThrottle'
	Template.IconImage = "img:///MusashiCombatKnifeMod_LW.UI.UIPerk_hailstorm";
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
	EventListenerTrigger.ListenerData.EventFn = ImpersonalEdgeListener;
	Template.AbilityTriggers.AddItem(EventListenerTrigger);

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.AddPersistentStatChange(eStat_Offense, default.IMPERSONAL_EDGE_AIM);	
	StatChangeEffect.BuildPersistentEffect(3, false, true, false, eGameRule_PlayerTurnEnd);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	StatChangeEffect.EffectName = 'ImpersonalEdgeBuff';
	Template.AddTargetEffect(StatChangeEffect);

	CooldownReductionEffect = new class'X2Effect_ImpersonalEdge';
	Template.AddTargetEffect(CooldownReductionEffect);


	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.AdditionalAbilities.AddItem('ImpersonalEdgePassive');

	return Template;
}


static function X2AbilityTemplate BlueScreenKnives()
{
	local XMBEffect_ConditionalBonus ShootingEffect;
	local X2AbilityTemplate Template;

	// Create an armor piercing bonus
	ShootingEffect = new class'XMBEffect_ConditionalBonus';
	ShootingEffect.EffectName = 'Bluescreenknifepierce';
	ShootingEffect.AddArmorPiercingModifier(default.BLUESCREEN_KNIVES_PIERCE);

	// Only with the associated weapon
	ShootingEffect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);

	// Prevent the effect from applying to a unit more than once
	ShootingEffect.DuplicateResponse = eDupe_Refresh;

	// The effect lasts forever
	ShootingEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	
	// Activated ability that targets user
	Template = Passive('BlueScreenKnives', "img:///UILibrary_XPerkIconPack.UIPerk_gremlin_knife", true, ShootingEffect);

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	return Template;
}

static function AddBlueScreenKnivesEffect(X2AbilityTemplate Template)
{
	local X2Condition_AbilityProperty AbilityCondition;
	local X2Condition_UnitProperty UnitCondition;
	local X2Effect_PersistentStatChange DisorientedEffect;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('BlueScreenKnives');

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = true;
	UnitCondition.IncludeWeakAgainstTechLikeRobot = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.FailOnNonUnits = true;

	DisorientedEffect = CreateRoboticDisorientedStatusEffect();
	DisorientedEffect.TargetConditions.AddItem(UnitCondition);
	DisorientedEffect.TargetConditions.AddItem(AbilityCondition);

	Template.AddTargetEffect(DisorientedEffect);
	Template.AddMultiTargetEffect(DisorientedEffect);
}

static function X2AbilityTemplate ImpersonalEdgePassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('ImpersonalEdgePassive', "img:///MusashiCombatKnifeMod_LW.UI.UIPerk_hailstorm", , 'eAbilitySource_Perk');

	return Template;
}

static function X2AbilityTemplate RendTheMarked()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('RendTheMarked', "img:///UILibrary_XPerkIconPack.UIPerk_knife_crit", , 'eAbilitySource_Perk');

	return Template;
}
static function EventListenerReturn ImpersonalEdgeListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Item ItemState;
	local XComGameState_Ability TriggerAbilityState;


	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	TriggerAbilityState = XComGameState_Ability(CallbackData);

	ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));

	if (AbilityContext != None && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		//	were we the killer?
		if (AbilityContext.InputContext.SourceObject.ObjectID == TriggerAbilityState.OwnerStateObject.ObjectID)
		{
			if(X2WeaponTemplate(ItemState.GetMyTemplate()) != none && X2WeaponTemplate(ItemState.GetMyTemplate()).WeaponCat == 'throwingknife')
			{
				return TriggerAbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
			}
		}
	}

	return ELR_NoInterrupt;
}

static function X2Effect_PersistentStatChange CreateRoboticDisorientedStatusEffect(float DelayVisualizationSec=0.0f)
{
	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = class'X2AbilityTemplateManager'.default.DisorientedName;
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
	PersistentStatChangeEffect.BuildPersistentEffect(class'X2StatusEffects'.default.DISORIENTED_TURNS,, false,,eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.DisorientedFriendlyName, class'X2StatusEffects'.default.DisorientedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, class'X2StatusEffects'.default.DISORIENTED_MOBILITY_ADJUST);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, class'X2StatusEffects'.default.DISORIENTED_AIM_ADJUST);
	PersistentStatChangeEffect.VisualizationFn = class'X2StatusEffects'.static.DisorientedVisualization;
	PersistentStatChangeEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.DisorientedVisualizationTicked;
	PersistentStatChangeEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static. DisorientedVisualizationRemoved;
	PersistentStatChangeEffect.EffectHierarchyValue = class'X2StatusEffects'.default.DISORIENTED_HIERARCHY_VALUE;
	PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
	PersistentStatChangeEffect.bIsImpairingMomentarily = true;
	PersistentStatChangeEffect.EffectAddedFn = class'X2StatusEffects'.static.DisorientedAdded;
	PersistentStatChangeEffect.DelayVisualizationSec = DelayVisualizationSec;

	if (class'X2StatusEffects'.default.DisorientedParticle_Name != "")
	{
		PersistentStatChangeEffect.VFXTemplateName = class'X2StatusEffects'.default.DisorientedParticle_Name;
		PersistentStatChangeEffect.VFXSocket = class'X2StatusEffects'.default.DisorientedSocket_Name;
		PersistentStatChangeEffect.VFXSocketsArrayName = class'X2StatusEffects'.default.DisorientedSocketsArray_Name;
	}

	return PersistentStatChangeEffect;
}