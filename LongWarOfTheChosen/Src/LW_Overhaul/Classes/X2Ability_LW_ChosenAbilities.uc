//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_SpecialistAbilitySet.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Defines all Long War Chosen-specific abilities, Credit to DerBK for some abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_ChosenAbilities extends X2Ability config(LW_SoldierSkills);

var config int COOLDOWN_AMMO_DUMP;
var config int COOLDOWN_SHIELD_ALLY;
var config int MSTERROR_STAT_CHECK_BASE_VALUE;
var config int COMBATREADINESS_DEF;
var config int COMBATREADINESS_AIM;
var config int KIDNAP_COOLDOWN;
var config int SHIELDALLYM1_SHIELD;
var config int SHIELDALLYM2_SHIELD;
var config int SHIELDALLYM3_SHIELD;
var config int SHIELDALLYM4_SHIELD;

var private name ExtractKnowledgeMarkSourceEffectName, ExtractKnowledgeMarkTargetEffectName;

var config array<name> CHOSEN_SUMMON_RNF_DATA;

var const string ChosenSummonContextDesc;
var const string CombatReadinessBonusText;
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
	Templates.AddItem(CreateTraitResilience());
	Templates.AddItem(CreateChosenKidnap());
	Templates.AddItem(AddCombatReadiness());
	Templates.AddItem(CombatReadinessPassive());
	Templates.AddItem(CreateKeen());
	Templates.AddItem(CreateFollowerDefeatedEscape());
	Templates.AddItem(AddChosenDragonRounds());
	Templates.AddItem(AddChosenVenomRounds());
	Templates.AddItem(AddChosenBleedingRounds());
	Templates.AddItem(AddMindScorchDangerZoneAbility());
	Templates.AddItem(AddTerrorPanicAbility());
	Templates.AddItem(CreateTeleportAllyCommand());
	Templates.AddItem(CreateBloodThirst());
	Templates.AddItem(BloodThirstPassive());
	
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

	`CREATE_X2ABILITY_TEMPLATE(Template, 'WarlockReaction');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
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

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AssassinReaction');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

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

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HunterReaction');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	TurnCondition =new class'X2Condition_OnlyOnXCOMTurn';
	Template.AbilityShooterConditions.AddItem(TurnCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
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
	
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeAlive = false;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeCivilian = true;
	TargetCondition.ExcludeCosmetic = true;
	TargetCondition.ExcludeRobotic = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);

	ShieldedEffect = CreateShieldedEffect(Template.LocFriendlyName, Template.GetMyLongDescription(), ShieldAmount);
	Template.AddTargetEffect(ShieldedEffect);

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
	ShieldedEffect.BuildPersistentEffect(10, false, true, , eGameRule_PlayerTurnEnd);
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, FriendlyName, LongDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, ShieldHPAmount);
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

simulated function ChosenSummonFollowers_BuildVisualization(XComGameState VisualizeGameState)
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
				OffsetVisDuration += 0.5f + `SYNC_FRAND() * 0.5f;
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
/*
static function X2DataTemplate CreatePassiveChosenKidnap()
{
	local X2Effect_Kidnap KidnapEffect;
	local X2AbilityTemplate Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW_ChosenKidnap');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_kidnap";
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ChosenKidnap'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
//END AUTOGENERATED CODE: Template Overrides 'ChosenKidnap'

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	KidnapEffect = new class'X2Effect_Kidnap';
	KidnapEffect.BuildPersistentEffect(1, true, true, true);
	Template.AddShooterEffect(KidnapEffect);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// The Target must be alive and a humanoid
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}
*/
static function X2AbilityTemplate AddCombatReadiness()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange			StatChangeEffect;

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

	StatChangeEffect = new class'X2Effect_PersistentStatChange';
	StatChangeEffect.AddPersistentStatChange(eStat_Defense, default.COMBATREADINESS_DEF);
	StatChangeEffect.AddPersistentStatChange(eStat_Offense, default.COMBATREADINESS_AIM);	
	StatChangeEffect.BuildPersistentEffect(3, false, true, false, eGameRule_PlayerTurnEnd);
	StatChangeEffect.DuplicateResponse = eDupe_Allow;
	StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.CombatReadinessBonusText, Template.IconImage, true, , Template.AbilitySourceName);
	StatChangeEffect.EffectName = 'CombatReadiness';
	Template.AddTargetEffect(StatChangeEffect);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.AdditionalAbilities.AddItem('CombatReadinessPassive');

	return Template;
}
static function X2AbilityTemplate CombatReadinessPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('CombatReadinessPassive', "img:///UILibrary_XPerkIconPack.UIPerk_command_defense", , 'eAbilitySource_Perk');

	return Template;
}
static function X2DataTemplate CreateKeen()
{
	local X2AbilityTemplate Template;
	local X2Effect_ChosenKeen KeenEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW_ChosenKeen');
	Template.IconImage = "img:///UILibrary_XPerkIconPack.UIPerk_adrenaline_defense";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	KeenEffect = new class'X2Effect_ChosenKeen';
	KeenEffect.BuildPersistentEffect(1, true, true);
	KeenEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);

	Template.AddMultiTargetEffect(KeenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddChosenDragonRounds()
{
	local X2AbilityTemplate			Template;
	local X2Effect_TemporaryItem	TemporaryItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenDragonRounds');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_incendiary";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'ChosenDragonRounds';
	TemporaryItemEffect.ItemName = 'incendiaryrounds';
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddChosenBleedingRounds()
{
	local X2AbilityTemplate			Template;
	local X2Effect_TemporaryItem	TemporaryItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenDragonRounds');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_incendiary";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'ChosenBleedingRounds';
	TemporaryItemEffect.ItemName = 'HunterBleedingRounds';
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate AddChosenVenomRounds()
{
	local X2AbilityTemplate			Template;
	local X2Effect_TemporaryItem	TemporaryItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenVenomRounds');

	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityVenomRounds";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'ChosenVenomRounds';
	TemporaryItemEffect.ItemName = 'VenomRounds';
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
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

	Template = PurePassive('MindScorchTerror', "img:///UILibrary_LW_Overhaul.LW_AbilityNapalmX", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
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
	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW_ChosenKidnap');
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
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	ActionPointCost.bfreeCost = true;
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

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = ChosenKidnap_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

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

	EventManager = `XEVENTMGR;

	KidnappedUnitState = XComGameState_Unit(kNewTargetState);
	EventManager.TriggerEvent('UnitRemovedFromPlay', KidnappedUnitState, KidnappedUnitState, NewGameState);
	EventManager.TriggerEvent('UnitCaptured', KidnappedUnitState, KidnappedUnitState, NewGameState);
}

simulated function ChosenKidnap_BuildVisualization(XComGameState VisualizeGameState)
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
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);
	
	EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false));
	EffectAction.EffectName = "FX_Chosen_Teleport.P_Chosen_Teleport_Out_w_Sound";
	EffectAction.EffectLocation = ActionMetadata.VisualizeActor.Location;
	EffectAction.bWaitForCompletion = false;

	DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, Context, false));
	DelayAction.Duration = 0.25;

	class'X2Action_RemoveUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, DelayAction);
	//****************************************************************************************
}

static function X2AbilityTemplate CreateTeleportAllyCommand()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener Trigger;
	local X2Effect_RunBehaviorTree ReactionEffect;
	local X2Effect_GrantActionPoints AddAPEffect;
	local array<name> SkipExclusions;
	local X2Condition_UnitProperty UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TeleportAllyCommand');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_combatstims";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.ConfusedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'TeleportAllyCommand';
	Trigger.ListenerData.EventFn = TeleportCommandListener;
	Trigger.ListenerData.Filter = eFilter_Unit;
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
	ReactionEffect.BehaviorTreeName = 'TeleportAllyShooterTree';
	Template.AddTargetEffect(ReactionEffect);

	Template.bShowActivation = false;
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;

	Template.FrameAbilityCameraType = eCameraFraming_Always;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}


static function EventListenerReturn TeleportCommandListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Ability Ability;
	local XComGameStateContext_Ability AbilityContext;

	Ability = XComGameState_Ability(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	`Log("TeleportCommandListener: Trying to convert EventSource to Ability. Result = " $ Ability);
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

static function X2AbilityTemplate CreateBloodThirst()
{
	local X2AbilityTemplate						Template;
	local X2Effect_BloodThirst            		DamageEffect;
	local X2Effect_ToHitModifier                HitModEffect;
	local X2AbilityTrigger_EventListener		EventListener;	
	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'LW_BloodThirst');
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

	DamageEffect = new class'X2Effect_BloodThirst';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.DuplicateResponse = eDupe_Allow;
	DamageEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	Template.bShowActivation=true;
	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!
	Template.AdditionalAbilities.AddItem('LW_BloodThirstPassive');

	return Template;
}

static function X2AbilityTemplate BloodThirstPassive()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('LW_BloodThirstPassive', "img:///UILibrary_PerkIcons.UIPerk_beserker_rage", , 'eAbilitySource_Perk');

	return Template;
}

defaultproperties
{
	ExtractKnowledgeMarkSourceEffectName="ExtractKnowledgeMarkSourceEffect"
	ExtractKnowledgeMarkTargetEffectName="ExtractKnowledgeMarkTargetEffect"

	ChosenSummonContextDesc="ChosenSummonContext"
	CombatReadinessBonusText="Aim and defense bonus"
}
