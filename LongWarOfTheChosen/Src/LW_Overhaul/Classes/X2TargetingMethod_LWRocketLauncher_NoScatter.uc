//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_LWRocketLauncher_NoScatter.uc
//  AUTHOR:  Amineri (Pavonis Interactive) / Tedster
//  PURPOSE: Custom targeting method without scatter for LW Rocket Launcher in Gauntlet_CV
//---------------------------------------------------------------------------------------
class X2TargetingMethod_LWRocketLauncher_NoScatter extends X2TargetingMethod_RocketLauncher;

//var bool SnapToTile;

function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
	Ability.GatherAdditionalAbilityTargetsForLocation(NewTargetLocation, AdditionalTargets);
	return true;
}

//class'XComWorldData'.const.WORLD_HalfFloorHeight

function Update(float DeltaTime)
{
	local XComWorldData World;
	local VoxelRaytraceCheckResult Raytrace;
	local array<Actor> CurrentlyMarkedTargets;
	local int Direction, CanSeeFromDefault;
	local GameRulesCache_VisibilityInfo VisibilityInfo;
	local UnitPeekSide PeekSide;
	local int OutRequiresLean;
	local TTile BlockedTile, PeekTile, UnitTile, SnapTile, TargetTile;
	local bool GoodView;
	local CachedCoverAndPeekData PeekData;
	local array<TTile> Tiles;
	local vector FiringLocation;

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	NewTargetLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;

	if( NewTargetLocation != CachedTargetLocation )
	{
		FiringLocation = FiringUnit.Location;
		FiringLocation.Z += 80; // (World_FloorHeight is 64, add 16 for a bit of jank improvement)
		World = `XWORLD;
		GoodView = false;
		if( World.VoxelRaytrace_Locations(FiringLocation, NewTargetLocation, Raytrace) )
		{
			BlockedTile = Raytrace.BlockedTile; 
			//  check left and right peeks
			FiringUnit.GetDirectionInfoForPosition(NewTargetLocation, VisibilityInfo, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);

			if (PeekSide != eNoPeek)
			{
				UnitTile = World.GetTileCoordinatesFromPosition(FiringUnit.Location);
				PeekData = World.GetCachedCoverAndPeekData(UnitTile);
				if (PeekSide == ePeekLeft)
					PeekTile = PeekData.CoverDirectionInfo[Direction].LeftPeek.PeekTile;
				else
					PeekTile = PeekData.CoverDirectionInfo[Direction].RightPeek.PeekTile;

				TargetTile = World.GetTileCoordinatesFromPosition(NewTargetLocation);
				if (!World.VoxelRaytrace_Tiles(PeekTile, TargetTile, Raytrace))
					GoodView = true;
				else
					BlockedTile = Raytrace.BlockedTile;
			}				
		}		
		else
		{
			GoodView = true;
		}

		if( !GoodView )
		{
			NewTargetLocation = World.GetPositionFromTileCoordinates(BlockedTile);
			//`SHAPEMGR.DrawSphere(LastTargetLocation, vect(25,25,25), MakeLinearColor(1,0,0,1), false);
		}
		else
		{
			if (SnapToTile)
			{
				SnapTile = `XWORLD.GetTileCoordinatesFromPosition(NewTargetLocation);
				`XWORLD.GetFloorPositionForTile(SnapTile, NewTargetLocation);
			}
		}
		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius();
		DrawAOETiles(Tiles);

	}

	super(X2TargetingMethod_Grenade).UpdateTargetLocation(DeltaTime);
}

defaultproperties
{
	SnapToTile = true;
}