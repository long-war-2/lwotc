//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Collector
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Implements effect for Collector ability
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Collector extends X2Effect_Persistent config(LW_OfficerPack);



//add a component to XComGameState_Effect to track cumulative number of attacks
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_Collector EffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	EventMgr = `XEVENTMGR;

	if (GetCollectorComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		EffectState = XComGameState_Effect_Collector(NewGameState.CreateStateObject(class'XComGameState_Effect_Collector'));
		EffectState.InitComponent();
		NewEffectState.AddComponentObject(EffectState);
		NewGameState.AddStateObject(EffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = EffectState;
	if (ListenerObj == none)
	{
		`Redscreen("Collector: Failed to find Collector Component when registering listener");
		return;
	}

	EventMgr.RegisterForEvent(ListenerObj, 'KillMail', EffectState.CollectionCheck, ELD_OnStateSubmitted,,,true);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;
	
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetCollectorComponent(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_Collector GetCollectorComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_Collector(Effect.FindComponentObject(class'XComGameState_Effect_Collector'));
	return none;
}

defaultproperties
{
	EffectName=Collector;
	bRemoveWhenSourceDies=false;
}
