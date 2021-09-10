class X2Effect_NukeKnockback extends X2Effect_Knockback;

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_Knockback KnockbackAction;

	if (EffectApplyResult == 'AA_Success')
	{
		if( ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit') )
		{
			KnockbackAction = X2Action_Knockback(class'X2Action_Knockback'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			if( OverrideRagdollFinishTimerSec >= 0 )
			{
				KnockbackAction.OverrideRagdollFinishTimerSec = OverrideRagdollFinishTimerSec;
			}
		}
		/*else if (ActionMetadata.StateObject_NewState.IsA('XComGameState_EnvironmentDamage') || ActionMetadata.StateObject_NewState.IsA('XComGameState_Destructible'))
		{
			//This can be added by other effects, so check to see whether this track already has one of these
			//	Firaxis never actually added the check. Removing damage to terrain action.
			class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext());//auto-parent to damage initiating action
		}*/
	}
}