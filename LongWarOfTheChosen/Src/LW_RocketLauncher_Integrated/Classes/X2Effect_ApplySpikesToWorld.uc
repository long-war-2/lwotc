class X2Effect_ApplySpikesToWorld extends X2Effect_ApplyPoisonToWorld;
/*
event array<ParticleSystem> GetParticleSystem_Fill()
{
	local array<ParticleSystem> ParticleSystems;
	//ParticleSystems.AddItem( none );
	ParticleSystems.AddItem(ParticleSystem(DynamicLoadObject(PoisonParticleSystemFill_Name, class'ParticleSystem')));
	return ParticleSystems;
}*/
/*
event array<X2Effect> GetTileEnteredEffects()
{
	local X2Effect_Persistent				BleedingEffect;
	local array<X2Effect>					TileEnteredEffectsUncached;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;

	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(class'X2Rocket_Flechette'.default.BLEED_DURATION, class'X2Rocket_Flechette'.default.BLEED_DAMAGE);
	BleedingEffect.bEffectForcesBleedout = false;
	BleedingEffect.WatchRule = eGameRule_PlayerTurnEnd;
	if (class'X2Rocket_Flechette'.default.BLEED_STACKS) 
	{
		BleedingEffect.DuplicateResponse = eDupe_Allow;
	}
	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_ArmorMitigation, 1, eCheck_LessThan);

	BleedingEffect.TargetConditions.AddItem(UnitStatCheckCondition);

	TileEnteredEffectsUncached.AddItem(BleedingEffect);
	
	return TileEnteredEffectsUncached;
}

simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateHistory		History;
	local XComGameState_Ability		AbilityStateObject;
	local XComGameState_Unit		SourceStateObject;
	local XComGameState_Item		SourceItemStateObject;
	local float						AbilityRadius, AbilityCoverage;
	local XComWorldData				WorldData;
	local vector					TargetLocation;
	local array<TilePosPair>		OutTiles;
	local X2AbilityTemplate			AbilityTemplate;
	local array<TTile>				AbilityTiles;
	local TilePosPair				OutPair;
	local int i;

	//If this damage effect has an associated position, it does world damage
	if( ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0 )
	{
		History = `XCOMHISTORY;
		SourceStateObject = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		SourceItemStateObject = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));	
		AbilityStateObject = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));									

		if( SourceStateObject != none && AbilityStateObject != none && (SourceItemStateObject != none || !RequireSourceItemForEffect()) )
		{
			AbilityTemplate = AbilityStateObject.GetMyTemplate();
			if( AbilityTemplate.AbilityMultiTargetStyle != none )
			{
				WorldData = `XWORLD;
				AbilityRadius = AbilityStateObject.GetAbilityRadius();
				AbilityCoverage = AbilityStateObject.GetAbilityCoverage();
				`LOG("Ability coverage: " @ AbilityCoverage,, 'IRIALLOY');
				TargetLocation = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
				AbilityTemplate.AbilityMultiTargetStyle.GetValidTilesForLocation(AbilityStateObject, TargetLocation, AbilityTiles);
				`LOG("Valid tiles: " @ AbilityTiles.Length,, 'IRIALLOY');
				for( i = 0; i < AbilityTiles.Length; ++i )
				{
					OutPair.Tile = AbilityTiles[i];
					OutPair.WorldPos = WorldData.GetPositionFromTileCoordinates(OutPair.Tile);

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
				`LOG("Applying effect to: " @ OutTiles.Length @ "tiles",, 'IRIALLOY');
				AddEffectToTiles( GetWorldEffectClassName(), self, NewGameState, OutTiles, TargetLocation, AbilityRadius, AbilityCoverage, SourceStateObject, SourceItemStateObject );
			}
		}
	}
}
*/
/*
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_PlayEffect				EffectAction;
	local XComGameState_WorldEffectTileData	TileData;
	local XComWorldData						WorldData;
	local TTile								Tile;
	local int i;	

	TileData = XComGameState_WorldEffectTileData(ActionMetadata.StateObject_NewState);
	if (TileData != none)
	{
		`LOG("Visualizing spikes for: " @ TileData.StoredTileData.Length @ "tiles",, 'IRIALLOY');

		WorldData = `XWORLD;
		for (i = 0; i < TileData.StoredTileData.Length; i++)
		{
			//	Can't use dynamic arrays with GetPositionFromTileCoordinates
			Tile = TileData.StoredTileData[i].Tile;
			 
			EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			EffectAction.EffectName = PoisonParticleSystemFill_Name; 
			EffectAction.EffectLocation = WorldData.GetPositionFromTileCoordinates(Tile);
			EffectAction.EffectRotation = Rotator(vect(0, 1, 0));
			EffectAction.bWaitForCompletion = false;
			EffectAction.bWaitForCameraArrival = false;
			EffectAction.bWaitForCameraCompletion = false;
		}
	}
}

static simulated function int GetTileDataDynamicFlagValue() { return 0; }

static simulated event bool ShouldRemoveFromDestroyedFloors() { return true; }

defaultproperties
{
	bCenterTile = false;
	EffectName = "IRI_AlloySpikes_WorldEffect"
}
*/
/*
simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityStateObject;
	local XComGameState_Unit SourceStateObject;
	local float AbilityRadius;//, AbilityCoverage;
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
			//AbilityCoverage = AbilityStateObject.GetAbilityCoverage();
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
							//	Add effect only to tiles that can be entered. Don't want alloy spikes on cover objects.
							//if (WorldData.CanUnitsEnterTile(OutPair.Tile) && !WorldData.IsTileFullyOccupied(OutPair.Tile) && !WorldData.IsTileOccupied(OutPair.Tile) && WorldData.IsFloorTile(OutPair.Tile))
							//{
								OutTiles.AddItem(OutPair);
							//}
						}
					}
				}
			}

			AddEffectToTiles(Class.Name, self, NewGameState, OutTiles, TargetLocation, AbilityRadius, class'X2Rocket_Flechette'.default.SPIKES_COVERAGE);
		}
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_UpdateWorldEffects_Acid AddAcidAction;
	if( ActionMetadata.StateObject_NewState.IsA('XComGameState_WorldEffectTileData') )
	{
		AddAcidAction = X2Action_UpdateWorldEffects_Acid(class'X2Action_UpdateWorldEffects_Acid'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		AddAcidAction.bCenterTile = bCenterTile;
		AddAcidAction.SetParticleSystems(GetParticleSystem_Fill());
	}
}

static simulated event AddEffectToTiles(Name EffectName, X2Effect_World Effect, XComGameState NewGameState, array<TilePosPair> Tiles, vector TargetLocation, float Radius, float Coverage, optional XComGameState_Unit SourceStateObject, optional XComGameState_Item SourceWeaponState, optional bool bUseFireChance)
{
	local XComGameState_WorldEffectTileData GameplayTileUpdate;
	local array<TileIsland> TileIslands;
	local array<TileParticleInfo> TileParticleInfos;
	local VolumeEffectTileData InitialTileData;

	GameplayTileUpdate = XComGameState_WorldEffectTileData(NewGameState.CreateNewStateObject(class'XComGameState_WorldEffectTileData'));
	GameplayTileUpdate.WorldEffectClassName = EffectName;

	InitialTileData.EffectName = EffectName;
	InitialTileData.NumTurns = GetTileDataNumTurns();
	InitialTileData.DynamicFlagUpdateValue = GetTileDataDynamicFlagValue();
	if (SourceStateObject != none)
		InitialTileData.SourceStateObjectID = SourceStateObject.ObjectID;
	if (SourceWeaponState != none)
		InitialTileData.ItemStateObjectID = SourceWeaponState.ObjectID;

	FilterForLOS( Tiles, TargetLocation, Radius );

	if (HasFillEffects())
	{
		TileIslands = CollapseTilesToPools(Tiles);
		DetermineFireBlocks(TileIslands, Tiles, TileParticleInfos);

		GameplayTileUpdate.SetInitialTileData( Tiles, InitialTileData, TileParticleInfos );
	}
	else
	{
		GameplayTileUpdate.SetInitialTileData( Tiles, InitialTileData );
	}
			
	`XEVENTMGR.TriggerEvent( 'GameplayTileEffectUpdate', GameplayTileUpdate, SourceStateObject, NewGameState );
}
*/