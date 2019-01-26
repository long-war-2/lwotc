//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_TacticalHUD_LWOfficerPack
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: Adds button to toggle officer command range preview
//
//--------------------------------------------------------------------------------------- 

class UIScreenListener_TacticalHUD_LWOfficerPack extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local UITacticalHUD HUDScreen;

	`log("Starting TacticalHUD Listener OnInit");

	if(Screen == none)
	{
		`RedScreen("UITacticalHUD ScreenListener: Screen == none");
		return;
	}
	HUDScreen = UITacticalHUD(Screen);
	if(HUDScreen == none)
	{
		`RedScreen("UITacticalHUD ScreenListener: HUDScreen == none");
		return;
	}
	UpdateMouseControls(HUDScreen);

	//Not working because can't create new archetype in UnrealEd
	// now spawn the CommandRange Actor, passing in the Archetype reference as the template
	//CRActor = ParentScreen.Spawn(class'LWCommandRange_Actor', ParentScreen, 'CommandRange',,,CRTemplate);

	class'LWOfficerUtilities'.static.GCandValidationChecks();
}

// This event is triggered after a screen receives focus
//event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen);

simulated function UpdateMouseControls(UITacticalHUD HUDScreen)
{
	//local UITacticalHUD HUDScreen;

	//HUDScreen = UITacticalHUD(Screen);
	if ((HUDScreen.m_kMouseControls != none) && (HUDScreen.Movie.IsMouseActive()))
	{
		HUDScreen.m_kMouseControls.Remove();
		HUDScreen.m_kMouseControls = HUDScreen.Spawn(class'UITacticalHUD_MouseControls_LWOfficerPack', HUDScreen);
		HUDScreen.m_kMouseControls.InitMouseControls();
		//HUDScreen.m_kMouseControls.UpdateControls();
	}
}


defaultProperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UITacticalHUD
	//ParticleSystemName = "LWCommandRange.Boundary.P_LeaderRange_Persistent"

	//Not working because can't create new archetype in UnrealEd
	//CRTemplate=LWCommandRange_Actor'LWCommandRange.LWCommandRange'
}