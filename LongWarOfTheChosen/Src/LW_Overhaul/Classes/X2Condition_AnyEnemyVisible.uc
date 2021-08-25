class X2Condition_AnyEnemyVisible extends X2Condition;


event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kTarget);
    if(UnitState.GetNumVisibleEnemyUnits(true,true) < 1)
    {
        return 'AA_NoTargets';
    }
	else
	{
		return 'AA_Success';
	}
}