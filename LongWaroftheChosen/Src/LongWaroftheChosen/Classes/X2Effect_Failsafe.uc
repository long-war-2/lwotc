//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Failsafe.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Failsafe Effect
//---------------------------------------------------------------------------------------
class X2Effect_Failsafe extends X2Effect_Persistent;

//add a component to XComGameState_Effect to listen for successful unit hacks
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_Failsafe FailsafeEffectState;
	local X2EventManager EventMgr;
	local Object								ListenerObj, EffectObj;
	local XComGameState_Unit					UnitState;

	EventMgr = `XEVENTMGR;
	EffectObj = NewEffectState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (GetEffectComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		FailsafeEffectState = XComGameState_Effect_Failsafe(NewGameState.CreateStateObject(class'XComGameState_Effect_Failsafe'));
		FailsafeEffectState.InitComponent();
		NewEffectState.AddComponentObject(FailsafeEffectState);
		NewGameState.AddStateObject(FailsafeEffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = FailsafeEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("Failsafe: Failed to find Failsafe Component when registering listener");
		return;
	}
	EventMgr.RegisterForEvent(ListenerObj, 'PreAcquiredHackReward', FailsafeEffectState.PreAcquiredHackReward,,,,true);
	EventMgr.RegisterForEvent(EffectObj, 'FailsafeTriggered', NewEffectState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

static function XComGameState_Effect_Failsafe GetEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_Failsafe(Effect.FindComponentObject(class'XComGameState_Effect_Failsafe'));
	return none;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="Failsafe";
	bRemoveWhenSourceDies=true;
}