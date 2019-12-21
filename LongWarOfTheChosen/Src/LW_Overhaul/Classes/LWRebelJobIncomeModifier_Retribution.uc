//---------------------------------------------------------------------------------------
//  FILE:   LWRebelJobIncomeModifier_Retribution.uc
//  AUTHOR:  Grobobobo/Based on X2RebelJobIncomeModifier_Prohibited
//	PURPOSE: Income modifier for Chosen Retribution activities
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_Retribution extends LWRebelJobIncomeModifier
    config(LW_Outposts);

var config float RETRIBUTION_MOD;
simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
    local int k;
    local float TotalMod;
    TotalMod=1;
	for (k = 0; k < OutPostState.CurrentRetributions.length; k++)
	{
        TotalMod*=RETRIBUTION_MOD;
	}
	return TotalMod;
}

simulated function String GetDebugName()
{
    return "Affected by Retribution";
}

defaultproperties
{
    ApplyToExpectedIncome=true
}
