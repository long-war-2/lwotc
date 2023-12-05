//---------------------------------------------------------------------------------------
//  FILE:    UIPersonnel_Liaison
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: UI for choosing a resistance haven liaison.
//--------------------------------------------------------------------------------------- 

class UIPersonnel_Liaison extends UIPersonnel;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
    super.InitScreen(InitController, InitMovie, InitName);
}


simulated function UpdateList()
{
    local int Idx;
    local UIPersonnel_ListItem ListItem;

    super.UpdateList();

    // Loop over all items and disable units that are ineligible for liaison duty
    for (Idx = 0; Idx < m_kList.itemCount; ++Idx)
    {
        ListItem = UIPersonnel_ListItem(m_kList.GetItem(Idx));
        if (!UnitAvailableForLiaisonDuty(ListItem.UnitRef))
            ListItem.SetDisabled(true);
    }
}

function bool UnitAvailableForLiaisonDuty(StateObjectReference UnitRef)
{
    local XComGameState_Unit Unit;
    local bool HasEligibleRegularRank;

    Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	if (Unit.IsSoldier())
    {
        HasEligibleRegularRank = Unit.GetRank() >= class'XComGameState_LWOutpost'.default.REQUIRED_RANK_FOR_LIAISON_DUTY;

        // The usual - injured/training soldiers cannot be selected
        if (!Unit.IsInjured()
		    && !Unit.IsTraining()
		    && !Unit.IsPsiTraining()
		    && !Unit.IsPsiAbilityTraining()
		    && !Unit.CanRankUpSoldier()
			&& !Unit.IsRobotic()
			&& Unit.GetMentalState() != eMentalState_Shaken
            // Need minimum rank to qualify for liaison duty
		    && HasEligibleRegularRank
            //On mission handles existing liaisons and people currently infiltrating.
		    && !class'LWDLCHelpers'.static.IsUnitOnMission(Unit))
	    {
		    return true;
	    }
    }
    else if (Unit.IsEngineer() || Unit.IsScientist())
    {
        return (!Unit.IsUnitCritical()
            && !Unit.IsInjured())
        ;
    }

    return false;
}
