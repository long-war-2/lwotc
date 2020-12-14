//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_TacticalHUD_LWOfficerPack
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Adds button to toggle officer command range preview
//--------------------------------------------------------------------------------------- 

class UIScreenListener_TacticalHUD_LWOfficerPack extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UITacticalHUD HUDScreen;
	
	HUDScreen = UITacticalHUD(Screen);
	
	if (HUDScreen == none)
	{
		`RedScreen("UITacticalHUD ScreenListener: HUDScreen == none");
		return;
	}

	UpdateMouseControls(HUDScreen);
	class'LWOfficerUtilities'.static.GCandValidationChecks();
	`SCREENSTACK.SubscribeToOnInputForScreen(Screen, OnUITacticalHUDCommand);
}

event OnRemoved(UIScreen Screen)
{
	`SCREENSTACK.UnsubscribeFromOnInputForScreen(Screen, OnUITacticalHUDCommand);
}

simulated protected function bool OnUITacticalHUDCommand(UIScreen Screen, int cmd, int arg)
{
	local bool bHandled, MenuIsRaised;
	local UITacticalHUD TacticalHUD;
	local UITacticalHUD_MouseControls_LWOfficerPack MouseControls;

	bHandled = true;

	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	TacticalHUD = UITacticalHUD(Screen);
	if (TacticalHUD == none)
	{
		return false;
	}

	switch (cmd)
	{
	// KDM : If an officer is on the mission, and the left trigger is pressed while the ability menu is open,
	// the command range display is toggled on/off.
	case (class'UIUtilities_Input'.const.FXS_BUTTON_LTRIGGER):
		MenuIsRaised = TacticalHUD.IsMenuRaised();
		MouseControls = UITacticalHUD_MouseControls_LWOfficerPack(TacticalHUD.m_kMouseControls);

		if (MenuIsRaised && MouseControls != none && class'LWOfficerUtilities'.static.HasOfficerInSquad() &&
			MouseControls.OfficerIcon != none)
		{
			MouseControls.OnClickedCallback();
			TacticalHUD.CancelTargetingAction();
		}
		else
		{
			bHandled = false;
		}
		break;

	default:
		bHandled = false;
		break;
	}

	return bHandled;
}

// KDM : UITacticalHUD_MouseControls_LWOfficerPack is now spawned for controller users as well, so they 
// have access to an officer's 'command range' icon and ability.
simulated function UpdateMouseControls(UITacticalHUD HUDScreen)
{
	if (HUDScreen.m_kMouseControls != none)
	{
		HUDScreen.m_kMouseControls.Remove();
	}

	// KDM : These statements need not be placed within a (HUDScreen.m_kMouseControls != none) conditional because :
	// 1.] When using a mouse and keyboard, UITacticalHUD always spawns m_kMouseControls within OnInit.
	// 2.] When using a controller, UITacticalHUD never spawns m_kMouseControls; however, we still want to
	// spawn the LW2 version, UITacticalHUD_MouseControls_LWOfficerPack.
	HUDScreen.m_kMouseControls = HUDScreen.Spawn(class'UITacticalHUD_MouseControls_LWOfficerPack', HUDScreen);
	HUDScreen.m_kMouseControls.InitMouseControls();
}

defaultProperties
{
	ScreenClass = UITacticalHUD;
}
