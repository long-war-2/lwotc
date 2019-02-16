//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_MinLiberatedRegions
//  AUTHOR:  JohnnyLump / Pavonis Interactive
//	PURPOSE: Conditionals on the number of days a region has been liberated
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_LiberatedDays extends X2LWActivityCondition;



var int MinLiberatedDays;

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local TDateTime CurrentTime;
	local int iDaysPassed;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
	if(RegionalAI.bLiberated)
	{
		CurrentTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
		iDaysPassed = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInDays(CurrentTime, RegionalAI.LastLiberationTime);
		if (iDaysPassed >= MinLiberatedDays)
			return true;
	}
	return false;
}