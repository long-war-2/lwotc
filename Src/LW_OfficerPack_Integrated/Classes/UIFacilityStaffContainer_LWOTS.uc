//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIFacilityStaffContainer_LWTS.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Staff container override for LW Officer Staff Slot. 
//----------------------------------------------------------------------------

class UIFacilityStaffContainer_LWOTS extends UIFacilityStaffContainer;

simulated function UIStaffContainer InitStaffContainer(optional name InitName, optional string NewTitle = DefaultStaffTitle)
{
	return super.InitStaffContainer(InitName, NewTitle);
}

simulated function Refresh(StateObjectReference LocationRef, delegate<UIStaffSlot.OnStaffUpdated> onStaffUpdatedDelegate)
{
	local int i;
	local XComGameState_StaffSlot StaffSlot;
	local bool bSlotVisible;
	local XComGameState_FacilityXCom Facility;

	Facility = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(LocationRef.ObjectID));

	if (Facility.StaffSlots.Length == 0 || Facility.GetMyTemplate().bHideStaffSlots)
	{
		//Hide the box for facilities without any staffers, like the Armory, or for any facilities which have them permanently hidden. 
		Hide();
	}
	else 
	{
		// Show or create slots for the currently requested facility
		for (i = 0; i < Facility.StaffSlots.Length; i++)
		{
			// If the staff slot is locked and no upgrades are available, do not initialize or show the staff slot
			StaffSlot = Facility.GetStaffSlot(i);
			if ((StaffSlot.IsLocked() && !Facility.CanUpgrade()) || StaffSlot.IsHidden())
				continue;
			else
				bSlotVisible = true;

			if (i < StaffSlots.Length)
				StaffSlots[i].UpdateData();
			else
			{
				switch (Movie.Stack.GetCurrentClass())
				{
				case class'UIFacility_Academy':
					if (i == 0 || i == 1)
					{
						StaffSlots.AddItem(Spawn(class'UIFacility_AcademySlot', self).InitStaffSlot(self, LocationRef, i, onStaffUpdatedDelegate));
					} 
					else if (i == 2 || i == 3)
					{
						StaffSlots.AddItem(Spawn(class'UIFacility_LWOfficerSlot', self).InitStaffSlot(self, LocationRef, i, onStaffUpdatedDelegate));
					}
					break;
				default:
					StaffSlots.AddItem(Spawn(class'UIFacility_StaffSlot', self).InitStaffSlot(self, LocationRef, i, onStaffUpdatedDelegate));
					break;
				}
			}
		}
		if (bSlotVisible) // Show the container only if at least one slot is visible
			Show();
		else
			Hide();
	}
}

defaultproperties
{
}
