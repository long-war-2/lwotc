class X2DownloadableContentInfo_LW_Tutorial extends X2DownloadableContentInfo;

static event OnExitPostMissionSequence()
{
	// Handle tutorial at campaign start. The objective is cleared the first
	// time the player goes into the Geoscape, so this will only execute after
	// Operation Gatecrasher.
	class'LWTutorial'.static.DoCampaignStart();
}
