//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_NotItsOwnTurn.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Condition to not trigger an ability on the unit's turn
//---------------------------------------------------------------------------------------
class X2Condition_NotItsOwnTurn extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kTarget);

	if (UnitState != none)
	{
		if (`TACTICALRULES.GetUnitActionTeam() != UnitState.GetTeam())
		{
			return 'AA_Success'; 
		}
	}
	else return 'AA_NotAUnit';

	return 'AA_AbilityUnavailable';
}
