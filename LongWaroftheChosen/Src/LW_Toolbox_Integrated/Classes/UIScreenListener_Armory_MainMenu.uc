//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Armory_MainMenu
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Performs garbage collection on gamestates when dismissing units
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Armory_MainMenu extends UIScreenListener;

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen)
{
	//garbage collect officer states in case one was dismissed
	class'XComGameState_LWToolboxOptions'.static.RandomizedStatsGCandValidationChecks();
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIArmory_MainMenu;
}