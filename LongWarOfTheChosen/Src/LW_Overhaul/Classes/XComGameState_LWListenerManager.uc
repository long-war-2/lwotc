//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWListenerManager.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This singleton object manages general persistent listeners that should live for both strategy and tactical play
//---------------------------------------------------------------------------------------
class XComGameState_LWListenerManager extends XComGameState_BaseObject config(LW_Overhaul) dependson(XComGameState_LWPersistentSquad);

var config int DEFAULT_LISTENER_PRIORITY;

var localized string ResistanceHQBodyText;


var config array<int>INITIAL_PSI_TRAINING;

static function XComGameState_LWListenerManager GetListenerManager(optional bool AllowNULL = false)
{
	return XComGameState_LWListenerManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWListenerManager', AllowNULL));
}

static function CreateListenerManager(optional XComGameState StartState)
{
	local XComGameState_LWListenerManager ListenerMgr;
	local XComGameState NewGameState;
	`Log("Creating LW Listener Manager --------------------------------");

	//first check that there isn't already a singleton instance of the listener manager
	if(GetListenerManager(true) != none)
	{
		`Log("LW listener manager already exists");
		return;
	}

	if(StartState != none)
	{
		ListenerMgr = XComGameState_LWListenerManager(StartState.CreateNewStateObject(class'XComGameState_LWListenerManager'));
	}
	else
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating LW Listener Manager Singleton");
		ListenerMgr = XComGameState_LWListenerManager(NewGameState.CreateNewStateObject(class'XComGameState_LWListenerManager'));
	}

	ListenerMgr.InitListeners();
}

static function RefreshListeners()
{
	local XComGameState_LWListenerManager ListenerMgr;
	local XComGameState_LWSquadManager    SquadMgr;
	`Log("Refreshing listeners --------------------------------");

	ListenerMgr = GetListenerManager(true);
	if(ListenerMgr == none)
		CreateListenerManager();
	else
		ListenerMgr.InitListeners();
		
	SquadMgr = class'XComGameState_LWSquadManager'.static.GetSquadManager(true);
	if (SquadMgr != none)
		SquadMgr.InitSquadManagerListeners();
}

function InitListeners()
{
	local X2EventManager EventMgr;
	local Object ThisObj;

	`LWTrace ("Init Listeners Firing!");

	ThisObj = self;
	EventMgr = `XEVENTMGR;
	EventMgr.UnregisterFromAllEvents(ThisObj); // clear all old listeners to clear out old stuff before re-registering

	// Mission summary civilian counts
	// WOTC TODO: Requires change to CHL Helpers and UIMissionSummary
	// EventMgr.RegisterForEvent(ThisObj, 'GetNumCiviliansKilled', OnNumCiviliansKilled, ELD_Immediate,,,true);

    // VIP Recovery screen
    // EventMgr.RegisterForEvent(ThisObj, 'GetRewardVIPStatus', OnGetRewardVIPStatus, ELD_Immediate,,, true);

    // Version check
    // EventMgr.RegisterForEvent(ThisObj, 'GetLWVersion', OnGetLWVersion, ELD_Immediate,,, true);

    // Async rebel photographs
    // EventMgr.RegisterForEvent(ThisObj, 'RefreshCrewPhotographs', OnRefreshCrewPhotographs, ELD_Immediate,,, true);

    // Override UFO interception time (since base-game uses Calendar, which no longer works for us)
    // EventMgr.RegisterForEvent(ThisObj, 'PostUFOSetInterceptionTime', OnUFOSetInfiltrationTime, ELD_Immediate,,, true);

	// initial psi training time override (this DOES require a change to the highlander)
	// EventMgr.RegisterForEvent(ThisObj, 'PsiTrainingBegun', OnOverrideInitialPsiTrainingTime, ELD_Immediate,,, true);
}

function EventListenerReturn OnNumCiviliansKilled(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local XGBattle_SP Battle;
    local XComGameState_BattleData BattleData;
    local array<XComGameState_Unit> arrUnits;
    local bool RequireEvac;
    local bool PostMission;
	local bool RequireTriadObjective;
    local int i, Total, Killed;
	local array<Name> TemplateFilter;

    Tuple = XComLWTuple(EventData);
    if (Tuple == none || Tuple.Id != 'GetNumCiviliansKilled' || Tuple.Data.Length > 1)
    {
        return ELR_NoInterrupt;
    }

    PostMission = Tuple.Data[0].b;

    switch(class'Utilities_LW'.static.CurrentMissionType())
    {
        case "Terror_LW":
            // For terror, all neutral units are interesting, and we save anyone
            // left on the map if we win the triad objective (= sweep). Rebels left on
			// the map if sweep wasn't completed are lost.
			RequireTriadObjective = true;
            break;
        case "Defend_LW":
            // For defend, all neutral units are interesting, but we don't count
            // anyone left on the map, regardless of win.
            RequireEvac = true;
            break;
        case "Invasion_LW":
            // For invasion, we only want to consider civilians with the 'Rebel' or
            // 'FacelessRebelProxy' templates.
			TemplateFilter.AddItem('Rebel');
            break;
        case "Jailbreak_LW":
            // For jailbreak we only consider evac'd units as 'saved' regardless of whether
            // we have won or not. We also only consider units with the template 'Rebel' or
			// 'Soldier_VIP', and don't count any regular civvies in the mission.
            RequireEvac = true;
            TemplateFilter.AddItem('Rebel');
			TemplateFilter.AddItem('Soldier_VIP');
            break;
        default:
            return ELR_NoInterrupt;
    }

    Battle = XGBattle_SP(`BATTLE);
    BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

    if (Battle != None)
    {
        Battle.GetCivilianPlayer().GetOriginalUnits(arrUnits);
    }

    for (i = 0; i < arrUnits.Length; ++i)
    {
        if (arrUnits[i].GetMyTemplateName() == 'FacelessRebelProxy')
        {
            // A faceless rebel proxy: we only want to count this guy if it isn't removed from play: they can't
            // be evac'd so if they're removed they must have been revealed so we don't want to count them.
            if (arrUnits[i].bRemovedFromPlay)
            {
                arrUnits.Remove(i, 1);
                --i;
                continue;
            }
        }
        else if (TemplateFilter.Length > 0 && TemplateFilter.Find(arrUnits[i].GetMyTemplateName()) == -1)
        {
            arrUnits.Remove(i, 1);
            --i;
            continue;
        }
    }

    // Compute the number killed
    Total = arrUnits.Length;

    for (i = 0; i < Total; ++i)
    {
        if (arrUnits[i].IsDead())
        {
            ++Killed;
        }
        else if (PostMission && !arrUnits[i].bRemovedFromPlay)
        {
			// If we require the triad objective, units left behind on the map
			// are lost unless it's completed.
			if (RequireTriadObjective && !BattleData.AllTriadObjectivesCompleted())
			{
				++Killed;
			}
            // If we lose or require evac, anyone left on map is killed.
            else if (!BattleData.bLocalPlayerWon || RequireEvac)
			{
                ++Killed;
			}
        }
    }

    Value.Kind = XComLWTVInt;
    Value.i = Killed;
    Tuple.Data.AddItem(Value);

    Value.i = Total;
    Tuple.Data.AddItem(Value);
    return ELR_NoInterrupt;
}

function EventListenerReturn OnGetRewardVIPStatus(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local XComGameState_Unit Unit;
    local XComGameState_MissionSite MissionSite;

    Tuple = XComLWTuple(EventData);
    // Not a tuple or already filled out?
    if (Tuple == none || Tuple.Data.Length != 1 || Tuple.Data[0].Kind != XComLWTVObject)
    {
        return ELR_NoInterrupt;
    }

    // Make sure we have a unit
    Unit = XComGameState_Unit(Tuple.Data[0].o);
    if (Unit == none)
    {
        return ELR_NoInterrupt;
    }

    // Make sure we have a mission site
    MissionSite = XComGameState_MissionSite(EventSource);
    if (MissionSite == none)
    {
        return ELR_NoInterrupt;
    }

    if (MissionSite.GeneratedMission.Mission.sType == "Jailbreak_LW")
    {
        // Jailbreak mission: Only evac'd units are considered rescued.
        // (But dead ones are still dead!)
        Value.Kind = XComLWTVInt;
        if (Unit.IsDead())
        {
            Value.i = eVIPStatus_Killed;
        }
        else
        {
            Value.i = Unit.bRemovedFromPlay ? eVIPStatus_Recovered : eVIPStatus_Lost;
        }
        Tuple.Data.AddItem(Value);
    }

    return ELR_NoInterrupt;
}

// Allow mods to query the LW version number. Trigger the 'GetLWVersion' event with an empty tuple as the eventdata and it will
// return a 3-tuple of ints with Data[0]=Major, Data[1]=Minor, and Data[2]=Build.
function EventListenerReturn OnGetLWVersion(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local int Major, Minor, Build;
    Tuple = XComLWTuple(EventData);
    if (Tuple == none)
    {
        return ELR_NoInterrupt;
    }

    class'LWVersion'.static.GetVersionNumber(Major, Minor, Build);
    Tuple.Data.Add(3);
    Tuple.Data[0].Kind = XComLWTVInt;
    Tuple.Data[0].i = Major;
    Tuple.Data[1].Kind = XComLWTVInt;
    Tuple.Data[1].i = Minor;
    Tuple.Data[2].Kind = XComLWTVInt;
    Tuple.Data[2].i = Build;

    return ELR_NoInterrupt;
}

// It's school picture day. Add all the rebels.
function EventListenerReturn OnRefreshCrewPhotographs(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local XComGameState_LWOutpost Outpost;
    local XComGameState_WorldRegion Region;
    local int i;

    Tuple = XComLWTuple(EventData);
    if (Tuple == none)
    {
        return ELR_NoInterrupt;
    }

    Value.Kind = XComLWTVInt;
    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
    {
        Region = Outpost.GetWorldRegionForOutPost();
        if (!Region.HaveMadeContact())
            continue;

        for (i = 0; i < Outpost.Rebels.Length; ++i)
        {
            Value.i = Outpost.Rebels[i].Unit.ObjectID;
            Tuple.Data.AddItem(Value);
        }
    }
	*/
    return ELR_NoInterrupt;
}

// Override how the UFO interception works, since we don't use the calendar
function EventListenerReturn OnUFOSetInfiltrationTime(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComGameState_UFO UFO;
	local int HoursUntilIntercept;

    UFO = XComGameState_UFO(EventData);
    if (UFO == none)
    {
        return ELR_NoInterrupt;
    }

	if (UFO.bDoesInterceptionSucceed)
	{
		UFO.InterceptionTime = UFO.GetCurrentTime();

		HoursUntilIntercept = (UFO.MinNonInterceptDays * 24) + `SYNC_RAND((UFO.MaxNonInterceptDays * 24) - (UFO.MinNonInterceptDays * 24) + 1);
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(UFO.InterceptionTime, HoursUntilIntercept);
	}

    return ELR_NoInterrupt;
}

//function EventListenerReturn OnOverrideInitialPsiTrainingTime(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
//{
	//local XComLWTuple Tuple;
//
	//Tuple = XComLWTuple(EventData);
	//if (Tuple == none)
	//{
		//return ELR_NoInterrupt;
	//}
	//Tuple.Data[0].i=default.INITIAL_PSI_TRAINING[`STRATEGYDIFFICULTYSETTING];
	//return ELR_NoInterrupt;
//}
//
// TechState, TechState
