//---------------------------------------------------------------------------------------
//	FILE:    UIScreenListener_Facility
//	AUTHOR:  Keith (KDM)
//	PURPOSE: Controller navigation, for UIFacilities, acts quite strangely at times. Here are just a few examples :
//	1.] If the rightmost staff slot is selected, and you hit D-Pad right, suddenly the room button, if one exists, becomes selected.
//	It would be better if selection looped within the staff slot container.
//	2.] If you press the left or right bumper, the Avenger shortcuts, at the bottom of the screen, become selected. At this point, D-Pad
//	down selects the room button, and D-Pad up does nothing.
//	3.] If you press right bumper --> D-Pad right --> D-Pad right, navigation becomes temporarily stuck on the 1st staff slot.
//	4.] If you press right bumper --> D-Pad right --> D-Pad left, there are suddenly 2 highlighted staff slots.
//	5.] Etc. Etc.
//
//	The solution : Kill the finicky navigation system and create it anew; this way we have complete control over its setup.
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Facility extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIFacility FacilityScreen;

	// KDM : We are only concerned with UIFacility and its subclasses.
	if (`ISCONTROLLERACTIVE && Screen.IsA('UIFacility'))
	{
		FacilityScreen = UIFacility(Screen);
		ReconstructNavigationSystem(FacilityScreen);
		PerformInitialSelection(FacilityScreen);
	}
}

// KDM : A facility, represented by UIFacility, can contain up to 1 staff slot container, and up to 1 room container.
// 1.] The staff slot container, located on the top of the screen, stores all of the staff slots; typically a facility has between 1 and 4 staff slots.
// 2.] The room container, near the bottom of the screen, stores the room buttons; typically a facility has either 0 or 1 room buttons.
//
// For example, the base XCom 2 Guerilla Tactics School has 1 staff slot container which contains 1 staff slot; this staff slot is used to
// 'Train Rookies'. Furthermore, the facility has 1 room container containing 1 room button labelled 'New Combat Tactics'.
static function ReconstructNavigationSystem(UIFacility FacilityScreen)
{
	local bool StaffSlotContainerIsUsable;
	local UIRoomContainer RoomContainer;
	local UIStaffContainer StaffSlotContainer;

	if (FacilityScreen == none)
	{
		return;
	}

	RoomContainer = FacilityScreen.m_kRoomContainer;
	StaffSlotContainer = FacilityScreen.m_kStaffSlotContainer;
	// KDM : If a staff slot container has no staff slots it should not be dealt with.
	StaffSlotContainerIsUsable = (StaffSlotContainer != none && StaffSlotContainer.NumChildren() > 0) ? true : false;
	
	// KDM : The UIFacility screen should ignore D-Pad left/right; its subcomponents will deal with them. 
	FacilityScreen.Navigator.HorizontalNavigation = false;

	// KDM : Remove all focus, just in case any existed beforehand.
	FacilityScreen.Navigator.ClearSelectionHierarchy();
	// KDM : Remove all navigable controls.
	FacilityScreen.Navigator.Clear();
	// KDM : Remove all navigation targets.
	FacilityScreen.Navigator.ClearAllNavigationTargets();
	
	if (StaffSlotContainerIsUsable)
	{
		// KDM : The staff slot container should navigate via D-Pad left/right, since its staff slots are positioned horizontally.
		StaffSlotContainer.Navigator.HorizontalNavigation = true;
		// KDM : Staff slot selection should loop; this also prevents the facility screen from transferring selection from the staff
		// slots to the room button via D-Pad left/right.
		StaffSlotContainer.Navigator.LoopSelection = true;
		// KDM : When the staff slot container is selected, selection should automatically cascade down to the 1st selectable staff slot.
		// If this isn't done, strange situations occur whereby the staff slot container is selected, but no staff slot is selected.
		StaffSlotContainer.bCascadeSelection = true;

		// KDM : Remove all focus, just in case any existed beforehand.
		StaffSlotContainer.Navigator.ClearSelectionHierarchy();
		// KDM : Remove all navigation targets.
		StaffSlotContainer.Navigator.ClearAllNavigationTargets();
		// KDM : We don't call StaffSlotContainer.Navigator.Clear() because staff slots have already been added, as navigable controls, to
		// the staff slot container, and we don't want to undo this.
		
		FacilityScreen.Navigator.AddControl(StaffSlotContainer);
		if (RoomContainer != none)
		{
			// KDM : If the staff slot container is selected, and you hit D-Pad down, select the room button container below it.
			StaffSlotContainer.Navigator.AddNavTargetDown(RoomContainer);
		}
	}

	if (RoomContainer != none)
	{
		// KDM : Remove all focus, just in case any existed beforehand.
		RoomContainer.Navigator.ClearSelectionHierarchy();
		// KDM : Remove all navigation targets.
		RoomContainer.Navigator.ClearAllNavigationTargets();
		// KDM : We don't call RoomContainer.Navigator.Clear() because we want the room container's navigable controls, which have already
		// been setup, to remain unaltered.
		
		FacilityScreen.Navigator.AddControl(RoomContainer);
		if (StaffSlotContainerIsUsable)
		{
			// KDM : If the room button container is selected, and you hit D-Pad up, select the staff slot container above it.
			RoomContainer.Navigator.AddNavTargetUp(StaffSlotContainer);
		}
	}

	// KDM : When you hit the left and right bumper buttons, the navigation system moves down to the Avenger shortcut bar. 
	// We want to be able to escape the shortcut bar, and move back to the facility's buttons, with the D-Pad; however, this escape
	// depends upon 1.] which UI elements are available 2.] whether D-Pad up or D-Pad down was pressed.
	
	// KDM : If D-Pad up is pressed, favour the room container since it is just above the Avenger shortcuts.
	if (RoomContainer != none)
	{
		FacilityScreen.Navigator.AddNavTargetUp(RoomContainer);
	}
	else if (StaffSlotContainerIsUsable)
	{
		FacilityScreen.Navigator.AddNavTargetUp(StaffSlotContainer);
	}

	// KDM : If D-Pad down is pressed, favour the staff slot container since it is just below the Avenger shortcuts in a looping,
	// bottom of the screen to top of the screen, sense.
	if (StaffSlotContainerIsUsable)
	{
		FacilityScreen.Navigator.AddNavTargetDown(StaffSlotContainer);
	}
	else if (RoomContainer != none)
	{
		FacilityScreen.Navigator.AddNavTargetDown(RoomContainer);
	}
}

static function PerformInitialSelection(UIFacility FacilityScreen)
{
	local bool StaffSlotContainerIsUsable;
	local UIRoomContainer RoomContainer;
	local UIStaffContainer StaffSlotContainer;

	if (FacilityScreen == none)
	{
		return;
	}

	RoomContainer = FacilityScreen.m_kRoomContainer;
	StaffSlotContainer = FacilityScreen.m_kStaffSlotContainer;
	StaffSlotContainerIsUsable = (StaffSlotContainer != none && StaffSlotContainer.NumChildren() > 0) ? true : false;

	// KDM : If the staff slot container exists, and has at least 1 staff slot, select the 1st available staff slot.
	if (StaffSlotContainerIsUsable)
	{
		FacilityScreen.Navigator.SetSelected(StaffSlotContainer);
	}
	// KDM : If the room container exists, then select it.
	else if (RoomContainer != none)
	{
		FacilityScreen.Navigator.SetSelected(RoomContainer);
	}
}

defaultproperties
{
	// KDM : This is being left empty so we are able to listen to all subclasses of UIFacility.
}
