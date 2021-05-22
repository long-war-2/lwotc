
//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ContinentBonus.uc
//  AUTHOR:  Peter Ledbrook
//
//  PURPOSE: Hides the continent bonus alert if Resistance Radio has not been
//           researched yet.
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ContinentBonus extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local UIAlert AlertScreen;

	AlertScreen = UIAlert(Screen);
	if (AlertScreen != none && AlertScreen.eAlertName == 'eAlert_ContinentBonus' &&
		!`XCOMHQ.IsTechResearched('ResistanceRadio'))
	{
		Screen.CloseScreen();
	}
}

defaultproperties
{
	// Leave this none and filter in the handlers to handle class overrides
	ScreenClass = none;
}
