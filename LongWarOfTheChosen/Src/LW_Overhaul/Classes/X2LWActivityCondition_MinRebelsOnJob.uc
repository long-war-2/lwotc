//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_MinRebelsOnJob
//  AUTHOR:  JohnnyLump / Pavonis Interactive
//	PURPOSE: Conditionals on the number of rebels on a job in a region
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_MinRebelsOnJob extends X2LWActivityCondition;



var int MinRebelsOnJob;
var name Job;
var bool FacelessReduceMinimum;

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local XComGameState_LWOutpostManager			OutPostManager;
	local XComGameState_LWOutpost					OutPostState;
	local int										AdjustedMinRebelsOnJob;

	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	OutpostState = OutpostManager.GetOutpostForRegion(Region);

	AdjustedMinRebelsOnJob = MinRebelsOnJob;

	// This is for triggering mini-retals at lower threshhold representing the Faceless leaking information. The 3 constant is so the mini-retals have a minimum number of rebels on the screen)
	if (FacelessReduceMinimum)
	{
		AdjustedMinRebelsOnJob = Max (MinRebelsOnJob - OutPostState.GetNumFacelessOnJob(Job), 3);
	}

	if (OutPostState.GetNumRebelsOnJob(Job) >= AdjustedMinRebelsOnJob)
	{
		`LWTRACE ("MinRebelsOnJob Pass" @ string(AdjustedMinRebelsOnJob) @ ActivityCreation.ActivityTemplate.ActivityName);
		return true;	
	}
	`LWTRACE ("MinRebelsOnJob Fail" @ string(AdjustedMinRebelsOnJob) @ ActivityCreation.ActivityTemplate.ActivityName);
	return false;
}



