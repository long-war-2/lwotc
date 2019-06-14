// UIScreenListener_PersonnelSquadSelect.uc
//
// Ensures that the 'OnSoldierListItemUpdateDisabled' event is fired for each
// soldier list item so that various parts of the system can enable/disable
// soldiers for missions.
class UIScreenListener_PersonnelSquadSelect extends UIScreenListener;

event OnInit(UIScreen Screen)
{
    local UIPersonnel_SquadSelect PersonnelListScreen;

    PersonnelListScreen = UIPersonnel_SquadSelect(Screen);
    if (PersonnelListScreen == none)
    {
        `REDSCREEN("UIScreenListener_PersonnelSquadSelect: Screen is not of the expected type");
        return;
    }

    FireEvents(PersonnelListScreen.m_kList);
}

event OnReceiveFocus(UIScreen Screen)
{
    local UIPersonnel_SquadSelect PersonnelListScreen;

    PersonnelListScreen = UIPersonnel_SquadSelect(Screen);
    if (PersonnelListScreen == none)
    {
        `REDSCREEN("UIScreenListener_PersonnelSquadSelect: Screen is not of the expected type");
        return;
    }

    FireEvents(PersonnelListScreen.m_kList);
}

function FireEvents(UIList PersonnelList)
{
    local UIPersonnel_ListItem UnitItem;
    local int i;

	// loop through every soldier to make sure they're not already in the squad
	for (i = 0; i < PersonnelList.ItemCount; ++i)
    {
        UnitItem = UIPersonnel_ListItem(PersonnelList.GetItem(i));

        // trigger now to allow overriding disabled status, and to add background elements
        `XEVENTMGR.TriggerEvent('OnSoldierListItemUpdateDisabled', UnitItem, None);
    }
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIPersonnel_SquadSelect;
}
