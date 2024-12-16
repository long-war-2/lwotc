class X2Effect_RemoveImmobilize extends X2Effect_RemoveEffects;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent PersistentEffect;
    local bool bReaddImmobilize;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', EffectState)
	{
		if ((bCheckSource && (EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)) ||
			(!bCheckSource && (EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)))
		{
			PersistentEffect = EffectState.GetX2Effect();
			if (ShouldRemoveEffect(EffectState, PersistentEffect))
			{
				EffectState.RemoveEffect(NewGameState, NewGameState, bCleanse);
                bReaddImmobilize = true;
			}
		}
	}

    if(bReaddImmobilize)
    {
        `XEVENTMGR.TriggerEvent('ReaddImmobilize', XComGameState_Unit(kNewTargetState), XComGameState_Unit(kNewTargetState));
    }
}

DefaultProperties
{
	bCleanse = true
	bDoNotVisualize=true
}