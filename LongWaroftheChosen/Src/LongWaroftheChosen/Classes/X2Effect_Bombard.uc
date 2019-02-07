//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Bombard.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Increases throw and launch range of grenades
//---------------------------------------------------------------------------------------
class X2Effect_Bombard extends X2Effect_Persistent;

//add a component to XComGameState_Effect to listen for successful unit hacks
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_Bombard BombardEffectState;
	local X2EventManager EventMgr;
	local Object								ListenerObj;

	EventMgr = `XEVENTMGR;
	if (GetEffectComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		BombardEffectState = XComGameState_Effect_Bombard(NewGameState.CreateStateObject(class'XComGameState_Effect_Bombard'));
		BombardEffectState.InitComponent();
		NewEffectState.AddComponentObject(BombardEffectState);
		NewGameState.AddStateObject(BombardEffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = BombardEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("Bombard: Failed to find Bombard Component when registering listener");
		return;
	}
	EventMgr.RegisterForEvent(ListenerObj, 'OnGetItemRange', BombardEffectState.OnGetItemRange);
}

static function XComGameState_Effect_Bombard GetEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_Bombard(Effect.FindComponentObject(class'XComGameState_Effect_Bombard'));
	return none;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="Bombardier";
	bRemoveWhenSourceDies=true;
}