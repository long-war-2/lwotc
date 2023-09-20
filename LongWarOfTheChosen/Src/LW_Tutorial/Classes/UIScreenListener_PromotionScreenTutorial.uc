//---------------------------------------------------------------------------------------
//	FILE:		UIScreenListener_PromotionScreenTutorial
//	AUTHOR:		Peter Ledbrook
//	PURPOSE:	Pops up a tutorial box when viewing the promotion screen for
//              the first time.
//---------------------------------------------------------------------------------------

class UIScreenListener_PromotionScreenTutorial extends UIScreenListener config(LW_Tutorial);

var localized string PistolAbilitiesTutorialTitle;
var localized string PistolAbilitiesTutorialBody;

event OnInit(UIScreen Screen)
{
	if (UIArmory_PromotionHero(Screen) == none)
		return;

	if (class'LWTutorial'.static.IsObjectiveInProgress('LW_TUT_PistolAbilities'))
	{
		class'LWTutorial'.static.CompleteObjective('LW_TUT_PistolAbilities');
		`PRESBASE.UITutorialBox(
			default.PistolAbilitiesTutorialTitle,
			default.PistolAbilitiesTutorialBody,
			"img:///UILibrary_LWOTC.TutorialImages.LWPistol_Abilities");

		// Showing the tutorial box hides the screen below it, but we actually want
		// the promotion screen to be visible behind the tutorial box. So we
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
