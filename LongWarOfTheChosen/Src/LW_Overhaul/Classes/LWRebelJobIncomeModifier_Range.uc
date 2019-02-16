//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier_Range.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//	PURPOSE: Income modifier that modifies income by applying a configurable range.
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_Range extends LWRebelJobIncomeModifier;

var float Min;
var float Max;

// Apply the income modifier: Given the input income, return an output income.
simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
    local float Mod;

    Mod = Min + (`SYNC_FRAND() * (Max - Min));
    return Mod;
}

simulated function String GetDebugName()
{
    return "Random(" $ Min $ ", " $ Max $ ")";
}