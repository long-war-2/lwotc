//---------------------------------------------------------------------------------------
//  FILE:    LWOfficerUtilities.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This container holds config, localization, and utility code for the LW officer system
//           
//---------------------------------------------------------------------------------------
class LWOfficerUtilities extends Object config(LW_OfficerPack) dependson(XComGameState_Unit_LWOfficer);

struct OfficerAbilityConfig
{
	var int Rank;
	var name AbilityName;
};

///////////////////////////////
// Ability tree
var config array<OfficerAbilityConfig> OfficerAbilityTree;

///////////////////////////////
// Content 

var protected config array<string> LWOfficerRankIcons;			//imagepaths to rank icons -- img:/// part not part of config file
var protected config string LWOfficerGenericIcon;				//imagepath to generic officer icon

///////////////////////////////
// Config 

var protected config array<int> MissionsPerOfficerRank;			//  the number of missions soldier must undertake at each officer rank to progress to the nex
var protected config array<int> RequiredRankPerOfficerRank;		//  the minimum regular soldier rank required for each officer rank
var protected config array<float> TrainingDaysForRank;			// number of days required to train each rank
var config int MaxOfficerRank;

///////////////////////////////
// Localization 

var protected localized array<string> LWOfficerRankNames;       //  there should be one name for each rank; e.g. Rookie, Squaddie, etc.
var protected localized array<string> LWOfficerShortNames;      //  the abbreviated rank name; e.g. Rk., Sq., etc.

///////////////////////////////
// Accessor and helper functions

// Number of days required to train to a the supplied rank
static function float GetOfficerTrainingDays(int NewRank)
{
	if (CheckRank(NewRank))
		return default.TrainingDaysForRank[NewRank];
	return 0.0;
}

// Returns the number of current officers in the roster
static function int GetNumOfficers()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local array<XComGameState_Unit> Soldiers;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Soldiers = XComHQ.GetSoldiers();
	return GetNumOfficersFromList(Soldiers);
}

// Returns the number of officers in the supplied list
static function int GetNumOfficersFromList(array<XComGameState_Unit> SoldierList)
{
	local XComGameState_Unit Unit;
	local int OfficerCount;
	local XComGameState_Unit_LWOfficer OfficerComp;
	OfficerCount = 0;

	foreach SoldierList(Unit)
	{
		OfficerComp = GetOfficerComponent(Unit);
		if (OfficerComp != none)
		{
			if (OfficerComp.GetOfficerRank() > 0)
			{
				OfficerCount++;
			}
		}
	}
	return OfficerCount;
}

static function int GetHighestOfficerRank()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local array<XComGameState_Unit> Soldiers;
	local int HighestOfficerRank;
	local XComGameState_Unit Unit;
	local XComGameState_Unit_LWOfficer OfficerComp;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	Soldiers = XComHQ.GetSoldiers();

	HighestOfficerRank = 0;

	foreach Soldiers(Unit)
	{
		OfficerComp = GetOfficerComponent(Unit);
		if (OfficerComp != none)
		{
			if (OfficerComp.GetOfficerRank() > HighestOfficerRank)
			{
				HighestOfficerRank = OfficerComp.GetOfficerRank();
			}
		}
	}
	return HighestOfficerRank;
}

//checks if a unit has any officer abilities
static function bool IsOfficer(XComGameState_Unit Unit)
{
	local XComGameState_Unit_LWOfficer OfficerState;

	OfficerState = GetOfficerComponent(Unit);
	if (OfficerState == none) return false;
	if (OfficerState.GetOfficerRank() > 0) return true;
	return false;
}

static function bool HasOfficerInSquad(optional XComGameState_HeadquartersXCom XComHQ)
{
	//local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;

	if (XComHQ == none)
		XComHQ = `XCOMHQ;
	History = `XCOMHISTORY;

	foreach XComHQ.Squad(UnitRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
		if (UnitState != none)
		{
			if (class'LWOfficerUtilities'.static.IsOfficer(UnitState)) { return true;}
		}
	}
	return false;
}

static function bool IsHighestRankOfficerInSquad(XComGameState_Unit CheckUnit, optional XComGameState_HeadquartersXCom XComHQ)
{
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local XComGameState_Unit_LWOfficer OfficerState, CheckOfficer;

	if (XComHQ == none)
		XComHQ = `XCOMHQ;
	if (XComHQ == none)
		return false;

	History = `XCOMHISTORY;

	CheckOfficer = GetOfficerComponent(CheckUnit);
	if (CheckOfficer == none)
		return false;

	if(`TACTICALRULES != none) // if in tactical game, check to see if unit has one of the actual officer abilities (tactically), since some use-cases where a later deployed officer happens (e.g. Avenger Defense0
	{
		if (CheckUnit.FindAbility(GetAbilityName(0, 0)).ObjectID > 0) // this should generally be the command ability
			return true;
	}

	foreach XComHQ.Squad(UnitRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
		if (UnitState != none)
		{
			if (UnitState.ObjectID == CheckUnit.ObjectID)
			{
				continue;
			}
			OfficerState = GetOfficerComponent(UnitState);
			if (OfficerState != none)
			{
				if (OfficerState.GetOfficerRank() > CheckOfficer.GetOfficerRank()) // officer rank is higher
					return false;
				else if (OfficerState.GetOfficerRank() < CheckOfficer.GetOfficerRank())
					continue;

				if (UnitState.GetRank() > CheckUnit.GetRank())  // regular rank is higher
					return false;
				else if (UnitState.GetRank() < CheckUnit.GetRank())
					continue;

				if (UnitState.GetCurrentStat(eStat_Will) > CheckUnit.GetCurrentStat(eStat_Will))  // will is higher
					return false;
				else if (UnitState.GetCurrentStat(eStat_Will) < CheckUnit.GetCurrentStat(eStat_Will))
					continue;

				if (UnitState.iNumMissions > CheckUnit.iNumMissions)  // been on more missions
					return false;
				else if (UnitState.iNumMissions < CheckUnit.iNumMissions)
					continue;

				if (UnitState.ObjectID < CheckUnit.ObjectID) // created earlier
					return false;
			}
		}
	}
	return true;	
}

//returns the best deployable soldier, with added restriction on no more than 1 officer per squad
static function XComGameState_Unit GetBestDeployableSoldier(XComGameState_HeadquartersXCom XComHQ, optional bool bDontIncludeSquad=false, optional bool bAllowWoundedSoldiers = false)
{
	local array<XComGameState_Unit> DeployableSoldiers;
	local int idx, HighestRank;
	local bool HasOfficer;

	HasOfficer = HasOfficerInSquad(XComHQ);

	DeployableSoldiers = XComHQ.GetDeployableSoldiers(bDontIncludeSquad, bAllowWoundedSoldiers);

	if(DeployableSoldiers.Length == 0)
	{
		return none;
	}

	HighestRank = 0;

	for(idx = 0; idx < DeployableSoldiers.Length; idx++)
	{
		if(DeployableSoldiers[idx].GetRank() > HighestRank)
		{
			if (!IsOfficer(DeployableSoldiers[idx]) || !HasOfficer)	
				HighestRank = DeployableSoldiers[idx].GetRank();
		}
	}

	//remove lower rank soldiers, and second officers (unless allowing wounded soldiers)
	for(idx = 0; idx < DeployableSoldiers.Length; idx++)
	{
		if((DeployableSoldiers[idx].GetRank() < HighestRank) || (IsOfficer(DeployableSoldiers[idx]) && HasOfficer && !bAllowWoundedSoldiers))
		{
			DeployableSoldiers.Remove(idx, 1);
			idx--;
		}
	}

	return (DeployableSoldiers[`SYNC_RAND_STATIC(DeployableSoldiers.Length)]);
}

// Returns the officer component attached to the supplied Unit GameState
static function XComGameState_Unit_LWOfficer GetOfficerComponent(XComGameState_Unit Unit)
{
	if (Unit != none) 
		return XComGameState_Unit_LWOfficer(Unit.FindComponentObject(class'XComGameState_Unit_LWOfficer'));
	return none;
}

// Returns the name of the ability at the given rank/option in the Officer Ability tree
static function name GetAbilityName(const int Rank, const int Option)
{
	local OfficerAbilityConfig ab;
	local int count;

	count = 0;
	foreach default.OfficerAbilityTree(ab)
	{
		if (ab.Rank == Rank) 
		{
			if (count == Option)
			{
				return ab.AbilityName;
			} else {
				count++;
			}
		}
	}
	return '';
}

//Returns the path to the Officer rank icon of the given rank
static function string GetRankIcon(const int Rank)
{
	if (ValidateRank(Rank))
		return "img:///" $ default.LWOfficerRankIcons[Rank];
	return "none";
}

//Returns the path to the generic Officer icon
static function string GetGenericIcon()
{
	return "img:///" $ default.LWOfficerGenericIcon;
}


//Returns the localized string rank name of the given rank
static function string GetLWOfficerRankName(const int Rank)
{
	if (ValidateRank(Rank))
		return default.LWOfficerRankNames[Rank];
	return "none";
}

//Returns the short version of the localized string name of the given rank
static function string GetLWOfficerShortRankName(const int Rank)
{
	if (ValidateRank(Rank))
		return default.LWOfficerShortNames[Rank];
	return "none";
}

//Returns the regular rank (non-officer) required to train a given officer rank 
static function int GetRequiredRegularRank(const int Rank)
{
	if (ValidateRank(Rank))
		return default.RequiredRankPerOfficerRank[Rank];
	return 0;
}

//Returns the number of missions required to train a given officer rank
static function int GetRequiredMissions(const int Rank)
{
	if (ValidateRank(Rank))
		return default.MissionsPerOfficerRank[Rank];
	return 1;
}

//Returns the maximum possible officer rank
static function int GetMaxRank()
{
	`Log("LW Officer Pack : Max Rank =" @ string(default.RequiredRankPerOfficerRank.Length-1));
	`Log("LW Officer Pack : Max Required Rank =" @ string(default.RequiredRankPerOfficerRank[default.RequiredRankPerOfficerRank.Length-1]));
	return default.RequiredRankPerOfficerRank.Length-1;
}

static function bool ValidateRank(const int Rank)
{
	if (!CheckRank(Rank))
	{
		`RedScreen("LW OfficerPack : OfficerRank" @ Rank @ "is out of bounds for regular ranks (" $ Rank $ "/" $ default.MaxOfficerRank $ ")\n" $ GetScriptTrace());
		return false;
	} 
	return true;
}

//Validation check that Rank is within required bounds
static function bool CheckRank(const int Rank)
{
	if (Rank < 0 || Rank > default.MaxOfficerRank)
	{
		return false;
	}
	return true;
}

//requires that the UpdateUnitState have already been added to the supplied NewGameState
static function XComGameState_Unit AddInitialAbilities(XComGameState_Unit UpdatedUnit, XComGameState_Unit_LWOfficer OfficerState, XComGameState NewGameState)
{
	local int i;
	local SoldierClassAbilityType StarterAbility;
	local ClassAgnosticAbility NewStarterAbility;

	// Add all rank 0 abilities to newly promoted officer
	if (OfficerState.GetOfficerRank() == 1)
	{
		for (i=0; i < default.OfficerAbilityTree.Length; ++i)
		{
			if (default.OfficerAbilityTree[i].Rank == 0)
			{
				StarterAbility.AbilityName = class'LWOfficerUtilities'.default.OfficerAbilityTree[i].AbilityName;
				StarterAbility.ApplyToWeaponSlot = eInvSlot_Unknown;
				StarterAbility.UtilityCat = '';
				NewStarterAbility.AbilityType = StarterAbility;
				NewStarterAbility.iRank = 0;
				NewStarterAbility.bUnlocked = true;
				OfficerState.OfficerAbilities.AddItem(NewStarterAbility);
			}
		}
	}
	return UpdatedUnit;
}

static function GCandValidationChecks()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState, UpdatedUnit;
	local XComGameState_Unit_LWOfficer OfficerState, UpdatedOfficer;
	//local XComGameState_HeadquartersProjectTrainLWOfficer TrainOfficerState;

	`LOG("LWOfficerUtilities: Starting Garbage Collection and Validation.");

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Officer States cleanup");
	foreach History.IterateByClassType(class'XComGameState_Unit_LWOfficer', OfficerState,,true)
	{
		`LOG("LWOfficerUtilities: Found OfficerState, OwningObjectID=" $ OfficerState.OwningObjectId $ ", Deleted=" $ OfficerState.bRemoved);
		//check and see if the OwningObject is still alive and exists
		if(OfficerState.OwningObjectId > 0)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(OfficerState.OwningObjectID));
			if(UnitState == none)
			{
				`LOG("LWOfficerUtilities: Officer Component has no current owning unit, cleaning up state.");
				// Remove disconnected officer state
				NewGameState.RemoveStateObject(OfficerState.ObjectID);
			}
			else
			{
				`LOG("LWOfficerUtilities: Found Owning Unit=" $ UnitState.GetFullName() $ ", Deleted=" $ UnitState.bRemoved);
				if(UnitState.bRemoved)
				{
					`LOG("LWOfficerUtilities: Owning Unit was removed, Removing and unlinking OfficerState");
					UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
					UpdatedOfficer = XComGameState_Unit_LWOfficer(NewGameState.CreateStateObject(class'XComGameState_Unit_LWOfficer', OfficerState.ObjectID));
					NewGameState.RemoveStateObject(UpdatedOfficer.ObjectID);
					UpdatedUnit.RemoveComponentObject(UpdatedOfficer);
					NewGameState.AddStateObject(UpdatedOfficer);
					NewGameState.AddStateObject(UpdatedUnit);
				}
			}
		}
	}
	//foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectTrainLWOfficer', TrainOfficerState,,true)
	//{
		////check and see if the OwningObject is still alive and exists
		//`LOG("LWOfficerUtilities: Found TrainOfficerState, ObjectID=" $  TrainOfficerState.ObjectId);
	//}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

// ------------------ LEADERSHIP ------------------

// returns the array of officers that have leadership data for the given unit, sorted by number of missions together
static function array<LeadershipEntry> GetOfficerLeadershipData_MissionSorted(StateObjectReference UnitRef)
{
	local array<LeadershipEntry> ReturnArray;

	ReturnArray = GetOfficerLeadershipData(UnitRef);
	ReturnArray.Sort(LeadershipMissionSort);

	return ReturnArray;
}

// returns the array of officers that have leadership data for the given unit
static function array<LeadershipEntry> GetOfficerLeadershipData(StateObjectReference UnitRef)
{
	local array<LeadershipEntry> ReturnArray;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit_LWOfficer OfficerState;
	local int idx;
	local LeadershipEntry Entry, EmptyEntry;

	History = `XCOMHISTORY;
	
	`LOG ("Getting Officer Leadership Data");

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.IsDead()) { continue; }
		if (UnitState.bCaptured) {continue; }
		OfficerState = GetOfficerComponent(UnitState);
		if (OfficerState == none) { continue; }
		idx = OfficerState.LeadershipData.Find('UnitRef', UnitRef);
		if (idx != -1 )
		{
			Entry = EmptyEntry;
			Entry.UnitRef = UnitState.GetReference();
			Entry.SuccessfulMissionCount = OfficerState.LeadershipData[idx].SuccessfulMissionCount;
			`LOG ("Found: SMC" @ string(Entry.SuccessfulMissionCount));
			ReturnArray.AddItem(Entry);
		}
	}

	return ReturnArray;
}

// this is designed to return the value for a unit in tactical combat it has no meaning in strategy, since there is no default officer
static function int GetTacticalLeadershipSuccessfulMission(StateObjectReference CheckUnitRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference UnitRef, CommandingRef;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit_LWOfficer OfficerState;
	local int idx;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	// get commanding officer

	//`LOG ("GetTacticalLeadershipSuccessfulMission firing");

	foreach XComHQ.Squad(UnitRef)
	{
		if (UnitRef.ObjectID == 0) { continue; }

		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
		if (UnitState == none) { continue; }

		if (class'LWOfficerUtilities'.static.IsHighestRankOfficerInSquad(UnitState, XComHQ))
		{
			OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);
			if (OfficerState != none)
			{
				CommandingRef = UnitRef;
				break;
			}
		}
	}
	if (CommandingRef.ObjectID == UnitRef.ObjectID) { return 0; }

	idx = OfficerState.LeadershipData.Find('UnitRef', CheckUnitRef);
	if (idx != -1 )
	{
		//`LOG ("GetTacticalLeadershipSuccessfulMission firing 2" @ string (OfficerState.LeadershipData[idx].SuccessfulMissionCount));
		return OfficerState.LeadershipData[idx].SuccessfulMissionCount;

	}

	return 0;
}

static function int LeadershipMissionSort(LeadershipEntry EntryA, LeadershipEntry EntryB)
{
	local int Result;
	local XComGameStateHistory History;
	local XComGameState_Unit UnitA, UnitB;
	local string NameA, NameB;

	// 1) Sort by missions
	Result = EntryA.SuccessfulMissionCount - EntryB.SuccessfulMissionCount;
	if (Result != 0) { return Result; }

	History = `XCOMHISTORY;
	UnitA = XComGameState_Unit(History.GetGameStateForObjectID(EntryA.UnitRef.ObjectID));
	UnitB = XComGameState_Unit(History.GetGameStateForObjectID(EntryB.UnitRef.ObjectID));

	// 2) Sort by rank
	Result = UnitA.GetRank() - UnitB.GetRank();
	if (Result != 0) { return Result; }

	// 3) Sort by class name
	NameA = UnitA.GetSoldierClassTemplate().DisplayName;
	NameB = UnitB.GetSoldierClassTemplate().DisplayName;
	if( NameA < NameB )
	{
		Result = 1;
	}
	else if( NameA > NameB )
	{
		Result = -1;
	}
	if (Result != 0) { return Result; }

	// 4) Sort by soldier name
	NameA = UnitA.GetName(eNameType_Last);
	NameB = UnitB.GetName(eNameType_Last);

	if( NameA < NameB )
	{
		Result = 1;
	}
	else if( NameA > NameB )
	{
		Result = -1;
	}
	else // Last names match, so sort by full name.
	{
		NameA = UnitA.GetName(eNameType_Full);
		NameB = UnitB.GetName(eNameType_Full);
		if( NameA < NameB )
		{
			Result = 1;
		}
		else if( NameA > NameB )
		{
			Result = -1;
		}
		else
		{
			Result = 0;
		}
	}

	return Result;
}


// ------------------------------------------------
