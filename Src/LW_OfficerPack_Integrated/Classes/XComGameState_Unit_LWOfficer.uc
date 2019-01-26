//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Unit_LWOfficer.uc
//  AUTHOR:  Amineri
//  PURPOSE: This is a component extension for Unit GameStates, containing 
//				additional data used for officers.
//---------------------------------------------------------------------------------------
class XComGameState_Unit_LWOfficer extends XComGameState_BaseObject config(LW_OfficerPack);

struct LeadershipEntry
{
	var StateObjectReference UnitRef;
	var int SuccessfulMissionCount;
};

var array<ClassAgnosticAbility>	OfficerAbilities;

var protected int OfficerRank;
var protected array<int> MissionsAtRank;
var protected int RankTraining;
var name AbilityTrainingName;
var name LastAbilityTrainedName;

var array<LeadershipEntry> LeadershipData;

function XComGameState_Unit_LWOfficer InitComponent()
{
	OfficerRank = 0;
	RegisterSoldierTacticalToStrategy();
	return self;
}

function bool SetRankTraining(int Rank, name AbilityName)
{
	if (CheckRank(Rank))
	{
		RankTraining = Rank;
		AbilityTrainingName = AbilityName;
		return true;
	} else {
		return false;
	}	
}

function bool HasOfficerAbility(name AbilityName)
{
	local ClassAgnosticAbility Ability;
	
	foreach OfficerAbilities(Ability)
	{
		if(Ability.AbilityType.AbilityName == AbilityName)
			return true;
	}
	return false;
}

function int GetOfficerRank()
{
	return OfficerRank;
}

function bool SetOfficerRank(int Rank)
{
	if (CheckRank(Rank))
	{
		OfficerRank = Rank;
		return true;
	} else {
		`Redscreen("LW Officer Pack: Attempting to set invalid officer Rank=" $ Rank);
		return false;
	}	
}

function int GetMissionCountAtRank(int Rank)
{
	if (!CheckRank(Rank)) 
	{
		return 0;
	} else {
		return MissionsAtRank[Rank];
	}
}

function int GetCurrentMissionCount()
{
	return GetMissionCountAtRank(GetOfficerRank());
}

function AddMission()
{
	if (GetOfficerRank() < 0) 
	{
		OfficerRank = 0;
	}
	//lazy instantiation to add to MissionsAtRank array
	if (CheckRank(GetOfficerRank()))
	{
		while (GetOfficerRank() >= MissionsAtRank.Length) 
		{
			MissionsAtRank.AddItem(0);
		}
	} 
	MissionsAtRank[GetOfficerRank()] += 1;

}

function bool CheckRank(int Rank)
{
	return class'LWOfficerUtilities'.static.CheckRank(Rank);
}

// ------------------ LEADERSHIP ------------------

// assumes that the Officer component is already added to supplied NewGameState
function AddSuccessfulMissionToLeaderShip(StateObjectReference UnitRef, XComGameState NewGameState, optional int Count = 1)
{
	local int idx;
	local LeadershipEntry Entry, EmptyEntry;
	local bool bFoundExistingUnit;

	foreach LeadershipData(Entry, idx)
	{
		if (Entry.UnitRef.ObjectID == UnitRef.ObjectID)
		{
			bFoundExistingUnit = true;
			break;
		}
	}
	if (bFoundExistingUnit)
	{
		LeadershipData[idx].SuccessfulMissionCount += Count;
	}
	else
	{
		Entry = EmptyEntry;
		Entry.UnitRef = UnitRef;
		Entry.SuccessfulMissionCount = Count;
		LeadershipData.AddItem(Entry);
	}
}

function array<LeadershipEntry> GetLeadershipData_MissionSorted()
{
	local array<LeadershipEntry> ReturnArray;

	ReturnArray = LeadershipData;
	ReturnArray.Sort (class'LWOfficerUtilities'.static.LeadershipMissionSort);

	return ReturnArray;
}

// ---------------------------------------------------------

function RegisterSoldierTacticalToStrategy()
{
	local Object ThisObj;
	
	ThisObj = self;

	//this should function for SimCombat as well
	`XEVENTMGR.RegisterForEvent(ThisObj, 'SoldierTacticalToStrategy', OnSoldierTacticalToStrategy, ELD_OnStateSubmitted,,, true);
}

simulated function EventListenerReturn OnSoldierTacticalToStrategy(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComGameState_Unit Unit;
	local XComGameState_Unit_LWOfficer OfficerState;

	Unit = XComGameState_Unit(EventData);

	//check we have the right unit
	if(Unit.ObjectID != OwningObjectID)
		return ELR_NoInterrupt;

	//find officer state component for change state on unit
	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);
	if (OfficerState == none) 
	{
		//`Redscreen("Failed to find Officer State Component when updating officer mission count : SoldierTacticalToStrategy");
		return ELR_NoInterrupt;
	}

	//create gamestate delta for officer component
	OfficerState = XComGameState_Unit_LWOfficer(GameState.CreateStateObject(class'XComGameState_Unit_LWOfficer', OfficerState.ObjectID));

	//Add +1 mission complete to current officer data
	OfficerState.AddMission();

	//add officer component gamestate delta to change container from triggered event 
	GameState.AddStateObject(OfficerState);

	return ELR_NoInterrupt;
}
