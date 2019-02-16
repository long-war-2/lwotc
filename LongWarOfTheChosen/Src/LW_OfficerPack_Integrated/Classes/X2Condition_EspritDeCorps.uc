//--------------------------------------------------------------------------------------- 
//  FILE:    X2Condition_EspritdeCorps
//  AUTHOR:  JL (Pavonis Interactive)
//  PURPOSE: Adds a check for leader-soldier history, depcreated
//---------------------------------------------------------------------------------------
class X2Condition_EspritDeCorps extends X2Condition Deprecated;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local array<LeadershipEntry> LeadershipHistory;
	local XComGameState_Unit SoldierUnit, OfficerUnit;
	local XComGameState_Unit_LWOfficer OfficerState, SecondOfficer;
	local int k;

	OfficerUnit = XComGameState_Unit (kSource);

	//`LOG ("EDC 0");

	if (OfficerUnit == none)
		return 'AA_NotAUnit';
	
	//`LOG ("EDC 1");
		
	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(OfficerUnit);
	SoldierUnit = XComGameState_Unit (kTarget);
	SecondOfficer = class'LWOfficerUtilities'.static.GetOfficerComponent(OfficerUnit);

	// if shooter not an officer
	if (OfficerState == none)
		return 'AA_AbilityUnavailable';

	//`LOG ("EDC 2");

	// if target not a soldier
	if (SoldierUnit == none)
		return 'AA_AbilityUnavailable';

	//`LOG ("EDC 3");

	// if shooter is not the boss officer
	if (!class'LWOfficerUtilities'.static.IsHighestRankOfficerInSquad(OfficerUnit))
		return 'AA_AbilityUnavailable';
	
	//`LOG ("EDC 4");

	// can't provide to self
	if (kSource.GetReference() == kTarget.GetReference())
		return 'AA_AbilityUnavailable';

	//`LOG ("EDC 5");

	// can't provide to other officers
	if (SecondOfficer != none)
		return 'AA_AbilityUnavailable';

	//`LOG ("EDC 6");

	LeadershipHistory = OfficerState.GetLeadershipData_MissionSorted();
	for (k = 0; k < LeadershipHistory.length; k++)
	{
		if (LeadershipHistory[k].UnitRef == SoldierUnit.GetReference())
		{
			if (LeadershipHistory[k].SuccessfulMissionCount > 0)
			{
				//`LOG ("X2C_EDC Passed for" @ SoldierUnit.GetLastName());
				return 'AA_Success';
			}
		}
	}

	return 'AA_AbilityUnavailable';
}


