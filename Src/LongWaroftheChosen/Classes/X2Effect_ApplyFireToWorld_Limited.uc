class X2Effect_ApplyFireToWorld_Limited extends X2Effect_ApplyFireToWorld;

static simulated function SharedApplyFireToTiles( Name EffectName, X2Effect_ApplyFireToWorld FireEffect, XComGameState NewGameState, array<TilePosPair> OutTiles, XComGameState_Unit SourceStateObject, int ForceIntensity = -1, optional bool UseFireChance = false )
{
	local XComGameState_WorldEffectTileData FireTileUpdate, SmokeTileUpdate;
	local VolumeEffectTileData InitialFireTileData, InitialSmokeTileData;
	local array<VolumeEffectTileData> InitialFireTileDatas;
	local XComDestructibleActor PossibleFuel;
	local TilePosPair SmokeTile;
	local int Index, SmokeIndex, Intensity2;
	local array<TileIsland> TileIslands;
	local array<TileParticleInfo> FireTileParticleInfos;
	local float FireChanceTotal, FireLevelRand;
	local XComWorldData WorldData;
	local array<Actor> ActorsOnTile;
	local Actor CurrentActor;

	WorldData = `XWORLD;

	FireChanceTotal = FireEffect.FireChance_Level1 + FireEffect.FireChance_Level2 + FireEffect.FireChance_Level3;

	FireTileUpdate = XComGameState_WorldEffectTileData(NewGameState.CreateStateObject(class'XComGameState_WorldEffectTileData'));
	FireTileUpdate.WorldEffectClassName = EffectName;
	FireTileUpdate.PreSizeTileData( OutTiles.Length );

	SmokeTileUpdate = XComGameState_WorldEffectTileData(NewGameState.CreateStateObject(class'XComGameState_WorldEffectTileData'));
	SmokeTileUpdate.WorldEffectClassName = 'X2Effect_ApplySmokeToWorld';
	SmokeTileUpdate.PreSizeTileData( OutTiles.Length * 11 ); // conservative worst case estimate (sadly)

	for (Index = 0; Index < OutTiles.Length; ++Index)
	{
		InitialFireTileData.EffectName = EffectName;
		InitialSmokeTileData.EffectName = SmokeTileUpdate.WorldEffectClassName;
		InitialSmokeTileData.Intensity = -1; // no particle effects needed in this case.  The fire effect makes smoke for us.
		InitialSmokeTileData.DynamicFlagUpdateValue = class'X2Effect_ApplySmokeToWorld'.static.GetTileDataDynamicFlagValue();

		// Initial randomness factor
		if(ForceIntensity > -1)
		{
			InitialFireTileData.NumTurns = ForceIntensity;
		}
		else
		{
			InitialFireTileData.NumTurns = `SYNC_RAND_STATIC(2) + 1;
		}

		if (UseFireChance)
		{
			FireLevelRand = `SYNC_FRAND_STATIC();
			if (FireLevelRand > FireChanceTotal)
			{
				InitialFireTileData.NumTurns = 0;
			}
			else if(FireLevelRand > (FireEffect.FireChance_Level1 + FireEffect.FireChance_Level2))
			{
				InitialFireTileData.NumTurns = 3;
			}
			else if(FireLevelRand > FireEffect.FireChance_Level1)
			{
				InitialFireTileData.NumTurns = 2;
			}
			else
			{
				InitialFireTileData.NumTurns = 1;
			}
		}
		if (default.MAX_INTENSITY_2_TILES > 0)
		{
			if (Intensity2 > default.MAX_INTENSITY_2_TILES && InitialFireTileData.NumTurns > 1)
				InitialFireTileData.NumTurns = 1;
		}

		if (InitialFireTileData.NumTurns >= 2)
			Intensity2++;

		// Additional length/intensity when there's something to burn
		ActorsOnTile = `XWORLD.GetActorsOnTile( OutTiles[Index].Tile, true );
		foreach ActorsOnTile(CurrentActor)
		{
			PossibleFuel = XComDestructibleActor(CurrentActor);
			if ((PossibleFuel != none) && (PossibleFuel.Toughness != none))
			{
				InitialFireTileData.NumTurns += PossibleFuel.Toughness.AvailableFireFuelTurns;
			}
		}

		// cap to maximum effect intensity
		InitialFireTileData.Intensity = InitialFireTileData.NumTurns;

		InitialSmokeTileData.NumTurns = InitialFireTileData.NumTurns;
		SmokeTile = OutTiles[Index];

		// Create tile data smoke flags for some/all of the tiles in the fire's column.
		// The higher up we go the shorter it lasts (matching up with the effect).
		// And we should extend past the top of the level
		for (SmokeIndex = 0; (SmokeIndex < 11) && (SmokeTile.Tile.Z < WorldData.NumZ); ++SmokeIndex)
		{
			if ((SmokeIndex == 3) || (SmokeIndex == 4) || (SmokeIndex == 8))
			{
				if (--InitialSmokeTileData.NumTurns < 0)
				{
					break;
				}
			}

			SmokeTileUpdate.AddInitialTileData( SmokeTile, InitialSmokeTileData );
			SmokeTile.Tile.Z++;
		}

		InitialFireTileDatas.AddItem(InitialFireTileData);
	}

	TileIslands = CollapseTilesToPools(OutTiles, InitialFireTileDatas);
	DetermineFireBlocks(TileIslands, OutTiles, FireTileParticleInfos);

	for(Index = 0; Index < OutTiles.Length; ++Index)
	{
		FireTileUpdate.AddInitialTileData(OutTiles[Index], InitialFireTileDatas[Index], FireTileParticleInfos[Index]);
	}

	NewGameState.AddStateObject(FireTileUpdate);
	NewGameState.AddStateObject(SmokeTileUpdate);

	`XEVENTMGR.TriggerEvent( 'GameplayTileEffectUpdate', FireTileUpdate, SourceStateObject, NewGameState );
	`XEVENTMGR.TriggerEvent( 'GameplayTileEffectUpdate', SmokeTileUpdate, SourceStateObject, NewGameState );
}

simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityStateObject;
	local XComGameState_Unit SourceStateObject;
	local float AbilityRadius, AbilityCoverage;
	local XComWorldData WorldData;
	local vector TargetLocation;
	local array<TilePosPair> OutTiles;
	local array<TTile> AbilityTiles;
	local TilePosPair OutPair;
	local int i;

	//If this damage effect has an associated position, it does world damage
	if( ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0 )
	{
		History = `XCOMHISTORY;
		SourceStateObject = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		AbilityStateObject = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));									

		if( SourceStateObject != none && AbilityStateObject != none )
		{	
			WorldData = `XWORLD;
			AbilityRadius = AbilityStateObject.GetAbilityRadius();
			AbilityCoverage = AbilityStateObject.GetAbilityCoverage();
			TargetLocation = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
			AbilityStateObject.GetMyTemplate().AbilityMultiTargetStyle.GetValidTilesForLocation(AbilityStateObject, TargetLocation, AbilityTiles);
			for (i = 0; i < AbilityTiles.Length; ++i)
			{
				if (WorldData.GetFloorPositionForTile(AbilityTiles[i], OutPair.WorldPos))
				{
					if (WorldData.GetFloorTileForPosition(OutPair.WorldPos, OutPair.Tile))
					{
						if (OutTiles.Find('Tile', OutPair.Tile) == INDEX_NONE)
						{
							OutTiles.AddItem(OutPair);
						}
					}
				}
			}
			//WorldData.CollectFloorTilesBelowDisc( OutTiles, TargetLocation, AbilityRadius );
			if (bUseFireChanceLevel)
			{
				AddEffectToTiles('X2Effect_ApplyFireToWorld', self, NewGameState, OutTiles, TargetLocation, AbilityRadius, AbilityCoverage, SourceStateObject, none, true);
			}
			else
			{
				AddEffectToTiles('X2Effect_ApplyFireToWorld', self, NewGameState, OutTiles, TargetLocation, AbilityRadius, AbilityCoverage);
			}
		}
	}
}

event AddWorldEffectTickEvents( XComGameState NewGameState, XComGameState_WorldEffectTileData TickingWorldEffect )
{
	local int Index, CurrentIntensity;
	local array<TilePosPair> OutTiles;
	//local array<TTile> DestroyedTiles;
	local TTile Tile;	
	local XComGameState_EnvironmentDamage DamageEvent;
	//local XComDestructibleActor TileActor;
	local array<int> FireEndingIndices;
	local int NumTurns, NumTurnEnvDamIdx;
	
	//Spread before reducing the intensity
	GetFireSpreadTiles(OutTiles, TickingWorldEffect);
	SharedApplyFireToTiles('X2Effect_ApplyFireToWorld', self, NewGameState, OutTiles, none);

	// Reduce the intensity of the fire each time it ticks
	for (Index = 0; Index < TickingWorldEffect.StoredTileData.Length; ++Index)
	{
		if (TickingWorldEffect.StoredTileData[Index].Data.LDEffectTile)
		{
			continue;
		}

		CurrentIntensity = TickingWorldEffect.StoredTileData[Index].Data.Intensity;
		TickingWorldEffect.UpdateTileDataIntensity( Index, CurrentIntensity - 1 );

		if (CurrentIntensity == 1)
		{
			//DestroyedTiles.AddItem( TickingWorldEffect.StoredTileData[Index].Tile );
			FireEndingIndices.AddItem(Index);
		}
	}

	//alt code that doesn't insta-destroy but instead deals environment damage
	// it instead generates three separate DamageEvents, bin sorting the affected tiles into each
	// each DamageEvent deals a different amount of environment damage, based on the NumTurns the fire burned
	if (FireEndingIndices.Length > 0)
	{
		for (NumTurns = 1; NumTurns <=3; NumTurns++)
		{
			DamageEvent = XComGameState_EnvironmentDamage( NewGameState.CreateStateObject(class'XComGameState_EnvironmentDamage') );

			DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_ApplyFireToWorld:AddWorldEffectTickEvents()";

			DamageEvent.DamageTypeTemplateName = 'Fire';
			DamageEvent.bRadialDamage = false;

			if (NumTurns >= class'Helpers_LW'.default.FireEnvironmentDamageAfterNumTurns.Length)
			{
				DamageEvent.DamageAmount = 5; // default to some low value
				`REDSCREEN("ApplyFireToWorld: Could not find configured EnvironmentDamage for NumTurns= " $ NumTurns); // this indicates a config error, so throw a redscreen
			}
			else
			{
				NumTurnEnvDamIdx = Clamp(NumTurns, 0, class'Helpers_LW'.default.FireEnvironmentDamageAfterNumTurns.Length);
				DamageEvent.DamageAmount = class'Helpers_LW'.default.FireEnvironmentDamageAfterNumTurns[NumTurnEnvDamIdx]; 
			}
			DamageEvent.bAffectFragileOnly = bDamageFragileOnly;
			//loop over indices of all tiles with fire terminating this turn
			foreach FireEndingIndices( Index )
			{
				//select only tiles with appropriate total turns the burned to be submitted with this damage event
				if (Clamp(TickingWorldEffect.StoredTileData[Index].Data.NumTurns, 1, 3) == NumTurns)
				{
					DamageEvent.DamageTiles.AddItem( Tile );
				}
			}
			NewGameState.AddStateObject( DamageEvent );
		}
	}

	//if (DestroyedTiles.Length > 0)
	//{
		//DamageEvent = XComGameState_EnvironmentDamage( NewGameState.CreateStateObject(class'XComGameState_EnvironmentDamage') );
//
		//DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_ApplyFireToWorld:AddWorldEffectTickEvents()";
//
		//DamageEvent.DamageTypeTemplateName = 'Fire';
		//DamageEvent.bRadialDamage = false;
		//DamageEvent.DamageAmount = 5; // TODO : make this config or something to avoid burning down advent walls
		//DamageEvent.bAffectFragileOnly = bDamageFragileOnly;
//
		//foreach DestroyedTiles( Tile )
		//{
			//TileActor = XComDestructibleActor( `XWORLD.GetActorOnTile( Tile, true  ) );
//
			//DamageEvent.DamageTiles.AddItem( Tile );
//
			//if (TileActor != none && (TileActor.Toughness == none || !TileActor.Toughness.bInvincible))
			//{
				//DamageEvent.DestroyedActors.AddItem( TileActor.GetActorID() );
			//}
		//}
//
		//NewGameState.AddStateObject( DamageEvent );
	//}
}

/* WOTC TODO: Fix this for WOTC
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, name EffectApplyResult)
{
	local X2Action_UpdateWorldEffects_Fire AddFireAction;
	local XComGameState_WorldEffectTileData GameplayTileUpdate;

	GameplayTileUpdate = XComGameState_WorldEffectTileData(BuildTrack.StateObject_NewState);

	// since we also make smoke, we don't want to add fire effects for those track states
	if((GameplayTileUpdate != none) && (GameplayTileUpdate.WorldEffectClassName == 'X2Effect_ApplyFireToWorld') && (GameplayTileUpdate.SparseArrayIndex > -1))
	{
		AddFireAction = X2Action_UpdateWorldEffects_Fire(class'X2Action_UpdateWorldEffects_Fire'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
		AddFireAction.bCenterTile = bCenterTile;
		AddFireAction.SetParticleSystems(GetParticleSystem_Fill());
	}
}
*/