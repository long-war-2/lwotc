//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_MaxRebels
//  AUTHOR:  JohnnyLump / Pavonis Interactive
//  PURPOSE: Conditionals on the number of rebels in a region
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_MaxRebels extends X2LWActivityCondition;



var int MaxRebels;

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local XComGameState_LWOutpostManager			OutPostManager;
	local XComGameState_LWOutpost					OutPostState;

	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	OutpostState = OutpostManager.GetOutpostForRegion(Region);
	if (OutPostState.Rebels.length <= MaxRebels)
		return true;	
	return false;
}