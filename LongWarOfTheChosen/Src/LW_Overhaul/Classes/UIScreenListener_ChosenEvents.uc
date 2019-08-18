
//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ResistanceReport.uc
//  AUTHOR:  amineri / Pavonis Interactive
//
//  PURPOSE: Applies changes to UIResistanceReport
//
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ChosenEvents extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	
	if (!`SecondWaveEnabled('EnableChosen'))
	{
		Screen.CloseScreen();
	}
}

defaultproperties
{
	// Leave this none and filter in the handlers to handle class overrides
	ScreenClass = UIResistanceReport_ChosenEvents;
}