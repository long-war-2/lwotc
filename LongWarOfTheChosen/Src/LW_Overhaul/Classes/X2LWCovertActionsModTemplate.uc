//---------------------------------------------------------------------------------------
//  FILE:    X2LWCovertActionsModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing covert actions templates, effectively disabling some
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
		case 'CovertAction_SuperiorWeaponUpgrade':
		case 'CovertAction_SuperiorPCS':
			CaTemplate.RequiredFactionInfluence = eFactionInfluence_Minimal;
			CaTemplate.bUnique = false;
		case 'CovertAction_GatherSupplies':
		case 'CovertAction_GatherIntel':
		case 'CovertAction_FormSoldierBond':
		case 'CovertAction_AlienLoot':
		case 'CovertAction_ResistanceMec':
			ConfigureEasyCovertAction(CATemplate);
			break;
		case 'CovertAction_RecruitScientist':
		case 'CovertAction_RecruitEngineer':
			CaTemplate.RequiredFactionInfluence = eFactionInfluence_Respected;
		case 'CovertAction_EnemyCorpses':
		case 'CovertAction_CancelChosenActivity':
		case 'CovertAction_DelayChosen':
		case 'CovertAction_ResistanceContact':
		case 'CovertAction_RecruitRebels':
		case 'CovertAction_SharedAbilityPoints':
			ConfigureModerateCovertAction(CATemplate);
			break;
		case 'CovertAction_ImproveComInt':
			RemoveStaffSlots(CATemplate, 'CovertActionScientistStaffSlot');
			CATemplate.RequiredFactionInfluence = EFactionInfluence(eFactionInfluence_MAX + 1);
			break;
		case 'CovertAction_RecruitExtraFactionSoldier':
			CATemplate.bDisplayIgnoresInfluence = false;  // Don't roll this CA if the player can't run it!
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
			CATemplate.Slots[0].iMinRank = default.FIND_SECOND_FACTION_REQ_RANK;
			break;
		case 'CovertAction_FindFarthestFaction':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			CATemplate.Slots[0].iMinRank = default.FIND_THIRD_FACTION_REQ_RANK;
			break;
		case 'CovertAction_RevealChosenMovements':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			ConfigureEasyCovertAction(CATemplate, false);
			CATemplate.Slots[0].iMinRank = default.FIRST_CHOSEN_CA_REQ_RANK;
			break;
		case 'CovertAction_RevealChosenStrengths':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			ConfigureModerateCovertAction(CATemplate, false);
			CATemplate.Slots[0].iMinRank = default.SECOND_CHOSEN_CA_REQ_RANK;  // Require a TSGT
			break;
		case 'CovertAction_RevealChosenStronghold':
			`LWTrace("X2LWCovertActionsModTemplate - increasing rank requirement for " $ CATemplate.DataName);
			ConfigureHardCovertAction(CATemplate, false);
			CATemplate.Slots[0].iMinRank = default.THIRD_CHOSEN_CA_REQ_RANK;  // Require a MSGT
			break;
		default:
			break;
	}

	// Remove all soldier slot rewards except for the Intense Training
	// covert action. That's the only one that should be allowed to boost
	// soldiers' stats.
	//
	// Note that we can't use `foreach` to iterate over the slots because
	// they're structs, which means we'd just be modifying a copy of the
	// slot, not the original one. Yay UnrealScript.
	if (CATemplate.DataName != 'CovertAction_IntenseTraining')
	{
		for (i = 0; i < CATemplate.Slots.Length; i++)
		{
			CATemplate.Slots[i].Rewards.Length = 0;
		}
	}

	// Disable Wounded risk, since the Ambush mission is more interesting
	// and less frustrating to the player than a random wound.
	CATemplate.Risks.RemoveItem('CovertActionRisk_SoldierWounded');
}

// Adds a chance of failure to easy covert actions and resets the staff slots.
static function ConfigureEasyCovertAction(X2CovertActionTemplate Template, optional bool ApplyFailureRisk = true)
{
	// Make failure the first risk in the list.
	if (ApplyFailureRisk)
	{
		Template.Risks.InsertItem(0, 'CovertActionRisk_Failure_Easy');

		// If a covert action can't fail, then it shouldn't be possible
		// to ambush it, because ambush also provides a chance to fail
		AddAmbushRisk(Template);
	}
	AddStaffSlots(Template, 2);

	// Add an optional cost slot to counter capture if it's a risk.
	AddCaptureMitigationSlot(Template);
}

// Adds a chance of failure to easy covert actions and resets the staff slots.
static function ConfigureModerateCovertAction(X2CovertActionTemplate Template, optional bool ApplyFailureRisk = true)
{

	// Make failure the first risk in the list.
	if (ApplyFailureRisk)
	{
		Template.Risks.InsertItem(0, 'CovertActionRisk_Failure_Moderate');

		// If a covert action can't fail, then it shouldn't be possible
		// to ambush it, because ambush also provides a chance to fail
		AddAmbushRisk(Template);
	}
	AddStaffSlots(Template, 3);

	// Add an optional cost slot to counter capture if it's a risk.
	AddCaptureMitigationSlot(Template);
}

// Adds a chance of failure to easy covert actions and resets the staff slots.
static function ConfigureHardCovertAction(X2CovertActionTemplate Template, optional bool ApplyFailureRisk = true)
{
	// Make failure the first risk in the list.
	if (ApplyFailureRisk)
	{
		Template.Risks.InsertItem(0, 'CovertActionRisk_Failure_Hard');

		// If a covert action can't fail, then it shouldn't be possible
		// to ambush it, because ambush also provides a chance to fail
		AddAmbushRisk(Template);
	}
	AddStaffSlots(Template, 3);

	// Add an optional cost slot to counter capture if it's a risk.
	AddCaptureMitigationSlot(Template);
}

static function AddStaffSlots(X2CovertActionTemplate Template, int SlotCount)
{
	local int i;

	// Reset the slots so there are just two standard soldier slots, with no costs.
	Template.Slots.Length = 0;
	Template.OptionalCosts.Length = 0;

	for (i = 0; i < SlotCount; i++)
	{
		Template.Slots.AddItem(CreateDefaultStaffSlot());
	}
}

static function RemoveStaffSlots(X2CovertActionTemplate Template, name SlotName)
{
	local int i;

	for (i = Template.Slots.Length - 1; i >= 0; i--)
	{
		if (Template.Slots[i].StaffSlot == SlotName)
		{
			Template.Slots.Remove(i, 1);
		}
	}
}

static function AddCaptureMitigationSlot(X2CovertActionTemplate Template)
{
	local ArtifactCost RiskRemovalCost;

	// Clear any existing optional costs.
	Template.OptionalCosts.Length = 0;

	// Add an optional cost slot to counter capture if it's a risk.
	if (Template.Risks.Find('CovertActionRisk_SoldierCaptured') != INDEX_NONE)
	{
		`LWTrace("Adding optional cost to mitigate soldier capture for covert action " $ Template.DataName);
		RiskRemovalCost = default.RISK_CAPTURE_MITIGATION_COSTS[0];
		Template.OptionalCosts.AddItem(CreateOptionalCostSlot(RiskRemovalCost.ItemTemplateName, RiskRemovalCost.Quantity));
	}
}

// Adds an ambush risk to the given covert action if it doesn't already
// have one.
static function AddAmbushRisk(X2CovertActionTemplate Template)
{
	if (Template.Risks.Find('CovertActionRisk_Ambush') == INDEX_NONE)
	{
		Template.Risks.AddItem('CovertActionRisk_Ambush');
	}
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
