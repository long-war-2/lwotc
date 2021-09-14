class X2Condition_FineControl extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{ 
	local XComGameState_Unit TargetUnit, SourceUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	SourceUnit = XComGameState_Unit(kSource);
	if (TargetUnit != none && SourceUnit != none)
	{
		if (SourceUnit.IsFriendlyUnit(TargetUnit) && SourceUnit.HasSoldierAbility('LWFineControl', true))
			return 'AA_NotInRange';
	}
	//return 'AA_NotAUnit';

	return 'AA_Success'; 
}