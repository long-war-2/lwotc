//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_HandleGatecrasherTutorialText
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Provides the appropriate objective text indices for the troop
//           column mission depending on whether it's Gatecrasher or not.
//--------------------------------------------------------------------------------------- 

class SeqAct_HandleGatecrasherTutorialText extends SequenceAction;

// The number of turns to return to Kismet.
var private int TitleIndex;
var private int BodyIndex;

event Activated()
{
	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_CampaignStart'))
	{
		TitleIndex = 4;
		BodyIndex = 5;
	}
}


defaultproperties
{
	ObjCategory="LWTutorial"
	ObjName="Update Gatecrasher Text"
    bConvertedForReplaySystem=true
    bAutoActivateOutputLinks=true

	TitleIndex=2
	BodyIndex=3
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Title Index",PropertyName=TitleIndex, bWriteable=true)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Body Index",PropertyName=BodyIndex, bWriteable=true)
}
