class X2TacticalGameRuleset_XComScamperObserver extends Object implements(X2GameRulesetEventObserverInterface);

// Needed by X2GameRulesetEventObserverInterface
event PreBuildGameStateFromContext(XComGameStateContext NewGameStateContext);
event CacheGameStateInformation();
event Initialize();

/// <summary>
/// This event is issued from within the context method ContextBuildGameState
/// </summary>
/// <param name="NewGameState">The state to examine</param>
event InterruptGameState(XComGameState NewGameState)
{
	ProcessGameState(NewGameState);
}

/// <summary>
/// Called immediately after the creation of a new game state via SubmitGameStateContext. 
/// Note that at this point, the state has already been committed to the history
/// </summary>
/// <param name="NewGameState">The state to examine</param>
event PostBuildGameState(XComGameState NewGameState)
{
	ProcessGameState(NewGameState);
}

protected function ProcessGameState(XComGameState SubmittedGameState)
{
	local XComGameState_BaseObject OutPreviousState, OutCurrentState;
	local XComGameStateContext_EffectRemoved EffectRemoveContext;
	local XComGameState_Unit SubmittedUnitState, OldUnitState;
	local array<StateObjectReference> EffectsToRemove;
	local XComGameState_Effect NewEffectState;
	local X2TacticalGameRuleset TacticalRules;
	local StateObjectReference EffectRef;
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local name EffectName;

	EffectName = class'X2Effect_ScamperPenalty'.default.EffectName;
	TacticalRules = `TACTICALRULES;
	History = `XCOMHISTORY;

	if (TacticalRules.HasTacticalGameEnded())
	{
		return;
	}

	foreach SubmittedGameState.IterateByClassType(class'XComGameState_Unit', SubmittedUnitState)
	{
		// Only care about units that have the penalty
		if (!SubmittedUnitState.IsUnitAffectedByEffectName(EffectName)) continue;

		// Get the previous state for comparison
		History.GetCurrentAndPreviousGameStatesForObjectID(SubmittedUnitState.ObjectID, OutPreviousState, OutCurrentState,, SubmittedGameState.HistoryIndex);
		OldUnitState = XComGameState_Unit(OutPreviousState);

		// Unit just spawned or something weird
		if (OldUnitState == none) continue;

		// Skip cases where the effect was just added
		if (!OldUnitState.IsUnitAffectedByEffectName(EffectName)) continue;

		// We are only interested in cases where there was a change in action points
		if (AreArraysSame(OldUnitState.ActionPoints, SubmittedUnitState.ActionPoints)) continue;

		// The penalty is removed in 2 cases:
		if (
			!AreArraysSame(OldUnitState.ActionPoints, SubmittedUnitState.ActionPoints) || // Unit's APs have changed
			!SubmittedUnitState.IsAbleToAct() // Or unit lost the ability to act (e.g. killed by ruler's reaction)
		)
		{
			EffectsToRemove.AddItem(SubmittedUnitState.GetUnitAffectedByEffectState(EffectName).GetReference());
		}
	}

	if (EffectsToRemove.Length == 0)
	{
		// Nothing found, we are done
		return;
	}

	EffectRemoveContext = XComGameStateContext_EffectRemoved(class'XComGameStateContext_EffectRemoved'.static.CreateXComGameStateContext());
	NewGameState = History.CreateNewGameState(true, EffectRemoveContext);

	foreach EffectsToRemove(EffectRef)
	{
		NewEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(class'XComGameState_Effect', EffectRef.ObjectID));
		NewEffectState.RemoveEffect(NewGameState, NewGameState);
	}

	TacticalRules.SubmitGameState(NewGameState);
}

simulated function bool AreArraysSame(array<name> Array1, array<name> Array2)
{
	local int i;
	
	if (Array1.Length != Array2.Length)
	{
		return false;
	}

	for (i = 0; i < Array1.Length; i++)
	{
		if (Array1[i] != Array2[i])
		{
			return false;
		}
	}

	return true;
}