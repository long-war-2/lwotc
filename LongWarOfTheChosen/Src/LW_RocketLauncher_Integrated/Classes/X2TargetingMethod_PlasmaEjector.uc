class X2TargetingMethod_PlasmaEjector extends X2TargetingMethod_Line;

// unused failure

function Update(float DeltaTime)
{
	local array<Actor> CurrentlyMarkedTargets;
	local vector ShooterToTarget;
	local TTile TargetTile;
	local array<TTile> Tiles;
	local Rotator LineRotator;
	local Vector Direction;
	local float VisibilityRadius;

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	//TargetTile = WorldData.GetTileCoordinatesFromPosition(NewTargetLocation);
	NewTargetLocation = IRI_ClampTargetLocation(UnitState, NewTargetLocation);
	TargetTile = WorldData.GetTileCoordinatesFromPosition(NewTargetLocation);

	//NewTargetLocation = WorldData.GetPositionFromTileCoordinates(TargetTile); // dev commented out
	NewTargetLocation.Z = WorldData.GetFloorZForPosition(NewTargetLocation, true) + class'XComWorldData'.const.WORLD_HalfFloorHeight;

	if (TargetTile == FiringTile)
	{
		bGoodTarget = false;
		return;
	}
	bGoodTarget = true;

	if (NewTargetLocation != CachedTargetLocation)
	{
		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );

		DrawAOETiles(Tiles);

		if (LineActor != none)
		{
			ShooterToTarget = NewTargetLocation - FiringLocation;
			LineRotator = rotator( ShooterToTarget );
			LineActor.SetRotation( LineRotator );
		}
	}

	Direction = NewTargetLocation - FiringLocation;
	VisibilityRadius = UnitState.GetVisibilityRadius() * class'XComWorldData'.const.WORLD_StepSize;
	AimingLocation = FiringLocation + (Direction / VSize(Direction)) * VisibilityRadius;

	AimingLocation = ClampTargetLocation(FiringLocation, AimingLocation, WorldData.Volume);

	//	Added by Iridar
	AimingLocation = IRI_ClampTargetLocation(UnitState, AimingLocation);

	super.Update(DeltaTime);
}

static function vector IRI_ClampTargetLocation(XComGameState_Unit SourceUnit, vector TargetLocation)
{
	local WeaponDamageValue		ExpectedDamage;

	local XComGameState_Unit		AdditionalTarget;
	local array<XComGameState_Unit>	AdditionalTargets;

	local XComWorldData			WorldDataObj;
	local XComGameStateHistory	History;

	local vector				ShooterLocation;
	local array<StateObjectReference>	UnitsOnTile;
	local StateObjectReference			UnitRef;

	local TTile TestTile;
	local array<XComDestructibleActor>	DestructibleActors;
	local array<TilePosPair>			Tiles;
	local int i;
	

	History = `XCOMHISTORY;
	WorldDataObj = `XWORLD;

	ExpectedDamage = class'X2Rocket_Plasma_Ejector'.default.BASEDAMAGE;
	ShooterLocation = WorldDataObj.GetPositionFromTileCoordinates(SourceUnit.TileLocation);

	//	first, reduce damage based on tile distance to the target.
	ExpectedDamage.Damage -= class'X2Effect_ApplyPlasmaEjectorDamage'.default.DAMAGE_LOSS_PER_TILE * class'X2Effect_ApplyPlasmaEjectorDamage'.static.TileDistanceBetweenVectors(ShooterLocation, TargetLocation);

	//	If that would reduce damage to zero or lower, exit the function then and there.
	if (ExpectedDamage.Damage <= 0) 
	{
		return TargetLocation;
	}
	else
	{
		//	grab all the tiles between the shooter and the target
		WorldDataObj.CollectTilesInCapsule(Tiles, ShooterLocation, TargetLocation, 1.0f); //WORLD_StepSize

		//	cycle through grabbed tiles
		for (i = 0; i < Tiles.Length; i++)
		{
			//	and try to find any units on it
			UnitsOnTile = WorldDataObj.GetUnitsOnTile(Tiles[i].Tile);
			foreach UnitsOnTile(UnitRef)
			{
				AdditionalTarget = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

				//	Add the Unit to the list of additional targets only if it's not the shooter, and not the primary target of this effect, and it's not in the list already
				//	and it's actually alive and not in Stasis
				if (AdditionalTarget != none && 
					UnitRef.ObjectID != SourceUnit.ObjectID && 
					AdditionalTargets.Find(AdditionalTarget) == INDEX_NONE &&
					AdditionalTarget.IsAlive() &&
					!AdditionalTarget.IsInStasis()) 
				{
					AdditionalTargets.AddItem(AdditionalTarget);
				}
			}
		}

		//	Cycle through filtered out targets and reduce damage dealt to this current target by the cumulitive amount of HP and Armor of all the units between the shooter and this current target
		for (i = 0; i < AdditionalTargets.Length; i++)
		{
			ExpectedDamage.Damage -= AdditionalTargets[i].GetCurrentStat(eStat_HP);
			ExpectedDamage.Damage -= AdditionalTargets[i].GetCurrentStat(eStat_ArmorMitigation); //	armor mitigates damage before being shredded
			
			if (ExpectedDamage.Damage <= 0)
			{
				return WorldDataObj.GetPositionFromTileCoordinates(AdditionalTargets[i].TileLocation);
			}
		}

		//	Then grab all the destructible objects between shooter and target. this includes ONLY things like cars and gas tanks, but not cover objects. (?)
		WorldDataObj.CollectDestructiblesInTiles(Tiles, DestructibleActors);
		for (i = 0; i < DestructibleActors.Length; i++)
		{
			ExpectedDamage.Damage -= int(DestructibleActors[i].Health / class'X2Effect_ApplyPlasmaEjectorDamage'.default.ENVIRONMENTAL_DAMAGE_MULTIPLIER);
			
			if (ExpectedDamage.Damage <= 0)
			{	
				TestTile = DestructibleActors[i].AssociatedTiles[0];
				return WorldDataObj.GetPositionFromTileCoordinates(TestTile);
			}
		}
	}
	
	return TargetLocation;
}