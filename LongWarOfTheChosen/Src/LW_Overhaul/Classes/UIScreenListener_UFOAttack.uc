//---------------------------------------------------------------------------------------
//	FILE :		UIScreenListener_UFOAttack.uc
//	AUTHOR :	KDM
//	PURPOSE :	Set up the UIUFOAttack screen such that :
//				- For controller users, the 'launch mission' button appears as a parent-panel centered hotlink.
//				- For mouse and keyboard users, the 'launch mission' button appears as a parent-panel centered 
//				conventional button.
//---------------------------------------------------------------------------------------

class UIScreenListener_UFOAttack extends UIScreenListener;

var private string PathToUFOAttackScreen;
//var UIUFOAttack UFOAttackScreen;
//var UIButton Button1;

event OnInit(UIScreen Screen)
{
	local UIUFOAttack UFOAttackScreen;
	local UIButton Button1;

	UFOAttackScreen = UIUFOAttack(Screen);
	Button1 = UFOAttackScreen.Button1;

	PathToUFOAttackScreen = PathName(UFOAttackScreen);
	
	// KDM : Display parent-panel centered hotlinks for controller users, and parent-panel centered buttons
	// for mouse and keyboard users.
	if (`ISCONTROLLERACTIVE)
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
	}
	else
	{
		// KDM : Resizing is already removed from Button1; therefore, simply set its width and position it manually.
		Button1.SetWidth(300);
		Button1.SetPosition(-150, 0);
	}

	// KDM : The navigation system, set up in UIUFOAttack.RefreshNavigation, is a mess; clean it up here.
	RefreshNavigation();

	`HQPRES.ScreenStack.SubscribeToOnInputForScreen(Screen, OnUFOAttackCommand);
}

event OnRemoved(UIScreen Screen)
{
	PathToUFOAttackScreen = "";

	`HQPRES.ScreenStack.UnsubscribeFromOnInputForScreen(Screen, OnUFOAttackCommand);
}

simulated function RefreshNavigation()
{
	local bool SelectionSet;
	local UIPanel DefaultPanel;
	local UIUFOAttack UFOAttackScreen;

	UFOAttackScreen = UIUFOAttack(FindObject(PathToUFOAttackScreen, class'UIUFOAttack'));

	SelectionSet = false;

	// KDM : Enable focus cascading so Navigator.Clear kills 'all' UI focus.
	UFOAttackScreen.LibraryPanel.bCascadeFocus = true;
	DefaultPanel = UFOAttackScreen.LibraryPanel.GetChildByName('DefaultPanel', false);
	if (DefaultPanel != none)
	{
		DefaultPanel.bCascadeFocus = true;
	}
	UFOAttackScreen.ButtonGroup.bCascadeFocus = true;

	// KDM : Empty the navigation system.
	UFOAttackScreen.Navigator.Clear();
	UFOAttackScreen.Navigator.LoopSelection = true;

	// KDM : The navigation system need not be setup for controller users, since they use hotlinks.
	if (!`ISCONTROLLERACTIVE)
	{
		// KDM : Add the 'launch mission' button to the Navigator.
		class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(UFOAttackScreen, UFOAttackScreen.Button1, SelectionSet);
	}
}

simulated function OnButtonSizeRealized()
{
	local UIUFOAttack UFOAttackScreen;

	UFOAttackScreen = UIUFOAttack(FindObject(PathToUFOAttackScreen, class'UIUFOAttack'));

	if (UFOAttackScreen != none)
	{
	if (UFOAttackScreen != none)
		UFOAttackScreen.Button1.SetX(-UFOAttackScreen.Button1.Width / 2.0);
		UFOAttackScreen.Button1.SetY(10.0);
	}
}

simulated protected function bool OnUFOAttackCommand(UIScreen Screen, int cmd, int arg)
{
	local UIButton SelectedButton;
	local UIUFOAttack UFOAttackScreen;

	UFOAttackScreen = UIUFOAttack(FindObject(PathToUFOAttackScreen, class'UIUFOAttack'));

	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	// KDM : Exit if the screen doesn't exist yet.
	if (UFOAttackScreen == none)
	{
		return false;
	}

	switch(cmd)
	{

	// KDM : UIUFOAttack.OnUnrealCommand would only 'click' on a button if it was selected; since controller users 
	// use hotlinks remove this requirement.
	case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		if (UFOAttackScreen.Button1 != none && UFOAttackScreen.Button1.bIsVisible)
		{
			UFOAttackScreen.Button1.Click();
			return true;
		}
		break;

	// KDM : The spacebar and enter key 'click' on the selected button. Previously, the spacebar and
	// enter key would only attempt to 'click' a button if it was selected, and was a child of ButtonGroup.
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
		SelectedButton = UIButton(UFOAttackScreen.Navigator.GetSelected());
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
	ScreenClass = UIUFOAttack
}
