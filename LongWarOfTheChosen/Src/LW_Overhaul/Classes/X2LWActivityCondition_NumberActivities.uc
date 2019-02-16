//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_NumberActivities.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Conditionals on the number of other activities currently active
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_NumberActivities extends X2LWActivityCondition;

var int MaxActivitiesInWorld;
var int MaxActivitiesInRegion;
var int MaxCategoriesInRegion;

simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState)
{
	local XComGameState_LWAlienActivity ActivityState;
	local int Count;
	local bool bMeetsCondition;

	bMeetsCondition = true;
	if(MaxActivitiesInWorld >= 0)
	{
		Count = 0;
		foreach ActivityCreation.ActivityStates(ActivityState)
		{
			if(ActivityState.GetMyTemplateName() == ActivityCreation.ActivityTemplate.DataName)
			{
				Count++;
			}
		}
		if(Count >= MaxActivitiesInWorld)
			bMeetsCondition = false;

		ActivityCreation.NumActivitiesToCreate = Min(ActivityCreation.NumActivitiesToCreate, MaxActivitiesInWorld-Count);
	}
	return bMeetsCondition;
}

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local XComGameState_LWAlienActivity ActivityState;
	local int Count;
	local bool bMeetsCondition;

	bMeetsCondition = true;
	if(MaxActivitiesInRegion >= 0)
	{
		Count = 0;
		foreach ActivityCreation.ActivityStates(ActivityState)
		{
			if(ActivityState.PrimaryRegion.ObjectID == Region.ObjectID && ActivityState.GetMyTemplateName() == ActivityCreation.ActivityTemplate.DataName)
			{
				Count++;
			}
		}
		if(Count >= MaxActivitiesInRegion)
			bMeetsCondition = false;
	}
	if(MaxCategoriesInRegion >= 0)
	{
		Count = 0;
		foreach ActivityCreation.ActivityStates(ActivityState)
		{
			if(ActivityState.PrimaryRegion.ObjectID == Region.ObjectID && ActivityState.GetMyTemplate().ActivityCategory == ActivityCreation.ActivityTemplate.ActivityCategory)
			{
				Count++;
			}
		}
		if(Count >= MaxCategoriesInRegion)
			bMeetsCondition = false;
	}
	return bMeetsCondition;
}


defaultProperties
{
	MaxActivitiesInWorld=-1
	MaxActivitiesInRegion=-1
	MaxCategoriesInRegion=-1
}