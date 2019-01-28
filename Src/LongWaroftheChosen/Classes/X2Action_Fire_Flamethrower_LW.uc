//---------------------------------------------------------------------------------------
//  FILE:    X2Action_Fire_Flamethrower_LW.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Custom action method tweaked for technical flamethrower
//			 - 
//---------------------------------------------------------------------------------------
class X2Action_Fire_Flamethrower_LW extends X2Action_Fire_Flamethrower config(GameCore);

var protected bool beginAimingAnim_LW; //need to know when aiming has occurred and is finished
var protected bool endAimingAnim_LW;

var private float currDuration_LW;

var private float CurrentFlameLength_LW;
var private float TargetFlameLength_LW;
var private bool bWaitingToFire_LW;

var private array<StateObjectReference> alreadySignaledTracks_LW;

var private float AimZOffset_LW;

function bool FindTrack(StateObjectReference find)
{
	local int i;
	for (i = 0; i < alreadySignaledTracks_LW.Length; i++)
	{
		if (find == alreadySignaledTracks_LW[i])
		{
			return true;
		}
	}

	return false;
}

function bool FindTile(TTile tile, out array<TTile> findArray)
{
	local TTile iter;
	foreach findArray(iter)
	{
		if (iter == tile)
		{
			return true;
		}
	}

	return false;
}

function bool FindSameXYTile(TTile tile, out array<TTile> findArray)
{
	local TTile iter;
	foreach findArray(iter)
	{
		if (iter.X == tile.X && iter.Y == tile.Y)
		{
			return true;
		}
	}

	return false;
}


function Init()
{
	local Vector TempDir;
	local XComWorldData WorldData;
	local vector ShootAtLocation;

	super(X2Action_Fire).Init();
	
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	
	if (ClassIsChildOf(AbilityState.GetMyTemplate().TargetingMethod, class'X2TargetingMethod_Cone'))
	{
		coneTemplate = X2AbilityMultiTarget_Cone(AbilityState.GetMyTemplate().AbilityMultiTargetStyle);

		ConeLength = coneTemplate.GetConeLength(AbilityState);
		ConeWidth = coneTemplate.GetConeEndDiameter(AbilityState) * 1.35;

		StartLocation = UnitPawn.Location;
		EndLocation = AbilityContext.InputContext.TargetLocations[0];
		
		// Update Z
		WorldData = `XWORLD;
		ShootAtLocation = Unit.GetShootAtLocation(eHit_Success, Unit.GetVisualizedStateReference());
		AimZOffset_LW = ShootAtLocation.Z - WorldData.GetFloorZForPosition(Unit.Location, true);
		EndLocation.Z = WorldData.GetFloorZForPosition(EndLocation, true) + AimZOffset_LW;
		StartLocation.Z = EndLocation.Z;

		ConeDir = EndLocation - StartLocation;
		UnitDir = Normal(ConeDir);

		ConeAngle = ConeWidth / ConeLength;

		ArcDelta = ConeAngle / SweepDuration;

		TempDir.x = UnitDir.x * cos(-ConeAngle / 2) - UnitDir.y * sin(-ConeAngle / 2);
		TempDir.y = UnitDir.x * sin(-ConeAngle / 2) + UnitDir.y * cos(-ConeAngle / 2);
		TempDir.z = UnitDir.z;

		SweepEndLocation_Begin = StartLocation + (TempDir * ConeLength);

		TempDir.x = UnitDir.x * cos(ConeAngle / 2) - UnitDir.y * sin(ConeAngle / 2);
		TempDir.y = UnitDir.x * sin(ConeAngle / 2) + UnitDir.y * cos(ConeAngle / 2);
		TempDir.z = UnitDir.z;

		SweepEndLocation_End = StartLocation + (TempDir * ConeLength);

		SecondaryTiles = AbilityContext.InputContext.VisibleNeighborTiles;
	}

	currDuration_LW = 0.0;
	beginAimingAnim_LW = false;
	endAimingAnim_LW = false;

	CurrentFlameLength_LW = -1.0;
	TargetFlameLength_LW = -1.0;
}

function AddProjectileVolley(X2UnifiedProjectile NewProjectile)
{
	bWaitingToFire_LW = false;
}

simulated state Executing
{
	simulated event Tick(float fDeltaT)
	{
		UpdateAim(fDeltaT);
	}

	simulated function UpdateAim(float DT)
	{
		local ParticleSystemComponent p;
		local int i;
		local float angle;
		local Vector TempDir, lineEndLoc;
		local float length;
		local TTile tile, tempTile;
		local TTile iterTile;
		local XComGameState_Unit targetObject;

		local array<TTile> cornerTiles;

		local StateObjectReference Target;
		local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
		local XComGameState_InteractiveObject InteractiveObject;
		local XComGameState_WorldEffectTileData WorldEffectTileData;
		local array<X2Action> worldEffectFireActionArray;
		local X2Action_UpdateWorldEffects_Fire worldEffectFireAction;
		local X2Action_ApplyWeaponDamageToTerrain terrainDamage;
		local Vector SetParticleVector;

		local array<TTile> lineTiles;
	
		local vector HitNormal;
		local Actor HitActor;
 
		local XComGameStateVisualizationMgr VisMgr;

		VisMgr = `XCOMVISUALIZATIONMGR;

		//find endlocation of target arc
		angle = ArcDelta * currDuration_LW;
		angle = angle - (ConeAngle / 2);

		TempDir.x = UnitDir.x * cos(angle) - UnitDir.y * sin(angle);
		TempDir.y = UnitDir.x * sin(angle) + UnitDir.y * cos(angle);
		TempDir.z = UnitDir.z;

		EndLocation = StartLocation + (TempDir * ConeLength);

		//Modify EndLocation based on any hits against the world
		`XWORLD.WorldTrace(StartLocation, EndLocation, EndLocation, HitNormal, HitActor, 4);
		
		//`SHAPEMGR.DrawLine(StartLocation, EndLocation, 6, MakeLinearColor(1.0f, 0.5f, 0.5f, 0.7f));
		//`SHAPEMGR.DrawLine(StartLocation, SweepEndLocation_Begin, 6, MakeLinearColor(0.0f, 0.0f, 1.0f, 1.0f));
		//`SHAPEMGR.DrawLine(StartLocation, SweepEndLocation_End, 6, MakeLinearColor(1.0f, 1.0f, 0.0f, 1.0f));
		//`SHAPEMGR.DrawSphere(EndLocation, Vect(10, 10, 10), MakeLinearColor(0.0f, 1.0f, 0.0f, 1.0f));

		if (UnitPawn.AimEnabled)
		{
			if (!beginAimingAnim_LW)
			{
				beginAimingAnim_LW = true;
			}

			tile = `XWORLD.GetTileCoordinatesFromPosition(EndLocation);

			//find all the tiles in the current line of fire
			tempTile = tile;
			//tempTile.Z = 0;
			lineTiles.AddItem(tempTile);
			lineEndLoc = EndLocation;
			while (VSize(lineEndLoc - StartLocation) > class'XComWorldData'.const.WORLD_StepSize)
			{
				lineEndLoc -= (TempDir * class'XComWorldData'.const.WORLD_HalfStepSize);
				tempTile = `XWORLD.GetTileCoordinatesFromPosition(lineEndLoc);
				//tempTile.Z = 0;
				if (FindTile(tempTile, lineTiles) == false)
				{
					lineTiles.AddItem(tempTile);
				}
			}

			//find all the possible secondarytiles to the line of fire
			cornerTiles.length = 0;
			foreach lineTiles(iterTile)
			{
				tempTile = iterTile;
				tempTile.X += 1;
				if (FindTile(tempTile, SecondaryTiles))
				{
					cornerTiles.AddItem(tempTile);
					SecondaryTiles.RemoveItem(tempTile);
				}

				tempTile = iterTile;
				tempTile.X -= 1;
				if (FindTile(tempTile, SecondaryTiles))
				{
					cornerTiles.AddItem(tempTile);
					SecondaryTiles.RemoveItem(tempTile);
				}

				tempTile = iterTile;
				tempTile.Y += 1;
				if (FindTile(tempTile, SecondaryTiles))
				{
					cornerTiles.AddItem(tempTile);
					SecondaryTiles.RemoveItem(tempTile);
				}

				tempTile = iterTile;
				tempTile.Y -= 1;
				if (FindTile(tempTile, SecondaryTiles))
				{
					cornerTiles.AddItem(tempTile);
					SecondaryTiles.RemoveItem(tempTile);
				}
			}

			//blend aim anim
			//`log("Endlocation " @ EndLocation @ " angle : " @ angle @ " ConeAngle: " @ ConeAngle );
			UnitPawn.TargetLoc = EndLocation;

//          `SHAPEMGR.DrawSphere(UnitPawn.TargetLoc, vect(15, 15, 15), MakeLinearColor(0, 1, 0, 1), true);
//          `SHAPEMGR.DrawLine(StartLocation, EndLocation, 6, MakeLinearColor(1.0f, 0.5f, 0.5f, 0.7f));
		}

		if( beginAimingAnim_LW && !UnitPawn.AimEnabled && !bWaitingToFire_LW )
		{
			endAimingAnim_LW = true;
		}

		//foreach AbilityContext.InputContext.VisibleTargetedTiles(iterTile)
		//{
		//	//iterTile.Z = 92;
		//	`SHAPEMGR.DrawTile(iterTile, 0, 255, 0);
		//}
		//foreach AbilityContext.InputContext.VisibleNeighborTiles(iterTile)
		//{
		//	iterTile.Z = 92;
		//	`SHAPEMGR.DrawTile(iterTile, 0, 0, 255);
		//}
		//foreach CornerTiles(iterTile)
		//{
		//	iterTile.Z = 92;
		//	`SHAPEMGR.DrawTile(iterTile, 0, 0, 255);
		//}
		//foreach lineTiles(iterTile)
		//{
		//	//iterTile.Z = 92;
		//	`SHAPEMGR.DrawTile(iterTile, 0, 0, 5, 0.8 );
		//}

		length = VSize(EndLocation - StartLocation);

		TargetFlameLength_LW = length;

		if (CurrentFlameLength_LW == -1.0)
		{
			CurrentFlameLength_LW = length;
		}
		else
		{
			if (CurrentFlameLength_LW < TargetFlameLength_LW)
			{
				CurrentFlameLength_LW = Min(TargetFlameLength_LW, CurrentFlameLength_LW + (LengthUpdateSpeed / DT));

			}
			else if (CurrentFlameLength_LW > TargetFlameLength_LW)
			{
				CurrentFlameLength_LW = Max(TargetFlameLength_LW, CurrentFlameLength_LW - (LengthUpdateSpeed / DT));
			}
		}


		SetParticleVector.X = CurrentFlameLength_LW;
		SetParticleVector.Y = CurrentFlameLength_LW;
		SetParticleVector.Z = CurrentFlameLength_LW;

		foreach UnitPawn.AllOwnedComponents(class'ParticleSystemComponent', p)
		{
			if( ParticleSystemsForLength.Find(p.Template.Name) != INDEX_NONE )
			{
				p.SetFloatParameter('Flamethrower_Length', CurrentFlameLength_LW);
				p.SetVectorParameter('Flamethrower_Length', SetParticleVector);
			}
		}
		
		//Force the "impact" of the flame to have a delay so that the jet has time to spread out visibly before we apply damage
		if (currDuration_LW >= (SweepDuration * 0.35f))
		{
			//send intertract updates if the tiles are in line
			foreach AbilityContext.InputContext.MultiTargets(Target)
			{
				targetObject = XComGameState_Unit(History.GetGameStateForObjectID(Target.ObjectID));
				if (FindSameXYTile(targetObject.TileLocation, lineTiles) && (!FindTrack(Target)) )
				{
					`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', targetObject, self);
					alreadySignaledTracks_LW.AddItem(Target);
				}
			}

			VisMgr.GetNodesOfType(VisMgr.VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', worldEffectFireActionArray);

			foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
			{
				Target = EnvironmentDamageEvent.GetReference();
				if (!FindTrack(Target))
				{
					`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamageEvent, self);
					alreadySignaledTracks_LW.AddItem(Target);
				}

				for (i = 0; i < worldEffectFireActionArray.length; i++)
				{
					terrainDamage = X2Action_ApplyWeaponDamageToTerrain(worldEffectFireActionArray[i]);
					if (terrainDamage != none && terrainDamage.Metadata.StateObject_NewState.ObjectID == EnvironmentDamageEvent.ObjectID)
					{
						if (!endAimingAnim_LW)
						{
							terrainDamage.DoPartialTileUpdate(lineTiles);
						}
						else
						{
							terrainDamage.FinishPartialTileUpdate();
						}
					}
				}
			}

			VisMgr.GetNodesOfType(VisMgr.VisualizationTree, class'X2Action_UpdateWorldEffects_Fire', worldEffectFireActionArray);

			foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
			{
				Target = InteractiveObject.GetReference();
				if (FindSameXYTile(InteractiveObject.TileLocation, lineTiles) && (!FindTrack(Target)))
				{
					`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', InteractiveObject, self);
					alreadySignaledTracks_LW.AddItem(Target);
				}
			}

			foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldEffectTileData)
			{
				Target = WorldEffectTileData.GetReference();
				if (worldEffectFireActionArray.length > 0 && beginAimingAnim_LW)
				{
					for (i = 0; i < worldEffectFireActionArray.length; i++)
					{
						worldEffectFireAction = X2Action_UpdateWorldEffects_Fire(worldEffectFireActionArray[i]);
						if (worldEffectFireAction != none && worldEffectFireAction.Metadata.StateObject_NewState.ObjectID == WorldEffectTileData.ObjectID)
						{
							if (!endAimingAnim_LW)
							{
								if (!FindTrack(Target))
								{
									worldEffectFireAction.BeginSyncWithOtherAction();
									`XEVENTMGR.TriggerEvent('Visualizer_TileData', WorldEffectTileData, self);
									alreadySignaledTracks_LW.AddItem(Target);
								}

								worldEffectFireAction.SetActiveTiles(lineTiles);
							}
							else
							{
								worldEffectFireAction.EndSyncWithOtherAction();
							}
						}
					}
				}

			}

			//play the secondarytile effects
			if (cornerTiles.length > 0)
			{
				foreach cornerTiles(iterTile)
				{
					WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem(DynamicLoadObject(SecondaryFire_ParticleEffectPath, class'ParticleSystem')), `XWORLD.GetPositionFromTileCoordinates(iterTile));
					//`SHAPEMGR.DrawTile(iterTile, 155, 0, 250, 0.6);
				}
			}
		}

		if( !bWaitingToFire_LW )
		{
			//update tick
			currDuration_LW += DT;
		}

		if (endAimingAnim_LW && currDuration_LW >= SweepDuration)
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
	TimeoutSeconds = 10.0f; //Should eventually be an estimate of how long we will run
	bNotifyMultiTargetsAtOnce = true
	bWaitingToFire_LW = true;	
}
