//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityMultiTarget_Cone_LWFlamethrower.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Pulls size of cone from altweapon, allows option for ability modifiers
//---------------------------------------------------------------------------------------
class X2AbilityMultiTarget_Cone_LWFlamethrower extends X2AbilityMultiTarget_Cone;

//`include(LongWaroftheChosen\Src\LW_Overhaul.uci)

struct TileDistancePair
{
	var TTile Tile;
	var float Distance;
};

const LOCAL_INF = 999999.0f;

var float Original_ConeEndDiameter;
var float Original_ConeLength;

var array<name> AbilityModifiers;
var array<float> ConeLengthModifiers;
var array<float> ConeEndDiameterModifiers;

var array<ETraversalType> AllowedTraversalTypes;

var array<TTile> CachedValidTiles;
var bool ResetCache;

//TODO: re-factor now that all calls to this are non-native
function float GetConeLength(const XComGameState_Ability Ability)
{
	UpdateParameters(Ability);
	return super.GetConeLength(Ability);
}

// converted from native to uscript in order to update length/width parameters and adjust targeting mechanisms
simulated function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles)
{
	local XComGameStateHistory History;
	local XComGameState_Unit Shooter;
	local XComWorldData WorldData;
	local XGUnit ShooterVisualizer;
	local Vector ShooterPos, ConeAxis;
	local int CoverDirection;
	local GameRulesCache_VisibilityInfo VisibilityInfo;
	local UnitPeekSide UsePeek;
	local int bCanSeeFromDefault, bRequiresLean;
	local array<TilePosPair> TileCollection;
	local TilePosPair TilePair;
	local array<TileDistancePair> UnvisitedTiles, VisitedTiles;
	local float CurrentConeLength, LargestDistance;
	local TTile SourceTile, TestTile;
	local TileDistancePair TempTile, CurrentTile;
	local VoxelRaytraceCheckResult VoxelRaytraceCheckResult;
	local int idx, VoxelChecks;
	local array<int> UpdateChecks;

	if (!ResetCache && CachedValidTiles.Length > 0)
	{
		ValidTiles = CachedValidtiles;
		return;
	}

	UpdateParameters(Ability);
	
	// Updated Flamethrower tile collection logic
	History = `XCOMHISTORY;
	Shooter = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	if (Shooter == none)
	{
		`REDSCREEN("Multitarget_Cone_Flamethrower : Shooter unit not found.");
		return;
	}	
	WorldData = `XWORLD;
	ShooterVisualizer = XGUnit(History.GetVisualizer(Shooter.ObjectID));

	if (ShooterVisualizer != none && Shooter.CanTakeCover())
	{
		ShooterVisualizer.GetDirectionInfoForPosition(Location, VisibilityInfo, CoverDirection, UsePeek, bCanSeeFromDefault, bRequiresLean, true);
		ShooterPos = ShooterVisualizer.GetExitCoverPosition(CoverDirection, UsePeek);
		ShooterPos.Z = WorldData.GetFloorZForPosition(ShooterPos);
		`LWTRACE("MultiTargetFlamethrower ShooterPosition = (" $ ShooterPos.X $ ", " $ ShooterPos.Y $ ", " $ ShooterPos.Z $ ")"); 
	}
	ShooterPos.Z += class'XComWorldData'.const.WORLD_FloorHeight;
	ConeAxis = Normal(Location - ShooterPos) * GetConeLength(Ability);

	//retrieve all of the tile -- this includes only those tiles 
	WorldData.CollectTilesInCone(TileCollection, ShooterPos, ConeAxis, GetConeEndDiameter(Ability) / 2.0);

	//check LOS-based path length to all tiles using variant of Dijkstra's algorithm
	CurrentConeLength = GetConeLength(Ability);
	SourceTile = WorldData.GetTileCoordinatesFromPosition(ShooterPos);
	//convert to tile array
	for (idx = 0; idx < TileCollection.length; idx++)
	{
		TilePair = TileCollection[idx];
		TempTile.Tile = TilePair.Tile;
		TempTile.Distance = LOCAL_INF;
		UnvisitedTiles.AddItem(TempTile);
	}

	// add in any tiles with direct LOS to the source tile -- inverted loop so can remove tiles marked valid
	// these are removed from invisible tiles, since we are guaranteed this is the minimum possible distance (straight-line)
	for (idx = UnvisitedTiles.Length - 1; idx >= 0; idx--)
	{
		TempTile = UnvisitedTiles[idx];
		TestTile = TempTile.Tile;
		VoxelChecks++;
		if (!WorldData.VoxelRaytrace_Tiles(SourceTile, TestTile, VoxelRaytraceCheckResult))
		{
			UnvisitedTiles[idx].Distance = VoxelRaytraceCheckResult.Distance;
		}
	}

	`LWTRACE("MultiTargetFlamethrower NumTiles=" $ TileCollection.length);
	//UnvisitedTiles.Sort(SortTilesByDistance);  // TODO : implement sorting for O(n log n) instead of O(n^2) if performance required
	CurrentTile = UnvisitedTiles[GetSmallestDistanceTile(UnvisitedTiles, LargestDistance)];
	while (LargestDistance > CurrentConeLength && CurrentTile.Distance <= CurrentConeLength)
	{
		SourceTile = CurrentTile.Tile;
		UpdateChecks = GetAdjacentTiles(SourceTile, UnvisitedTiles);
		foreach UpdateChecks(idx)
		{
			TestTile = UnvisitedTiles[idx].Tile;
			VoxelChecks++;
			if (!WorldData.VoxelRaytrace_Tiles(SourceTile, TestTile, VoxelRaytraceCheckResult))
			{
				// TODO : implement distancesorted insertion for O(n log n) instead of O(n^2) if performance required
				UnvisitedTiles[idx].Distance = FMin(UnvisitedTiles[idx].Distance, CurrentTile.Distance + VoxelRaytraceCheckResult.Distance);
			}
		}
		UnvisitedTiles.RemoveItem(CurrentTile);
		VisitedTiles.AddItem(CurrentTile);
		CurrentTile = UnvisitedTiles[GetSmallestDistanceTile(UnvisitedTiles, LargestDistance)];
	}
	//generate the valid tiles list
	foreach VisitedTiles(TempTile)
	{
		if (TempTile.Distance < CurrentConeLength)
		{
			ValidTiles.AddItem(TempTile.Tile);
		}
	}
	if (ResetCache)
	{
		CachedValidTiles = ValidTiles;
	}
	`LWTRACE("MultiTargetFlamethrower NumTiles=" $ TileCollection.length $ ", VoxelChecks=" $ VoxelChecks);
}

protected function array<int> GetAdjacentTiles(TTile CenterTile, array<TileDistancePair> Tiles)
{
	local int Index, SumIndex;
	local array<int> ReturnIndices;
	local TileDistancePair Tile;

	for (Index = 0; Index < Tiles.length; Index++)
	{
		Tile = Tiles[Index];
		if (Tile.Tile == CenterTile)
		{
			continue;
		}
		SumIndex  =   Abs(CenterTile.X - Tile.Tile.X) 
					+ Abs(CenterTile.Y - Tile.Tile.Y)
					+ Abs(CenterTile.Z - Tile.Tile.Z);

		if (SumIndex <= 1)
		{
			ReturnIndices.AddItem(Index);
		}
	}
	return ReturnIndices;
}

// binary insertion into sorted list
protected function InsertByDistance(TileDistancePair Tile, out array<TileDistancePair> Tiles)
{
	local int FirstIndex, LastIndex, MidPoint, InsertIndex;

	if (Tiles.Length == 0)
	{
		Tiles.AddItem(Tile);
	}

	FirstIndex = 0;
	LastIndex = Tiles.Length - 1;

	while (LastIndex - FirstIndex > 1)
	{
		MidPoint = FirstIndex + LastIndex / 2;
		if (Tiles[MidPoint].Distance < Tile.Distance)
		{
			FirstIndex = MidPoint;
		}
		else
		{
			LastIndex = MidPoint;
		}
	}
	if (LastIndex - FirstIndex == 1)
	{
		InsertIndex = LastIndex;
	}
	else if (FirstIndex == LastIndex)
	{
		if (Tiles[FirstIndex].Distance < Tile.Distance)
		{
			InsertIndex = FirstIndex;
		}
		else
		{
			InsertIndex = FirstIndex+1;
		}
	}
	if (InsertIndex >= Tiles.Length)
	{
		Tiles.AddItem(Tile);
	}
	else
	{
		Tiles.InsertItem(InsertIndex, Tile);
	}
}

// sort so that smaller distance is at front of array
protected function int SortTilesByDistance(TileDistancePair TileA, TileDistancePair TileB)
{
	if (TileA.Distance > TileB.Distance)
	{
		return -1;
	}
	return 1;
}

simulated function int GetSmallestDistanceTile(array<TileDistancePair> Tiles, optional out float LargestDistance)
{
	local float SmallestDistance;
	local int idx, SmallestIndex;

	SmallestDistance = LOCAL_INF;
	LargestDistance = 0;
	for (idx = 0; idx < Tiles.length; idx++)
	{
		if (Tiles[idx].Distance < SmallestDistance)
		{
			SmallestDistance = Tiles[idx].Distance;
			SmallestIndex = idx;
		}
		LargestDistance = FMax(LargestDistance, Tiles[idx].Distance);
	}
	return SmallestIndex;
}

//Return the Valid Uncollided tiles into ValidTiles and everything else into InValidTiles
simulated function GetCollisionValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles, out array<TTile> InValidTiles)
{
	UpdateParameters(Ability);
	GetValidTilesForLocation(Ability, Location, ValidTiles);
}

//converted from native code
simulated function GetMultiTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
	local Vector Nowhere;
	local  int i;
	local AvailableTarget Target;
	for (i = 0; i < Targets.Length; i++)
	{
		if (Targets[i].PrimaryTarget.ObjectID != 0 || bUseSourceWeaponLocation)
		{
			Target = Targets[i];
			GetMultiTargetsForLocation (Ability, Nowhere, Target);
			Targets[i] = Target;
		}
	}
}

simulated function GetMultiTargetsForLocation(XComGameState_Ability Ability, Vector Location, out AvailableTarget Target)
{
	local array<XComGameState_BaseObject> StateObjects;
	local XComGameState_BaseObject StateObject;

	GetTargetedStateObjects(Ability, Location, StateObjects);
	foreach StateObjects(StateObject)
	{
		if (Target.AdditionalTargets.Find('ObjectID', StateObject.ObjectID) == -1)
		{
			Target.AdditionalTargets.AddItem(StateObject.GetReference());
		}
	}
}

simulated function GetTargetedStateObjects(XComGameState_Ability Ability, Vector Location, out array<XComGameState_BaseObject> StateObjects)
{
	local XComGameStateHistory History;
	local XComWorldData WorldData;
	local array<TTile> ValidTiles;
	local TTile Tile;
	local array<StateObjectReference> ObjectRefList;
	local StateObjectReference ObjectRef;
	local XComGameState_BaseObject UseStateObject;
	
	`Log("GetTargetedStateObjects");
	History = `XCOMHISTORY;
	WorldData = `XWORLD;
	GetValidTilesForLocation(Ability, Location, ValidTiles);

	foreach ValidTiles(Tile)
	{
		// for now, skip destructible tiles for flamethrowers (for optimization), since they deal no environmental damage
		//check for units
		ObjectRefList = WorldData.GetUnitsOnTile(Tile);
		foreach ObjectRefList(ObjectRef)
		{
			if (ObjectRef.ObjectID > 0 && 
				!(bExcludeSelfAsTargetIfWithinRadius && (Ability.OwnerStateObject.ObjectID == ObjectRef.ObjectID)))
			{
				UseStateObject = History.GetGameStateForObjectID(ObjectRef.ObjectID);
				if (UseStateObject != none)
				{
					StateObjects.AddItem(UseStateObject);
				}
			}
		}
	}
	// skip bAllowDeadMultiTargetUnits check
}

simulated function UpdateParameters(XComGameState_Ability Ability)
{
	local XComGameStateHistory History;
	local XComGameState_Unit SourceUnit;
	local name AbilityName;
	local int idx;
	local XComGameState_Item SourceItemState;
	local X2MultiWeaponTemplate MultiWeaponTemplate;
	
	`Log("X2ABilityMultiTarget_Cone.UpdateParameters for " $ Ability.GetMyTemplateName());
	History = `XCOMHISTORY;
	SourceItemState = XComGameState_Item( History.GetGameStateForObjectID( Ability.SourceWeapon.ObjectID ) );
	MultiWeaponTemplate = X2MultiWeaponTemplate(SourceItemState.GetMyTemplate());
	if(MultiWeaponTemplate != none)
	{
		ConeEndDiameter = MultiWeaponTemplate.iAltRadius * class'XComWorldData'.const.WORLD_StepSize;
		ConeLength = MultiWeaponTemplate.iAltRange * class'XComWorldData'.const.WORLD_StepSize;

		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
		if(SourceUnit == none)
			return;

		foreach AbilityModifiers(AbilityName, idx)
		{
			if (SourceUnit.HasSoldierAbility(AbilityName))
			{
				ConeEndDiameter += ConeEndDiameterModifiers[idx];
				ConeLength += ConeLengthModifiers[idx];
			}
		}
	}
}

DefaultProperties
{
	AllowedTraversalTypes[0] = eTraversal_Normal;
	AllowedTraversalTypes[1] = eTraversal_Flying;
	AllowedTraversalTypes[2] = eTraversal_Land;
	AllowedTraversalTypes[3] = eTraversal_Launch;
	AllowedTraversalTypes[4] = eTraversal_BreakWindow; 
	AllowedTraversalTypes[5] = eTraversal_KickDoor
	AllowedTraversalTypes[6] = eTraversal_ClimbOver
	AllowedTraversalTypes[7] = eTraversal_ClimbOnto
}