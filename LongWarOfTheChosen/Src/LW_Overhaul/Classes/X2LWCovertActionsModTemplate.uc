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

var config array<ArtifactCost> RISK_CAPTURE_MITIGATION_COSTS;

static function UpdateCovertActions(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2CovertActionTemplate CATemplate;
	local int i;

	CATemplate = X2CovertActionTemplate(Template);
	if (CATemplate == none)
		return;
	
	switch (CATemplate.DataName)
	{
		case 'CovertAction_GatherSupplies':
		case 'CovertAction_GatherIntel':
		case 'CovertAction_ImproveComInt':
		case 'CovertAction_FormSoldierBond':
		case 'CovertAction_SharedAbilityPoints':
		case 'CovertAction_SuperiorWeaponUpgrade':
		case 'CovertAction_SuperiorPCS':
		case 'CovertAction_AlienLoot':
			ConfigureEasyCovertAction(CATemplate);
			break;
		case 'CovertAction_RecruitScientist':
		case 'CovertAction_RecruitEngineer':
		case 'CovertAction_CancelChosenActivity':
		case 'CovertAction_RecruitFactionSoldier':
		case 'CovertAction_DelayChosen':
		case 'CovertAction_ResistanceContact':
			ConfigureModerateCovertAction(CATemplate);
			break;
		case 'CovertAction_RecruitExtraFactionSoldier':
			ConfigureHardCovertAction(CATemplate);
			break;
		case 'CovertAction_RemoveDoom':
		case 'CovertAction_FacilityLead':
			`LWTrace("X2LWCovertActionsModTemplate - making " $ CATemplate.DataName $ " unique");
			CATemplate.bUnique = true;
			CATemplate.bMultiplesAllowed = false;
			ConfigureHardCovertAction(CATemplate);
			break;
		case 'CovertAction_IncreaseIncome':
		case 'CovertAction_BreakthroughTech':
		case 'CovertAction_ResistanceCard':
			`LWTrace("X2LWCovertActionsModTemplate - disabling covert action " $ CATemplate.DataName);
			CATemplate.RequiredFactionInfluence = EFactionInfluence(eFactionInfluence_MAX + 1);
			break;
		case 'CovertAction_FindFaction':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			ConfigureModerateCovertAction(CATemplate);
			CATemplate.Slots[0].iMinRank = default.FIND_SECOND_FACTION_REQ_RANK;
			break;
		case 'CovertAction_FindFarthestFaction':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			ConfigureModerateCovertAction(CATemplate);
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

	// Remove all soldier slot rewards. Note that we can't use
	// `foreach` to iterate over the slots because they're structs, which
	// means we'd just be modifying a copy of the slot, not the original
	// one. Yay UnrealScript.
	for (i = 0; i < CATemplate.Slots.Length; i++)
	{
		CATemplate.Slots[i].Rewards.Length = 0;
	}

	// Disable Ambush risk, since the Ambush mission is bad.
	// TODO: Remove this code if and when the Ambush mission is updated to
	// be more interesting/challenging.
	CATemplate.Risks.RemoveItem('CovertActionRisk_Ambush');
}

// Adds a chance of failure to easy covert actions and resets the staff slots.
static function ConfigureEasyCovertAction(X2CovertActionTemplate Template)
{
	local ArtifactCost RiskRemovalCost;

	// Make failure the first risk in the list.
	Template.Risks.InsertItem(0, 'CovertActionRisk_Failure_Easy');

	// Reset the slots so there are just two standard soldier slots, with no costs.
	Template.Slots.Length = 0;
	Template.OptionalCosts.Length = 0;
	Template.Slots.AddItem(CreateDefaultStaffSlot());
	Template.Slots.AddItem(CreateDefaultStaffSlot());

	// Add an optional cost slot to counter capture if it's a risk.
	if (Template.Risks.Find('CovertActionRisk_SoldierCaptured') != INDEX_NONE)
	{
		`LWTrace("Adding optional cost to mitigate soldier capture for covert action " $ Template.DataName);
		RiskRemovalCost = default.RISK_CAPTURE_MITIGATION_COSTS[0];
		Template.OptionalCosts.AddItem(CreateOptionalCostSlot(RiskRemovalCost.ItemTemplateName, RiskRemovalCost.Quantity));
	}
}

// Adds a chance of failure to easy covert actions and resets the staff slots.
static function ConfigureModerateCovertAction(X2CovertActionTemplate Template)
{
	local ArtifactCost RiskRemovalCost;

	// Make failure the first risk in the list.
	Template.Risks.InsertItem(0, 'CovertActionRisk_Failure_Moderate');

	// Reset the slots so there are just two standard soldier slots, with no costs.
	Template.Slots.Length = 0;
	Template.OptionalCosts.Length = 0;
	Template.Slots.AddItem(CreateDefaultStaffSlot());
	Template.Slots.AddItem(CreateDefaultStaffSlot());
	Template.Slots.AddItem(CreateDefaultStaffSlot());

	// Add an optional cost slot to counter capture if it's a risk.
	if (Template.Risks.Find('CovertActionRisk_SoldierCaptured') != INDEX_NONE)
	{
		`LWTrace("Adding optional cost to mitigate soldier capture for covert action " $ Template.DataName);
		RiskRemovalCost = default.RISK_CAPTURE_MITIGATION_COSTS[1];
		Template.OptionalCosts.AddItem(CreateOptionalCostSlot(RiskRemovalCost.ItemTemplateName, RiskRemovalCost.Quantity));
	}
}

// Adds a chance of failure to easy covert actions and resets the staff slots.
static function ConfigureHardCovertAction(X2CovertActionTemplate Template)
{
	local ArtifactCost RiskRemovalCost;

	// Make failure the first risk in the list.
	Template.Risks.InsertItem(0, 'CovertActionRisk_Failure_Hard');

	// Reset the slots so there are just two standard soldier slots, with no costs.
	Template.Slots.Length = 0;
	Template.OptionalCosts.Length = 0;
	Template.Slots.AddItem(CreateDefaultStaffSlot());
	Template.Slots.AddItem(CreateDefaultStaffSlot());
	Template.Slots.AddItem(CreateDefaultStaffSlot());
	Template.Slots.AddItem(CreateDefaultStaffSlot());

	// TODO: Can't currently add an optional cost slot as all 4 slots are
	// reserved for soldiers. If the covert actions UI is modified to support
	// more than 4 slots, we can add optional cost slots.
}

// LWOTC: The follow slot-creation functions were copied from X2StrategyElement_DefaultCovertActions
// (since they're private to that class)
static function CovertActionSlot CreateDefaultStaffSlot(optional name SlotName = 'CovertActionSoldierStaffSlot', optional int iMinRank)
{
	local CovertActionSlot SoldierSlot;

	SoldierSlot.StaffSlot = SlotName;
	SoldierSlot.iMinRank = iMinRank;

	return SoldierSlot;
}

static function StrategyCostReward CreateOptionalCostSlot(name ResourceName, int Quantity)
{
	local StrategyCostReward ActionCost;
	local ArtifactCost Resources;

	Resources.ItemTemplateName = ResourceName;
	Resources.Quantity = Quantity;
	ActionCost.Cost.ResourceCosts.AddItem(Resources);
	ActionCost.Reward = 'Reward_DecreaseRisk';
	
	return ActionCost;
}

defaultproperties
{
	StrategyElementTemplateModFn=UpdateCovertActions
}
