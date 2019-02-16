///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Savior
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for Savior ability -- this is a triggering effect that occurs when a medikit heal is applied
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Savior extends X2Effect_Persistent config(LW_SoldierSkills);

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var localized string strSavior_WorldMessage;
var config int SaviorBonusHealAmount;

//add a component to XComGameState_Effect to listen for medikit heal being applied
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_Savior SaviorEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	EventMgr = `XEVENTMGR;

	if (GetEffectComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		SaviorEffectState = XComGameState_Effect_Savior(NewGameState.CreateStateObject(class'XComGameState_Effect_Savior'));
		SaviorEffectState.InitComponent();
		NewEffectState.AddComponentObject(SaviorEffectState);
		NewGameState.AddStateObject(SaviorEffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = SaviorEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("Savior: Failed to find Savior Component when registering listener");
		return;
	}
	`PPDEBUG("PerkPack(Savior): Registering for event XpHealDamage");
	EventMgr.RegisterForEvent(ListenerObj, 'XpHealDamage', SaviorEffectState.OnMedikitHeal, ELD_OnStateSubmitted,,,true);
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

static function XComGameState_Effect_Savior GetEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_Savior(Effect.FindComponentObject(class'XComGameState_Effect_Savior'));
	return none;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="Savior";
	bRemoveWhenSourceDies=true;
}