//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_RecruitSoldiers
//  AUTHOR:  Peter Ledbrook
//
//  PURPOSE: A big ball of event listeners we need to set up for tactical games.
//--------------------------------------------------------------------------------------- 

class UIScreenListener_RecruitSoldiers extends UIScreenListener config(LW_Overhaul);

event OnInit(UIScreen Screen)
{
    local UIRecruitSoldiers RecruitScreen;
    local int i;

    RecruitScreen = UIRecruitSoldiers(Screen);
    if (RecruitScreen == none)
    {
        return;
    }

    for (i = 0; i < RecruitScreen.List.ItemContainer.ChildPanels.Length; i++)
    {
        class'UIRecruitmentListItem_LW'.static.AddRecruitStats(
                RecruitScreen.m_arrRecruits[i],
                UIRecruitmentListItem(RecruitScreen.List.ItemContainer.ChildPanels[i]));
    }
}

event OnReceiveFocus(UIScreen Screen)
{
    local UIRecruitSoldiers RecruitScreen;
    local int i;

    RecruitScreen = UIRecruitSoldiers(Screen);
    if (RecruitScreen == none)
    {
        return;
    }

    for (i = 0; i < RecruitScreen.List.ItemContainer.ChildPanels.Length; i++)
    {
        class'UIRecruitmentListItem_LW'.static.UpdateItemsForFocus(UIRecruitmentListItem(RecruitScreen.List.ItemContainer.ChildPanels[i]));
    }
}

event OnLoseFocus(UIScreen Screen)
{
    local UIRecruitSoldiers RecruitScreen;
    local int i;

    RecruitScreen = UIRecruitSoldiers(Screen);
    if (RecruitScreen == none)
    {
        return;
    }

    for (i = 0; i < RecruitScreen.List.ItemContainer.ChildPanels.Length; i++)
    {
        class'UIRecruitmentListItem_LW'.static.UpdateItemsForFocus(UIRecruitmentListItem(RecruitScreen.List.ItemContainer.ChildPanels[i]));
    }
}

defaultProperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none
}
