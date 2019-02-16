//--------------------------------------------------------------------------------------- 
//  FILE:    X2Condition_CoupDeGrace.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Adds Coup de Grace condition that target have the correct impairing effect
//---------------------------------------------------------------------------------------
class X2Condition_CoupDeGrace extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	if (TargetUnit.IsStunned() || TargetUnit.IsUnconscious() || TargetUnit.IsDisoriented())
		return 'AA_Success';

	return 'AA_UnitIsNotImpaired';
}

