//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SolaceAura_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Custom version of the vanilla aura-based Solace effect that incorporates
//           ability target conditions to determine whether it's affecting a target
//           or not.
//---------------------------------------------------------------------------------------
class X2Effect_SolaceAura_LW extends X2Effect_Solace;

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	local XComGameState_Ability AbilityState;
	local X2Condition CurrentCondition;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	foreach AbilityState.GetMyTemplate().AbilityMultiTargetConditions(CurrentCondition)
	{
		// If any of the target conditions fails, then the target isn't
		// eligible for Solace protection regardless of anything else.
		if (CurrentCondition.MeetsCondition(TargetUnit) != 'AA_Success') return false;
	}

	return super.IsEffectCurrentlyRelevant(EffectGameState, TargetUnit);
}

DefaultProperties
{
	DuplicateResponse=eDupe_Allow
}
