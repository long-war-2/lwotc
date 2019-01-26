//--------------------------------------------------------------------------------------- 
//  FILE:    X2Condition_RequireConcealed.uc
//  AUTHOR:  JL (Pavonis Interactive)
//  PURPOSE: Allows ability activition only when concealed
//---------------------------------------------------------------------------------------
class X2Condition_RequireConcealed extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit (kTarget);
	if (UnitState == none)
		return 'AA_UnitAlreadySpotted';

	if (UnitState.IsConcealed())
	    return 'AA_Success';

	return 'AA_UnitAlreadySpotted';

}