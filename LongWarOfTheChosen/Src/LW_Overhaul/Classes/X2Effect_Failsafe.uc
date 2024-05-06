//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Failsafe.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Failsafe Effect
//---------------------------------------------------------------------------------------
class X2Effect_Failsafe extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	// allows activation/deactivation of effect
	EventMgr.RegisterForEvent(EffectObj, 'PreAcquiredHackReward', PreAcquiredHackReward,,,, true, EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'FailsafeTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted,, UnitState);
	EventMgr.RegisterForEvent(EffectObj, 'FailsafeTriggered', FailsafeGiveAP, ELD_OnStateSubmitted,, UnitState);
}

// this is triggered just before acquiring a hack reward, giving a chance to skip adding the negative one
static function EventListenerReturn PreAcquiredHackReward(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideHackRewardTuple;
	local XComGameState_Effect		EffectState;
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

	EffectState = XComGameState_Effect(CallbackData);
	Hacker = XComGameState_Unit(OverrideHackRewardTuple.Data[1].o);
	HackTarget = XComGameState_BaseObject(OverrideHackRewardTuple.Data[2].o); // not necessarily a unit, could be a Hackable environmental object

	if(Hacker == none || HackTarget == none)
		return ELR_NoInterrupt;

	if(Hacker == none || Hacker.ObjectID != EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID)
		return ELR_NoInterrupt;

	if(HackTemplate.bBadThing)
	{
		if(`SYNC_RAND_STATIC(100) < class'X2Ability_LW_SpecialistAbilitySet'.default.FAILSAFE_PCT_CHANCE)
		{
			OverrideHackRewardTuple.Data[0].b = true;
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			`XEVENTMGR.TriggerEvent('FailsafeTriggered', AbilityState, Hacker, NewGameState);
		}
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn FailsafeGiveAP(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState UpdatedGameState;
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(EventSource);

	`LWTrace("FailsafeGiveAP firing");

	if (UnitState == none)
	{
		`LWTrace("No Unit");
		return ELR_NoInterrupt;
	}
	if(GameState != none)
	{
		`LWTrace("NewGameState passed");
		UnitState = XComGameState_Unit(GameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

		UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
	}
	else
	{
		`LWTrace("No Gamestate passed");
		UpdatedGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding FailSafe AP");

		UnitState = XComGameState_Unit(UpdatedGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

		UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);

		`TACTICALRULES.SubmitGameState(UpdatedGameState);
	}

	

	

	return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="Failsafe";
	bRemoveWhenSourceDies=true;
}
