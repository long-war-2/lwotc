//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_LinkObjects.uc
//  AUTHOR:  Furu -- 11/11/2025
//  PURPOSE: Adds/removes a gamestate object component to/from another gamestate object
//---------------------------------------------------------------------------------------

class SeqAct_LinkObjects extends SequenceAction;

var XComGameState_BaseObject ParentObject;
var XComGameState_BaseObject ChildObject;

event Activated()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("KISMET: Linking/unlinking gamestate objects");

	if(ParentObject != None && ChildObject != None)
	{
		ParentObject = NewGameState.ModifyStateObject(ParentObject.Class, ParentObject.ObjectID);
		ChildObject = NewGameState.ModifyStateObject(ChildObject.Class, ChildObject.ObjectID);

		if(InputLinks[0].bHasImpulse)
		{
			ParentObject.AddComponentObject(ChildObject);
		}
		else if(InputLinks[1].bHasImpulse)
		{
			ParentObject.RemoveComponentObject(ChildObject);
		}
	}

	if(NewGameState.GetNumGameStateObjects() > 0)
	{
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}
}

defaultproperties
{
	ObjCategory="Level"
	ObjName="Link Gamestate Objects"
	bCallHandler = false

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	bAutoActivateOutputLinks=true

	InputLinks(0)=(LinkDesc="Add")
	InputLinks(1)=(LinkDesc="Remove")

	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateObject',LinkDesc="Parent",PropertyName=ParentObject)
	VariableLinks(1)=(ExpectedType=class'SeqVar_GameStateObject',LinkDesc="Child",PropertyName=ChildObject)
}