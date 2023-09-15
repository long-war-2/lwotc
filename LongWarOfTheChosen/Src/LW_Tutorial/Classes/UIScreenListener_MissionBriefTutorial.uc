//---------------------------------------------------------------------------------------
//	FILE:		UIScreenListener_MissionBriefTutorial
//	AUTHOR:		Peter Ledbrook
//	PURPOSE:	Pops up a tutorial box when viewing the mission brief screen for
//              the first time.
//---------------------------------------------------------------------------------------

class UIScreenListener_MissionBriefTutorial extends UIScreenListener config(LW_Tutorial);

var localized string MissionBriefTutorialTitle;
var localized string MissionBriefTutorialBody;

var localized string MissionEnemyCountTitle;
var localized string MissionEnemyCountBody;

event OnInit(UIScreen Screen)
{
	if (UIMission_LWCustomMission(Screen) == none)
		return;

	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_FirstMissionBrief'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_FirstMissionBrief');

		// This tutorial box appears second, because the next tutorial box
		// is shown over it. In this case, we want to show the information
		// about mission expiry first, then about enemy numbers.
		`PRESBASE.UITutorialBox(
			default.MissionEnemyCountTitle,
			default.MissionEnemyCountBody,
			"img:///UILibrary_LW_Overhaul.TutorialImages.LWMission_Numbers");

		`PRESBASE.UITutorialBox(
			default.MissionBriefTutorialTitle,
			default.MissionBriefTutorialBody,
			"img:///UILibrary_LW_Overhaul.TutorialImages.LWMission_Brief");

		// Showing the tutorial box hides the screen below it, but we actually want
		// the mission brief screen to be visible behind the tutorial box. So we
		// manually show it.
		if (!Screen.bIsVisible)
		{
			Screen.Show();
		}
	}
}

defaultproperties
{
	ScreenClass = none
}
