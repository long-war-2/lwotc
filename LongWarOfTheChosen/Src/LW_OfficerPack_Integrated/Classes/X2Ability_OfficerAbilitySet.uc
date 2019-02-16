//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_OfficerAbilitySet
//  AUTHOR:  Amineri / John Lumpkin (Pavonis Interactive)
//  PURPOSE: Defines officer ability templates
//---------------------------------------------------------------------------------------
class X2Ability_OfficerAbilitySet extends X2Ability config (LW_OfficerPack);

var config int GETSOME_ACTIONPOINTCOST;
var config int GETSOME_CRIT_BONUS;
var config int GETSOME_CHARGES;
var config int GETSOME_DURATION;
var config int FALLBACK_COOLDOWN;
var config int OSCARMIKE_ACTIONPOINTCOST;
var config int OSCARMIKE_CHARGES;
var config int OSCARMIKE_DURATION;
var config int OSCARMIKE_MOBILITY_BONUS;
var config int COLLECTOR_BONUS_INTEL_LOW;
var config int COLLECTOR_BONUS_INTEL_RANDBONUS;
var config int COLLECTOR_BONUS_CHANCE;
var config int COLLECTOR_MAX_INTEL_PER_MISSION;
var config int COMMAND_MIN_ACTION_POINTS_REQ;
var config array<int>COMMAND_CHARGES;
var config int INTERVENTION_ACTION_POINTS;
var config array<int>INTERVENTION_CHARGES;
var config int INTERVENTION_EXTRA_TURNS;
var config int INTERVENTION_INTEL_COST;
var config int INCOMING_COOLDOWN;
var config int INCOMING_EXPLOSIVES_DR;
var config int AIR_CONTROLLER_EVAC_TURN_REDUCTION;
var config int JAMMER_CHARGES;
var config int JAMMER_ACTION_POINTS;
var config int LEADERSHIP_WILL_PER_MISSION;
var config int LEADERSHIP_WILL_CAP;
var config float LEADERSHIP_DODGE_PER_MISSION;
var config int LEADERSHIP_DODGE_CAP;
var config int LEADERSHIP_AIM_PER_MISSION;
var config int LEADERSHIP_AIM_CAP;
var config int LEADERSHIP_DEFENSE_PER_MISSION;
var config int LEADERSHIP_DEFENSE_CAP;
var config int TRIAL_BY_FIRE_RANK_CAP;

var localized string strIntervention_WorldMessage;
var localized string strCollector_WorldMessage;
var localized string FocussedFriendlyName;
var localized string FocussedFriendlyDesc;

var config float BaseCommandRange;
var config float CommandRangePerRank;
var config array<float> COMMANDRANGE_DIFFICULTY_MULTIPLER;

var const name OfficerSourceName; // change this once UI work is done

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2Ability_OfficerAbilitySet.CreateTemplates()");
	
	//rev 3 abilities
	Templates.AddItem(AddGetSomeAbility());
	Templates.AddItem(AddCollectorAbility());
	Templates.AddItem(AddFocusFireAbility());
	Templates.AddItem(AddFallBackAbility());
	Templates.AddItem(AddScavengerAbility());
	Templates.AddItem(AddOscarMikeAbility());

	Templates.AddItem(ScavengerPassive());

	Templates.AddItem(AddInfiltratorAbility());
	Templates.AddItem(AddAirControllerAbility());
	Templates.AddItem(AddJammerAbility());
	Templates.AddItem(AddCommandAbility());
	Templates.AddItem(AddIncomingAbility());
	Templates.AddItem(AddInterventionAbility());

	Templates.AddItem(AddLeadershipAbility());
	Templates.AddItem(AddEspritdeCorpsAbility());

	Templates.AddItem(PurePassive('TrialByFire', "img:///UILibrary_LW_Overhaul.UIPerk_TrialByFire", true));

	return Templates;
}

// ******* Helper function ******* //

static function float GetCommandRangeSq(XComGameState_Unit Unit)
{
	local float range;
	local XComGameState_Unit_LWOfficer OfficerState;

	range = default.BaseCommandRange;

	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);
	if (OfficerState != none)
	{
		range += float(OfficerState.GetOfficerRank()) * default.CommandRangePerRank;
	}

	range *= default.COMMANDRANGE_DIFFICULTY_MULTIPLER[`TACTICALDIFFICULTYSETTING];

	//`log("LW Officer Pack: CommandRange=" $ range);
	return range*range;
	//return 49.0;
}


//LT1: GetSome, use a action to give everybody in range a crit bonus
//Needs Aura AOE
static function X2AbilityTemplate AddGetSomeAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_PersistentStatChange		StatEffect;
	local X2AbilityTargetStyle				TargetStyle;
	local X2Condition_UnitProperty			MultiTargetProperty;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GetSome');

	Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityWhereItHurts";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipFireAction = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.GETSOME_ACTIONPOINTCOST;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = default.GETSOME_CHARGES;
    Template.AbilityCharges = Charges;
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.Deadeye;

	TargetStyle = new class 'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	MultiTargetProperty = new class'X2Condition_UnitProperty';
	MultiTargetProperty.ExcludeAlive = false;
    MultiTargetProperty.ExcludeDead = true;
    MultiTargetProperty.ExcludeHostileToSource = true;
    MultiTargetProperty.ExcludeFriendlyToSource = false;
    MultiTargetProperty.RequireSquadmates = true;
    MultiTargetProperty.ExcludePanicked = true;
	MultiTargetProperty.ExcludeRobotic = true;
	MultiTargetProperty.ExcludeStunned = true;
	MultiTargetProperty.ExcludeCivilian = true;

	//add command range
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_LWOfficerCommandRange';

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.BuildPersistentEffect(default.GETSOME_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	StatEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); // adjust?
	StatEffect.DuplicateResponse = eDupe_Refresh;
	StatEffect.AddPersistentStatChange (eStat_CritChance, float (default.GETSOME_CRIT_BONUS));
	StatEffect.TargetConditions.AddItem(MultiTargetProperty); // prevent exclusion on effect apply instead of in targeting
	Template.AddMultiTargetEffect(StatEffect);

	Template.AbilityConfirmSound = "Unreal2DSounds_NewWeaponUnlocked";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = GetSome_BuildVisualization;

	return Template;
}

//LT 2 Collector has an X% chance ot add y bonus intel for each kill
static function X2AbilityTemplate AddCollectorAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Collector				CollectorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Collector');

	Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityCollector";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	CollectorEffect = new class'X2Effect_Collector';
	CollectorEffect.BuildPersistentEffect(1, true, false);
	CollectorEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(CollectorEffect);

	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.AdditionalAbilities.AddItem('CollectorPassive');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;  // deliberately no visualization
	return Template;
}

// ***** OLD VERSION THAT USED EVENT CALLBACKS BELOW *****
//static function X2AbilityTemplate AddCollectorAbility()
//{
	//local X2AbilityTemplate                 Template;
	//local X2AbilityTrigger_EventListener	Listener;
	//local X2Condition_UnitProperty			ShooterPropertyConditions;
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'Collector');
	//Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityCollector";
	//Template.AbilitySourceName = default.OfficerSourceName;
	//Template.Hostility = eHostility_Neutral;
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
//
	//Template.AbilityToHitCalc = default.Deadeye;
	//Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	//ShooterPropertyConditions = new class 'X2Condition_UnitProperty';
	//ShooterPropertyConditions.ExcludeDead = true;
	//ShooterPropertyConditions.ExcludeImpaired = true;
	//ShooterPropertyConditions.ExcludePanicked = true;
	//ShooterPropertyConditions.ExcludeInStasis = true;
	//ShooterPropertyConditions.ExcludeStunned = true;
	//Template.AbilityShooterConditions.AddItem(ShooterPropertyConditions);
//
	//Template.AbilityTargetStyle = new class 'X2AbilityTarget_Self';
	//Template.AdditionalAbilities.AddItem('CollectorPassive');
//
	//Listener = new class'X2AbilityTrigger_EventListener';
    //Listener.ListenerData.Filter = eFilter_None;
    //Listener.ListenerData.Deferral = ELD_OnStateSubmitted;
	//Listener.ListenerData.EventID = 'UnitDied';
    //Listener.ListenerData.EventFn = CollectionCheck;
	//Template.AbilityTriggers.AddItem(Listener);
//
	//Template.bSkipFireAction = true;
//
	////No gamestate or visualization triggered here, as that is all handled by the ability trigger
	//Template.BuildNewGameStateFn = Empty_BuildGameState;
//
	//return Template;
//}

function XComGameState Empty_BuildGameState( XComGameStateContext Context )
{
	return none;
}

static function X2AbilityTemplate CollectorPassive()
{
 return PurePassive('CollectorPassive', "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityCollector", , class'X2Ability_OfficerAbilitySet'.default.OfficerSourceName);
}

//***** MOVED TO XComGameState_Effect_Collector ***** KEEPING FOR BACKWARDS COMPATIBILITY ONLY
static function EventListenerReturn CollectionCheck(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local XComGameState_Ability				AbilityState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local int								RandRoll, IntelGain;
	local XComGameState_Unit				SourceUnit, DeadUnit;

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(GameState.GetContext());
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	`log("Collection: AbilityState=" $ AbilityState.GetMyTemplateName());
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	`LOG ("COLLECTION:" @ string(SourceUnit.GetMyTemplateName()));
	If (SourceUnit == none)
	{
		`Redscreen("CollectionCheck: No source");
		return ELR_NoInterrupt;
	}
	DeadUnit = XComGameState_Unit(EventData);
	`LOG ("COLLECTION:" @ string(DeadUnit.GetMyTemplateName()));
	If (DeadUnit == none)
	{
		`Redscreen("CollectionCheck: No killed unit");
		return ELR_NoInterrupt;
	}
	IntelGain = 0;
	if (DeadUnit.IsEnemyUnit(SourceUnit))
	{
		if (SourceUnit.GetTeam() == eTeam_XCom)
		{
			if ((!DeadUnit.IsMindControlled()) && (DeadUnit.GetMyTemplateName() != 'PsiZombie') && (DeadUnit.GetMyTemplateName() != 'PsiZombieHuman'))
			{
				RandRoll = `SYNC_RAND_STATIC(100);
				if (RandRoll < default.COLLECTOR_BONUS_CHANCE)
				{
					IntelGain = default.COLLECTOR_BONUS_INTEL_LOW + `SYNC_RAND_STATIC(default.COLLECTOR_BONUS_INTEL_RANDBONUS);
					If (IntelGain > 0)
					{
						//option 1 -- attach to existing state, use PostBuildVisualization
						XCOMHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
						XCOMHQ.AddResource(GameState, 'Intel', IntelGain);
						GameState.GetContext().PostBuildVisualizationFn.AddItem(Collector_BuildVisualization);

						//option 2 -- build new state, use PostBuildVisualization
						//XCOMHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
						//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Collector ability gain");
						//XCOMHQ.AddResource(NewGameState, 'Intel', IntelGain);
						//StateChangeContainer.InputContext.SourceObject = kUnit.GetReference();
						//NewGameState.GetContext().PostBuildVisualizationFn.AddItem(Collector_BuildVisualization);
						//`TACTICALRULES.SubmitGameState(NewGameState);

						//option 3 -- build new state, add attach BuildVisualization to change container
						//XCOMHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
						//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Collector ability gain");
						//XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = Collector_BuildVisualization;
						//XCOMHQ.AddResource(NewGameState, 'Intel', IntelGain);
						//`TACTICALRULES.SubmitGameState(NewGameState);
					}
				}
			}
		}

	}
	return ELR_NoInterrupt;
}


//***** MOVED TO XComGameState_Effect_Collector ***** KEEPING FOR BACKWARDS COMPATIBILITY ONLY
//static
function Collector_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		Context;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack;
	local XComGameState_Unit				UnitState;
    local X2Action_PlayWorldMessage			MessageAction;

    History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	//Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    //InteractingUnitRef = context.InputContext.SourceObject;

	//`LOG ("COLLECTION: Building Collector Track");
	BuildTrack = EmptyTrack;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	//`LOG ("COLLECTION: VisSoureUnit=" @ UnitState.GetFullName());
	BuildTrack.StateObject_NewState = UnitState;
	BuildTrack.StateObject_OldState = UnitState;
	BuildTrack.VisualizeActor = UnitState.GetVisualizer();
	MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	MessageAction.AddWorldMessage(default.strCollector_WorldMessage);
}

//CAPT 2 Focus Fire
//FocusFire makes each subsequent attack against designated enemy gain +x to-hit -- also grants +1 armor piercing to all attacks
static function X2AbilityTemplate AddFocusFireAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Effect_FocusFire				FocusFireEffect;
	local X2Condition_UnitEffects UnitEffectsCondition;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'FocusFire');
	Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityTakeItDown";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	//Template.bDisplayInUITacticalText = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipFireAction = true;
	Template.ConcealmentRule = eConceal_Always;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = class'X2Effect_FocusFire'.default.FOCUSFIRE_ACTIONPOINTCOST;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = class'X2Effect_FocusFire'.default.FOCUSFIRE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

    Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible=true;
	TargetVisibilityCondition.bAllowSquadsight=false;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Target cannot already be focussed on
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_FocusFire'.default.EffectName, 'AA_UnitIsFocussed');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	// Needs effect implementation
	FocusFireEffect = new class'X2Effect_FocusFire';
	//FocusFireEffect.EffectName = default.MarkedName;
	FocusFireEffect.DuplicateResponse = eDupe_Ignore;
	FocusFireEffect.BuildPersistentEffect(class'X2Effect_FocusFire'.default.FOCUSFIRE_DURATION, false, true,,eGameRule_PlayerTurnEnd);
	//FocusFireEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	FocusFireEffect.SetDisplayInfo(ePerkBuff_Penalty, default.FocussedFriendlyName, default.FocussedFriendlyDesc, Template.IconImage, true,, Template.AbilitySourceName);
	FocusFireEffect.VisualizationFn = class'X2StatusEffects'.static.MarkedVisualization;
	FocusFireEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.MarkedVisualizationTicked;
	FocusFireEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.MarkedVisualizationRemoved;
	FocusFireEffect.bRemoveWhenTargetDies = true;

	Template.AddTargetEffect(FocusFireEffect);

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	Template.AbilityConfirmSound = "Unreal2DSounds_TargetLock";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = FocusFire_BuildVisualization;

	return Template;
}

//MAJ 1 Fall Back
static function X2AbilityTemplate AddFallBackAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Effect_FallBack					FallBackEffect;
	local X2Condition_UnitActionPoints		ValidTargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FallBack');
	Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityFallBack";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipFireAction = true;

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.FALLBACK_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.Deadeye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
    TargetVisibilityCondition.bRequireGameplayVisible=true;
	TargetVisibilityCondition.bAllowSquadsight=false;
    Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeUnrevealedAI = true;
	UnitPropertyCondition.ExcludeConcealed = false;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludePanicked = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeStunned = true;
	UnitPropertyCondition.ExcludeNoCover = false;
	UnitPropertyCondition.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,'Suppression',true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetcondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,,false,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,class'X2Ability_SharpshooterAbilitySet'.default.KillZoneReserveType,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	FallBackEffect = new class'X2Effect_FallBack';
	FallBackEffect.BehaviorTree = 'FallBackRoot';
	Template.AddTargetEffect(FallBackEffect);

	Template.AbilityConfirmSound = "Unreal2DSounds_GeneMod_SecondHeart";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = FallBack_BuildVisualization;
	return Template;
}

//plays wave when ability fires
function FallBack_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack;
    local X2Action_PlayAnimation			PlayAnimationAction;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
    InteractingUnitRef = context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_SignalEncourage';
	PlayAnimationAction.bFinishAnimationWait = true;
}

//MAJ 2 Scavenger adds +X supplies per mission
static function X2AbilityTemplate AddScavengerAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Scavenger				ScavengerEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Scavenger');

	Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityScavenger";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	ScavengerEffect = new class'X2Effect_Scavenger';
	ScavengerEffect.BuildPersistentEffect(1, true, false);
	ScavengerEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(ScavengerEffect);

	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;  // deliberately no visualization
	return Template;
}

static function X2AbilityTemplate ScavengerPassive()
{
 return PurePassive('ScavengerPassive', "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityScavenger", , class'X2Ability_OfficerAbilitySet'.default.OfficerSourceName);
}


//COL 2 Oscar Mike

static function X2AbilityTemplate AddOscarMikeAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCharges					Charges;
	local X2Condition_UnitProperty			MultiTargetProperty;
	//local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityCost_Charges				ChargeCost;
	local X2Effect_PersistentStatChange		StatEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'OscarMike');
	Template.IconImage = "img:///UILibrary_LW_OfficerPack.LWOfficers_AbilityOscarMike";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.bSkipFireAction = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.OSCARMIKE_ACTIONPOINTCOST;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = default.OSCARMIKE_CHARGES;
    Template.AbilityCharges = Charges;
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.Deadeye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetStyle = new class 'X2AbilityTarget_Self';

	MultiTargetProperty = new class'X2Condition_UnitProperty';
	MultiTargetProperty.ExcludeAlive = false;
    MultiTargetProperty.ExcludeDead = true;
    MultiTargetProperty.ExcludeHostileToSource = true;
    MultiTargetProperty.ExcludeFriendlyToSource = false;
    MultiTargetProperty.RequireSquadmates = true;
    MultiTargetProperty.ExcludePanicked = true;
	MultiTargetProperty.ExcludeRobotic = true;
	MultiTargetProperty.ExcludeStunned = true;
	MultiTargetProperty.ExcludeCivilian = true;
	MultiTargetProperty.TreatMindControlledSquadmateAsHostile = true;

	//add command range
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_LWOfficerCommandRange';

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.BuildPersistentEffect(default.OSCARMIKE_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	StatEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	StatEffect.DuplicateResponse = eDupe_Refresh;
	StatEffect.AddPersistentStatChange (eStat_Mobility, float (default.OSCARMIKE_MOBILITY_BONUS));
	StatEffect.TargetConditions.AddItem(MultiTargetProperty); // prevent exclusion on effect apply instead of in targeting
	Template.AddMultiTargetEffect(StatEffect);

	Template.AbilityConfirmSound = "Unreal2DSounds_OfficerSchoolPurchase";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = OscarMike_BuildVisualization;
	return Template;
}

static function X2AbilityTemplate AddCommandAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCharges_Command			Charges;
	local X2Condition_UnitEffects           SuppressedCondition, CommandRestriction;
	local X2Effect_GrantActionPoints		ActionPointEffect;
	local X2Effect_Persistent				ActionPointPersistEffect;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_UnitActionPoints		ValidTargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Command');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityCommand";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = 319;
	Template.bLimitTargetIcons = true;
	Template.AddShooterEffectExclusions();

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.COMMAND_MIN_ACTION_POINTS_REQ;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges_Command';
	Charges.LT2Charges = default.COMMAND_CHARGES[1];
	Charges.LT1Charges = default.COMMAND_CHARGES[2];
	Charges.CAPTCharges = default.COMMAND_CHARGES[3];
	Charges.MajCharges = default.COMMAND_CHARGES[4];
	Charges.LTCCharges = default.COMMAND_CHARGES[5];
	Charges.ColCharges = default.COMMAND_CHARGES[6];
	Charges.CmdrCharges = default.COMMAND_CHARGES[7];
    Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.Deadeye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

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
	ValidTargetCondition.AddActionPointCheck(0,class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint,true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect('AreaSuppression', 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect('HunkerDown', 'AA_UnitIsHunkered');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeUnrevealedAI = true;
	UnitPropertyCondition.ExcludeConcealed = false;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludePanicked = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeStunned = true;
	UnitPropertyCondition.ExcludeNoCover = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
    ActionPointEffect.NumActionPoints = 1;
    ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
    Template.AddTargetEffect(ActionPointEffect);

	ActionPointPersistEffect = new class'X2Effect_Persistent';
    ActionPointPersistEffect.EffectName = 'Command';
    ActionPointPersistEffect.BuildPersistentEffect(1, false, true, false, 8);
    ActionPointPersistEffect.bRemoveWhenTargetDies = true;
    Template.AddTargetEffect(ActionPointPersistEffect);

	CommandRestriction = new class'X2Condition_UnitEffects';
	CommandRestriction.AddExcludeEffect('Rescued', 'AA_UnitIsRescued');
	Template.AbilityTargetConditions.AddItem(CommandRestriction);

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'LL_SignalGoAheadFwd';
	Template.AbilityConfirmSound = "Unreal2DSounds_OfficerSchoolPurchase";
	//Template.ActivationSpeech = 'Inspire';
	//Template.ActivationSpeech = 'HoldTheLine';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate AddInterventionAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCharges_Command			Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Condition_Intervention			InterventionCondition;
	local X2Condition_HasEnoughIntel		IntelCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Intervention');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityIntervention";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.ShotHUDPriority = 318;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.INTERVENTION_ACTION_POINTS;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AddShooterEffectExclusions();

	InterventionCondition = new class'X2Condition_Intervention';
	Template.AbilityShooterConditions.AddItem(InterventionCondition);

	IntelCondition = new class'X2Condition_HasEnoughIntel';
	IntelCondition.MinIntel = default.INTERVENTION_INTEL_COST;
	Template.AbilityShooterConditions.AddItem(IntelCondition);

	Charges = new class'X2AbilityCharges_Command';
	Charges.LT2Charges = default.INTERVENTION_CHARGES[1];
	Charges.LT1Charges = default.INTERVENTION_CHARGES[2];
	Charges.CAPTCharges = default.INTERVENTION_CHARGES[3];
	Charges.MajCharges = default.INTERVENTION_CHARGES[4];
	Charges.LTCCharges = default.INTERVENTION_CHARGES[5];
	Charges.ColCharges = default.INTERVENTION_CHARGES[6];
	Charges.CmdrCharges = default.INTERVENTION_CHARGES[7];
    Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

    Template.AbilityConfirmSound = "Intervention_Cue";

	Template.BuildNewGameStateFn = InterventionAbility_BuildGameState;
	Template.BuildVisualizationFn = InterventionAbility_BuildVisualization;

	return Template;
}

function InterventionAbility_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		Context;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack;
	local XComGameState_Unit				UnitState;
    local X2Action_PlayWorldMessage			MessageAction;
	local XGParamTag						ParamTag;

	TypicalAbility_BuildVisualization(VisualizeGameState);

    History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	//add the world message
	BuildTrack = EmptyTrack;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	BuildTrack.StateObject_NewState = UnitState;
	BuildTrack.StateObject_OldState = UnitState;
	BuildTrack.VisualizeActor = UnitState.GetVisualizer();

	MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = default.INTERVENTION_INTEL_COST;
	MessageAction.AddWorldMessage(`XEXPAND.ExpandString(default.strIntervention_WorldMessage));
}

function XComGameState InterventionAbility_BuildGameState( XComGameStateContext Context )
{
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameStateHistory History;
	local XComGameState_UITimer UiTimer, UpdatedUiTimer;
	local StrategyCost InterventionCost;
	local array<StrategyCostScalar> CostScalars;
	local ArtifactCost IntelCost;

	History = `XCOMHISTORY;
	//Build the new game state frame
	NewGameState = History.CreateNewGameState(true, Context);

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID, eReturnType_Reference));
	AbilityTemplate = AbilityState.GetMyTemplate();
	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));

	//Apply the cost of the ability
	AbilityTemplate.ApplyCost(AbilityContext, AbilityState, UnitState, none, NewGameState);
	NewGameState.AddStateObject(UnitState);

	//update the mission timer, if there is one
	UiTimer = XComGameState_UITimer(History.GetSingleGameStateObjectForClass(class 'XComGameState_UITimer', true));
	if (UiTimer != none)
	{
		//This functionality is being added to the SeqAct and kismet separately, so it will update from the XCGS_UITimer
		//AddToMissionTimerVariable(default.INTERVENTION_EXTRA_TURNS);

		UpdatedUiTimer = XComGameState_UITimer(NewGameState.CreateStateObject(class 'XComGameState_UITimer', UiTimer.ObjectID));
		NewGameState.AddStateObject(UpdatedUiTimer);

		UpdatedUiTimer.TimerValue += default.INTERVENTION_EXTRA_TURNS;
		if(UpdatedUiTimer.TimerValue > 3) // the 3 value is hard-coded into the kismet mission maps, so we hard-code it here as well
		{
			UpdatedUiTimer.UiState = Normal_Blue;
		}
	}

	//apply the intel cost
	CostScalars.length = 0;
	IntelCost.ItemTemplateName = 'Intel';
	IntelCost.Quantity = default.INTERVENTION_INTEL_COST;
	InterventionCost.ResourceCosts.Additem(IntelCost);
	`XCOMHQ.PayStrategyCost(NewGameState, InterventionCost, CostScalars);

	//XComHQ.AddResource(NewGameState, 'Intel', -default.INTERVENTION_INTEL_COST);

	//Return the game state we have created
	return NewGameState;
}

//code that attempts to increment the kismet timer int value
//doesn't work for that (but does for Timer.DefaultTurns), so not currently used
static function AddToMissionTimerVariable(int AddedValue, optional string VariableName)
{
	local WorldInfo LocalWorldInfo;
	local array<SequenceVariable> OutVariables;
	local SequenceVariable SeqVar;
	local SeqVar_Int SeqVarTimer;

	LocalWorldInfo = `XWORLDINFO;
	if(VariableName == "")
		VariableName = "Timer.TurnsRemaining";

	LocalWorldInfo.MyKismetVariableMgr.RebuildVariableMap();
	LocalWorldInfo.MyKismetVariableMgr.GetVariable(name(VariableName), OutVariables);

	foreach OutVariables(SeqVar)
	{
		SeqVarTimer = SeqVar_Int(SeqVar);
		if(SeqVarTimer != none)
		{
			if(SeqVarTimer.VarName == name(VariableName))
			{
				`LOG("Found KismetVariable " $ SeqVar.VarName $ ", Value= " $ SeqVarTimer.IntValue);
				SeqVarTimer.IntValue = SeqVarTimer.IntValue + AddedValue;
			}
		}
	}
}

// code that attempts to set a kismet boolean value -- currently unused
static function SetMissionBoolVariable(bool NewValue, optional string VariableName)
{
	local WorldInfo LocalWorldInfo;
	local array<SequenceVariable> OutVariables;
	local SequenceVariable SeqVar;
	local SeqVar_Bool SeqVarB;

	LocalWorldInfo = `XWORLDINFO;
	if(VariableName == "")
		VariableName = "Mission.TimerEngaged";

	LocalWorldInfo.MyKismetVariableMgr.RebuildVariableMap();
	LocalWorldInfo.MyKismetVariableMgr.GetVariable(name(VariableName), OutVariables);

	foreach OutVariables(SeqVar)
	{
		SeqVarB = SeqVar_Bool(SeqVar);
		if(SeqVarB != none)
		{
			if(SeqVarB.VarName == name(VariableName))
			{
				`LOG("Found KismetVariable " $ SeqVar.VarName $ ", Value= " $ SeqVarB.bValue);
				SeqVarB.bValue = int(NewValue);
			}
		}
	}
}

//method that bypasses the Fxs KismetVariable Manager - FOR TESTING ONLY
private function AddToMissionTimerVariable_Direct(int AddedValue)
{
	local WorldInfo LocalWorldInfo;
	local array<SequenceObject> OutObjects;
	//local array<SequenceVariable> OutVariables;
	local SequenceObject SeqObj;
	local SequenceVariable SeqVar;
	local SeqVar_Int SeqVarTimer;
	local Sequence CurrentSequence;
	//local array<Sequence> AllSequences;
	local string VariableName;
	//local int idx;

	LocalWorldInfo = `XWORLDINFO;
	VariableName = "Timer.TurnsRemaining";

	CurrentSequence = LocalWorldInfo.GetGameSequence();
	if(CurrentSequence == none)
		return;

	//AllSequences = LocalWorldInfo.GetAllRootSequences();

	CurrentSequence.FindSeqObjectsByClass(class'SequenceVariable', true, OutObjects);

	//CurrentSequence.FindSeqObjectsByName("Timer.TurnsRemaining", false, OutObjects, true);

	//for(idx = 0; idx < AllSequences.Length; idx++)
	//{
		//AllSequences[idx].FindSeqObjectsByClass(class'SequenceVariable', true, OutObjects);
		foreach OutObjects(SeqObj)
		{
			SeqVar = SequenceVariable(SeqObj);
			if(SeqVar != none)
			{
				SeqVarTimer = SeqVar_Int(SeqVar);
				if(SeqVarTimer != none)
				{
					if(SeqVarTimer.VarName == name(VariableName))
					{
						//`LOG("Found KismetVariable in Seq(" $ idx $ "): " $ SeqVar.VarName $ ", Value= " $ SeqVarTimer.IntValue);
						`LOG("Found KismetVariable: " $ SeqVar.VarName $ ", Value= " $ SeqVarTimer.IntValue);
						SeqVarTimer.IntValue = SeqVarTimer.IntValue + AddedValue;
					}
				}
			}
		}
	//}
}


static function X2AbilityTemplate AddIncomingAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_Incoming					StatEffect;
	local X2Condition_UnitActionPoints		ValidTargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Incoming');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityIncoming";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = 317;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AddShooterEffectExclusions();

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.INCOMING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_LWOfficerCommandRange';
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeUnrevealedAI = true;
	UnitPropertyCondition.ExcludeConcealed = false;
	UnitPropertyCondition.TreatMindControlledSquadmateAsHostile = true;
	UnitPropertyCondition.ExcludeAlive = false;
    UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.RequireSquadmates = true;
    UnitPropertyCondition.ExcludePanicked = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	UnitPropertyCondition.ExcludeStunned = true;
	UnitPropertyCondition.ExcludeNoCover = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	ValidTargetCondition = new class'X2Condition_UnitActionPoints';
	ValidTargetCondition.AddActionPointCheck(0,'Suppression',true,eCheck_LessThanOrEqual);
	Template.AbilityTargetConditions.AddItem(ValidTargetCondition);
	Template.AbilityMultiTargetConditions.AddItem(ValidTargetCondition);

	StatEffect = new class'X2Effect_Incoming';
	StatEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	StatEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); // adjust?
	StatEffect.EffectName = 'Incoming';
	StatEffect.DuplicateResponse = eDupe_Refresh;
	StatEffect.ExplosivesDamageReduction = default.INCOMING_EXPLOSIVES_DR;
	StatEffect.TargetConditions.AddItem(UnitPropertyCondition); // prevent exclusion on effect apply instead of in targeting
	StatEffect.TargetConditions.AddItem(ValidTargetCondition);
	Template.AddTargetEffect(StatEffect);
	Template.AddMultiTargetEffect(StatEffect);

	Template.ActivationSpeech = 'HoldTheLine';
	Template.BuildVisualizationFn = Incoming_BuildVisualization;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate AddJammerAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCost_ActionPoints		ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Jammer');

	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityJammer";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = 316;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AddShooterEffectExclusions();

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.JAMMER_ACTION_POINTS;
	ActionPointCost.bfreeCost = false;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = default.JAMMER_CHARGES;
    Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	//Template.AbilityConfirmSound = "Unreal2DSounds_TargetLock";
	//Template.CustomFireAnim = 'HL_SignalBark';
	//Template.ActivationSpeech = 'Inspire';

	Template.BuildVisualizationFn = JammerAbility_BuildVisualization;
	Template.BuildNewGameStateFn = JammerAbility_BuildGameState;

	return Template;
}

function JammerAbility_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameState_Unit			SourceState;
	local XComGameStateContext_Ability  Context;
	local VisualizationActionMetadata	BuildTrack;
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local SoundCue						ChatterCue;

	TypicalAbility_BuildVisualization(VisualizeGameState);

	// Use an SoundAndFlyover to play a SoundCue
	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	SourceState = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));

	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(SourceState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(SourceState.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(SourceState.ObjectID);

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, Context, false, BuildTrack.LastActionAdded));

	ChatterCue = SoundCue(DynamicLoadObject("LW_Overhaul_SoundFX.AbilitySounds.ExaltChatter_Cue", class'SoundCue'));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(ChatterCue, "", '', eColor_Good);
}

function XComGameState JammerAbility_BuildGameState( XComGameStateContext Context )
{
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameStateHistory History;
	local XComGameState_AIReinforcementSpawner ReinforcementSpawner, UpdatedSpawner;

	History = `XCOMHISTORY;
	//Build the new game state frame
	NewGameState = History.CreateNewGameState(true, Context);

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID, eReturnType_Reference));
	AbilityTemplate = AbilityState.GetMyTemplate();

	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));
	//Apply the cost of the ability
	AbilityTemplate.ApplyCost(AbilityContext, AbilityState, UnitState, none, NewGameState);
	NewGameState.AddStateObject(UnitState);

	foreach History.IterateByClassType(class'XComGameState_AIReinforcementSpawner', ReinforcementSpawner)
	{
		UpdatedSpawner = XComGameState_AIReinforcementSpawner(NewGamestate.CreateStateObject(class'XComGameState_AIReinforcementSpawner', ReinforcementSpawner.ObjectID));
		NewGameState.AddStateObject(UpdatedSpawner);
		UpdatedSpawner.CountDown += 1;
	}

	//Return the game state we have created
	return NewGameState;
}

static function X2AbilityTemplate AddAirControllerAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_AirController			AirControllerEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AirController');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityAirController";
	Template.AbilitySourceName = default.OfficerSourceName;
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.ShotHUDPriority = 555;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	AirControllerEffect = new class'X2Effect_AirController';
	AirControllerEffect.BuildPersistentEffect(1, true, true);
	AirControllerEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(AirControllerEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	return Template;
}

static function X2AbilityTemplate AddInfiltratorAbility()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('Infiltrator', "img:///UILibrary_LW_Overhaul.LW_AbilityInfiltrator", false, 'eAbilitySource_Perk');
	return Template;
}

function GetSome_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack, TargetTrack;
    local X2Action_PlayAnimation			PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover, SoundAndFlyoverTarget;
	local XComGameState_Ability				Ability;
	local XComGameState_Effect				EffectState;
	local XComGameState_Unit				UnitState;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_xcom);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_SignalBark';
	PlayAnimationAction.bFinishAnimationWait = true;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'GetSome')
		{
				TargetTrack = EmptyTrack;
				UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				if ((UnitState != none) && (EffectState.StatChanges.Length > 0))
				{
					TargetTrack.StateObject_NewState = UnitState;
					TargetTrack.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
					TargetTrack.VisualizeActor = UnitState.GetVisualizer();
					SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
					SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Good);
				}
		}
	}
}


function Incoming_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack, TargetTrack;
    local X2Action_PlayAnimation			PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover, SoundAndFlyoverTarget;
	local XComGameState_Ability				Ability;
	local XComGameState_Effect				EffectState;
	local XComGameState_Unit				UnitState;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, '', eColor_xcom);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'LL_SignalGoAheadFwd';
	PlayAnimationAction.bFinishAnimationWait = true;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'Incoming')
		{
			TargetTrack = EmptyTrack;
			UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
			if (UnitState != none)
			{
				TargetTrack.StateObject_NewState = UnitState;
				TargetTrack.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
				TargetTrack.VisualizeActor = UnitState.GetVisualizer();

				PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
				PlayAnimationAction.Params.AnimName = 'LL_HunkerDwn_Start';
				PlayAnimationAction.bFinishAnimationWait = true;

				if (InteractingUnitRef.ObjectID != UnitState.ObjectID)
				{
					SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
					SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Good);
				}
			}
		}
	}
}


function OscarMike_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack, TargetTrack;
    local X2Action_PlayAnimation			PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover, SoundAndFlyoverTarget;
	local XComGameState_Ability				Ability;
	local XComGameState_Effect				EffectState;
	local XComGameState_Unit				UnitState;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_xcom);

	class'X2Action_ExitCover'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_SignalYellA';
	PlayAnimationAction.bFinishAnimationWait = true;

	class'X2Action_EnterCover'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded);

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'OscarMike')
		{
				TargetTrack = EmptyTrack;
				UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				if ((UnitState != none) && (EffectState.StatChanges.Length > 0))
				{
					TargetTrack.StateObject_NewState = UnitState;
					TargetTrack.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
					TargetTrack.VisualizeActor = UnitState.GetVisualizer();
					SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
					SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Good);
				}
		}
	}
}

function FocusFire_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack, TargetTrack;
    local X2Action_PlayAnimation			PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover, SoundAndFlyoverTarget;
	local XComGameState_Ability				Ability;
	local XComGameState_Effect				EffectState;
	local XComGameState_Unit				UnitState;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_xcom);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    PlayAnimationAction.Params.AnimName = 'HL_SignalPointA';
	PlayAnimationAction.bFinishAnimationWait = true;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.ApplyEffectParameters.EffectRef.SourceTemplateName == 'FocusFire')
		{
				TargetTrack = EmptyTrack;
				UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				if (UnitState != none)
				{
					TargetTrack.StateObject_NewState = UnitState;
					TargetTrack.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
					TargetTrack.VisualizeActor = UnitState.GetVisualizer();
					SoundandFlyoverTarget = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(TargetTrack, context, false, TargetTrack.LastActionAdded));
					SoundandFlyoverTarget.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Good);
				}
		}
	}
}

static function X2AbilityTemplate AddLeadershipAbility()
{
	local X2AbilityTemplate						Template;
	local x2Effect_Persistent					PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Leadership');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityLeadership";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bCrossClassEligible = false;
	Template.bIsPassive = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
    Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	Template.AdditionalAbilities.AddItem('EspritdeCorps');
	return Template;
}


static function X2AbilityTemplate AddEspritdeCorpsAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_EspritdeCorps				StatEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EspritdeCorps');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityLeadership";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	StatEffect = new class'X2Effect_EspritdeCorps';
	StatEFfect.BuildPersistentEffect (1, true, true, false);

	StatEFfect.SetSourceDisplayInfo(ePerkBuff_Passive, "ERROR", "ERROR", Template.IconImage, false);
	StatEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	StatEffect.WillPerMission = default.LEADERSHIP_WILL_PER_MISSION;
	StatEffect.WillCap = default.LEADERSHIP_WILL_CAP;
	StatEFfect.DodgePerMission = default.LEADERSHIP_DODGE_PER_MISSION;
	StatEFfect.DodgeCap = default.LEADERSHIP_DODGE_CAP;
	StatEFfect.AimPerMission = default.LEADERSHIP_AIM_PER_MISSION;
	StatEFfect.AimCap = default.LEADERSHIP_AIM_CAP;
	StatEFfect.DefensePerMission = default.LEADERSHIP_DEFENSE_PER_MISSION;
	StatEFfect.DefenseCap = default.LEADERSHIP_DEFENSE_CAP;
	Template.AddMultiTargetEffect(StatEffect);

	Template.bSkipFireAction = true;
	Template.bCrossClassEligible = false;
	Template.bDontDisplayInAbilitySummary = true;
	//Template.bDisplayInUITooltip = false;
	//Template.bDisplayInUITacticalText = false;
	//Template.HideIfAvailable.AddItem('Leadership');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


DefaultProperties
{
	OfficerSourceName = "eAbilitySource_Perk"
}
