//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetMissionInfo.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Gets info about the the current mission, currently only alert
//---------------------------------------------------------------------------------------


class SeqAct_GetMissionInfo extends SequenceAction;

var int MissionAlertLevel;



event Activated()
{
    local XComGameState_MissionSite Mission;
    local XComGameStateHistory History;

    History = `XCOMHISTORY;
    Mission = XComGameState_MissionSite(History.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));

    MissionAlertLevel = Mission.SelectedMissionData.AlertLevel;
    //`RedScreen("SeqAct_GetMissionInfo: This is alert level given to kismet: " $ Mission.SelectedMissionData.AlertLevel);
}

defaultproperties
{
	ObjCategory="LWOverhaul"
	ObjName="Get Mission Info"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Alert Level",PropertyName=MissionAlertLevel,bWriteable=true)
}
