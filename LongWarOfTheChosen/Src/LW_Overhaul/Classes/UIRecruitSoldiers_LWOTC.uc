//---------------------------------------------------------------------------------------
//  FILE:	 UIRecruitSoldiers_LWOTC.uc
//  AUTHOR:	 KDM
//  PURPOSE: Long War of the Chosen compatible recruit screen.
//--------------------------------------------------------------------------------------- 

class UIRecruitSoldiers_LWOTC extends UIRecruitSoldiers;

simulated function UpdateData()
{
	local int i;
	local XComGameState_Unit Recruit;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	AS_SetTitle(m_strListTitle);

	List.ClearItems();
	m_arrRecruits.Length = 0;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	if (ResistanceHQ != none)
	{
		for (i = 0; i < ResistanceHQ.Recruits.Length; i++)
		{
			Recruit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ResistanceHQ.Recruits[i].ObjectID));
			m_arrRecruits.AddItem(Recruit);
			// KDM : Create and add our custom list item to the list.
			UIRecruitmentListItem_LWOTC(List.CreateItem(class'UIRecruitmentListItem_LWOTC')).InitRecruitItem(Recruit);
		}
	}

	if (m_arrRecruits.Length > 0)
	{
		// KDM : If we don't call RealizeList(), the bottom of the list gets cut off after recruiting a soldier.
		List.RealizeList();
		List.SetSelectedIndex(0, true);
	}
	else
	{
		List.SetSelectedIndex(-1, true);
		AS_SetEmpty(m_strNoRecruits);
	}
}
