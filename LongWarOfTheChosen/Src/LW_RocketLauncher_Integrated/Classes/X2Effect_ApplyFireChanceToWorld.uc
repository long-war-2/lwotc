class X2Effect_ApplyFireChanceToWorld extends X2Effect_ApplyFireToWorld;

var float fChance;

event array<X2Effect> GetTileEnteredEffects()
{
	local X2Effect_PersistentStatChange	PoisonedEffect;
	local array<X2Effect> TileEnteredEffectsUncached;

	TileEnteredEffectsUncached.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	PoisonedEffect = class'X2StatusEffects'.static.CreatePoisonedStatusEffect();
	PoisonedEffect.VFXTemplateName = "";
	TileEnteredEffectsUncached.AddItem(PoisonedEffect);

	TileEnteredEffectsUncached.AddItem(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());
	
	return TileEnteredEffectsUncached;
}

static simulated function SharedApplyFireToTiles( Name EffectName, X2Effect_ApplyFireToWorld FireEffect, XComGameState NewGameState, array<TilePosPair> OutTiles, XComGameState_Unit SourceStateObject, int ForceIntensity = -1, optional bool UseFireChance = false )
{
	local XComGameState_WorldEffectTileData FireTileUpdate, SmokeTileUpdate;
	local VolumeEffectTileData InitialFireTileData, InitialSmokeTileData;
	local array<VolumeEffectTileData> InitialFireTileDatas;
	local array<Actor> TileActors;
	local Actor TileActor;
	local XComDestructibleActor PossibleFuel;
	local TilePosPair SmokeTile;
	local int Index, SmokeIndex, Intensity2;
	local array<TileIsland> TileIslands;
	local array<TileParticleInfo> FireTileParticleInfos;
	local float FireChanceTotal, FireLevelRand;
	local XComWorldData WorldData;
	local float fRand;

	WorldData = `XWORLD;

	FireChanceTotal = FireEffect.FireChance_Level1 + FireEffect.FireChance_Level2 + FireEffect.FireChance_Level3;

	FireTileUpdate = XComGameState_WorldEffectTileData(NewGameState.CreateNewStateObject(class'XComGameState_WorldEffectTileData'));
	FireTileUpdate.WorldEffectClassName = EffectName;
	FireTileUpdate.PreSizeTileData( OutTiles.Length );

	SmokeTileUpdate = XComGameState_WorldEffectTileData(NewGameState.CreateNewStateObject(class'XComGameState_WorldEffectTileData'));
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
			FireLevelRand = `SYNC_FRAND_STATIC() * FireChanceTotal;
			if(FireLevelRand > (FireEffect.FireChance_Level1 + FireEffect.FireChance_Level2))
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
		TileActors = `XWORLD.GetActorsOnTile( OutTiles[Index].Tile, true );
		foreach TileActors(TileActor)
		{
			PossibleFuel = XComDestructibleActor( TileActor );
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

	`LOG("Calling SharedApplyFireToTiles, tiles: " @ OutTiles.Length,, 'IRIPH');
	`LOG("fChance: " @ default.fChance,, 'IRIPH');

	for(Index = OutTiles.Length; Index >= 0; Index--)
	{
		fRand = `SYNC_FRAND_STATIC();
		`LOG("Roll: " @ fRand,, 'IRIPH');
		if (fRand > default.fChance)
		{
			OutTiles.Remove(Index, 1);
			InitialFireTileDatas.Remove(Index, 1);
			FireTileParticleInfos.Remove(Index, 1);
		}
	}

	`LOG("######## Finished: " @ OutTiles.Length,, 'IRIPH');

	for(Index = 0; Index < OutTiles.Length; ++Index)
	{
		FireTileUpdate.AddInitialTileData(OutTiles[Index], InitialFireTileDatas[Index], FireTileParticleInfos[Index]);
	}

	`XEVENTMGR.TriggerEvent( 'GameplayTileEffectUpdate', FireTileUpdate, SourceStateObject, NewGameState );
	`XEVENTMGR.TriggerEvent( 'GameplayTileEffectUpdate', SmokeTileUpdate, SourceStateObject, NewGameState );
}

defaultproperties
{
	fChance = 0.35f;
}