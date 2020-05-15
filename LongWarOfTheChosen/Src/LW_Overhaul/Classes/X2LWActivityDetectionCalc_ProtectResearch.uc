//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityDetectionCalc_ProtectResearch.uc
//  AUTHOR:  JL / Pavonis Interactive
//  PURPOSE: Adds additional detection chance if facility is in the region, even more if it's also liberated
//---------------------------------------------------------------------------------------
class X2LWActivityDetectionCalc_ProtectResearch extends X2LWActivityDetectionCalc;

function float GetDetectionChance(XComGameState_LWAlienActivity ActivityState, X2LWAlienActivityTemplate ActivityTemplate, XComGameState_LWOutpost OutpostState)
{
	local float DetectionChance;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI	RegionalAI;

	DetectionChance = super.GetDetectionChance(ActivityState, ActivityTemplate, OutpostState);

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(GetRegion(ActivityState));

	// If there's a local Research facility, grant a bonus
	if(RegionalAI.bHasResearchFacility)
	{
		DetectionChance *= 1.5;
	}

	// for each hidden facility in a liberated region, have more bonuses
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);

		if (RegionalAI.bLiberated && RegionalAI.bHasResearchFacility)
		{
			DetectionChance *= 1.5;
		}
	}

	return DetectionChance;
}
