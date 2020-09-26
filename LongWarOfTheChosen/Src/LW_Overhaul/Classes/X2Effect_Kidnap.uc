class X2Effect_Kidnap extends X2Effect_Persistent;
                         
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;
	`XEVENTMGR.RegisterForEvent(EffectObj, 'UnitBleedingOut', OnUnitBleedingOut, ELD_OnStateSubmitted, ,EffectObj);
}

static function EventListenerReturn OnUnitBleedingOut(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState, FlyOverGameState;
	local XComGameState_Unit UnitState, ChosenUnitState;
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;
	local name TargetTemplate;
	local X2EventManager EventManager;
	local XComGameState_Ability AbilityState;
	local XComGameState_Effect EffectState;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameStateContext_Ability AbilityContext;

	EventManager = `XEVENTMGR;
	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	UnitState = XComGameState_Unit(EventData);
	EffectState = XComGameState_Effect(CallBackData);
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Chosen Kidnapping a unit");

	//If this effect is to be removed on both source death and target death, the event manager can't filter events by objectID for us.
	//We might, then, get events for irrelevant units dying. (See comment in OnCreation.) -btopp 2015-08-26
	if (UnitState.ObjectID != EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID && UnitState.ObjectID != EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID)
		return ELR_NoInterrupt;

	if(UnitState != none && (UnitState.IsBleedingOut()) && !Effectstate.bRemoved)
	{
		TargetTemplate = UnitState.GetMyTemplateName();
		//must be a human soldier
		if(TargetTemplate != 'Soldier' && 
			TargetTemplate != 'SkirmisherSoldier' &&
			TargetTemplate != 'TemplarSoldier' && 
			TargetTemplate != 'ReaperSoldier' )
			{
				return ELR_NoInterrupt;
			}

		ChosenUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		ChosenState = AlienHQ.GetChosenOfTemplate(ChosenUnitState.GetMyTemplateGroupName());
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
		ChosenState.CaptureSoldier(NewGameState, UnitState.GetReference());


		EventManager.TriggerEvent('UnitRemovedFromPlay', UnitState, UnitState, NewGameState);
		EventManager.TriggerEvent('UnitCaptured', UnitState, UnitState, NewGameState);
		EventManager.TriggerEvent('ChosenKidnap', AbilityState, UnitState, NewGameState);

		`TACTICALRULES.SubmitGameState(NewGameState);

		FlyOverGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("UPDATING VIZ FOR CHOSEN KIDNAP");
		UnitState = XComGameState_Unit(FlyOverGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
		AbilityState = XComGameState_Ability(FlyOverGameState.ModifyStateObject(AbilityState.Class, AbilityState.ObjectID));
		XComGameStateContext_ChangeContainer(FlyOverGameState.GetContext()).BuildVisualizationFn = ChosenKidnapVisualizationFn;


		`TACTICALRULES.SubmitGameState(FlyOverGameState);
	}

	return ELR_NoInterrupt;
}

function ChosenKidnapVisualizationFn(XComGameState VisualizeGameState)
{
	local XComGameState_Unit UnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameStateHistory History;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Ability	AbilityState;
	local X2Action_PlayEffect EffectAction;
	local X2Action_Delay DelayAction;
	local XComGameStateContext_Ability Context;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	History = `XCOMHISTORY;
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		foreach VisualizeGameState.IterateByClassType(class'XComGameState_Ability', AbilityState)
		{
			break;
		}
		if (AbilityState == none)
		{
			`RedScreenOnce("Ability state missing from" @ GetFuncName() @ "-jbouscher @gameplay");
			return;
		}
		History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
		ActionMetadata.StateObject_NewState = UnitState;
		ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

		AbilityTemplate = AbilityState.GetMyTemplate();
		if (AbilityTemplate != none)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good, AbilityTemplate.IconImage, `DEFAULTFLYOVERLOOKATTIME, true);
		}


		History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
		ActionMetadata.StateObject_NewState = UnitState;
		ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

		EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false));
		EffectAction.EffectName = "FX_Chosen_Teleport.P_Chosen_Teleport_Out_w_Sound";
		EffectAction.EffectLocation = ActionMetadata.VisualizeActor.Location;
		EffectAction.bWaitForCompletion = false;
	
		DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, Context, false));
		DelayAction.Duration = 0.25;
	
		class'X2Action_RemoveUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, DelayAction);
	
		
		break;
	}
}

