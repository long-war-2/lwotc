//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_MinLiberatedRegions
//  AUTHOR:  JohnnyLump / Pavonis Interactive
//	PURPOSE: Conditionals on the number of liberated regions
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_MinLiberatedRegions extends X2LWActivityCondition;



var int MaxAlienRegions;

simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState)
{
	
	//local int LiberatedRegions, NumRegions
	local int AlienRegions;
	local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	//LiberatedRegions = 0;
	AlienRegions = 0;
	//NumRegions = 0;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_WorldRegion', Region)
	{
		//NumRegions += 1;
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
		if (!RegionalAI.bLiberated)
		//{
			//LiberatedRegions += 1;
		//}
		//else
		{
			AlienRegions += 1;
		}
	}

	//`LWTrACE ("Foothold Test: Liberated:" @ string(LiberatedRegions) @ "MaxAlienRegions (to fire activity):" @ string (MaxAlienRegions) @ "NumRegions:" @ string (NumRegions));

	if (AlienRegions <= MaxAlienRegions)
		return true;

	return false;
}
