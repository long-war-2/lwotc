class X2TargetingMethod_IRI_Nuke extends X2TargetingMethod_IRI_RocketLauncher;

//	Same as usual, except we also draw a second Splash Radius object, but smaller in scale - to show how far the Epicenter Damage would reach.

var protected transient XComEmitter ExplosionEmitterNuke;

function Init(AvailableAction InAction, int NewTargetIndex)
{
    super.Init(InAction, NewTargetIndex);

	ExplosionEmitterNuke = `BATTLE.spawn(class'XComEmitter');
	ExplosionEmitterNuke.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere", class'ParticleSystem')));		
	ExplosionEmitterNuke.LifeSpan = 60 * 60 * 24 * 7; // never die (or at least take a week to do so)
}

function Update(float DeltaTime)
{
    local XComWorldData World;
    local VoxelRaytraceCheckResult Raytrace;
    local array<Actor> CurrentlyMarkedTargets;
    local int Direction, CanSeeFromDefault;
    local UnitPeekSide PeekSide;
    local int OutRequiresLean;
    local TTile BlockedTile, PeekTile, UnitTile, SnapTile;
    local bool GoodView;
    local CachedCoverAndPeekData PeekData;
    local array<TTile> Tiles;
    local vector2d vMouseCursorPos;
    local float ExpectedScatter;
	local float MaximumScatter;
    local GameRulesCache_VisibilityInfo OutVisibilityInfo;
    local vector FiringLocation;

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	NewTargetLocation.Z = GetOptimalZForTile(NewTargetLocation);
	
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
            FiringUnit.GetDirectionInfoForPosition(NewTargetLocation, OutVisibilityInfo, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);

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
		DrawNukeRadius();	// DRAW NUKE INNER RADIUS
        DrawAOETiles(Tiles);
      
		vMouseCursorPos = LocalPlayer(`LOCALPLAYERCONTROLLER.Player).Project(NewTargetLocation);
		ScatterAmountText.SetPosition((vMouseCursorPos.X+1)*960 - 15, (1-vMouseCursorPos.Y)*540 + 50); // this follows cursor // 14 original value

		MaximumScatter = static.GetNumAimRolls(UnitState);
        ExpectedScatter = static.GetExpectedScatter(UnitState, NewTargetLocation);
        ScatterAmountText.SetHTMLText(class'UIUtilities_LW'.static.GetHTMLTilesText1() $ class'UIUtilities_LW'.static.GetHTMLAverageScatterValueText(ExpectedScatter) $ class'UIUtilities_LW'.static.GetHTMLMaximumScatterValueText(MaximumScatter) $ class'UIUtilities_LW'.static.GetHTMLTilesText2());
    }

    super(X2TargetingMethod_Grenade).UpdateTargetLocation(DeltaTime);
}

simulated protected function DrawNukeRadius()
{
	local Vector Center;
	local float Radius;
	local LinearColor CylinderColor;

	Center = GetSplashRadiusCenter( true );

	Radius = Ability.GetAbilityRadius();

	CylinderColor = MakeLinearColor(1.0, 0.05, 0, 0.2);

	if( (ExplosionEmitterNuke != none) && (Center != ExplosionEmitterNuke.Location))
	{
		ExplosionEmitterNuke.SetLocation(Center); // Set initial location of emitter
		ExplosionEmitterNuke.SetDrawScale(Radius / (48.0f / class'X2Rocket_Nuke'.default.EPICENTER_RELATIVE_RADIUS));
		ExplosionEmitterNuke.SetRotation( rot(0,0,1) );

		if( !ExplosionEmitterNuke.ParticleSystemComponent.bIsActive )
		{
			ExplosionEmitterNuke.ParticleSystemComponent.ActivateSystem();			
		}

		ExplosionEmitterNuke.ParticleSystemComponent.SetMICVectorParameter(0, Name("RadiusColor"), CylinderColor);
		ExplosionEmitterNuke.ParticleSystemComponent.SetMICVectorParameter(1, Name("RadiusColor"), CylinderColor);
	}
}

function Canceled()
{
    super.Canceled();

	ExplosionEmitterNuke.Destroy();
}