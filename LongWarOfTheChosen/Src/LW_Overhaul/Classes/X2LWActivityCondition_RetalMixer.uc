// Because the activity chooser will pick randomly from eligble candidate regions for an activity, this will serve to steer likelihoods toward certain regions by passing them through a gate 

class X2LWActivityCondition_RetalMixer extends X2LWActivityCondition;



var bool UseSpecificJob;
var name SpecificJob;

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local int PassGateChance;
	local XComGameState_MissionSite					MissionState;
	local XComGameState_WorldRegion_LWStrategyAI	RegionalAI;
	local XComGameState_LWOutpost					Outpost;

	PassGateChance = 20;
	
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region,NewGameState);
	Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);

	PassGateChance += 3 * RegionalAI.LocalVigilanceLevel;
	PassGateChance += 3 * RegionalAI.LocalAlertLevel;

	if (UseSpecificJob)
	{
		PassGateChance += 5 * OutPost.GetNumRebelsOnJob (SpecificJob);
	}
	else
	{
		PassGateChance += 3 * (Outpost.GetRebelCount() - OutPost.GetNumRebelsOnJob(class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB) - 6);
	}

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if (MissionState.GetMissionSource().DataName == 'MissionSource_Blacksite' ||
			MissionState.GetMissionSource().DataName == 'MissionSource_Forge' ||
			MissionState.GetMissionSource().DataName == 'MissionSource_PsiGate')
		{
			if (MissionState.Region == Region.GetReference())
				PassGateChance = 100;
			if (MissionState.GetWorldRegion().LinkedRegions.Find('ObjectID', Region.ObjectID) != -1)
				PassGateChance = 100;
		}
	}

	if (`SYNC_RAND(100) < PassGateChance)
		return true;

	return false;
}
