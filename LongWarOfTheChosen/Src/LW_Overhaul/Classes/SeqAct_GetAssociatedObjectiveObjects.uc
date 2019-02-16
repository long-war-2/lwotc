//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetAssociatedObjectiveObjects.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Locate all the interactive objects that are associated with objectives.
//           Basically, look for all the locked doors associated with the strategy game.
//---------------------------------------------------------------------------------------

class SeqAct_GetAssociatedObjectiveObjects extends SequenceAction;

var XComGameState_InteractiveObject InteractiveObject1;
var XComGameState_InteractiveObject InteractiveObject2;
var XComGameState_InteractiveObject InteractiveObject3;
var XComGameState_InteractiveObject InteractiveObject4;
var XComGameState_InteractiveObject InteractiveObject5;
var XComGameState_InteractiveObject InteractiveObject6;
var int NumAvailable;

event Activated()
{
	local XComGameState_InteractiveObject InteractiveObject;
	local XComGameStateHistory History;

	History  = `XCOMHISTORY;

	NumAvailable = 0;
	foreach History.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
	{
		if (InteractiveObject.bOffersStrategyHackRewards && InteractiveObject.MustBeHacked())
		{
			SetItem(InteractiveObject, NumAvailable);
			++NumAvailable;
		}
	}
}

function SetItem(XComGameState_InteractiveObject InteractiveObject, int index)
{
	switch(index)
	{
		case 5:
			InteractiveObject6 = InteractiveObject;
			break;
		case 4:
			InteractiveObject5 = InteractiveObject;
			break;
		case 3:
			InteractiveObject4 = InteractiveObject;
			break;
		case 2:
			InteractiveObject3 = InteractiveObject;
			break;
		case 1:
			InteractiveObject2 = InteractiveObject;
			break;
		case 0:
			InteractiveObject1 = InteractiveObject;
			break;
	}
}

defaultproperties
{
	ObjName="Get Associated Objective Actors"
	ObjCategory="LWOverhaul"
	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="AssociatedObject1",PropertyName=InteractiveObject1,bWriteable=true)
	VariableLinks(1)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="AssociatedObject2",PropertyName=InteractiveObject2,bWriteable=true)
	VariableLinks(2)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="AssociatedObject3",PropertyName=InteractiveObject3,bWriteable=true)
	VariableLinks(3)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="AssociatedObject4",PropertyName=InteractiveObject4,bWriteable=true)
	VariableLinks(4)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="AssociatedObject5",PropertyName=InteractiveObject5,bWriteable=true)
	VariableLinks(5)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="AssociatedObject6",PropertyName=InteractiveObject6,bWriteable=true)
	VariableLinks(6)=(ExpectedType=class'SeqVar_Int',LinkDesc="NumAvailable",PropertyName=NumAvailable,bWriteable=true)
}
