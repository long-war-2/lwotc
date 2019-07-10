//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteRendezvous_LW.uc
//  AUTHOR:  tracktwo (LWS)
//  PURPOSE: Special code for the rendezvous mission type: skip skyranger travel and squad select.
//---------------------------------------------------------------------------------------



class XComGameState_MissionSiteRendezvous_LW extends XComGameState_MissionSite
    config(LW_Overhaul);

var config int MAX_REBELS_FOR_RENDEZVOUS;

var array<StateObjectReference> FacelessSpies;

function bool RequiresAvenger()
{
	// We don't need the avenger to be present for this mission
	return false;
}

function SelectSquad()
{
	local XGStrategy StrategyGame;
    local XComGameState_HeadquartersXCom XComHQ;
    local XComGameState NewGameState;
    local XComGameStateHistory History;
    local XComGameState_LWOutpost OutpostState;
    local XComGameState_WorldRegion RegionState;
    local XComGameState_Unit Unit;
    local XComGameState_Unit Proxy;
    local StateObjectReference UnitRef;
    local int i;
    local int NumRebels;

	BeginInteraction();

	StrategyGame = `GAME;
	StrategyGame.PrepareTacticalBattle(ObjectID);

    History = `XCOMHISTORY;
    XComHQ = `XCOMHQ;

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Fill Rendezvous Squad");
    XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
    NewGameState.AddStateObject(XComHQ);

    RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(Region.ObjectID));
    OutpostState = `LWOUTPOSTMGR.GetOutpostForRegion(RegionState);

    // Clear out any old squad
    XComHQ.Squad.Length = 0;

    // Add the liaison
    UnitRef = OutpostState.GetLiaison();
    Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
    if (Unit != none && Unit.IsSoldier())
    {
        XComHQ.Squad.AddItem(Unit.GetReference());
    }
    else
    {
        `redscreen("Error: Rendezvous launched with no soldier liaison!");
    }

    // Add some rebels.
    NumRebels = Min(MAX_REBELS_FOR_RENDEZVOUS, OutpostState.Rebels.Length);

    for (i = 0; i < OutpostState.Rebels.Length; ++i)
    {
        // Exclude the faceless spies
        if (FacelessSpies.Find('ObjectID', OutpostState.Rebels[i].Unit.ObjectID) >= 0)
        {
            continue;
        }

        Unit = XComGameState_Unit(History.GetGameStateForObjectID(OutpostState.Rebels[i].Unit.ObjectID));
        `LWTrace("Adding " $ Unit.GetFullName() $ " to rendezvous squad");
        Proxy = class'Utilities_LW'.static.CreateRebelSoldier(OutpostState.Rebels[i].Unit, OutpostState.GetReference(), NewGameState);
        XComHQ.Squad.AddItem(Proxy.GetReference());

        --NumRebels;
        if (NumRebels <= 0)
            break;
    }

    // Borrowed from Covert Infiltration mod:
	// This isn't needed to properly spawn units into battle, but without this
	// the transition screen shows last selection in strategy, not the soldiers
	// on this mission.
	XComHQ.AllSquads.Length = 1;
	XComHQ.AllSquads[0].SquadMembers = XComHQ.Squad;

	`GAMERULES.SubmitGameState(NewGameState);

    // Start the mission
    ConfirmMission();
}


// Set up the faceless units for the mission.
function SetupFacelessUnits()
{
    local XComGameStateHistory History;
    local XComGameState_AIGroup Group;
    local int i;

    History = `XCOMHISTORY;
    // Locate our special encounter IDs
    foreach History.IterateByClassType(class'XComGameState_AIGroup', Group)
    {
        if (Group.TeamName == ETeam.eTeam_Alien)
        {
            break;
        }
    }

    for (i = 0; i < FacelessSpies.Length; ++i)
    {
        SetupFaceless(FacelessSpies[i], Group);
    }
}

function SetupFaceless(StateObjectReference FacelessRef, XComGameState_AIGroup Group)
{
    local XComGameState NewGameState;
    local XComGameStateContext_TacticalGameRule NewGameStateContext;
    local XComGameState_Unit ProxyUnit;
    local XGAIPlayer AIPlayer;
    local XComGameState_AIPlayerData PlayerData;
    local XComGameStateHistory History;
    local XComGameState_LWOutpost OutpostState;
    local XComGameState_WorldRegion RegionState;
    local TTile UnitTile;

    History = `XCOMHISTORY;
    NewGameStateContext = class'XComGameStateContext_TacticalGameRule'.static.BuildContextFromGameRule(eGameRule_UnitAdded);
    NewGameState = History.CreateNewGameState(true, NewGameStateContext);

    // Find a position for this unit
    Group.GetUnitMidpoint(UnitTile);
    if (class'Utilities_LW'.static.GetSpawnTileNearTile(UnitTile, 2, 4))
    {
        RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(Region.ObjectID));
        OutpostState = `LWOUTPOSTMGR.GetOutpostForRegion(RegionState);
        ProxyUnit = class'Utilities_LW'.static.AddRebelToMission(FacelessRef, OutpostState.GetReference(), 'FacelessCivilian', UnitTile, eTeam_Alien, NewGameState);
        AIPlayer = XGAIPlayer(XGBattle_SP(`BATTLE).GetAIPlayer());
        PlayerData = XComGameState_AIPlayerData(NewGameState.CreateStateObject(class'XComGameState_AIPlayerData', AIPlayer.GetAIDataID()));
        NewGameState.AddStateObject(PlayerData);
        PlayerData.TransferUnitToGroup(Group.GetReference(), ProxyUnit.GetReference(), NewGameState);
        `TACTICALRULES.SubmitGameState(NewGameState);
        ProxyUnit.OnBeginTacticalPlay(NewGameState);
    }
    else
    {
        `LWDebug("Failed to find a position for faceless");
    }
}

