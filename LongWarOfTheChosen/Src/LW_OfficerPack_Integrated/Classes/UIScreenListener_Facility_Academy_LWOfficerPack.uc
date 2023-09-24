//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Academy_StaffSlot_LWOfficerPack
//  AUTHOR:  Amineri
//  PURPOSE: Implements hooks to setup officer Staff Slot 
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Facility_Academy_LWOfficerPack extends UIScreenListener dependsOn(UIScreenListener_Facility);

//Tedster - none of these are actually used, yay

//var UIButton OfficerButton;
//var UIFacility_LWOfficerSlot Slot;
var localized string strOfficerTrainButton;
//var UIPersonnel PersonnelSelection;
//var XComGameState_StaffSlot StaffSlot;

event OnInit(UIScreen Screen)
{
	local int i, QueuedDropDown;
	local UIFacility_Academy ParentScreen;

	// Default is no dropdown
	QueuedDropDown = -1;

	ParentScreen = UIFacility_Academy(Screen);

	// Check for queued dropdown, and cache it if find one
	for (i = 0; i < ParentScreen.m_kStaffSlotContainer.StaffSlots.Length; i++)
	{
		if (ParentScreen.m_kStaffSlotContainer.StaffSlots[i].m_QueuedDropDown)
		{
			QueuedDropDown = i;
			break;
		}
	}

	ParentScreen.RealizeNavHelp();

	// Get rid of existing staff slots
	for (i = ParentScreen.m_kStaffSlotContainer.StaffSlots.Length-1; i >= 0; i--)
	{
		ParentScreen.m_kStaffSlotContainer.StaffSlots[i].Remove();
		ParentScreen.m_kStaffSlotContainer.StaffSlots[i].Destroy();
	}

	// Get rid of the existing staff slot container
	ParentScreen.m_kStaffSlotContainer.Hide();
	ParentScreen.m_kStaffSlotContainer.Destroy();

	// Create the new staff slot container that correctly handles the second soldier officer slot
	ParentScreen.m_kStaffSlotContainer = ParentScreen.Spawn(class'UIFacilityStaffContainer_LWOTS', ParentScreen);
	ParentScreen.m_kStaffSlotContainer.InitStaffContainer();
	ParentScreen.m_kStaffSlotContainer.SetMessage("");
	ParentScreen.RealizeStaffSlots();

	// Re-queue the dropdown if there was one
	if (QueuedDropDown >= 0)
	{
		ParentScreen.ClickStaffSlot(QueuedDropDown);
	}

	// KDM : UIScreenListener_Facility fixes the finicky UIFacility controller navigation system via OnInit(); however, its functions need 
	// to be called last, after the facility screen, including its navigation, has been setup. Since we can't determine screen listener 
	// ordering, make sure these functions are called last no matter what.
	if (`ISCONTROLLERACTIVE)
	{
		class'UIScreenListener_Facility'.static.ReconstructNavigationSystem(UIFacility(Screen));
		class'UIScreenListener_Facility'.static.PerformInitialSelection(UIFacility(Screen));
	}
}

event OnReceiveFocus(UIScreen Screen)
{
	UIFacility_Academy(Screen).m_kStaffSlotContainer.Show();
}

event OnLoseFocus(UIScreen Screen)
{
	UIFacility_Academy(Screen).m_kStaffSlotContainer.Hide();
}

event OnRemoved(UIScreen Screen)
{
	// KDM : I don't believe this needs to be left here as it does nothing; nonetheless, I will leave it here 'just in case'.
}

simulated function OnSoldierSelected(StateObjectReference _UnitRef)
{
	local UIArmory_LWOfficerPromotion OfficerScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;
	OfficerScreen = UIArmory_LWOfficerPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWOfficerPromotion', HQPres), HQPres.Get3DMovie()));
	OfficerScreen.InitPromotion(_UnitRef, false);
	OfficerScreen.CreateSoldierPawn();
}

defaultproperties
{
	ScreenClass = UIFacility_Academy;
}
