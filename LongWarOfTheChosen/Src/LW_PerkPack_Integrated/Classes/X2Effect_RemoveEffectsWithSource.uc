//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_RemoveEffectsWithSource.uc
//  AUTHOR:  Merist / Based on X2Effect_RemoveEffects by Firaxis
//  PURPOSE: Removes the effects where the source of the effect
//           matches / doesn't match the source of this effect.
//---------------------------------------------------------------------------------------
class X2Effect_RemoveEffectsWithSource extends X2Effect;

var() array<name>   EffectNamesToRemove;
var() bool          bCleanse;           //  Indicates the effect was removed "safely" for gameplay purposes so any bad "wearing off" effects should not trigger
                                        //  e.g. Bleeding Out normally kills the soldier it is removed from, but if cleansed, it won't.
var() bool          bMatchSource;       //  Match the source of each effect to the source of this one.
var bool            bDoNotVisualize;    //  Adding this because an ability may have two X2Effect_RemoveEffects but we only need one to visualize because it is dumb

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Effect EffectState;
    local X2Effect_Persistent PersistentEffect;

    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', EffectState)
    {
        if (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)
        {
            if ((bMatchSource && (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID))
                || (!bMatchSource && (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID != ApplyEffectParameters.SourceStateObjectRef.ObjectID)))
            {
                PersistentEffect = EffectState.GetX2Effect();
                if (ShouldRemoveEffect(EffectState, PersistentEffect))
                {
                    // `LOG("Removing " $ EffectState.GetX2Effect().EffectName $ " from " $ XComGameState_Unit(kNewTargetState).GetMyTemplateName(), true, 'MeristRemoveEffectsWithSource');
                    EffectState.RemoveEffect(NewGameState, NewGameState, bCleanse);
                }
            }
        }
    }
}

simulated function bool ShouldRemoveEffect(XComGameState_Effect EffectState, X2Effect_Persistent PersistentEffect)
{
    return EffectNamesToRemove.Find(PersistentEffect.EffectName) != INDEX_NONE;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Effect EffectState;
    local X2Effect_Persistent Effect;

    if ((EffectApplyResult != 'AA_Success') ||
        bDoNotVisualize)
        return;

    //  We are assuming that any removed effects were cleansed by this RemoveEffects. If this turns out to not be a good assumption, something will have to change.
    foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect', EffectState)
    {
        if (EffectState.bRemoved)
        {
            if (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ActionMetadata.StateObject_NewState.ObjectID)
            {
                Effect = EffectState.GetX2Effect();
                if (Effect.CleansedVisualizationFn != none && bCleanse)
                {
                    Effect.CleansedVisualizationFn(VisualizeGameState, ActionMetadata, EffectApplyResult);
                }
                else
                {
                    Effect.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, EffectState);
                }
            }
            else if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ActionMetadata.StateObject_NewState.ObjectID)
            {
                Effect = EffectState.GetX2Effect();
                Effect.AddX2ActionsForVisualization_RemovedSource(VisualizeGameState, ActionMetadata, EffectApplyResult, EffectState);
            }
        }
    }
}

defaultproperties
{
    bCleanse = true
    bDoNotVisualize = false
    bMatchSource = true
}