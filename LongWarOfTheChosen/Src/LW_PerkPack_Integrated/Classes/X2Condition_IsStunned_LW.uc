//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_IsStunned_LW.uc
//  AUTHOR:  Peter ledbrook
//  PURPOSE: A condition that returns true if the unit is stunned. Required by
//           Revival Protocol so that it can use the appropriate Effect for
//           restoring action points.
//---------------------------------------------------------------------------------------
class X2Condition_IsStunned_LW extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;

    TargetUnit = XComGameState_Unit(kTarget);
    if (TargetUnit == none) return 'AA_NotAUnit';

    if (TargetUnit.IsStunned() || TargetUnit.StunnedActionPoints > 0 || TargetUnit.StunnedThisTurn > 0)
    {
        return 'AA_Success';
    }
    else
    {
        return 'AA_MissingRequiredEffect';
    }
}
