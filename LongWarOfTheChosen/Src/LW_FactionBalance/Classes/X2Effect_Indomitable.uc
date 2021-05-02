//  FILE:    X2Effect_Indomitable
//  AUTHOR:  Grobobobo
//  PURPOSE: Grants focus when shot.
//---------------------------------------------------------------------------------------
class X2Effect_Indomitable extends X2Effect_Persistent;

var name IndomitableValue;


function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', IndomitableListener, ELD_OnStateSubmitted,,,, EffectGameState);
}

static function EventListenerReturn IndomitableListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local UnitValue TotalValue;
	local XComGameState_Unit TargetUnit, SourceUnit;
	local XComGameState_Ability AbilityState;
   	local XComGameState_Effect_TemplarFocus FocusState;
	local XComGameState_Effect EffectGameState;

	AbilityState = XComGameState_Ability(EventData);
	EffectGameState = XComGameState_Effect(CallbackData);
	// Set to only Offensive abilities to prevent Reflex from being kicked off on Chosen Tracking Shot Marker.
	if (AbilityState.IsAbilityInputTriggered() && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
	{
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
		if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
		{
			if (AbilityContext.InputContext.PrimaryTarget.ObjectID == EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID)
			{
				SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
				if (SourceUnit == none)
					return ELR_NoInterrupt;

				TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				if (TargetUnit == none)
					TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				`assert(TargetUnit != none);

				if (TargetUnit.IsFriendlyUnit(SourceUnit))
					return ELR_NoInterrupt;

				TargetUnit.GetUnitValue(default.IndomitableValue, TotalValue);
				if (TotalValue.fValue >= 1)
					return ELR_NoInterrupt;


				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Skirmisher Reflex Immediate Action");
				TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(TargetUnit.Class, TargetUnit.ObjectID));
				TargetUnit.SetUnitFloatValue(default.IndomitableValue, TotalValue.fValue + 1, eCleanup_BeginTurn);

				FocusState = TargetUnit.GetTemplarFocusEffectState();
				if (FocusState != none)
				{
					FocusState = XComGameState_Effect_TemplarFocus(NewGameState.ModifyStateObject(FocusState.Class, FocusState.ObjectID));
					FocusState.SetFocusLevel(FocusState.FocusLevel + 1, TargetUnit, NewGameState);		
				}
                

				if (NewGameState != none)
				{
					NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectGameState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);
					XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectGameState.TriggerAbilityFlyoverVisualizationFn;
					`TACTICALRULES.SubmitGameState(NewGameState);
				}
			}
		}
	}
	
	return ELR_NoInterrupt;
}

defaultproperties
{
    IndomitableValue="IndomitableUnitValue"
}
