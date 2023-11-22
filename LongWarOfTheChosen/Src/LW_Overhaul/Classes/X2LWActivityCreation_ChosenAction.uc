//Author: Tedster
// New ActivityCreation to allow for chosen created activities.

class X2LWActivityCreation_ChosenAction extends X2LWActivityCreation;

simulated function InitActivityCreation(X2LWAlienActivityTemplate Template, XComGameState NewGameState, optional XComGameState_AdventChosen ChosenState = none)
{
    if(ChosenState != None)
    {
        NumActivitiesToCreate = 1;
    }
    else
    {
       	NumActivitiesToCreate = 0;
    }

    ActivityTemplate = Template;
	ActivityStates = class'XComGameState_LWAlienActivityManager'.static.GetAllActivities(NewGameState);
}

simulated function int GetNumActivitiesToCreate(XComGameState NewGameState, optional XComGameState_AdventChosen ChosenState = none)
{
    // Short Circuit this for if this isn't called by the Chosen Activity FN, so the activity doesn't get created normally.
    if(ChosenState == NONE)
    {
        return 0;
    }

	PrimaryRegions = FindValidRegions(NewGameState, ChosenState);

	NumActivitiesToCreate = Min(NumActivitiesToCreate, PrimaryRegions.Length);

	return NumActivitiesToCreate;
}

simulated function array<StateObjectReference> FindValidRegions(XComGameState NewGameState, optional XComGameState_AdventChosen ChosenState = none)
{
	local X2LWActivityCondition Condition;
	local XComGameStateHistory History;
	local array<StateObjectReference> ValidActivityRegions;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI	RegionalAI;
	local bool bValidRegion;
	
	History = `XCOMHISTORY;

	foreach Conditions(Condition)
	{
		if(!Condition.MeetsCondition(self, NewGameState))
		{
			return ValidActivityRegions;
		}
	}

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		bValidRegion = true;
		foreach Conditions(Condition)
		{
            //Commenting this part out so conditions get ignored for this one?
            /*
			if(!Condition.MeetsConditionWithRegion(self,  RegionState, NewGameState))
			{
				bValidRegion = false;
				break;
			} */
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);
			if(RegionalAI.RegionalCooldowns.Find('ActivityName', ActivityTemplate.DataName) != -1)
			{
				bValidRegion = false;
				break;
			}
			// LWoTC add - new condition for selecting from regions controlled by a specific Chosen.
			if(RegionState.GetControllingChosen()!= ChosenState && ChosenState != NONE)
			{
				bValidRegion = false;
				break;
			}
		}
		
		if(bValidRegion)
			ValidActivityRegions.AddItem(RegionState.GetReference());
	}

	return ValidActivityRegions;
}