class X2Effect_GreatestChampion extends X2Effect_PersistentStatChange;


simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Effect	TetherEffectState;
	local X2Effect_Persistent PersistentEffect;
    local bool DrRemoved, RegenRemoved;
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect', TetherEffectState)
	{
		if (ApplyEffectParameters.SourceStateObjectRef.ObjectID == TetherEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID)
		{
			PersistentEffect = TetherEffectState.GetX2Effect();
			if (PersistentEffect.EffectName == 'WarlockDamageReduction' && !DrRemoved)
			{
				if(!TetherEffectState.bRemoved)
				{	
					TetherEffectState.RemoveEffect(NewGameState, NewGameState);
                    DrRemoved = true;
				}

			}
            if (PersistentEffect.EffectName == 'WarlockRegeneration' && !RegenRemoved)
			{
				if(!TetherEffectState.bRemoved)
				{	
					TetherEffectState.RemoveEffect(NewGameState, NewGameState);
                    RegenRemoved = true;
				}

			}
        }
	}
}
