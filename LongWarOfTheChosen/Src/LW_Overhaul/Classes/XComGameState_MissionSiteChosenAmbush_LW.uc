//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteChosenAmbush_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: A version of XCGS_MissionSiteChosenAmbush that doesn't override the
//           squad selection before starting the mission.
//---------------------------------------------------------------------------------------
class XComGameState_MissionSiteChosenAmbush_LW extends XComGameState_MissionSiteChosenAmbush;

function SelectSquad()
{
    super(XComGameState_MissionSite).SelectSquad();
}
