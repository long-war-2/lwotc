//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetSpawnLocation.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Locate the spawn point for XCom.
//---------------------------------------------------------------------------------------

class SeqAct_XComSpawnLocation extends SequenceAction;

var private Vector SpawnLocation;

event Activated()
{
    local XComParcelManager ParcelManager;
    local XComGroupSpawn SoldierSpawn;

    ParcelManager = `PARCELMGR;
    SoldierSpawn = ParcelManager.SoldierSpawn;

    if(SoldierSpawn == none) // check for test maps, just grab any spawn
    {
        foreach `XComGRI.AllActors(class'XComGroupSpawn', SoldierSpawn)
        {
            break;
        }
    }

    SpawnLocation = SoldierSpawn.Location;
}

defaultproperties
{
    ObjName="Get XCom Spawn Location"
    bConvertedForReplaySystem=true
    bCanBeUsedForGameplaySequence=true
    bAutoActivateOutputLinks=true

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Position",PropertyName=SpawnLocation,bWriteable=true)
}
