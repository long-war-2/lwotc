//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Collector
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Implements effect for Collector ability
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Collector extends X2Effect_Persistent config(LW_OfficerPack);

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	// allows activation/deactivation of effect
	`XEVENTMGR.RegisterForEvent(EffectObj, 'KillMail', CollectionCheck, ELD_OnStateSubmitted,,,, EffectObj);
}

// The following methods supersede the ones with the same names
// in X2Ability_OfficerAbilitySet
static function EventListenerReturn CollectionCheck(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
	local XComGameState						NewGameState;
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local XComGameState_HeadquartersXCom	XComHQ;
	local int								RandRoll, IntelGain;
	local XComGameState_Unit				SourceUnit, DeadUnit, CollectionUnit;
	local XComGameState_Effect_EffectCounter EffectState;
	local XComLWTuple OverrideActivation;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(GameState.GetContext());
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));

	EffectState = XComGameState_Effect_EffectCounter(CallbackData);
	if (EffectState == none)
	{
		`RedScreen("ScavengerCheck: no effect game state");
		return ELR_NoInterrupt;
	}

	if (EffectState.bReadOnly) // this indicates that this is a stale effect from a previous battle
		return ELR_NoInterrupt;

	CollectionUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (CollectionUnit == none)
		CollectionUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (CollectionUnit == none)
	{
		`RedScreen("CollectorCheck: no collector officer unit");
		return ELR_NoInterrupt;
	}

	// Allow an event handler to override the activation of collector by setting the boolean
	// value of the Tuple to true.
	OverrideActivation = new class'XComLWTuple';
	OverrideActivation.Id = 'OverrideCollectorActivation';
	OverrideActivation.Data.Length = 1;
	OverrideActivation.Data[0].kind = XComLWTVBool;
	OverrideActivation.Data[0].b = true;
	`XEVENTMGR.TriggerEvent('OverrideCollectorActivation', OverrideActivation, EffectState);

	if(OverrideActivation.Data[0].b)
	{
		`LOG("Skipping Collector From Override");
		return ELR_NoInterrupt;
	}

	if(!CollectionUnit.IsAbleToAct()) { return ELR_NoInterrupt; }
	if(CollectionUnit.bRemovedFromPlay) { return ELR_NoInterrupt; }
	if(CollectionUnit.IsMindControlled()) { return ELR_NoInterrupt; }

	If (SourceUnit == none)
	{
		`Redscreen("CollectionCheck: No source");
		return ELR_NoInterrupt;
	}
	DeadUnit = XComGameState_Unit(EventData);
	If (DeadUnit == none)
	{
		`Redscreen("CollectionCheck: No killed unit");
		return ELR_NoInterrupt;
	}
	IntelGain = 0;
	if (DeadUnit.IsEnemyUnit(SourceUnit) && SourceUnit.GetTeam() == eTeam_XCom &&
		!DeadUnit.IsMindControlled() && DeadUnit.GetMyTemplateName() != 'PsiZombie' &&
		DeadUnit.GetMyTemplateName() != 'PsiZombieHuman')
	{
		RandRoll = `SYNC_RAND_STATIC(100);
		if (RandRoll < class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_BONUS_CHANCE)
		{
			IntelGain = class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_BONUS_INTEL_LOW + `SYNC_RAND_STATIC(class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_BONUS_INTEL_RANDBONUS);
			if (IntelGain > 0 && EffectState.uses < class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_MAX_INTEL_PER_MISSION)
			{
				// Make sure intel gain doesn't go over max allowed.
				IntelGain = Min(IntelGain, class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_MAX_INTEL_PER_MISSION - EffectState.uses);

				// Add the intel to XCOM HQ
				XCOMHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
				XCOMHQ.AddResource(GameState, 'Intel', IntelGain);
				GameState.GetContext().PostBuildVisualizationFn.AddItem(Collector_BuildVisualization);

				// Save the new total intel gained this mission
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
				EffectState = XComGameState_Effect_EffectCounter(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
				EffectState.uses += IntelGain;
				`TACTICALRULES.SubmitGameState(NewGameState);
			}
		}
	}
	return ELR_NoInterrupt;
}

static function Collector_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		Context;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack;
	local XComGameState_Unit				UnitState;
    local X2Action_PlayWorldMessage			MessageAction;

    History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	BuildTrack = EmptyTrack;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	BuildTrack.StateObject_NewState = UnitState;
	BuildTrack.StateObject_OldState = UnitState;
	BuildTrack.VisualizeActor = UnitState.GetVisualizer();
	MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	MessageAction.AddWorldMessage(class'X2Ability_OfficerAbilitySet'.default.strCollector_WorldMessage);
}

defaultproperties
{
	EffectName=Collector;
	GameStateEffectClass=class'XComGameState_Effect_EffectCounter';
	bRemoveWhenSourceDies=false;
}
