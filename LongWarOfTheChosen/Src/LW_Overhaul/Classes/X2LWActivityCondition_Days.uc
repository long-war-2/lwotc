class X2LWActivityCondition_Days extends X2LWActivityCondition;

var array<int> FirstDayPossible;

simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState)
{
	local TDateTime GameStartDate, CurrentDate;
	local float TimeDiffHours;
	local int TimeToDays;

	class'X2StrategyGameRulesetDataStructures'.static.SetTime( GameStartDate, 0, 0, 0,
	class'X2StrategyGameRulesetDataStructures'.default.START_MONTH,
	class'X2StrategyGameRulesetDataStructures'.default.START_DAY,
	class'X2StrategyGameRulesetDataStructures'.default.START_YEAR );
	CurrentDate = `STRATEGYRULES.GameTime;

	TimeDiffHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours( CurrentDate, GameStartDate );

	TimeToDays = Round( TimeDiffHours / 24.0f );

	if (TimeToDays >= FirstDayPossible[`STRATEGYDIFFICULTYSETTING])
		return true;

	return false;
}

