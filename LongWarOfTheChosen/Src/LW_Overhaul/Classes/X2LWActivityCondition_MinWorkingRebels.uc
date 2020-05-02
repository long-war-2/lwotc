//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_MinRebelsOnJob
//  AUTHOR:  JohnnyLump / Pavonis Interactive
//  PURPOSE: Conditionals on the number of rebels on a job in a region
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_MinWorkingRebels extends X2LWActivityCondition;



var int MinWorkingRebels;

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local XComGameState_LWOutpostManager			OutPostManager;
	local XComGameState_LWOutpost					OutPostState;
	local int WorkingRebels;

	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	OutpostState = OutpostManager.GetOutpostForRegion(Region);

	WorkingRebels = OutPostState.Rebels.Length - OutPostState.GetNumRebelsOnJob(class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB);

	`LWTRACE("Trying to make" @ ActivityCreation.ActivityTemplate.ActivityName $ ". Attempting MinWorkingRebelsCheck" @ string (WorkingRebels) @ ">=" @ string(MinWorkingRebels));

	if (WorkingRebels >= MinWorkingRebels)
		return true;
	return false;
}
