class X2Ability_LW_PsiOperativeAbilitySet extends X2Ability config(LW_SoldierSkills);

var config int SOLACE_ACTION_POINTS;
var config int SOLACE_COOLDOWN;
var config int PHASEWALK_ACTIONPOINTS;
var config int PHASEWALK_COOLDOWN_TURNS;
var config int PHASEWALK_CHARGES;
var config int PHASEWALK_CAST_RANGE_TILES;
var config bool PHASEWALK_TARGET_TILE_MUST_BE_REVEALED;
var config bool PHASEWALK_IS_FREE_ACTION;
var config bool PHASEWALK_ENDS_TURN;
var config bool PHASEWALK_CAN_BE_USED_WHILE_DISORIENTED;
var config bool PHASEWALK_CAN_BE_USED_WHILE_BURNING;

var config int NULLWARD_ACTIONPOINTS;
var config bool NULLWARD_IS_FREE_ACTION;
var config bool NULLWARD_ENDS_TURN;
var config int NULLWARD_COOLDOWN_TURNS;
var config int NULLWARD_CHARGES;
var config bool NULLWARD_CAN_BE_USED_WHILE_DISORIENTED;
var config bool NULLWARD_CAN_BE_USED_WHILE_BURNING;
var config int NULLWARD_CAST_RADIUS_METERS;
var config int NULL_WARD_BASE_SHIELD;
var config int NULL_WARD_AMP_MG_SHIELD_BONUS;
var config int NULL_WARD_AMP_BM_SHIELD_BONUS;

var config int SOULSTORM_ACTIONPOINTS;
var config bool SOULSTORM_IS_FREE_ACTION;
var config bool SOULSTORM_ENDS_TURN;
var config int SOULSTORM_COOLDOWN_TURNS;
var config int SOULSTORM_CHARGES;
var config bool SOULSTORM_CAN_BE_USED_WHILE_DISORIENTED;
var config bool SOULSTORM_CAN_BE_USED_WHILE_BURNING;
var config int SOULSTORM_CAST_RADIUS_METERS;
var config int SOULSTORM_CAST_RANGE_TILES;
var config bool SOULSTORM_TARGET_TILE_MUST_BE_REVEALED;
var config bool SOULSTORM_CAN_TARGET_ALLIES;
var config WeaponDamageValue SOULSTORM_DAMAGE;
var config bool SOULSTORM_IGNORES_ARMOR;
var config int SOULSTORM_ENVIRONMENAL_RADIUS;
var config int SOULSTORM_ENVIRONMENAL_DAMAGE;
var config bool SOULSTORM_SPARES_CEILINGS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_PsiOperativeAbilitySet.CreateTemplates --------------------------------");

	Templates.AddItem(PurePassive('QuickStudy', "img:///UILibrary_PerkIcons.UIPerk_mentalstrength", true));
	Templates.AddItem(AddSolace_LWAbility());
	Templates.AddItem(Create_PhaseWalk());
	Templates.AddItem(Create_AnimSet_Passive('LW_PhaseWalk_Anim', "LW_PsiOverhaul.Anims.AS_Teleport"));
	Templates.AddItem(Create_NullWard());
	Templates.AddItem(Create_AnimSet_Passive('LW_NullWard_Anim', "LW_PsiOverhaul.Anims.AS_NullWard"));
	Templates.AddItem(Create_SoulStorm());
	Templates.AddItem(Create_AnimSet_Passive('LW_SoulStorm_Anim', "LW_PsiOverhaul.Anims.AS_SoulStorm"));

	return Templates;
}

static function X2AbilityTemplate AddSolace_LWAbility()
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

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Solace_LW');

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

    Template.ActivationSpeech = 'Inspire';
    Template.bShowActivation = true;
    Template.CustomFireAnim = 'HL_Psi_ProjectileMedium';
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.CinescriptCameraType = "Psionic_FireAtUnit";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate Create_AnimSet_Passive(name TemplateName, string AnimSetPath)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_AdditionalAnimSets		AnimSetEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	AnimSetEffect = new class'X2Effect_AdditionalAnimSets';
	AnimSetEffect.AddAnimSetWithPath(AnimSetPath);
	AnimSetEffect.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(AnimSetEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

	static function X2DataTemplate Create_PhaseWalk()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCooldown				Cooldown;
	local X2AbilityCharges				Charges;
	local X2AbilityCost_Charges			ChargeCost;
	local X2AbilityTarget_Cursor		CursorTarget;
	local X2AbilityMultiTarget_Radius	RadiusMultiTarget;
	local array<name>                   SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW_PhaseWalk');

	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_codex_teleport";
	Template.Hostility = eHostility_Neutral;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.PHASEWALK_ACTIONPOINTS;
	ActionPointCost.bConsumeAllPoints = default.PHASEWALK_ENDS_TURN;
	ActionPointCost.bFreeCost = default.PHASEWALK_IS_FREE_ACTION;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if (default.PHASEWALK_COOLDOWN_TURNS > 0)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.PHASEWALK_COOLDOWN_TURNS;
		Template.AbilityCooldown = Cooldown;
	}
	if (default.PHASEWALK_CHARGES > 0)
	{
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = default.PHASEWALK_CHARGES;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}
	Template.TargetingMethod = class'X2TargetingMethod_Teleport';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = default.PHASEWALK_TARGET_TILE_MUST_BE_REVEALED;
	if (default.PHASEWALK_CAST_RANGE_TILES > 0) CursorTarget.FixedAbilityRange = default.PHASEWALK_CAST_RANGE_TILES;	// TILES OMG
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 0.25; // small amount so it just grabs one tile
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	if (default.PHASEWALK_CAN_BE_USED_WHILE_BURNING) SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	if (default.PHASEWALK_CAN_BE_USED_WHILE_DISORIENTED) SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//// Damage Effect
	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);

	Template.ModifyNewContextFn = class'X2Ability_Cyberus'.static.Teleport_ModifyActivatedAbilityContext;
	Template.BuildNewGameStateFn = class'X2Ability_Cyberus'.static.Teleport_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_Cyberus'.static.Teleport_BuildVisualization;
	Template.CinescriptCameraType = "Cyberus_Teleport";
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('LW_PhaseWalk_Anim');

	return Template;
}

static function X2DataTemplate Create_NullWard()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Effect_NullWard					ShieldedEffect;
	local X2AbilityMultiTarget_Radius		MultiTarget;
	local array<name>						SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW_NullWard');

	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aethershift";
	
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.Hostility = eHostility_Defensive;
	Template.ConcealmentRule = eConceal_Never;
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.NULLWARD_ACTIONPOINTS;
	ActionPointCost.bConsumeAllPoints = default.NULLWARD_ENDS_TURN;
	ActionPointCost.bFreeCost = default.NULLWARD_IS_FREE_ACTION;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if (default.NULLWARD_CHARGES > 0)
	{
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = default.NULLWARD_CHARGES;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}

	if (default.NULLWARD_COOLDOWN_TURNS > 0)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.NULLWARD_COOLDOWN_TURNS;
		Template.AbilityCooldown = Cooldown;
	}

	//Can't use while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	if (default.NULLWARD_CAN_BE_USED_WHILE_BURNING) SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	if (default.NULLWARD_CAN_BE_USED_WHILE_DISORIENTED) SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// Multi target
	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = default.NULLWARD_CAST_RADIUS_METERS;
	MultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// The Targets must be within the AOE, LOS, and friendly
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Friendlies in the radius receives a shield receives a shield
	ShieldedEffect = new class'X2Effect_NullWard';
	ShieldedEffect.BaseShieldHPIncrease = default.NULL_WARD_BASE_SHIELD;
	ShieldedEffect.AmpMGShieldHPBonus= default.NULL_WARD_AMP_MG_SHIELD_BONUS;
	ShieldedEffect.AmpBMShieldHPBonus= default.NULL_WARD_AMP_BM_SHIELD_BONUS;
	ShieldedEffect.BuildPersistentEffect (3, false, true, false, eGameRule_PlayerTurnBegin);
	ShieldedEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);

	Template.AddShooterEffect(ShieldedEffect);
	Template.AddMultiTargetEffect(ShieldedEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_AdventShieldBearer'.static.Shielded_BuildVisualization;
	Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('LW_NullWard_Anim');
	Template.PrerequisiteAbilities.AddItem('SoulSteal');
	
	return Template;
}

static function X2AbilityTemplate Create_SoulStorm()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCooldown					Cooldown;
	local array<name>						SkipExclusions;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW_SoulStorm');
	
	//	Targeting and Triggering
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Template.TargetingMethod = class'X2TargetingMethod_AreaSuppression';
	Template.bFriendlyFireWarning = true;
	Template.TargetingMethod = class'X2TargetingMethod_Grenade';

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = default.SOULSTORM_TARGET_TILE_MUST_BE_REVEALED;
	CursorTarget.FixedAbilityRange = default.SOULSTORM_CAST_RANGE_TILES;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.SOULSTORM_CAST_RADIUS_METERS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//	Ability costs

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.SOULSTORM_ACTIONPOINTS;
	ActionPointCost.bConsumeAllPoints = default.SOULSTORM_ENDS_TURN;
	ActionPointCost.bFreeCost = default.SOULSTORM_IS_FREE_ACTION;
	Template.AbilityCosts.AddItem(ActionPointCost);

	if (default.SOULSTORM_CHARGES > 0)
	{
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = default.SOULSTORM_CHARGES;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}
	if (default.SOULSTORM_COOLDOWN_TURNS > 0)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.SOULSTORM_COOLDOWN_TURNS;
		Template.AbilityCooldown = Cooldown;
	}

	//	Ability Effects
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'SoulStorm';
	DamageEffect.bIgnoreArmor = default.SOULSTORM_IGNORES_ARMOR;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect(new class'X2Effect_IRI_SoulStorm');	//	environmental destruction

	//	Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	if (default.SOULSTORM_CAN_BE_USED_WHILE_BURNING) SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	if (default.SOULSTORM_CAN_BE_USED_WHILE_DISORIENTED) SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	//	Target Conditions
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = !default.SOULSTORM_CAN_TARGET_ALLIES;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);
	
	//	Appearance and Visualization
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_Charges');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_archon_blast";
	
	Template.ActivationSpeech = 'NullLance';
	Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.ActionFireClass = class'X2Action_IRI_PsiPinion';
	Template.CustomFireAnim = 'HL_SoulStorm';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SoulStorm_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('LW_SoulStorm_Anim');

	Template.PrerequisiteAbilities.AddItem ('LW_Phasewalk');

	return Template;	
}


simulated function SoulStorm_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local Array<X2Action>					arrFoundActions;
	local X2Action							FoundAction;
	local X2Action_Fire						FireAction;
	local X2Action_WaitForAbilityEffect		WaitAction;
	local VisualizationActionMetadata		ShooterMetadata;
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local StateObjectReference				InteractingUnitRef;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	//	Spawning Meteors (Psi Pinions) is a Fire Action.
	//	However, we need the actual Fire Action to play the ability animation and use its Notify Targets animnotify to trigger the meteors.
	//	Apply weapon damage effects that are visualized for targets listen to the first (or random, if several) Fire Actions that are added before them
	//	We need enemies and environment react to Psi Pinions action. 
	//	So we have to get tricky with the visualization. We call the Typical Ability Build Visualization with Action Fire Class set to Psi Pinions.
	//	Then we insert a second Fire Action before it and use a Wait Action in the middle to make Psi Pinions trigger on Notify Targets in HL_SoulStorm

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	ShooterMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ShooterMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ShooterMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	//	Find Exit Cover action
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover', arrFoundActions);

	//	insert a second Fire Action after it
	FireAction = X2Action_Fire(class'X2Action_Fire'.static.AddToVisualizationTree(ShooterMetadata, Context, false, arrFoundActions[0]));
	//	followed by a Wait Action
	WaitAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ShooterMetadata, Context, false, FireAction));

	//	then we look for all Fire Actions
	//	which will find both the Fire Action and Psi Pinions. But we only need Psi Pinions.
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_Fire', arrFoundActions);
	foreach arrFoundActions(FoundAction)
	{
		if (X2Action_IRI_PsiPinion(FoundAction) != None)	// so we chack if the found action can be cast to it
		{
			VisMgr.DisconnectAction(FoundAction);	//	if it is, then it is the Psi Pinions action. We disconnect it from its parents
			VisMgr.ConnectAction(FoundAction, VisMgr.BuildVisTree,, WaitAction);	//	and set it as a child of the Wait Action so that it comes after it
		}
	}
}