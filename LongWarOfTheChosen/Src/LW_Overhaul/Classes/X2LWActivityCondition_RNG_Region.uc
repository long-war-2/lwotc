//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_RNG_Region.uc
//  AUTHOR:  JohnnyLump / Pavonis Interactive
//	PURPOSE: Conditional on a die rolled every check
//---------------------------------------------------------------------------------------

class X2LWActivityCondition_RNG_Region extends X2LWActivityCondition config(LW_Activities);



var float Multiplier; 
var bool UseAlert; // if false, use vigilance
var bool UseRebelsOnJobValue;
var bool UseFaceless; // each Facless at outpost adds X% to chance
var bool Invasion; // if an invasion, just use the multipler as the baseline
var int StandardRebelCount;	// This is the value we measure the current number of rebels against to modify the chance for this to occur
var name RebelJob;
var config array<float> FACELESS_ROLL_MODIFIER; // added ability to make this vary by difficulty

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local float RandValue;
	local float CheckValue;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local XComGameState_LWOutpostManager			OutPostManager;
	local XComGameState_LWOutpost					OutPostState;

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
	
	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	OutpostState = OutpostManager.GetOutpostForRegion(Region);

	`LWTRACE ("Attempting to Create Retal/Invasion via RNG" @ ActivityCreation.ActivityTemplate.ActivityName);

	If(RegionalAI != none)
	{
		if (Invasion)
		{
			CheckValue = Multiplier;
		}
		else
		{
			if (UseAlert)
			{
				CheckValue = RegionalAI.LocalAlertLevel * Multiplier;
			}
			else
			{
				CheckValue = RegionalAI.LocalVigilanceLevel * Multiplier;
			}
		}

		if (UseRebelsOnJobValue)
		{
			CheckValue *= (float(OutPostState.GetNumRebelsOnJob(RebelJob)) / float(StandardRebelCount));
		}

		if (UseFaceless)
		{
			CheckValue += OutPostState.GetNumFaceless() * default.FACELESS_ROLL_MODIFIER[`STRATEGYDIFFICULTYSETTING];
		}

		RandValue = `SYNC_FRAND() * 100.0;
		if (RandValue <= CheckValue)
		{
			`LWTRACE (ActivityCreation.ActivityTemplate.ActivityName @ "Retal passes RNG roll");
			return true;
		}
		else
		{
			`LWTRACE (ActivityCreation.ActivityTemplate.ActivityName @ "fails RNG roll" @ string (RandValue) @ string (CheckValue));
		}
	}

	return false;
}