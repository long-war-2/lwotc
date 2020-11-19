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

	Button1.SetBad(true);
	Button1.OnClickedDelegate = OnLaunchClicked;

	Button2.OnClickedDelegate = OnCancelClicked;
	Button2.Show();
}

// Make sure the player can close this screen without it
// automatically completing the mission.
simulated function bool CanBackOut()
{
	return true;
}
