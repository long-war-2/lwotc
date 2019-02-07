///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Whirlwind
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for Whirlwind ability 
//			This is a triggering effect makes the unit melee attack each unit while making a single move
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Whirlwind extends X2Effect_Persistent config(LW_PerkPack);

 var config int WHIRLWIND_COOLDOWN;

 //add a component to XComGameState_Effect to listen for successful unit hacks
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_Whirlwind WhirlwindEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;
	local XComGameState_Unit TargetUnit;

	EventMgr = `XEVENTMGR;

	//add a move action point
	TargetUnit = XComGameState_Unit(kNewTargetState);
	TargetUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);

	if (GetEffectComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		WhirlwindEffectState = XComGameState_Effect_Whirlwind(NewGameState.CreateStateObject(class'XComGameState_Effect_Whirlwind'));
		WhirlwindEffectState.InitComponent(NewEffectState);
		NewEffectState.AddComponentObject(WhirlwindEffectState);
		NewGameState.AddStateObject(WhirlwindEffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = WhirlwindEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("Whirlwind: Failed to find Whirlwind Component when registering listener");
		return;
	}
	//`LOG("PerkPack(Whirlwind): Registering for event UnitMoveFinished");
	//register object moved with slightly higher priority so a final move action can trigger attack(s) before effect ends
	EventMgr.RegisterForEvent(ListenerObj, 'ObjectMoved', WhirlwindEffectState.OnUnitEnteredTile, ELD_OnStateSubmitted, 60, TargetUnit);

	EventMgr.RegisterForEvent(ListenerObj, 'UnitMoveFinished', WhirlwindEffectState.OnUnitMoveFinished, ELD_OnStateSubmitted);

	//register a gamestate observer to watch for unit movement and insert attack actions
	//`XCOMHISTORY.RegisterOnNewGameStateDelegate(WhirlwindEffectState.OnNewGameState);
}

static function XComGameState_Effect_Whirlwind GetEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_Whirlwind(Effect.FindComponentObject(class'XComGameState_Effect_Whirlwind'));
	return none;
}


//simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
//{
	//local XComGameState_Effect_Whirlwind WhirlwindEffectState;
//
	//super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
//
	//WhirlwindEffectState = GetEffectComponent(RemovedEffectState);
	////un-register the gamestate observer that was watching for unit movement
	//`XCOMHISTORY.UnRegisterOnNewGameStateDelegate(WhirlwindEffectState.OnNewGameState);
//}


//function SubmitNewGameState(out XComGameState NewGameState)
//{
	//if (NewGameState.GetNumGameStateObjects() > 0)
		//`TACTICALRULES.SubmitGameState(NewGameState);
	//else
		//`XCOMHISTORY.CleanupPendingGameState(NewGameState);
//}