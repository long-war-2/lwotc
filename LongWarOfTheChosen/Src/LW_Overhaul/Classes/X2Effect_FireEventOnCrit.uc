//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_FireEventOnCrit.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Triggers a specified custom event name when a unit crits the enemy.
//           This is a slightly modified version of `X2Effect_KilledEnemy` that
//           is primarily for triggering Combat Rush.
//--------------------------------------------------------------------------------------- 

class X2Effect_FireEventOnCrit extends X2Effect_Persistent config(LW_SoldierSkills);

var name EventId;
var bool bShowActivation;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local XComGameState_Unit UnitState;
	local X2EventManager EventMgr;
	local Object EffectObj;

	if (bshowactivation)
	{
		EventMgr = `XEVENTMGR;
		EffectObj = EffectGameState;
		UnitState = XComGameState_Unit(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		EventMgr.RegisterForEvent(EffectObj, EventId, EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted,, UnitState);  
	}
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Ability AbilityState;
	local X2EventManager EventMgr;

	if (AbilityContext.ResultContext.HitResult == eHit_Crit ||
			AbilityContext.ResultContext.MultiTargetHitResults.Find(eHit_Crit) != INDEX_NONE)
	{
		AbilityState = XComGameState_Ability(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		if (AbilityState != none)
		{
			EventMgr = `XEVENTMGR;	
			EventMgr.TriggerEvent(EventId, AbilityState, SourceUnit, NewGameState);
		}
	}

	return false;
}
