
//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ChosenEvents.uc
//  AUTHOR:  Peter Ledbrook
//
//  PURPOSE: Hides the Chosen and Resistance Order end-of-month screens if those
//           features aren't enabled in the campaign.
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ChosenEvents extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	if (UIResistanceReport_ChosenEvents(Screen) != none && !`SecondWaveEnabled('EnableChosen'))
	{
		Screen.CloseScreen();
	}

	if (UIStrategyPolicy(Screen) != none && UIStrategyPolicy(Screen).bResistanceReport &&
			!class'Helpers_LW'.static.AreResistanceOrdersEnabled())
	{
		Screen.CloseScreen();
	}
}

defaultproperties
{
	// Leave this none and filter in the handlers to handle class overrides
	ScreenClass = none;
}
