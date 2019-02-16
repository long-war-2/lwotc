//---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_LWTeamHasNoFilteredPlayableUnitsRemaining.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: A mash-up of SeqEvent_TeamHasNoPlayableUnitsRemaining and SeqEvent_GameEventTriggered
//           to allow kismet events to fire when a team is out of playable units while also excluding
//           a configurable list of unit templates from consideration. For example, when there is nothing
//           but resistance mecs left on map.
//---------------------------------------------------------------------------------------
class SeqEvent_LWTeamHasNoFilteredPlayableUnitsRemaining extends SeqEvent_X2GameState;

var private XGPlayer LosingPlayer;
var() array<Name> TemplateNamesToExclude;

var private array<XGPlayer> FiredForPlayer;

event RegisterEvent()
{
	local Object ThisObj;

	ThisObj = self;
	`XEVENTMGR.RegisterForEvent(ThisObj, 'UnitRemovedFromPlay', EventTriggered, ELD_OnStateSubmitted);
    `XEVENTMGR.RegisterForEvent(ThisObj, 'UnitChangedTeam', EventTriggered, ELD_OnStateSubmitted);
    `XEVENTMGR.RegisterForEvent(ThisObj, 'UnitUnconscious', EventTriggered, ELD_OnStateSubmitted);
    `XEVENTMGR.RegisterForEvent(ThisObj, 'UnitDied', EventTriggered, ELD_OnStateSubmitted);
    `XEVENTMGR.RegisterForEvent(ThisObj, 'UnitBleedingOut', EventTriggered, ELD_OnStateSubmitted);
}

event Activated()
{
	local int ImpulseIdx;
	local array<ETeam> Teams;

	Teams.AddItem(eTeam_XCom);
	Teams.AddItem(eTeam_Alien);
	Teams.AddItem(eTeam_Neutral);
	Teams.AddItem(eTeam_One);
	Teams.AddItem(eTeam_Two);

	for (ImpulseIdx = 0; ImpulseIdx < OutputLinks.Length; ++ImpulseIdx)
	{
		OutputLinks[ImpulseIdx].bHasImpulse = (LosingPlayer.m_eTeam == Teams[ImpulseIdx]);
	}
}


function EventListenerReturn EventTriggered(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComGameStateHistory History;
    local XComGameState_Player PlayerObject;
    local XGPlayer PlayerVisualizer;
    local bool bFired;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_Player', PlayerObject)
	{
		PlayerVisualizer = XGPlayer(PlayerObject.GetVisualizer());
        if (FiredForPlayer.Find(PlayerVisualizer) == -1)
        {
		    bFired = DidPlayerRunOutOfPlayableUnits(PlayerVisualizer, GameState);
		    if( bFired )
		    {
                FiredForPlayer.AddItem(PlayerVisualizer);
			    self.FireEvent(PlayerVisualizer);
		    }
        }
	}

	return ELR_NoInterrupt;
}

// This function is copied almost verbatim from KismetGameRulesetEventObserver, modified only to provide a 
// configurable list of template names that should not be considered when looking for playable units.
private function bool DidPlayerRunOutOfPlayableUnits(XGPlayer InPlayer, XComGameState NewGameState)
{	
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;
	local XComGameState_Unit PreviousUnit;
	local XComGameState_Unit RemovedUnit;
	local int ExamineHistoryFrameIndex;

	History = `XCOMHISTORY;	

	if(NewGameState != none)
	{
		ExamineHistoryFrameIndex = NewGameState.HistoryIndex;

		// find any unit on this team that was in play the previous state but not this one
		foreach NewGameState.IterateByClassType(class'XComGameState_Unit', Unit)
		{
			// Don't count turrets, ever.  Also ignore unselectable units (mimic beacons).
			if( Unit.IsTurret() || Unit.GetMyTemplate().bNeverSelectable )
				continue;

			//For units on our team, check if they recently died or became incapacitated.
			if (Unit.ControllingPlayer.ObjectID == InPlayer.ObjectID)
			{
				if (!Unit.IsAlive() || Unit.bRemovedFromPlay || Unit.IsIncapacitated())
				{
					// this unit is no longer playable. See if it was playable in the previous state
					PreviousUnit = XComGameState_Unit(History.GetGameStateForObjectID(Unit.ObjectID, , ExamineHistoryFrameIndex - 1));
					if (PreviousUnit.IsAlive() && !PreviousUnit.bRemovedFromPlay && !PreviousUnit.IsIncapacitated())
					{
						RemovedUnit = Unit;
						break;
					}
				}
			}
			else
			{
				//For units on the other team, check if they were stolen from our team (via mind-control, typically)
				PreviousUnit = XComGameState_Unit(History.GetGameStateForObjectID(Unit.ObjectID, , ExamineHistoryFrameIndex - 1));
				if (PreviousUnit.ControllingPlayer.ObjectID == InPlayer.ObjectID)
				{
					//This unit was taken by another team, but used to be on our team.
					RemovedUnit = Unit;
					break;
				}
			}

		}

		// no unit was removed for this player, so no need to continue checking the entire team
		if(RemovedUnit == none)
		{
			return false;
		}
	}	
	else
	{
		ExamineHistoryFrameIndex = -1;
	}

	// at least one unit was removed from play for this player on this state. If all other units
	// for this player are also out of play on this state, then this must be the state where
	// the last unit was removed.
	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if( Unit.ControllingPlayer.ObjectID == InPlayer.ObjectID && !Unit.GetMyTemplate().bIsCosmetic && !Unit.IsTurret() && !Unit.GetMyTemplate().bNeverSelectable && 
                TemplateNamesToExclude.Find(Unit.GetMyTemplateName()) == -1)
		{
			Unit = XComGameState_Unit(History.GetGameStateForObjectID(Unit.ObjectID, , ExamineHistoryFrameIndex));
			if( Unit == None || (Unit.IsAlive() && !Unit.bRemovedFromPlay && !Unit.IsIncapacitated()) )
			{
				return false;
			}
		}
	}

	// the alien team has units remaining if they have reinforcements already queued up
	if( InPlayer.m_eTeam == eTeam_Alien && AnyPendingReinforcements() )
	{
		return false;
	}

	// this player had a unit removed from play and all other units are also out of play.
	return true;
}

function bool AnyPendingReinforcements()
{
	local XComGameState_AIReinforcementSpawner AISPawnerState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_AIReinforcementSpawner', AISPawnerState)
	{
		break;
	}

	// true if there are any active reinforcement spawners
	return (AISPawnerState != None);
}

function FireEvent(XGPlayer InPlayer)
{
	LosingPlayer = InPlayer;
	CheckActivate(InPlayer, none);
}

defaultproperties
{
	ObjName="(LW) Team Has No Filtered Playable Units Remaining"
    ObjCategory="LWOverhaul"
	OutputLinks(0)=(LinkDesc="XCom")
	OutputLinks(1)=(LinkDesc="Alien")
	OutputLinks(2)=(LinkDesc="Civilian")
	OutputLinks(3)=(LinkDesc="Team One")
	OutputLinks(4)=(LinkDesc="Team Two")

    bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
}
