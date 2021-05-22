//---------------------------------------------------------------------------------------
//	FILE:		UIScreenListener_CovertActionsTutorial
//	AUTHOR:		Peter Ledbrook
//	PURPOSE:	Pops up a tutorial box when viewing the covert actions screen for
//              the first time.
//---------------------------------------------------------------------------------------

class UIScreenListener_CovertActionsTutorial extends UIScreenListener config(LW_Tutorial);

var localized string CovertActionsTutorialTitle;
var localized string CovertActionsTutorialBody;

event OnInit(UIScreen Screen)
{
	if (UICovertActions(Screen) == none)
		return;

	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_CovertActions'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_CovertActions');
		`PRESBASE.UITutorialBox(
			default.CovertActionsTutorialTitle,
			default.CovertActionsTutorialBody,
			"img:///UILibrary_LW_Overhaul.TutorialImages.LWCovert_Actions_Failure");

		// Showing the tutorial box hides the screen below it, but we actually want
		// the covert actions screen to be visible behind the tutorial box. So we
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
