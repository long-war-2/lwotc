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
	local UIStrategyMap StrategyMapScreen;
	local UIStrategyMapItem_Region_LW SelectedRegionMapItem;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;
	bHandled = true;

	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	switch (cmd)
	{
		// KDM : X button brings up either : 
		// 1.] The selected haven's rebel screen, if a haven is selected. 
		// 2.] The resistance management screen.
		//
		// This needs to be done because the highlander deals with input before UIStrategyMap gets a chance; however, if a haven is selected,
		// we want the input piped through UIStrategyMap down to the selected haven map item.
		case class'UIUtilities_Input'.const.FXS_BUTTON_X:
			StrategyMapScreen = UIStrategyMap(Screen);
			SelectedRegionMapItem = UIStrategyMapItem_Region_LW(StrategyMapScreen.SelectedMapItem);
			if (SelectedRegionMapItem != none && SelectedRegionMapItem.OutpostButton.bIsVisible)
			{
				// KDM : Make sure OnUnrealCommand() is called on the strategy map, which will then forward it onto the selected haven map item.
				bHandled = false;
			}
			else
			{
				if (!HQPres.ScreenStack.HasInstanceOf(class'UIResistanceManagement_LW'))
				{
					ResistanceOverviewScreen = HQPres.Spawn(class'UIResistanceManagement_LW', HQPres);
					ResistanceOverviewScreen.EnableCameraPan = false;
					HQPres.ScreenStack.Push(ResistanceOverviewScreen);
				}
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

