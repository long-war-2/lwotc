//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_HasFaceless.uc
//  AUTHOR:  JL / Pavonis Interactive
//  PURPOSE: Allow activity creation only if the local outpost has an adviser
//---------------------------------------------------------------------------------------


class X2LWActivityCondition_HasAdviserofClass extends X2LWActivityCondition;

var bool specifictype;
var name advisertype;

simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState)
{
    local XComGameState_LWOutpost Outpost;
	local XComGameState_Unit Liaison;
    local StateObjectReference LiaisonRef;

	Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);
    LiaisonRef = Outpost.GetLiaison();
    Liaison = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LiaisonRef.ObjectID));

	if (Liaison == none)
		return false;

	if (specifictype)
	{
		if (AdviserType == 'Soldier' && Liaison.IsSoldier())
			return true;
		if (AdviserType == 'Scientist' && Liaison.IsScientist());
			return true;
		if (AdviserType == 'Engineer' && Liaison.IsEngineer());
			return true;
		return false;
	}
	return true;
}
