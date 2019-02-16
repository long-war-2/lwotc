//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityDetectionCalc_Rendezvous.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//	PURPOSE: Special detection logic for rendezvous missions
//---------------------------------------------------------------------------------------
class X2LWActivityDetectionCalc_Rendezvous extends X2LWActivityDetectionCalc config(LW_Activities);



var config array<float> LIAISON_MISSION_INCOME_PER_RANK;
var config array<float> LIAISON_MISSION_INCOME_PER_RANK_PSI;

var config array<float> LIAISON_MISSION_INCOME_BONUS_PER_RANK_OFFICER;

function bool CanBeDetected(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
    local XComGameState_Unit Liaison;
    local StateObjectReference LiaisonRef;
    local XComGameState_WorldRegion RegionState;
    local XComGameState_LWOutpost OutpostState;

    RegionState = GetRegion(ActivityState);
    OutpostState = `LWOUTPOSTMGR.GetOutpostForRegion(RegionState);

    LiaisonRef = OutpostState.GetLiaison();
    Liaison = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LiaisonRef.ObjectID));

    // Cannot detect unless the liaison is a soldier
    if (Liaison == none || !Liaison.IsSoldier())
        return false;

    // Make sure we still have a faceless in the outpost. If they are gone we cannot detect this
    // activity.
    if (OutpostState.GetNumFaceless() == 0)
    {
        return false;
    }

    // All special conditions met, use the standard formula for the rest
    return super.CanBeDetected(ActivityState, NewGameState);
}

function float GetMissionIncomeForUpdate(XComGameState_LWOutpost OutpostState)
{
	local float NewIncome;
    local XComGameState_Unit Liaison;
    local StateObjectReference LiaisonRef;
	local int Rank;

    LiaisonRef = OutpostState.GetLiaison();
    Liaison = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LiaisonRef.ObjectID));

    // Cannot detect unless the liaison is a soldier
    if (Liaison == none || !Liaison.IsSoldier())
        return 0.0f;

    // Make sure we still have a faceless in the outpost. If they are gone we cannot detect this
    // activity.
    if (OutpostState.GetNumFaceless() == 0)
    {
        return 0.0f;
    }

	//mission income based on soldier class and rank
	switch (Liaison.GetSoldierClassTemplateName())
	{
		case 'PsiOperative':
			Rank = Liaison.GetRank();
			Rank = Clamp(Rank, 0, LIAISON_MISSION_INCOME_PER_RANK_PSI.Length - 1);
			NewIncome = LIAISON_MISSION_INCOME_PER_RANK_PSI[Rank];
			break;
		case 'Spark':
			break;
		default:
			Rank = Liaison.GetRank();
			Rank = Clamp(Rank, 0, LIAISON_MISSION_INCOME_PER_RANK.Length - 1);
			NewIncome = LIAISON_MISSION_INCOME_PER_RANK[Rank];
			break;
	}

	if (class'LWOfficerUtilities'.static.IsOfficer(Liaison))
	{
		Rank = class'LWOfficerUtilities'.static.GetOfficerComponent(Liaison).GetOfficerRank();
		Rank = Clamp(Rank, 0, LIAISON_MISSION_INCOME_BONUS_PER_RANK_OFFICER.Length - 1);
		NewIncome += LIAISON_MISSION_INCOME_BONUS_PER_RANK_OFFICER[Rank];
	}

	NewIncome *= float(class'X2LWAlienActivityTemplate'.default.HOURS_BETWEEN_ALIEN_ACTIVITY_DETECTION_UPDATES) / 24.0;

	return NewIncome;
}

