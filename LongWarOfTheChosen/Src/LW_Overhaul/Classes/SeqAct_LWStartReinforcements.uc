//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_LWStartReinforcements.uc
//  AUTHOR:  Peter Ledbrook (LWOTC)
//  PURPOSE: Used for externally triggered reinforcements (for example RNFs that start
//           after a timer has run out) to start the reinforcement drops.
//---------------------------------------------------------------------------------------
class SeqAct_LWStartReinforcements extends SequenceAction config(LW_Overhaul);

event Activated()
{
    local XComGameState_LWReinforcements Reinforcements;
    local XComGameState NewGameState;

    Reinforcements = XComGameState_LWReinforcements(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWReinforcements', true));
    if (Reinforcements == none)
        return;

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Start reinforcement drops");
    Reinforcements = XComGameState_LWReinforcements(NewGameState.ModifyStateObject(class'XComGameState_LWReinforcements', Reinforcements.ObjectID));
	Reinforcements.StartReinforcements();
    `TACTICALRULES.SubmitGameState(NewGameState);
}

defaultproperties
{
    ObjCategory="LWOverhaul"
    ObjName="(Long War) Start Reinforcements"
    bConvertedForReplaySystem=true

    VariableLinks.Empty
}
