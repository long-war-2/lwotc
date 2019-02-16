//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_JavelinRockets.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Increases range of rockets
//---------------------------------------------------------------------------------------
class X2Effect_JavelinRockets extends X2Effect_Persistent;

//add a component to XComGameState_Effect to listen for successful unit hacks
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_JavelinRockets JavelinRocketsEffectState;
	local X2EventManager EventMgr;
	local Object								ListenerObj;

	EventMgr = `XEVENTMGR;
	if (GetEffectComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		JavelinRocketsEffectState = XComGameState_Effect_JavelinRockets(NewGameState.CreateStateObject(class'XComGameState_Effect_JavelinRockets'));
		JavelinRocketsEffectState.InitComponent();
		NewEffectState.AddComponentObject(JavelinRocketsEffectState);
		NewGameState.AddStateObject(JavelinRocketsEffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = JavelinRocketsEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("JavelinRockets: Failed to find JavelinRockets Component when registering listener");
		return;
	}
	EventMgr.RegisterForEvent(ListenerObj, 'OnGetItemRange', JavelinRocketsEffectState.OnGetItemRange);
}

static function XComGameState_Effect_JavelinRockets GetEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_JavelinRockets(Effect.FindComponentObject(class'XComGameState_Effect_JavelinRockets'));
	return none;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="JavelinRockets";
	bRemoveWhenSourceDies=true;
}