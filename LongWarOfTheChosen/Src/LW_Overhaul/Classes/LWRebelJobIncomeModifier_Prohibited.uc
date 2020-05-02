//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier_Prohibited.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Income modifier for Prohibited Jobs
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_Prohibited extends LWRebelJobIncomeModifier
    config(LW_Outposts);

var name TestJob;

simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
	local int k;

	for (k = 0; k < OutPostState.ProhibitedJobs.length; k++)
	{
		If (OutPostState.ProhibitedJobs[k].job == TestJob)
			return 0.0f;
	}
	return 1.0f;
}

simulated function String GetDebugName()
{
    return "Prohibited Activity";
}

defaultproperties
{
    ApplyToExpectedIncome=true
}
