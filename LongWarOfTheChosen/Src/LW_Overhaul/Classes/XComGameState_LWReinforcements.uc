//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWReinforcements.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Game state for handling the LW reinforcement system. This class maintains
//           the state of the reinforcement system - how many times have we reinforced,
//           what are the chances of reinforcement occuring?
//---------------------------------------------------------------------------------------

class XComGameState_LWReinforcements extends XComGameState_BaseObject
    config(LW_Overhaul);

enum Reinforcements_Timer_Trigger
{
	eReinforcementsTrigger_MissionStart,
	eReinforcementsTrigger_Reveal,
	eReinforcementsTrigger_RedAlert,
	eReinforcementsTrigger_ExternalTrigger,
	eReinforcementsTrigger_MAX
};

struct Mission_Reinforcements_Modifiers_Struct_LW
{
	var name MissionType;
	var name ActivityName;
	var float BucketModifier;
	var float BucketMultiplier;
	var float AccelerateMultiplier;
	var int ReinforcementsCap;
	var int ForcedReinforcementsTurn;
	var Reinforcements_Timer_Trigger ReinforcementsTrigger;
	var bool CavalryOnly;
	var int QueueOffset;
	var int CavalryAbsoluteTurn;
	var int CavalryWinTurn;

	structdefaultproperties
	{
		MissionType=none
		ActivityName=none
		BucketModifier=0.0
		BucketMultiplier=1.0
		AccelerateMultiplier=0.0
		ReinforcementsCap=10
		QueueOffset=0
		ForcedReinforcementsTurn=-1
		ReinforcementsTrigger=eReinforcementsTrigger_RedAlert
		CavalryOnly=false
		CavalryAbsoluteTurn=28
		CavalryWinTurn=12
	}
};

struct InfiltrationQueueModifierStruct
{
	var float Infiltration;
	var int Modifier;
};

var config array <Mission_Reinforcements_Modifiers_Struct_LW> MISSION_REINFORCEMENT_MODIFIERS;

var config array<int>TURN_COUNT_FOR_CAVALRY_AFTER_VICTORY_MOD;
var config array<int>TURN_COUNT_TO_CAVALRY_ALL_CASES_MOD;
var config array<InfiltrationQueueModifierStruct>QUEUE_MODIFIER;

// Amount to add to the level per-turn when the 'RapidResponse' Dark Event is active, indexed
// by difficulty setting.
var config const array<float> RAPID_RESPONSE_MODIFIER;

// Amount to add to the level per-turn due to alert level
var config const array<float> ALERT_MODIFIER;

// Amount to modify by difficulty level
var config array<float> DIFFICULTY_MODIFIER;

// Randomization amount for alert factor. Alert value will be randomized +/- this amount as a percentage.
var config const float ALERT_RANDOM_FACTOR;

// How many times have we called reinforcements on this mission?
var private int Count;

// How many actual reinforcements have spawned (not counting skips)
var private int Spawns;

// The reinforcement "Bucket". Each time reinforcements are checked
// the bucket is filled by a certain amount, and when it fills up
// a reinforcement is spawned.
var privatewrite float Bucket;

// If true, the reinforcement system is initialized. If false, we haven't yet
// done any first-time initialization.
var privatewrite bool IsInitialized;

var int TurnsSinceStart;
var int TurnsSinceReveal;
var int TurnsSinceRedAlert;
var int TurnsSinceTriggered;
var int TurnsSinceWin;
var int CavalryTurn;
var int CavalryOnWinTurn;
var float TimerBucketModifier;
var bool RedAlertTriggered;
var bool ExternallyTriggered;
var bool Disabled;
var Mission_Reinforcements_Modifiers_Struct_LW ReinfRules;

function Reset()
{
    // Reset the reinforcement system: no count and an empty bucket
	Count = ReinfRules.QueueOffset;
    Bucket = 0.0f;
	Spawns = 0;
	TurnsSinceReveal = 0;
	TurnsSinceStart = 0;
	TurnsSinceRedAlert = 0;
	TurnsSinceTriggered = 0;
	IsInitialized = false;
	ExternallyTriggered = false;
	Disabled = false;
}

// Initialize the reinforcement system: Set the initial bucket level
function Initialize()
{
	local XComGameState_MissionSite MissionState;
	local XComGameState_LWAlienActivity CurrentActivity;
	local int k;
	local Mission_Reinforcements_Modifiers_Struct_LW EmptyReinfRules;
	local float BaseTimerLength, CurrentTimerLength;

    `LWTrace("LWRNF: Initializing RNF state");

    Bucket = 0;
	Spawns = 0;
	TurnsSinceReveal = 0;
	TurnsSinceStart = 0;
	TurnsSinceRedAlert = 0;
	TurnsSinceTriggered = 0;
	TurnsSinceWin = 0;
	RedAlertTriggered = false;
	ExternallyTriggered = false;
	ReinfRules = EmptyReinfRules;

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	CurrentActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);

	// Get the deets for this particular mission type
	for (k = 0; k < default.MISSION_REINFORCEMENT_MODIFIERS.length; k++)
	{
		if (string(default.MISSION_REINFORCEMENT_MODIFIERS[k].MissionType) == class'Utilities_LW'.static.CurrentMissionType())
		{
			ReinfRules = default.MISSION_REINFORCEMENT_MODIFIERS[k];
		}
		// Activity setting overrides mission setting
		if (CurrentActivity != none &&
			default.MISSION_REINFORCEMENT_MODIFIERS[k].ActivityName == CurrentActivity.GetMyTemplateName())
		{
			ReinfRules = default.MISSION_REINFORCEMENT_MODIFIERS[k];
			break;
		}
	}
	Count = Max (ReinfRules.QueueOffset + GetQueueOffSetModifier(), 0);

	// Work out how many more or fewer turns there are compared to the default
	// and use this to initialise the timer-based bucket modifier
	TimerBucketModifier = 1.0;
	CurrentTimerLength = GetCurrentTimer();
	if (CurrentTimerLength > 0)
	{
		// We have a timer, so we can calculate a bucket modifier for it
		BaseTimerLength = class'SeqAct_InitializeMissionTimer'.static.GetBaseTimer(
			MissionState.GeneratedMission.Mission.sType,
			MissionState.GeneratedMission.Mission.MissionFamily);
		TimerBucketModifier = BaseTimerLength / CurrentTimerLength;
	}

    IsInitialized = true;
}

function int GetCurrentTimer()
{
    local XComGameState_UITimer Timer;

    Timer = XComGameState_UITimer(`XCOMHISTORY.GetSingleGameStateObjectForClass(class 'XComGameState_UITimer', true));
    if (Timer == none)
    {
        return -1;
    }

    return Timer.TimerValue;
}

function int GetQueueOffsetModifier()
{
	local XComGameState_MissionSite			MissionState;
	local XComGameState_LWPersistentSquad	SquadState;
	local XComGameState_BattleData			BattleData;
	local int idx;
	local InfiltrationQueueModifierStruct	InfiltrationQueueModifier;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(BattleData.m_iMissionID));
    if (MissionState == none)
    {
       return 0;
    }
	SquadState = `LWSQUADMGR.GetSquadOnMission(MissionState.GetReference());
	if (`LWSQUADMGR.IsValidInfiltrationMission(MissionState.GetReference()))
	{
		foreach default.QUEUE_MODIFIER(InfiltrationQueueModifier, idx)
		{
			if (InfiltrationQueueModifier.Infiltration > SquadState.CurrentInfiltration)
			{
				return InfiltrationQueueModifier.Modifier;
			}
		}
	}
	return 0;
}


function bool AnyEnemiesInRedAlert()
{
	local XGPlayer AIPlayer;
    local XComGameState_Unit Enemy;
    local array<XComGameState_Unit> Enemies_array;

    AIPlayer = XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kBattle.GetAIPlayer();
    AIPlayer.GetAliveUnits(Enemies_array);
    foreach Enemies_array(Enemy)
    {
        if(Enemy.GetCurrentStat(10) > float(1))
		{
			return true;
		}
	}
	return false;
}

function bool AtTurnThreshhold (int Threshhold, optional bool Absolute = false)
{
	if (Absolute)
	{
		if (TurnsSincestart == Threshhold)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_MissionStart && TurnsSinceStart == Threshhold)
	{
		return true;
	}
	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_Reveal && TurnsSinceReveal == Threshhold)
	{
		return true;
	}
	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_RedAlert && TurnsSinceRedAlert == Threshhold)
	{
		return true;
	}
	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_ExternalTrigger && TurnsSinceTriggered == Threshhold)
	{
		return true;
	}
	return false;
}

function bool ReachedTurnThreshhold (int Threshhold, optional bool CheckWin = false, optional bool ExactTurn = false)
{
	if (CheckWin && TurnsSinceWin >= Threshhold && !ExactTurn)
	{
		return true;
	}
	if (CheckWin && TurnsSinceWin == Threshhold && ExactTurn)
	{
		return true;
	}
	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_MissionStart && TurnsSinceStart >= Threshhold)
	{
		return true;
	}
	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_Reveal && TurnsSinceReveal >= Threshhold)
	{
		return true;
	}
	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_RedAlert && TurnsSinceRedAlert >= Threshhold)
	{
		return true;
	}
	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_ExternalTrigger && TurnsSinceTriggered >= Threshhold)
	{
		return true;
	}
	return false;
}

function bool CanAddToBucket()
{
	local XComGameState_Player PlayerState;
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldREgion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	if (Disabled)
	{
		return false;
	}

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	Region = MissionState.GetWorldRegion();
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);
	if (RegionalAI.bLiberated)
	{
		if (class'Utilities_LW'.static.CurrentMissionType() != "Defend_LW" &&
		    class'Utilities_LW'.static.CurrentMissionType() != "SupplyConvoy_LW" &&
		    class'Utilities_LW'.static.CurrentMissionType() != "Invasion_LW")
		return false;
	}

	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_MissionStart)
	{
		return true;
	}

	PlayerState = class'Utilities_LW'.static.FindPlayer(eTeam_XCom);
	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_Reveal && !PlayerState.bSquadIsConcealed)
	{
		return true;
	}

	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_RedAlert && RedAlertTriggered)
	{
		return true;
	}

	if (ReinfRules.ReinforcementsTrigger == eReinforcementsTrigger_ExternalTrigger && ExternallyTriggered)
	{
		return true;
	}
	return false;
}


// Returns true if reinforcements are possible.
function bool ReinforcementsArePossible()
{
	// Not yet initialized, no reinforcements.
	if (!IsInitialized)
		return false;

	// At reinf cap?
	if (ReinfRules.ReinforcementsCap > 0 && Spawns >= ReinfRules.ReinforcementsCap)
		return false;

	// Otherwise if we're accumulating into the bucket they're possible
	return CanAddToBucket();
}


// Check for reinforcements. Returns -1 if we should not call reinforcements, or another value if reinforcements
// should be spawned, where the number returned is the number of reinforcements there have been so far.
function int CheckForReinforcements()
{
    local float TmpValue, BucketFiller;
	local XComGameState_BattleData BattleData;
	local XComGameState_Player PlayerState;
	local XGPlayer Player;
	local array<XComGameState_Unit> Units;

	`LWTrace ("LWRNF Check For Reinforcements");

    if (!IsInitialized)
        Initialize();

	// If we've hit the limit, no further reinfs
	if (ReinfRules.ReinforcementsCap > 0)
	{
		if (Spawns >= ReinfRules.ReinforcementsCap)
			return -1;
	}

	// If we've disabled the system, no more reinfs
	if (Disabled)
	{
		return -1;
	}

	// Prevent issues from too many aliens on the map
	Player = XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kBattle.GetAIPlayer();
	Player.GetAliveUnits(Units, false, true);
	if (Units.length > 60)
	{
		return -1;
	}

	TmpValue = 0;
	BucketFiller = 0;
	// Add hardcoded sources of reinforcement values: region stats, dark events, etc.
	PlayerState = class'Utilities_LW'.static.FindPlayer(eTeam_XCom);
	if (CanAddToBucket())
	{
	    TmpValue = GetIncreaseFromRegion();
		`LWTrace("LWRNF: Adding " $ TmpValue $ " to reinforcement bucket from region status");
		BucketFiller += TmpValue;

		TmpValue = GetIncreaseFromDarkEvents();
		`LWTrace("LWRNF: Adding " $ TmpValue $ " to reinforcement bucket from dark events");
		BucketFiller += TmpValue;

		TmpValue = GetIncreaseFromMods();
		`LWTrace("LWRNF: Adding " $ TmpValue $ " to reinforcement bucket from mods");
		BucketFiller += TmpValue;

		TmpValue = ReinfRules.BucketModifier;
		`LWTrace("LWRNF: Adding " $ TmpValue $ " to reinforcement bucket from mission/activity");
		BucketFiller += TmpValue;

		TmpValue = default.DIFFICULTY_MODIFIER[`TACTICALDIFFICULTYSETTING];
		`LWTrace("LWRNF: Adding " $ string(TmpValue) $ " to reinforcement bucket from difficulty");
		BucketFiller += TmpValue;

		TmpValue = ReinfRules.AccelerateMultiplier * BucketFiller * Spawns;
		`LWTrace("LWRNF: Applying acceleration value multiplier " $ TmpValue $ " to this turn's reinforcement bucket fill value");
		BucketFiller += TmpValue;

		TmpValue = ReinfRules.BucketMultiplier;
		`LWTrace("LWRNF: Applying multiplier " $ TmpValue $ " to this turn's reinforcement bucket fill value from mission/activity");
		BucketFiller *= TmpValue;

		TmpValue = TimerBucketModifier;
		`LWTrace("LWRNF: Applying timer-based multiplier " $ TmpValue $ " to this turn's reinforcement bucket fill value");
		BucketFiller *= TmpValue;

		Bucket += BucketFiller;

		if (AtTurnThreshhold(ReinfRules.ForcedReinforcementsTurn - 2) && Bucket == 0)
		{
			Bucket += 0.01; // This is to trigger a warning
		}
		else
		{
			if (AtTurnThreshhold(ReinfRules.ForcedReinforcementsTurn - 1) && Bucket < 0.5)
			{
				Bucket += 0.501; // so is this
			}
			else
			{
				if (AtTurnThreshhold(ReinfRules.ForcedReinforcementsTurn))
				{
					`LWTRACE ("Adding 1.0 to bucket to Force Reinforcements on Turn" @ PlayerState.PlayerTurnCount);
					Bucket += 1.0;
				}
			}
		}
		if (ReinfRules.CavalryOnly && !AtTurnThreshhold(ReinfRules.ForcedReinforcementsTurn))
		{
			`LWTRACE ("LWRNF: This is a Cavalry-only mission. Zeroing out bucket before adding cav numbers.");
			Bucket = 0;
		}

		CavalryTurn = ReinfRules.CavalryAbsoluteTurn + default.TURN_COUNT_TO_CAVALRY_ALL_CASES_MOD[`TACTICALDIFFICULTYSETTING];
		CavalryOnWinTurn = ReinfRules.CavalryWinTurn + default.TURN_COUNT_FOR_CAVALRY_AFTER_VICTORY_MOD[`TACTICALDIFFICULTYSETTING];

		// Punish Loitering - Killfarming
		BattleData = XComGameState_BattleData(class'XComGameStateHistory'.static.GetGameStateHistory().GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
		if (BattleData.AllStrategyObjectivesCompleted())
		{
			if (ReachedTurnThreshhold (ReinfRules.CavalryWinTurn-2, true) && Bucket <= 0.0)
			{
				Bucket += 0.01; // Trigger Warning
			}
			else
			{
				if (ReachedTurnThreshhold (ReinfRules.CavalryWinTurn-1, true) && Bucket <= 0.5)
				{
					Bucket += 0.501; // Trigger imminent
				}
				else
				{
					if (ReachedTurnThreshhold (ReinfRules.CavalryWinTurn, true))
					{
						`LWTRACE("LWRNF: Forcing Reinforcements to punish loitering after victory");
						Bucket += 1.0;
					}
				}
			}
		}
		else
		{
			if (AtTurnThreshhold (ReinfRules.CavalryAbsoluteTurn-2, true) && Bucket <= 0.0)
			{
				Bucket += 0.01;
			}
			else
			{
				if (AtTurnThreshhold (ReinfRules.CavalryAbsoluteTurn-1, true) && Bucket <= 0.5)
				{
					Bucket += 0.501;
				}
				else
				{
					if (ReachedTurnThreshhold (ReinfRules.CavalryAbsoluteTurn))
					{
						Bucket += 1.0;
					}
				}
			}
		}
	}

	// Clamp the bucket to a reasonable level
    Bucket = FClamp(Bucket, 0, 9.0);

    `LWTrace("LWRNF: Final bucket value is: " $ Bucket);
	`LWTrace("LWRNF: Turns Since Start:" @ TurnsSinceStart);
	`LWTrace("LWRNF: Turns Since Reveal:" @ TurnsSinceReveal);
	`LWTrace("LWRNF: Turns Since RedAlert:" @ TurnsSinceReveal);
	`LWTrace("LWRNF: Turns Since Win:" @ TurnsSinceWin);

	TurnsSinceStart += 1;
	// Increment turns since reveal counter

	if (!PlayerState.bSquadIsConcealed)
	{
		TurnsSinceReveal += 1;
	}
	if (AnyEnemiesInRedAlert())
	{
		RedAlertTriggered = true;
	}
	if (RedAlertTriggered)
	{
		TurnsSinceRedAlert += 1;
	}
	if (BattleData.AllStrategyObjectivesCompleted())
	{
		TurnsSinceWin += 1;
	}

    if (Bucket >= 1.0)
    {
        // Success! If over one, then skip ahead to harder reinf
        `LWTrace("LWRNF: Spawning reinforcement " $ Count);
		Count += int (Bucket);
		Spawns += 1;
		Bucket -= float(int(Bucket));
		`LWTrace("LWRNF: Bucket decreased to" @ string(Bucket));
		return Count;
    }
    else
    {
        return -1;
    }
}

function bool ForceReinforcementsByTurn(int Turn)
{
	if (Turn == ReinfRules.ForcedReinforcementsTurn)
	{
		return true;
	}
	return false;
}

function float GetIncreaseFromRegion()
{
    //local XComGameState_BattleData BattleData;
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
    local int AlertLevel;
    local float Modifier;
    local float AlertMod;

    //BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	Region = MissionState.GetWorldRegion();
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);

    AlertLevel = Min(RegionalAI.LocalAlertLevel, ALERT_MODIFIER.Length);
    AlertMod = ALERT_MODIFIER[AlertLevel];

    // Randomize the alert-based level.
    AlertMod = Lerp(AlertMod * (1.0 - ALERT_RANDOM_FACTOR), AlertMod * (1.0 + ALERT_RANDOM_FACTOR), `SYNC_FRAND());
    Modifier += AlertMod;

    return Modifier;
}

function float GetIncreaseFromDarkEvents()
{
    local float Modifier;

    // Check for the 'RapidResponse' Dark Event.
    if (`XCOMHQ.TacticalGameplayTags.Find('DarkEvent_RapidResponse') != -1)
    {
        Modifier = RAPID_RESPONSE_MODIFIER[`TACTICALDIFFICULTYSETTING];
    }

    return Modifier;
}

// Allow mods to modify the reinforcement level by listening for the
// 'GetReinforcementValue' event. EventData is a 1-tuple containing the current
// level as a float. Mods should write their desired modifier into a new float element
// at the end of the tuple. The returned modifier is the sum of all elements of the tuple
// except the first (which contains the input level).
function float GetIncreaseFromMods()
{
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local int i;
    local float Result;

    Tuple = new class'XComLWTuple';
    Tuple.Id = 'GetReinforcementValue';

    // Add the current reinforce chance
    Value.Kind = XComLWTVFloat;
    Value.f = Bucket;
    Tuple.Data.AddItem(Value);

    `XEVENTMGR.TriggerEvent('GetReinforcementValue', Tuple, self);

    for (i = 1; i < Tuple.Data.Length; ++i)
    {
        if (Tuple.Data[i].Kind == XComLWTVFloat)
        {
            Result += Tuple.Data[i].f;
        }
    }

    return Result;
}

// Force a reinforcement. Just return a new reinforcement index and empty the bucket.
function int ForceReinforcements()
{
    `LWTrace("LWRNF: Forcing reinforcement " $ Count);
    if (!IsInitialized)
        Initialize();

    Bucket = 0;
    return ++Count;
}

// Starts the reinforcement drops if the current mission uses the
// eReinforcementsTrigger_ExternalTrigger rule. Note that this must
// be called on a modifiable game state object.
function StartReinforcements()
{
	ExternallyTriggered = true;
}

// Turn off the reinforcement system. Once set reinforcements will not build again until the state
// is reset with the Reset call.
function DisableReinforcements()
{
	Disabled = true;
}
