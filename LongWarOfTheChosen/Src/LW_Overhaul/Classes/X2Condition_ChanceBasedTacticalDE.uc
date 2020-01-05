//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_ChanceBasedTacticalDE.uc
//  AUTHOR:  Peter Ledbrook
//	PURPOSE: Conditional on a die rolled at the start of tactical combat. Designed for
//           Tactical Dark Events that apply abilities to enemy unit based on chance.
//---------------------------------------------------------------------------------------

class X2Condition_ChanceBasedTacticalDE extends X2Condition;

var int SuccessChance; // should be between 0 and 100;

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
	local float RandValue;

	if (bStrategyCheck) return false;

	RandValue = `SYNC_FRAND() * 100.0;
	if (RandValue < SuccessChance || SuccessChance == 100)
		return true;

	return false;
}
