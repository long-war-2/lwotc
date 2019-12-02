//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_SpecialistAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Specialist-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_SpecialistAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(LW_SoldierSkills);

var config int FAILSAFE_PCT_CHANCE;
var config int RESCUE_CV_CHARGES;
var config int RESCUE_MG_CHARGES;
var config int RESCUE_BM_CHARGES;
var config int FULL_OVERRIDE_COOLDOWN;
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_SpecialistAbilitySet.CreateTemplates --------------------------------");
	Templates.AddItem(AddFullOverride());
	Templates.AddItem(FinalizeFullOverride());
	Templates.AddItem(CancelFullOverride());
	//Templates.AddItem(AddHackRewardControlRobot_Mission()); Replaced with Greater Shutdown, commented out but not removed in case of reversal
	Templates.AddItem(AddHackRewardControlRobot_Permanent());
	Templates.AddItem(AddFailsafe());
	//Templates.AddItem(AddCorpsman());
	Templates.AddItem(AddRescueProtocol());
	Templates.AddItem(HackRewardGreaterShutdownRobot());
	Templates.AddItem(HackRewardGreaterShutdownTurret());

	
	return Templates;
}

static function X2AbilityTemplate AddFailsafe()
{
	local X2AbilityTemplate			Template;
	local X2Effect_Failsafe			FailsafeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Failsafe');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityFailsafe";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	FailsafeEffect = new class 'X2Effect_Failsafe';
	FailsafeEffect.BuildPersistentEffect (1, true, false);
	FailsafeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (FailsafeEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddFullOverride()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCharges              Charges;
	local X2AbilityCost_Charges         ChargeCost;
	local X2Condition_UnitEffects		NotHaywiredCondition;
	local X2AbilityCooldown             Cooldown;

	Template = class'X2Ability_SpecialistAbilitySet'.static.ConstructIntrusionProtocol('FullOverride', , true);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityFullOverride";

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.bOnlyOnHit = true;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FULL_OVERRIDE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	NotHaywiredCondition = new class 'X2Condition_UnitEffects';
	NotHaywiredCondition.AddExcludeEffect ('Haywired', 'AA_NoTargets');
	Template.AbilityTargetConditions.AddItem(NotHaywiredCondition);

	Template.CancelAbilityName = 'CancelFullOverride';
	Template.AdditionalAbilities.AddItem('CancelFullOverride');
	Template.FinalizeAbilityName = 'FinalizeFullOverride';
	Template.AdditionalAbilities.AddItem('FinalizeFullOverride');

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.ActivationSpeech = 'HaywireProtocol';

	return Template;
}

static function X2AbilityTemplate CancelFullOverride()
{
	local X2AbilityTemplate             Template;

	Template = class'X2Ability_SpecialistAbilitySet'.static.CancelIntrusion('CancelFullOverride');

	Template.BuildNewGameStateFn = CancelFullOverride_BuildGameState;

	return Template;
}

// Full override only consumes the charge on a successful hack. The charge is attached to the FullOverride ability
// and is charged when the player first selects the ability, similar to the cooldown applied on Haywire protocol.
// As for haywire, if the player cancels the hack we need to refund the charge. Full override also refunds the charge
// if the hack is attempted but fails.
static function RefundFullOverrideCharge(XComGameStateContext_Ability AbilityContext, XComGameState NewGameState)
{
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	// locate the Ability gamestate for HaywireProtocol associated with this unit, and remove the turn timer
	foreach History.IterateByClassType(class'XComGameState_Ability', AbilityState)
	{
		if( AbilityState.OwnerStateObject.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID &&
		   AbilityState.GetMyTemplateName() == 'FullOverride' )
		{
			AbilityState = XComGameState_Ability(NewGameState.CreateStateObject(class'XComGameState_Ability', AbilityState.ObjectID));
			NewGameState.AddStateObject(AbilityState);
			++AbilityState.iCharges;
			return;
		}
	}
}

// Player has aborted a full override: Refund the chage.
function XComGameState CancelFullOverride_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	AbilityContext = XComGameStateContext_Ability(Context);
	NewGameState = TypicalAbility_BuildGameState(Context);

	foreach History.IterateByClassType(class'XComGameState_Ability', AbilityState)
	{
		if( AbilityState.OwnerStateObject.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID &&
		   AbilityState.GetMyTemplateName() == 'FullOverride' )
		{
			AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', AbilityState.ObjectID));
			AbilityState.iCooldown = 0;
			break;
		}
	}

	RefundFullOverrideCharge(AbilityContext, NewGameState);
	return NewGameState;
}

// Player has attempted a full override: Perform the normal hack finalization, but in addition
// we need to check if the hack has failed. If so, refund the charge.
simulated function XComGameState FinalizeFullOverrideAbility_BuildGameState(XComGameStateContext Context)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_BaseObject TargetState;
	local XComGameState_Unit TargetUnit;
	local XComGameState NewGameState;
	local X2Ability_DefaultAbilitySet	DefaultAbilitySet;

	// First perform the standard hack finalization.
	DefaultAbilitySet = new class'X2Ability_DefaultAbilitySet';
	NewGameState = DefaultAbilitySet.FinalizeHackAbility_BuildGameState(Context);
	AbilityContext = XComGameStateContext_Ability(Context);

	// Check if we have succesfully hacked the target. If not, refund the charge.
	TargetState = NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID);
	TargetUnit = XComGameState_Unit(TargetState);
	if (TargetUnit != none && !TargetUnit.bHasBeenHacked)
	{
		RefundFullOverrideCharge(AbilityContext, NewGameState);
	}

	return NewGameState;
}

static function X2AbilityTemplate FinalizeFullOverride()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Single            SingleTarget;
	local X2Effect_Persistent				HaywiredEffect;
	local X2Ability_DefaultAbilitySet		DefaultAbilitySet;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FinalizeFullOverride');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_intrusionprotocol";
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.bStationaryWeapon = true; // we move the gremlin during the action, don't move it before we're ready
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;

	// successfully completing the hack requires and costs an action point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_Hacking';
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.bAllowInteractiveObjects = true;
	Template.AbilityTargetStyle = SingleTarget;

	HaywiredEffect = new class'X2Effect_Persistent';
	HaywiredEffect.EffectName = 'Haywired';
	HaywiredEffect.BuildPersistentEffect(1, true, false);
	HaywiredEffect.bDisplayInUI = false;
	HaywiredEffect.bApplyOnMiss = true;
	Template.AddTargetEffect(HaywiredEffect);

	Template.CinescriptCameraType = "Specialist_IntrusionProtocol";

	DefaultAbilitySet = new class'X2Ability_DefaultAbilitySet';
	Template.BuildNewGameStateFn = FinalizeFullOverrideAbility_BuildGameState;
	Template.BuildVisualizationFn = DefaultAbilitySet.FinalizeHackAbility_BuildVisualization;
	Template.MergeVisualizationFn = DefaultAbilitySet.FinalizeHackAbility_MergeVisualization;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	//Template.OverrideAbilities.AddItem( 'FinalizeHack' );
	Template.bOverrideWeapon = true;
	Template.bSkipFireAction = true;
	return Template;
}
 
static function X2AbilityTemplate AddHackRewardControlRobot_Mission()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    Listener;
	local X2Effect_MindControl              ControlEffect;
	local bool								bInfiniteDuration;
	local X2Effect_RemoveEffects			RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HackRewardControlRobot_Mission');

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	Listener = new class'X2AbilityTrigger_EventListener';
	Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
	Listener.ListenerData.EventFn = class'XComGameState_Ability'.static.HackTriggerTargetListener;
	Listener.ListenerData.EventID = class'X2HackRewardTemplateManager'.default.HackAbilityEventName;
	Listener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(Listener);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	bInfiniteDuration = true;
	ControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(99, true, bInfiniteDuration);
	Template.AddTargetEffect(ControlEffect);

	// Remove any pre-existing disorient.
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('HackRewardBuffEnemy0');
	RemoveEffects.EffectNamesToRemove.AddItem('HackRewardBuffEnemy1');
	Template.AddTargetEffect(RemoveEffects);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

	return Template;
}

static function X2AbilityTemplate HackRewardGreaterShutdownRobot()
{
	return HackRewardShutdownRobotOrTurret(false, 'HackRewardGreaterShutdownRobot');
}

static function X2AbilityTemplate HackRewardGreaterShutdownTurret()
{
	return HackRewardShutdownRobotOrTurret(true, 'HackRewardGreaterShutdownTurret');
}

static function X2AbilityTemplate HackRewardShutdownRobotOrTurret( bool bTurret, Name AbilityName )
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    Listener;
	local X2Effect_Stunned                  StunEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	Listener = new class'X2AbilityTrigger_EventListener';
	Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
	Listener.ListenerData.EventFn = class'XComGameState_Ability'.static.HackTriggerTargetListener;
	Listener.ListenerData.EventID = class'X2HackRewardTemplateManager'.default.HackAbilityEventName;
	Listener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(Listener);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(6, 100, false);
	StunEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.RoboticStunnedFriendlyName, class'X2StatusEffects'.default.RoboticStunnedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun");
	if( bTurret )
	{
		StunEffect.CustomIdleOverrideAnim = ''; // Clearing this prevents the anim tree controller from being locked down.  
	}											// Then the idle anim state machine can properly update the stunned anims.
	Template.AddTargetEffect(StunEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

	return Template;
}




static function X2AbilityTemplate AddHackRewardControlRobot_Permanent()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    Listener;
	local X2Effect_MindControl              ControlEffect;
	local bool								bInfiniteDuration;
	local X2Effect_TransferMecToOutpost		Effect;
	local X2Effect_PersistentStatChange		Buff;
	local X2Effect_RemoveEffects			RemoveEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HackRewardControlRobot_Permanent');

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	Listener = new class'X2AbilityTrigger_EventListener';
	Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
	Listener.ListenerData.EventFn = class'XComGameState_Ability'.static.HackTriggerTargetListener;
	Listener.ListenerData.EventID = class'X2HackRewardTemplateManager'.default.HackAbilityEventName;
	Listener.ListenerData.Filter = eFilter_None;
	Template.AbilityTriggers.AddItem(Listener);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	bInfiniteDuration = true;
	ControlEffect = class'X2StatusEffects'.static.CreateMindControlStatusEffect(99, true, bInfiniteDuration);
	ControlEffect.bRemoveWhenSourceDies = false; // added for ID 1733 -- mind control effect is no longer lost when source unit dies or evacs
	ControlEffect.EffectRemovedVisualizationFn = none; // No visualization of this effect being removed (which happens when the unit evacs or dies)
	Template.AddTargetEffect(ControlEffect);

	// Save MEC effect
	Effect = new class'X2Effect_TransferMecToOutpost';
	Effect.BuildPersistentEffect(1, true, false, true, eGameRule_PlayerTurnBegin); // for ID 1733, changed parameter 3 to falso, so effect is no longer lost when source unit dies or evacs
	Effect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), "img:///UILibrary_PerkIcons.UIPerk_hack_reward", true,,Template.AbilitySourceName);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Effect.bPersistThroughTacticalGameEnd=true;
	Template.AddTargetEffect(Effect);

	Buff = new class'X2Effect_PersistentStatChange';
	Buff.BuildPersistentEffect (1, true, true);
	Buff.SetDisplayInfo(1, class'X2Ability_HackRewards'.default.ControlRobotStatName, class'X2Ability_HackRewards'.default.ControlRobotStatDesc, "img:///UILibrary_PerkIcons.UIPerk_hack_reward", true);
	Buff.AddPersistentStatChange(eStat_Offense, float(class'X2Ability_HackRewards'.default.CONTROL_ROBOT_AIM_BONUS));
    Buff.AddPersistentStatChange(eStat_CritChance, float(class'X2Ability_HackRewards'.default.CONTROL_ROBOT_CRIT_BONUS));
    Buff.AddPersistentStatChange(eStat_Mobility, float(class'X2Ability_HackRewards'.default.CONTROL_ROBOT_MOBILITY_BONUS));
	Template.AddTargetEFfect(Buff);

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('HackRewardBuffEnemy0');
	RemoveEffects.EffectNamesToRemove.AddItem('HackRewardBuffEnemy1');
	Template.AddTargetEffect(RemoveEffects);

	// Remove any pre-existing disorient.
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

	return Template;
}

static function X2AbilityTemplate AddCorpsman()
{
	local X2AbilityTemplate			Template;
	local X2Effect_TemporaryItem	TemporaryItemEffect;
	local ResearchConditional		Conditional;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Corpsman');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;

	Conditional.ResearchProjectName = 'BattlefieldMedicine';
	Conditional.ItemName = 'NanoMedikit';

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'CorspmanEffect';
	TemporaryItemEffect.ItemName = 'Medikit';
	TemporaryItemEffect.ResearchOptionalItems.AddItem(Conditional);
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate AddRescueProtocol()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCharges_RescueProtocol	Charges;
	local X2Condition_UnitEffects			CommandRestriction;
	local X2Effect_GrantActionPoints		ActionPointEffect;
	local X2Effect_Persistent				ActionPointPersistEffect;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_UnitActionPoints		ValidTargetCondition;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'RescueProtocol');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_defensiveprotocol";
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bStationaryWeapon = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipPerkActivationActions = true;
	Template.bCrossClassEligible = false;

	Charges = new class 'X2AbilityCharges_RescueProtocol';
	Charges.CV_Charges = default.RESCUE_CV_CHARGES;
	Charges.MG_Charges = default.RESCUE_MG_CHARGES;
	Charges.BM_Charges = default.RESCUE_BM_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,'Suppression',true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2Ability_SharpshooterAbilitySet'.default.KillZoneReserveType,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.StandardActionPoint,false,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.RunAndGunActionPoint,false,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.MoveActionPoint,false,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeUnrevealedAI = true;
	UnitPropertyCondition.ExcludeConcealed = true;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludePanicked = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeStunned = true;
	UnitPropertyCondition.ExcludeNoCover = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = false;
	UnitPropertyCondition.ExcludeTurret = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	CommandRestriction = new class'X2Condition_UnitEffects';
	CommandRestriction.AddExcludeEffect('Command', 'AA_UnitIsCommanded');
	CommandRestriction.AddExcludeEffect('Rescued', 'AA_UnitIsCommanded');
	CommandRestriction.AddExcludeEffect('HunkerDown', 'AA_UnitIsCommanded');
    CommandRestriction.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(CommandRestriction);

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
    Template.AddTargetEffect(ActionPointEffect);

	ActionPointPersistEffect = new class'X2Effect_Persistent';
    ActionPointPersistEffect.EffectName = 'Rescued';
    ActionPointPersistEffect.BuildPersistentEffect(1, false, true, false, 8);
    ActionPointPersistEffect.bRemoveWhenTargetDies = true;
    Template.AddTargetEffect(ActionPointPersistEffect);

	//Template.bSkipFireAction = true;

	Template.bShowActivation = true;

	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.ActivationSpeech = 'DefensiveProtocol';
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}
