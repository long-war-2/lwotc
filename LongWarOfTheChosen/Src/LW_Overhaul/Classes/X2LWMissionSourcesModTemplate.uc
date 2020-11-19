//---------------------------------------------------------------------------------------
//  FILE:    X2LWMissionSourcesModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing mission source templates.
//---------------------------------------------------------------------------------------
class X2LWMissionSourcesModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

static function UpdateMissionSources(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2MissionSourceTemplate SourceTemplate;

	SourceTemplate = X2MissionSourceTemplate(Template);
	if (SourceTemplate == none)
		return;

	switch (SourceTemplate.DataName)
	{
		case 'MissionSource_ChosenAmbush':
			SourceTemplate.OnFailureFn = ChosenAmbushOnFailure;
			SourceTemplate.OnExpireFn = ChosenAmbushOnExpire;
			break;
		default:
			break;
	}
}

// Captures the covert operatives on the mission before going through the
// normal failure path for the ambush mission.
static function ChosenAmbushOnExpire(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_CovertAction ActionState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit UnitState;
	local int i;

	// Find the covert operatives and capture them
	ActionState = XComGameState_CovertAction(`XCOMHISTORY.GetGameStateForObjectID(
			XComGameState_MissionSiteChosenAmbush_LW(MissionState).CovertActionRef.ObjectID));

	// Go through all the soldier slots, marking the corresponding soldier
	// as captured
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	for (i = 0; i < ActionState.StaffSlots.Length; i++)
	{
		SlotState = ActionState.GetStaffSlot(i);
		if (SlotState.IsSlotFilled())
		{
			UnitState = SlotState.GetAssignedStaff();
			MarkUnitAsCaptured(NewGameState, XComHQ, ActionState, UnitState);
		}
	}

	// Continue with the normal failure path
	ChosenAmbushOnFailure(NewGameState, MissionState);

	`XEVENTMGR.TriggerEvent('CovertActionSoldierCaptured_Central', , , NewGameState);
}

// Adds some behaviour to ambush mission failure that marks the covert action
// rewards as not to be given.
static function ChosenAmbushOnFailure(XComGameState NewGameState, XComGameState_MissionSite MissionState)
{
	local XComGameState_CovertAction ActionState;

	// Go through default failure implementation for the ambush mission first
	class'X2StrategyElement_XpackMissionSources'.static.ChosenAmbushOnFailure(NewGameState, MissionState);

	// Now mark the source covert action as not getting rewards (we use this in a
	// listener to prevent the CA rewards from being given to the player).
	ActionState = XComGameState_CovertAction(NewGameState.ModifyStateObject(
			class'XComGameState_CovertAction',
			XComGameState_MissionSiteChosenAmbush_LW(MissionState).CovertActionRef.ObjectID));
	ActionState.RewardsNotGivenOnCompletion = true;
}

// Marks a unit on a covert action as having been captured by setting its
// `bCaptured` flag, removing it from the crew, and adding a covert action
// risk that will cause the unit to appear as captured in the covert action
// report.
static function MarkUnitAsCaptured(
	XComGameState NewGameState,
	XComGameState_HeadquartersXCom XComHQ,
	XComGameState_CovertAction ActionState,
	XComGameState_Unit UnitState)
{
	local CovertActionRisk ActionRisk;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
	UnitState.bCaptured = true;

	// Remove captured unit from XComHQ crew
	XComHQ.RemoveFromCrew(UnitState.GetReference());

	// Add a fake "Captured" risk so that the soldier is displayed as such
	// in the after-action report
	ActionRisk.RiskTemplateName = 'CovertActionRisk_SoldierCaptured';
	ActionRisk.Target.ObjectID = UnitState.ObjectID;
	ActionRisk.bOccurs = true;
	ActionState.Risks.AddItem(ActionRisk);
}

defaultproperties
{
	StrategyElementTemplateModFn=UpdateMissionSources
}
