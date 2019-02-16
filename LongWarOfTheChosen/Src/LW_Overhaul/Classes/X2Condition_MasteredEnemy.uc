//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_MasteredEnemy
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: Condition for determining if a unit has been mastered via the specialist full override, or is not mind controlled.
//           All units meet this condition unless they are under the influence of a mind control effect without being mastered.
//--------------------------------------------------------------------------------------- 

class X2Condition_MasteredEnemy extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

	// If this unit is not mind-controlled, or is affected by permanent override we're good.
	/* WOTC TODO: Restore when TransferMecToOutpost is back
	if (UnitState.AffectedByEffectNames.Find(class'X2Effect_MindControl'.default.EffectName) == -1 ||
		UnitState.AffectedByEffectNames.Find(class'X2Effect_TransferMecToOutpost'.default.EffectName) != -1)
	{
		return 'AA_Success';
	}

	return 'AA_AbilityUnavailable';
	*/
	return 'AA_Success';
}
