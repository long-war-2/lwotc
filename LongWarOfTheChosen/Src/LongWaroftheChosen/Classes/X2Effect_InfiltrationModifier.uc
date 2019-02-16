//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_InfiltrationModifier.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Implements the infiltration modifier, which modifies enemy stats based on mission infiltration status 
//---------------------------------------------------------------------------------------
class X2Effect_InfiltrationModifier extends X2Effect_ModifyStats config (LW_InfiltrationSettings);

//`include(LongWaroftheChosen\Src\LW_Overhaul.uci)

var config array<float> MAX_INFILTRATION_DETECTION_MULT;
var config array<float> MIN_INFILTRATION_DETECTION_MULT;

//set stat modification based on the current mission's infiltration status
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;	
	local XComGameState_MissionSite MissionSiteState;
	/* WOTC TODO: Restore this
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_LWPersistentSquad SquadState;
	*/
	//local XComGameState_Unit TargetState;
	local array<StatChange>	arrStatChanges;
	local StatChange NewChange;
	local float DetectionModifier, CurrentInfiltration;

	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionSiteState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));

	/* WOTC TODO: Restore this
	SquadMgr = `LWSQUADMGR;

	//TargetState = XComGameState_Unit (kNewTargetState);
	
	if (SquadMgr.IsValidInfiltrationMission(MissionSiteState.GetReference()))
	{
		SquadState = SquadMgr.GetSquadOnMission(MissionSiteState.GetReference());
		CurrentInfiltration = SquadState.CurrentInfiltration;
		arrStatChanges.Length = 0;
		if (CurrentInfiltration >= 1.0)
		{
			DetectionModifier = 1.0 - (1.0 - default.MIN_INFILTRATION_DETECTION_MULT[`STRATEGYDIFFICULTYSETTING]) * (CurrentInfiltration - 1.0);
		}
		else
		{
			DetectionModifier = 1.0 + (default.MAX_INFILTRATION_DETECTION_MULT[`STRATEGYDIFFICULTYSETTING] - 1.0) * (1.0 - CurrentInfiltration);
		}

		DetectionModifier = FClamp(DetectionModifier, 0.667, 3.0);
		NewChange.StatType = eStat_DetectionRadius;
		NewChange.StatAmount = DetectionModifier;
		NewChange.ModOp = MODOP_Multiplication;

		arrStatChanges.AddItem(NewChange);

		NewEffectState.StatChanges = arrStatChanges;
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	}
	*/

}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="InfiltrationModifier";
	bRemoveWhenSourceDies=true;
}

