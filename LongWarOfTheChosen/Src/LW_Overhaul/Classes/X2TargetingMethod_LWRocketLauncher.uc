//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_LWRocketLauncher.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Custom targeting method with scatter for LW Rocket Launcher in Gauntlet_CV
//---------------------------------------------------------------------------------------
class X2TargetingMethod_LWRocketLauncher extends X2TargetingMethod_RocketLauncher;

//var bool SnapToTile;
var UIScrollingTextField ScatterAmountText;

function Init(AvailableAction InActionAvailable, int NewTargetIndex)
{
	local UITacticalHUD TacticalHUD;

	super.Init(InActionAvailable, NewTargetIndex);
	TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
	ScatterAmountText = TacticalHUD.Spawn(class'UIScrollingTextField', TacticalHUD);
	ScatterAmountText.bAnimateOnInit = false;
	ScatterAmountText.InitScrollingText('AverageScatterText_LW', "", 400, 0, 0);
	ScatterAmountText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText("± 1.4 Tiles", eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D));
	ScatterAmountText.ShowShadow(0);
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	local vector ScatteredTargetLoc;

	ScatteredTargetLoc = NewTargetLocation;
	ScatteredTargetLoc = class'X2Ability_LW_TechnicalAbilitySet'.static.GetScatterAmount(UnitState, ScatteredTargetLoc);

	NewTargetLocation = ScatteredTargetLoc;
	TargetLocations.Length = 0;
	TargetLocations.AddItem(ScatteredTargetLoc);
}

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
	local TTile BlockedTile, PeekTile, UnitTile, SnapTile;
	local bool GoodView;
	local CachedCoverAndPeekData PeekData;
	local array<TTile> Tiles;
	local vector FiringLocation;
	local vector2d vMouseCursorPos;
	local float ExpectedScatter;

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	NewTargetLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;

	if( NewTargetLocation != CachedTargetLocation )
	{
		FiringLocation = FiringUnit.Location;
		FiringLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;
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

				if (!World.VoxelRaytrace_Tiles(UnitTile, PeekTile, Raytrace))
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
			Cursor.CursorSetLocation(NewTargetLocation);
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

		//update expected scatter amount display
		vMouseCursorPos = class'UIUtilities_LW'.static.GetMouseCoords();
		ScatterAmountText.SetPosition(vMouseCursorPos.X + 2, vMouseCursorPos.Y + 14); // this follows cursor
		ExpectedScatter = class'X2Ability_LW_TechnicalAbilitySet'.static.GetExpectedScatter(UnitState, NewTargetLocation);
		ScatterAmountText.SetHTMLText(class'UIUtilities_LW'.static.GetHTMLAverageScatterText(ExpectedScatter));
	}

	super(X2TargetingMethod_Grenade).UpdateTargetLocation(DeltaTime);
}

function Canceled()
{
	super.Canceled();

	ScatterAmountText.Remove();
	ScatterAmountText.Destroy();
}

defaultproperties
{
	SnapToTile = true;
}