// IsMovableHavenLiaison accepts a movable haven advisor, and launching an infiltration empties their haven slot.
class X2TH_Test_HavenAdvisor extends X2TH_Test;

function Run()
{
	local XComGameState_LWOutpostManager Manager;
	local XComGameState_LWOutpost Outpost;
	local StateObjectReference Ref;
	local XComGameState_Unit Advisor;
	local XComGameState NewGameState;
	local XComGameState_StaffSlot Slot;

	Manager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	foreach Manager.Outposts(Ref)
	{
		Outpost = XComGameState_LWOutpost(`XCOMHISTORY.GetGameStateForObjectID(Ref.ObjectID));
		if (Outpost.HasLiaison() && Outpost.CanLiaisonBeMoved())
			Advisor = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Outpost.GetLiaison().ObjectID));
	}
	T.Check(Advisor != none, "save has a movable haven advisor");
	if (Advisor == none)
		return;

	T.Check(class'LWDLCHelpers'.static.IsMovableHavenLiaison(Advisor), "IsMovableHavenLiaison is true for a movable haven advisor");

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("X2TH haven advisor launch");
	Advisor = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Advisor.ObjectID));
	Slot = Advisor.GetStaffSlot();
	class'LWDLCHelpers'.static.SetOnMissionStatus(Advisor, NewGameState);
	Slot = XComGameState_StaffSlot(NewGameState.GetGameStateForObjectID(Slot.ObjectID));
	T.Check(Slot != none && Slot.GetAssignedStaffRef().ObjectID != Advisor.ObjectID, "SetOnMissionStatus empties the advisor's haven slot");
	`XCOMHISTORY.CleanupPendingGameState(NewGameState);
}
