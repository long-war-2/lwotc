//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_LiberationStage.uc
//  AUTHOR:  JL / Pavonis Interactive
//	PURPOSE: Conditionals on the LiberationStage of the region
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_LiberationStage extends X2LWActivityCondition;



var bool NoStagesComplete;
var bool Stage1Complete;
var bool Stage2Complete;

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
	
	//`LWTrACE ("X2LWActivityCondition_LiberationStage" @ Region.GetMyTemplateName() @ "Checking:" @ NoStagesComplete @ Stage1Complete @ Stage2Complete @ "Status:" @ RegionalAI.LiberateStage1Complete @ RegionalAI.LiberateStage2Complete);

	if (NoStagesComplete && !RegionalAI.LiberateStage1Complete && !RegionalAI.LiberateStage2Complete)
	{
		`LWTrACE("ProtectRegionEarly Liberation Stage condition met in " $ Region.GetMyTemplateName());
		return true;
	}
	if (!NoStagesComplete && Stage1Complete && RegionalAI.LiberateStage1Complete && !Stage2Complete && !RegionalAI.LiberateStage2Complete)
	{
		`LWTrACE("ProtectRegionMid Liberation Stage condition met in " $ Region.GetMyTemplateName());
		return true;
	}
	if (!NoStagesComplete && Stage2Complete && RegionalAI.LiberateStage2Complete)
	{
		//`LWTrACE("ProtectRegion (final) Liberation Stage condition met in " $ Region.GetMyTemplateName());
		return true;
	}

	//`LWTrACE ("X2LWActivityCondition_LiberationStage returning false");

	return false;
}