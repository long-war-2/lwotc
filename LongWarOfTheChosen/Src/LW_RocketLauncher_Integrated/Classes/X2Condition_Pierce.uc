class X2Condition_Pierce extends X2Condition;

//	unused

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	local vector ShooterLocation, TargetLocation;
	local array<TilePosPair>	PierceTiles;
	local XComWorldData			WorldData;
	local vector				PierceLocation;
	local int PierceDistance;
	local int i;

	SourceUnit = XComGameState_Unit(kSource);
	TargetUnit = XComGameState_Unit(kTarget);

	if (SourceUnit != none && TargetUnit != none)
	{
			
		WorldData = `XWORLD;

		PierceDistance = 3;

		ShooterLocation = WorldData.GetPositionFromTileCoordinates(SourceUnit.TileLocation);
		TargetLocation = WorldData.GetPositionFromTileCoordinates(TargetUnit.TileLocation);

		//	Calculate DIRECTION from the shooter to the target.
		PierceLocation = Normal(TargetLocation - ShooterLocation);
		//	Multiply that direction by PierceDistance tiles
		PierceLocation *= (PierceDistance + 1) * WorldData.WORLD_StepSize;
		//	Project the resulting vector from target's location
		//	This should always get us a vector pointing behind the target.
		PierceLocation += TargetLocation;

		//	Grab tiles located alongside that vector.
		//	It will grab "tiles" hanging in the air as well. 
		WorldData.CollectTilesInCapsule(PierceTiles, TargetLocation, PierceLocation, WorldData.WORLD_StepSize); //WORLD_HalfStepSize

		for (i = 0; i < PierceTiles.Length; i++)
		{
			if (PierceTiles[i].Tile == TargetUnit.TileLocation) return 'AA_Success'; 
		}
	}
	return 'AA_NotInRange'; 
}
/*
static function FilterPierceTiles(const vector ShooterLocation, const vector TargetLocation, const int PierceDistance, out array<TTile> Tiles)
{

}*/