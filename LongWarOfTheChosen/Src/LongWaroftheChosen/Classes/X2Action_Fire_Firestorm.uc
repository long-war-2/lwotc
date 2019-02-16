//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Fire_Firestorm extends X2Action_Fire_Flamethrower config(GameCore);

//var config string SecondaryFire_ParticleEffectPath;
//var config float LengthUpdateSpeed;
var config float FirestormSweepDuration;
//var config float FireChance_Level1, FireChance_Level2, FireChance_Level3;
//var config array<Name> ParticleSystemsForLength;

var X2AbilityMultiTarget_Radius radiusTemplate;
//var float ConeLength, ConeWidth;

//var Vector StartLocation, EndLocation;
//var Vector UnitDir, ConeDir;
//
//var Vector SweepEndLocation_Begin, SweepEndLocation_End;
//var float ArcDelta, ConeAngle;
//
//
var private bool beginAimingAnim_F; //need to know when aiming has occurred and is finished
var private bool endAimingAnim_F;

var private float currDuration_F;
//
//var XComGameState_Ability AbilityState;
//var array<TTile> SecondaryTiles;
//
var private float CurrentFlameLength_F;
var private float TargetFlameLength_F;
var private bool bWaitingToFire_F;

var private array<StateObjectReference> alreadySignaledTracks_F;

var private Rotator PawnStartRotation;

function bool FindTrack(StateObjectReference find)
{
	local int i;
	for (i = 0; i < alreadySignaledTracks_F.Length; i++)
	{
		if (find == alreadySignaledTracks_F[i])
		{
			return true;
		}
	}

	return false;
}


function Init()
{
	local Vector TempDir;

	super.Init();

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

	if (ClassIsChildOf(AbilityState.GetMyTemplate().TargetingMethod, class'X2TargetingMethod_Grenade'))
	{
		radiusTemplate = X2AbilityMultiTarget_Radius(AbilityState.GetMyTemplate().AbilityMultiTargetStyle);

		//ConeLength = radiusTemplate.GetConeLength(AbilityState);
		//ConeWidth = radiusTemplate.GetConeEndDiameter(AbilityState) * 1.35;
		ConeLength = radiusTemplate.GetTargetRadius(AbilityState) * 1.35;

		StartLocation = UnitPawn.Location;
		EndLocation = UnitPawn.Location;
		EndLocation.x += 1.0;
		//EndLocation = AbilityContext.InputContext.TargetLocations[0];
		

		ConeDir = EndLocation - StartLocation;
		UnitDir = Normal(vector(UnitPawn.Rotation));

		ConeAngle = PI; // * 2;

		ArcDelta = ConeAngle / FirestormSweepDuration;

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

	PawnStartRotation = UnitPawn.Rotation;

	currDuration_F = 0.0;
	beginAimingAnim_F = false;
	endAimingAnim_F = false;

	CurrentFlameLength_F = -1.0;
	TargetFlameLength_F = -1.0;
}

function AddProjectileVolley(X2UnifiedProjectile NewProjectile)
{
	bWaitingToFire_F = false;
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
		local float aimAngle, unitAngle;
		local Vector TempDir, lineEndLoc;
		local Rotator Facing;
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
		unitAngle = ArcDelta * currDuration_F;
		aimAngle = 2 * unitAngle - (ConeAngle / 2);

		TempDir.x = UnitDir.x * cos(aimAngle) - UnitDir.y * sin(aimAngle);
		TempDir.y = UnitDir.x * sin(aimAngle) + UnitDir.y * cos(aimAngle);
		TempDir.z = UnitDir.z;

		Facing.Yaw = unitAngle * RadToUnrRot;

		EndLocation = StartLocation + (TempDir * ConeLength);

		//Modify EndLocation based on any hits against the world
		`XWORLD.WorldTrace(StartLocation, EndLocation, EndLocation, HitNormal, HitActor, 4);
		
		//`SHAPEMGR.DrawLine(StartLocation, EndLocation, 6, MakeLinearColor(1.0f, 0.5f, 0.5f, 0.7f));
		//`SHAPEMGR.DrawLine(StartLocation, SweepEndLocation_Begin, 6, MakeLinearColor(0.0f, 0.0f, 1.0f, 1.0f));
		//`SHAPEMGR.DrawLine(StartLocation, SweepEndLocation_End, 6, MakeLinearColor(1.0f, 1.0f, 0.0f, 1.0f));
		//`SHAPEMGR.DrawSphere(EndLocation, Vect(10, 10, 10), MakeLinearColor(0.0f, 1.0f, 0.0f, 1.0f));

		if (UnitPawn.AimEnabled)
		{
			if (!beginAimingAnim_F)
			{
				beginAimingAnim_F = true;
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
			`log("Endlocation " @ EndLocation @ " aimAngle : " @ aimAngle @ " unitAngle : " @ unitAngle @ " currDuration : " @ currDuration_F @ " DT : " @ DT );
			UnitPawn.SetRotation(PawnStartRotation + Facing);
			UnitPawn.TargetLoc = EndLocation;

		}

		if( beginAimingAnim_F && !UnitPawn.AimEnabled && !bWaitingToFire_F )
		{
			endAimingAnim_F = true;
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

		TargetFlameLength_F = length;

		if (CurrentFlameLength_F == -1.0)
		{
			CurrentFlameLength_F = length;
		}
		else
		{
			if (CurrentFlameLength_F < TargetFlameLength_F)
			{
				CurrentFlameLength_F = Min(TargetFlameLength_F, CurrentFlameLength_F + (LengthUpdateSpeed / DT));

			}
			else if (CurrentFlameLength_F > TargetFlameLength_F)
			{
				CurrentFlameLength_F = Max(TargetFlameLength_F, CurrentFlameLength_F - (LengthUpdateSpeed / DT));
			}
		}


		SetParticleVector.X = CurrentFlameLength_F;
		SetParticleVector.Y = CurrentFlameLength_F;
		SetParticleVector.Z = CurrentFlameLength_F;

		foreach UnitPawn.AllOwnedComponents(class'ParticleSystemComponent', p)
		{
			if( ParticleSystemsForLength.Find(p.Template.Name) != INDEX_NONE )
			{
				p.SetFloatParameter('Flamethrower_Length', CurrentFlameLength_F);
				p.SetVectorParameter('Flamethrower_Length', SetParticleVector);
			}
		}


		//send intertract updates if the tiles are in line
		foreach AbilityContext.InputContext.MultiTargets(Target)
		{
			targetObject = XComGameState_Unit(History.GetGameStateForObjectID(Target.ObjectID));
			if (targetObject != none && FindSameXYTile(targetObject.TileLocation, lineTiles) && (!FindTrack(Target)) )
			{
				`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', targetObject, self);
				alreadySignaledTracks_F.AddItem(Target);
			}
		}

		foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
		{
				Target = EnvironmentDamageEvent.GetReference();
				if (!FindTrack(Target))
				{
					`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamageEvent, self);
					alreadySignaledTracks_F.AddItem(Target);
				}

				VisMgr.GetNodesOfType(VisMgr.VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', worldEffectFireActionArray);
				for (i = 0; i < worldEffectFireActionArray.length; i++)
				{
					terrainDamage = X2Action_ApplyWeaponDamageToTerrain(worldEffectFireActionArray[i]);
					if (terrainDamage != none)
					{
						if (!endAimingAnim_F)
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

		foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
		{
			Target = InteractiveObject.GetReference();
			if (FindSameXYTile(InteractiveObject.TileLocation, lineTiles) && (!FindTrack(Target)))
			{
				`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', InteractiveObject, self);
				alreadySignaledTracks_F.AddItem(Target);
			}
		}

		foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldEffectTileData)
		{
			Target = WorldEffectTileData.GetReference();
			VisMgr.GetNodesOfType(VisMgr.VisualizationTree, class'X2Action_UpdateWorldEffects_Fire', worldEffectFireActionArray);
			if (worldEffectFireActionArray.length > 0 && beginAimingAnim_F)
			{
				for (i = 0; i < worldEffectFireActionArray.length; i++)
				{
					worldEffectFireAction = X2Action_UpdateWorldEffects_Fire(worldEffectFireActionArray[i]);
					if (worldEffectFireAction != none)
					{
						if (!endAimingAnim_F)
						{
							if (!FindTrack(Target))
							{
								worldEffectFireAction.BeginSyncWithOtherAction();
								`XEVENTMGR.TriggerEvent('Visualizer_TileData', WorldEffectTileData, self);
								alreadySignaledTracks_F.AddItem(Target);
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

		if( !bWaitingToFire_F )
		{
			//update tick
			currDuration_F += DT;
		}

		if (endAimingAnim_F && currDuration_F >= FirestormSweepDuration)
		{
			CompleteAction();
		}
	}

Begin:
	//if (XGUnit(PrimaryTarget).GetTeam() == eTeam_Neutral)
	//{
		//FOWViewer = `XWORLD.CreateFOWViewer(XGUnit(PrimaryTarget).GetPawn().Location, class'XComWorldData'.const.WORLD_StepSize * 3);
//
		//XGUnit(PrimaryTarget).SetForceVisibility(eForceVisible);
		//XGUnit(PrimaryTarget).GetPawn().UpdatePawnVisibility();
//
		//// Sleep long enough for the fog to be revealed
		//Sleep(1.0f * GetDelayModifier());
	//}

	Unit.CurrentFireAction = self;
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));
	
	CompleteAction();
}

DefaultProperties
{
	//NotifyTargetTimer = 0.75;
	TimeoutSeconds = 20.0f; //Should eventually be an estimate of how long we will run
	//bNotifyMultiTargetsAtOnce = true
	bWaitingToFire_F = true;	
}
