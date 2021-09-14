class X2Effect_ApplyThermobaricDamage extends X2Effect_ApplyWeaponDamage;

//	deal bonus damage based on how many tiles around the target provide cover

var transient int MaxTiles;
const bLog = false;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue		ReturnDamageValue;
	local XComGameState_Unit	TargetUnit;
	local XComWorldData			WorldData;
	local XComGameStateHistory	History;
	local vector				TargetLocation;
	local array<TilePosPair>	Tiles;
	local float					AccumulatedDamage;
	local int i;

	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	//	For the purposes of damage preview
	TargetLocation = WorldData.GetPositionFromTileCoordinates(SourceUnit.TileLocation);
	WorldData.CollectTilesInCylinder(Tiles, TargetLocation, class'X2Rocket_Thermobaric'.default.MAX_DISTANCE_TO_COVER_FOR_BONUS_DAMAGE, 0); // results in 3 x 3 tile square
	MaxTiles = Tiles.Length;
	//	end of damage preview

	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
	
	if (TargetUnit != none) 
	{
		//`LOG("Targeting: " @ TargetUnit.GetFullName(), bLog, 'IRIROCK');

		TargetLocation = WorldData.GetPositionFromTileCoordinates(TargetUnit.TileLocation);
		//WorldData.CollectTilesInCapsule(Tiles, TargetLocation, TargetLocation2, class'X2Rocket_Thermobaric'.default.MAX_DISTANCE_TO_COVER_FOR_BONUS_DAMAGE); 
		
		WorldData.CollectTilesInCylinder(Tiles, TargetLocation, class'X2Rocket_Thermobaric'.default.MAX_DISTANCE_TO_COVER_FOR_BONUS_DAMAGE, 0); // results in 3 x 3 tile square

		for (i = 0; i < Tiles.Length; i++)
		{
			if (WorldData.IsFloorTile(Tiles[i].Tile) && //	if tile is on the floor (we don't count tiles "hanging in the air")
				!WorldData.IsAdjacentTileBlocked(TargetUnit.TileLocation, Tiles[i].Tile)) // and there is clearance to this tile from the target's tile, i.e. the blastwave can travel between them
			{
				//	 A tile is considered cover if it GETS COVER from a nearby cover object, not if the tile itself contains a cover object.
				if (WorldData.IsLocationHighCover(Tiles[i].WorldPos))
				{
					AccumulatedDamage += class'X2Rocket_Thermobaric'.default.BONUS_DAMAGE_PER_HIGH_COVER_OBJECT;
					//`LOG("Found High Cover object, increasing damage by: " @ class'X2Rocket_Thermobaric'.default.BONUS_DAMAGE_PER_HIGH_COVER_OBJECT, bLog, 'IRIROCK');
				}
				if (WorldData.IsLocationLowCover(Tiles[i].WorldPos))
				{
					AccumulatedDamage += class'X2Rocket_Thermobaric'.default.BONUS_DAMAGE_PER_LOW_COVER_OBJECT;
					//`LOG("Found Low Cover object, increasing damage by: " @ class'X2Rocket_Thermobaric'.default.BONUS_DAMAGE_PER_LOW_COVER_OBJECT, bLog, 'IRIROCK');
				}
			}
		}
		if (TargetUnit.GetCurrentStat(eStat_ArmorMitigation) > class'X2Rocket_Thermobaric'.default.HIGH_ARMOR_THRESHOLD)
		{
			AccumulatedDamage *= class'X2Rocket_Thermobaric'.default.HIGH_ARMOR_DAMAGE_MULTIPLIER;
			//`LOG("Target armor exceeds threshold, multiplying damage by: " @ class'X2Rocket_Thermobaric'.default.HIGH_ARMOR_DAMAGE_MULTIPLIER @ ", adjusted damage: " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
		}

	}

	ReturnDamageValue.Damage = FFloor(AccumulatedDamage);
	//`LOG("Calculated bonus damage: " @ ReturnDamageValue.Damage @ " from cover objects in " @ Tiles.Length @ "tiles", bLog, 'IRIROCK');
	return ReturnDamageValue;
}

simulated function GetDamagePreview(StateObjectReference TargetRef, XComGameState_Ability AbilityState, bool bAsPrimaryTarget, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	Super.GetDamagePreview(TargetRef, AbilityState, bAsPrimaryTarget, MinDamagePreview, MaxDamagePreview, AllowsShield);

	MaxDamagePreview.Damage += FFloor(MaxTiles * class'X2Rocket_Thermobaric'.default.BONUS_DAMAGE_PER_HIGH_COVER_OBJECT);
}