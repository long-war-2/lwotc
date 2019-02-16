//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_AcquireHackRewardOverride.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Uses new XComGame TriggerEvent to override logic to add items to inventory
//---------------------------------------------------------------------------------------

class UIScreenListener_AcquireHackRewardOverride extends UIScreenListener config(LW_Overhaul) deprecated;

var bool bCreated;

//DEPRECATED - functionality now in XComGameState_Effect_Failsafe

// This event is triggered after a screen is initialized
//event OnInit(UIScreen Screen)
//{
	//if(!bCreated)
	//{
		//InitListeners();
		//bCreated = true;
	//}
//}

function InitListeners()
{
	local X2EventManager EventMgr;
	local Object ThisObj;

	ThisObj = self;
	EventMgr = `XEVENTMGR;
	EventMgr.RegisterForEvent(ThisObj, 'PreAcquiredHackReward', PreAcquiredHackReward,,,,true);
}

function EventListenerReturn PreAcquiredHackReward(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideHackRewardTuple;
	local XComGameState_Unit		Hacker;
	local XComGameState_BaseObject	HackTarget;
	local X2HackRewardTemplate		HackTemplate;

	OverrideHackRewardTuple = XComLWTuple(EventData);
	if(OverrideHackRewardTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverrideHackRewardTuple : Parsed XComLWTuple.");

	HackTemplate = X2HackRewardTemplate(EventSource);
	if(HackTemplate == none)
		return ELR_NoInterrupt;
	//`LOG("OverrideHackRewardTuple : EventSource valid.");

	if(OverrideHackRewardTuple.Id != 'OverrideHackRewards')
		return ELR_NoInterrupt;

	Hacker = XComGameState_Unit(OverrideHackRewardTuple.Data[1].o);
	HackTarget = XComGameState_BaseObject(OverrideHackRewardTuple.Data[2].o); // not necessarily a unit, could be a Hackable environmental object

	if(Hacker == none || HackTarget == none)
		return ELR_NoInterrupt;

	`LOG("PreAcquiredHackReward : working!.");

	return ELR_NoInterrupt;
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UITacticalHUD;
}
