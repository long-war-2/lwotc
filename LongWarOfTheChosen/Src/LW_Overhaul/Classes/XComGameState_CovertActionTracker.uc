//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_CovertActionTracker.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Tracks information about covert actions across a campaign.
//---------------------------------------------------------------------------------------
class XComGameState_CovertActionTracker extends XComGameState_BaseObject;

var bool LastAmbushMissionFailed;
var int ActionsCompletedWithoutAmbush;

static function XComGameState_CovertActionTracker CreateOrGetCovertActionTracker(optional XComGameState NewGameState)
{
	local XComGameState_CovertActionTracker CATracker;

    CATracker = XComGameState_CovertActionTracker(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CovertActionTracker', true));
    if (CATracker != none)
        return CATracker;

	`Log("Creating Covert Action Tracker --------------------------------");

	if (NewGameState != none)
	{
		CATracker = XComGameState_CovertActionTracker(NewGameState.CreateNewStateObject(class'XComGameState_CovertActionTracker'));
	}
	else
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating Covert Action Tracker Singleton");
		CATracker = XComGameState_CovertActionTracker(NewGameState.CreateNewStateObject(class'XComGameState_CovertActionTracker'));
		`GAMERULES.SubmitGameState(NewGameState);
	}

    return CATracker;
}
