//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_DropShipBriefing_MissionStart
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Changes text on UI to be more congruent with infiltration
//--------------------------------------------------------------------------------------- 

class UIScreenListener_DropShipBriefing_MissionStart extends UIScreenListener;

var localized string strLaunchingInfiltration;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local XComGameStateHistory History;
	local UIDropShipBriefing_MissionStart MissionStart;
	local XComGameState_BattleData BattleData;	
	local XComGameState_MissionSite MissionSiteState;

	MissionStart = UIDropShipBriefing_MissionStart(Screen);
	if (MissionStart == none)
		return;

	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionSiteState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));

	if (`LWSQUADMGR.IsValidInfiltrationMission(MissionSiteState.GetReference()))
	{
		MissionStart.MC.ChildSetString("loadingText.theText", "htmlText", strLaunchingInfiltration);
	}
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIDropShipBriefing_MissionStart;
}