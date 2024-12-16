// Author: Tedster
// New ActivityCreation to allow for chosen created activities.
// Chosen will be passed in by direct calls to the below in the Chosen Action activated FN
// to directly create the activity and bypass the ActivityManager.

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
		`LWTrace("None Chosen supplied to GetNumActivitiesToCreate for Chosen version.");
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
		`LWTrace("Checkinng Region" @RegionState);
		bValidRegion = true;
		foreach Conditions(Condition)
		{
			`LWTrace("Checking Condition:" @Condition);
			if(!Condition.MeetsConditionWithRegion(self,  RegionState, NewGameState))
			{
				`LWTrace("Failed condition check");
				bValidRegion = false;
				break;
			} 
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);
			if(RegionalAI.RegionalCooldowns.Find('ActivityName', ActivityTemplate.DataName) != -1)
			{
				`LWTrace("Failed cooldown check");
				bValidRegion = false;
				break;
			}
			// LWoTC add - new condition for selecting from regions controlled by a specific Chosen.
			`LWTrace("Region Chosen:" @RegionState.GetControllingChosen().GetChosenTemplate().CharacterGroupName);
			`LWTrace("Chosen Activity chosen:" @ChosenState.GetChosenTemplate().CharacterGroupName);
			if(RegionState.GetControllingChosen().GetChosenTemplate().CharacterGroupName != ChosenState.GetChosenTemplate().CharacterGroupName && ChosenState != NONE)
			{
				`LWTrace("Failed controlling Chosen check");
				bValidRegion = false;
				break;
			}
		}
		
		if(bValidRegion)
			ValidActivityRegions.AddItem(RegionState.GetReference());
	}

	`LWTrace("Valid regions length:" @ValidActivityRegions.Length);
	return ValidActivityRegions;
}