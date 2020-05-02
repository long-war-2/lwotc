
//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier_Liberated.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Income modifier for liberated regions
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_Liberated extends LWRebelJobIncomeModifier
    config(LW_Outposts);

var config float LIBERATED_BONUS;

simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
    local XComGameState_WorldRegion WorldRegion;
    local XComGameState_WorldRegion_LWStrategyAI PrimaryRegionalAI;

    WorldRegion = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(OutpostState.Region.ObjectID));
    PrimaryRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(WorldRegion, none, false);

	if (PrimaryRegionalAI != none)
	{
		if (PrimaryRegionalAI.bLiberated)
		{
			return 1.0f + LIBERATED_BONUS;
		}
	}
    return 1.0;
}

simulated function String GetDebugName()
{
    return "Liberated Region";
}

defaultproperties
{
    ApplyToExpectedIncome=true
}

