class X2Condition_FineControlDefensive extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{ 
	local XComGameState_Unit TargetUnit, SourceUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	SourceUnit = XComGameState_Unit(kSource);
	if (TargetUnit == none || SourceUnit == none)
		return 'AA_NotAUnit';

	if (SourceUnit.IsEnemyUnit(TargetUnit) && SourceUnit.HasSoldierAbility('LWFineControl', true))
		return 'AA_NotInRange';

	return 'AA_Success'; 
}