//---------------------------------------------------------------------------------------
//  FILE:    X2LWCovertActionsModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//	PURPOSE: Modifies existing covert actions templates, effectively disabling some
//           of them and changing rewards of others, etc.
//
//           This also delays the contact of new factions by increasing the rank
//           requirements for the corresponding covert actions.
//---------------------------------------------------------------------------------------
class X2LWCovertActionsModTemplate extends X2LWTemplateModTemplate;

static function UpdateCovertActions(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2CovertActionTemplate CATemplate;
	local CovertActionSlot CurrentSlot;

	CATemplate = X2CovertActionTemplate(Template);
	if (CATemplate == none)
		return;
	
	switch (CATemplate.DataName)
	{
		case 'CovertAction_RemoveDoom':
		case 'CovertAction_FacilityLead':
			`LWTrace("X2LWCovertActionsModTemplate - making " $ CATemplate.DataName $ " unique");
			CATemplate.bUnique = true;
			CATemplate.bMultiplesAllowed = false;
			break;
		case 'CovertAction_IncreaseIncome':
		case 'CovertAction_BreakthroughTech':
			`LWTrace("X2LWCovertActionsModTemplate - disabling covert action " $ CATemplate.DataName);
			CATemplate.RequiredFactionInfluence = EFactionInfluence(eFactionInfluence_MAX + 1);
			break;
		case 'CovertAction_FindFaction':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			CATemplate.Slots[0].iMinRank = 4;  // Require a SGT
			break;
		case 'CovertAction_FindFarthestFaction':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			CATemplate.Slots[0].iMinRank = 6;  // Require a TSGT
			break;
		default:
			break;
	}

	// Remove promotions as soldier slot rewards
	foreach CATemplate.Slots(CurrentSlot)
	{
		CurrentSlot.Rewards.RemoveItem('Reward_RankUp');
	}
}

defaultproperties
{
	StrategyElementTemplateModFn=UpdateCovertActions
}