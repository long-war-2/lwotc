//---------------------------------------------------------------------------------------
//  FILE:    LWGiveSoldierRewardWrapper.uc
//  AUTHOR:  Peter Ledbrook
//
//  PURPOSE: Wraps a GiveReward function delegate so that we can rank up any
//           faction soldier after they are given as a reward.
//--------------------------------------------------------------------------------------- 

class LWGiveSoldierRewardWrapper extends Object;

var int SoldierRank;
var delegate<X2RewardTemplate.GiveRewardDelegate> OriginalDelegateFn;

function GiveFactionSoldierReward(XComGameState NewGameState, XComGameState_Reward RewardState, optional StateObjectReference AuxRef, optional bool bOrder=false, optional int OrderHours=-1)
{
    local XComGameState_Unit UnitState;
    local int idx, OrigRank;

    // Call the original GiveRewardFn delegate
    OriginalDelegateFn(NewGameState, RewardState, AuxRef, bOrder, OrderHours);

    // Rank up the soldier to the requested rank
    UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
    OrigRank = UnitState.GetRank();
    if (OrigRank < SoldierRank)
    {
        `LWTrace("Ranking up " $ UnitState.GetSoldierClassTemplate().DataName $ " reward soldier to rank " $ SoldierRank);
        
		UnitState.SetXPForRank(SoldierRank);
        UnitState.StartingRank = SoldierRank;
        
	    for (idx = 0; idx < SoldierRank - OrigRank; idx++)
        {
            UnitState.RankUpSoldier(NewGameState, UnitState.GetSoldierClassTemplate().DataName);
        }
    }
}
