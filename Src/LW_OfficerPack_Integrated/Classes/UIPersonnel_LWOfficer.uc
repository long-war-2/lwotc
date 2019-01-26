//---------------------------------------------------------------------------------------
//  FILE:    UIPersonnel_LWOfficer
//  AUTHOR:  Amineri
//
//  PURPOSE: Implements custom localization and filtering mechanism for officer selection
//
//--------------------------------------------------------------------------------------- 

class UIPersonnel_LWOfficer extends UIPersonnel;

var public localized string EmptyListMessage;

var private UIText StatusMessage;

simulated function UpdateData()
{
	local int i;
	local XComGameState_Unit Unit;
	local XComGameStateHistory History;
	local XComGameState_StaffSlot SlotState;
	local StaffUnitInfo SlotUnitInfo;

	History = `XCOMHISTORY;
	SlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(SlotRef.ObjectID));

	// Destroy old data
	m_arrSoldiers.Length = 0;
	m_arrScientists.Length = 0;
	m_arrEngineers.Length = 0;
	m_arrDeceased.Length = 0;

	//Need to get the latest state here, else you may have old sata in the list upon refreshing at OnReceiveFocus, such as 
	//still showing dismissed soldiers. 
	HQState = class'UIUtilities_Strategy'.static.GetXComHQ();

	for(i = 0; i < HQState.Crew.Length; i++)
	{
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(HQState.Crew[i].ObjectID));
		SlotUnitInfo.UnitRef = Unit.GetReference();

		if(Unit.IsAlive())
		{
			if (Unit.IsSoldier())
			{
				//Check StaffSlot Validation function, defined in LWOfficer StaffSlot Template
				if (SlotState.ValidUnitForSlot(SlotUnitInfo))
				{
					if (m_arrNeededTabs.Find(eUIPersonnel_Soldiers) != INDEX_NONE)
					{
						m_arrSoldiers.AddItem(Unit.GetReference());
					}
				}
			}
	}
	if( StatusMessage == none )
	{
		StatusMessage = Spawn(class'UIText', self).InitText(, "");
		StatusMessage.SetWidth(m_kList.Width); 
		StatusMessage.SetPosition(m_kList.X, m_kList.Y);
	}

	if( m_arrSoldiers.length == 0 )
	{
		StatusMessage.SetHTMLText( EmptyListMessage );
	}
	else
	{
		StatusMessage.SetHTMLText("");
	}
}

} 

defaultproperties
{
	m_eListType = eUIPersonnel_Soldiers;
	m_bRemoveWhenUnitSelected = true;
}