///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_IsSWOActive.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Action to determine if a second wave option is active or not.
//----------------------------------------------------------------------------------------

class SeqAct_IsSWOActive extends SequenceAction;

var() Name OptionName;

event Activated()
{
	if (`SecondWaveEnabled(OptionName))
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
	ObjName="Is SWO Active?"
	ObjCategory="LWOverhaul"
	bCallHandler=false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")
}
