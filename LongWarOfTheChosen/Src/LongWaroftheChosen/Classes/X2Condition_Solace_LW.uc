//--------------------------------------------------------------------------------------- 
//  FILE:    X2Condition_Solace_LW.uc
//  AUTHOR:  JL (Pavonis Interactive)
//  PURPOSE: Adds Solace condition that target have the correct impairing effect
//---------------------------------------------------------------------------------------
class X2Condition_Solace_LW extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	//`LOG (TargetUnit.GetLastName() @ "checking Solace_LW condition");

	if (TargetUnit.IsAdvent() || TargetUnit.IsAlien() || TargetUnit.IsRobotic())
		return 'AA_UnitIsWrongType';

	if (TargetUnit.GetTeam() == 1)
		return 'AA_UnitIsWrongType';

	if (TargetUnit.IsStunned() || TargetUnit.IsDisoriented() || TargetUnit.bPanicked || TargetUnit.IsMindControlled() || TargetUnit.IsPanicked())
	{
		//`LOG (TargetUnit.GetLastName() @ "passes Solace_LW condition");
		return 'AA_Success';
	}

	return 'AA_UnitIsNotImpaired';
}