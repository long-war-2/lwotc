//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_LWTutorialIsActive
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Check whether the LWOTC tutorial is enabled.
//--------------------------------------------------------------------------------------- 

class SeqAct_LWTutorialIsActive extends SequenceAction;

event Activated()
{
	if (!`SecondWaveEnabled('DisableTutorial'))
	{
		OutputLinks[0].bHasImpulse = true;
		OutputLinks[1].bHasImpulse = false;
	}
	else
	{
		OutputLinks[0].bHasImpulse = false;
		OutputLinks[1].bHasImpulse = true;
	}
}


defaultproperties
{
	ObjCategory="LWTutorial"
	ObjName="Is Tutorial Active"
	bConvertedForReplaySystem=true

	VariableLinks.Empty
	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Yes")
	OutputLinks(1)=(LinkDesc="No")
}
