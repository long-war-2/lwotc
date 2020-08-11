//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_ConditionalStatChange.uc
//  AUTHOR:  xylthixlm
//
//  USAGE
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  Inspiration
//  Stalker
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  None.
//---------------------------------------------------------------------------------------
class XMBEffect_ConditionalStatChange extends X2Effect_PersistentStatChange;

var array<X2Condition> Conditions;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local XComGameState_Unit UnitState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	EventMgr = `XEVENTMGR;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	ListenerObj = EffectGameState;

	// Register to tick after EVERY action.
	EventMgr.RegisterForEvent(ListenerObj, 'OnUnitBeginPlay', EventHandler, ELD_OnStateSubmitted, 25, UnitState,, EffectGameState);	
	EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', EventHandler, ELD_OnStateSubmitted, 25,,, EffectGameState);	
}

static function EventListenerReturn EventHandler(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState, SourceUnitState, NewUnitState;
	local XComGameState_Effect NewEffectState;
	local XComGameState_Ability AbilityState;
	local XComGameState NewGameState;
	local XMBEffect_ConditionalStatChange EffectTemplate;
	local XComGameState_Effect EffectState;
	local bool bOldApplicable, bNewApplicable;

	EffectState = XComGameState_Effect(CallbackData);
	if (EffectState == none)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	// Once a unit is removed from play we don't want to apply the conditional stat changes anymore
	// As those can have permanent effects after tactical has ended
	// This is already handled by the game but for some reason the stats are still being permanently affect
	// Hopefully this is a fail safe to prevent stat modifiers after the unit has been removed from play
	if (UnitState.bRemovedFromPlay) 
	{								
		return ELR_NoInterrupt;
	}
	SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	EffectTemplate = XMBEffect_ConditionalStatChange(EffectState.GetX2Effect());

	bOldApplicable = EffectState.StatChanges.Length > 0;
	bNewApplicable = class'XMBEffectUtilities'.static.CheckTargetConditions(EffectTemplate.Conditions, EffectState, SourceUnitState, UnitState, AbilityState) == 'AA_Success';

	if (bOldApplicable != bNewApplicable)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Conditional Stat Change");

		NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
		NewEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(class'XComGameState_Effect', EffectState.ObjectID));

		if (bNewApplicable)
		{
			NewEffectState.StatChanges = EffectTemplate.m_aStatChanges;

			// Note: ApplyEffectToStats crashes the game if the state objects aren't added to the game state yet
			NewUnitState.ApplyEffectToStats(NewEffectState, NewGameState);
		}
		else
		{
			NewUnitState.UnApplyEffectFromStats(NewEffectState, NewGameState);
			NewEffectState.StatChanges.Length = 0;
		}

		`GAMERULES.SubmitGameState(NewGameState);
	}

	return ELR_NoInterrupt;
}


// From X2Effect_Persistent.
function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	return EffectGameState.StatChanges.Length > 0;
}


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	super(X2Effect_Persistent).OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}