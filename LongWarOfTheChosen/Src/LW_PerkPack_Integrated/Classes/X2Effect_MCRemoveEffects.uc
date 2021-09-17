class X2Effect_MCRemoveEffects extends X2Effect_RemoveEffects;


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent PersistentEffect;
    local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(kNewTargetState);
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if ((bCheckSource && (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)) ||
			(!bCheckSource && (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)))
		{
			PersistentEffect = EffectState.GetX2Effect();
			if (ShouldRemoveEffect(EffectState, PersistentEffect))
			{
				EffectState.RemoveEffect(NewGameState, NewGameState, bCleanse);
                //Set their AP to 0 so they don't get to move immediately beacuse of panic refunds and shit
                TargetUnit.ActionPoints.Length = 0;
			}
		}
	}
}

DefaultProperties
{
	bCleanse = true
	bDoNotVisualize=false
}