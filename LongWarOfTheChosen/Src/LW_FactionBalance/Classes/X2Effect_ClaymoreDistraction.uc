//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ClaymoreDistraction
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Allows an additional ability to be triggered when a Claymore
//           explodes.
//--------------------------------------------------------------------------------------- 

class X2Effect_ClaymoreDistraction extends X2Effect_Persistent;

var name AbilityToTrigger;

// Registers a listener that is called when the Claymore is thrown, so that
// we can then attach another listener for when the Claymore is destroyed.
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;
	local XComGameState_Unit UnitState;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	XComGameState_Effect_AbilityTrigger(EffectGameState).AbilityToTrigger = AbilityToTrigger;

	`XEVENTMGR.RegisterForEvent(EffectObj, 'PersistentEffectAdded', OnClaymoreThrown, ELD_OnStateSubmitted,, UnitState,, EffectObj);
}

// This is called when a Claymore is thrown. It registers a listener that is
// called when the Claymore is destroyed.
static function EventListenerReturn OnClaymoreThrown(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Effect ClaymoreEffectState;
	local XComGameState_Destructible DestructibleState;

	ClaymoreEffectState = XComGameState_Effect(EventData);
	if (ClaymoreEffectState == none || ClaymoreEffectState.GetX2Effect().EffectName != 'Claymore')
	{
		// Not interested in any effect other than the one resulting from
		// the Throw Claymore ability.
		return ELR_NoInterrupt;
	}

	DestructibleState = XComGameState_Destructible(`XCOMHISTORY.GetGameStateForObjectID(ClaymoreEffectState.CreatedObjectReference.ObjectID));

	`XEVENTMGR.RegisterForEvent(CallbackData, 'ObjectDestroyed', OnClaymoreTriggered, ELD_OnStateSubmitted,, DestructibleState,, CallbackData);

	return ELR_NoInterrupt;
}

// Called when a Claymore is destroyed. It applies the configured ability
// to the targets within the Claymore's explosion radius.
static function EventListenerReturn OnClaymoreTriggered(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
	local XComGameState_Destructible DestructibleState;

	DestructibleState = XComGameState_Destructible(EventSource);
	if (DestructibleState == none)
		return ELR_NoInterrupt;

	ApplyAbilityToTargets(XComGameState_Effect_AbilityTrigger(CallbackData), DestructibleState);
	return ELR_NoInterrupt;
}

private static function ApplyAbilityToTargets(XComGameState_Effect_AbilityTrigger EffectState, XComGameState_Destructible DestructibleState)
{
	local XComDestructibleActor DestructibleActor;
	local XComGameState_Unit SourceUnit;
	local XComGameState_Ability AbilityState;
	local AvailableAction Action;
	local AvailableTarget Target;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	DestructibleActor = XComDestructibleActor(History.GetVisualizer(DestructibleState.ObjectID));
	if (DestructibleActor == none)
	{
		`REDSCREEN("Can't access destructible actor for Claymore");
		return;
	}

    SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	Action.AbilityObjectRef = SourceUnit.FindAbility(EffectState.AbilityToTrigger);

	if (Action.AbilityObjectRef.ObjectID == 0)
		return;

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Action.AbilityObjectRef.ObjectID));
	if (AbilityState == none)
		return;

	Action.AvailableCode = 'AA_Success';
	AbilityState.GatherAdditionalAbilityTargetsForLocation(DestructibleActor.Location, Target);
	Action.AvailableTargets.AddItem(Target);

	class'XComGameStateContext_Ability'.static.ActivateAbility(Action, 0, EffectState.ApplyEffectParameters.AbilityInputContext.TargetLocations);
}

defaultProperties
{
	GameStateEffectClass = class'XComGameState_Effect_AbilityTrigger';
	bInfiniteDuration = true;
}
