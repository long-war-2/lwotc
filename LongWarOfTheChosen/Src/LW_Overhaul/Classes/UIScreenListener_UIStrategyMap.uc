//---------------------------------------------------------------------------------------
//	FILE:		UIScreenListener_UIStrategyMap
//	AUTHOR:		KDM
//	PURPOSE:	Provides additional functionality, on the strategy map, for controller users.
//---------------------------------------------------------------------------------------

class UIScreenListener_UIStrategyMap extends UIScreenListener config(LW_UI);

var config bool CYCLE_HAVENS_INSTANTLY;

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
	local UIStrategyMap StrategyMap;
	local UIStrategyMapItem_Region_LW SelectedRegionMapItem;
	local XComHQPresentationLayer HQPres;

	bHandled = true;
	HQPres = `HQPRES;
	StrategyMap = UIStrategyMap(Screen);

	// XCom : No input during flight mode.
	if (StrategyMap.IsInFlightMode())
	{
		return true;
	}

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
			SelectedRegionMapItem = UIStrategyMapItem_Region_LW(StrategyMap.SelectedMapItem);
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

		// KDM : DPad left cycles through 'contacted' havens/regions on the strategy map.
		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
			CycleSelectedHaven(StrategyMap, true);
			break;

		// KDM : DPad right cycles through 'contacted' havens/regions on the strategy map.
		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
			CycleSelectedHaven(StrategyMap, false);
			break;

		default:
			bHandled = false;
			break;
	}

	return bHandled;
}

simulated function CycleSelectedHaven(UIStrategyMap StrategyMap, bool CyclePrevious)
{
	local int i, SelectedMapItemIndex;
	local array<UIStrategyMapItem_Region> RegionMapItems;
	local UIStrategyMapItem_Region RegionMapItem, SelectedMapItem;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LWOutpost OutpostState;
	local XComGameState_WorldRegion RegionState;
	local XComGameStateHistory History;
	
	History = `XCOMHISTORY;
	XComHQ = StrategyMap.XCOMHQ();

	// KDM : SelectedMapItem will be 'none' if either:
	// 1.] There is currently no selected map item on the strategy map. 
	// 2.] The currently selected map item, on the strategy map, is not a 'region' map item.
	SelectedMapItem = UIStrategyMapItem_Region(StrategyMap.SelectedMapItem);

	// KDM : If a haven/region is not currently selected, just select the starting haven/region.
	if (SelectedMapItem == none)
	{
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(XComHQ.StartingRegion.ObjectID));
		RegionMapItem = UIStrategyMapItem_Region(StrategyMap.GetMapItem(RegionState));
	}
	else
	{
		i = 0;
		SelectedMapItemIndex = -1;
		foreach History.IterateByClassType(class'XComGameState_LWOutpost', OutpostState)
		{
			RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(OutpostState.Region.ObjectID));
			// KDM : We only want to select from havens/regions which have been 'contacted'.
			if (RegionState.HaveMadeContact())
			{
				RegionMapItem = UIStrategyMapItem_Region(StrategyMap.GetMapItem(RegionState));
				RegionMapItems.AddItem(RegionMapItem);
				
				// KDM : If we find our currently selected haven/region, store this information; it will be 
				// needed in a bit.
				if (RegionMapItem == SelectedMapItem)
				{
					SelectedMapItemIndex = i;
				}
				i++;
			}
		}

		// KDM : No 'contacted' region map items existed; this should never happen !
		if (RegionMapItems.Length == 0)
		{
			`log("KDM ERROR : UIScreenListener_UIStrategyMap.CycleSelectedHaven : No region map items found !");
			return;
		}
		// KDM : If only 1 'contacted' region map item exists, or if the selected region map item corresponds
		// to an 'uncontacted' region, just select the starting haven/region.
		else if (RegionMapItems.Length == 1 || SelectedMapItemIndex == -1)
		{
			RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(XComHQ.StartingRegion.ObjectID));
			RegionMapItem = UIStrategyMapItem_Region(StrategyMap.GetMapItem(RegionState));
		}
		else
		{
			// KDM : Cycle from right to left array-wise; if we are already at the start
			// of the array then loop back around to the back of the array.
			if (CyclePrevious)
			{
				if (SelectedMapItemIndex == 0)
				{
					RegionMapItem = RegionMapItems[RegionMapItems.Length - 1];
				}
				else
				{
					RegionMapItem = RegionMapItems[SelectedMapItemIndex - 1];
				}
			}
			// KDM : Cycle from left to right array-wise; if we are already at the end
			// of the array then loop around to the front of the array.
			else
			{
				if (SelectedMapItemIndex == RegionMapItems.Length - 1)
				{
					RegionMapItem = RegionMapItems[0];
				}
				else
				{
					RegionMapItem = RegionMapItems[SelectedMapItemIndex + 1];
				}
			}
		}
	}

	if (RegionMapItem != none)
	{
		// KDM : As per XComGameState_HeadquartersXCom.SetPendingPointOfTravel, we will set LastSelectedMapItem to
		// our chosen region map item then select it; apparently, according to XCom comments, this makes 
		// sure certain issues don't arise.
		//
		// The code below is a slight modification of that found in UIStrategyMap.SelectLastSelectedMapItem.
		
		StrategyMap.LastSelectedMapItem = RegionMapItem;
		if (CYCLE_HAVENS_INSTANTLY)
		{
			// KDM : Move to the 'newly selected' region map item instantly.
			`EARTH.SetViewLocation(StrategyMap.LastSelectedMapItem.Cached2DWorldLocation);
		}
		else
		{
			// KDM : Move to the 'newly selected' map item with acceleration/deceleration.
			XComHQPresentationLayer(StrategyMap.Movie.Pres).CAMLookAtEarth(StrategyMap.LastSelectedMapItem.Cached2DWorldLocation);
		}
		StrategyMap.SetSelectedMapItem(StrategyMap.LastSelectedMapItem);
		StrategyMap.HideTooltip();
		StrategyMap.LastSelectedMapItem = none;
	}
}

defaultProperties
{
	ScreenClass = UIStrategyMap;
}
