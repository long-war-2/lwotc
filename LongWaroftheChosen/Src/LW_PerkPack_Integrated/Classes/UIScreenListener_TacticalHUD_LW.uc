//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_TacticalHUD_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Listens to TacticalHUD and kills/replaces AbilityContainer if needed
//--------------------------------------------------------------------------------------- 

class UIScreenListener_TacticalHUD_LW extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local XComGameState_LWPerkPackOptions PerkPackOptions;
	local UITacticalHUD HUDScreen;
	
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

	PerkPackOptions = class'XComGameState_LWPerkPackOptions'.static.GetPerkPackOptions();
	if(!PerkPackOptions.bDefaultTacticalAbilityContainer)
	{
		HUDScreen = UITacticalHUD(Screen);
		HUDScreen.m_kAbilityHUD.Remove();
		HUDScreen.m_kAbilityHUD = HUDScreen.Spawn(class'UITacticalHUD_AbilityContainer_LWExtended',HUDScreen);
        // Make sure to initialize m_iPreviousIndexForSecondaryMovement, which isn't initialized either by
        // the defaultproperties in that class nor in InitAbilityContainer, it's done by the TacticalHUD when
        // raising and lowering the targeting system.
        if (!HUDScreen.m_isMenuRaised)
        {
            HUDScreen.m_kAbilityHUD.m_iPreviousIndexForSecondaryMovement = -1;
        }
		HUDScreen.m_kAbilityHUD.InitAbilityContainer();
	}
}

//This event is triggered after a screen receives focus
//event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);


// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen);

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UITacticalHUD;
}