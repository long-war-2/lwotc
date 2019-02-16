///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Trojan
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for Trojan ability -- this is a triggering effect that occurs
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Trojan extends X2Effect_Persistent;

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

//add a component to XComGameState_Effect to listen for successful unit hacks
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_Trojan TrojanEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	EventMgr = `XEVENTMGR;

	if (GetEffectComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		TrojanEffectState = XComGameState_Effect_Trojan(NewGameState.CreateStateObject(class'XComGameState_Effect_Trojan'));
		TrojanEffectState.InitComponent();
		NewEffectState.AddComponentObject(TrojanEffectState);
		NewGameState.AddStateObject(TrojanEffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = TrojanEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("Trojan: Failed to find Trojan Component when registering listener");
		return;
	}
	`PPDEBUG("PerkPack(Trojan): Registering for event XpSuccessfulHack");
	EventMgr.RegisterForEvent(ListenerObj, 'XpSuccessfulHack', TrojanEffectState.OnSuccessfulHack, ELD_OnStateSubmitted,,,true);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;
	
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetEffectComponent(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_Trojan GetEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_Trojan(Effect.FindComponentObject(class'XComGameState_Effect_Trojan'));
	return none;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="Trojan";
	bRemoveWhenSourceDies=true;
}