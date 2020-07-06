
//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_NotLost.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Condition that specifies that target can't be lost
//---------------------------------------------------------------------------------------
class X2Condition_NotLost extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
    local XComGameState_Unit UnitState;
    
    UnitState = XComGameState_Unit(kTarget);
    
    if (UnitState != none)
    {
        if ( UnitState.GetTeam() != eTeam_TheLost )
        {
            return 'AA_Success'; 
        }
    }
    else return 'AA_NotAUnit';

    return 'AA_AbilityUnavailable';
}