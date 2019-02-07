//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Armory_MainMenu_LWExpandedPerkTree
//  AUTHOR:  Amineri
//
//  PURPOSE: Implements hooks to add button to List in order to invoke Expanded Perk Tree for testing
//--------------------------------------------------------------------------------------- 

class UIScreenListener_SquadSelect extends UIScreenListener;

delegate OnMouseEventDelegate(UIPanel Panel, int Cmd);

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	`Log("UIScreenListener_SquadSelect: Initializing");
	if(Screen.IsA('UISquadSelect') || Screen.IsA('UISquadSelect_LW'))
		if(!class'UIArmory_MainMenu_LW'.default.bUse2WideAbilityTree && !class'XComGameState_LWPerkPackOptions'.static.IsBaseGamePerkUIEnabled())
			class'UIScreenListener_Armory_MainMenu_LWExpandedPerkTree'.static.DisableSoldierIntros();
}

//This event is triggered after a screen receives focus
//event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen)

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none;
}
