//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_TacticalHUD_LWAlienPack
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Launches a polling actor to update AlienCustomizations after they are loaded
//---------------------------------------------------------------------------------------

class UIScreenListener_TacticalHUD_LWAlienPack extends UIScreenListener;


// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
       // not needed since we aren't going to try and install the AlienCustomization manager when loading into tactical mission
       //class'X2DownloadableContentInfo_LWAlienPack'.static.AddAndRegisterCustomizationManager();

       Screen.Spawn(class'LWUpdateAlienCustomizationAction', Screen);
}

// This event is triggered after a screen receives focus
//event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen)'

defaultproperties
{
       // Leave this none so it can be triggered anywhere, gate inside the OnInit
       ScreenClass = UITacticalHUD;
}
