//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_InitMissionTimer
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: Initialize the mission timer for a mission. This sets the turn value in the 
//           XComGameState_UITimer to the appropriate default value for the current mission
//           type, creating the state if necessary. Note: In LWS Overhaul mod the XComGameState_UITimer
//           is the official owner of the mission timer, not kismet (but retains the "Ui"
//           name to minimize diffs against the originals). LW mission kismet must fetch
//           the current timer value from the state rather than keeping a private timer
//           value in a kismet variable.
//--------------------------------------------------------------------------------------- 

// LWOTC: This is used by `UMS_LWMissionTimer` to modify the starting
// number of turns remaining in Kismet. The base number of turns that
// the UMS_SetupMissionTimer sequence configures is provided in the
// `BaseTurns` variable.
class SeqAct_InitializeMissionTimer extends SequenceAction config(LW_Overhaul);

struct TimerMap
{
	var string MissionType;
	var string MissionFamily;
	var int Turns;
};

// The config mapping of mission families to initial turn counts
var config array<TimerMap> InitialTurnCounts;
var config array<int> TimerDifficultyMod;
var config int VERY_LARGE_MAP_BONUS;
var config int LARGE_MAP_BONUS;

// The base number of turns set from config. Feel free to ignore
// this number and just set `Turns`.
var private int BaseTurns;

// The number of turns to return to Kismet (optional)
var private int Turns;

static function int GetInitialTimer(string MissionType, string MissionFamily)
{
	local XComGameState_KismetVariableModifier ModifierState;
	local XComGameState_MissionSite MissionState;
	local int TurnValue;
	local name GameplayTag;

	TurnValue = GetBaseTimer(MissionType, MissionFamily);

	// Apply any sit rep timer-modifier effects
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_KismetVariableModifier', ModifierState)
	{
		if (ModifierState.VarName == class'X2SitRep_DefaultSitRepEffects_LW'.default.MissionTimerModifierVarName)
		{
			TurnValue += ModifierState.Delta;
			break;
		}
	}

	// Hack to increase timer for Warlock on Full Retals.
	if(MissionFamily == "Defend_LW")
	{
		MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));

		foreach MissionState.TacticalGameplayTags (GameplayTag)
		{
			if(GamePlayTag =='Chosen_WarlockActive_LWOTC_ChosenTag' ||
				GamePlayTag =='Chosen_WarlockActiveM2_LWOTC_ChosenTag' ||
				GamePlayTag =='Chosen_WarlockActiveM3_LWOTC_ChosenTag' ||
				GamePlayTag =='Chosen_WarlockActiveM4_LWOTC_ChosenTag'
				)

				TurnValue += 1;
		}
	}

	return TurnValue;
}

static function int GetBaseTimer(string MissionType, string MissionFamily)
{
	local int i, TurnValue;

	i = default.InitialTurnCounts.Find('MissionType', MissionType);
	if (i == INDEX_NONE)
	{
		i = default.InitialTurnCounts.Find('MissionFamily', MissionFamily);
	}

	if (i >= 0)
	{
		// Add 1 to the initial mission count in the INI because this is typically invoked from the mission start sequence, and
		// the first thing the begin turn sequence does is decrement the mission count.

		// LWOTC: UMS_LWMissionTimer does not decrement the timer on turn one, so we shouldn't
		// add a turn to the timer here (as was done in original LW2).
		TurnValue = default.InitialTurnCounts[i].Turns;
	}
	else
	{
		return -1;
	}

	TurnValue += default.TimerDifficultyMod[`TACTICALDIFFICULTYSETTING];

	return TurnValue;
}

event Activated()
{
    local XComGameState_BattleData BattleData;
    local XComGameState_UITimer UiTimer;
    local XComGameState NewGameState;

    BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	Turns = GetInitialTimer(BattleData.MapData.ActiveMission.sType, BattleData.MapData.ActiveMission.MissionFamily);

	if (Turns == -1)
	{
		Turns = 10;
	}

    UiTimer = XComGameState_UITimer(`XCOMHISTORY.GetSingleGameStateObjectForClass(class 'XComGameState_UITimer', true));
	NewGameState = class 'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Initialize Timer");
	if (UiTimer == none)
		UiTimer = XComGameState_UITimer(NewGameState.CreateStateObject(class 'XComGameState_UITimer'));
	else
		UiTimer = XComGameState_UITimer(NewGameState.CreateStateObject(class 'XComGameState_UITimer', UiTimer.ObjectID));

	UiTimer.TimerValue = Turns;
	
	NewGameState.AddStateObject(UiTimer);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

defaultproperties
{
    ObjCategory="LWOverhaul"
    ObjName="Initialize Mission Timer"
    bConvertedForReplaySystem=true
    bAutoActivateOutputLinks=true

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Base Turns",PropertyName=BaseTurns)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Turns",PropertyName=Turns, bWriteable=true)
}
