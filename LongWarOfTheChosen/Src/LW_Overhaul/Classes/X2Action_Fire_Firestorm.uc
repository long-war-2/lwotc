//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Fire_Firestorm extends X2Action_Fire_Flamethrower_LW;

var protected X2AbilityMultiTarget_Radius RadiusMultiTarget;
var protected float         Radius;
var protected bool          bInitUpdateAim;

var protected Rotator       PawnStartRotation;

function Init()
{
    super(X2Action_Fire).Init();

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

    RadiusMultiTarget = X2AbilityMultiTarget_Radius(AbilityState.GetMyTemplate().AbilityMultiTargetStyle);
    if (RadiusMultiTarget != none)
    {
        Radius = RadiusMultiTarget.GetTargetRadius(AbilityState);

        StartLocation = UnitPawn.Location;

        UnitDir = Normal(Vector(UnitPawn.Rotation));
        PawnStartRotation = UnitPawn.Rotation;

        EndLocation = StartLocation + (UnitDir * Radius);

        ConeAngle = PI;
        ArcDelta = ConeAngle / SweepDuration;
        `LOG("ArcDelta = " $ ArcDelta, default.bLog, default.Class.Name);

        SecondaryTiles = AbilityContext.InputContext.VisibleNeighborTiles;
    }

    CurrentDuration = 0.0;
    BeginAimingAnim2 = false;
    EndAimingAnim2 = false;

    CurrentFlameLength2 = -1.0;
    TargetFlameLength2 = -1.0;

    bInitUpdateAim = false;
}

simulated state Executing
{
    simulated event Tick(float fDeltaT)
    {
        UpdateAim(fDeltaT);
    }

    simulated function UpdateAim(float DT)
    {
        local XComWorldData                     WorldData;
        local XComGameStateVisualizationMgr     VisMgr;
        local float                             UnitAngle, AimAngle;
        local Vector                            TempDir;
        local Rotator                           FacingRotation;

        local Vector                            HitNormal;
        local Actor                             HitActor;

        local TTile                             Tile, TempTile, IterTile;
        local Vector                            LineEndLoc;
        local array<TTile>                      LineTiles, CornerTiles;

        local float                             LineLength;
        local Vector                            SetParticleVector;
        local ParticleSystemComponent           p;

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

        // Find EndLocation of the target arc
        UnitAngle = ArcDelta * CurrentDuration;
        AimAngle = 2 * UnitAngle - (ConeAngle / 2);

        TempDir.X = UnitDir.X * cos(AimAngle) - UnitDir.Y * sin(AimAngle);
        TempDir.Y = UnitDir.X * sin(AimAngle) + UnitDir.Y * cos(AimAngle);
        TempDir.Z = UnitDir.Z;

        FacingRotation.Yaw = UnitAngle * RadToUnrRot;

        EndLocation = StartLocation + (TempDir * Radius);

        `LOG("=====================================================================", default.bLog, default.Class.Name);
        `LOG("CurrentDuration = " $ CurrentDuration, default.bLog, default.Class.Name);
        `LOG("StartLocation = " $ StartLocation, default.bLog, default.Class.Name);
        `LOG("EndLocation = " $ EndLocation, default.bLog, default.Class.Name);
        `LOG("LocationDelta = " $ (TempDir * Radius), default.bLog, default.Class.Name);
        `LOG("UnitAngle = " $ UnitAngle, default.bLog, default.Class.Name);
        `LOG("AimAngle = " $ AimAngle, default.bLog, default.Class.Name);
        `LOG("TempDir = " $ TempDir, default.bLog, default.Class.Name);
        `LOG("UnitPawn.Rotation = " $ UnitPawn.Rotation, default.bLog, default.Class.Name);
        `LOG("FacingRotation.Yaw = " $ FacingRotation.Yaw, default.bLog, default.Class.Name);
        `LOG("---------------------------------------------------------------------", default.bLog, default.Class.Name);

        WorldData.WorldTrace(StartLocation, EndLocation, EndLocation, HitNormal, HitActor, 4);

        if (UnitPawn.AimEnabled)
        {
            if (!BeginAimingAnim2)
            {
                BeginAimingAnim2 = true;
            }
            Tile = WorldData.GetTileCoordinatesFromPosition(EndLocation);
            // Find all the tiles in the current line of fire
            TempTile = Tile;
            LineTiles.AddItem(tempTile);
            LineEndLoc = EndLocation;
            while (VSize(LineEndLoc - StartLocation) > class'XComWorldData'.const.WORLD_StepSize)
            {
                LineEndLoc -= (TempDir * class'XComWorldData'.const.WORLD_HalfStepSize);
                TempTile = WorldData.GetTileCoordinatesFromPosition(lineEndLoc);
                if (!FindTile(TempTile, LineTiles))
                {
                    LineTiles.AddItem(TempTile);
                }
            }

            // Find all the possible SecondaryTiles to the line of fire
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

            UnitPawn.SetRotation(PawnStartRotation + FacingRotation);
            UnitPawn.TargetLoc = EndLocation;
        }

        if (BeginAimingAnim2 && !UnitPawn.AimEnabled && !bWaitingToFire2)
        {
            EndAimingAnim2 = true;
        }

        // Update current flame length
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

        if (CurrentDuration >= (SweepDuration * 0.15f))
        {
            // Send intertract updates if the tiles are in line
            foreach AbilityContext.InputContext.MultiTargets(TargetRef)
            {
                TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
                if (TargetUnitState != none
                    && FindSameXYTile(TargetUnitState.TileLocation, LineTiles)
                    && !FindTrack(TargetRef))
                {
                    `XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', TargetUnitState, self);
                    SignaledTracks.AddItem(TargetRef);
                }
            }

            foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
            {
                TargetRef = EnvironmentDamageEvent.GetReference();
                if (!FindTrack(TargetRef))
                {
                    `XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamageEvent, self);
                    SignaledTracks.AddItem(TargetRef);
                }

                VisMgr.GetNodesOfType(VisMgr.VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', WorldEffectFireActionArray);
                for (i = 0; i < WorldEffectFireActionArray.length; i++)
                {
                    TerrainDamage = X2Action_ApplyWeaponDamageToTerrain(WorldEffectFireActionArray[i]);
                    if (TerrainDamage != none)
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
        }

        foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
        {
            TargetRef = InteractiveObject.GetReference();
            if (FindSameXYTile(InteractiveObject.TileLocation, LineTiles)
                && !FindTrack(TargetRef))
            {
                `XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', InteractiveObject, self);
                SignaledTracks.AddItem(TargetRef);
            }
        }

        if (BeginAimingAnim2)
        {
            foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldEffectTileData)
            {
                TargetRef = WorldEffectTileData.GetReference();
                VisMgr.GetNodesOfType(VisMgr.VisualizationTree, class'X2Action_UpdateWorldEffects_Fire', WorldEffectFireActionArray);
                for (i = 0; i < WorldEffectFireActionArray.length; i++)
                {
                    WorldEffectFireAction = X2Action_UpdateWorldEffects_Fire(WorldEffectFireActionArray[i]);
                    if (WorldEffectFireAction != none)
                    {
                        if (!EndAimingAnim2)
                        {
                            if (!FindTrack(TargetRef))
                            {
                                WorldEffectFireAction.BeginSyncWithOtherAction();
                                `XEVENTMGR.TriggerEvent('Visualizer_TileData', WorldEffectTileData, self);
                                SignaledTracks.AddItem(TargetRef);
                            }

                            WorldEffectFireAction.SetActiveTiles(lineTiles);
                        }
                        else
                        {
                            WorldEffectFireAction.EndSyncWithOtherAction();
                        }
                    }
                }
            }
        }

        // Play the effects for CornerTiles
        if (CornerTiles.Length > 0)
        {
            foreach CornerTiles(IterTile)
            {
                WorldInfo.MyEmitterPool.SpawnEmitter(
                    ParticleSystem(DynamicLoadObject(SecondaryFire_ParticleEffectPath, class'ParticleSystem')),
                    WorldData.GetPositionFromTileCoordinates(IterTile));
            }
        }

        if (!bWaitingToFire2)
        {
            // update tick
            CurrentDuration += DT;
        }

        if (EndAimingAnim2 && CurrentDuration >= SweepDuration)
        {
            CompleteAction();
        }
    }

Begin:
    Unit.IdleStateMachine.GoDormant();
    Unit.CurrentFireAction = self;
    UnitPawn.EnableRMA(true, true);
    UnitPawn.EnableRMAInteractPhysics(true);
    FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

    CompleteAction();
}

defaultproperties
{
    NotifyTargetTimer = 0.75f
    TimeoutSeconds = 20.0f
    bNotifyMultiTargetsAtOnce = true
    bWaitingToFire2 = true
}