class X2TargetingMethod_Collateral extends X2TargetingMethod;

var protected XCom3DCursor Cursor;
var protected transient XComEmitter ExplosionEmitter;
var protected bool bRestrictToSquadsightRange;
var protected XComGameState_Player AssociatedPlayerState;

var bool SnapToTile;

function Init(AvailableAction InAction, int NewTargetIndex)
{
	local XComGameStateHistory History;
	local float TargetingRange;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityTemplate AbilityTemplate;

	super.Init(InAction, NewTargetIndex);

	History = `XCOMHISTORY;

	AssociatedPlayerState = XComGameState_Player(History.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));
	`assert(AssociatedPlayerState != none);

	// determine our targeting range
	AbilityTemplate = Ability.GetMyTemplate();
	TargetingRange = UnitState.GetCurrentStat(eStat_SightRadius);

	// lock the cursor to that range
	Cursor = `Cursor;
	Cursor.m_fMaxChainedDistance = `METERSTOUNITS(TargetingRange);

	CursorTarget = X2AbilityTarget_Cursor(Ability.GetMyTemplate().AbilityTargetStyle);
	if (CursorTarget != none)
		bRestrictToSquadsightRange = CursorTarget.bRestrictToSquadsightRange;

	if (!AbilityTemplate.SkipRenderOfTargetingTemplate)
	{
		// setup the blast emitter
		ExplosionEmitter = `BATTLE.spawn(class'XComEmitter');
		if(AbilityIsOffensive)
		{
			ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere", class'ParticleSystem')));
		}
		else
		{
			ExplosionEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere_Neutral", class'ParticleSystem')));
		}
		
		ExplosionEmitter.LifeSpan = 60 * 60 * 24 * 7; // never die (or at least take a week to do so)
	}
}

function Canceled()
{
	super.Canceled();

	// unlock the 3d cursor
	Cursor.m_fMaxChainedDistance = -1;

	// clean up the ui
	ExplosionEmitter.Destroy();
	ClearTargetedActors();
}

function Committed()
{
	Canceled();
}

simulated protected function Vector GetSplashRadiusCenter()
{
	local vector Center;
	local TTile SnapTile;

	Center = Cursor.GetCursorFeetLocation();

	if (SnapToTile)
	{
		SnapTile = `XWORLD.GetTileCoordinatesFromPosition( Center );
		`XWORLD.GetFloorPositionForTile( SnapTile, Center );
	}

	return Center;
}

simulated protected function DrawSplashRadius()
{
	local Vector Center;
	local float Radius;
	local LinearColor CylinderColor;

	Center = GetSplashRadiusCenter();
	Radius = Ability.GetAbilityRadius(); // This method lies! It clamps us to 1-meter increments
	
	if (ExplosionEmitter != none)
	{
		ExplosionEmitter.SetLocation(Center); // Set initial location of emitter
		ExplosionEmitter.SetDrawScale(Radius / 48.0f);
		ExplosionEmitter.SetRotation( rot(0,0,1) );

		if (!ExplosionEmitter.ParticleSystemComponent.bIsActive)
		{
			ExplosionEmitter.ParticleSystemComponent.ActivateSystem();			
		}

		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(0, Name("RadiusColor"), CylinderColor);
		ExplosionEmitter.ParticleSystemComponent.SetMICVectorParameter(1, Name("RadiusColor"), CylinderColor);
	}
}

function Update(float DeltaTime)
{
	local XComWorldData World;
	local VoxelRaytraceCheckResult Raytrace;
	local array<Actor> CurrentlyMarkedTargets;
	local int Direction, CanSeeFromDefault;
	local UnitPeekSide PeekSide;
    local GameRulesCache_VisibilityInfo VisInfo;
	local int OutRequiresLean;
	local TTile PeekTile, UnitTile;
	local bool GoodView;
	local CachedCoverAndPeekData PeekData;
	local vector NewTargetLocation, FiringUnitLocation, BlockedPosition;
	local array<TTile> Tiles;

	NewTargetLocation = GetSplashRadiusCenter();
	NewTargetLocation.Z += class'XComWorldData'.const.WORLD_HalfFloorHeight;

	if(NewTargetLocation != CachedTargetLocation)
	{		
		World = `XWORLD;
		GoodView = false;
		FiringUnitLocation = FiringUnit.Location;
		FiringUnitLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;
		if (World.VoxelRaytrace_Locations(FiringUnitLocation, NewTargetLocation, Raytrace))
		{
			BlockedPosition = Raytrace.TraceBlocked;
			// Check left and right peeks
			FiringUnit.GetDirectionInfoForPosition(NewTargetLocation, VisInfo, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);

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
					BlockedPosition = Raytrace.TraceBlocked;
			}				
		}		
		else
		{
			GoodView = true;
		}

		if (!GoodView)
		{
			NewTargetLocation = BlockedPosition;//World.GetPositionFromTileCoordinates(BlockedTile);
			Cursor.CursorSetLocation(NewTargetLocation);
			//`SHAPEMGR.DrawSphere(LastTargetLocation, vect(25,25,25), MakeLinearColor(1,0,0,1), false);
		}

		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius();
		DrawAOETiles(Tiles);
	}

	super.Update(DeltaTime);
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	TargetLocations.Length = 0;
	TargetLocations.AddItem(GetSplashRadiusCenter());
}

function name ValidateTargetLocations(const array<Vector> TargetLocations)
{
	local TTile TestLoc;
	if (TargetLocations.Length == 1)
	{
		if (bRestrictToSquadsightRange)
		{
			TestLoc = `XWORLD.GetTileCoordinatesFromPosition(TargetLocations[0]);
			if (!class'X2TacticalVisibilityHelpers'.static.CanSquadSeeLocation(AssociatedPlayerState.ObjectID, TestLoc))
				return 'AA_NotVisible';
		}
		return 'AA_Success';
	}
	return 'AA_NoTargets';
}

function int GetTargetIndex()
{
	return 0;
}

function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
	Ability.GatherAdditionalAbilityTargetsForLocation(GetSplashRadiusCenter(), AdditionalTargets);
	return true;
}

function bool GetCurrentTargetFocus(out Vector Focus)
{
	Focus = GetSplashRadiusCenter();
	return true;
}

static function name GetProjectileTimingStyle()
{
	return '';
}

static function name GetOrdnanceType()
{
	return '';
}

defaultproperties
{
	SnapToTile = false;
}