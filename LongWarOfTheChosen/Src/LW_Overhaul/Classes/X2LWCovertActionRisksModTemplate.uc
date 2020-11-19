//---------------------------------------------------------------------------------------
//  FILE:    X2LWCovertActionRisksModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing covert action risk templates, such as to launch our
//           own Ambush mission.
//---------------------------------------------------------------------------------------
class X2LWCovertActionRisksModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

// How long the ambush mission stays on the Geoscape before expiring (in hours)
var config int AMBUSH_MISSION_DURATION;

static function UpdateCovertActionRisks(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2CovertActionRiskTemplate RiskTemplate;

	RiskTemplate = X2CovertActionRiskTemplate(Template);
	if (RiskTemplate == none)
		return;
	
	switch (RiskTemplate.DataName)
	{
		case 'CovertActionRisk_Ambush':
			RiskTemplate.ApplyRiskFn = CreateAmbushMission;
			break;
		default:
			break;
	}
}

// Modified version of X2StrategyElement_DefaultCovertActionRisks.CreateAmbushMission()
// that uses our own mission state class for the mission.
static function CreateAmbushMission(XComGameState NewGameState, XComGameState_CovertAction ActionState, optional StateObjectReference TargetRef)
{
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_MissionSiteChosenAmbush_LW MissionState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_Reward RewardState;
	local X2StrategyElementTemplateManager StratMgr;
	local X2RewardTemplate RewardTemplate;
	local X2MissionSourceTemplate MissionSource;
	local array<XComGameState_Reward> MissionRewards;

	ResHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	if (ResHQ.CanCovertActionsBeAmbushed()) // If a Covert Action was supposed to be ambushed, but now the Order is active, don't spawn the mission
	{
		StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
		ActionState.bAmbushed = true; // Flag the Action as being ambushed so it cleans up properly and doesn't give rewards
		ActionState.bNeedsAmbushPopup = true; // Set up for the Ambush popup
		RegionState = ActionState.GetWorldRegion();

		MissionRewards.Length = 0;
		RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_None'));
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		MissionRewards.AddItem(RewardState);

		MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate('MissionSource_ChosenAmbush'));

		MissionState = XComGameState_MissionSiteChosenAmbush_LW(NewGameState.CreateNewStateObject(class'XComGameState_MissionSiteChosenAmbush_LW'));
		MissionState.BuildMission(
			MissionSource,
			RegionState.GetRandom2DLocationInRegion(),
			RegionState.GetReference(),
			MissionRewards, true, true,
			default.AMBUSH_MISSION_DURATION);
		MissionState.CovertActionRef = ActionState.GetReference();
		MissionState.ResistanceFaction = ActionState.Faction;

		// Set the alert level for the mission based on the covert action difficulty
		MissionState.ManualDifficultySetting = class'Helpers_LW'.static.GetCovertActionDifficulty(ActionState);
	}
}

defaultproperties
{
	StrategyElementTemplateModFn=UpdateCovertActionRisks
}
