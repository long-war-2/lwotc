class X2Effect_Pinned extends X2Effect_Persistent;


function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{

	if(UnitState.CanTakeCover())
	{	
		if(ActionPoints.Length > 1) //Make so multiple suppressions don't completely disable an enemy
		{
			ActionPoints.Remove(0, 1);
		}
	}

}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "Pinned Down", '', eColor_Bad);
}