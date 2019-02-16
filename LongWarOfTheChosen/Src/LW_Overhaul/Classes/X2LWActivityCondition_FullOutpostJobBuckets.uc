class X2LWActivityCondition_FullOutpostJobBuckets extends X2LWActivityCondition config(LW_Activities);



var config float CONTACTED_REGIONS_BASE_BUCKET_MOD;
var config float LIBERATED_REGIONS_BASE_BUCKET_MOD;

var bool FullRetal;
var name Job;
var int RequiredDays;

simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion Region;
	local int BucketSize, LiberatedRegions, ContactedRegions;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local XComGameState_LWOutpostManager			OutPostManager;
	local XComGameState_LWOutpost					OutPostState;
	
	History = `XCOMHISTORY;
	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	BucketSize = 0;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', Region)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
		OutpostState = OutpostManager.GetOutpostForRegion(Region);
		if (Region.ResistanceLevel >= eResLevel_Contact)
		{
			if (FullRetal)
			{
				BucketSize += OutPostState.TotalResistanceBucket;
			}
			else
			{
				BucketSize += OutPostState.GetJobBucketForJob (Job);
			}
			ContactedRegions += 1;
		}

		if (RegionalAI.bLiberated)
		{
			LiberatedRegions += 1;
		}
	}
	
	BucketSize = BucketSize * (default.CONTACTED_REGIONS_BASE_BUCKET_MOD ** (ContactedRegions - 1));
	BucketSize = Bucketsize * (default.LIBERATED_REGIONS_BASE_BUCKET_MOD ** (LiberatedRegions));
	`LWTRACE ("Testing for Retalbucket (post adjustment):" @ (FullRetal ? "Full" : string(Job)) @ "Condition passed if" @ BucketSize @ ">=" @ RequiredDays);

	if (BucketSize >= RequiredDays)
		return true;
	
	return false;
}