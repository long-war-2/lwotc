//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_RegionStatus.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Conditionals on the status of the region
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_RegionStatus extends X2LWActivityCondition;

var bool bAllowInLiberated;
var bool bAllowInAlien;
var bool bAllowInContacted;
var bool bAllowInUncontacted;
var bool bAllowInContactedOrAdjacentToContacted;

function bool ContactedOrAdjacentToContacted (XComGameState_WorldRegion Region, XComGameState_WorldRegion_LWStrategyAI RegionalAI)
{
	local StateObjectReference			LinkedRegionRef;
	local XComGameState_WorldRegion		NeighborRegionState; 
	local XComGameState_WorldRegion_LWStrategyAI NeighborRegionStateAI;

	if (Region.HaveMadeContact() && !RegionalAI.bLiberated)
		return true;

	foreach Region.LinkedRegions (LinkedRegionRef)
	{
		NeighborRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
		NeighborRegionStateAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(NeighborRegionState);
		if (NeighborRegionState.HaveMadeContact() && !NeighborRegionStateAI.bLiberated)
		{
			return true;
		}
	}
	return false;
}


simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local bool bMeetsCondition;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	bMeetsCondition = true;

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
	if(RegionalAI.bLiberated && !bAllowInLiberated)
		bMeetsCondition = false;
		
	if(!RegionalAI.bLiberated && !bAllowInAlien)
		bMeetsCondition = false;

	if(Region.HaveMadeContact() && !bAllowInContacted)
		bMeetsCondition = false;
	
	if(!Region.HaveMadeContact() && !bAllowInUncontacted)
		bMeetsCondition = false;

	If (!ContactedOrAdjacentToContacted(Region, RegionalAI) && bAllowInContactedOrAdjacentToContacted)
		bMeetsCondition = false;

	return bMeetsCondition;
}


defaultProperties
{
	bAllowInLiberated=false
	bAllowInAlien=true
	bAllowInContacted=false
	bAllowInUncontacted=false
	bAllowInContactedOrAdjacentToContacted=false
}