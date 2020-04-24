//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Implacable_LW
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies Implacable so that it can't proc on interrupt turns, like
//           the ones Skirmishers get with Battlelord.
//--------------------------------------------------------------------------------------- 

class X2Effect_Implacable_LW extends X2Effect_Implacable;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', NoInterruptImplacableCheck, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn NoInterruptImplacableCheck(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name Event,
	Object CallbackData)
{
	local XComGameState_Effect EffectState;
	local XComGameState_Unit SourceUnit;

	EffectState = XComGameState_Effect(CallbackData);
	if (EffectState != none)
	{
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(
				EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

		// Skip the Implacable handler if we're in an interrupt turn
		if (class'Helpers_LW'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
			return ELR_NoInterrupt;
		else
			return EffectState.ImplacableCheck(EventData, EventSource, GameState, Event, CallbackData);
	}

	return ELR_NoInterrupt;
}
