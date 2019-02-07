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

	if (bshowactivation)
	{
		EventMgr = `XEVENTMGR;
		EffectObj = EffectGameState;
		UnitState = XComGameState_Unit(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		EventMgr.RegisterForEvent(EffectObj, eventid, EffectGameState.TriggerAbilityFlyover, 1,, UnitState);  
	}
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameState_Unit TargetUnit;
    local X2EventManager EventMgr;
    local XComGameState_Ability AbilityState;

   TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
   if(TargetUnit != none && TargetUnit.IsEnemyUnit(SourceUnit) && TargetUnit.IsDead())
   {
		AbilityState = XComGameState_Ability(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		if(AbilityState != none)
        {
			EventMgr = `XEVENTMGR;	
            EventMgr.TriggerEvent(eventid, AbilityState, SourceUnit, NewGameState);            
        }
    }
    return false;
}