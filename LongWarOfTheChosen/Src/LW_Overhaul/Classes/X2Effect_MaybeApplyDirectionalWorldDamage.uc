//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_MaybeApplyDirectionalWorldDamage.uc
//  AUTHOR:  Xylthixlm
//  PURPOSE: Fixes vanilla code that ignores apply chance for Sat Fire
//---------------------------------------------------------------------------------------

class X2Effect_MaybeApplyDirectionalWorldDamage extends X2Effect_ApplyDirectionalWorldDamage;

simulated function ApplyDirectionalDamageToTarget(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit, XComGameState NewGameState)
{
	if (`SYNC_RAND(100) < ApplyChance)
		super.ApplyDirectionalDamageToTarget(SourceUnit, TargetUnit, NewGameState);
}