//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_HasFaceless.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//	PURPOSE: Allow activity creation only if the local outpost has faceless
//---------------------------------------------------------------------------------------


class X2LWActivityCondition_HasFaceless extends X2LWActivityCondition;

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
    local XComGameState_LWOutpost Outpost;

    Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);

    return Outpost.GetNumFaceless() > 0;
}
