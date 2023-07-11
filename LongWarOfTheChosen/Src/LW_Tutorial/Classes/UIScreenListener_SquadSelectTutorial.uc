//---------------------------------------------------------------------------------------
//	FILE:		UIScreenListener_SquadSelectTutorial
//	AUTHOR:		Peter Ledbrook
//	PURPOSE:	Pops up a tutorial box when viewing the squad select screen for
//              the first time.
//---------------------------------------------------------------------------------------

class UIScreenListener_SquadSelectTutorial extends UIScreenListener config(LW_Tutorial);

var localized string SquadSelectInfiltrationTitle;
var localized string SquadSelectInfiltrationBody;

event OnInit(UIScreen Screen)
{
	if (UISquadSelect(Screen) == none)
		return;

	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_SquadSelect'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_SquadSelect');

		// This tutorial box appears second, because the next tutorial box
		// is shown over it. In this case, we want to show the information
		// about mission expiry first, then about enemy numbers.
		`PRESBASE.UITutorialBox(
			default.SquadSelectInfiltrationTitle,
			default.SquadSelectInfiltrationBody,
			"img:///UILibrary_LWOTC.TutorialImages.LWSquad_Select_Infiltration");
	}
}

defaultproperties
{
	ScreenClass = none
}
