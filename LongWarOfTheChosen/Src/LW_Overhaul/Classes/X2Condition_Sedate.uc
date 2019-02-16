//--------------------------------------------------------------------------------------- 
//  FILE:    X2Condition_Sedate.uc
//  AUTHOR:  JL (Pavonis Interactive)
//  PURPOSE: Adds Sedate condition that target have the correct impairing effect
//---------------------------------------------------------------------------------------
class X2Condition_Sedate extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	if (TargetUnit.IsStunned() || TargetUnit.IsDisoriented() || TargetUnit.bPanicked)
		return 'AA_Success';

	//if TargetUnit.IsPoisoned()
		//return 'AA_Success';

	//if (TargetUnit.GetCurrentStat(eStat_Mobility) <= 8)
		//return 'AA_Success';

	return 'AA_UnitIsNotImpaired';
}