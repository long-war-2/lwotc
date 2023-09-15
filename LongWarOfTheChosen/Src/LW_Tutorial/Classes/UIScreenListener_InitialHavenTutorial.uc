//---------------------------------------------------------------------------------------
//	FILE:		UIScreenListener_InitialHavenTutorial
//	AUTHOR:		Peter Ledbrook
//	PURPOSE:	Pops up a tutorial box to give an overview of havens.
//---------------------------------------------------------------------------------------

class UIScreenListener_InitialHavenTutorial extends UIScreenListener config(LW_Tutorial);

var localized string HavenHighlightTitle;
var localized string HavenHighlightBody;

event OnRemoved(UIScreen Screen)
{
	if (UIFactionPopup(Screen) == none)
		return;

	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_HavenOnGeoscape'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_HavenOnGeoscape');
		`PRESBASE.UITutorialBox(
			default.HavenHighlightTitle,
			default.HavenHighlightBody,
			"img:///UILibrary_LWOTC.TutorialImages.LWHaven_Map_Icon");
	}
}

defaultproperties
{
	ScreenClass = none
}
