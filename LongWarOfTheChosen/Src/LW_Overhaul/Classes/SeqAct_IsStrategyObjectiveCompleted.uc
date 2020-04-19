///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_IsStrategyObjectiveCompleted.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Action to determine if a strategy objective has been completed yet.
//----------------------------------------------------------------------------------------

class SeqAct_IsStrategyObjectiveCompleted extends SequenceAction;

var() Name ObjectiveName;

event Activated()
{
	if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted(ObjectiveName))
	{
		OutputLinks[0].bHasImpulse = true;   // Yes!
		OutputLinks[1].bHasImpulse = false;
	}
	else
	{
		OutputLinks[0].bHasImpulse = false;
		OutputLinks[1].bHasImpulse = true;   // No!
	}
}

defaultproperties
{
	ObjName="Is Strat Objective Completed?"
	ObjCategory="LWOverhaul"
	bCallHandler=false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")
}
