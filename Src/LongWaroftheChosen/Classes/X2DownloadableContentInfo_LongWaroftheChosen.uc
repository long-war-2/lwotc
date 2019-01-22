//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_LongWaroftheChosen.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_LongWaroftheChosen extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	`Log("*********************** Starting OnLoadedSavedGame *************************");
	class'X2DownloadableContentInfo_LWSMGPack'.static.OnLoadedSavedGame();
	class'X2DownloadableContentInfo_LWLaserPack'.static.OnLoadedSavedGame();
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	class'X2DownloadableContentInfo_LW_Overhaul'.static.OnPostTemplatesCreated();
	class'X2DownloadableContentInfo_LWSMGPack'.static.OnPostTemplatesCreated();
	class'X2DownloadableContentInfo_LWLaserPack'.static.OnPostTemplatesCreated();
}
