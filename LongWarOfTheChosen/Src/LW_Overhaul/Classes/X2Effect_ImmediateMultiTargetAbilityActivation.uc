//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ImmediateMultiTargetAbilityActivation.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Variation of base-game ImmediateAbilityActivation that works correctly when applied to multiple targets
//---------------------------------------------------------------------------------------
class X2Effect_ImmediateMultiTargetAbilityActivation extends X2Effect_Persistent;

var name AbilityName;      // Used to identify the ability that this effect will trigger

var private name EventName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit						SourceUnit, TargetUnit;
	local XComGameStateHistory						History;
	local X2EventManager							EventManager;
	local Object									ListenerObj;
	local XComGameState_Effect_ImmediateMultiTarget EffectComponentState;

	History = `XCOMHISTORY;
	EventManager = `XEVENTMGR;

	if (GetEffectComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		EffectComponentState = XComGameState_Effect_ImmediateMultiTarget(NewGameState.CreateStateObject(class'XComGameState_Effect_ImmediateMultiTarget'));
		EffectComponentState.InitComponent();
		NewEffectState.AddComponentObject(EffectComponentState);
		NewGameState.AddStateObject(EffectComponentState);
	}

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	//add listener to new component effect -- do it here so that the effect component has been created
	ListenerObj = EffectComponentState;
	if (ListenerObj == none)
	{
		`Redscreen("ImmediateMultiTarget: Failed to find ImmediateMultiTarget Component when registering listener");
		return;
	}
	EventManager.RegisterForEvent(ListenerObj, default.EventName, EffectComponentState.OnFireImmediateMultiTargetAbility, ELD_OnStateSubmitted,, SourceUnit);

	if (AbilityName == '')
	{
		`RedScreen("X2Effect_ImmediateMultiTargetAbilityActivation - AbilityName must be set:"@AbilityName);
	}

	EventManager.TriggerEvent(default.EventName, TargetUnit, SourceUnit, NewGameState);
}

static function XComGameState_Effect_ImmediateMultiTarget GetEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_ImmediateMultiTarget(Effect.FindComponentObject(class'XComGameState_Effect_ImmediateMultiTarget'));
	return none;
}

defaultproperties
{
	EventName="MultiTargetTriggerImmediateAbility"
}