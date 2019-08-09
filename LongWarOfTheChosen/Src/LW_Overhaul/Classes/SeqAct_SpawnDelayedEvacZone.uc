
//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SpawnDelayedEvacZone.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Spawn an evac zone after a delay.
//---------------------------------------------------------------------------------------

class SeqAct_SpawnDelayedEvacZone extends SequenceAction
	implements(X2KismetSeqOpVisualizer);
	//config(GameCore);

var Vector SpawnLocation; // desired spawn location, in parameter
var Vector ActualSpawnLocation; // actually used spawn location, out parameter
var int TurnsRemaining;       // Number of turns til skyranger arrives


// if specified, will use SpawnLocation as a centerpoint around which a spawn within these bounds
// will be spawned
var() int MinimumTilesFromLocation; // in tiles
var() int MaximumTilesFromLocation; // in tiles
var() bool BiasAwayFromXComSpawn; // if true, will attempt to pick an evac location further away from the xcom spawn
var() bool SkipCreationNarrative; // if true, skip the narrative moment from firebrand when the flare is dropped.

event Activated()
{
	// this needs to be computed in the activation so that we copy the actual spawn location
	// out to the variable node in kismet
	ActualSpawnLocation = GetSpawnLocation();
}

function ModifyKismetGameState(out XComGameState GameState)
{
    class'XComGameState_LWEvacSpawner'.static.InitiateEvacZoneDeployment(TurnsRemaining, ActualSpawnLocation, GameState, SkipCreationNarrative);
}

function BuildVisualization(XComGameState GameState)
{
}

private function Vector GetSpawnLocation()
{
	local XComWorldData WorldData;
	local XComGroupSpawn Spawn;
	local XComParcelManager ParcelManager;
	local XComTacticalMissionManager MissionManager;
	local Vector ObjectiveLocation;
	local float TilesFromSpawn;
	local array<XComGroupSpawn> SpawnsInRange;
	local vector SoldierSpawnToObjectiveNormal;
	local float BiasHalfAngleDot;
	local float SpawnDot;
	local TTile Tile;

	if(MinimumTilesFromLocation < 0 && MaximumTilesFromLocation < 0)
	{
		// simple case, this isn't a ranged check and we just want to use the exact location
		return SpawnLocation;
	}

	if(MinimumTilesFromLocation >= MaximumTilesFromLocation)
	{
		`Redscreen("SeqAct_SpawnEvacZone: The minimum zone distance is further than the maximum, this makes no sense!");
		return SpawnLocation;
	}

	// find all group spawns that lie within the specified limits
	WorldData = `XWORLD;
	foreach `BATTLE.AllActors(class'XComGroupSpawn', Spawn)
	{
		TilesFromSpawn = VSize(Spawn.Location - SpawnLocation) / class'XComWorldData'.const.WORLD_StepSize;
		Tile = WorldData.GetTileCoordinatesFromPosition(Spawn.Location);
		if(TilesFromSpawn > MinimumTilesFromLocation 
			&& TilesFromSpawn < MaximumTilesFromLocation 
			&& WorldData.Volume.EncompassesPoint(Spawn.Location) // only if it lies within the extents of the level
			&& class'X2TargetingMethod_EvacZone'.static.ValidateEvacArea(Tile, false)) 
		{
			SpawnsInRange.AddItem(Spawn);
		}
	}

	if (SpawnsInRange.Length == 0)
	{
		`Redscreen("SeqAct_SpawnDelayedEvacZone: Couldn't find any spawns in range, trying without range");
		foreach `BATTLE.AllActors(class'XComGroupSpawn', Spawn)
		{
			Tile = WorldData.GetTileCoordinatesFromPosition(Spawn.Location);
			if(WorldData.Volume.EncompassesPoint(Spawn.Location) // only if it lies within the extents of the level
				&& class'X2TargetingMethod_EvacZone'.static.ValidateEvacArea(Tile, false)) 
			{
				SpawnsInRange.AddItem(Spawn);
			}
		}
	}

	if(SpawnsInRange.Length == 0)
	{
		// couldn't find any spawns in range!
		`Redscreen("SeqAct_SpawnEvacZone: Couldn't find any spawns in range, spawning at the centerpoint!");
		return SpawnLocation;
	}

	// now pick a spawn.
	if(BiasAwayFromXComSpawn)
	{
		ParcelManager = `PARCELMGR;
		MissionManager = `TACTICALMISSIONMGR;
		if(MissionManager.GetLineOfPlayEndpoint(ObjectiveLocation))  // WOTC: GetObjectivesCenterpoint() -> GetLineOfPlayEndpoint()
		{
			// randomize the array so we can just take the first one that is on the opposite side of the objectives
			// from the xcom spawn
			SpawnsInRange.RandomizeOrder();

			SoldierSpawnToObjectiveNormal = Normal(ParcelManager.SoldierSpawn.Location - ObjectiveLocation);
			BiasHalfAngleDot = cos((180.0f - (class'SeqAct_SpawnEvacZone'.default.BiasConeAngleInDegrees * 0.5)) * DegToRad); // negated since it's on the opposite side of the spawn
			foreach SpawnsInRange(Spawn)
			{
				SpawnDot = SoldierSpawnToObjectiveNormal dot Normal(Spawn.Location - ObjectiveLocation);
				if(SpawnDot < BiasHalfAngleDot)
				{
					return Spawn.Location;
				}
			}
		}
	}

	// random pick
	return SpawnsInRange[`SYNC_RAND(SpawnsInRange.Length)].Location;
}

static event int GetObjClassVersion()
{
	return super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="LWOverhaul"
	ObjName="Spawn Delayed Evac Zone"
	bCallHandler=false
	
	MinimumTilesFromLocation=-1
	MaximumTilesFromLocation=-1

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Input Location",PropertyName=SpawnLocation)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Actual Location",PropertyName=ActualSpawnLocation,bWriteable=true)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="Turns",PropertyName=TurnsRemaining)
}
