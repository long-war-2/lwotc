//---------------------------------------------------------------------------------------
//  FILE:    UIMission_ChosenAmbush_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Override for the normal Chosen Ambush mission blade so that players
//           can back out and make sure they have a suitable squad for the mission.
//---------------------------------------------------------------------------------------
class UIMission_ChosenAmbush_LW extends UIMission_ChosenAmbush;

// Overrides the parent class to call `UIMission.OnLaunchClicked()`.
simulated function OnLaunchClicked(UIButton Button)
{
	super(UIMission).OnLaunchClicked(Button);
}

// Override the Cancel button so that it simply closes the screen.
simulated function BuildOptionsPanel()
{
	super.BuildOptionsPanel();

	if (`ISCONTROLLERACTIVE)
	{
		Button1.OnSizeRealized = OnButtonSizeRealized;
		Button1.MC.SetNum("MIN_WIDTH", 50);
		Button1.SetResizeToText(true);
		Button1.SetStyle(eUIButtonStyle_HOTLINK_BUTTON);
		Button1.SetGamepadIcon(class 'UIUtilities_Input'.static.GetAdvanceButtonIcon());
		// Button1.SetText(m_strConfirmMission);

		Button2.OnSizeRealized = OnButtonSizeRealized;
		Button2.MC.SetNum("MIN_WIDTH", 50);
		Button2.SetResizeToText(true);
		Button2.SetStyle(eUIButtonStyle_HOTLINK_BUTTON);
		Button2.SetGamepadIcon(class 'UIUtilities_Input'.static.GetBackButtonIcon());
		// Button2.SetText(m_strCancel);
	}

	// Button1.SetBad(true);
	// Button1.OnClickedDelegate = OnLaunchClicked;

	Button2.OnClickedDelegate = OnCancelClicked;
	Button2.Show();
}

simulated function OnButtonSizeRealized()
{
	Button1.SetX(-Button1.Width / 2.0);
	Button1.SetY(10.0);

	Button2.SetX(-Button2.Width / 2.0);
	Button2.SetY(40.0);
}

simulated function RefreshNavigation()
{
	local bool SelectionSet;
	local UIPanel DefaultPanel;

	SelectionSet = false;

	// KDM : Enable focus cascading so Navigator.Clear kills 'all' UI focus.
	LibraryPanel.bCascadeFocus = true;
	ButtonGroup.bCascadeFocus = true;
	DefaultPanel = LibraryPanel.GetChildByName('DefaultPanel', false);
	if (DefaultPanel != none)
	{
		DefaultPanel.bCascadeFocus = true;
	}

	// KDM : Empty the navigation system.
	Navigator.Clear();
	Navigator.LoopSelection = true;

	// KDM : The navigation system need not be setup for controller users, since they use hotlinks.
	if (!`ISCONTROLLERACTIVE)
	{
		SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(self, Button1, SelectionSet);
		SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(self, Button2, SelectionSet);
	}
}

// Make sure the player can close this screen without it
// automatically completing the mission.
simulated function bool CanBackOut()
{
	return true;
}
