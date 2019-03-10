//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_LWCallReinforcements.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Call some reinforcements. Determines the encounter to use and spawns em.
//---------------------------------------------------------------------------------------
class SeqAct_LWCallReinforcements extends SequenceAction config(LW_Overhaul);


struct ReinforcementSchedule
{
    var Name ScheduleName;
    var array<Name> EncounterList;
};

struct AltReinforcementLocation
{	
	var Name ScheduleName;
};

var() int IdealSpawnTilesOffset;
var() Name Schedule;
var Vector Location;

var config const array<ReinforcementSchedule> ReinforcementList;

var config int DEFEND_SPAWN_DISTANCE_TILES_BEFORE_ZONE;
var config int DEFEND_SPAWN_DISTANCE_TILES_BEFORE_ZONE_RAND;
var config int DEFEND_SPAWN_DISTANCE_TILES_AFTER_ZONE;
var config int DEFEND_SPAWN_DISTANCE_TILES_AFTER_ZONE_RAND;
var config int REINF_SPAWN_DISTANCE_FROM_OBJECTIVE_WHEN_SQUAD_IS_CONCEALED;

event Activated()
{
    local XComGameState_LWReinforcements Reinforcements;
    local XComGameState NewGameState;
    local int ReinforceIndex;

    Reinforcements = XComGameState_LWReinforcements(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWReinforcements', true));
    if (Reinforcements == none)
        return;

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Check for reinforcements");
    Reinforcements = XComGameState_LWReinforcements(NewGameState.CreateStateObject(class'XComGameState_LWReinforcements', Reinforcements.ObjectID));
    NewGameState.AddStateObject(Reinforcements);

	// Look for a disable signal
	if (InputLinks[2].bHasImpulse)
	{
		Reinforcements.DisableReinforcements();
	}
	else
	{
		// Check if we should call reinforcements, or if we have a forced reinforcement.
		if (InputLinks[1].bHasImpulse)
			ReinforceIndex = Reinforcements.ForceReinforcements();
		else 
			ReinforceIndex = Reinforcements.CheckForReinforcements();

		// If the index is -1 we're done and there is nothing to spawn.
		if (ReinforceIndex != -1) {
			OutputLinks[1].bHasImpulse = true;
			SpawnReinforcements(ReinforceIndex, NewGameState);
		}
	}

    OutputLinks[0].bHasImpulse = true;
    `TACTICALRULES.SubmitGameState(NewGameState);
}

function SpawnReinforcements(int ReinforceIndex, XComGameState NewGameState)
{
    local int Idx;
    local Name EncounterID;
	local XComGameState_EvacZone EvacZone;
	local XComGameState_LWEvacSpawner PendingEvacZone;
	local bool AlterSpawn;
	local XComGameState_Player PlayerState;
	local XComGameState_ObjectiveInfo ObjectiveInfo;
	local XComGameState_Unit ObjectiveUnit;
	local XComGameState_InteractiveObject ObjectiveObject;
	local Actor ObjectiveActor;
	local TTile Tile;

    Idx = -1;
    // If we're given a schedule override, use that.
    if (Schedule != '')
    {
        Idx = ReinforcementList.Find('ScheduleName', Schedule);
        if (Idx == -1)
        {
            `Redscreen("Bad reinforcement schedule name " $ Schedule);
        }
    }

    // No schedule given or couldn't find it: use the default.
    if (Idx == -1)
    {
        Idx = ReinforcementList.Find('ScheduleName', 'Default');
    }

    if (Idx == -1)
    {
        // Oh oh, no default schedule either. We can't do anything.
        `redscreen("No Default reinforcement schedule found! Aborting reinf!");
        return;
    }

    ReinforceIndex = Min(ReinforceIndex, ReinforcementList[Idx].EncounterList.Length - 1);
    EncounterID = ReinforcementList[Idx].EncounterList[ReinforceIndex];

	if (class'Utilities_LW'.static.CurrentMissionType() == "Defend_LW")
	{
		EvacZone = class'XComGameState_EvacZone'.static.GetEvacZone();
		if (EvacZone != none)
		{	
			AlterSpawn = true;
			Location = class'XComWorldData'.static.GetWorldData().GetPositionFromTileCoordinates(EvacZone.CenterLocation);
			IdealSpawnTilesOffset = default.DEFEND_SPAWN_DISTANCE_TILES_AFTER_ZONE + `SYNC_RAND(default.DEFEND_SPAWN_DISTANCE_TILES_AFTER_ZONE_RAND);
		}
		else
		{
			PendingEvacZone = class'XComGameState_LWEvacSpawner'.static.GetPendingEvacZone();
			if (PendingEvacZone != none)
			{	
				AlterSpawn = true;
				Location = PendingEvacZone.GetLocation();
				IdealSpawnTilesOffset = default.DEFEND_SPAWN_DISTANCE_TILES_BEFORE_ZONE + `SYNC_RAND(default.DEFEND_SPAWN_DISTANCE_TILES_BEFORE_ZONE_RAND);
			}
		}
		
		// LWOTC: It appears that the second argument to InitiateReinforcements should
		// be 1, not 0, in order to start reinforcements at *end* of XCOM's first turn
		// rather than before it.
		class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(EncounterID, 1, AlterSpawn, Location, IdealSpawnTilesOffset, NewGameState, true);
	}
	else
	{
		PlayerState = class'Utilities_LW'.static.FindPlayer(eTeam_XCom);
		if (PlayerState.bSquadIsConcealed)
		{
		    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_ObjectiveInfo', ObjectiveInfo)
			{
				if(class'Utilities_LW'.static.CurrentMissionType() == ObjectiveInfo.MissionType)
				{
					ObjectiveUnit = XComGameState_Unit(ObjectiveInfo.FindComponentObject(class'XComGameState_Unit', true));
					ObjectiveObject = XComGameState_InteractiveObject(ObjectiveInfo.FindComponentObject(class'XComGameState_InteractiveObject', true));
					ObjectiveActor = `XCOMHISTORY.GetVisualizer(ObjectiveInfo.ObjectID);
					if(ObjectiveUnit != none)
					{
						ObjectiveUnit.GetKeystoneVisibilityLocation(Tile);
						Location = class'XComWorldData'.static.GetWorldData().GetPositionFromTileCoordinates(Tile);
						AlterSpawn = true;
						break;
					}
					else
					{
						if(ObjectiveObject != none)
						{
							Tile = ObjectiveObject.TileLocation;
							Location = class'XComWorldData'.static.GetWorldData().GetPositionFromTileCoordinates(Tile);
							AlterSpawn = true;
							break;
						}
						else
						{
							Location = ObjectiveActor.Location;
							AlterSpawn = true;
							break;
						}
					}
				}
			}
			if (AlterSpawn)
			{
				// LWOTC: It appears that the second argument to InitiateReinforcements should
				// be 1, not 0, in order to start reinforcements at *end* of XCOM's first turn
				// rather than before it.
  				IdealSpawnTilesOffset = `SYNC_RAND(default.REINF_SPAWN_DISTANCE_FROM_OBJECTIVE_WHEN_SQUAD_IS_CONCEALED);
				class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(EncounterID, 1, AlterSpawn, Location, IdealSpawnTilesOffset, NewGameState, true);
			}
			else
			{
				class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(EncounterID, 1, false, Location, IdealSpawnTilesOffset, NewGameState, true);
			}
		}
		else
		{
				// LWOTC: It appears that the second argument to InitiateReinforcements should
				// be 1, not 0, in order to start reinforcements at *end* of XCOM's first turn
				// rather than before it.
			class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(EncounterID, 1, false, Location, IdealSpawnTilesOffset, NewGameState, true);
		}
	}
}

defaultproperties
{
    ObjCategory="LWOverhaul"
    ObjName="(LongWar) Call Reinforcements"
    bConvertedForReplaySystem=true

    InputLinks(0)=(LinkDesc="Check")
    InputLinks(1)=(LinkDesc="Force")
	InputLinks(2)=(LinkDesc="Disable");

    OutputLinks(0)=(LinkDesc="Out")
    OutputLinks(1)=(LinkDesc="Reinforced");

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Location",PropertyName=Location)
}

