//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_Collector.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is a component extension for Effect GameStates, containing
//				additional data used for Collector.
//---------------------------------------------------------------------------------------
class XComGameState_Effect_Collector extends XComGameState_BaseObject config(LW_OfficerPack);

var int IntelCollected;

function XComGameState_Effect_Collector InitComponent()
{
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

// WOTC TODO: Work out why there's another version of this method in X2Ability_OfficerAbilitySet
function EventListenerReturn CollectionCheck(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	//local XComGameState_Ability				AbilityState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local int								RandRoll, IntelGain;
	local XComGameState_Unit				SourceUnit, DeadUnit, CollectionUnit;
	local XComGameState_Effect EffectState;
	local XComLWTuple OverrideActivation;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(GameState.GetContext());
	//AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	//`log("Collection: AbilityState=" $ AbilityState.GetMyTemplateName());
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	//`LOG ("COLLECTION:" @ string(SourceUnit.GetMyTemplateName()));

	EffectState = GetOwningEffect();
	if (EffectState == none)
	{
		`RedScreen("ScavengerCheck: no parent effect");
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
	`XEVENTMGR.TriggerEvent('OverrideCollectorActivation', OverrideActivation, self);

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
	//`LOG ("COLLECTION:" @ string(DeadUnit.GetMyTemplateName()));
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
				if (RandRoll < class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_BONUS_CHANCE)
				{
					IntelGain = class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_BONUS_INTEL_LOW + `SYNC_RAND_STATIC(class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_BONUS_INTEL_RANDBONUS);
					If (IntelGain > 0 && IntelCollected <= class'X2Ability_OfficerAbilitySet'.default.COLLECTOR_MAX_INTEL_PER_MISSION)
					{
						//option 1 -- attach to existing state, use PostBuildVisualization
						XCOMHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
						XCOMHQ.AddResource(GameState, 'Intel', IntelGain);
						GameState.GetContext().PostBuildVisualizationFn.AddItem(Collector_BuildVisualization);

						IntelCollected += IntelGain;

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

function Collector_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		Context;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack;
	local XComGameState_Unit				UnitState;
    local X2Action_PlayWorldMessage			MessageAction;

	//local XComPresentationLayer				Presentation;
    //local XGParamTag						kTag;
    //local StateObjectReference				InteractingUnitRef;
	//local X2Action_PlaySoundAndFlyOver		SoundAndFlyoverTarget;
	//local XComGameState_Ability				Ability;
	//local XComGameState_Effect				EffectState;


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
	MessageAction.AddWorldMessage(class'X2Ability_OfficerAbilitySet'.default.strCollector_WorldMessage);
}
