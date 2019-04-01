//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_PersonnelLists.uc
//  AUTHOR:  Peter Ledbrook
//
//  PURPOSE: This class updates the Rank string to include the squad name, and rolls for AWC abilities when needed
//---------------------------------------------------------------------------------------

class UIScreenListener_PersonnelLists extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	EnableButtonsForSoldiersOnMissions(Screen);
}

event OnReceiveFocus(UIScreen Screen)
{
	EnableButtonsForSoldiersOnMissions(Screen);
}

function EnableButtonsForSoldiersOnMissions(UIScreen Screen)
{
	local UIPersonnel_Armory SoldierList;
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;
	local UIPersonnel_ListItem UnitItem;
	local int i;

	SoldierList = UIPersonnel_Armory(Screen);
	if (SoldierList == none)
	{
		`Redscreen("UIScreenListener_PersonnelLists triggering on wrong screen");
		return;
	}

	// Re-enable any soldiers who are away on Covert Actions
	History = `XCOMHISTORY;
	for (i = 0; i < SoldierList.m_kList.itemCount; ++i)
	{
		UnitItem = UIPersonnel_ListItem(SoldierList.m_kList.GetItem(i));
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitItem.UnitRef.ObjectID));

		if(Unit.IsOnCovertAction())
		{
			UnitItem.SetDisabled(false);
		}
	}
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIPersonnel_Armory;
}