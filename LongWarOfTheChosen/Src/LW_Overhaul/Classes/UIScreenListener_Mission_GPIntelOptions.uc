//---------------------------------------------------------------------------------------
//	FILE :		UIScreenListener_Mission_GPIntelOptions.uc
//	AUTHOR :	KDM
//	PURPOSE :	Set up the UIMission_GPIntelOptions final-mission screen such that :
//				- For controller users, the 'launch mission', 'cancel mission', and 'locked mission' buttons appear 
//				as parent-panel centered hotlinks.
//				- For mouse and keyboard users, the 'launch mission', 'cancel mission', and 'locked mission' buttons
//				appear as parent-panel centered conventional buttons.
//---------------------------------------------------------------------------------------

class UIScreenListener_Mission_GPIntelOptions extends UIScreenListener;

var UIMission_GPIntelOptions GPIntelOptionsScreen;
var UIButton Button1, Button2, LockedButton;

event OnInit(UIScreen Screen)
{
	GPIntelOptionsScreen = UIMission_GPIntelOptions(Screen);
	// KDM : If CanTakeMission is true then LockedButton will be 'none'; if CanTakeMission is false then Button1 
	// and Button2 will both be 'none'. Buttons which are not 'none' will have the eUIButtonStyle_HOTLINK_BUTTON style
	// and will resize according to their text.
	Button1 = GPIntelOptionsScreen.Button1;
	Button2 = GPIntelOptionsScreen.Button2;
	LockedButton = GPIntelOptionsScreen.LockedButton;

	// KDM : Display parent-panel centered hotlinks for controller users, and parent-panel centered buttons
	// for mouse and keyboard users.
	if (`ISCONTROLLERACTIVE)
	{
		if (GPIntelOptionsScreen.CanTakeMission())
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
		if (GPIntelOptionsScreen.CanTakeMission())
		{
			// KDM : Within UIMission_GPIntelOptions Button1.OnSizeRealized, Button2.OnSizeRealized, and
			// LockedButton.OnSizeRealized all point to OnButtonSizeRealized, a function which changes all 3
			// button's positions. We don't want this, so override OnSizeRealized. 
			Button1.OnSizeRealized = OnButtonSizeRealized;
			// KDM : We want the buttons to be nice and wide; therefore, remove their text resizing and set their width
			// and position manually.
			Button1.SetResizeToText(false);
			Button1.SetWidth(300);
			Button1.SetPosition(-150, 0);

			Button2.OnSizeRealized = OnButtonSizeRealized;
			Button2.SetResizeToText(false);
			Button2.SetWidth(300);
			Button2.SetPosition(-150, 31);
		}
		else
		{
			LockedButton.OnSizeRealized = OnLockedButtonSizeRealized;
			LockedButton.SetResizeToText(false);
			LockedButton.SetWidth(300);
			LockedButton.SetPosition(50, 90);
		}
	}

	// KDM : The navigation system, set up in UIMission.RefreshNavigation, is a mess; clean it up here.
	RefreshNavigation();
	
	`HQPRES.ScreenStack.SubscribeToOnInputForScreen(Screen, OnGPIntelOptionsMissionCommand);	
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
	GPIntelOptionsScreen = none;

	`HQPRES.ScreenStack.UnsubscribeFromOnInputForScreen(Screen, OnGPIntelOptionsMissionCommand);
}

simulated function RefreshNavigation()
{
	local bool SelectionSet;
	local int i;
	local UIList List;
	local UIMechaListItem ListItem;
	local UIPanel IntelPanel;

	SelectionSet = false;

	List = GPIntelOptionsScreen.List;

	// KDM : An unlocked final mission screen makes use of a special navigation system which consists of a list, and 
	// a variety of buttons. Just leave it 'as is' !
	if (!GPIntelOptionsScreen.CanTakeMission())
	{
		// KDM : Enable focus cascading so Navigator.Clear kills 'all' UI focus.
		GPIntelOptionsScreen.LibraryPanel.bCascadeFocus = true;
		IntelPanel = GPIntelOptionsScreen.LibraryPanel.GetChildByName('IntelPanel', false);
		if (IntelPanel != none)
		{
			IntelPanel.bCascadeFocus = true;
		}
		GPIntelOptionsScreen.ButtonGroup.bCascadeFocus = true;

		// KDM : Empty the navigation system.
		GPIntelOptionsScreen.Navigator.Clear();
		GPIntelOptionsScreen.Navigator.LoopSelection = true;

		// KDM : The navigation system need not be setup for controller users, since they use hotlinks.
		if (!`ISCONTROLLERACTIVE)
		{
			// KDM : Add the 'locked mission' button to the Navigator.
			class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(GPIntelOptionsScreen, LockedButton, SelectionSet);
		}

		// KDM : If the mission is locked then disable all of the intel option buttons.
		for (i = 0; i < List.ItemCount; i++)
		{
			ListItem = UIMechaListItem(List.GetItem(i));
			if (ListItem != none)
			{
				ListItem.SetDisabled(true);
			}
		}
	}
}

simulated function OnButtonSizeRealized()
{
	// KDM : When using a mouse and keyboard, this function acts as an override for 
	// UIMission_GPIntelOptions.OnButtonSizeRealized; therefore, we can simply exit.
	if (!`ISCONTROLLERACTIVE)
	{
		return;
	}

	if (GPIntelOptionsScreen != none)
	{
		Button1.SetX(-Button1.Width / 2.0);
		Button1.SetY(10.0);

		Button2.SetX(-Button2.Width / 2.0);
		Button2.SetY(40.0);
	}
}

simulated function OnLockedButtonSizeRealized()
{
	if (!`ISCONTROLLERACTIVE)
	{
		return;
	}

	if (GPIntelOptionsScreen != none)
	{
		LockedButton.SetX(225 - LockedButton.Width / 2.0);
		LockedButton.SetY(85.0);
	}
}

simulated protected function bool OnGPIntelOptionsMissionCommand(UIScreen Screen, int cmd, int arg)
{
	local UIButton SelectedButton;

	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	// KDM : Exit if the screen doesn't exist yet.
	if (GPIntelOptionsScreen == none)
	{
		return false;
	}

	if (!GPIntelOptionsScreen.CanTakeMission())
	{
		switch(cmd)
		{
		// KDM : UIMission_GPIntelOptions.OnUnrealCommand automatically pipes commands through the intel options
		// list; however, when the mission is locked, we don't want to allow list navigation. Consequently, grab
		// ahold of any up/down commands and ignore them.
		case class'UIUtilities_Input'.const.FXS_DPAD_UP:
		case class'UIUtilities_Input'.const.FXS_DPAD_DOWN:
		case class'UIUtilities_Input'.const.FXS_ARROW_UP:
		case class'UIUtilities_Input'.const.FXS_ARROW_DOWN:
			return true;

		// KDM : The spacebar and enter key 'click' on the selected button. Previously, the spacebar and
		// enter key would only attempt to 'click' ConfirmButton or Button1.
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			SelectedButton = UIButton(GPIntelOptionsScreen.Navigator.GetSelected());
			if (SelectedButton != none && SelectedButton.OnClickedDelegate != none)
			{
				SelectedButton.Click();
				return true;
			}
			break;
		}
	}

	return false;
}

defaultproperties
{
	ScreenClass = UIMission_GPIntelOptions
}
