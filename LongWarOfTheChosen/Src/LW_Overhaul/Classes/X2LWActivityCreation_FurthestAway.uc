//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCreation_FurthestAway.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Extended Creation class that optimizes to putting activity in region furthest from a contacted region
//---------------------------------------------------------------------------------------
class X2LWActivityCreation_FurthestAway extends X2LWActivityCreation;



simulated function StateObjectReference FindBestPrimaryRegion(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local StateObjectReference RegionRef, NullRef;
	local array<StateObjectReference> BestRegions;
	local XComGameState_WorldRegion		RegionState;
	local int CurrentDistance, BestDistance;

	if (PrimaryRegions.Length == 0)
		return NullRef;

	History = `XCOMHISTORY;
	BestDistance = -99;
	foreach PrimaryRegions(RegionRef)
	{
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));
		CurrentDistance = LinkDistanceToClosestContactedRegion(RegionState);
		if (BestDistance < CurrentDistance)
		{
			BestRegions.Length = 0;
			BestRegions.AddItem(RegionRef);
			BestDistance = CurrentDistance;
		}
		if (BestDistance == CurrentDistance)
		{
			BestRegions.AddItem(RegionRef);
		}
	}
	
	if(BestRegions.Length == 0)
		return NullRef;
	else
		return BestRegions[`SYNC_RAND(BestRegions.Length)];
}

