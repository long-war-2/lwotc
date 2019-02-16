//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_MissionSiteRebelRaid_LW.uc
//  AUTHOR:  tracktwo (LWS)
//  PURPOSE: Special code for the rebel raid mission types: Record a list of rebels to spawn in-mission
//---------------------------------------------------------------------------------------



class XComGameState_MissionSiteRebelRaid_LW extends XComGameState_MissionSite
    config(LW_Overhaul);

enum RebelRaid_SpawnType
{
    eRebelRaid_SpawnWithSquad,
    eRebelRaid_SpawnAtObjective
};

var array<StateObjectReference> Rebels;
var RebelRaid_SpawnType SpawnType;
var bool ArmRebels;

function LoadRebels()
{
    local XComGameState_LWOutpost OutpostState;
    local XComGameState_WorldRegion RegionState;
    local XComGameState_BattleData BattleDataState;
    local XComWorldData WorldData;
    local int i;
    local StateObjectReference RebelRef;
    local TTile RootTile;
    local TTile Tile;
   
    RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(Region.ObjectID));
    OutpostState = `LWOUTPOSTMGR.GetOutpostForRegion(RegionState);
    WorldData = `XWORLD;
    BattleDataState = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

    switch(SpawnType)
    {
    case eRebelRaid_SpawnAtObjective:
        // We want to spawn the rebels near the objective.
        WorldData.GetFloorTileForPosition(BattleDataState.MapData.ObjectiveLocation, RootTile);
        break;
    case eRebelRaid_SpawnWithSquad:
        // We want to spawn the rebels at the xcom spawn point.
        WorldData.GetFloorTileForPosition(BattleDataState.MapData.SoldierSpawnLocation, RootTile);
        break;
    default:
        // Unknown: Log it and spawn em at the objective.
        `redscreen("XComGameState_MissionSiteRebelRaid_LW.LoadRebels: Unknown spawn type " $ SpawnType);
        WorldData.GetFloorTileForPosition(BattleDataState.MapData.ObjectiveLocation, RootTile);
        break;
    }

    for (i = 0; i < Rebels.Length; ++i)
    {
        RebelRef = Rebels[i];
        Tile = RootTile;
        if (class'Utilities_LW'.static.GetSpawnTileNearTile(Tile, 3, 8))
        {
            if (ArmRebels)
            {
                class'Utilities_LW'.static.AddRebelSoldierToMission(RebelRef, OutpostState.GetReference(), Tile);
            }
            else
            {
                class'Utilities_LW'.static.AddRebelToMission(RebelRef, OutpostState.GetReference(), 'Rebel', Tile);
            }
        } 
    }
}

defaultproperties
{
    SpawnType=eRebelRaid_SpawnAtObjective
    ArmRebels=true
}
