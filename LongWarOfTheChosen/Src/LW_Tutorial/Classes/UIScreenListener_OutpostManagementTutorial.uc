//---------------------------------------------------------------------------------------
//	FILE:		UIScreenListener_OutpostManagementTutorial
//	AUTHOR:		Peter Ledbrook
//	PURPOSE:	Pops up a tutorial box when viewing a haven for the first time.
//---------------------------------------------------------------------------------------

class UIScreenListener_OutpostManagementTutorial extends UIScreenListener config(LW_Tutorial);

var localized string HavenManagementTitle;
var localized string HavenManagementBody;

event OnInit(UIScreen Screen)
{
	if (UIOutpostManagement(Screen) == none)
		return;

	if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('LW_TUT_HavenManagement') == eObjectiveState_InProgress)
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_HavenManagement');
		`PRESBASE.UITutorialBox(
			default.HavenManagementTitle,
			default.HavenManagementBody,
			"img:///UILibrary_LW_Overhaul.TutorialImages.LWHaven_Management");

		// Showing the tutorial box hides the screen below it, but we actually want
		// the haven management screen to be visible behind the tutorial box. So we
		// manually show it.
		if (!Screen.bIsVisible)
		{
			Screen.Show();
		}
	}
}

event OnLoseFocus(UIScreen Screen)
{
}

defaultproperties
{
    ScreenClass = none
}
