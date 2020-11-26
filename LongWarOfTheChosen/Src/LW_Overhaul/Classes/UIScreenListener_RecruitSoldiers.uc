//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_RecruitSoldiers
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: A big ball of event listeners we need to set up for tactical games.
//
//	KDM : This recruit screen 'screen listener' has been disabled so that the recruit screen can be modded.
//
//	The former implementation was problematic for 2 reasons :
//	1.] When you recruited a soldier from the recruit screen, the screen reverted to its base game 'look'.
//	2.] Recruit attribute text did not change colour when different recruit rows were selected. 
//	This is because, while the screen listener implemented OnReceiveFocus and OnLoseFocus, these were only 
//	called when the screen itself received and lost focus; they were not called when individual list 
//	items received and lost focus.
//
//	My fixed recruit screen mod can be found at : https://steamcommunity.com/sharedfiles/filedetails/?id=2116413401
//--------------------------------------------------------------------------------------- 

class UIScreenListener_RecruitSoldiers extends UIScreenListener config(LW_Overhaul);

/*
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
*/
