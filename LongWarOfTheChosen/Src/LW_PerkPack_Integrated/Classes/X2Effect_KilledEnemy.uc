//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_KilledEnemy
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Triggers a specified custom event name when you kill somebody, which can be
// used to trigger unique effects, like Combat Rush
//--------------------------------------------------------------------------------------- 

Class X2Effect_KilledEnemy extends X2Effect_Persistent config (LW_SoldierSkills);

var name eventid;
var bool bShowActivation;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'KillMail', UnitDiedEventListener, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn UnitDiedEventListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Effect EffectState;
	local XComGameState_Unit SourceUnit;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability Ability;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	EffectState = XComGameState_Effect(CallbackData);
	if (EffectState != none)
	{
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
		{
			if (AbilityContext.InputContext.SourceObject.ObjectID == SourceUnit.ObjectID)
			{
				Ability = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.FindAbility('BroadcastCombatRush').ObjectID));
				if (Ability != none) {
					Ability.AbilityTriggerAgainstSingleTarget(SourceUnit.GetReference(), false);    
				}
			}
		}
	}

	return ELR_NoInterrupt;
}
