//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_AlertVigilance.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Conditionals on the Alert and Vigilance levels of the region
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_AlertVigilance extends X2LWActivityCondition;

var int MinVigilance;
var int MaxVigilance;
var int MinAlert;
var int MaxAlert;

var int MinAlertVigilanceDiff;
var int MaxAlertVigilanceDiff;

var int MinVigilance_Global;
var int MaxVigilance_Global;
var int MinAlert_Global;
var int MaxAlert_Global;

var int MinAlertVigilanceDiff_Global;
var int MaxAlertVigilanceDiff_Global;

simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion Region;
	local bool bMeetsCondition;
	local int AlertVigilanceDiff, SumAlert, SumVigilance;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	bMeetsCondition = true;
	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_WorldRegion', Region)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
		if(!RegionalAI.bLiberated)
		{
			SumAlert += RegionalAI.LocalAlertLevel;
			SumVigilance += RegionalAI.LocalVigilanceLevel;
		}
	}
	AlertVigilanceDiff = SumAlert - SumVigilance;

	if(MinAlert_Global > 0 && SumAlert < MinAlert_Global)
		bMeetsCondition = false;
	else if(MaxAlert_Global> 0 && SumAlert > MaxAlert_Global)
		bMeetsCondition = false;
	else if(MinVigilance_Global > 0 && SumVigilance < MinVigilance_Global)
		bMeetsCondition = false;
	else if(MaxVigilance_Global> 0 && SumVigilance > MaxVigilance_Global)
		bMeetsCondition = false;
	else if(AlertVigilanceDiff < MinAlertVigilanceDiff_Global)
		bMeetsCondition = false;
	else if(AlertVigilanceDiff > MaxAlertVigilanceDiff_Global)
		bMeetsCondition = false;

	return bMeetsCondition;
}

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local bool bMeetsCondition;
	local int AlertVigilanceDiff;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	bMeetsCondition = true;

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
	AlertVigilanceDiff = RegionalAI.LocalAlertLevel - RegionalAI.LocalVigilanceLevel;

	if(RegionalAI.LocalAlertLevel < MinAlert || (ActivityCreation.ActivityTemplate.MinAlert > 0 && RegionalAI.LocalAlertLevel < ActivityCreation.ActivityTemplate.MinAlert))
		bMeetsCondition = false;
	else if(RegionalAI.LocalAlertLevel > MaxAlert || (ActivityCreation.ActivityTemplate.MaxAlert > 0 && RegionalAI.LocalAlertLevel > ActivityCreation.ActivityTemplate.MaxAlert))
		bMeetsCondition = false;
	else if(RegionalAI.LocalVigilanceLevel < MinVigilance || (ActivityCreation.ActivityTemplate.MinVigilance > 0 && RegionalAI.LocalVigilanceLevel < ActivityCreation.ActivityTemplate.MinVigilance))
		bMeetsCondition = false;
	else if(RegionalAI.LocalVigilanceLevel > MaxVigilance || (ActivityCreation.ActivityTemplate.MaxVigilance > 0 && RegionalAI.LocalVigilanceLevel > ActivityCreation.ActivityTemplate.MaxVigilance))
		bMeetsCondition = false;
	else if(AlertVigilanceDiff < MinAlertVigilanceDiff)
		bMeetsCondition = false;
	else if(AlertVigilanceDiff > MaxAlertVigilanceDiff)
		bMeetsCondition = false;


	return bMeetsCondition;
}


defaultProperties
{
	MinVigilance=0
	MaxVigilance=9999
	MinAlert=0
	MaxAlert=9999

	MinAlertVigilanceDiff=-9999
	MaxAlertVigilanceDiff=9999

	MinVigilance_Global=0
	MaxVigilance_Global=9999
	MinAlert_Global=0
	MaxAlert_Global=9999

	MinAlertVigilanceDiff_Global=-9999
	MaxAlertVigilanceDiff_Global=9999
}