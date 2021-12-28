//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_FullRetalBucket.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: A condition for any retal that requires an outpost's retal bucket to
//           be full.
//---------------------------------------------------------------------------------------

class X2LWActivityCondition_FullRetalBucket extends X2LWActivityCondition config(LW_Activities);

var name RebelJob;
var int BucketCapacity;

simulated function bool MeetsConditionWithRegion(
	X2LWActivityCreation ActivityCreation,
	XComGameState_WorldRegion RegionState,
	XComGameState NewGameState)
{
	local XComGameState_LWOutpost					OutPostState;

	OutpostState = `LWOUTPOSTMGR.GetOutpostForRegion(RegionState);

	`LWTRACE("Testing for retaliation in " $ RegionState.GetDisplayName() $
		" (Bucket capacity = " $ BucketCapacity $ ", level = " $ OutpostState.TotalResistanceBucket $ ")");

	if (RebelJob == '')
	{
		return OutpostState.TotalResistanceBucket >= BucketCapacity;
	}
	else
	{
		return OutpostState.GetJobBucketForJob(RebelJob) >= BucketCapacity;
	}

	return false;
}
