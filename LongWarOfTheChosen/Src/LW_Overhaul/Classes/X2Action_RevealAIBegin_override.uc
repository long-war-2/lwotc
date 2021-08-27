class X2Action_RevealAIBegin_override extends X2Action_RevealAIBegin;


function Init()
{	
	
	local X2CharacterTemplate FirstRevealTemplate;
	local XGUnit UnitActor;
	local int Index;
	local X2EventManager EventManager;
	local Object ThisObj;

	super.Init();
	
	RevealContext = XComGameStateContext_RevealAI(StateChangeContext);	

	History = `XCOMHISTORY;

	FirstRevealTemplate = RevealContext.FirstEncounterCharacterTemplate;

	//First make sure that there are units to be revealed
	if(RevealContext.RevealedUnitObjectIDs.Length > 0)
	{		
		for(Index = 0; Index < RevealContext.RevealedUnitObjectIDs.Length; ++Index)
		{
			TempUnitState = XComGameState_Unit(History.GetGameStateForObjectID(RevealContext.RevealedUnitObjectIDs[Index], eReturnType_Reference, RevealContext.AssociatedState.HistoryIndex));
			if( TempUnitState.IsAbleToAct() ) //Only focus on still living enemies
			{
				UnitActor = XGUnit(History.GetVisualizer(TempUnitState.ObjectID));
				if(MatineeFocusUnitVisualizer == none 
					|| (FirstRevealTemplate != none && FirstRevealTemplate.DataName != MatineeFocusUnitVisualizer.GetVisualizedGameState().GetMyTemplateName()))
				{
					// If this is a first encounter, then favor playing the reveal on a unit of that template type. Otherwise 
					// take the first one available. Since the pod leader is always at index 0, this will focus him if possible.
					MatineeFocusUnitVisualizer = UnitActor;		
					MatineeFocusUnitState = TempUnitState;
				}

				//RevealedUnitVisualizers.AddItem(UnitActor.GetPawn());
			}
		}

		//We can still end up with an empty RevealedUnitVisualizers if the player killed this entire group with AOE or something before the reveal could take place, so account for that 
		WorldInfo.RemoteEventListeners.AddItem(self);

		EventManager = `XEVENTMGR;
		ThisObj = self;

		EventManager.RegisterForEvent(ThisObj, 'UIChosenReveal_OnRemoved', OnChosenRevealUI_Removed, ELD_Immediate);
	}
	else
	{
		`redscreen("Attempted to plan AI reveal action with no AIs!");
	}
	
	EnemyUnitVisualizer = XGUnit(History.GetVisualizer(RevealContext.CausedRevealUnit_ObjectID));
	if (EnemyUnitVisualizer == None)
	{
		// Revealing unit may be dead?  Select any xcom unit?
		EnemyUnitVisualizer = XGBattle_SP(`BATTLE).GetAIPlayer().GetNearestEnemy(UnitActor.GetLocation());
	}
}



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