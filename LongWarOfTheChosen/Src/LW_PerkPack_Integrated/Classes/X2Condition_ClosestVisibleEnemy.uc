class X2Condition_ClosestVisibleEnemy extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local array<StateObjectReference> VisibleUnits;
	local XComGameState_Unit TargetUnit, SourceUnit, VisibleUnit;
	local int TargetDistance;
	local StateObjectReference UnitRef;
	local XComGameStateHistory History;
	local bool bSeen;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	SourceUnit = XComGameState_Unit(kSource);
	if (SourceUnit == none)
		return 'SS_NotAUnit';

	History = `XCOMHISTORY;

	TargetDistance = SourceUnit.TileDistanceBetween(TargetUnit);

	class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyUnitsForUnit(kSource.ObjectID, VisibleUnits);
	class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(kSource.ObjectID, VisibleUnits);

	foreach VisibleUnits(UnitRef)
	{
		VisibleUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));		

		if (SourceUnit.TileDistanceBetween(VisibleUnit) < TargetDistance)
			return 'AA_UnknownError';

		if (UnitRef.ObjectID == kTarget.ObjectID)
			bSeen = true;
	}

	if (!bSeen)
		return 'AA_UnknownError';

	return 'AA_Success';
}