//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier_DiminishingSupplies.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//	PURPOSE: Income modifier for Liberated regions
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_DiminishingSupplies extends LWRebelJobIncomeModifier;

simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
	local float DiminishingReturns;

	if (OutpostState.SuppliesTaken <= OutpostState.SupplyCap)
	{
		DiminishingReturns = 1.0f;
	}
	else
	{
		if (OutPostState.SuppliesTaken > 2 * OutPostState.SupplyCap)
		{
			DiminishingReturns = 0.5f;
		}
		else
		{
			DiminishingReturns = float (OutPostState.SupplyCap) / float (OutPostState.SuppliesTaken);
		}
	}

	return fclamp (DiminishingReturns, 0.5, 1.0);
}

simulated function String GetDebugName()
{
    return "Diminishing Returns";
}

defaultproperties
{
    ApplyToExpectedIncome=true
}
