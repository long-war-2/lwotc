//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Academy_StaffSlot_LWOfficerPack
//  AUTHOR:  Amineri
//
//  PURPOSE: Implements hooks to setup officer Staff Slot 
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Facility_Academy_LWOfficerPack extends UIScreenListener;

var UIButton OfficerButton;
//var UIFacility_Academy ParentScreen;
var UIFacility_LWOfficerSlot Slot;
var localized string strOfficerTrainButton;
var UIPersonnel PersonnelSelection;
var XComGameState_StaffSlot StaffSlot;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local int i, QueuedDropDown;
	local UIFacility_Academy ParentScreen;

	//default is no dropdown
	QueuedDropDown = -1;

	ParentScreen = UIFacility_Academy(Screen);

	//check for queued dropdown, and cache it if find one
	for(i = 0; i < ParentScreen.m_kStaffSlotContainer.StaffSlots.Length; i++)
	{
		if(ParentScreen.m_kStaffSlotContainer.StaffSlots[i].m_QueuedDropDown)
		{
			QueuedDropDown = i;
			break;
		}
	}

	//update template and facility as needed
	//`Log("LW OfficerPack: AcademyListener Start");
	//class'X2DownloadableContentInfo_LWOfficerPack'.static.OnLoadedSavedGame();
	ParentScreen.RealizeNavHelp();

	//UpdateStaffSlots();

	//Get rid of existing staff slots
	for(i = ParentScreen.m_kStaffSlotContainer.StaffSlots.Length-1; i >= 0; i--)
	{
		ParentScreen.m_kStaffSlotContainer.StaffSlots[i].Remove();
		ParentScreen.m_kStaffSlotContainer.StaffSlots[i].Destroy();
	}

	//Get rid of the existing staff slot container
	ParentScreen.m_kStaffSlotContainer.Hide();
	//ParentScreen.m_kStaffSlotContainer.Remove();
	ParentScreen.m_kStaffSlotContainer.Destroy();

	//Create the new staff slot container that correctly handles the second soldier officer slot
	ParentScreen.m_kStaffSlotContainer = ParentScreen.Spawn(class'UIFacilityStaffContainer_LWOTS', ParentScreen);
	ParentScreen.m_kStaffSlotContainer.InitStaffContainer();
	ParentScreen.m_kStaffSlotContainer.SetMessage("");
	ParentScreen.RealizeStaffSlots();

	//re-queue the dropdown if there was one
	if(QueuedDropDown >= 0)
	{
		//if (ParentScreen.m_kStaffSlotContainer != none)
		//{
			//UIFacility_StaffSlot(ParentScreen.m_kStaffSlotContainer.GetChildAt(QueuedDropDown)).OnClickStaffSlot(none, class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
		//}

		ParentScreen.ClickStaffSlot(QueuedDropDown);
	}
}


// This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen)
{
	//UpdateStaffSlots();
	UIFacility_Academy(Screen).m_kStaffSlotContainer.Show();
}
// This event is triggered after a screen loses focus
event OnLoseFocus(UIScreen Screen)
{
	//UpdateStaffSlots();
	UIFacility_Academy(Screen).m_kStaffSlotContainer.Hide();
}

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen)
{
	//clear reference to UIScreen so it can be garbage collected
	//ParentScreen = none;
}

//function UpdateStaffSlots()
//{
	//local int i;
	//local XComGameState_FacilityXCom Facility;
//
	//Facility = ParentScreen.GetFacility();
	//`log("LW Officer Pack: Facility Template instantiated=" $ Facility.GetMyTemplateName());
//
	////currently only retrieves first officer staffslot
	//for (i = 0; i < Facility.StaffSlots.Length; ++i)
	//{
		//StaffSlot = Facility.GetStaffSlot(i);
		//if (StaffSlot.GetMyTemplateName() == 'OTSOfficerSlot')
			//break;
	//}
//}

//function AddFloatingButton()
//{
	//OfficerButton = ParentScreen.Spawn(class'UIButton', ParentScreen.m_kStaffSlotContainer);
	//OfficerButton.InitButton('', Caps(strOfficerTrainButton), OnButtonCallback, eUIButtonStyle_HOTLINK_BUTTON);
	////OfficerButton.AnchorBottomCenter();
	//OfficerButton.OriginTopLeft();
	//OfficerButton.SetResizeToText(false);
	//OfficerButton.SetFontSize(24);
	//OfficerButton.SetPosition(10, 100);
	//OfficerButton.SetSize(280, 40);
	//OfficerButton.Show();
//}

//simulated function OnButtonCallback(UIButton kButton)
//{
	//local UIPersonnel_LWOfficer kPersonnelList;
	//local XComHQPresentationLayer HQPres;
//
	//HQPres = `HQPRES;
	//
	////Don't allow clicking of Personnel List is active or if staffslot is filled
	//if(HQPres.ScreenStack.IsNotInStack(class'UIPersonnel') && !StaffSlot.IsSlotFilled())
	//{
		//kPersonnelList = HQPres.Spawn( class'UIPersonnel_LWOfficer', HQPres);
		//kPersonnelList.m_eListType = eUIPersonnel_Soldiers;
		//kPersonnelList.onSelectedDelegate = OnSoldierSelected;
		//kPersonnelList.m_bRemoveWhenUnitSelected = true;
		//kPersonnelList.SlotRef = StaffSlot.GetReference();
		//HQPres.ScreenStack.Push( kPersonnelList );
	//}
//}

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
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIFacility_Academy;
}