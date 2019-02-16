//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SetInteractiveObjectHacked.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Set an interactive object as being hacked.
//---------------------------------------------------------------------------------------

class SeqAct_SetInteractiveObjectHacked extends SequenceAction;

var XComGameState_InteractiveObject InteractiveObject;

event Activated()
{
    local XComGameState NewGameState;
    local XComGameState_InteractiveObject NewInteractiveObject;

    if (InteractiveObject != none)
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SeqAct_SetInteractiveObjectHacked: " @ InteractiveObject.GetVisualizer() @ " (" @ InteractiveObject.ObjectID @ ")");
        NewInteractiveObject = XComGameState_InteractiveObject(NewGameState.CreateStateObject(class'XComGameState_InteractiveObject', InteractiveObject.ObjectID));
        NewInteractiveObject.bHasBeenHacked = true;
        NewGameState.AddStateObject(NewInteractiveObject);
        `TACTICALRULES.SubmitGameState(NewGameState);
    }
}

defaultproperties
{
    ObjName="Set Interactive Object Hacked"
    ObjCategory="LWOverhaul"
    bConvertedForReplaySystem=true
    bCanBeUsedForGameplaySequence=true

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Interactive Object",PropertyName=InteractiveObject,bWriteable=false)
}
