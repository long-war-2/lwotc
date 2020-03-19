//---------------------------------------------------------------------------------------
//  FILE:    UICovertActions_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Slightly modified version of the standard UICovertActions screen that can
//           display any strategy costs for the covert action. Required for the training
//           covert actions that use up ability points.
//---------------------------------------------------------------------------------------

class UICovertActions_LW extends UICovertActions;

var localized string strCovertActionFailed;

simulated function String GetRewardDetailsString()
{
    local XComGameState_CovertAction CAState;

    CAState = GetAction();
    if (CAState.HasCost())
    {
        return class'UIUtilities_Text'.static.GetColoredText(CovertActions_Cost $ " " $ CAState.GetCostString(), eUIState_Bad) $
                ". " $ super.GetRewardDetailsString();
    }
    else
    {
        return super.GetRewardDetailsString();
    }
}
