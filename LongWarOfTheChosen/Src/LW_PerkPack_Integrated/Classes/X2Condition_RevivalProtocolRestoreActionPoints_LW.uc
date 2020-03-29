//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_RevivalProtocolRestoreActionPoints_LW.uc
//  AUTHOR:  Peter ledbrook
//  PURPOSE: Used by Revival Protocol to determine whether X2Effect_RestoreActionPoints
//           should be applied.
//---------------------------------------------------------------------------------------
class X2Condition_RevivalProtocolRestoreActionPoints_LW extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;

    // This condition applies to the effect, so we can assume the target is a unit.
    // In other words, we are relying on the ability targeting ensuring that the
    // target is valid for Revival Protocol.
    TargetUnit = XComGameState_Unit(kTarget);

    // Only allow action points to be restored for units that aren't disoriented
    // (stunned is handled by X2Effect_StunRecover).
	if (TargetUnit.IsPanicked() || TargetUnit.IsUnconscious() || TargetUnit.IsDazed())
        return 'AA_Success';

    return 'AA_UnitIsNotImpaired';
}
