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
    local string ResultsHeader, RewardDetailsString, SummaryString;

    ResultsHeader = CovertActions_SlotsHeader;

    // Did this covert action fail?
    if (class'Utilities_LW'.static.DidCovertActionFail(GetAction()))
    {
        // Show the failure in the screen header.
        ResultsHeader $= ("&nbsp;" $ strCovertActionFailed);
        RewardDetailsString = "";
        SummaryString = "";
    }
    else
    {
        RewardDetailsString = GetRewardDetailsString();
        SummaryString = GetActionDescription();
    }

	if (DoesActionHaveRewards())
		AS_SetInfoData(GetActionImage(), CovertActions_ScreenHeader, ResultsHeader, Caps(GetActionName()), SummaryString, class'UICovertActions'.default.CovertActions_RewardHeader, GetRewardString(), RewardDetailsString);
	else
		AS_SetInfoData(GetActionImage(), CovertActions_ScreenHeader, ResultsHeader, Caps(GetActionName()), SummaryString, "", "", "");
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
