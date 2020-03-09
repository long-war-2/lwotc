//---------------------------------------------------------------------------------------
//  FILE:    X2LWCovertActionsModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//	PURPOSE: Modifies existing covert actions templates, effectively disabling some
//           of them and changing rewards of others, etc.
//
//           This also delays the contact of new factions by increasing the rank
//           requirements for the corresponding covert actions.
//---------------------------------------------------------------------------------------
class X2LWCovertActionsModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

var config int FIND_SECOND_FACTION_REQ_RANK;
var config int FIND_THIRD_FACTION_REQ_RANK;
var config int FIRST_CHOSEN_CA_REQ_RANK;
var config int SECOND_CHOSEN_CA_REQ_RANK;
var config int THIRD_CHOSEN_CA_REQ_RANK;

static function UpdateCovertActions(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2CovertActionTemplate CATemplate;
	local int i;

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
		case 'CovertAction_ResistanceCard':
			`LWTrace("X2LWCovertActionsModTemplate - disabling covert action " $ CATemplate.DataName);
			CATemplate.RequiredFactionInfluence = EFactionInfluence(eFactionInfluence_MAX + 1);
			break;
		case 'CovertAction_FindFaction':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			CATemplate.Slots[0].iMinRank = default.FIND_SECOND_FACTION_REQ_RANK;
			break;
		case 'CovertAction_FindFarthestFaction':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			CATemplate.Slots[0].iMinRank = default.FIND_THIRD_FACTION_REQ_RANK;
			break;
		case 'CovertAction_RevealChosenMovements':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			CATemplate.Slots[0].iMinRank = default.FIRST_CHOSEN_CA_REQ_RANK;
			break;
		case 'CovertAction_RevealChosenStrengths':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			CATemplate.Slots[0].iMinRank = default.SECOND_CHOSEN_CA_REQ_RANK;  // Require a TSGT
			break;
		case 'CovertAction_RevealChosenStronghold':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			CATemplate.Slots[0].iMinRank = default.THIRD_CHOSEN_CA_REQ_RANK;  // Require a MSGT
			break;
		default:
			break;
	}

	// Remove promotions as soldier slot rewards. Note that we can't use
	// `foreach` to iterate over the slots because they're structs, which
	// means we'd just be modifying a copy of the slot, not the original
	// one. Yay UnrealScript.
	for (i = 0; i < CATemplate.Slots.Length; i++)
	{
		CATemplate.Slots[i].Rewards.RemoveItem('Reward_RankUp');
	}
}

defaultproperties
{
	StrategyElementTemplateModFn=UpdateCovertActions
}