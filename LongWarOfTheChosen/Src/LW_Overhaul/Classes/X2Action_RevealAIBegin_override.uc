class X2Action_RevealAIBegin_override extends X2Action_RevealAIBegin;


state Executing
{

    // Only play reveal matinee for Chosen and reinforcements.
    // Ignore others.
    function bool ShouldPlayRevealMatinee()
    {
		local XComGameStateContext_ChangeContainer Context;
		local XComGameState_AIReinforcementSpawner SpawnState;
		local XComGameState_AIUnitData AIUnitData;
        local XComGameState_Unit UnitState;
        local X2CharacterTemplate Template;
        local string MatineePrefix;
        local int Index;

        if(RevealContext.RevealedUnitObjectIDs.Length > 0)
	    {		
		    for(Index = 0; Index < RevealContext.RevealedUnitObjectIDs.Length; ++Index)
		    {
			    UnitState = XComGameState_Unit(History.GetGameStateForObjectID(RevealContext.RevealedUnitObjectIDs[Index], eReturnType_Reference, RevealContext.AssociatedState.HistoryIndex));
                
                
                if( UnitState.IsAbleToAct() ) //Only focus on still living enemies
			    {
				    Template = UnitState.GetMyTemplate();
                    if(Template.GetRevealMatineePrefixFn != none)
		            {
			            // function takes priority over specified matinee prefix
			            MatineePrefix = Template.GetRevealMatineePrefixFn(UnitState);
		            }
		            else if(Template.RevealMatineePrefix != "")
		            {
			            // we have a matinee prefix specified, use that
			            MatineePrefix = Template.RevealMatineePrefix;
		            }
                    if (Left(MatineePrefix, 10) == "CIN_Chosen") {
                        //`redscreen("Matinee Prefix = "$MatineePrefix);
                        return true;
                    }
                    else if (class'X2TacticalVisibilityHelpers'.static.GetNumEnemyViewersOfTarget(UnitState.ObjectId) > 0) {
                        return true;
                    }
                }
            }
        }



		// Determine if this reveal is happening immediately after a spawn. If so, then we don't want to play a further
		// reveal matinee. The spawn animations are considered the reveal matinee in this case.
		foreach History.IterateContextsByClassType(class'XComGameStateContext_ChangeContainer', Context,, true)
		{
			if(Context.AssociatedState.HistoryIndex <= RevealContext.AssociatedState.HistoryIndex // only look in the past
				&& Context.EventChainStartIndex == RevealContext.EventChainStartIndex // only within this chain of action
				&& Context.ChangeInfo == class'XComGameState_AIReinforcementSpawner'.default.SpawnReinforcementsCompleteChangeDesc)
			{
				// check if this change spawned our units
				foreach Context.AssociatedState.IterateByClassType(class'XComGameState_AIUnitData', AIUnitData)
				{
					if(RevealContext.RevealedUnitObjectIDs.Find(AIUnitData.m_iUnitObjectID) != INDEX_NONE)
					{
						foreach Context.AssociatedState.IterateByClassType(class'XComGameState_AIReinforcementSpawner', SpawnState)
						{
							//`redscreen("Spawned by reinforcement");
                            return true;
						}

						// no reinforcement game state, so just allow it by default
                        //`redscreen("Spawned not by reinforcement");
						return false;
					}
				}
			}

			// we are iterating into the past, so abort as soon as we pass the start of our event chain
			if(Context.AssociatedState.HistoryIndex < RevealContext.EventChainStartIndex)
			{
				break;
			}
		}
		return false;
    }

    function UpdateUnitVisuals()
    {
        if (ShouldPlayRevealMatinee()) {
            super.UpdateUnitVisuals();
        }
    }

    function RequestInitialLookAtCamera()
    {
        if (ShouldPlayRevealMatinee()) {
            super.RequestInitialLookAtCamera();
        }
    }

    function RequestLookAtCamera()
    {
        if (ShouldPlayRevealMatinee()) {
            super.RequestLookAtCamera();
        }
    }

    function FaceRevealUnitsTowardsEnemy()
    {
        if (ShouldPlayRevealMatinee()) {
            super.FaceRevealUnitsTowardsEnemy();
        }
    }
}