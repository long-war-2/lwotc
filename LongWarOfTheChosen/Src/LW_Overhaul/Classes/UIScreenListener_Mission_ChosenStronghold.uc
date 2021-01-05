//---------------------------------------------------------------------------------------
//	FILE :		UIScreenListener_Mission_ChosenStronghold.uc
//	AUTHOR :	KDM
//	PURPOSE :	Set up the UIMission_ChosenStronghold screen such that :
//				- For controller users, the 'launch mission', 'cancel mission', and 'locked mission' buttons appear 
//				as parent-panel centered hotlinks.
//				- For mouse and keyboard users, the 'launch mission', 'cancel mission', and 'locked mission' buttons
//				appear as parent-panel centered conventional buttons.
//---------------------------------------------------------------------------------------

class UIScreenListener_Mission_ChosenStronghold extends UIScreenListener;

var UIMission_ChosenStronghold ChosenStrongholdScreen;
var UIButton Button1, Button2, LockedButton;

event OnInit(UIScreen Screen)
{
	ChosenStrongholdScreen = UIMission_ChosenStronghold(Screen);
	// KDM : If CanTakeMission is true then LockedButton will be 'none'; if CanTakeMission is false then Button1 
	// and Button2 will both be 'none'.
	Button1 = ChosenStrongholdScreen.Button1;
	Button2 = ChosenStrongholdScreen.Button2;
	LockedButton = ChosenStrongholdScreen.LockedButton;

	// KDM : Display parent-panel centered hotlinks for controller users, and parent-panel centered buttons
	// for mouse and keyboard users.
	if (`ISCONTROLLERACTIVE)
	{
		if (ChosenStrongholdScreen.CanTakeMission())
		{
			Button1.OnSizeRealized = OnButtonSizeRealized;
			// KDM : Allow the hotlink to be shorter than 150 pixels, its flash-based default.
			Button1.MC.SetNum("MIN_WIDTH", 50);
			// KDM : Enable hotlink resizing.
			Button1.SetResizeToText(true);
			// KDM : Actually 'make' it a hotlink with a gamepad icon.
			Button1.SetStyle(eUIButtonStyle_HOTLINK_BUTTON);
			Button1.SetGamepadIcon(class 'UIUtilities_Input'.static.GetAdvanceButtonIcon());
			// KDM : Set the hotlink's text so OnSizeRealized is called; this is where we center it within its
			// parent panel.
			Button1.SetText(Button1.Text);

			Button2.OnSizeRealized = OnButtonSizeRealized;
			Button2.MC.SetNum("MIN_WIDTH", 50);
			Button2.SetResizeToText(true);
			Button2.SetStyle(eUIButtonStyle_HOTLINK_BUTTON);
			Button2.SetGamepadIcon(class 'UIUtilities_Input'.static.GetBackButtonIcon());
			Button2.SetText(Button2.Text);
		}
		else
		{
			// KDM : LockedButton is already set up to be a resizing hotlink; therefore, we need not set
			// its style nor its text-resizing property.
			LockedButton.OnSizeRealized = OnLockedButtonSizeRealized;
			LockedButton.MC.SetNum("MIN_WIDTH", 50);
			LockedButton.SetText(LockedButton.Text);
		}
	}
	else
	{
		if (ChosenStrongholdScreen.CanTakeMission())
		{
			// KDM : Resizing is already removed from Button1 and Button2; therefore, simply set their width
			// and position them manually.
			Button1.SetWidth(300);
			Button1.SetPosition(-150, 0);

			Button2.SetWidth(300);
			Button2.SetPosition(-150, 31);
		}
		else
		{
			// KDM : We want LockedButton to be nice and wide; therefore, remove its text resizing and set its width
			// and position manually.
			LockedButton.SetResizeToText(false);
			LockedButton.SetWidth(300);
			LockedButton.SetPosition(50, 120);
		}

	}

	// KDM : The navigation system, set up in UIMission.RefreshNavigation, is a mess; clean it up here.
	RefreshNavigation();
	
	`HQPRES.ScreenStack.SubscribeToOnInputForScreen(Screen, OnChosenStrongholdMissionCommand);
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
	ChosenStrongholdScreen = none;

	`HQPRES.ScreenStack.UnsubscribeFromOnInputForScreen(Screen, OnChosenStrongholdMissionCommand);
}

simulated function RefreshNavigation()
{
	local bool SelectionSet;

	SelectionSet = false;

	// KDM : Enable focus cascading so Navigator.Clear kills 'all' UI focus.
	ChosenStrongholdScreen.LibraryPanel.bCascadeFocus = true;
	ChosenStrongholdScreen.ButtonGroup.bCascadeFocus = true;

	// KDM : Empty the navigation system.
	ChosenStrongholdScreen.Navigator.Clear();
	ChosenStrongholdScreen.Navigator.LoopSelection = true;

	// KDM : The navigation system need not be setup for controller users, since they use hotlinks.
	if (!`ISCONTROLLERACTIVE)
	{
		if (ChosenStrongholdScreen.CanTakeMission())
		{
			// KDM : Add the 'launch mission' and 'cancel mission' buttons to the Navigator.
			SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(ChosenStrongholdScreen, Button1, SelectionSet);
			SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(ChosenStrongholdScreen, Button2, SelectionSet);
		}
		else
		{
			// KDM : Add the 'locked mission' button to the Navigator.
			class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(ChosenStrongholdScreen, LockedButton, SelectionSet);
		}
	}
}

simulated function OnButtonSizeRealized()
{
	if (ChosenStrongholdScreen != none)
	{
		Button1.SetX(-Button1.Width / 2.0);
		Button1.SetY(10.0);

		Button2.SetX(-Button2.Width / 2.0);
		Button2.SetY(40.0);
	}
}

simulated function OnLockedButtonSizeRealized()
{
	if (ChosenStrongholdScreen != none)
	{
		LockedButton.SetX(200 - LockedButton.Width / 2.0);
		LockedButton.SetY(125.0);
	}
}

simulated protected function bool OnChosenStrongholdMissionCommand(UIScreen Screen, int cmd, int arg)
{
	local UIButton SelectedButton;

	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	// KDM : Exit if the screen doesn't exist yet.
	if (ChosenStrongholdScreen == none)
	{
		return false;
	}

	switch(cmd)
	{
	// KDM : UIMission_ChosenStronghold.OnUnrealCommand would only 'click' on Button1 or Button2 if they were
	// focused; since controller users use hotlinks remove this requirement.
	case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		if (ChosenStrongholdScreen.CanTakeMission() && Button1 != none && Button1.bIsVisible)
		{
			Button1.Click();
		}
		else if (Button2 != none && Button2.bIsVisible)
		{
			Button2.Click();
		}
		return true;

	// KDM : UIMission_ChosenStronghold.OnUnrealCommand ignores B button presses unless the mission is locked.
	// This allows the B button to back out of the screen when the mission is unlocked, assuming certain conditions
	// are met.
	case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		if(ChosenStrongholdScreen.CanBackOut() && Button2 != none && Button2.bIsVisible)
		{
			ChosenStrongholdScreen.CloseScreen();
			return true;
		}
		break;

	// KDM : The spacebar and enter key 'click' on the selected button. Previously, the spacebar and
	// enter key would only attempt to 'click' ConfirmButton or Button1.
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
		SelectedButton = UIButton(ChosenStrongholdScreen.Navigator.GetSelected());
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
	ScreenClass = UIMission_ChosenStronghold
}
