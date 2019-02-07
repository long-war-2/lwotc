//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_UIAlert
//  AUTHOR:  Amineri
//
//  PURPOSE: Listen for BuildTrainingCompleteAlert and hide Button1 if in expanded version of promotion
//--------------------------------------------------------------------------------------- 

class UIScreenListener_UIAlert extends UIScreenListener;

delegate OnMouseEventDelegate(UIPanel Panel, int Cmd);

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local UIAlert Alert;
	`Log("Initializing UIScreenListener_UIAlert");

	Alert = UIAlert(Screen);

	if(Alert == none)
		return;

	if(Alert.eAlertName == 'eAlert_SoldierPromoted')
	{
		if(Alert.Movie.Pres.ScreenStack.IsInStack(class'UIArmory_LWExpandedPromotion'))
			Alert.Button1.Hide();
	}

}

//This event is triggered after a screen receives focus
//event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen)

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIAlert;
}
