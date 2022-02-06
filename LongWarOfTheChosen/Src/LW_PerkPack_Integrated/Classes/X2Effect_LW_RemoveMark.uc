//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_LW_RemoveMark.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: An effect that removes the effects from both tracking mark target, and source
//---------------------------------------------------------------------------------------
class X2Effect_LW_RemoveMark extends X2Effect_RemoveEffects;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect	EffectState;
	local X2Effect_Persistent	PersistentEffect;
	local XComGameStateHistory	History;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Effect', EffectState)	//	cycle through ALL effects in History
	{		
		//`LOG("Found effect: " @ EffectState.GetX2Effect().EffectName,, 'IRIDAR');
		//	if this effect was applied BY THE SAME UNIT that is applying this Remove Effects effect
		if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)
		{
			//	and if the effect name fits
			PersistentEffect = EffectState.GetX2Effect();
			if (PersistentEffect.EffectName == class'X2Ability_ChosenSniper'.default.TrackingShotMarkTargetEffectName ||
				PersistentEffect.EffectName == class'X2Ability_ChosenSniper'.default.TrackingShotMarkSourceEffectName)
			{
				//`LOG("Removing it.",, 'IRIDAR');
				// remove it
				EffectState.RemoveEffect(NewGameState, NewGameState, bCleanse);

				//	in practice, this implementation should allow us to remove Hunter Mark effects from the enemy target even though we're technically not passing 
				//	the target state anywhere
			}
		}
	}
}
/*
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_AbilityPerkEnd	PerkEndAction;
	local XComGameState_Effect		EffectState;
	local X2Effect_Persistent		PersistentEffect;
	local XComGameStateHistory		History;

		History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Effect', EffectState)	//	cycle through ALL effects in History
	{		
		`LOG("Found effect: " @ EffectState.GetX2Effect().EffectName,, 'IRIDAR');
		//	if this effect was applied BY THE SAME UNIT that is applying this Remove Effects effect
		if (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)
		{
			//	and if the effect name fits
			PersistentEffect = EffectState.GetX2Effect();
			if (PersistentEffect.EffectName == class'X2Ability_ChosenSniper'.default.TrackingShotMarkTargetEffectName ||
				PersistentEffect.EffectName == class'X2Ability_ChosenSniper'.default.TrackingShotMarkSourceEffectName)
			{
				`LOG("Removing it.",, 'IRIDAR');
				// remove it
				PerkEndAction = X2Action_AbilityPerkEnd( class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
				PerkEndAction.PersistentPerkEffect = EffectState.GetX2Effect();
				EffectState.RemoveEffect(NewGameState, NewGameState, bCleanse);

				//	in practice, this implementation should allow us to remove Hunter Mark effects from the enemy target even though we're technically not passing 
				//	the target state anywhere
			}
		}
	}
}*/

