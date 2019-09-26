class X2LWActivityCondition_GeneralOpsCap extends X2LWActivityCondition config(LW_Activities);



var config array <int> MAX_GEN_OPS_PER_REGION_PER_MONTH;

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region, NewGameState);
	`LWTrACE ("Monthly GeneralOps Count" @ RegionalAI.GeneralOpsCount @ "compared to monthly cap" @ MAX_GEN_OPS_PER_REGION_PER_MONTH[`STRATEGYDIFFICULTYSETTING] * (ResistanceHQ.NumMonths +1));
	if (RegionalAI.GeneralOpsCount > MAX_GEN_OPS_PER_REGION_PER_MONTH[`STRATEGYDIFFICULTYSETTING] * (ResistanceHQ.NumMonths +1))
	{
		`LWTrACE ("Activity disallowed, General Ops Cap exceeded for" @ Region.GetDisplayName());
		return false;
	}
	return true;
}
