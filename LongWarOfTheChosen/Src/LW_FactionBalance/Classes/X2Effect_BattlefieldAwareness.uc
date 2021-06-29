//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BattlefieldAwareness
//  AUTHOR:  Grobobobo
//  PURPOSE: Gives Untouchable, but with cooldown
//---------------------------------------------------------------------------------------
class X2Effect_BattlefieldAwareness extends X2Effect_Persistent;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	if (TargetUnit.IsAbleToAct())
	{	

		if (TargetUnit.Untouchable > 0)
		{
			NewHitResult = eHit_Untouchable;
			`XEVENTMGR.TriggerEvent('BattlefieldAwarenessTriggered', TargetUnit, TargetUnit);
			return true;
		}
	}
	return false;
}

protected simulated function OnEffectAdded (const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(kNewTargetState);

	if (SourceUnit.Untouchable < class'X2Ability_RangerAbilitySet'.default.MAX_UNTOUCHABLE || class'X2Ability_RangerAbilitySet'.default.MAX_UNTOUCHABLE < 1)
	{
		SourceUnit.Untouchable++;
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
