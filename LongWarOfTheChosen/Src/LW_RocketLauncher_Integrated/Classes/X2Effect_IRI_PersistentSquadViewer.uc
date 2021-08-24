class X2Effect_IRI_PersistentSquadViewer extends X2Effect_PersistentSquadViewer;

//	Same as the original, except we remove the Viewer with an X2Action so it can happen at a specific moment during ability visualization.

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local X2Action_AbilityPerkDurationEnd	PerkEnded;
	local X2Action_RemoveViewer				RemoveViewer;

	RemoveViewer = X2Action_RemoveViewer(class'X2Action_RemoveViewer'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	RemoveViewer.SquadViewer = XComGameState_SquadViewer(`XCOMHISTORY.GetGameStateForObjectID(RemovedEffect.CreatedObjectReference.ObjectID));

	PerkEnded = X2Action_AbilityPerkDurationEnd(class'X2Action_AbilityPerkDurationEnd'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	PerkEnded.EndingEffectState = RemovedEffect;
}