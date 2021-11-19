class X2Condition_ExcludeChosen extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	

	if (TargetUnit.IsChosen())
		return 'AA_UnitIsImmune';

	return 'AA_Success'; 
}
