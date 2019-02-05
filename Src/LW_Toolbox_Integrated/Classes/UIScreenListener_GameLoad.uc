//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_GameLoad
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Implements hooks to handle loads into tactical game, to make sure that toolbox options are loaded properly
//--------------------------------------------------------------------------------------- 

class UIScreenListener_GameLoad extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local XComGameState_LWToolboxOptions ToolboxOptions;
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();

	//handle the case where we aren't loading into strategy, but still need to update stuff
	class'X2DownloadableContentInfo_LWToolbox'.static.OnLoadedSavedGameToStrategy();

	//re-register the hit point observer if necessary
	if(ToolboxOptions.bRedFogXComActive || ToolboxOptions.bRedFogAliensActive)
		`XCOMHISTORY.RegisterOnNewGameStateDelegate(ToolboxOptions.OnNewGameState_HealthWatcher);
}

// This event is triggered after a screen receives focus
//event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen);

defaultproperties
{
	// AlienHunters update -- only have to listen for TacticalHUD, as strategy game is handled in X2DLCInfo
	ScreenClass = UITacticalHUD;
}
