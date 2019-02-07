//---------------------------------------------------------------------------------------
//  FILE:    UIPersonnel_SquadSelect_LWOfficerPack.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Provides custom behavior for personnel selection screen when
//           selecting soldiers to take on a mission.
//			 Extends functionality to prevent more than one officer from being selected.
//--------------------------------------------------------------------------------------- 

class UIPersonnel_SquadSelect_LWOfficerPack extends UIPersonnel_SquadSelect;

//override in order to add special condition preventing adding a second officer
simulated function UpdateList()
{
	local int i;
	local XComGameState_Unit Unit;
	local GeneratedMissionData MissionData;
	local UIPersonnel_ListItem UnitItem;
	local bool bAllowWoundedSoldiers; // true if wounded soldiers are allowed to be deployed on this mission
	
	super(UIPersonnel).UpdateList();
	
	MissionData = HQState.GetGeneratedMissionData(HQState.MissionRef.ObjectID);
	bAllowWoundedSoldiers = MissionData.Mission.AllowDeployWoundedUnits;

	// loop through every soldier to make sure they're not already in the squad
	for(i = 0; i < m_kList.itemCount; ++i)
	{
		UnitItem = UIPersonnel_ListItem(m_kList.GetItem(i));
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitItem.UnitRef.ObjectID));	

		if(HQState.IsUnitInSquad(UnitItem.UnitRef) 
			|| (Unit.IsInjured() && !bAllowWoundedSoldiers && !Unit.IgnoresInjuries()) 
			|| Unit.IsTraining() 
			|| Unit.IsPsiTraining()
			|| (class'LWOfficerUtilities'.static.IsOfficer(Unit) && class'LWOfficerUtilities'.static.HasOfficerInSquad() && !bAllowWoundedSoldiers))
			UnitItem.SetDisabled(true);

	}
}

//override to use custom extension of UIPersonnel_ListItem in order to display custom status for officers
// calling this function will add items instantly
simulated function PopulateListInstantly()
{
	local array<StateObjectReference> CurrentData;
	local UIPersonnel_ListItem kItem;
	local StateObjectReference SoldierRef;

	CurrentData = GetCurrentData();
	HQState = class'UIUtilities_Strategy'.static.GetXComHQ();

	while( m_kList.itemCount < CurrentData.Length )
	{
		kItem = Spawn(class'UIPersonnel_ListItem_SquadSelect_LWOfficerPack', m_kList.itemContainer);
		SoldierRef = CurrentData[m_kList.itemCount];
		kItem.InitListItem(SoldierRef);
		kItem.SetDisabled(!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M2_WelcomeToArmory') && (SoldierRef != HQState.TutorialSoldier));
	}
}

//override to use custom extension of UIPersonnel_ListItem in order to display custom status for officers
// calling this function will add items sequentially, the next item loads when the previous one is initialized
simulated function PopulateListSequentially( UIPanel Control )
{
	local UIPersonnel_ListItem kItem;
	local array<StateObjectReference> CurrentData;

	CurrentData = GetCurrentData();

	if(m_kList.itemCount < CurrentData.Length)
	{
		kItem = Spawn(class'UIPersonnel_ListItem_SquadSelect_LWOfficerPack', m_kList.itemContainer);
		kItem.InitListItem(CurrentData[m_kList.itemCount]);
		kItem.AddOnInitDelegate(PopulateListSequentially);
	}
}
