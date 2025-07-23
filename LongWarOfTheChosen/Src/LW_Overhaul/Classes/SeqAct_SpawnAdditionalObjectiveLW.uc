
// Author - Tedster - 7/21/2025
// Modifies the Activated event on the base game class for better validity checking.

class SeqAct_SpawnAdditionalObjectiveLW extends SeqAct_SpawnAdditionalObjective;

event Activated()
{
	local XComTacticalMissionManager MissionManager;
	local XComGameState_ObjectiveInfo ObjectiveInfo;
	local XComGameStateContext_ChangeContainer ChangeContext;
	local XComGameState NewGameState;
	local TTile SpawnTile, TestTile;
    local int IsOnFloor, i, maxHeightTile, maxZ;
	local XComWorldData WorldData;
	local bool bAlternativeFound;
	local vector LOPVector, NormalVector, SideVector, InitialOutVector, ScaledSideVector, AdjustedVector, AdjustedTestVector;
	local array<TilePosPair> StartTiles;
	local XComGameState_BattleData BattleData;
	local float LOPLength, LOPalpha;

	SpawnedObjective = none;

	if(SelectSpawnTile(SpawnTile))
	{

		// If something is there already or there's no clearance, or it's not pathable, then pick a new one
        if(!IsActuallyValidTile(SpawnTile, isOnFloor))
        {
			`LWTrace("Tile not valid with updated check, manually picking a new one");
			SpawnTile = SelectNewSpawnTile(SpawnTile);
			`LWTrace("Selected tile" @SpawnTile.X @SpawnTile.Y @SpawnTile.Z);
        }
		else
		{
			`LWTrace("Initial tile found by the check is valid");
		}

		MissionManager = `TACTICALMISSIONMGR;
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SeqAct_SpawnAdditionalObjective::Activate()");
		ChangeContext = XComGameStateContext_ChangeContainer(NewGameState.GetContext());
		ChangeContext.BuildVisualizationFn = BuildVisualization;

		SpawnedObjective = XComGameState_InteractiveObject(NewGameState.CreateNewStateObject(class'XComGameState_InteractiveObject'));
		SpawnedObjective.ArchetypePath = ObjectiveArchetype != none ? PathName(ObjectiveArchetype) : ObjectiveArchetypePathString;
		SpawnedObjective.TileLocation = SpawnTile;
		SpawnedObjective.bRequiresVisibilityUpdate = true;

		if (ObjectiveRelated)
		{
			ObjectiveInfo = XComGameState_ObjectiveInfo(NewGameState.CreateNewStateObject(class'XComGameState_ObjectiveInfo'));
			ObjectiveInfo.MissionType = MissionManager.ActiveMission.sType;
			ObjectiveInfo.AffectsLineOfPlay = AffectsLineOfPlay;

			SpawnedObjective.AddComponentObject(ObjectiveInfo);
		}

		NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);

		`TACTICALRULES.SubmitGameState(NewGameState);
		OutputLinks[0].bHasImpulse = true;
		OutputLinks[1].bHasImpulse = false;
	}
	else
	{
		`LWTrace("Base game failed, finding our own point to spawn the crate. @Tedster");
		WorldData = `XWORLD;
		BattleData = XComGameState_BattleData(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
		//WorldData.GetFloorTileForPosition(`BATTLEDATA.MapData.ObjectiveLocation, SpawnTile, true);

		// Intentionally inverted, to start at the objective
		LOPVector = BattleData.MapData.SoldierSpawnLocation - BattleData.MapData.ObjectiveLocation;

		// How long is it?
		LOPLength = VSize(LOPVector);

		// Use 2 cross products to get the vector perpendicular to the starting vector + the vertical plane relative to the start
		NormalVector = Normal(LOPVector Cross(BattleData.MapData.ObjectiveLocation));

		SideVector = -1 * Normal(LOPVector Cross(NormalVector)); // Flip the side one to make signs work as expected?

		// Converts the min/max distance along the objective vector into a percentage for VLerp
		LOPalpha = ((MinTileDistance + MaxTileDistance)/2.0) * 96 / LOPLength;

		InitialOutVector = VLerp(BattleData.MapData.ObjectiveLocation, BattleData.MapData.SoldierSpawnLocation, LOPalpha);

		// Calcs the vector that represents the offsets
		ScaledSideVector = SideVector * (MaxTilesFromLineOfPlay * LineOfPlayJustification) * 96;

		// Add the side component to the straight component
		AdjustedVector = InitialOutVector + ScaledSideVector;
		`LWTrace("Adjusted vector location:" @AdjustedVector.X @AdjustedVector.Y @AdjustedVector.Z);
		AdjustedTestVector = AdjustedVector;
		AdjustedTestVector.Z = 0;

		MaxZ = class'XComWorldData'.const.WORLD_FloorHeightsPerLevel * class'XComWorldData'.const.WORLD_TotalLevels * class'XComWorldData'.const.WORLD_FloorHeight;
		WorldData.CollectTilesInCylinder(StartTiles, AdjustedTestVector, WorldData.WORLD_StepSize/2, MaxZ);
		
		//`LWTrace("Found" @StartTiles.Length @"Tiles to test for floor");

		SpawnTile.X = 0;
		SpawnTile.Y = 0;
		SpawnTile.Z = 0;
		maxHeightTile = 0;

		for (i = 0; i < StartTiles.length; i++)
		{
			TestTile = StartTiles[i].Tile;

			//`LWTrace("Testing Tile" @TestTile.X @TestTile.Y @TestTile.Z);

			if(WorldData.IsFloorTile(TestTile) && TestTile.Z > StartTiles[maxHeightTile].Tile.Z)
			{
				maxHeightTile = i;
			}

		}
			SpawnTile = StartTiles[maxHeightTile].Tile;

		if(SpawnTile.Z == 0)
		{
			WorldData.GetFloorTileForPosition(AdjustedVector, SpawnTile, true);
		}

		//`LWTrace("Calculated initial tile:" @SpawnTile.X @SpawnTile.Y @SpawnTile.Z);

		SpawnTile = SelectNewSpawnTile(SpawnTile);

		if(WorldData.IsFloorTile(SpawnTile))
		{
			bAlternativeFound = true;
			`LWTrace("Found alternative tile:" @SpawnTile.X @SpawnTile.Y @Spawntile.Z);
		}

		if(bAlternativeFound)
		{
			MissionManager = `TACTICALMISSIONMGR;

			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SeqAct_SpawnAdditionalObjective::Activate()");
			ChangeContext = XComGameStateContext_ChangeContainer(NewGameState.GetContext());
			ChangeContext.BuildVisualizationFn = BuildVisualization;

			SpawnedObjective = XComGameState_InteractiveObject(NewGameState.CreateNewStateObject(class'XComGameState_InteractiveObject'));
			SpawnedObjective.ArchetypePath = ObjectiveArchetype != none ? PathName(ObjectiveArchetype) : ObjectiveArchetypePathString;
			SpawnedObjective.TileLocation = SpawnTile;
			SpawnedObjective.bRequiresVisibilityUpdate = true;

			if (ObjectiveRelated)
			{
				ObjectiveInfo = XComGameState_ObjectiveInfo(NewGameState.CreateNewStateObject(class'XComGameState_ObjectiveInfo'));
				ObjectiveInfo.MissionType = MissionManager.ActiveMission.sType;
				ObjectiveInfo.AffectsLineOfPlay = AffectsLineOfPlay;

				SpawnedObjective.AddComponentObject(ObjectiveInfo);
			}

			NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);

			`TACTICALRULES.SubmitGameState(NewGameState);
			OutputLinks[0].bHasImpulse = true;
			OutputLinks[1].bHasImpulse = false;
		}
		else
		{
			`Redscreen("SeqAct_SpawnAdditionalObjective: no matching spawn location found.");
			OutputLinks[0].bHasImpulse = false;
			OutputLinks[1].bHasImpulse = true;
		}
	}
}

// Checks for valid tile by checking whether it's a valid Evac tile, whether something is already there, and is it a reachable floor tile
static function bool IsActuallyValidTile(out TTile TestTile, out int bIsOnFloor)
{
    local XComWorldData WorldData;
	local int MaxZ;
	local Vector testVector;

	WorldData = `XWORLD;

	//`LWTrace("Checking possible tile" @ TestTile.X @ TestTile.Y @ TestTile.Z);
	if(WorldData.IsTileFullyOccupied(TestTile))
	{
		//`LWTrace("Tile is occupied - Fail");
		return false;
	}

	if(!class'X2TargetingMethod_EvacZone'.static.ValidateEvacTile(TestTile, bIsOnFloor))
	{
		//`LWTrace("Validate evac zone check failed");
		return false;
	}


	if(!WorldData.CanUnitsEnterTile(TestTile))
    {
		//`LWTrace("Units can't enter tile - fail");
		return false;
    }

	if(WorldData.IsRampTile(TestTile))
	{
		//`LWTrace("Tile is ramp tile - fail");
		return false;
	}

	MaxZ = class'XComWorldData'.const.WORLD_FloorHeightsPerLevel * class'XComWorldData'.const.WORLD_TotalLevels * class'XComWorldData'.const.WORLD_FloorHeight;
	TestVector = WorldData.GetPositionFromTileCoordinates(TestTile);
	if(!WorldData.HasOverheadClearance(TestVector, float(MaxZ)))
	{
		`LWTrace("Tile doesn't have clearance - fail");
		return false;
	}

	return true;
}

// Iterates over all tiles surrounding the initial selection, widening the box size until there is a valid tile.
static function TTile SelectNewSpawnTile(TTile CenterTile)
{
	local int radius;
	local array<TTile> ValidTiles;
	local TTile IterationTile, TestTile, TestMin, TestMax;
	local int bIsOnFloor;
	local XComWorldData WorldData;

	WorldData = `XWORLD;

	ValidTiles.Length = 0;
	radius = 1;

	while (ValidTiles.length == 0)
	{
		//`LWTrace("Radius =" @radius);
		GetMinMaxZone2D(CenterTile, TestMin, TestMax, radius);

		IterationTile = TestMin;

		while (IterationTile.X <= TestMax.X)
		{
			while (IterationTile.Y <= TestMax.Y)
			{
				TestTile = IterationTile;
				TestTile.Z = WorldData.GetFloorTileZ(IterationTile, true);
				if (IsActuallyValidTile( TestTile, bIsOnFloor ))
				{
					ValidTiles.AddItem(TestTile);
				}

				IterationTile.Y++;
			}

		IterationTile.Y = TestMin.Y;
		IterationTile.X++;
		}

		radius++;
	}

	return ValidTiles[`SYNC_RAND_STATIC(ValidTiles.Length)];
}

// Borrowed from XCGS_EvacZone and tweaked to add a radius
static function GetMinMaxZone2D(TTile CenterTile, out TTile TileMin, out TTile TileMax, int radius)
{
	local int i;
	TileMin = CenterTile;
	TileMax = CenterTile;

	for(i = 0; i < radius; i++)
	{
		TileMin.X -= 1;
		TileMin.Y -= 1;

		TileMax.X += 1;
		TileMax.Y += 1;
	}
}

defaultproperties
{
	ObjName="LW Spawn Additional Objective"
}