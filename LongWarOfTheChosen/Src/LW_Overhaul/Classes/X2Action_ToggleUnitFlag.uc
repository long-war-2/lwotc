//---------------------------------------------------------------------------------------
//  FILE:    X2Action_ToggleUnitFlag.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: An action to toggle unit flag visibility on a unit. Implemented as an action
//           to allow the toggle to sync with a particular visualization.
//---------------------------------------------------------------------------------------
class X2Action_ToggleUnitFlag extends X2Action;

var privatewrite bool bEnableFlag;
var UIUnitFlag UnitFlag;

function Init()
{
	super.Init();
}

function SetEnableFlag(bool v)
{
    bEnableFlag = v;
}

simulated state Executing
{
Begin:
    UnitFlag = `PRES.m_kUnitFlagManager.GetFlagForObjectID(Unit.ObjectID);
    if (UnitFlag == none)
    {
        `PRES.m_kUnitFlagManager.AddFlag(Unit.GetVisualizedStateReference());
        UnitFlag = `PRES.m_kUnitFlagManager.GetFlagForObjectID(Unit.ObjectID);
        `assert(UnitFlag != none);
    }
    
    if (bEnableFlag)
    {
        UnitFlag.Show();
    }
    else
    {
        UnitFlag.Hide();
    }

    CompleteAction();
}
