//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SetInteractiveObjectHacked.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Tests whether an interactive object has been hacked.
//---------------------------------------------------------------------------------------

class SeqAct_GetInteractiveObjectHacked extends SequenceAction;

var XComGameState_InteractiveObject InteractiveObject;
var bool HasBeenHacked;

event Activated()
{
    local XComGameState_InteractiveObject LatestInteractiveObject;

    OutputLinks[0].bHasImpulse = false;
    OutputLinks[1].bHasImpulse = false;
    OutputLinks[2].bHasImpulse = false;

    if (InteractiveObject == None)
    {
        OutputLinks[0].bHasImpulse = true;
    }
    else
    {
        LatestInteractiveObject = XComGameState_InteractiveObject(`XCOMHISTORY.GetGameStateForObjectID(InteractiveObject.ObjectID));
        HasBeenHacked = LatestInteractiveObject.bHasBeenHacked;
        if (HasBeenHacked)
        {
            OutputLinks[2].bHasImpulse = true;
        }
        else
        {
            OutputLinks[1].bHasImpulse = true;
        }
    }
}

defaultproperties
{
    ObjName="Get Interactive Object Hacked"
    ObjCategory="LWOverhaul"
    bConvertedForReplaySystem=true
    bCanBeUsedForGameplaySequence=true
    bAutoActivateOutputLinks=false
    OutputLinks(0)=(LinkDesc="None")
    OutputLinks(1)=(LinkDesc="False")
    OutputLinks(2)=(LinkDesc="True")

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Interactive Object",PropertyName=InteractiveObject,bWriteable=false)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Bool',LinkDesc="HasBeenHacked",PropertyName=HasBeenHacked,bWriteable=true)
}
