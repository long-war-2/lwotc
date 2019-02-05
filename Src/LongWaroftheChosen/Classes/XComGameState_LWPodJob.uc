//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWPodJob.uc
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: Maintains state information for a job assigned to a pod.
//---------------------------------------------------------------------------------------
class XComGameState_LWPodJob extends XComGameState_BaseObject
    config(LW_PodManager);

`include(LongWaroftheChosen\Src\LW_Overhaul.uci)

var config const int MAX_TURNS_FOR_JOB;

var StateObjectReference GroupRef;
var Name TemplateName;
var int InitTurn;
var int ID;
var EAlertCause AlertCause;
var String AlertTag;
var int AlertLevelOnJobAssignment;

function XComGameState_AIPlayerData GetAIPlayerData()
{
    local XGAIPlayer AIPlayer;

    AIPlayer = XGAIPlayer(`BATTLE.GetAIPlayer());
    return XComGameState_AIPlayerData(`XCOMHISTORY.GetGameStateForObjectID(AIPlayer.m_iDataID));
}

function InitJob(LWPodJobTemplate JobTemplate, XComGameState_AIGroup Group, int JobID, EAlertCause Cause, String Tag, XComGameState NewGameState)
{
    local XComGameState_AIPlayerData AIPlayerData;
	local XComGameState_Unit Unit;
    
    GroupRef = Group.GetReference();

	// Remember what alert level this pod was at when they were assigned this job.
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Group.m_arrMembers[0].ObjectID));
	AlertLevelOnJobAssignment = Unit.GetCurrentStat(eStat_AlertLevel);
    TemplateName = JobTemplate.DataName;

    // Record the turn we started the job
    AIPlayerData = GetAIPlayerData();
    InitTurn = AIPlayerData.StatsData.TurnCount;

    // Record the alert cause to use when setting alerts for this job.
    AlertCause = Cause;

	// Record any tag we should use for this alert.
	AlertTag = Tag;

    // Record the original ID of this job.
    ID = JobID;
}

function bool ProcessTurn(XComGameState_LWPodManager PodMgr, XComGameState NewGameState)
{
    return ShouldContinueJob(NewGameState);
}

function bool ShouldContinueJob(XComGameState NewGameState)
{
    return !HasJobExpired();
}

function bool HasJobExpired()
{
    local XComGameState_AIPlayerData AIPlayerData;

    // Have we reached a threshold time limit since we set this job?
    AIPlayerData = GetAIPlayerData();
    if ((AIPlayerData.StatsData.TurnCount - InitTurn) > MAX_TURNS_FOR_JOB)
    {
        return true;
    }

    return false;
}

// Given the target location 'Loc', adjust it until it's a place this group can actually
// reach, returning the new, adjusted vector.
function static Vector AdjustLocation(Vector Loc, XComGameState_AIGroup Group)
{
	local XGUnit Visualizer;
	local XComWorldData WorldData;
	local array<TTile> Path;
	local TTile TileDest;

	WorldData = `XWORLD;

    // Make sure the target location is on the map. Just because it's on the map
	// doesn't mean we can path there, though...
    Loc = `XWORLD.FindClosestValidLocation(Loc, false, false);

	// Lookup the leader
	Visualizer = XGUnit(`XCOMHISTORY.GetVisualizer(Group.m_arrMembers[0].ObjectID));

	if (Visualizer != none)
	{
		// Get the tile coordinates for this location
		if (!WorldData.GetFloorTileForPosition(Loc, TileDest))
		{
			TIleDest = WorldData.GetTileCoordinatesFromPosition(Loc);
		}

		// Do we have a valid path there?
		if (!Visualizer.m_kReachableTilesCache.BuildPathToTile(TileDest, Path))
		{
			// Nope, find the cloest tile we can reach
			TileDest = Visualizer.m_kReachableTilesCache.GetClosestReachableDestination(TileDest);

			// Can we find a path now?
			if (!Visualizer.m_kReachableTilesCache.BuildPathToTile(TileDest, Path))
			{
				// Nope. Give up. So Sad.
				`RedScreen("Unable to build path to job location.");
			}
		}

		// Set the location at the reachable tile.
		Loc = WorldData.GetPositionFromTileCoordinates(TileDest);
	}

	return Loc;
}

// Set an alert at the given location. Will adjust the given location to the nearest on-map position and return
// the adjusted vector.
function Vector SetAlertAtLocation(Vector Location, XComGameState_AIGroup Group, XComGameState NewGameState)
{
    local AlertAbilityInfo AlertInfo;
    local XComGameStateHistory History;
    local StateObjectReference UnitRef;
    local XComGameState_Unit Unit;
    local XComGameState_AIUnitData AIData;
    local int AIUnitDataID;

    History = `XCOMHISTORY;

	Location = AdjustLocation(Location, Group);

    AlertInfo.AlertTileLocation = `XWORLD.GetTileCoordinatesFromPosition(Location);
    AlertInfo.AlertRadius = 1000;
    AlertInfo.AlertUnitSourceID = 0;
    AlertInfo.AnalyzingHistoryIndex = History.GetCurrentHistoryIndex();

    foreach Group.m_arrMembers(UnitRef)
    {
        Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
        AIUnitDataID = Unit.GetAIUnitDataID();

        if (Unit.IsAlive() && AIUnitDataID > 0)
        {
            AIData = XComGameState_AIUnitData(NewGameState.CreateStateObject(class'XComGameState_AIUnitData', AIUnitDataID));
            if (AIData.AddAlertData(UnitRef.ObjectID, AlertCause, AlertInfo, NewGameState, AlertTag))
            {
               NewGameState.AddStateObject(AIData);
            }
            else
            {
                NewGameState.PurgeGameStateForObjectID(AIData.ObjectID);
            }
        }
    }

	return Location;
}

function name GetMyTemplateName()
{
    return TemplateName;
}

function LWPodJobTemplate GetMyTemplate()
{
    local X2StrategyElementTemplateManager TemplateMgr;
    local LWPodJobTemplate Template;

    TemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
    Template = LWPodJobTemplate(TemplateMgr.FindStrategyElementTemplate(TemplateName));
    return Template;
}

function String GetDebugString()
{
    return " ["$`LWPODMGR.MissionJobs[ID].FriendlyName $"] " $ String(TemplateName);
}

function DrawDebugLabel(Canvas kCanvas)
{
}

