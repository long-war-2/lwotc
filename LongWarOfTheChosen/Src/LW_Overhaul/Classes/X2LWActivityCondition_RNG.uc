//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_RNG.uc
//  AUTHOR:  JohnnyLump / Pavonis Interactive
//  PURPOSE: Conditional on a die rolled every activity check
//---------------------------------------------------------------------------------------

class X2LWActivityCondition_RNG extends X2LWActivityCondition;

var float CheckValue; // should be between 0 and 100;

simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState)
{
	local float RandValue;
	RandValue = `SYNC_FRAND() * 100.0;
	if (RandValue <= CheckValue)
		return true;

	return false;
}