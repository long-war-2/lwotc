//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_Cone_Flamethrower_LW.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Custom targeting method tweaked for technical flamethrower targeting
//			 - Removed tile snapping, since it doesn't make much sense since further away tile can be targeted for smaller angles anyhow
//			 - Source and target set to more similar heights, instead of source at +half-height and target at floor
//---------------------------------------------------------------------------------------
class X2TargetingMethod_Cone_Flamethrower_LW extends X2TargetingMethod_Cone config(Game);

//`include(LongWaroftheChosen\Src\LW_Overhaul.uci)

var float CumulativeUpdateTime;

var protected X2Actor_ConeTarget ConeActor_Vert;
var protected X2Actor_ConeTarget ConeActor_Vert2;

var config float MaxFramesPerSecondUpdateRate;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local float TargetingRange;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Cone ConeMultiTarget;
	local X2AbilityTemplate AbilityTemplate;

	super(X2TargetingMethod).Init(InAction, NewTargetIndex);
	WorldData = `XWORLD;

	FiringTile = UnitState.TileLocation;
	FiringLocation = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);
	FiringLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;

	AssociatedPlayerStateRef.ObjectID = UnitState.ControllingPlayer.ObjectID;

	// determine our targeting range
	TargetingRange = Ability.GetAbilityCursorRangeMeters();

	// lock the cursor to that range
	Cursor = `Cursor;
	Cursor.m_fMaxChainedDistance = `METERSTOUNITS(TargetingRange);

	AbilityTemplate = Ability.GetMyTemplate();

	ConeMultiTarget = X2AbilityMultiTarget_Cone(AbilityTemplate.AbilityMultiTargetStyle);
	`assert(ConeMultiTarget != none);
	ConeLength = ConeMultiTarget.GetConeLength(Ability);
	ConeWidth = ConeMultiTarget.GetConeEndDiameter(Ability);

	CursorTarget = X2AbilityTarget_Cursor(AbilityTemplate.AbilityTargetStyle);
	if (CursorTarget != none)
		bRestrictToSquadsightRange = CursorTarget.bRestrictToSquadsightRange;

	if (!AbilityTemplate.SkipRenderOfTargetingTemplate)
	{
		// setup the targeting mesh
		ConeActor = `BATTLE.Spawn(class'X2Actor_ConeTarget');
		ConeActor_Vert = `BATTLE.Spawn(class'X2Actor_ConeTarget');
		ConeActor_Vert2 = `BATTLE.Spawn(class'X2Actor_ConeTarget');
		if(AbilityIsOffensive)
		{
			ConeActor.MeshLocation = "UI_3D.Targeting.ConeRange";
			ConeActor_Vert.MeshLocation = "UI_3D.Targeting.ConeRange";
			ConeActor_Vert2.MeshLocation = "UI_3D.Targeting.ConeRange";
		}
		ConeActor.InitConeMesh(ConeLength / class'XComWorldData'.const.WORLD_StepSize, ConeWidth / class'XComWorldData'.const.WORLD_StepSize);
		ConeActor.SetLocation(FiringLocation);
		ConeActor_Vert.InitConeMesh(ConeLength / class'XComWorldData'.const.WORLD_StepSize, ConeWidth / class'XComWorldData'.const.WORLD_StepSize);
		ConeActor_Vert.SetLocation(FiringLocation);
		ConeActor_Vert2.InitConeMesh(ConeLength / class'XComWorldData'.const.WORLD_StepSize, ConeWidth / class'XComWorldData'.const.WORLD_StepSize);
		ConeActor_Vert2.SetLocation(FiringLocation);
	}
}

function Update(float DeltaTime)
{
	local array<Actor> CurrentlyMarkedTargets;
	local vector Direction;
	local TTile TargetTile;
	local array<TTile> Tiles; //, NeighborTiles;
	//local X2AbilityMultiTarget_Cone targetingMethod;
	//local INT i;
	local vector SnappedTargetLocation;

	//`LWTRACE("Flamethrower TargetingMethod : DeltaTime = " $ DeltaTime);
	CumulativeUpdateTime += DeltaTime;
	if (MaxFramesPerSecondUpdateRate > 0 && CumulativeUpdateTime < 1.0/MaxFramesPerSecondUpdateRate)
	{
		return;
	}
	else if (`XWORLDINFO.bAggressiveLOD) // frame rate is well below DesiredFrameRate, so make LOD more aggressive
	{
		if (CumulativeUpdateTime < 0.1)
		{
			return;
		}
		else
		{
			CumulativeUpdateTime = 0;
		}
	}
	else if (`XWORLDINFO.bDropDetail) // frame rate is below DesiredFrameRate
	{
		if (CumulativeUpdateTime < 0.05)
		{
			return;
		}
		else
		{
			CumulativeUpdateTime = 0;
		}
	}

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	//TargetTile = WorldData.GetTileCoordinatesFromPosition(NewTargetLocation);
	WorldData.GetFloorTileForPosition(NewTargetLocation, TargetTile);
	//NewTargetLocation = WorldData.GetPositionFromTileCoordinates(TargetTile);
	SnappedTargetLocation = WorldData.GetPositionFromTileCoordinates(TargetTile);
	NewTargetLocation.Z = SnappedTargetLocation.Z;
	NewTargetLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;

	if (TargetTile == FiringTile)
	{
		bGoodTarget = false;
		return;
	}

	bGoodTarget = true;
	Direction = NewTargetLocation - FiringLocation;

	NewTargetLocation = FiringLocation + (Direction / VSize(Direction)) * ConeLength;       //  recalibrate based on direction to cursor; must always be as long as possible

	if (NewTargetLocation != CachedTargetLocation)
	{
		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);

		//targetingMethod = X2AbilityMultiTarget_Cone(Ability.GetMyTemplate().AbilityMultiTargetStyle);

		//if (Ability.GetMyTemplate().bAffectNeighboringTiles)
		//{
			//ReticuleTargetedTiles.Length = 0;
			//ReticuleTargetedSecondaryTiles.Length = 0;
			//Tiles.Length = 0;
//
			//targetingMethod.GetCollisionValidTilesForLocation(Ability, NewTargetLocation, Tiles, NeighborTiles);
//
			////class'WorldInfo'.static.GetWorldInfo().FlushPersistentDebugLines();
			//ReticuleTargetedTiles = Tiles;
//
			//for (i = 0; i < NeighborTiles.Length; i++)
			//{
				//if (IsNeighborTile(NeighborTiles[i], ReticuleTargetedTiles) && IsNextToWall(NeighborTiles[i]) )
				//{
					//ReticuleTargetedSecondaryTiles.AddItem(NeighborTiles[i]);
					////`SHAPEMGR.DrawTile(NeighborTiles[i], 0, 255, 0, 0.9);
				//}
			//}
		//}

		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius(NewTargetLocation);		
		DrawAOETiles(Tiles);
	}

	Super(X2TargetingMethod).Update(DeltaTime);
}

//override native
simulated protected function GetTargetedActors(const vector Location, out array<Actor> TargetActors, optional out array<TTile> TargetTiles)
{
	local XComGameStateHistory History;
	local X2AbilityMultiTarget_Cone_LWFlamethrower MultiTarget;
	local AvailableTarget AbilityTarget;
	local StateObjectReference Target;
	local XComGameState_BaseObject TargetState;

	History = `XCOMHISTORY;
	MultiTarget = X2AbilityMultiTarget_Cone_LWFlamethrower(Ability.GetMyTemplate().AbilityMultiTargetStyle);
	if (MultiTarget == none)
	{
		return;
	}
	MultiTarget.ResetCache = true;
	MultiTarget.GetMultiTargetsForLocation(Ability, Location, AbilityTarget);
	foreach AbilityTarget.AdditionalTargets(Target)
	{
		TargetState = History.GetGameStateForObjectID(Target.ObjectID);
		if (TargetState != none)
		{
			TargetActors.AddItem(TargetState.GetVisualizer());
		}
	}
	MultiTarget.GetValidTilesForLocation(Ability, Location, TargetTiles);
	//skip environment actors for flamethrower
}


//override to allow offsetting for stepping out
simulated protected function DrawSplashRadius(Vector TargetLoc)
{
	local Vector ShooterPos;
	local XGUnit UnitVisualizer;
	local int CoverDirection;
	local UnitPeekSide UsePeek;
	local int bCanSeeFromDefault, bRequiresLean;
	local Vector ShooterToTarget;
	local Rotator ConeRotator;
	local GameRulesCache_VisibilityInfo VisibilityInfo;

	//replicate step-out calculations from the MultiTarget_Flamethrower  to offset the center point of the ConeActor
	UnitVisualizer = XGUnit(UnitState.GetVisualizer());

	if (UnitVisualizer != none && UnitState.CanTakeCover())
	{
		UnitVisualizer.GetDirectionInfoForPosition(TargetLoc, VisibilityInfo, CoverDirection, UsePeek, bCanSeeFromDefault, bRequiresLean, true);
		ShooterPos = UnitVisualizer.GetExitCoverPosition(CoverDirection, UsePeek);
		ShooterPos.Z = WorldData.GetFloorZForPosition(ShooterPos);
		ShooterPos.Z += class'XComWorldData'.const.WORLD_FloorHeight;

		ConeActor.SetLocation(ShooterPos);
		ConeActor_Vert.SetLocation(ShooterPos);
		ConeActor_Vert2.SetLocation(ShooterPos);
	}
	super.DrawSplashRadius(TargetLoc);

	if (ConeActor_Vert != none)
	{
		ShooterToTarget = TargetLoc - FiringLocation;
		ConeRotator = rotator(ShooterToTarget);
		ConeRotator.Roll = 90 * DegToUnrRot; //Rotate by 90 degrees so it is vertical
		ConeActor_Vert.SetRotation(ConeRotator);
	}
	if (ConeActor_Vert != none)
	{
		ShooterToTarget = TargetLoc - FiringLocation;
		ConeRotator = rotator(ShooterToTarget);
		ConeRotator.Roll = -90 * DegToUnrRot; //Rotate by 90 degrees so it is vertical
		ConeActor_Vert2.SetRotation(ConeRotator);
	}
}

//destroy extra actor
function Canceled()
{
	// clean up the ui
	ConeActor_Vert.Destroy();
	ConeActor_Vert2.Destroy();

	super.Canceled();
}