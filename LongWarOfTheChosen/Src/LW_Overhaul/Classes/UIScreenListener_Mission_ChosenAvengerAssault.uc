//---------------------------------------------------------------------------------------
//	FILE :		UIScreenListener_Mission_ChosenAvengerAssault.uc
//	AUTHOR :	KDM
//	PURPOSE :	Set up the UIMission_ChosenAvengerAssault screen such that :
//				- For controller users, the 'launch mission' button appears as a parent-panel centered hotlink.
//				- For mouse and keyboard users, the 'launch mission' button appears as a parent-panel centered 
//				conventional button.
//---------------------------------------------------------------------------------------

class UIScreenListener_Mission_ChosenAvengerAssault extends UIScreenListener;

var UIMission_ChosenAvengerAssault ChosenAvengerAssaultScreen;
var UIButton Button1;

event OnInit(UIScreen Screen)
{
	ChosenAvengerAssaultScreen = UIMission_ChosenAvengerAssault(Screen);
	Button1 = ChosenAvengerAssaultScreen.Button1;
	
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
		// KDM : Resizing is already removed from Button1; therefore, simply set its width
		// and position it manually.
		Button1.SetWidth(300);
		Button1.SetPosition(-150, 0);
	}

	// KDM : The navigation system, set up in UIMission_ChosenAvengerAssault.RefreshNavigation, is a mess; 
	// clean it up here.
	RefreshNavigation();
}

event OnRemoved(UIScreen Screen)
{
	if (Button1 != none)
	{
		Button1.OnSizeRealized = none;
	}

	Button1 = none;
	ChosenAvengerAssaultScreen = none;
}

simulated function RefreshNavigation()
{
	local bool SelectionSet;

	SelectionSet = false;

	// KDM : Enable focus cascading so Navigator.Clear kills 'all' UI focus.
	ChosenAvengerAssaultScreen.LibraryPanel.bCascadeFocus = true;
	ChosenAvengerAssaultScreen.ButtonGroup.bCascadeFocus = true;
	
	// KDM : Empty the navigation system.
	ChosenAvengerAssaultScreen.Navigator.Clear();
	ChosenAvengerAssaultScreen.Navigator.LoopSelection = true;

	// KDM : The navigation system need not be setup for controller users, since they use hotlinks.
	if (!`ISCONTROLLERACTIVE)
	{
		// KDM : Add the 'launch mission' button to the Navigator.
		class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(ChosenAvengerAssaultScreen, Button1, SelectionSet);
	}
}

simulated function OnButtonSizeRealized()
{
	if (ChosenAvengerAssaultScreen != none)
	{
		Button1.SetX(-Button1.Width / 2.0);
		Button1.SetY(10.0);
	}
}

defaultproperties
{
	ScreenClass = UIMission_ChosenAvengerAssault
}
