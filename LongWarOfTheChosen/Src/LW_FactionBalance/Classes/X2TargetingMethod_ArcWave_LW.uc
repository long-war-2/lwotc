class X2TargetingMethod_ArcWave_LW extends X2TargetingMethod_MeleePath;

var X2AbilityTemplate ArcWaveTemplate;
var TTile LastDestination;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	ArcWaveTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('ArcWave_LW');

	super.Init(InAction, NewTargetIndex);	
}

function DirectSetTarget(int TargetIndex)
{
	local Actor TargetedActor;
	local array<TTile> Tiles;
	local TTile TargetedActorTile;
	local XGUnit TargetedPawn;
	local vector TargetedLocation;
	local XComWorldData World;

	super.DirectSetTarget(TargetIndex);

	TargetedActor = GetTargetedActor();
	TargetedPawn = XGUnit(TargetedActor);
	if (TargetedPawn != none)
	{
		World = `XWORLD;
		TargetedLocation = TargetedPawn.GetFootLocation();
		TargetedActorTile = World.GetTileCoordinatesFromPosition(TargetedLocation);
		TargetedLocation = World.GetPositionFromTileCoordinates(TargetedActorTile);
		LastDestination = TargetedActorTile;

		ArcWaveTemplate.AbilityMultiTargetStyle.GetValidTilesForLocation(Ability, TargetedLocation, Tiles);

		if (Tiles.Length > 1)
		{
			DrawAOETiles(Tiles);
		}
	}
}

function TickUpdatedDestinationTile(TTile NewDestination)
{
	local Actor TargetedActor;
	local array<TTile> Tiles;
	local TTile TargetedActorTile;
	local XGUnit TargetedPawn;
	local vector TargetedLocation, SourceLocation;
	local XComWorldData World;
	local array<Actor> CurrentlyMarkedTargets;

	TargetedActor = GetTargetedActor();
	TargetedPawn = XGUnit(TargetedActor);
	if (TargetedPawn != none)
	{
		World = `XWORLD;
		TargetedLocation = TargetedPawn.GetFootLocation();
		TargetedActorTile = World.GetTileCoordinatesFromPosition(TargetedLocation);
		TargetedLocation = World.GetPositionFromTileCoordinates(TargetedActorTile);
		SourceLocation = World.GetPositionFromTileCoordinates(NewDestination);
		LastDestination = NewDestination;

		X2AbilityMultiTarget_Cone(ArcWaveTemplate.AbilityMultiTargetStyle).GetTilesProxy(Ability, TargetedLocation, SourceLocation, Tiles);

		if (Tiles.Length > 1)
		{
			DrawAOETiles(Tiles);

			GetTargetedActorsInTiles(Tiles, CurrentlyMarkedTargets, true);
			MarkTargetedActors(CurrentlyMarkedTargets);
		}
	}
}

function bool GetPreAbilityPath(out array<TTile> PathTiles)
{
	PathTiles = PathingPawn.PathTiles;
	return PathTiles.Length > 1;
}

protected function Vector GetPathDestination()
{
	local XComWorldData WorldData;
	local TTile Tile;

	WorldData = `XWORLD;
	if (PathingPawn.PathTiles.Length > 0)
	{
		Tile = PathingPawn.PathTiles[PathingPawn.PathTiles.Length - 1];
	}
	else
	{
		Tile = UnitState.TileLocation;
	}

	return WorldData.GetPositionFromTileCoordinates(Tile);
}

// function GetTargetLocations(out array<Vector> TargetLocations)
// {
// 	TargetLocations.AddItem(GetPathDestination());
// }

function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
	local Actor TargetedActor;
	local array<TTile> Tiles;
	local TTile TargetedActorTile;
	local XGUnit TargetedPawn;
	local vector TargetedLocation, SourceLocation;
	local XComWorldData World;
	local array<Actor> CurrentlyMarkedTargets;
	local XGUnit CurrentTargetUnit;
	local int i;
	local name AvailableCode;
	local XComGameStateHistory History;
	local XComGameState_BaseObject StateObject;

	TargetedActor = GetTargetedActor();
	TargetedPawn = XGUnit(TargetedActor);
	if (TargetedPawn != none)
	{
		World = `XWORLD;
		TargetedLocation = TargetedPawn.GetFootLocation();
		TargetedActorTile = World.GetTileCoordinatesFromPosition(TargetedLocation);
		TargetedLocation = World.GetPositionFromTileCoordinates(TargetedActorTile);
		SourceLocation = World.GetPositionFromTileCoordinates(LastDestination);

		X2AbilityMultiTarget_Cone(ArcWaveTemplate.AbilityMultiTargetStyle).GetTilesProxy(Ability, TargetedLocation, SourceLocation, Tiles);

		if (Tiles.Length > 1)
		{
			GetTargetedActorsInTiles(Tiles, CurrentlyMarkedTargets, true);
			
			History = `XCOMHISTORY;
			for (i = 0; i < CurrentlyMarkedTargets.Length; ++i)
			{
				CurrentTargetUnit = XGUnit(CurrentlyMarkedTargets[i]);
				if (CurrentTargetUnit != none)
				{
					StateObject = History.GetGameStateForObjectID(CurrentTargetUnit.ObjectID);
					AvailableCode = ArcWaveTemplate.CheckMultiTargetConditions(Ability, UnitState, StateObject);	
					if (AvailableCode == 'AA_Success' && StateObject.ObjectID != AdditionalTargets.PrimaryTarget.ObjectID)
					{
						if (AdditionalTargets.AdditionalTargets.Find('ObjectID', StateObject.ObjectID) == INDEX_NONE)
							AdditionalTargets.AdditionalTargets.AddItem(StateObject.GetReference());
					}
				}
			}

			return true;
		}
	}

	return false;
}

function Canceled()
{
	super.Canceled();
	ClearTargetedActors();
}