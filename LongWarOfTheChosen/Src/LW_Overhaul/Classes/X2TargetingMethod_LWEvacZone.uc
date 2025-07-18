//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_LWEvacZone.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Subclass of X2TargetingMethod_EvacZone to allow for grenade path visualization.
//---------------------------------------------------------------------------------------


class X2TargetingMethod_LWEvacZone extends X2TargetingMethod_EvacZone;

var protected XComPrecomputedPath GrenadePath;
var protected int EvacDelay;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XComGameState_Item WeaponItem;
	local XGWeapon WeaponVisualizer;
	local X2WeaponTemplate WeaponTemplate;
	local XComWeapon WeaponEntity;

	super.Init(InAction, NewTargetIndex);

	// Show the grenade path
	GrenadePath = `PRECOMPUTEDPATH;
	WeaponItem = Ability.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(WeaponItem.GetMyTemplate());
	WeaponVisualizer = XGWeapon(WeaponItem.GetVisualizer());

	// LWOTC: Patch for getting this to get PlaceDelayedEvacZone ability
	// reliably working with Skirmishers and Templars.
	WeaponEntity = WeaponVisualizer.GetEntity();
	if (WeaponEntity.m_kPawn == none)
	{
		WeaponEntity.m_kPawn = FiringUnit.GetPawn();
	}
	// End patch

	GrenadePath.ClearOverrideTargetLocation();
	GrenadePath.ActivatePath(WeaponEntity, FiringUnit.GetTeam(), WeaponTemplate.WeaponPrecomputedPathData);

	EvacDelay = class'X2Ability_PlaceDelayedEvacZone'.static.GetEvacDelay();
}

function Update(float DeltaTime)
{
	local XComWorldData WorldData;
	local vector NewTargetLocation;
	local TTile CursorTile;

	WorldData = `XWORLD;

	// snap the evac origin to the tile the hypthetical grenade would fall in
	NewTargetLocation = GrenadePath.GetEndPosition();
	WorldData.GetFloorTileForPosition(NewTargetLocation, CursorTile);
	NewTargetLocation = WorldData.GetPositionFromTileCoordinates(CursorTile);
	NewTargetLocation.Z = WorldData.GetFloorZForPosition(NewTargetLocation);

	if(NewTargetLocation != CachedTargetLocation)
	{
		EvacZoneTarget.SetLocation(NewTargetLocation);
		EvacZoneTarget.SetRotation( rot(0,0,1) );
		CachedTargetLocation = NewTargetLocation;

		`LWTrace("Testing target tile" @CursorTile.X @CursorTile.Y @CursorTile.Z);

		EnoughTilesValid = ValidateEvacArea( CursorTile, EvacDelay == 0);
		if (EnoughTilesValid)
		{
			`LWTrace("Valid evac tile in targeting");
			EvacZoneTarget.ShowGoodMesh( );
		}
		else
		{
			EvacZoneTarget.ShowBadMesh( );
		}
	}
}

function bool GetCurrentTargetFocus(out Vector Focus)
{
	Focus = `PRECOMPUTEDPATH.GetEndPosition();
	return true;
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	TargetLocations.Length = 0;
	TargetLocations.AddItem(`PRECOMPUTEDPATH.GetEndPosition());
}


function Canceled()
{
    super.Canceled();
    GrenadePath.ClearPathGraphics();
}

function Committed()
{
	Canceled();
}

static function bool UseGrenadePath() { return true; }

static function bool ValidateEvacArea( const out TTile EvacCenterLoc, bool IncludeSoldiers )
{
	local TTile EvacMin, EvacMax, TestTile;
	local int NumTiles, NumValidTiles;
	local int IsOnFloor;
	local bool bIsValid;

	`LWTrace("Evac Center tile:" @EvacCenterLoc.X @EvacCenterLoc.Y @EvacCenterLoc.Z);

	class'XComGameState_EvacZone'.static.GetEvacMinMax2D( EvacCenterLoc, EvacMin, EvacMax );

	if( IncludeSoldiers && class'X2TargetingMethod_EvacZone'.static.EvacZoneContainsXComUnit(EvacMin, EvacMax) )
	{
		return false;
	}

	NumTiles = (EvacMax.X - EvacMin.X + 1) * (EvacMax.Y - EvacMin.Y + 1);

	NumValidTiles = 0;
	IsOnFloor = 1;

	TestTile = EvacMin;
	while (TestTile.X <= EvacMax.X)
	{
		while (TestTile.Y <= EvacMax.Y)
		{
			//`LWTrace("Testing tile " @ TestTile.X @ " " @ TestTile.Y @ " " @ TestTile.Z);
			bIsValid = class'X2TargetingMethod_EvacZone'.static.ValidateEvacTile(TestTile, IsOnFloor);
			//`LWTrace("ValidateEvacTile returns " @ bIsValid @ ", IsOnFloor=" @ IsOnFloor);

			if (bIsValid)
			{
 			   NumValidTiles++;
			}
			else if (IsOnFloor == 0)
			{
 			   `LWTrace("Evac Tile not on floor, returning false");
			    return false;
			}

			TestTile.Y++;
		}

		TestTile.Y = EvacMin.Y;
		TestTile.X++;
	}
	
	if((NumValidTiles / float( NumTiles )) >= class'X2TargetingMethod_EvacZone'.default.NeededValidTileCoverage)
	{
		return true;
	}
	else
	{
		`LWTrace("Evac point doesn't have enough valid tiles @Tedster");
		return false;
	}
}
