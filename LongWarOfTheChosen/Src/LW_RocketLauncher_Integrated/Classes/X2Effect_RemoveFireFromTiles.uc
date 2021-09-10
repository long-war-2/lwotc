class X2Effect_RemoveFireFromTiles extends X2Effect_World;

// doesn't work, currently unused

simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityStateObject;
	local XComGameState_Unit SourceStateObject;
	local XComGameState_Item SourceItemStateObject;
	local XComWorldData WorldData;
	local vector TargetLocation;
	local array<TilePosPair> OutTiles;
	local X2AbilityTemplate AbilityTemplate;
	local array<TTile> AbilityTiles;
	local TilePosPair OutPair;
	local int i;

	local XComGameState_WorldEffectTileData	WorldEffectTileData;	
	//local array<ParticleSystem>	pArray;

	//`LOG("Applying fire effect to tiles:" @ ApplyEffectParameters.AbilityResultContext.RelevantEffectTiles.Length,, 'IRIROCK');

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
				TargetLocation = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
				AbilityTemplate.AbilityMultiTargetStyle.GetValidTilesForLocation(AbilityStateObject, TargetLocation, AbilityTiles);
				for( i = 0; i < AbilityTiles.Length; ++i )
				{
					OutPair.Tile = AbilityTiles[i];
					OutPair.WorldPos = WorldData.GetPositionFromTileCoordinates(OutPair.Tile);

					//WorldData.SetIsWaterTile(AbilityTiles[i], true);	// prevents new fires from appearing, doesn't remove existing ones

					if (OutTiles.Find('Tile', OutPair.Tile) == INDEX_NONE)
					{
						OutTiles.AddItem(OutPair);
					}
				}


				//pArray.AddItem(ParticleSystem(DynamicLoadObject(class'X2Effect_ApplyFireToWorld'.default.FireParticleSystemFill_Name, class'ParticleSystem')));
				foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldEffectTileData)
				{
					//`LOG("found world effect",, 'IRIROCK');
					if (WorldEffectTileData.WorldEffectClassName == class'X2Effect_ApplyFireToWorld'.Name)
					{	
						WorldEffectTileData = XComGameState_WorldEffectTileData(NewGameState.ModifyStateObject(class'XComGameState_WorldEffectTileData', WorldEffectTileData.ObjectID));

						
						//WorldData.UpdateVolumeEffects(WorldEffectTileData, pArray, false);	
						
						for( i = 0; i < WorldEffectTileData.StoredTileData.Length; ++i )
						{
							WorldEffectTileData.UpdateTileDataIntensity(i, 100);
						}
						
						//`LOG("found fire effect, affecting tiles: " @ WorldEffectTileData.StoredTileData.Length,, 'IRIROCK');
					}
				}
			}
		}
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_UpdateWorldEffects_Fire AddFireAction;
	local XComGameState_WorldEffectTileData GameplayTileUpdate;

	//`LOG("Caling visualization",, 'IRIROCK');

	GameplayTileUpdate = XComGameState_WorldEffectTileData(ActionMetadata.StateObject_NewState);
	
	// since we also make smoke, we don't want to add fire effects for those track states
	if((GameplayTileUpdate != none) && (GameplayTileUpdate.WorldEffectClassName == class'X2Effect_ApplyFireToWorld'.Name) && (GameplayTileUpdate.SparseArrayIndex > -1))
	{
		AddFireAction = X2Action_UpdateWorldEffects_Fire(class'X2Action_UpdateWorldEffects_Fire'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		//AddFireAction.bCenterTile = true;	//	works along Z axis, methinks
		AddFireAction.SetParticleSystems(GetParticleSystem_Fill());
	}
}