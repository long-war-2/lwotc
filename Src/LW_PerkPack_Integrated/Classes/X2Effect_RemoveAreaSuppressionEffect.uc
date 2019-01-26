//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_RemoveAreaSuppressionEffect.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Adds conditional to RemoveEffects to only remove the effect once ammo is depleted
//--------------------------------------------------------------------------------------- 

class X2Effect_RemoveAreaSuppressionEffect extends X2Effect_RemoveEffects;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState;
	local XComGameState_Unit SourceState;
	local X2Effect_Persistent PersistentEffect;
	local bool MatchesTarget;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		// only remove suppression effects matching the source taking the suppression shot
		if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID) 
		{
			PersistentEffect = EffectState.GetX2Effect();
			if (ShouldRemoveEffect(EffectState, PersistentEffect)) // basic check that the effectname matches
			{
				MatchesTarget = EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID;

				SourceState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
				if(SourceState == none)
				{
					SourceState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
				}
				if (MatchesTarget || class'X2Effect_AreaSuppression'.static.ShouldRemoveAreaSuppression(SourceState, NewGameState, true)) // remove if either matches target or area suppression is shutting down
				{
					EffectState.RemoveEffect(NewGameState, NewGameState, bCleanse);
				}
			}
		}
	}
}

//source is not target, and no visualization on target
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	return;
}

//fix up to pass the EffectState being removed to the CleansedVisualiation
simulated function AddX2ActionsForVisualizationSource(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Effect EffectState;
	local X2Effect_AreaSuppression Effect;

	if (EffectApplyResult != 'AA_Success')
		return;

	//  We are assuming that any removed effects were cleansed by this RemoveEffects. If this turns out to not be a good assumption, something will have to change.
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if (EffectState.bRemoved)
		{
			if (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == BuildTrack.StateObject_NewState.ObjectID)
			{
				Effect = X2Effect_AreaSuppression(EffectState.GetX2Effect());
				if (Effect != none)
					Effect.CleansedAreaSuppressionVisualization(VisualizeGameState, BuildTrack, EffectApplyResult, EffectState);
			}
			else if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == BuildTrack.StateObject_NewState.ObjectID)
			{
				Effect = X2Effect_AreaSuppression(EffectState.GetX2Effect());
				if (Effect != none)
					Effect.AddX2ActionsForVisualization_RemovedSource(VisualizeGameState, BuildTrack, EffectApplyResult, EffectState);
			}
		}
	}
}