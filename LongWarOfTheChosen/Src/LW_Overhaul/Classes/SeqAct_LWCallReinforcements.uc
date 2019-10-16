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
var bool ForceSpawnInLoS;
var bool ForceSpawnOutOfLoS;

var config const array<ReinforcementSchedule> ReinforcementList;

var config int RANDOM_SPAWN_OFFSET;
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
	Reinforcements = XComGameState_LWReinforcements(NewGameState.ModifyStateObject(class'XComGameState_LWReinforcements', Reinforcements.ObjectID));

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

		// LWOTC: Since the reinforcement spawner doesn't seem to do a good job of
		// randomisation spawn locations, we manually randomise the spawn location
		// and use a smaller tile offset for InitiateReinforcements().
		Location = GenerateRandomSpawnLocation(Location, IdealSpawnTilesOffset);

		// LWOTC: It appears that the second argument to InitiateReinforcements should
		// be -1, not 0, in order to use the reinforcement countdown of the encounter.
		class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(
			EncounterID,
			-1,
			AlterSpawn,
			Location,
			default.RANDOM_SPAWN_OFFSET,
			NewGameState,
			true,
			,
			ForceSpawnOutOfLoS,
			ForceSpawnInLoS,
			true,
			false,
			false,
			true);
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
				// LWOTC: Since the reinforcement spawner doesn't seem to do a good job of
				// randomisation spawn locations, we manually randomise the spawn location
				// and use a smaller tile offset for InitiateReinforcements().
				Location = GenerateRandomSpawnLocation(Location, IdealSpawnTilesOffset);
		
				// LWOTC: It appears that the second argument to InitiateReinforcements should
				// be -1, not 0, in order to use the reinforcement countdown of the encounter.
  				IdealSpawnTilesOffset = `SYNC_RAND(default.REINF_SPAWN_DISTANCE_FROM_OBJECTIVE_WHEN_SQUAD_IS_CONCEALED);
				class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(
					EncounterID,
					-1,
					AlterSpawn,
					Location,
					default.RANDOM_SPAWN_OFFSET,
					NewGameState,
					true,
					,
					ForceSpawnOutOfLoS,
					ForceSpawnInLoS,
					true,
					false,
					false,
					true);
			}
			else
			{
				// LWOTC: Since the reinforcement spawner doesn't seem to do a good job of
				// randomisation spawn locations, we manually randomise the spawn location
				// and use a smaller tile offset for InitiateReinforcements().
				Location = GenerateRandomSpawnLocation(`SPAWNMGR.GetCurrentXComLocation(), IdealSpawnTilesOffset);
		
				class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(
					EncounterID,
					-1,
					true,
					Location,
					default.RANDOM_SPAWN_OFFSET,
					NewGameState,
					true,
					,
					ForceSpawnOutOfLoS,
					ForceSpawnInLoS,
					true,
					false,
					false,
					true);
			}
		}
		else
		{
			// LWOTC: Since the reinforcement spawner doesn't seem to do a good job of
			// randomisation spawn locations, we manually randomise the spawn location
			// and use a smaller tile offset for InitiateReinforcements().
			Location = GenerateRandomSpawnLocation(`SPAWNMGR.GetCurrentXComLocation(), IdealSpawnTilesOffset);
	
			// LWOTC: It appears that the second argument to InitiateReinforcements should
			// be -1, not 0, in order to use the reinforcement countdown of the encounter.
			class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(
				EncounterID,
				-1,
				true,
				Location,
				default.RANDOM_SPAWN_OFFSET,
				NewGameState,
				true,
				,
				ForceSpawnOutOfLoS,
				ForceSpawnInLoS,
				true,
				false,
				false,
				true);
		}
	}
}

// LWOTC: Pick a random location that is at a distance of TileOffset tiles
// from the given anchor point. This location is guaranteed to be within the
// game board, but it may not necessarily be a valid spawn point.
static function Vector GenerateRandomSpawnLocation(Vector AnchorPoint, int TileOffset)
{
	local XComWorldData WorldData;
	local Rotator RandomRotator;
	local Vector TrySpawnLocation;
	local float RadiusUnits;
	local bool FoundValidSpawn;

	WorldData = `XWORLD;
	RadiusUnits = `TILESTOUNITS(TileOffset);

	while (!FoundValidSpawn)
	{
		RandomRotator.yaw = `SYNC_RAND_STATIC(65536);
		TrySpawnLocation = AnchorPoint + RadiusUnits * Vector(RandomRotator);
		TrySpawnLocation.Z = WorldData.GetFloorZForPosition(TrySpawnLocation);
		if (WorldData.Volume.EncompassesPoint(TrySpawnLocation))
		{
			FoundValidSpawn = true;
		}
	}

	return TrySpawnLocation;
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
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="TileOffset",PropertyName=IdealSpawnTilesOffset)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Bool',LinkDesc="ForceSpawnInLoS",PropertyName=ForceSpawnInLoS)
	VariableLinks(3)=(ExpectedType=class'SeqVar_Bool',LinkDesc="ForceSpawnOutOfLoS",PropertyName=ForceSpawnOutOfLoS)
}

