class X2Effect_ApplyAcidToWorld_Cone extends X2Effect_ApplyAcidToWorld;

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

		AddEffectToTiles(Class.Name, self, NewGameState, OutTiles, TargetLocation, AbilityRadius, AbilityCoverage);

		}
	}
}