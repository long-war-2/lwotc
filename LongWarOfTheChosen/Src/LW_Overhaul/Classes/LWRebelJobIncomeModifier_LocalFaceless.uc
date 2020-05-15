//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier_LocalFaceless.uc
//  AUTHOR:  amineri / Pavonis Interactive
//  PURPOSE: Income modifier that depends on the number of faceless at the outpost
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_LocalFaceless extends LWRebelJobIncomeModifier config(LW_Outposts);

var config array<float> PCT_PENALTY_PER_FACELESS;

// Apply the income modifier: Given the input income, return an output income.
simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
    local float Mod;

    Mod = 1.0 - PCT_PENALTY_PER_FACELESS[`STRATEGYDIFFICULTYSETTING] * OutpostState.GetNumFaceless();
    return FClamp(Mod, 0.0, 1.0);
}

simulated function String GetDebugName()
{
    return "LocalFaceless";
}