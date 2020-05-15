//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCreation.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Basic creation mechanics for alien activities
//---------------------------------------------------------------------------------------
class X2LWActivityCreation extends Object;



var array<StateObjectReference> PrimaryRegions;
var array<StateObjectReference> SecondaryRegions;

var array<X2LWActivityCondition> Conditions;

var protectedwrite array<XComGameState_LWAlienActivity> ActivityStates;
var protectedwrite X2LWAlienActivityTemplate ActivityTemplate;
var int NumActivitiesToCreate;

simulated function InitActivityCreation(X2LWAlienActivityTemplate Template, XComGameState NewGameState)
{
	NumActivitiesToCreate = 999;

	ActivityTemplate = Template;
	ActivityStates = class'XComGameState_LWAlienActivityManager'.static.GetAllActivities(NewGameState);
}

simulated function int GetNumActivitiesToCreate(XComGameState NewGameState)
{
	PrimaryRegions = FindValidRegions(NewGameState);

	NumActivitiesToCreate = Min(NumActivitiesToCreate, PrimaryRegions.Length);

	return NumActivitiesToCreate;
}

simulated function StateObjectReference GetBestPrimaryRegion(XComGameState NewGameState)
{
	local StateObjectReference SelectedRegion;

	SelectedRegion = FindBestPrimaryRegion(NewGameState);
	PrimaryRegions.RemoveItem(SelectedRegion);

	return SelectedRegion;
}

simulated function array<StateObjectReference> FindValidRegions(XComGameState NewGameState)
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
			if(!Condition.MeetsConditionWithRegion(self,  RegionState, NewGameState))
			{
				bValidRegion = false;
				break;
			}
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);
			if(RegionalAI.RegionalCooldowns.Find('ActivityName', ActivityTemplate.DataName) != -1)
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

simulated function StateObjectReference FindBestPrimaryRegion(XComGameState NewGameState)
{
	local StateObjectReference NullRef;

	if (PrimaryRegions.Length > 0)
	{
		return PrimaryRegions[`SYNC_RAND(PrimaryRegions.Length)];
	}
	return NullRef;
}

simulated function array<StateObjectReference> GetSecondaryRegions(XComGameState NewGameState, XComGameState_LWAlienActivity ActivityState);


function int LinkDistanceToClosestContactedRegion(XComGameState_WorldRegion FromRegion)
{
	local XComGameStateHistory History;
	local array<XComGameState_WorldRegion> arrSearchRegions;
	local XComGameState_WorldRegion RegionState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionState.ResistanceLevel >= eResLevel_Contact)
		{
			arrSearchRegions.AddItem(RegionState);
		}
	}

	return FromRegion.FindClosestRegion(arrSearchRegions, RegionState);
}