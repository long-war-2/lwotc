// Author: Tedster
// Purpose: remove the "Chosen Controls Area" overlay for missions without chosen.

class UIScreenListener_MissionChosenPanel extends UIScreenListener;

event OnInit(UIScreen Screen)
{
    local XComGameState_MissionSite MissionSite;
   // `LOG("Screen initialized:" @ Screen.Class.Name,, 'UISL');

    if(UIMission(Screen) == none)
        return;

    MissionSite = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(UIMission(Screen).MissionRef.ObjectID));

    if(MissionSite.GeneratedMission.SitReps.Find('ChosenOnMissionSitrep') == INDEX_NONE)
    {
        UIMission(Screen).ChosenPanel.Hide();
    }

}
