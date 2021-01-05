//---------------------------------------------------------------------------------------
//	FILE :		UIScreenListener_Mission_GoldenPath.uc
//	AUTHOR :	KDM
//	PURPOSE :	Set up the UIMission_GoldenPath screen such that :
//				- For controller users, the 'launch mission', 'cancel mission', and 'locked mission' buttons appear 
//				as parent-panel centered hotlinks.
//				- For mouse and keyboard users, the 'launch mission', 'cancel mission', and 'locked mission' buttons
//				appear as parent-panel centered conventional buttons.
//---------------------------------------------------------------------------------------

class UIScreenListener_Mission_GoldenPath extends UIScreenListener;

var UIMission_GoldenPath GoldenPathScreen;
var UIButton Button1, Button2, LockedButton;

event OnInit(UIScreen Screen)
{
	GoldenPathScreen = UIMission_GoldenPath(Screen);
	// KDM : If CanTakeMission is true then LockedButton will be 'none'; if CanTakeMission is false then Button1 
	// and Button2 will both be 'none'. Buttons which are not 'none' will have the eUIButtonStyle_HOTLINK_BUTTON style
	// and will resize according to their text.
	Button1 = GoldenPathScreen.Button1;
	Button2 = GoldenPathScreen.Button2;
	LockedButton = GoldenPathScreen.LockedButton;

	// KDM : Display parent-panel centered hotlinks for controller users, and parent-panel centered buttons
	// for mouse and keyboard users.
	if (`ISCONTROLLERACTIVE)
	{
		if (GoldenPathScreen.CanTakeMission())
		{
			Button1.OnSizeRealized = OnButtonSizeRealized;
			// KDM : Allow the hotlink to be shorter than 150 pixels, its flash-based default.
			Button1.MC.SetNum("MIN_WIDTH", 50);
			// KDM : Set the hotlink's text so OnSizeRealized is called; this is where we center it within its
			// parent panel.
			Button1.SetText(Button1.Text);

			Button2.OnSizeRealized = OnButtonSizeRealized;
			Button2.MC.SetNum("MIN_WIDTH", 50);
			Button2.SetText(Button2.Text);
		}
		else
		{
			LockedButton.OnSizeRealized = OnLockedButtonSizeRealized;
			LockedButton.MC.SetNum("MIN_WIDTH", 50);
			LockedButton.SetText(LockedButton.Text);
		}
	}
	else
	{
		if (GoldenPathScreen.CanTakeMission())
		{
			// KDM : We want the buttons to be nice and wide; therefore, remove their text resizing and set their width
			// and position manually.
			Button1.SetResizeToText(false);
			Button1.SetWidth(300);
			Button1.SetPosition(-150, 0);

			Button2.SetResizeToText(false);
			Button2.SetWidth(300);
			Button2.SetPosition(-150, 31);
		}
		else
		{
			LockedButton.SetResizeToText(false);
			LockedButton.SetWidth(300);
			LockedButton.SetPosition(50, 120);
		}

	}

	// KDM : The navigation system, set up in UIMission.RefreshNavigation, is a mess; clean it up here.
	RefreshNavigation();
	
	`HQPRES.ScreenStack.SubscribeToOnInputForScreen(Screen, OnGoldenPathMissionCommand);
}

event OnRemoved(UIScreen Screen)
{
	if (Button1 != none)
	{
		Button1.OnSizeRealized = none;
	}
	if (Button2 != none)
	{
		Button2.OnSizeRealized = none;
	}
	if (LockedButton != none)
	{
		LockedButton.OnSizeRealized = none;
	}

	Button1 = none;
	Button2 = none;
	LockedButton = none;
	GoldenPathScreen = none;

	`HQPRES.ScreenStack.UnsubscribeFromOnInputForScreen(Screen, OnGoldenPathMissionCommand);
}

simulated function RefreshNavigation()
{
	local bool SelectionSet;
	local UIPanel DefaultPanel;

	SelectionSet = false;

	// KDM : Enable focus cascading so Navigator.Clear kills 'all' UI focus.
	GoldenPathScreen.LibraryPanel.bCascadeFocus = true;
	GoldenPathScreen.ButtonGroup.bCascadeFocus = true;
	DefaultPanel = GoldenPathScreen.LibraryPanel.GetChildByName('DefaultPanel', false);
	if (DefaultPanel != none)
	{
		DefaultPanel.bCascadeFocus = true;
	}

	// KDM : Empty the navigation system.
	GoldenPathScreen.Navigator.Clear();
	GoldenPathScreen.Navigator.LoopSelection = true;

	// KDM : The navigation system need not be setup for controller users, since they use hotlinks.
	if (!`ISCONTROLLERACTIVE)
	{
		if (GoldenPathScreen.CanTakeMission())
		{
			// KDM : Add the 'launch mission' and 'cancel mission' buttons to the Navigator.
			SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(GoldenPathScreen, Button1, SelectionSet);
			SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(GoldenPathScreen, Button2, SelectionSet);
		}
		else
		{
			// KDM : Add the 'locked mission' button to the Navigator.
			class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(GoldenPathScreen, LockedButton, SelectionSet);
		}
	}
}

simulated function OnButtonSizeRealized()
{
	if (GoldenPathScreen != none)
	{
		Button1.SetX(-Button1.Width / 2.0);
		Button1.SetY(10.0);

		Button2.SetX(-Button2.Width / 2.0);
		Button2.SetY(40.0);
	}
}

simulated function OnLockedButtonSizeRealized()
{
	if (GoldenPathScreen != none)
	{
		LockedButton.SetX(200 - LockedButton.Width / 2.0);
		LockedButton.SetY(125.0);
	}
}

simulated protected function bool OnGoldenPathMissionCommand(UIScreen Screen, int cmd, int arg)
{
	local UIButton SelectedButton;

	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	// KDM : Exit if the screen doesn't exist yet.
	if (GoldenPathScreen == none)
	{
		return false;
	}

	switch(cmd)
	{
	// KDM : The spacebar and enter key 'click' on the selected button. Previously, the spacebar and
	// enter key would only attempt to 'click' ConfirmButton or Button1.
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
		SelectedButton = UIButton(GoldenPathScreen.Navigator.GetSelected());
		if (SelectedButton != none && SelectedButton.OnClickedDelegate != none)
		{
			SelectedButton.Click();
			return true;
		}
		break;
	}

	return false;
}

defaultproperties
{
	ScreenClass = UIMission_GoldenPath
}
