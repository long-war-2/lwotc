//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_ResearchFacility.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Conditionals on the alien research facilities
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_ResearchFacility extends X2LWActivityCondition config(LW_Activities);



var config int MAX_UNOBSTRUCTED_FACILITIES;
var config int GLOBAL_ALERT_DELTA_PER_EXTRA_FACILITY;

var bool bRequiresAlienResearchFacilityInRegion;
var bool bRequiresHiddenAlienResearchFacilityInWorld;
var bool bAllowedAlienResearchFacilityInRegion;
var bool bBuildingResearchFacility;

simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local bool bMeetsCondition;
	local int Facilities;

	if(!bRequiresHiddenAlienResearchFacilityInWorld && !bBuildingResearchFacility)
		return true;

	bMeetsCondition = false;
	History = `XCOMHISTORY;

	// Testing if there is an undiscovered facility in the world
	foreach ActivityCreation.ActivityStates(ActivityState)
	{
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);
		if(RegionalAI.bHasResearchFacility && !ActivityState.bDiscovered && !bBuildingResearchFacility)
		{
			bMeetsCondition = true;
			break;
		}
	}
	if (bBuildingResearchFacility)
	{
		Facilities = 0;
		bMeetsCondition = true;
		foreach History.IterateByClassType(class'XComGameState_WorldRegion_LWStrategyAI', RegionalAI )
		{
			// How many facilities are already built
			if(RegionalAI.bHasResearchFacility)
			{
				Facilities +=1;
			}
		}
		// Only build more than 3 if feeling safe
		if (Facilities >= default.MAX_UNOBSTRUCTED_FACILITIES)
		{
			if (`LWACTIVITYMGR.GetGlobalAlert() - (default.GLOBAL_ALERT_DELTA_PER_EXTRA_FACILITY * (Facilities - default.MAX_UNOBSTRUCTED_FACILITIES + 1)) < `LWACTIVITYMGR.GetGlobalVigilance())
			{
				bMeetsCondition = false;
				`LWTRACE("Bad guys can't build research facility because Global Vig is TOO HIGH");
			}
		}
	}
	return bMeetsCondition;
}

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local bool bMeetsCondition;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	bMeetsCondition = true;

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
	if(!RegionalAI.bHasResearchFacility && bRequiresAlienResearchFacilityInRegion)
		bMeetsCondition = false;
	if(RegionalAI.bHasResearchFacility && !bAllowedAlienResearchFacilityInRegion)
		bMeetsCondition = false;
	
	return bMeetsCondition;
}


defaultProperties
{
	bRequiresAlienResearchFacilityInRegion=false
	bRequiresHiddenAlienResearchFacilityInWorld=false
	bAllowedAlienResearchFacilityInRegion=true
	bBuildingResearchFacility=false
}