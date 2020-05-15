//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_FacilityLeadItem.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Conditionals on the having a facility lead item or the related research
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_FacilityLeadItem extends X2LWActivityCondition;



simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGamestate_HeadquartersXCom XComHQ;
	local XComGameState_Tech TechState;
	local X2TechTemplate TechTemplate;
	local int TotalFacilities, FacilitiesAlreadyAccessible, k;
	local XComGameState_Item ItemState;
	local XComGameState_LWAlienActivity ActivityState;

	History = `XCOMHISTORY;
	XComHQ = `XCOMHQ;

	TotalFacilities = 0;
	FacilitiesAlreadyAccessible = 0;

	foreach History.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		TechTemplate = TechState.GetMyTemplate();
		if (TechTemplate != none && TechTemplate.DataName == 'Tech_AlienFacilityLead')
			break;
	}
	if (TechState == none)
	{
		`REDSCREEN("X2LWActivityCondition_FacilityLeadItem: Could not find Tech_AlienFacilityLead");
		return false;
	}

	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		// How many facilities are running this activity
		if (ActivityState.GetMyTemplateName() == class'X2StrategyElement_DefaultAlienActivities'.default.RegionalAvatarResearchName)
		{
			TotalFacilities += 1;
			// How many have we already revealed
			if (ActivityState.bDiscovered)
			{
				FacilitiesAlreadyAccessible += 1;
			}
		}	

		// How many of this activity are already running and Leads already available?
		if (ActivityState.GetMyTemplateName() == class'X2StrategyElement_DefaultAlienActivities'.default.ProtectResearchName)
		{
			FacilitiesAlreadyAccessible += 1;
		}
	}
	// How many leads to we already have
	for (k = 0; k < XComHQ.Inventory.length; k++)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(XComHQ.Inventory[k].ObjectID));
        if(ItemState != none)
        {
            if(ItemState.GetMyTemplateName() == 'FacilityLeadItem')
			{
				FacilitiesAlreadyAccessible += ItemState.Quantity;
			}
		}
	}
		
	// -1 if we're already researching a lead (lead item already consumed)
	if (XComHQ.IsTechCurrentlyBeingResearched(TechState))
	{
		FacilitiesAlreadyAccessible += 1;
	}	
	// -1 if we're already researched a lead but paused it (lead item already consumed)
	if (XComHQ.GetPausedProject(TechState.GetReference()) != none)
	{
		FacilitiesAlreadyAccessible += 1;
	}

	`LWTRACE ("X2LWActivityCondition_FacilityLeadItem: Total Facilities" @ TotalFacilities @ "Facilities Already Accessible" @ FacilitiesAlreadyAccessible @ "Condition Pass:" @ FacilitiesAlreadyAccessible >= TotalFacilities);

	if (FacilitiesAlreadyAccessible >= TotalFacilities)
		return false;

	return true;
}
