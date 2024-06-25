//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWPersistentSquad.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This models a single persistent squad, which can be on Avenger or deploying to mission site
//---------------------------------------------------------------------------------------
class XComGameState_LWPersistentSquad extends XComGameState_GeoscapeEntity config(LW_InfiltrationSettings);

struct CategoryCovertnessContainer
{
	var name CategoryName;  // should match configured category from 
	var float CovertnessValue;
	var float CovertnessWeight;
};

struct EquipmentCovertnessContainer
{
	var name ItemName;
	var float CovertnessValue;
	var float CovertnessWeight;
	var float IndividualMultiplier;
};

struct AbilityCovertnessContainer
{
	var name AbilityName;
	var float IndividualMultiplier;
	var float SquadMultiplier;
};

struct InfiltrationModifier
{
	var float Infiltration;
	var float Modifier;
};

var array<StateObjectReference> SquadSoldiers; // Which soldiers make up the squad
var array<StateObjectReference> SquadSoldiersOnMission; // possibly different from SquadSoldiers due to injury, training, or being a temporary reserve replacement

var bool bOnMission;  // indicates the squad is currently deploying to a mission site
var bool bTemporary; // indicates that this squad is only for the current infiltration, and shouldn't be retained
var StateObjectReference CurrentMission; // the current mission being deployed to -- none if no mission
var float CurrentInfiltration; // the current infiltration progress against the mission
var float LastInfiltrationUpdate; // the infiltration value the last time the AlertnessModifier was updated
var int LastAlertIndex; // the last AlertIndex delivered
var int CurrentEnemyAlertnessModifier;  // the modifier to alertness based on the infiltration progress
var TDateTime StartInfiltrationDateTime; // the time when the current infiltration began
var bool bHasBoostedInfiltration; // indicates if the player has boosted infiltration for this squad
var bool bHasPausedAtIdealInfiltration; // DEPRECATED, but kept for backward compatibility -- indicated if the game has paused once at reaching ideal infiltration
var bool bCannotCancelAbort; // indicates the squad has been marked to abort their mission cannot continue it
var float SquadCovertnessCached; // cached value for Squad Covertness

var string sSquadName;  // auto-generated or user-customize squad name
var string SquadImagePath;  // option to set a Squad Image custom for this squad
var string sSquadBiography;  // a player-editable squad history
var int iNumMissions;  // automatically tracked squad mission counter

var localized array<string> DefaultSquadNames; // localizable array of default squadnames to choose from
var localized array<string> TempSquadNames; // localizable array of temporary squadnames to choose from

var localized string BackupSquadName;
var localized string BackupTempSquadName;

var config array<float> InfiltrationTime_BaselineHours;
var config array<float> InfiltrationTime_BlackSite;
var config array<float> InfiltrationTime_Forge;
var config array<float> InfiltrationTime_PsiGate;

var config float InfiltrationTime_MinHours;
var config float InfiltrationTime_MaxHours;
var config array<float> SquadSizeInfiltrationFactor;
var config float InfiltrationCovertness_Baseline;
var config float InfiltrationCovertness_RateUp;
var config float InfiltrationCovertness_RateDown;


var config float RequiredInfiltrationToLaunch;
var config array<float> DefaultBoostInfiltrationFactor;  // allows for boosting infiltration rate in various ways
var config array<int> DefaultBoostInfiltrationCost;

var config array<float> InfiltrationHaltPoints; // infiltration values at which the game will pause (or as soon as possible)
var array<bool> InfiltrationPointPassed; // recordings of when a particular point has been passed

var config float AlertnessUpdateInterval; // how often to reroll enemy "Alertness"/difficulty
var config float MeanAlertnessDeltaPerInterval; // how much the Alertness changes per infiltration interval
var config array<InfiltrationModifier> AlertModifierAtInfiltration;

var config array<CategoryCovertnessContainer> ItemCategoryCovertness;
var config array<CategoryCovertnessContainer> WeaponCategoryCovertness;
var config array<EquipmentCovertnessContainer> EquipmentCovertness;
var config array<AbilityCovertnessContainer> AbilityCovertness;

var config array<int> EvacDelayAtSquadSize;
var config array<InfiltrationModifier> EvacDelayAtInfiltration;
var config array<int> EvacDelayForInfiltratedMissions;

var config array<name> MissionsRequiring100Infiltration;
var config array<name> MissionsAffectedByLiberationStatus;

var config array<float> InfiltrationLiberationFactor; // multiplier for baseline infiltration factor based on region's liberation status

var config string DefaultSquadImagePath;

var config array<float> GTSInfiltration1Modifier;
var config array<float> GTSInfiltration2Modifier;

var config float EMPTY_UTILITY_SLOT_WEIGHT;

var config float LEADERSHIP_COVERTNESS_PER_MISSION;
var config float LEADERSHIP_COVERTNESS_CAP;

var config float SUPPRESSOR_INFILTRATION_EMPOWER_BONUS;
//---------------------------
// INIT ---------------------
//---------------------------

function XComGameState_LWPersistentSquad InitSquad(optional string sName = "", optional bool Temp = false)
{
	local TDateTime StartDate;
	local string DateString;
	local XGParamTag SquadBioTag;

	bTemporary = Temp;

	if(sName != "")
		sSquadName = sName;
	else
		if (bTemporary)
			sSquadName = GetUniqueRandomName(TempSquadNames, BackupTempSquadName);
		else
			sSquadName = GetUniqueRandomName(DefaultSquadNames, BackupSquadName);

	if (`GAME.GetGeoscape() != none)
	{
		DateString = class'X2StrategyGameRulesetDataStructures'.static.GetDateString(`GAME.GetGeoscape().m_kDateTime);
	}
	else
	{
	class'X2StrategyGameRulesetDataStructures'.static.SetTime(StartDate, 0, 0, 0, class'X2StrategyGameRulesetDataStructures'.default.START_MONTH,
															  class'X2StrategyGameRulesetDataStructures'.default.START_DAY, class'X2StrategyGameRulesetDataStructures'.default.START_YEAR);
		DateString = class'X2StrategyGameRulesetDataStructures'.static.GetDateString(StartDate);
	}

	SquadBioTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	SquadBioTag.StrValue0 = DateString;
	sSquadBiography = `XEXPAND.ExpandString(class'UIPersonnel_SquadBarracks'.default.strDefaultSquadBiography);

	SquadImagePath = class'UIPersonnel_SquadBarracks'.default.SquadImagePaths[Rand(class'UIPersonnel_SquadBarracks'.default.SquadImagePaths.Length)];

	return self;
}

function string GetUniqueRandomName(const array<string> NameList, string DefaultName)
{
	local XComGameStateHistory History;
	local XComGameState_LWSquadManager SquadMgr;
	local array<string> PossibleNames;
	local StateObjectReference SquadRef;
	local XComGameState_LWPersistentSquad SquadState;
	local XGParamTag SquadNameTag;

	History = `XCOMHISTORY;
	SquadMgr = class'XComGameState_LWSquadManager'.static.GetSquadManager();
	PossibleNames = NameList;
	foreach SquadMgr.Squads(SquadRef)
	{
		SquadState = XComGameState_LWPersistentSquad(History.GetGameStateForObjectID(SquadRef.ObjectID));
		if (SquadState == none)
			continue;

		PossibleNames.RemoveItem(SquadState.sSquadName);
	}

	if (PossibleNames.Length == 0)
	{
		SquadNameTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		SquadNameTag.StrValue0 = GetRightMost(string(self));
		return `XEXPAND.ExpandString(DefaultName);		
	}

	return PossibleNames[`SYNC_RAND(PossibleNames.Length)];
}

//---------------------------
// SOLDIER HANDLING ---------
//---------------------------

function bool UnitIsInSquad(StateObjectReference UnitRef)
{
	return SquadSoldiers.Find('ObjectID', UnitRef.ObjectID) != -1;
}

function bool UnitIsInSquadOnMission(StateObjectReference UnitRef)
{
	return SquadSoldiersOnMission.Find('ObjectID', UnitRef.ObjectID) != -1;
}

function XComGameState_Unit GetSoldier(int idx)
{
	if(idx >=0 && idx < SquadSoldiers.Length)
	{
		return XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(SquadSoldiers[idx].ObjectID));
	}
	return none;
}

// Is this soldier valid for a squad? Yes as long as they aren't dead or captured.
// This is often used to filter which units to display in a squad, as the unit list
// in a given squad is not always clean. For example, a mission might involve soldiers
// from a mix of squads as temporary additions to another squad, and if they die or
// are captured on mission the other squads are not necessarily cleaned up from the
// squad right away, but we don't want them to be listed in the squad or appear on any
// missions. A better long-term fix here is to do a better job at post-mission cleanup
// to remove dead/captured soldiers from every squad (can't just do the one that went
// on the mission because they can involve temporary members from other squads).
function bool IsValidSoldierForSquad(XComGameState_Unit Soldier)
{
	return Soldier.IsSoldier() && !Soldier.IsDead() && !Soldier.bCaptured;
}

function array<XComGameState_Unit> GetSoldiers()
{
	local XComGameState_Unit Soldier;
	local array<XComGameState_Unit> Soldiers;
	local int idx;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	for (idx = 0; idx < SquadSoldiers.Length; idx++)
	{
		Soldier = XComGameState_Unit(History.GetGameStateForObjectID(SquadSoldiers[idx].ObjectID));

		if (Soldier != none)
		{
			if (IsValidSoldierForSquad(Soldier))
			{
				Soldiers.AddItem(Soldier);
			}
		}
	}

	return Soldiers;
}

function array<XComGameState_Unit> GetTempSoldiers()
{
	local XComGameState_Unit Soldier;
	local array<XComGameState_Unit> Soldiers;
	local int idx;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	for (idx = 0; idx < SquadSoldiersOnMission.Length; idx++)
	{
		Soldier = XComGameState_Unit(History.GetGameStateForObjectID(SquadSoldiersOnMission[idx].ObjectID));

		if (Soldier != none)
		{
			if (IsValidSoldierForSquad(Soldier))
			{
				if (IsSoldierTemporary(Soldier.GetReference()))
					Soldiers.AddItem(Soldier);
			}
		}
	}

	return Soldiers;
	
}

function bool IsSoldierTemporary(StateObjectReference UnitRef)
{
	if (SquadSoldiersOnMission.Find('ObjectID', UnitRef.ObjectID) == -1)
		return false;
	return SquadSoldiers.Find('ObjectID', UnitRef.ObjectID) == -1;
}

function array<StateObjectReference> GetSoldierRefs(optional bool bIncludeTemp = false)
{
	local XComGameState_Unit Soldier;
	local array<StateObjectReference> SoldierRefs;
	local int idx;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	for (idx = 0; idx < SquadSoldiers.Length; idx++)
	{
		Soldier = XComGameState_Unit(History.GetGameStateForObjectID(SquadSoldiers[idx].ObjectID));

		if (Soldier != none)
		{
			if (IsValidSoldierForSquad(Soldier))
			{
				SoldierRefs.AddItem(Soldier.GetReference());
			}
		}
	}
	if (!bIncludeTemp)
		return SoldierRefs;

	for (idx = 0; idx < SquadSoldiersOnMission.Length; idx++)
	{
		Soldier = XComGameState_Unit(History.GetGameStateForObjectID(SquadSoldiersOnMission[idx].ObjectID));

		if (Soldier != none)
		{
			if (IsValidSoldierForSquad(Soldier))
			{
				if (IsSoldierTemporary(Soldier.GetReference()))
					SoldierRefs.AddItem(Soldier.GetReference());
			}
		}
	}

	return SoldierRefs;
}

function array<XComGameState_Unit> GetDeployableSoldiers(optional bool bAllowWoundedSoldiers=false)
{
	local XComGameState_Unit Soldier;
	local array<XComGameState_Unit> DeployableSoldiers;
	local int idx;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	for(idx = 0; idx < SquadSoldiers.Length; idx++)
	{
		Soldier = XComGameState_Unit(History.GetGameStateForObjectID(SquadSoldiers[idx].ObjectID));

		if(Soldier != none)
		{
			if(IsValidSoldierForSquad(Soldier) &&
				(Soldier.GetStatus() == eStatus_Active || Soldier.GetStatus() == eStatus_PsiTraining || (bAllowWoundedSoldiers && Soldier.IsInjured())))
			{
				DeployableSoldiers.AddItem(Soldier);
			}
		}
	}

	return DeployableSoldiers;
}

function array<StateObjectReference> GetDeployableSoldierRefs(optional bool bAllowWoundedSoldiers=false)
{
	local XComGameState_Unit Soldier;
	local array<StateObjectReference> DeployableSoldierRefs;
	local int idx;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	for(idx = 0; idx < SquadSoldiers.Length; idx++)
	{
		Soldier = XComGameState_Unit(History.GetGameStateForObjectID(SquadSoldiers[idx].ObjectID));

		if(Soldier != none)
		{
			if(IsValidSoldierForSquad(Soldier) &&
				(Soldier.GetStatus() == eStatus_Active || Soldier.GetStatus() == eStatus_PsiTraining || (bAllowWoundedSoldiers && Soldier.IsInjured())))
			{
				DeployableSoldierRefs.AddItem(Soldier.GetReference());
			}
		}
	}

	return DeployableSoldierRefs;
}

function AddSoldier(StateObjectReference UnitRef)
{
	local StateObjectReference SoldierRef;
	local int idx;

	// the squad may have "blank" ObjectIDs in order to allow player to arrange squad as desired
	// so, when adding a new soldier generically, try and find an existing ObjectID == 0 to fill before adding
	// This is a fix for ID 863
	foreach SquadSoldiers(SoldierRef, idx)
	{
		if (SoldierRef.ObjectID == 0)
		{
			SquadSoldiers[idx] = UnitRef;
			return;
		}
	}
	SquadSoldiers.AddItem(UnitRef);
}

function RemoveSoldier(StateObjectReference UnitRef)
{
	SquadSoldiers.RemoveItem(UnitRef);
}

function int GetSquadCount()
{
	return GetSquadCount_Static(SquadSoldiers);
}

static function int GetSquadCount_Static(array<StateObjectReference> Soldiers)
{
	local int idx, Count;


	for(idx = 0; idx < Soldiers.Length; idx++)
	{
		if(Soldiers[idx].ObjectID > 0)
			Count++;
	}
	return Count;
}

function string GetSquadImagePath()
{
	if(SquadImagePath != "")
		return SquadImagePath;

	return default.DefaultSquadImagePath;
}

//---------------------------
// MISSION HANDLING ---------
//---------------------------

simulated function SetSquadCrew(optional XComGameState UpdateState, optional bool bOnMissionSoldiers = true, optional bool bForDisplayOnly)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local bool bSubmitOwnGameState, bAllowWoundedSoldiers;
	local array<StateObjectReference> SquadSoldiersToAssign;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local XComGameState_MissionSite MissionSite;
	local int MaxSoldiers, idx;
	local array<name> RequiredSpecialSoldiers;

	bSubmitOwnGameState = UpdateState == none;

	if(bSubmitOwnGameState)
		UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Set Persistent Squad Members");

	History = `XCOMHISTORY;

	//try and retrieve XComHQ from GameState if possible
	XComHQ = `XCOMHQ;
	XComHQ = XComGameState_HeadquartersXCom(UpdateState.GetGameStateForObjectID(XComHQ.ObjectID));
	if(XComHQ == none)
		XComHQ = `XCOMHQ;

	if (XComHQ.MissionRef.ObjectID != 0)
	{
		MissionSite = XComGameState_MissionSite(History.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
	}

	MaxSoldiers = class'Utilities_LW'.static.GetMaxSoldiersAllowedOnMission(MissionSite);
	if (MissionSite != None)
	{
		bAllowWoundedSoldiers = MissionSite.GeneratedMission.Mission.AllowDeployWoundedUnits;
	}

	XComHQ = XComGameState_HeadquartersXCom(UpdateState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	if (bOnMissionSoldiers)
	{
		SquadSoldiersToAssign = SquadSoldiersOnMission;
	}
	else
	{
		if (bForDisplayOnly)
		{
			SquadSoldiersToAssign = SquadSoldiers;
		}
		else
		{
			SquadSoldiersToAssign = GetDeployableSoldierRefs(bAllowWoundedSoldiers);
		}
	}

	//clear the existing squad as much as possible (leaving in required units if in SquadSelect)
	// we can clear special units when assigning for infiltration or viewing
	if (bOnMissionSoldiers)
	{
		XComHQ.Squad.Length = 0;
	}
	else
	{
		RequiredSpecialSoldiers = MissionSite.GeneratedMission.Mission.SpecialSoldiers;

		for (idx = XComHQ.Squad.Length - 1; idx >= 0; idx--)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[idx].ObjectID));
			if (UnitState != none && RequiredSpecialSoldiers.Find(UnitState.GetMyTemplateName()) != -1)
			{
			}
			else
			{
				XComHQ.Squad.Remove(idx, 1);
			}
		}
	}

	//fill out the squad as much as possible using the squad units
	foreach SquadSoldiersToAssign(UnitRef)
	{
		if (XComHQ.Squad.Length >= MaxSoldiers) { continue; }

		if (UnitRef.ObjectID != 0)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
			if (UnitState != none)
			{
				if (IsValidSoldierForSquad(UnitState))
				{
					XComHQ.Squad.AddItem(UnitRef);
				}
			}
		}
	}

	// Only update AllSquads if we're dealing with soldiers already
	// on a mission (and ready to launch).
	if (bOnMissionSoldiers)
	{
		// Borrowed from Covert Infiltration mod:
		// This isn't needed to properly spawn units into battle, but without this
		// the transition screen shows last selection in strategy, not the soldiers
		// on this mission.
		XComHQ.AllSquads.Length = 1;
		XComHQ.AllSquads[0].SquadMembers = XComHQ.Squad;
	}


	if(bSubmitOwnGameState)
		`GAMERULES.SubmitGameState(UpdateState);
}

function SetOnMissionSquadSoldierStatus(XComGameState NewGameState)
{
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;

	foreach SquadSoldiersOnMission(UnitRef)
	{
		UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(UnitRef.ObjectID));
		if(UnitState == none && UnitRef.ObjectID != 0)
		{
			UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitRef.ObjectID));
			NewGameState.AddStateObject(UnitState);
		}
		if (UnitState != none)
		{
			class'LWDLCHelpers'.static.SetOnMissionStatus(UnitState, NewGameState);
		}
	}
}

function PostMissionRevertSoldierStatus(XComGameState NewGameState, XComGameState_LWSquadManager SquadMgr)
{
	//local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local XComGameState_HeadquartersProjectPsiTraining PsiProjectState;
	local XComGameState_FacilityXCom FacilityState;
	local XComGameState_StaffSlot SlotState;
	local int SlotIndex, idx;
	local StaffUnitInfo UnitInfo;
	local XComGameState_LWPersistentSquad SquadState, UpdatedSquad;
	local XComGameState_HeadquartersProjectHealSoldier HealProject;

	//History = `XCOMHISTORY;
	XComHQ = `XCOMHQ;
	foreach SquadSoldiersOnMission(UnitRef)
	{
		if (UnitRef.ObjectID == 0)
			continue;

		UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(UnitRef.ObjectID));
		if(UnitState == none)
		{
			UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitRef.ObjectID));
			if (UnitState == none)
				continue;
			NewGameState.AddStateObject(UnitState);
		}
		
		//if solder is dead or captured, remove from squad
		if(UnitState.IsDead() || UnitState.bCaptured)
		{
			RemoveSoldier(UnitRef);
			// Also find if the unit was a persistent member of another squad, and remove that that squad as well if so - ID 1675
			for(idx = 0; idx < SquadMgr.Squads.Length; idx++)
			{
				SquadState = SquadMgr.GetSquad(idx);
				if(SquadState.UnitIsInSquad(UnitRef))
				{
					UpdatedSquad = XComGameState_LWPersistentSquad(NewGameState.GetGameStateForObjectID(SquadState.ObjectID));
					if (UpdatedSquad == none)
					{
						UpdatedSquad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', SquadState.ObjectID));
						NewGameState.AddStateObject(UpdatedSquad);
					}
					UpdatedSquad.RemoveSoldier(UnitRef);
					break;	
				}
			}
		}

		//if soldier has an active psi training project, handle it if needed
		PsiProjectState = XComHQ.GetPsiTrainingProject(UnitState.GetReference());
		if (PsiProjectState != none) // A paused Psi Training project was found for the unit
		{
			if(UnitState.GetStatus() != eStatus_PsiTraining) // if the project wasn't already resumed (e.g. during typical post-mission processing)
			{
				//following code was copied from XComGameStateContext_StrategyGameRule.SquadTacticalToStrategyTransfer

				if (UnitState.IsDead() || UnitState.bCaptured) // The unit died or was captured, so remove the project
				{
					XComHQ.Projects.RemoveItem(PsiProjectState.GetReference());
					NewGameState.RemoveStateObject(PsiProjectState.ObjectID);
				}
				else if (!UnitState.IsInjured() && UnitState.GetMentalState() == eMentalState_Ready) // If the unit is uninjured, restart the training project automatically
				{
					// Get the Psi Chamber facility and staff the unit in it if there is an open slot
					FacilityState = XComHQ.GetFacilityByName('PsiChamber'); // Only one Psi Chamber allowed, so safe to do this

					for (SlotIndex = 0; SlotIndex < FacilityState.StaffSlots.Length; ++SlotIndex)
					{
						//If this slot has not already been modified (filled) in this tactical transfer, check to see if it's valid
						SlotState = XComGameState_StaffSlot(NewGameState.GetGameStateForObjectID(FacilityState.StaffSlots[SlotIndex].ObjectID));
						if (SlotState == None)
						{
							SlotState = FacilityState.GetStaffSlot(SlotIndex);

							// If this is a valid soldier slot in the Psi Lab, restaff the soldier and restart their training project
							if (!SlotState.IsLocked() && SlotState.IsSlotEmpty() && SlotState.IsSoldierSlot())
							{
								// Restart the paused training project
								PsiProjectState = XComGameState_HeadquartersProjectPsiTraining(NewGameState.CreateStateObject(class'XComGameState_HeadquartersProjectPsiTraining', PsiProjectState.ObjectID));
								NewGameState.AddStateObject(PsiProjectState);
								PsiProjectState.bForcePaused = false;

								UnitInfo.UnitRef = UnitState.GetReference();
								SlotState.FillSlot(UnitInfo, NewGameState);

								break;
							}
						}
					}
				}
			}
		}

		// Tedster fix - resume heal project during squad cleanup
		
		HealProject = class'LWDLCHelpers'.static.GetHealProject(UnitState.GetReference());

		if(HealProject != NONE && (HealProject.BlockCompletionDateTime.m_iYear == 9999 ||HealProject.BlockCompletionDateTime.m_iYear == 9999 ))
		{
			UnitState.SetStatus(eStatus_Healing);
			HealProject.ResumeProject();
		}

		//if soldier still has OnMission status, set status to active (unless it's a SPARK that's healing)
		if(class'LWDLCHelpers'.static.IsUnitOnMission(UnitState) && UnitState.GetStatus() != eStatus_Healing)
		{
			UnitState.SetStatus(eStatus_Active);
			class'Helpers_LW'.static.UpdateUnitWillRecoveryProject(UnitState);
		}
	}
}

function bool IsDeployedOnMission()
{
	if(bOnMission && CurrentMission.ObjectID == 0)
		`REDSCREEN("LWPersistentSquad: Squad marked on mission, but no current mission");
	return (bOnMission && CurrentMission.ObjectID != 0);
}

function bool IsSoldierOnMission(StateObjectReference UnitRef)
{
	return SquadSoldiersOnMission.Find('ObjectID', UnitRef.ObjectID) >= 0;
}

function XComGameState_MissionSite GetCurrentMission()
{
	if(CurrentMission.ObjectID == 0)
		return none;
	return XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(CurrentMission.ObjectID));
}

function StartMissionInfiltration(StateObjectReference MissionRef)
{
	local XComGameState UpdateState;
	local XComGameState_LWPersistentSquad UpdateSquad;

	UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Start Infiltration Mission");
	UpdateSquad = XComGameState_LWPersistentSquad(UpdateState.CreateStateObject(class'XComGameState_LWPersistentSquad', ObjectID));
	UpdateSquad.InitInfiltration(UpdateState, MissionRef, 0.0);
	UpdateState.AddStateObject(UpdateSquad);
	`XCOMGAME.GameRuleset.SubmitGameState(UpdateState);
}

function InitInfiltration(XComGameState NewGameState, StateObjectReference MissionRef, float Infiltration) // add cache call here for covertness
{
	CurrentMission = MissionRef;
	bOnMission = true;
	CurrentInfiltration = Infiltration;
	CurrentEnemyAlertnessModifier = 99999;
	SquadCovertnessCached=GetSquadCovertness(SquadSoldiersOnMission);
	GetAlertnessModifierForCurrentInfiltration(NewGameState, true);
	StartInfiltrationDateTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
	InfiltrationPointPassed.Length = 0;
}

function bool HasSufficientInfiltrationToStartMission(XComGameState_MissionSite MissionState)
{
	return CurrentInfiltration >= (GetRequiredPctInfiltrationToLaunch(MissionState) / 100.0);
}

static function float GetRequiredPctInfiltrationToLaunch(XComGameState_MissionSite MissionState)
{
	if (default.MissionsRequiring100Infiltration.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
	{
		return 100.0;
	}
	return default.RequiredInfiltrationToLaunch;
}

function ClearMission()
{
	bOnMission = false;
	SquadSoldiersOnMission.Length = 0;
	CurrentInfiltration = 0;
	CurrentMission.ObjectID = 0;
	bHasBoostedInfiltration = false;
	bCannotCancelAbort = false;
}

function StrategyCost GetBoostInfiltrationCost()
{
	local StrategyCost Cost;
	local ArtifactCost ResourceCost;

	ResourceCost.ItemTemplateName = 'Intel';
	ResourceCost.Quantity = DefaultBoostInfiltrationCost[`STRATEGYDIFFICULTYSETTING];
	Cost.ResourceCosts.AddItem(ResourceCost);

	return Cost;
}

function SpendBoostResource(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local StrategyCost BoostCost;
	local array<StrategyCostScalar> CostScalars;

	History = `XCOMHISTORY;
	
	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}
	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
	}
	CostScalars.Length = 0;
	BoostCost = GetBoostInfiltrationCost();
	XComHQ.PayStrategyCost(NewGameState, BoostCost, CostScalars);
	
	//`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	
	//`XCOMHQ.AddResource(NewGameState, 'Intel', -DefaultBoostInfiltrationCost[`STRATEGYDIFFICULTYSETTING]);
}

//---------------------------
// EVAC DELAY CALCS ---------
//---------------------------

function int EvacDelayModifier_SquadSize()
{
	local int SquadSize;
	local StateObjectReference UnitRef;

	SquadSize = 0;
	foreach SquadSoldiersOnMission(UnitRef)
	{
		if (UnitRef.ObjectID > 0)
		{
			SquadSize++;	
		}
	}

	if (SquadSize >= default.EvacDelayAtSquadSize.Length)
		SquadSize = default.EvacDelayAtSquadSize.Length - 1;

	return default.EvacDelayAtSquadSize[SquadSize];
}

function int EvacDelayModifier_Infiltration()
{
	local float Infiltration;
	local int EvacDelayForInfiltration;
	local InfiltrationModifier EvacDelayModifier;
	
	Infiltration = CurrentInfiltration;
	foreach default.EvacDelayAtInfiltration(EvacDelayModifier)
	{
		if (EvacDelayModifier.Infiltration <= Infiltration)
			EvacDelayForInfiltration = EvacDelayModifier.Modifier;
	}
	return EvacDelayForInfiltration;
}

function int EvacDelayModifier_Missions()
{
	local int NumMissions;
	local XComGameState_LWSquadManager SquadMgr;

	SquadMgr = class'XComGameState_LWSquadManager'.static.GetSquadManager();
	NumMissions = SquadMgr.NumSquadsOnAnyMission();
	if (NumMissions >= default.EvacDelayForInfiltratedMissions.Length)
		NumMissions = default.EvacDelayForInfiltratedMissions.Length - 1;

	return default.EvacDelayForInfiltratedMissions[NumMissions];
}

//---------------------------
// INFILTRATION HANDLING ----
//---------------------------

function UpdateInfiltrationState(bool AllowPause)
{
	local XComGameState UpdateState;
	local XComGameState_LWPersistentSquad UpdateSquad;
	local int SecondsOfInfiltration;
	local float HoursOfInfiltration;
	local float HoursToFullInfiltration;
	local float PossibleInfiltrationUpdate;
	local float InfiltrationBonusOnLiberation;
	local UIStrategyMap StrategyMap;
	local bool ShouldPause;
	local int InfiltrationHaltIndex;
	local XGGeoscape Geoscape;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
    local XComGameState_MissionSite MissionSite;
	
	if(CurrentMission.ObjectID == 0) return;  // only needs update when on mission
	SecondsOfInfiltration = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(GetCurrentTime(), StartInfiltrationDateTime);
	HoursOfInfiltration = float(SecondsOfInfiltration) / 3600.0;
	HoursToFullInfiltration = GetHoursToFullInfiltrationCached();
	
	// Add the liberation infiltration bonus to the infiltration time if the region has been liberated.
	// This handles boosting of missions that are still around after liberating the region where the boost
	// was not being applied fully, or at all.
	MissionSite = GetCurrentMission();
	if(MissionSite != none)
	{
		RegionState = MissionSite.GetWorldRegion();
		if(RegionState != none)
		{
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
			if(RegionalAI.bLiberated)
			{
				InfiltrationBonusOnLiberation = class'X2StrategyElement_DefaultAlienActivities'.default.INFILTRATION_BONUS_ON_LIBERATION[`STRATEGYDIFFICULTYSETTING] / 100.0;
				HoursOfInfiltration += GetHoursToFullInfiltrationCached_Static(SquadSoldiersOnMission, SquadCovertnessCached, CurrentMission) * InfiltrationBonusOnLiberation;
			}
		}
	}
	
	PossibleInfiltrationUpdate = FClamp(HoursOfInfiltration / HoursToFullInfiltration, 0.0, 2.0000001);

	UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Infiltration Progress");
	if(PossibleInfiltrationUpdate - CurrentInfiltration >= 0.01 || PossibleInfiltrationupdate >= 2.0)
	{
		UpdateSquad = XComGameState_LWPersistentSquad(UpdateState.CreateStateObject(class'XComGameState_LWPersistentSquad', ObjectID));
		UpdateSquad.CurrentInfiltration = PossibleInfiltrationUpdate;
		UpdateState.AddStateObject(UpdateSquad);
	}
	StrategyMap = `HQPRES.StrategyMap2D;
	if (StrategyMap != none && StrategyMap.m_eUIState != eSMS_Flight)
	{
		if (UpdateSquad != none)  
		{
			InfiltrationHaltIndex = HasPassedAvailableInfiltrationHaltPoint(UpdateSquad.CurrentInfiltration);
			if (InfiltrationHaltIndex >= 0)
			{
				ShouldPause = true;
				UpdateSquad.InfiltrationPointPassed[InfiltrationHaltIndex] = true;
			}
		}
	}
	if (UpdateState.GetNumGameStateObjects() > 0)
		`XCOMGAME.GameRuleset.SubmitGameState(UpdateState);
	else
		`XCOMHISTORY.CleanupPendingGameState(UpdateState);

	if (AllowPause && ShouldPause)
	{
		Geoscape = `GAME.GetGeoscape();
		Geoscape.Pause();
		Geoscape.Resume();
	}
}

function UpdateGameBoard()
{
    UpdateInfiltrationState(true);
}

function int HasPassedAvailableInfiltrationHaltPoint(float InfiltrationToCheck)
{
	local int idx;
	local float InfiltrationHaltPoint;

	foreach default.InfiltrationHaltPoints(InfiltrationHaltPoint, idx)
	{
		// This is causing log warnings -- A:fixed with length check
		if ((idx >= InfiltrationPointPassed.Length  || !InfiltrationPointPassed[idx]) && InfiltrationToCheck >= InfiltrationHaltPoint/100.0)
		{
			return idx;
		}
	}
	return -1;
}

function int GetAlertnessModifierForCurrentInfiltration(optional XComGameState UpdateState, optional bool bForceUpdate = false, optional out int ArrayIndex)
{
	local bool bUpdateSelf;
	local XComGameState_LWPersistentSquad UpdateSquad;
	local float fAlertnessModifier, FractionalBit;
	local int iAlertnessModifier;
	local int idx;
	local float Infiltration_Low, Infiltration_High;
	local float fAlert_Low, fAlert_High;
	local InfiltrationModifier AlertLevelModifier;

	//use the previously cached version if not enough additional infiltration has occurred
	if(!bForceUpdate && (CurrentInfiltration < LastInfiltrationUpdate + AlertnessUpdateInterval))
	{
		ArrayIndex = LastAlertIndex;
		return CurrentEnemyAlertnessModifier;
	}
	//time to update the alertness modifier
	if(UpdateState == none)
	{
		UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Alertness Modifier from Infiltration");
		UpdateSquad = XComGameState_LWPersistentSquad(UpdateState.CreateStateObject(class'XComGameState_LWPersistentSquad', ObjectID));
		bUpdateSelf = true;
	}

	foreach default.AlertModifierAtInfiltration(AlertLevelModifier, idx)
	{
		if (AlertLevelModifier.Infiltration > CurrentInfiltration)
		{
			break;
		}
	}
	if (CurrentInfiltration <= (RequiredInfiltrationToLaunch/100.0))
	{
		ArrayIndex = 0;
		iAlertnessModifier = Round(default.AlertModifierAtInfiltration[ArrayIndex].Modifier);
	}
	else if (idx >= default.AlertModifierAtInfiltration.Length - 1)
	{
		ArrayIndex = default.AlertModifierAtInfiltration.Length - 1;
		iAlertnessModifier = Round(default.AlertModifierAtInfiltration[ArrayIndex].Modifier);
	}
	else
	{
		Infiltration_Low = default.AlertModifierAtInfiltration[idx-1].Infiltration;
		Infiltration_High = default.AlertModifierAtInfiltration[idx].Infiltration;
		fAlert_Low = default.AlertModifierAtInfiltration[idx-1].Modifier;
		fAlert_High = default.AlertModifierAtInfiltration[idx].Modifier;

		fAlertnessModifier = fAlert_Low + (fAlert_High - fAlert_Low) * (CurrentInfiltration - Infiltration_Low ) / (Infiltration_High - Infiltration_Low);  // goes down when infiltration is high
		FractionalBit = Abs(fAlertnessModifier - fAlert_Low);
		if(`SYNC_FRAND() < FractionalBit)
		{
			ArrayIndex = idx - 1;
			iAlertnessModifier = Round(fAlert_High);
		}
		else
		{
			ArrayIndex = idx;
			iAlertnessModifier = Round(fAlert_Low);
		}
	}
	iAlertnessModifier = Min(iAlertnessModifier, CurrentEnemyAlertnessModifier);

	ArrayIndex = default.AlertModifierAtInfiltration.Find('Modifier', iAlertnessModifier);
	if(bUpdateSelf)
	{
		UpdateSquad.LastAlertIndex = ArrayIndex;
		UpdateSquad.CurrentEnemyAlertnessModifier = iAlertnessModifier;
		UpdateSquad.LastInfiltrationUpdate = CurrentInfiltration;
		UpdateState.AddStateObject(UpdateSquad);
		`XCOMGAME.GameRuleset.SubmitGameState(UpdateState);
	}
	else
	{
		LastAlertIndex = ArrayIndex;
		CurrentEnemyAlertnessModifier = iAlertnessModifier;
		LastInfiltrationUpdate = CurrentInfiltration;
	}
	return iAlertnessModifier;
}

function float GetSecondsRemainingToFullInfiltration(optional bool bBoost = false)
{
	local float TotalSecondsToInfiltrate;
	local float SecondsOfInfiltration;
	local float SecondsToInfiltrate;

	if(bBoost)
	{
		TotalSecondsToInfiltrate = 3600.0 * GetHoursToFullInfiltrationCached() / class'XComGameState_LWPersistentSquad'.default.DefaultBoostInfiltrationFactor[`STRATEGYDIFFICULTYSETTING];
	}
	else
	{
		TotalSecondsToInfiltrate = 3600.0 * GetHoursToFullInfiltrationCached(); // test caching here roo
	}
	
	SecondsOfInfiltration = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(GetCurrentTime(), StartInfiltrationDateTime);
	SecondsToInfiltrate = TotalSecondsToInfiltrate - SecondsOfInfiltration;

	return SecondsToInfiltrate;
}

static function float GetBaselineHoursToInfiltration(StateObjectReference MissionRef)
{
	local XComGameState_LWAlienActivity ActivityState;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local XComGameState_MissionSite MissionState;
	local float BaseHours;
	local int MissionIdx;

	BaseHours = default.InfiltrationTime_BaselineHours[`STRATEGYDIFFICULTYSETTING];

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));
	switch (MissionState.Source)
	{
		case 'MissionSource_Blacksite': 
			BaseHours = default.InfiltrationTime_BlackSite[`STRATEGYDIFFICULTYSETTING];
			break;
		case 'MissionSource_Forge':
			BaseHours = default.InfiltrationTime_Forge[`STRATEGYDIFFICULTYSETTING];
			break;
		case 'MissionSource_PsiGate':
			BaseHours = default.InfiltrationTime_PsiGate[`STRATEGYDIFFICULTYSETTING];
			break;
		default:
			break;
	}
	if (MissionRef.ObjectID != 0)
	{
		ActivityState = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMissionRef(MissionRef);
	}
	if (ActivityState == none)
	{
		return BaseHours;
	}
	ActivityTemplate = ActivityState.GetMyTemplate();
	if (ActivityTemplate == none)
	{
		return BaseHours;
	}
	MissionIdx = ActivityState.CurrentMissionLevel;
	if (MissionIdx < 0 || MissionIdx >= ActivityTemplate.MissionTree.Length)
	{
		return BaseHours;
	}
	BaseHours += ActivityTemplate.MissionTree[MissionIdx].BaseInfiltrationModifier_Hours;
	return BaseHours;
}

function float GetHoursToFullInfiltration(optional out int SquadSizeHours, optional StateObjectReference MissionRef, optional out int CovertnessHours, optional out int LiberationHours) // make copy to reference new static version
{
	local float HoursToFullInfiltration;

	if (MissionRef.ObjectID == 0)
	{
		MissionRef = CurrentMission;
	}
	HoursToFullInfiltration = GetHoursToFullInfiltration_Static(SquadSoldiersOnMission, MissionRef, SquadSizeHours, CovertnessHours, LiberationHours);

	if (bHasBoostedInfiltration)
		HoursToFullInfiltration /= DefaultBoostInfiltrationFactor[`STRATEGYDIFFICULTYSETTING];

	return HoursToFullInfiltration;
}

static function float GetHoursToFullInfiltration_Static(array<StateObjectReference> Soldiers, StateObjectReference MissionRef, optional out int SquadSizeHours, optional out int CovertnessHours, optional out int LiberationHours) // make copy to use cached covertness 
{
	local float BaseHours;
	local float SquadSize;
	local float Covertness;
	local float SquadSizeFactor, CovertnessFactor, LiberationFactor;
	local float ReturnHours;
	local XComGameState_MissionSite MissionState;
	//if(Soldiers.Length == 0)
		//Soldiers = SquadSoldiers;

	SquadSize = float(GetSquadCount_Static(Soldiers));
	Covertness = GetSquadCovertness(Soldiers);

	if(SquadSize >= default.SquadSizeInfiltrationFactor.Length)
		SquadSizeFactor = default.SquadSizeInfiltrationFactor[default.SquadSizeInfiltrationFactor.Length - 1];
	else
		SquadSizeFactor = default.SquadSizeInfiltrationFactor[SquadSize];

	if (`XCOMHQ.SoldierUnlockTemplates.Find('Infiltration1Unlock') != -1)
		SquadSizeFactor -= default.GTSInfiltration1Modifier[SquadSize];

	if (`XCOMHQ.SoldierUnlockTemplates.Find('Infiltration2Unlock') != -1)
		SquadSizeFactor -= default.GTSInfiltration2Modifier[SquadSize];
	

	//if(SquadSize < default.InfiltrationSquadSize_Baseline)
		//SquadSizeFactor -= (default.InfiltrationSquadSize_Baseline - SquadSize) * InfiltrationSquadSize_RateDown;
	//else
		//SquadSizeFactor += (SquadSize- default.InfiltrationSquadSize_Baseline) * InfiltrationSquadSize_RateUp;

	BaseHours = GetBaselineHoursToInfiltration(MissionRef);

	SquadSizeFactor = FClamp(SquadSizeFactor, 0.05, 10.0);
	SquadSizeHours = Round(BaseHours * (SquadSizeFactor - 1.0));

	CovertnessFactor = 1.0;
	if(Covertness < default.InfiltrationCovertness_Baseline)
		CovertnessFactor -= (default.InfiltrationCovertness_Baseline - Covertness) * default.InfiltrationCovertness_RateDown / 100.0;
	else
		CovertnessFactor += (Covertness - default.InfiltrationCovertness_Baseline) * default.InfiltrationCovertness_RateUp / 100.0;

	CovertnessFactor = FClamp(CovertnessFactor, 0.05, 10.0);
	CovertnessHours = Round((BaseHours + FMax(0.0, SquadSizeHours)) * (CovertnessFactor - 1.0));

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));
	if (default.MissionsAffectedByLiberationStatus.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
	{
		LiberationFactor = GetLiberationFactor(MissionState);
		LiberationHours = Round(BaseHours * (LiberationFactor - 1.0));
	}
	else
	{
		LiberationFactor = 1.0;
		LiberationHours = 0;
	}
	ReturnHours = BaseHours;
	ReturnHours += SquadSizeHours;
	ReturnHours += CovertnessHours;
	ReturnHours += LiberationHours;
	ReturnHours = FClamp(ReturnHours, default.InfiltrationTime_MinHours, default.InfiltrationTime_MaxHours);

	return ReturnHours;
}

function float GetHoursToFullInfiltrationCached(optional out int SquadSizeHours, optional StateObjectReference MissionRef, optional out int CovertnessHours, optional out int LiberationHours) // make copy to reference new static version
{
	local float HoursToFullInfiltration;

	if (MissionRef.ObjectID == 0)
	{
		MissionRef = CurrentMission;
	}
	HoursToFullInfiltration = GetHoursToFullInfiltrationCached_Static(SquadSoldiersOnMission, SquadCovertnessCached, MissionRef, SquadSizeHours, CovertnessHours, LiberationHours);
	//`LOG("Squad" @self @"covertness:"@SquadCovertnessCached,,'TedLog');
	if (bHasBoostedInfiltration)
		HoursToFullInfiltration /= DefaultBoostInfiltrationFactor[`STRATEGYDIFFICULTYSETTING];

	return HoursToFullInfiltration;
}

static function float GetHoursToFullInfiltrationCached_Static(array<StateObjectReference> Soldiers, float CachedCovertness, StateObjectReference MissionRef, optional out int SquadSizeHours, optional out int CovertnessHours, optional out int LiberationHours) // make copy to use cached covertness 
{
	local float BaseHours;
	local float SquadSize;
	local float Covertness;
	local float SquadSizeFactor, CovertnessFactor, LiberationFactor;
	local float ReturnHours;
	local XComGameState_MissionSite MissionState;
	//if(Soldiers.Length == 0)
		//Soldiers = SquadSoldiers;

	SquadSize = float(GetSquadCount_Static(Soldiers));
	Covertness = CachedCovertness;

	if(SquadSize >= default.SquadSizeInfiltrationFactor.Length)
		SquadSizeFactor = default.SquadSizeInfiltrationFactor[default.SquadSizeInfiltrationFactor.Length - 1];
	else
		SquadSizeFactor = default.SquadSizeInfiltrationFactor[SquadSize];

	if (`XCOMHQ.SoldierUnlockTemplates.Find('Infiltration1Unlock') != -1)
		SquadSizeFactor -= default.GTSInfiltration1Modifier[SquadSize];

	if (`XCOMHQ.SoldierUnlockTemplates.Find('Infiltration2Unlock') != -1)
		SquadSizeFactor -= default.GTSInfiltration2Modifier[SquadSize];
	

	//if(SquadSize < default.InfiltrationSquadSize_Baseline)
		//SquadSizeFactor -= (default.InfiltrationSquadSize_Baseline - SquadSize) * InfiltrationSquadSize_RateDown;
	//else
		//SquadSizeFactor += (SquadSize- default.InfiltrationSquadSize_Baseline) * InfiltrationSquadSize_RateUp;

	BaseHours = GetBaselineHoursToInfiltration(MissionRef);

	SquadSizeFactor = FClamp(SquadSizeFactor, 0.05, 10.0);
	SquadSizeHours = Round(BaseHours * (SquadSizeFactor - 1.0));

	CovertnessFactor = 1.0;
	if(Covertness < default.InfiltrationCovertness_Baseline)
		CovertnessFactor -= (default.InfiltrationCovertness_Baseline - Covertness) * default.InfiltrationCovertness_RateDown / 100.0;
	else
		CovertnessFactor += (Covertness - default.InfiltrationCovertness_Baseline) * default.InfiltrationCovertness_RateUp / 100.0;

	CovertnessFactor = FClamp(CovertnessFactor, 0.05, 10.0);
	CovertnessHours = Round((BaseHours + FMax(0.0, SquadSizeHours)) * (CovertnessFactor - 1.0));

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));
	if (default.MissionsAffectedByLiberationStatus.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
	{
		LiberationFactor = GetLiberationFactor(MissionState);
		LiberationHours = Round(BaseHours * (LiberationFactor - 1.0));
	}
	else
	{
		LiberationFactor = 1.0;
		LiberationHours = 0;
	}
	ReturnHours = BaseHours;
	ReturnHours += SquadSizeHours;
	ReturnHours += CovertnessHours;
	ReturnHours += LiberationHours;
	ReturnHours = FClamp(ReturnHours, default.InfiltrationTime_MinHours, default.InfiltrationTime_MaxHours);

	return ReturnHours;
}

static function float GetLiberationFactor(XComGameState_MissionSite MissionState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionAI;
	local XComGameState_LWAlienActivity ActivityState;
	local float LiberationFactor;

	RegionState = MissionState.GetWorldRegion();
	RegionAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
	LiberationFactor = default.InfiltrationLiberationFactor[0];
	if (RegionAI.LiberateStage1Complete)
	{
		LiberationFactor = default.InfiltrationLiberationFactor[1];
	}
	if (RegionAI.LiberateStage2Complete)
	{
		LiberationFactor = default.InfiltrationLiberationFactor[2];
		foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
		{
			if(ActivityState.GetMyTemplateName() == class'X2StrategyElement_DefaultAlienActivities'.default.ProtectRegionName)
			{
				if (ActivityState.PrimaryRegion.ObjectID == RegionState.ObjectID)
				{
					if (ActivityState.CurrentMissionLevel > 0)
					{
						LiberationFactor = default.InfiltrationLiberationFactor[3];
					}
					if (ActivityState.CurrentMissionLevel > 1)
					{
						LiberationFactor = default.InfiltrationLiberationFactor[4];
					}
				}
			}
		}
	}
	if (RegionAI.bLiberated)
	{
		LiberationFactor = default.InfiltrationLiberationFactor[5];
	}
	return LiberationFactor;
}



static function float GetSquadCovertness(array<StateObjectReference> Soldiers)
{
	local StateObjectReference UnitRef;
	local float CumulativeCovertness, AveCovertness;
	local float SquadCovertnessMultiplier, SquadCovertnessMultiplierDelta;

	//if(Soldiers.Length == 0)
		//Soldiers = SquadSoldiers;

	SquadCovertnessMultiplier = 1.0;
	CumulativeCovertness = 0.0;
	foreach Soldiers(UnitRef)
	{
		SquadCovertnessMultiplierDelta = 1.0;
		CumulativeCovertness += GetSoldierCovertness(Soldiers, UnitRef, SquadCovertnessMultiplierDelta);
		SquadCovertnessMultiplier *= SquadCovertnessMultiplierDelta;
	}

	// this is for squad-wide ability/item effects
	CumulativeCovertness *= SquadCovertnessMultiplier;

	//each soldier is equally weighted
	AveCovertness = CumulativeCovertness / float(GetSquadCount_Static(Soldiers));

	//`LOG("Computed Squad Covertness = " $ AveCovertness);

	return AveCovertness;
}

static function float GetSoldierCovertness(array<StateObjectReference> Soldiers, StateObjectReference UnitRef, out float SquadCovertnessMultiplierDelta)
{
	local XComGameStateHistory History;
	local XComGameState CurrentGameState;
	local XComGameState_Unit UnitState, OfficerCandidateState;
	local array<XComGameState_Item> CurrentInventory, EquippedUtilityItems;
	local XComGameState_Item InventoryItem;
	local float CumulativeUnitCovertness, CumulativeWeight;
	local float CumulativeUnitMultiplier, UnitCovertness;
	local array<X2WeaponUpgradeTemplate> WeaponUpgradeTemplates;
	local X2WeaponUpgradeTemplate WeaponUpgradeTemplate;
	local AbilityCovertnessContainer AbilityCov;
	local int k;
	local array<LeadershipEntry> LeadershipHistory;
	local XComGameState_Unit_LWOfficer OfficerState;

	History = `XCOMHISTORY;
	CurrentGameState = History.GetGameStateFromHistory();

	//this can happen if the player leaves gaps in SquadSelect, so just don't count this as anything
	if(UnitRef.ObjectID <= 0)
		return 0.0;

	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

	//This is to support including non-soldiers on missions eventually
	if(!UnitState.IsSoldier())
		return default.InfiltrationCovertness_Baseline;

	CumulativeUnitMultiplier = 1.0;

	CumulativeUnitCovertness = 0.0;
	CumulativeWeight = 0.0;

	CurrentInventory = UnitState.GetAllInventoryItems();
	EquippedUtilityItems = UnitState.GetAllItemsInSlot(eInvSlot_Utility,,,true);
	CumulativeWeight += (UnitState.RealizeItemSlotsCount(CurrentGameState) - EquippedUtilityItems.Length) * default.EMPTY_UTILITY_SLOT_WEIGHT;

	//`LOG ("Soldier with" @ EquippedUtilityItems.Length @ "utility slot items starts with base covertness weight of" @ CumulativeWeight);

	foreach CurrentInventory(InventoryItem)
	{
		UpdateCovertnessForItem(InventoryItem.GetMyTemplate(), CumulativeUnitCovertness, CumulativeWeight, CumulativeUnitMultiplier);

		//  Gather covertness from any weapon upgrades
		WeaponUpgradeTemplates = InventoryItem.GetMyWeaponUpgradeTemplates();
		foreach WeaponUpgradeTemplates(WeaponUpgradeTemplate)
		{
			UpdateCovertnessForItem(WeaponUpgradeTemplate, CumulativeUnitCovertness, CumulativeWeight, CumulativeUnitMultiplier);
		}
	}

	foreach default.AbilityCovertness(AbilityCov)
	{
		if (class'Helpers_LW'.static.HasSoldierAbility(UnitState, AbilityCov.AbilityName))
		{
			if (AbilityCov.IndividualMultiplier > 0.0)
				CumulativeUnitMultiplier *= AbilityCov.IndividualMultiplier;

			if (AbilityCov.SquadMultiplier > 0.0)
				SquadCovertnessMultiplierDelta *= AbilityCov.SquadMultiplier;
		}
	}

	// find the officer and missions together
	for (k = 0; k < soldiers.length; k++)
	{
		OfficerCandidateState = XComGameState_Unit(History.GetGameStateForObjectID(Soldiers[k].ObjectID));
		if (class'LWOfficerUtilities'.static.IsHighestRankOfficerinSquad(OfficerCandidateState))
		{
			OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(OfficerCandidateState);
			break;
		}
	}

	//`LOG ("LeadershipCovertness 0");

	if (OfficerState != none && UnitState != none && !class'LWOfficerUtilities'.static.IsOfficer(UnitState))
	{
		//`LOG ("LeadershipCovertness 1");

		LeadershipHistory = OfficerState.GetLeadershipData_MissionSorted();
		for (k = 0; k < LeadershipHistory.length; k++)
		{
			if (LeadershipHistory[k].UnitRef == UnitState.GetReference())
			{
				CumulativeUnitMultiplier *= (1.00 - (fMin (LeadershipHistory[k].SuccessfulMissionCount * default.LEADERSHIP_COVERTNESS_PER_MISSION, default.LEADERSHIP_COVERTNESS_CAP)));
				//`LOG ("ADDING LEADERSHIP COVERTNESS MODIFIER:" @ UnitState.GetLastName() @ string(CumulativeUnitMultiplier));
				//`LOG (string (1.00 - (fMin (LeadershipHistory[k].SuccessfulMissionCount * default.LEADERSHIP_COVERTNESS_PER_MISSION, default.LEADERSHIP_COVERTNESS_CAP))));
				break;
			}
		}
	}

	CumulativeUnitCovertness *= CumulativeUnitMultiplier;

	if(CumulativeWeight > 0.0)  // avoid divide-by-zero errors
		UnitCovertness = CumulativeUnitCovertness/CumulativeWeight;
	else
		UnitCovertness = default.InfiltrationCovertness_Baseline;

	//`LOG("Computed Unit Covertness (" $ UnitState.GetFullName() $ ") = " $ UnitCovertness);
	return UnitCovertness;
}

static function UpdateCovertnessForItem(X2ItemTemplate ItemTemplate, out float CumulativeUnitCovertness, 
																	 out float CumulativeWeight, 
																	 out float CumulativeUnitMultiplier)
{
	local int ListIdx;
	local X2WeaponTemplate WeaponTemplate;
	local name WeaponCategory;
	local float Weight;
	local XComGameState_HeadquartersXCom XComHQ;

	//look for a specific equipment configuration
	ListIdx = default.EquipmentCovertness.Find('ItemName', ItemTemplate.DataName);
	if(ListIdx != -1) // found a specific equipment definition
	{
		Weight = default.EquipmentCovertness[ListIdx].CovertnessWeight;
		CumulativeUnitCovertness += Weight * default.EquipmentCovertness[ListIdx].CovertnessValue;
		CumulativeWeight += Weight;
		if(default.EquipmentCovertness[ListIdx].IndividualMultiplier > 0.0)
			CumulativeUnitMultiplier *= default.EquipmentCovertness[ListIdx].IndividualMultiplier;

		//Add possible Insider Knowledge bonus for suppressors
		switch (ItemTemplate.DataName)
		{
			case 'FreeKillUpgrade_Bsc':
			case 'FreeKillUpgrade_Adv':
			case 'FreeKillUpgrade_Sup':
				XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
				CumulativeWeight += XComHQ.bEmpoweredUpgrades ? default.SUPPRESSOR_INFILTRATION_EMPOWER_BONUS : 0.0;
				break;
			default: break;
		}
	}
	else
	{
		WeaponTemplate = X2WeaponTemplate(ItemTemplate);
		if(WeaponTemplate != none)
		{
			WeaponCategory = WeaponTemplate.WeaponCat;
			if(WeaponCategory != '') // sanity check
				ListIdx = default.WeaponCategoryCovertness.Find('CategoryName', WeaponCategory);
		}
		if(ListIdx != -1)
		{
			Weight = default.WeaponCategoryCovertness[ListIdx].CovertnessWeight;
			CumulativeUnitCovertness += Weight * default.WeaponCategoryCovertness[ListIdx].CovertnessValue;
			CumulativeWeight += default.WeaponCategoryCovertness[ListIdx].CovertnessWeight;
		}
		else
		{
			ListIdx = default.ItemCategoryCovertness.Find('CategoryName', ItemTemplate.ItemCat);
			if(ListIdx != -1)
			{
				Weight = default.ItemCategoryCovertness[ListIdx].CovertnessWeight;
				CumulativeUnitCovertness += Weight * default.ItemCategoryCovertness[ListIdx].CovertnessValue;
				CumulativeWeight += Weight;
			}
			else
			{
				`REDSCREEN("COVERTNESS CALCULATION : No valid item or category found for item=" $ ItemTemplate.DataName);
			}
		}
	}

}

// We need a UI class for all strategy elements (but they'll never be visible)
function class<UIStrategyMapItem> GetUIClass()
{
    return class'UIStrategyMapItem';
}

// Never show these on the map.
function bool ShouldBeVisible()
{
    return false;
}

//---------------------------
// MISC SETTINGS ------------
//---------------------------

function string GetSquadName()
{
	return sSquadName;
}

function SetSquadName(string NewName)
{
	sSquadName = NewName;
}
