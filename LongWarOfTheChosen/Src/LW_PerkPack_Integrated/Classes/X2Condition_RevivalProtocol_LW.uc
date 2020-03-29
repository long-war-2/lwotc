//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_RevivalProtocol_LW.uc
//  AUTHOR:  Peter ledbrook
//  PURPOSE: Allows Revival Protocol to also target stunned units.
//---------------------------------------------------------------------------------------
class X2Condition_RevivalProtocol_LW extends X2Condition_RevivalProtocol;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;
    local name Result;

	TargetUnit = XComGameState_Unit(kTarget);

    Result = super.CallMeetsCondition(kTarget);
    if (Result == 'AA_UnitIsNotImpaired' && TargetUnit != none && TargetUnit.IsStunned())
    {
        Result = 'AA_Success';
    }

    return Result;
}
