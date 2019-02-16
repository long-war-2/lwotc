//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_Failsafe.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is an effect component extension listening for successful hacks to apply the Failsafe Effect to the hacked unit
//---------------------------------------------------------------------------------------

class XComGameState_Effect_Failsafe extends XComGameState_BaseObject;

function XComGameState_Effect_Failsafe InitComponent()
{
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

// this is triggered just before acquiring a hack reward, giving a chance to skip adding the negative one
function EventListenerReturn PreAcquiredHackReward(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideHackRewardTuple;
	local XComGameState_Unit		Hacker;
	local XComGameState_BaseObject	HackTarget;
	local X2HackRewardTemplate		HackTemplate;
	local XComGameState_Ability		AbilityState;

	OverrideHackRewardTuple = XComLWTuple(EventData);
	if(OverrideHackRewardTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

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

	if(Hacker == none || Hacker.ObjectID != GetOwningEffect().ApplyEffectParameters.TargetStateObjectRef.ObjectID)
		return ELR_NoInterrupt;

	if(HackTemplate.bBadThing)
	{
		/* WOTC TODO: Restore this
		if(`SYNC_RAND(100) < class'X2Ability_LW_SpecialistAbilitySet'.default.FAILSAFE_PCT_CHANCE)
		{
			OverrideHackRewardTuple.Data[0].b = true;
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(GetOwningEffect().ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			`XEVENTMGR.TriggerEvent('FailsafeTriggered', AbilityState, Hacker, NewGameState);
		}
		*/
	}

	return ELR_NoInterrupt;
}
