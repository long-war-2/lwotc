//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BreakSquadConcealment.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Breaks squad concealment without breaking the affected unit's
//           individual concealment.
//--------------------------------------------------------------------------------------- 

class X2Effect_BreakSquadConcealment extends X2Effect;

simulated protected function OnEffectAdded(
    const out EffectAppliedData ApplyEffectParameters,
    XComGameState_BaseObject kNewTargetState,
    XComGameState NewGameState,
    XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Player PlayerState;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;

	// Don't do anything if the squad is not in concealment.
	PlayerState = XComGameState_Player(History.GetGameStateForObjectID(ApplyEffectParameters.PlayerStateObjectRef.ObjectID));
	if (!PlayerState.bSquadIsConcealed)
		return;

	// Find an appropriate unit to break concealment on.
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.ControllingPlayer.ObjectID == PlayerState.ObjectID && !RetainsConcealment(UnitState))
		{
			UnitState.BreakConcealmentNewGameState(NewGameState);
			break;
		}
	}
}

static function bool RetainsConcealment(XComGameState_Unit UnitState)
{
	local XComGameStateHistory History;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;

	History = `XCOMHISTORY;

	foreach UnitState.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState != none)
		{
			if (EffectState.GetX2Effect().RetainIndividualConcealment(EffectState, UnitState))
			{
				return true;
			}
		}
	}

	return false;
}
