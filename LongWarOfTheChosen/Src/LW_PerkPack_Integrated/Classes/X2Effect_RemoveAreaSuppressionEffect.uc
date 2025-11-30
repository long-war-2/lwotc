//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_RemoveAreaSuppressionEffect.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Adds conditional to RemoveEffects to only remove the effect once ammo is depleted
//--------------------------------------------------------------------------------------- 

class X2Effect_RemoveAreaSuppressionEffect extends X2Effect_RemoveEffects;

// if `true` and the source ran out of ammo, Area Suppression
// will be removed from all units the source is suppressing
var bool bRemoveAll;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameStateHistory      History;
    local XComGameState_Effect      EffectState;
    local X2Effect_Persistent       PersistentEffect;
    local X2Effect_AreaSuppression  AreaSuppressionEffect;
    local bool                      bMatchesTarget;

    History = `XCOMHISTORY;

    foreach History.IterateByClassType(class'XComGameState_Effect', EffectState)
    {
        // only remove suppression effects if the source of the suppression matches
        if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)
        {
            PersistentEffect = EffectState.GetX2Effect();
            // basic check that the effectname matches
            if (ShouldRemoveEffect(EffectState, PersistentEffect))
            {
                bMatchesTarget = EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID;
                AreaSuppressionEffect = X2Effect_AreaSuppression(PersistentEffect);
                // remove if either matches target or area suppression is shutting down
                if (bMatchesTarget || bRemoveAll && AreaSuppressionEffect != none && AreaSuppressionEffect.ShouldRemoveAreaSuppression(EffectState, NewGameState, true))
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

defaultproperties
{
    bRemoveAll = true
}