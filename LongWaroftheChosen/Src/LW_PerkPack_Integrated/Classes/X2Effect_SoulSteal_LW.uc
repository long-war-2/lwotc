class X2Effect_SoulSteal_LW extends X2Effect_PersistentStatChange;

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, name EffectApplyResult)
{
	local XComGameState_Unit OldUnitState, NewUnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local string Msg;

	`LOG ("Soul Steal 2 activated");
	if (EffectApplyResult == 'AA_Success')
	{
		OldUnitState = XComGameState_Unit(BuildTrack.StateObject_OldState);
		NewUnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
		if (OldUnitState != none && NewUnitState != none)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
			Msg = class'XGLocalizedData'.Default.ShieldedMessage;
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
		}
	}
}