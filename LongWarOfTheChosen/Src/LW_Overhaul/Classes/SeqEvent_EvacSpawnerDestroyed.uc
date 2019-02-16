//---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_EvacSpawnerDestroyed.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Event for handling when an evac spawner is destroyed
//---------------------------------------------------------------------------------------
 
class SeqEvent_EvacSpawnerDestroyed extends SeqEvent_GameEventTriggered;

var() private ETeam Team;

function EventListenerReturn EventTriggered( Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData )
{
	local XComGameState_LWEvacSpawner EvacSpawner;

	EvacSpawner = XComGameState_LWEvacSpawner(EventSource);

	if (EvacSpawner != none)
	{
		CheckActivate(`BATTLE, none);
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
	ObjName="Evac Spawner Destroyed"
	ObjCategory="LWOverhaul"
	EventID="EvacSpawnerDestroyed"
}
