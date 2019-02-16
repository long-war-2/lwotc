//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_EspritdeCorpse
//  AUTHOR:  Amineri  (Pavonis Interactive)
//  PURPOSE: Adds sliding bonus effect for Esprit de Corps Ability
//--------------------------------------------------------------------------------------- 
class X2Effect_EspritdeCorps extends X2Effect_PersistentStatChange;

var float DodgePerMission;
var float DodgeCap;
var float WillPerMission;
var float WillCap;
var float AimPerMission;
var float AimCap;
var float DefensePerMission;
var float DefenseCap;

protected simulated function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local array<LeadershipEntry> LeadershipHistory;
	local XComGameState_Unit SoldierUnit, OfficerUnit;
	local XComGameState_Unit_LWOfficer OfficerState, SecondOfficer;
	local int k, MissionsTogether;
	local StatChange LeadershipChange;

	//`LOG ("EDC TRIGGERED!");

	m_aStatChanges.length = 0;

	OfficerUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(OfficerUnit);
	SoldierUnit = XComGameState_Unit (kNewTargetState);
	SecondOfficer = class'LWOfficerUtilities'.static.GetOfficerComponent(SoldierUnit);
		
	if (OfficerState != none && SoldierUnit != none && OfficerUnit.GetReference() != SoldierUnit.GetReference() && SecondOfficer == none)
	{
		LeadershipHistory = OfficerState.GetLeadershipData_MissionSorted();
		for (k = 0; k < LeadershipHistory.length; k++)
		{
			if (LeadershipHistory[k].UnitRef == SoldierUnit.GetReference())
			{
				MissionsTogether = LeadershipHistory[k].SuccessfulMissionCount;
				break;
			}
		}
		//`LOG ("EDC 1: MissionsTogether" @ string (MissionsTogether) @ SoldierUnit.GetLastName());
		LeadershipChange.ModOp = MODOP_Addition;
		if (MissionsTogether > 0)
		{
			if (WillPerMission > 0)
			{
				LeadershipChange.StatType = eStat_Will;
				LeadershipChange.StatAmount = FMin (MissionsTogether * WillPerMission, WillCap);
				//`LOG ("EDC 2: Will" @ LeaderShipChange.StatAmount);
				m_aStatChanges.AddItem (LeadershipChange);
			}
			if (DodgePerMission > 0)
			{
				LeadershipChange.StatType = eStat_Dodge;
				LeadershipChange.StatAmount = FMin (MissionsTogether * DodgePerMission, DodgeCap);
				//`LOG ("EDC 3: Dodge" @ LeaderShipChange.StatAmount);
				m_aStatChanges.AddItem (LeadershipChange);
			}
			if (AimPerMission > 0)
			{
				LeadershipChange.StatType = eStat_Dodge;
				LeadershipChange.StatAmount = FMin (MissionsTogether * AimPerMission, AimCap);
				//`LOG ("EDC 4: Aim" @ LeaderShipChange.StatAmount);
				m_aStatChanges.AddItem (LeadershipChange);
			}
			if (DefensePerMission > 0)
			{
				LeadershipChange.StatType = eStat_Dodge;
				LeadershipChange.StatAmount = FMin (MissionsTogether * DefensePerMission, DefenseCap);
				//`LOG ("EDC 4: Defense" @ LeaderShipChange.StatAmount);
				m_aStatChanges.AddItem (LeadershipChange);
			}
		}
	}
	if (m_aStatChanges.length > 0)
	{
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	}
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (SourceUnit == none || SourceUnit.IsDead() || TargetUnit == none || TargetUnit.IsDead())
	{
		return false;
	}
	if (SourceUnit.ObjectID == TargetUnit.ObjectID)
	{
		return false;
	}
	if (EffectGameState.StatChanges.length == 0)
	{
		return false;
	}

	return true;
}

