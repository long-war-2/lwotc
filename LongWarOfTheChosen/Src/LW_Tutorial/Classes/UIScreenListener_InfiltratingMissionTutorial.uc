//---------------------------------------------------------------------------------------
//	FILE:		UIScreenListener_InfiltratingMissionTutorial
//	AUTHOR:		Peter Ledbrook
//	PURPOSE:	Pops up a tutorial box when viewing the mission infiltration screen for
//              the first time.
//---------------------------------------------------------------------------------------

class UIScreenListener_InfiltratingMissionTutorial extends UIScreenListener config(LW_Tutorial);

var localized string InfiltratingMissionTitle;
var localized string InfiltratingMissionBody;

event OnInit(UIScreen Screen)
{
	if (UIMission_LWLaunchDelayedMission(Screen) == none)
		return;

	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_InfiltratingMission'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_InfiltratingMission');

		// This tutorial box appears second, because the next tutorial box
		// is shown over it. In this case, we want to show the information
		// about mission expiry first, then about enemy numbers.
		`PRESBASE.UITutorialBox(
			default.InfiltratingMissionTitle,
			default.InfiltratingMissionBody,
			"img:///UILibrary_LWOTC.TutorialImages.LWInfiltrating_Mission");

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
