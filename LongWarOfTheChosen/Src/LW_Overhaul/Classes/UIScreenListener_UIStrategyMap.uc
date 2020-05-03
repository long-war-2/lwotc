//---------------------------------------------------------------------------------------
//	FILE:		UIScreenListener_UIStrategyMap
//	AUTHOR:		KDM
//	PURPOSE:	Allow controller users to bring up the Resistance overview screen from the strategy map
//--------------------------------------------------------------------------------------- 

class UIScreenListener_UIStrategyMap extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	HQPres.ScreenStack.SubscribeToOnInputForScreen(Screen, OnUIStrategyMapCommand);
}

event OnRemoved(UIScreen Screen)
{
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	HQPres.ScreenStack.UnsubscribeFromOnInputForScreen(Screen, OnUIStrategyMapCommand);
}

simulated protected function bool OnUIStrategyMapCommand(UIScreen Screen, int cmd, int arg)
{
	local bool bHandled;
	local UIResistanceManagement_LW ResistanceOverviewScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;
	bHandled = true;

	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	switch (cmd)
	{
		// KDM : X button brings up the Resistance overview screen
		case class'UIUtilities_Input'.const.FXS_BUTTON_X:
			if (!HQPres.ScreenStack.HasInstanceOf(class'UIResistanceManagement_LW'))
			{
				ResistanceOverviewScreen = HQPres.Spawn(class'UIResistanceManagement_LW', HQPres);
				ResistanceOverviewScreen.EnableCameraPan = false;
				HQPres.ScreenStack.Push(ResistanceOverviewScreen);
			}
			break;

		default:
			bHandled = false;
			break;
	}

	return bHandled;
}

defaultProperties
{
	ScreenClass = UIStrategyMap;
}

