//---------------------------------------------------------------------------------------
//  FILE:    X2Action_Fire_Flamethrower.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Action animation data for the Gauntlet's Flamethrower ability
//---------------------------------------------------------------------------------------

//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Fire_Flamethrower_LW extends X2Action_Fire_Flamethrower;

var config bool bLog;

// Every time I see private vars in the action classes, a piece of me dies
var protected bool      BeginAimingAnim2;
var protected bool      EndAimingAnim2;

var protected float     CurrentDuration;

var protected float     CurrentFlameLength2;
var protected float     TargetFlameLength2;
var protected bool      bWaitingToFire2;

var protected array<StateObjectReference> SignaledTracks;

function bool FindTrack(StateObjectReference TargetRef)
{
    return SignaledTracks.Find('ObjectID', TargetRef.ObjectID) != INDEX_NONE;
}

function Init()
{
    local XComWorldData WorldData;
    local Vector ShootAtLocation;
    local float AimZOffset2;

    super(X2Action_Fire).Init();

    WorldData = `XWORLD;

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

    ConeTemplate = X2AbilityMultiTarget_Cone(AbilityState.GetMyTemplate().AbilityMultiTargetStyle);
    if (ConeTemplate != none)
    {
        ConeLength = ConeTemplate.GetConeLength(AbilityState);
        ConeWidth = ConeTemplate.GetConeEndDiameter(AbilityState) * 1.35;

        StartLocation = UnitPawn.Location;

        EndLocation = AbilityContext.InputContext.TargetLocations[0];

        // Update Z
        ShootAtLocation = Unit.GetShootAtLocation(eHit_Success, Unit.GetVisualizedStateReference());
        AimZOffset2 = ShootAtLocation.Z - WorldData.GetFloorZForPosition(Unit.Location, true);
        EndLocation.Z = WorldData.GetFloorZForPosition(EndLocation, true) + AimZOffset2;

        StartLocation.Z = EndLocation.Z;

        ConeDir = EndLocation - StartLocation;
        UnitDir = Normal(ConeDir);

        ConeAngle = ConeWidth / ConeLength;
        `LOG("ConeAngle = " $ ConeAngle, default.bLog, default.Class.Name);
        ArcDelta = ConeAngle / SweepDuration;
        `LOG("ArcDelta = " $ ArcDelta, default.bLog, default.Class.Name);

        SecondaryTiles = AbilityContext.InputContext.VisibleNeighborTiles;
    }

    CurrentDuration = 0.0;
    BeginAimingAnim2 = false;
    EndAimingAnim2 = false;

    CurrentFlameLength2 = -1.0;
    TargetFlameLength2 = -1.0;
}

function AddProjectileVolley(X2UnifiedProjectile NewProjectile)
{
    bWaitingToFire2 = false;
}

simulated state Executing
{
    simulated event Tick(float fDeltaT)
    {
        UpdateAim(fDeltaT);
    }

    simulated function UpdateAim(float DT)
    {
        local XComWorldData     WorldData;
        local XComGameStateVisualizationMgr VisMgr;
        local float             AimAngle;
        local Vector            TempDir;

        local Vector            HitNormal;
        local Actor             HitActor;

        local TTile             Tile, TempTile, IterTile;
        local Vector            LineEndLoc;
        local array<TTile>      LineTiles, CornerTiles;

        local float                     LineLength;
        local Vector                    SetParticleVector;
        local ParticleSystemComponent   p;

        local StateObjectReference                  TargetRef;
        local XComGameState_Unit                    TargetUnitState;
        local XComGameState_EnvironmentDamage       EnvironmentDamageEvent;
        local XComGameState_InteractiveObject       InteractiveObject;
        local XComGameState_WorldEffectTileData     WorldEffectTileData;
        local array<X2Action>                       WorldEffectFireActionArray;
        local X2Action_UpdateWorldEffects_Fire      WorldEffectFireAction;
        local X2Action_ApplyWeaponDamageToTerrain   TerrainDamage;

        local int i;

        WorldData = `XWORLD;
        VisMgr = `XCOMVISUALIZATIONMGR;

        AimAngle = ArcDelta * CurrentDuration;
        AimAngle = AimAngle - (ConeAngle / 2);

        TempDir.X = UnitDir.X * cos(AimAngle) - UnitDir.Y * sin(AimAngle);
        TempDir.Y = UnitDir.X * sin(AimAngle) + UnitDir.Y * cos(AimAngle);
        TempDir.Z = UnitDir.Z;

        EndLocation = StartLocation + (TempDir * ConeLength);

        WorldData.WorldTrace(StartLocation, EndLocation, EndLocation, HitNormal, HitActor, 4);

        if (UnitPawn.AimEnabled)
        {
            if (!BeginAimingAnim2)
            {
                BeginAimingAnim2 = true;
            }

            Tile = WorldData.GetTileCoordinatesFromPosition(EndLocation);
            TempTile = Tile;
            LineTiles.AddItem(TempTile);
            LineEndLoc = EndLocation;
            while (VSize(LineEndLoc - StartLocation) > class'XComWorldData'.const.WORLD_StepSize)
            {
                LineEndLoc -= (TempDir * class'XComWorldData'.const.WORLD_HalfStepSize);
                TempTile = WorldData.GetTileCoordinatesFromPosition(LineEndLoc);
                if (!FindTile(TempTile, LineTiles))
                {
                    LineTiles.AddItem(TempTile);
                }
            }

            CornerTiles.Length = 0;
            foreach LineTiles(IterTile)
            {
                TempTile = IterTile;
                TempTile.X += 1;
                if (FindTile(TempTile, SecondaryTiles))
                {
                    CornerTiles.AddItem(TempTile);
                    SecondaryTiles.RemoveItem(TempTile);
                }

                TempTile = IterTile;
                TempTile.X -= 1;
                if (FindTile(TempTile, SecondaryTiles))
                {
                    CornerTiles.AddItem(TempTile);
                    SecondaryTiles.RemoveItem(TempTile);
                }

                TempTile = IterTile;
                TempTile.Y += 1;
                if (FindTile(TempTile, SecondaryTiles))
                {
                    CornerTiles.AddItem(TempTile);
                    SecondaryTiles.RemoveItem(TempTile);
                }

                TempTile = IterTile;
                TempTile.Y -= 1;
                if (FindTile(TempTile, SecondaryTiles))
                {
                    CornerTiles.AddItem(TempTile);
                    SecondaryTiles.RemoveItem(TempTile);
                }
            }

            UnitPawn.TargetLoc = EndLocation;
        }

        if (BeginAimingAnim2 && !UnitPawn.AimEnabled && !bWaitingToFire2)
        {
            EndAimingAnim2 = true;
        }

        LineLength = VSize(EndLocation - StartLocation);

        TargetFlameLength2 = LineLength;

        if (CurrentFlameLength2 == -1.0)
        {
            CurrentFlameLength2 = LineLength;
        }
        else
        {
            if (CurrentFlameLength2 < TargetFlameLength2)
            {
                CurrentFlameLength2 = Min(TargetFlameLength2, CurrentFlameLength2 + (LengthUpdateSpeed / DT));
            }
            else if (CurrentFlameLength2 > TargetFlameLength2)
            {
                CurrentFlameLength2 = Max(TargetFlameLength2, CurrentFlameLength2 - (LengthUpdateSpeed / DT));
            }
        }

        SetParticleVector.X = CurrentFlameLength2;
        SetParticleVector.Y = CurrentFlameLength2;
        SetParticleVector.Z = CurrentFlameLength2;

        foreach UnitPawn.AllOwnedComponents(class'ParticleSystemComponent', p)
        {
            if (ParticleSystemsForLength.Find(p.Template.Name) != INDEX_NONE)
            {
                p.SetFloatParameter('Flamethrower_Length', CurrentFlameLength2);
                p.SetVectorParameter('Flamethrower_Length', SetParticleVector);
            }
        }

        //Force the "impact" of the flame to have a delay so that the jet has time to spread out visibly before we apply damage
        if (CurrentDuration >= (SweepDuration * 0.35f))
        {
            //send intertract updates if the tiles are in line
            foreach AbilityContext.InputContext.MultiTargets(TargetRef)
            {
                TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
                if (FindSameXYTile(TargetUnitState.TileLocation, LineTiles) && (!FindTrack(TargetRef)))
                {
                    `XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', TargetUnitState, self);
                    SignaledTracks.AddItem(TargetRef);
                }
            }

            VisMgr.GetNodesOfType(VisMgr.VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', WorldEffectFireActionArray);

            foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
            {
                TargetRef = EnvironmentDamageEvent.GetReference();
                if (!FindTrack(TargetRef))
                {
                    `XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamageEvent, self);
                    SignaledTracks.AddItem(TargetRef);
                }

                for (i = 0; i < WorldEffectFireActionArray.Length; i++)
                {
                    TerrainDamage = X2Action_ApplyWeaponDamageToTerrain(WorldEffectFireActionArray[i]);
                    if (TerrainDamage != none && TerrainDamage.Metadata.StateObject_NewState.ObjectID == EnvironmentDamageEvent.ObjectID)
                    {
                        if (!EndAimingAnim2)
                        {
                            TerrainDamage.DoPartialTileUpdate(LineTiles);
                        }
                        else
                        {
                            TerrainDamage.FinishPartialTileUpdate();
                        }
                    }
                }
            }

            foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
            {
                TargetRef = InteractiveObject.GetReference();
                if (FindSameXYTile(InteractiveObject.TileLocation, LineTiles) && !FindTrack(TargetRef))
                {
                    `XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', InteractiveObject, self);
                    SignaledTracks.AddItem(TargetRef);
                }
            }

            VisMgr.GetNodesOfType(VisMgr.VisualizationTree, class'X2Action_UpdateWorldEffects_Fire', WorldEffectFireActionArray);

            foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldEffectTileData)
            {
                TargetRef = WorldEffectTileData.GetReference();
                if (WorldEffectFireActionArray.Length > 0 && BeginAimingAnim2)
                {
                    for (i = 0; i < WorldEffectFireActionArray.Length; i++)
                    {
                        WorldEffectFireAction = X2Action_UpdateWorldEffects_Fire(WorldEffectFireActionArray[i]);
                        if (WorldEffectFireAction != none && WorldEffectFireAction.Metadata.StateObject_NewState.ObjectID == WorldEffectTileData.ObjectID)
                        {
                            if (!EndAimingAnim2)
                            {
                                if (!FindTrack(TargetRef))
                                {
                                    WorldEffectFireAction.BeginSyncWithOtherAction();
                                    `XEVENTMGR.TriggerEvent('Visualizer_TileData', WorldEffectTileData, self);
                                    SignaledTracks.AddItem(TargetRef);
                                }

                                WorldEffectFireAction.SetActiveTiles(LineTiles);
                            }
                            else
                            {
                                WorldEffectFireAction.EndSyncWithOtherAction();
                            }
                        }
                    }
                }

            }

            if (CornerTiles.Length > 0)
            {
                foreach CornerTiles(IterTile)
                {
                    WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem(DynamicLoadObject(SecondaryFire_ParticleEffectPath, class'ParticleSystem')), `XWORLD.GetPositionFromTileCoordinates(IterTile));
                }
            }
        }

        if (!bWaitingToFire2)
        {
            CurrentDuration += DT;
        }

        if (EndAimingAnim2 && CurrentDuration >= SweepDuration)
        {
            CompleteAction();
        }
    }

Begin:
    if (XGUnit(PrimaryTarget) != none && (XGUnit(PrimaryTarget).GetTeam() == eTeam_Neutral || XGUnit(PrimaryTarget).GetTeam() == eTeam_Resistance))
    {
        FOWViewer = `XWORLD.CreateFOWViewer(XGUnit(PrimaryTarget).GetPawn().Location, class'XComWorldData'.const.WORLD_StepSize * 3);

        XGUnit(PrimaryTarget).SetForceVisibility(eForceVisible);
        XGUnit(PrimaryTarget).GetPawn().UpdatePawnVisibility();

        // Sleep long enough for the fog to be revealed
        Sleep(1.0f * GetDelayModifier());
    }

    Unit.CurrentFireAction = self;
    UnitPawn.EnableRMA(true, true);
    UnitPawn.EnableRMAInteractPhysics(true);
    FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

    CompleteAction();
}

DefaultProperties
{
    NotifyTargetTimer = 0.75;
    TimeoutSeconds = 10.0f; // Should eventually be an estimate of how long we will run
    bNotifyMultiTargetsAtOnce = true
    bWaitingToFire2 = true;  
}