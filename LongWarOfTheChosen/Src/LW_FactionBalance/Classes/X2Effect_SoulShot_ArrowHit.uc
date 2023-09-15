class X2Effect_SoulShot_ArrowHit extends X2Effect;

// If target is killed by the attack that applied this effect, play a particle effect on the target that will spawn an arrow stuck in its chest.

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlayEffect	EffectAction;
	local XComGameState_Unit	UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (EffectApplyResult == 'AA_Success' && UnitState != none && UnitState.IsDead())
	{
		EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
		EffectAction.EffectName = "IRISoulShotPerk.PS_Arrow_Persistent";
		EffectAction.AttachToUnit = true;
		EffectAction.AttachToSocketName = 'IRI_SoulBow_Arrow_Hit';
		EffectAction.AttachToSocketsArrayName = 'BoneSocketActor';
	}
}
