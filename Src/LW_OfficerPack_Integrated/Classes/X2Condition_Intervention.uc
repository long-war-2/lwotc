//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_Intervention.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Adds condition that mission timer must be active, and also excludes certain configurable mission types
//---------------------------------------------------------------------------------------
class X2Condition_Intervention extends X2Condition config(LW_OfficerPack);

var config array<string> INTERVENTION_INVALID_MISSIONS;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameStateHistory History;
	local XComGameState_UITimer UiTimer;
	local XComGameState_BattleData BattleData;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (BattleData == none)
		return 'AA_UnknownError';

	if (default.INTERVENTION_INVALID_MISSIONS.Find(string(BattleData.MapData.ActiveMission.MissionName)) != -1)
		return 'AA_AbilityUnavailable';

	UiTimer = XComGameState_UITimer(History.GetSingleGameStateObjectForClass(class 'XComGameState_UITimer', true));
	if (UiTimer == none)
		return 'AA_AbilityUnavailable';
	
	if(!UiTimer.ShouldShow || UiTimer.TimerValue <= 0)
		return 'AA_AbilityUnavailable';
		
	return 'AA_Success';
}