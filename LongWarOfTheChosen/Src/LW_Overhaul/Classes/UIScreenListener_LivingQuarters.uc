//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_LivingQuarters
//  AUTHOR:  Aminer / Pavonis Interactive
//
//  PURPOSE: Hooks the LivingQuarters to add additional room button(s)
//--------------------------------------------------------------------------------------- 

class UIScreenListener_LivingQuarters extends UIScreenListener deprecated;

var localized string m_strSquadSelection;

//DEPRECATED

// This event is triggered after a screen is initialized
//event OnInit(UIScreen Screen)
//{
	//local UIFacility_LivingQuarters LQScreen;
//
	//LQScreen = UIFacility_LivingQuarters(Screen);
	//LQScreen.AddFacilityButton(m_strSquadSelection, OnShowSquads);
//
//}

simulated function OnShowSquads()
{
	local UIPersonnel_SquadBarracks kPersonnelList;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	if (HQPres.ScreenStack.IsNotInStack(class'UIPersonnel_SquadBarracks'))
	{
		kPersonnelList = HQPres.Spawn(class'UIPersonnel_SquadBarracks', HQPres);
		kPersonnelList.onSelectedDelegate = OnPersonnelSelected;
		HQPres.ScreenStack.Push(kPersonnelList);
	}

}

simulated function OnPersonnelSelected(StateObjectReference selectedUnitRef)
{
	//add any logic here for selecting someone in the squad barracks
}

// This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen);

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIFacility_LivingQuarters;
}