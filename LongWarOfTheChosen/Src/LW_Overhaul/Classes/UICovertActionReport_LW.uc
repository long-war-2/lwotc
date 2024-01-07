//---------------------------------------------------------------------------------------
//  FILE:    UICovertActionReport_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Slightly modified version of the standard UICovertActionReport that can
//           display covert actions as failed.
//---------------------------------------------------------------------------------------

class UICovertActionReport_LW extends UICovertActionReport;

var localized string strCovertActionFailed;

simulated function RefreshMainPanel()
{
    local string ResultsHeader;

    ResultsHeader = CovertActions_SlotsHeader;

    // Did this covert action fail?
    if (class'Utilities_LW'.static.DidCovertActionFail(GetAction()))
    {
        // Show the failure in the screen header.
        ResultsHeader $= ("&nbsp;" $ strCovertActionFailed);
    }

	if (DoesActionHaveRewards())
		AS_SetInfoData(GetActionImage(), CovertActions_ScreenHeader, ResultsHeader, Caps(GetActionName()), GetActionDescription(), class'UICovertActions'.default.CovertActions_RewardHeader, GetRewardString(), GetRewardDetailsString());
	else
		AS_SetInfoData(GetActionImage(), CovertActions_ScreenHeader, ResultsHeader, Caps(GetActionName()), GetActionDescription(), "", "", "");
}

simulated function String GetRewardString()
{
    // Did this covert action fail?
    if (class'Utilities_LW'.static.DidCovertActionFail(GetAction()))
    {
        return" (" $ strCovertActionFailed $ ")";
    }
    else
    {
        return super.GetRewardString();
    }
}
