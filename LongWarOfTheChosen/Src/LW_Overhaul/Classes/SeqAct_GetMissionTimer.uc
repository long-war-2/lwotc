//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetMissionTimer
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: Get the current mission timer value.
//--------------------------------------------------------------------------------------- 

class SeqAct_GetMissionTimer extends SequenceAction;

// The number of turns to return to Kismet.
var private int Turns;

event Activated()
{
    local XComGameState_UITimer Timer;

    Timer = XComGameState_UITimer(`XCOMHISTORY.GetSingleGameStateObjectForClass(class 'XComGameState_UITimer', true));
    if (Timer == none)
    {
        `redscreen("No mission timer found!");
        return;
    }

    Turns = Timer.TimerValue;
}

defaultproperties
{
    ObjCategory="LWOverhaul"
    ObjName="Get Mission Timer"
    bConvertedForReplaySystem=true
    bAutoActivateOutputLinks=true

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Turns",PropertyName=Turns, bWriteable=true)
}
