//---------------------------------------------------------------------------------------
//  FILE:    UIUtilities_LW
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: Miscellanous UI helper routines
//---------------------------------------------------------------------------------------

class UIUtilities_LW extends Object config(LW_Overhaul);

var config array<name> EvacFlareMissions;
var config array<name> EvacFlareEscapeMissions;
var config array<name> FixedExitMissions;
var config array<name> DelayedEvacMissions;
var config array<name> NoEvacMissions;
var config array<name> ObjectiveTimerMissions;
var config array<name> EvacTimerMissions;
var config(LW_UI) bool USE_LARGE_INFO_PANEL;
var config(LW_UI) bool CENTER_TEXT_IN_LIP;

var const array<string> PlotTypes;

var localized string m_strInfiltrationMission;
var localized string m_strQuickResponseMission;
var localized string m_strFixedEvacLocation;
var localized string m_strFlareEvac;
var localized string m_strDelayedEvac;
var localized string m_strNoEvac;
var localized string m_strMaxSquadSize;
var localized string m_strConcealedStart;
var localized string m_strRevealedStart;
var localized string m_strObjectiveTimer;
var localized string m_strExtractionTimer;
var localized string m_strGetCorpses;
var localized string m_strSweepObjective;
var localized string m_strEvacRequired;
var localized string m_strTurnSingular;
var localized string m_strTurnPlural;
var localized string m_strMinimumInfiltration;
var localized string m_strYellowAlert;
var localized string m_sAverageScatterText;
var localized string m_strBullet;
var localized string m_strExpectedInfiltration;

var localized string m_strStripWeaponUpgrades;
var localized string m_strStripWeaponUpgradesLower;
var localized string m_strStripWeaponUpgradesConfirm;
var localized string m_strStripWeaponUpgradesConfirmDesc;
var localized string m_strTooltipStripWeapons;
var localized string m_strVIPCaptureReward;

// Initiate the process of taking a unit's picture. May immediately return the picture if it's available, or return none if the
// picture isn't yet available but will be taken asynchronously. The provided callback will be invoked when the picture is ready, and
// the caller should call FinishUnitPicture() when the callback is invoked.
function static Texture2D TakeUnitPicture(
	StateObjectReference UnitRef,
	delegate<X2Photobooth_AutoGenBase.OnAutoGenPhotoFinished> Callback)
{
	local Texture2D Pic;

    // First check to see if we already have one
	Pic = GetUnitPictureIfExists(UnitRef);

    // Nope: queue one up
	if (Pic == none)
	{
		`HQPRES.GetPhotoboothAutoGen().AddHeadShotRequest(UnitRef, 128, 128, Callback, , , true);
		`HQPRES.GetPhotoboothAutoGen().RequestPhotos();

		`GAME.GetGeoscape().m_kBase.m_kCrewMgr.TakeCrewPhotobgraph(UnitRef,,true);
	}

    return Pic;
}

// Complete an asynchronous unit picture request. Pass in the unit reference that is sent
// to the callback provided with TakeUnitPicture.
function static Texture2D FinishUnitPicture(StateObjectReference UnitRef)
{
	return GetUnitPictureIfExists(UnitRef);
}

// Borrowed from CI
static function string ColourText(string strValue, string strColour)
{
    return "<font color='#" $ strColour $ "'>" $ strValue $ "</font>";
}

function static Texture2D GetUnitPictureIfExists(StateObjectReference UnitRef)
{
	local XComGameState_CampaignSettings SettingsState;

	SettingsState = XComGameState_CampaignSettings(
		`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	return `XENGINE.m_kPhotoManager.GetHeadshotTexture(SettingsState.GameIndex, UnitRef.ObjectID, 128, 128);
}


// Read the evac delay in the strat layer
static function int GetCurrentEvacDelay (XComGameState_LWPersistentSquad Squad, XComGameState_LWAlienActivity ActivityState)
{
	local int EvacDelay, k;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit_LWOfficer OfficerState;

	if (Squad == none)
		return -1;

	EvacDelay = class'X2Ability_PlaceDelayedEvacZone'.default.DEFAULT_EVAC_PLACEMENT_DELAY[`TACTICALDIFFICULTYSETTING];

	EvacDelay += Squad.EvacDelayModifier_SquadSize();
	EvacDelay += Squad.EvacDelayModifier_Infiltration();
	EvacDelay += Squad.EvacDelayModifier_Missions();
	EvacDelay += ActivityState.GetMyTemplate().MissionTree[ActivityState.CurrentMissionLevel].EvacModifier;

	for (k = 0; k < Squad.SquadSoldiersOnMission.Length; k++)
	{
		UnitState = Squad.GetSoldier(k);
		if (class'LWOfficerUtilities'.static.IsOfficer(UnitState))
		{
			if (class'LWOfficerUtilities'.static.IsHighestRankOfficerinSquad(UnitState))
			{
				OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);
				if (OfficerState.HasOfficerAbility('AirController'))
				{
					EvacDelay -= class'X2Ability_OfficerAbilitySet'.default.AIR_CONTROLLER_EVAC_TURN_REDUCTION;
					break;
				}
			}
		}
	}

	EvacDelay = Clamp (EvacDelay, class'X2Ability_PlaceDelayedEvacZone'.default.MIN_EVAC_PLACEMENT_DELAY[`TACTICALDIFFICULTYSETTING], class'X2Ability_PlaceDelayedEvacZone'.default.MAX_EVAC_PLACEMENT_DELAY);

	return EvacDelay;

}


static function string GetTurnsLabel(int kounter)
{
	if (kounter == 1)
		return default.m_strTurnSingular;
	return default.m_strTurnPlural;
}

static function bool HasSweepObjective (XComGameState_MissionSite MissionState)
{
	local int ObjectiveIndex;

    ObjectiveIndex = 0;
    if(ObjectiveIndex < MissionState.GeneratedMission.Mission.MissionObjectives.Length)
    {
        if(instr(string(MissionState.GeneratedMission.Mission.MissionObjectives[ObjectiveIndex].ObjectiveName), "Sweep") != -1)
        {
            return true;
        }
    }
    return false;
}

static function bool FullSalvage (XComGameState_MissionSite MissionState)
{
	local int ObjectiveIndex;

    ObjectiveIndex = 0;
    if(ObjectiveIndex < MissionState.GeneratedMission.Mission.MissionObjectives.Length)
    {
        if(MissionState.GeneratedMission.Mission.MissionObjectives[ObjectiveIndex].bIsTacticalObjective)
        {
            return true;
        }
    }
    return false;
}

static function string GetMissionTypeString (StateObjectReference MissionRef)
{
	if (`LWSquadMgr.IsValidInfiltrationMission(MissionRef)) // && MissionState.ExpirationDateTime.m_iYear < 2100)
	{
		return default.m_strInfiltrationMission;
	}
	else
	{
		return default.m_strQuickResponseMission;
	}
}


static function string GetMissionConcealStatusString (StateObjectReference MissionRef)
{
	local MissionSchedule CurrentSchedule;
	local XComGameState_MissionSite MissionState;
	local int k;
	local XGParamTag LocTag;
	local string ExpandedString;

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));

	if (MissionState.SelectedMissionData.SelectedMissionScheduleName != '')
	{
		`TACTICALMISSIONMGR.GetMissionSchedule(MissionState.SelectedMissionData.SelectedMissionScheduleName, CurrentSchedule);
	}
	else
	{
		// No mission schedule yet. This generally only happens for missions that spawn outside geoscape elements, like avenger def.
		// Just look over the possible schedules and pick one to use. It may be wrong if the mission type changes concealment status
		// based on the schedule, but no current missions do this.
		`TACTICALMISSIONMGR.GetMissionSchedule(MissionState.GeneratedMission.Mission.MissionSchedules[0], CurrentSchedule);
	}

	if (CurrentSchedule.XComSquadStartsConcealed)
	{
		for (k = 0; k < `MIN_INFIL_FOR_CONCEAL.Length; k++)
		{
			if (MissionState.GeneratedMission.Mission.sType == `MIN_INFIL_FOR_CONCEAL[k].MissionType)
			{
				LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
				LocTag.IntValue0 = round (100 * `MIN_INFIL_FOR_CONCEAL[k].MinInfiltration);
				ExpandedString = `XEXPAND.ExpandString(default.m_strMinimumInfiltration);
				return ColourText(default.m_strConcealedStart @ ExpandedString, class'UIUtilities_Colors'.const.WARNING_HTML_COLOR);
			}
		}
		return ColourText(default.m_strConcealedStart, class'UIUtilities_Colors'.const.GOOD_HTML_COLOR);
	}
	else
	{
		return ColourText(default.m_strRevealedStart, class'UIUtilities_Colors'.const.BAD_HTML_COLOR);
	}
}

static function string GetTimerInfoString (XComGameState_MissionSite MissionState)
{
	local int Timer;

	Timer = class'SeqAct_InitializeMissionTimer'.static.GetInitialTimer(
		MissionState.GeneratedMission.Mission.sType,
		MissionState.GeneratedMission.Mission.MissionFamily);
	if (Timer > 0)
	{
		if (default.ObjectiveTimerMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
		{
			return default.m_strObjectiveTimer @ string(Timer - 1) @ GetTurnsLabel(Timer);
		}
		else
		{
			if (default.EvacTimerMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
			{
				if (default.FixedExitMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
				{
					return default.m_strExtractionTimer @ string(Timer - 1) $ "+" @ GetTurnsLabel(Timer);
				}
				else
				{
					return default.m_strExtractionTimer @ string(Timer - 1) @ GetTurnsLabel(Timer);
				}
			}
		}
	}
	return "";
}

static function string GetEvacTypeString (XComGameState_MissionSite MissionState)
{
	if (default.EvacFlareMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1 || default.EvacFlareEscapeMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
	{
		return default.m_strFlareEvac;
	}
	else
	{
		if (default.FixedExitMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
		{
			return default.m_strFixedEvacLocation;
		}
		else
		{
			if (default.DelayedEvacMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
			{
				return default.m_strDelayedEvac;
			}
			else
			{
				if (default.NoEvacMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1)
				{
					return default.m_strNoEvac;
				}
			}
		}
	}
	return "";
}

// Build the infiltration string for a mission - shows % infiltrated, time until 100% or
// mission expiry, and a description of the current advent alertedness modifier.
//
// WOTC TODO This function was moved from UIMission_LWLaunchDelayedMission so the infiltration
// info can be added to the mission brief panel. The various localized strings used here are
// still declared in that class and could be moved here, but this panel is still a work in progress
// and may change.
function static string GetInfiltrationString(XComGameState_MissionSite MissionState, XComGameState_LWAlienActivity ActivityState, XComGameState_LWPersistentSquad InfiltratingSquad)
{
	local string InfiltrationString;
	local XGParamTag ParamTag;
	local float TotalSeconds_Mission, TotalSeconds_Infiltration;
	local float TotalSeconds, TotalHours, TotalDays;
	local bool bExpiringMission, bCanFullyInfiltrate, bMustLaunch;
	local int AlertnessIndex, AlertModifier;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = int(InfiltratingSquad.CurrentInfiltration * 100.0);

	bExpiringMission = MissionState.ExpirationDateTime.m_iYear < 2050;
	bMustLaunch = ActivityState != none && ActivityState.bMustLaunch;

	if(bMustLaunch)
	{
		InfiltrationString = `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusNonExpiring);
	}
	else if(bExpiringMission)
	{
		//determine if can fully infiltrate before mission expires
		TotalSeconds_Mission = ActivityState.SecondsRemainingCurrentMission();
		TotalSeconds_Infiltration = InfiltratingSquad.GetSecondsRemainingToFullInfiltration();

		bCanFullyInfiltrate = (TotalSeconds_Infiltration < TotalSeconds_Mission) && (InfiltratingSquad.CurrentInfiltration < 1.0);
		if(bCanFullyInfiltrate)
		{
			TotalSeconds = TotalSeconds_Infiltration;
		}
		else
		{
			TotalSeconds = TotalSeconds_Mission;
		}
		TotalHours = int(TotalSeconds / 3600.0) % 24;
		TotalDays = TotalSeconds / 86400.0;
		ParamTag.IntValue1 = int(TotalDays);
		ParamTag.IntValue2 = int(TotalHours);

		if(bCanFullyInfiltrate && InfiltratingSquad.CurrentInfiltration < 1.0)
			InfiltrationString = `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusExpiring);
		else
			InfiltrationString = `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusMissionEnding);
	}
	else // mission does not expire
	{
		//ID 619 - allow non-expiring missions to show remaining time until 100% infiltration will be reached
		if (InfiltratingSquad.CurrentInfiltration < 1.0)
		{
			TotalSeconds = InfiltratingSquad.GetSecondsRemainingToFullInfiltration();
			TotalHours = int(TotalSeconds / 3600.0) % 24;
			TotalDays = TotalSeconds / 86400.0;
			ParamTag.IntValue1 = int(TotalDays);
			ParamTag.IntValue2 = int(TotalHours);
			InfiltrationString = `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusExpiring);
		}
		else
		{
			InfiltrationString = `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusNonExpiring);
		}
	}

	InfiltrationString $= "\n";

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	AlertModifier = InfiltratingSquad.GetAlertnessModifierForCurrentInfiltration(,, AlertnessIndex);
	ParamTag.StrValue0 = class'UIMission_LWLaunchDelayedMission'.default.m_strAlertnessModifierDescriptions[AlertnessIndex];
	if (false) // for debugging only !
		ParamTag.StrValue0 $= " (" $ AlertModifier $ ")";
	InfiltrationString $= `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationConsequence);

	return InfiltrationString;
}

function static string GetBoostedInfiltrationString(XComGameState_MissionSite MissionState, XComGameState_LWAlienActivity ActivityState, XComGameState_LWPersistentSquad InfiltratingSquad)
{
	local string InfiltrationString;
	local XGParamTag ParamTag;
	local float TotalSeconds_Mission, TotalSeconds_Infiltration;
	local float TotalSeconds, TotalHours, TotalDays, BoostFactor;
	local bool bExpiringMission, bCanFullyInfiltrate, bMustLaunch;

	local XComGameState_LWPersistentSquad Squad;
	local StrategyCost BoostInfiltrationCost;
	local array<StrategyCostScalar> CostScalars;

	BoostFactor = class'XComGameState_LWPersistentSquad'.default.DefaultBoostInfiltrationFactor[`STRATEGYDIFFICULTYSETTING];

	Squad =  `LWSQUADMGR.GetSquadOnMission(MissionState.GetReference());
	BoostInfiltrationCost = Squad.GetBoostInfiltrationCost();
	CostScalars.Length = 0;

	InfiltrationString = "Cost:" @ class'UIUtilities_Strategy'.static.GetStrategyCostString(BoostInfiltrationCost, CostScalars);
	InfiltrationString $= "\n";

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = int(InfiltratingSquad.CurrentInfiltration * 100.0 * BoostFactor);

	bExpiringMission = MissionState.ExpirationDateTime.m_iYear < 2050;
	bMustLaunch = ActivityState != none && ActivityState.bMustLaunch;

	InfiltrationString $= default.m_strExpectedInfiltration $": ";

	if(bMustLaunch)
	{
		InfiltrationString $= `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusNonExpiring);
	}
	else if(bExpiringMission)
	{
		//determine if can fully infiltrate before mission expires / boosted state
		TotalSeconds_Mission = ActivityState.SecondsRemainingCurrentMission();
		TotalSeconds_Infiltration = InfiltratingSquad.GetSecondsRemainingToFullInfiltration(true);

		bCanFullyInfiltrate = (TotalSeconds_Infiltration < TotalSeconds_Mission) && (InfiltratingSquad.CurrentInfiltration * BoostFactor < 1.0);
		if(bCanFullyInfiltrate)
		{
			TotalSeconds = TotalSeconds_Infiltration ;
		}
		else
		{
			TotalSeconds = TotalSeconds_Mission;
		}
		TotalHours = int(TotalSeconds / 3600.0) % 24 ;
		TotalDays = TotalSeconds / 86400.0;
		ParamTag.IntValue1 = int(TotalDays);
		ParamTag.IntValue2 = int(TotalHours);

		if(bCanFullyInfiltrate && InfiltratingSquad.CurrentInfiltration * BoostFactor < 1.0)
			InfiltrationString $= `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusNonExpiring);
		else
			InfiltrationString $= `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusMissionEnding);
	}
	else // mission does not expire
	{
		//ID 619 - allow non-expiring missions to show remaining time until 100% infiltration will be reached
		if (InfiltratingSquad.CurrentInfiltration < 1.0)
		{
			TotalSeconds = InfiltratingSquad.GetSecondsRemainingToFullInfiltration();
			TotalHours = int(TotalSeconds / 3600.0) % 24;
			TotalDays = TotalSeconds / 86400.0;
			ParamTag.IntValue1 = int(TotalDays);
			ParamTag.IntValue2 = int(TotalHours);
			InfiltrationString = `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusExpiring);
		}
		else
		{
			InfiltrationString = `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInfiltrationStatusNonExpiring);
		}
	}

	InfiltrationString $= "\n";

	InfiltrationString $= class'UISquadSelect_InfiltrationPanel'.default.ExpectedActivityTextStr $ ": ";

	//
	InfiltrationString $= class'UIUtilities_Text_LW'.static.GetDifficultyString(MissionState, GetExpectedAlertModifier(MissionState, float(ParamTag.IntValue0)/100));

	return InfiltrationString;
}

static function int GetExpectedAlertModifier(XComGameState_MissionSite MissionState, float InfiltrationPct)
{
	local int i, AlertModifier;
	i = 0;
	while (i + 1 < class'XComGameState_LWPersistentSquad'.default.AlertModifierAtInfiltration.Length 
			&& class'XComGameState_LWPersistentSquad'.default.AlertModifierAtInfiltration[i + 1].Infiltration <= InfiltrationPct)
	{
		i++;
	}
	// use current mission data to minus out the change since GetDifficultyString uses the current alert on the mission, so we need to remove it from the modifier as well to get the proper modifier relative for the boost.
	AlertModifier = class'XComGameState_LWPersistentSquad'.default.AlertModifierAtInfiltration[i].Modifier + `LWACTIVITYMGR.GetMissionAlertLevel(MissionState)- MissionState.SelectedMissionData.AlertLevel;
	// `LWACTIVITYMGR.GetMissionAlertLevel(MissionState)
	`LWTrace("Alert boost %:"@ InfiltrationPct);
	`LWTrace("new modifier =" @ class'XComGameState_LWPersistentSquad'.default.AlertModifierAtInfiltration[i].Modifier @ "Activity Alert level:" @`LWACTIVITYMGR.GetMissionAlertLevel(MissionState) @"Mission Current Alert Level:" @ MissionState.SelectedMissionData.AlertLevel @ "Boost tooltip modifier:" @AlertModifier);
	return AlertModifier;
}

static function GetMissionInfoPanelText(StateObjectReference MissionRef, bool IsInfiltrating,
	out string TitleString, out string InfiltrationString, out string ExpirationString, out string MissionInfo1String,
	out string MissionInfo2String)
{
	local int EvacFlareTimer, EvacDelayDiff;
	local float HoursRemaining;
	local string Header, TimeRemaining, ExpirationTime, MissionType, EvacTurns, SquadSize, MissionTurns, SweepInfo,
		FullSalvageInfo, RendezvousInfo, ConcealmentInfo, InfiltrationInfo, MissionInfo1, MissionInfo2, EvacTimerColor;
	local X2CharacterTemplate FacelessTemplate;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_LWPersistentSquad InfiltratingSquad;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_MissionSite MissionState;
	local XComGameState_MissionSiteRendezvous_LW RendezvousMissionState;

	SquadMgr = `LWSQUADMGR;
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));
	InfiltratingSquad = SquadMgr.GetSquadOnMission(MissionRef);
	ActivityState = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);

	// ------------- Get header -------------------------------
	Header = class'UIMissionIntro'.default.m_strMissionTitle;
	Header -= ":";

	// ------------- Get infiltration info --------------------
	InfiltrationInfo = IsInfiltrating ? GetInfiltrationString(MissionState, ActivityState, InfiltratingSquad) : "";

	// ------------- Get mission expiration time --------------
	if (ActivityState != none)
	{
		HoursRemaining = int(ActivityState.SecondsRemainingCurrentMission() / 3600.0);
	}
	else
	{
		HoursRemaining = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(
			MissionState.ExpirationDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()) / 3600.0;
	}
	TimeRemaining = class'UISquadSelect_InfiltrationPanel'.static.GetDaysAndHoursString(HoursRemaining);

	ExpirationTime = "";
	if (HoursRemaining >= 0.0 &&
		HoursRemaining <= 10000.0 &&
		MissionState.ExpirationDateTime.m_iYear < 2100)
	{
		if (ActivityState != none && ActivityState.bMustLaunch)
		{
			ExpirationTime = class'UIMission_LWLaunchDelayedMission'.default.m_strMustLaunchMission;
		}
		else
		{
			ExpirationTime = class'UISquadSelect_InfiltrationPanel'.default.strMissionTimeTitle @ TimeRemaining;
		}
	}

	// ------------- Get mission type -------------------------
	MissionType = GetMissionTypeString(MissionRef);

	// ------------- Get mission evacuation time --------------
	if (InfiltratingSquad != none)
	{
		EvacFlareTimer = GetCurrentEvacDelay(InfiltratingSquad, ActivityState);
	}
	else
	{
		EvacFlareTimer = -1;
	}

	EvacTurns = "";
	if (GetEvacTypeString(MissionState) != "")
	{
		EvacTurns = GetEvacTypeString(MissionState);
		if (EvacFlareTimer >= 0 &&
			(default.EvacFlareMissions.Find(MissionState.GeneratedMission.Mission.MissionName) != -1 ||
			default.EvacFlareEscapeMissions.Find(MissionState.GeneratedMission.Mission.MissionName) != -1))
		{
			EvacDelayDiff = EvacFlareTimer - class'X2Ability_PlaceDelayedEvacZone'.default.DEFAULT_EVAC_PLACEMENT_DELAY[`TACTICALDIFFICULTYSETTING];
			
			switch (EvacDelayDiff)
			{
				case 0:
					EvacTimerColor = class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR;
					break;
				case 1:
					EvacTimerColor = class'UIUtilities_Colors'.const.WARNING_HTML_COLOR;
					break;
				default:
					if(EvacDelayDiff < 0)
					{
						EvacTimerColor = class'UIUtilities_Colors'.const.GOOD_HTML_COLOR;
					}
					else
					{
						EvacTimerColor = class'UIUtilities_Colors'.const.BAD_HTML_COLOR;
					}
					break;

			}


			EvacTurns @= ColourText("(" $ string(EvacFlareTimer) @ GetTurnsLabel(EvacFlareTimer) $ ")", EvacTimerColor);
		}
	}

	// ------------- Get mission squad size -------------------
	SquadSize = default.m_strMaxSquadSize @ string(MissionState.GeneratedMission.Mission.MaxSoldiers);

	// ------------- Get mission time limit -------------------
	MissionTurns = GetTimerInfoString(MissionState);

	// ------------- Get mission 'sweep' status ---------------
	SweepInfo = HasSweepObjective(MissionState) ? default.m_strSweepObjective : "";

	// ------------- Get mission 'salvage' status -------------
	FullSalvageInfo = FullSalvage(MissionState) ? default.m_strGetCorpses : "";

	// ------------- Get rendezvous info ----------------------
	RendezvousInfo = "";
	if (MissionState.GeneratedMission.Mission.sType == "Rendezvous_LW")
	{
		RendezvousMissionState = XComGameState_MissionSiteRendezvous_LW(MissionState);
		FacelessTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('Faceless');
		RendezvousInfo = FacelessTemplate.strCharacterName $ ":" @ RendezvousMissionState.FacelessSpies.Length;
	}

	// ------------- Get mission concealment status -----------
	ConcealmentInfo = GetMissionConcealStatusString(MissionRef);

	// ------------- Set up strings similar to LW2 ------------
	InfiltrationInfo $= (InfiltrationInfo != "") ? "\n" : "";

	ExpirationTime $= (ExpirationTime != "") ? "\n" : "";

	MissionInfo1 = MissionType @ default.m_strBullet $ " ";
	MissionInfo1 $= (EvacTurns != "") ? EvacTurns @ default.m_strBullet $ " " : "";
	MissionInfo1 $= SquadSize;

	MissionInfo2 = MissionTurns;
	MissionInfo2 $= (MissionTurns != "") ? " " $ default.m_strBullet $ " " : "";
	MissionInfo2 $= (SweepInfo != "") ? SweepInfo @ default.m_strBullet $ " " : "";
	MissionInfo2 $= (FullSalvageInfo != "") ? FullSalvageInfo @ default.m_strBullet $ " " : "";
	MissionInfo2 $= (RendezvousInfo != "") ? RendezvousInfo @ default.m_strBullet $ " " : "";
	MissionInfo2 $= ConcealmentInfo @ default.m_strBullet $ " ";
	MissionInfo2 $= class'UIUtilities_LW'.static.GetPlotTypeFriendlyName(MissionState.GeneratedMission.Plot.strType);

	TitleString = Header;
	InfiltrationString = InfiltrationInfo;
	ExpirationString = ExpirationTime;
	MissionInfo1String = MissionInfo1;
	MissionInfo2String = MissionInfo2;
}

static function BuildMissionInfoPanel(UIScreen ParentScreen, StateObjectReference MissionRef, bool IsInfiltrating)
{
	local int LinesOfText, TextContainerY, TextContainerHeight;
	local string TitleString, BodyString, InfiltrationString, ExpirationString, MissionInfo1String, MissionInfo2String;
	local array<string> StringArray;
	local UIBGBox MissionExpiryBG;
	local UIPanel DividerLine, MissionExpiryPanel;
	// KDM : LW's UIVerticalScrollingText2 is being used instead of the base game's UITextContainer because
	// they fixed a bug whereby text, starting outside of the text container's visible area, would remain invisible
	// even when scrolling into view.
	local UIVerticalScrollingText2 MissionExpiryText;
	local UIX2PanelHeader MissionExpiryTitle;

	// LW : If the 'Mission Expiry' panel already exists then remove it; it needs to be refreshed.
	MissionExpiryPanel = ParentScreen.GetChildByName('ExpiryPanel', false);
	if (MissionExpiryPanel != none)
	{
		MissionExpiryPanel.Remove();
	}

	// ---------------- Create container panel ----------------
	MissionExpiryPanel = ParentScreen.Spawn(class'UIPanel', ParentScreen);
	// KDM : Make sure MissionExpiryPanel isn't navigable because :
	// 1.] It shouldn't be navigable in the first place.
	// 2.] It messes up controller and arrow key navigation within the infiltration screen, UIMission_LWLaunchDelayedMission.
	MissionExpiryPanel.bIsNavigable = false;
	MissionExpiryPanel.InitPanel('ExpiryPanel');
	if (default.USE_LARGE_INFO_PANEL)
	{
		MissionExpiryPanel.SetPosition(700, 150);
	}
	else
	{
		MissionExpiryPanel.SetPosition(725, 180);
	}
	
	// ---------------- Create background ---------------------
	MissionExpiryBG = ParentScreen.Spawn(class'UIBGBox', MissionExpiryPanel);
	MissionExpiryBG.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	// LW : Adjust the background size depending on whether or not we are infiltrating; the infiltation
	// status string needs extra lines in a large-ish font.
	if (default.USE_LARGE_INFO_PANEL)
	{
		MissionExpiryBG.InitBG('ExpiryBG', 0, 0, 520, IsInfiltrating ? 270 : 200);
	}
	else
	{
		MissionExpiryBG.InitBG('ExpiryBG', 0, 0, 470, IsInfiltrating ? 200 : 130);
	}

	MissionExpiryBG.SetTooltipText("This is a test tooltip");

	//MissionExpiryPanel.ProcessMouseEvents(MissionExpiryBG.OnChildMouseEvent);

	// ---------------- Create text container -----------------
	GetMissionInfoPanelText(MissionRef, IsInfiltrating, TitleString, InfiltrationString,
		ExpirationString, MissionInfo1String, MissionInfo2String);
	if (default.USE_LARGE_INFO_PANEL)
	{
		BodyString = class'UIUtilities_Text'.static.GetSizedText(InfiltrationString $ ExpirationString, 26);
		if (default.CENTER_TEXT_IN_LIP)
		{
			BodyString = class'UIUtilities_Text'.static.AlignCenter(BodyString);
		}
	}
	else
	{
		BodyString = InfiltrationString $ ExpirationString $
			class'UIUtilities_Text'.static.GetSizedText(MissionInfo1String $ "\n" $ MissionInfo2String, 16);
	}
	MissionExpiryTitle = ParentScreen.Spawn(class'UIX2PanelHeader', MissionExpiryPanel);
	// KDM : Make sure MissionExpiryTitle isn't navigable; the reasoning is the same as for MissionExpiryPanel above.
	MissionExpiryTitle.bIsNavigable = false;
	// KDM : DO NOT use SetText on a UIX2PanelHeader since it doesn't work; the only way I have ever been
	// able to get UIX2PanelHeader's to work is by initializing them, via InitPanelHeader, with the strings
	// you want them to show. I think something must be messed up in the Flash back-end.
	MissionExpiryTitle.InitPanelHeader('MissionExpiryTitle', TitleString, BodyString);
	MissionExpiryTitle.SetHeaderWidth(MissionExpiryBG.Width - 20);
	MissionExpiryTitle.SetPosition(MissionExpiryBG.X + 10, MissionExpiryBG.Y + 10);

	// --------- Create second text container if --------------
	// --------- using the large information panel ------------
	if (default.USE_LARGE_INFO_PANEL)
	{
		if (InfiltrationString == "" && ExpirationString == "")
		{
			LinesOfText = 0;
		}
		else
		{
			StringArray = SplitString(BodyString, "\n", true);
			LinesOfText = StringArray.Length - 1;
		}

		// KDM : If infiltration information and/or expiration information exists then place a dividing line
		// below them; this will help separate 'main' information from 'other' information.
		if (LinesOfText > 0)
		{
			// ---------------- Create divider line -------------------
			DividerLine = ParentScreen.Spawn(class'UIPanel', MissionExpiryPanel);
			DividerLine.bAnimateOnInit = false;
			DividerLine.bIsNavigable = false;
			DividerLine.InitPanel('DividerLine', class'UIUtilities_Controls'.const.MC_GenericPixel);
			DividerLine.SetColor(class'UIUtilities_Colors'.const.WHITE_HTML_COLOR);
			DividerLine.SetSize(MissionExpiryBG.Width - 20, 2);
			DividerLine.SetPosition(MissionExpiryBG.X + 10, MissionExpiryBG.Y + 50 + LinesOfText * 33);
			DividerLine.SetAlpha(30);
		}

		TextContainerY = LinesOfText > 0 ? DividerLine.Y + 10 : MissionExpiryBG.Y + 50;
		TextContainerHeight = MissionExpiryBG.Height - TextContainerY - 10;

		// -------------- Create second text container ------------
		MissionExpiryText = ParentScreen.Spawn(class'UIVerticalScrollingText2', MissionExpiryPanel);
		MissionExpiryText.bAnimateOnInit = false;
		MissionExpiryText.InitVerticalScrollingText('MissionExpiryText', "Expiry Text", MissionExpiryBG.X + 10,
			TextContainerY, MissionExpiryBG.Width - 20, TextContainerHeight);
		BodyString = (MissionInfo1String == "" || MissionInfo2String == "") ?
			MissionInfo1String $ MissionInfo2String :
			MissionInfo1String $ " " $ default.m_strBullet $ " " $ MissionInfo2String;
		BodyString = class'UIUtilities_Text'.static.GetSizedText(BodyString, 23);
		if (default.CENTER_TEXT_IN_LIP)
		{
			BodyString = class'UIUtilities_Text'.static.AlignCenter(BodyString);
		}
		MissionExpiryText.SetHTMLText(BodyString);
	}

	MissionExpiryPanel.Show();
}

// Returns a player-friendly name for the given plot type, so they
// know what map type they'll be playing on
static function string GetPlotTypeFriendlyName(string PlotType)
{
	local int i;

	// Use the multiplayer localisation to get the friendly name for a given plot type
	i = default.PlotTypes.Find(PlotType);

	if (i == INDEX_NONE)
	{
		`REDSCREEN("Unknown plot type '" $ PlotType $ "' encountered in GetPlotTypeFriendlyName()");
		return "???";
	}
	else
	{
		return class'X2MPData_Shell'.default.arrMPMapFriendlyNames[i];
	}
}

static function vector2d GetMouseCoords()
{
	local PlayerController PC;
	local PlayerInput kInput;
	local vector2d vMouseCursorPos;

	foreach `XWORLDINFO.AllControllers(class'PlayerController',PC)
	{
		if ( PC.IsLocalPlayerController() )
		{
			break;
		}
	}
	kInput = PC.PlayerInput;

	XComTacticalInput(kInput).GetMouseCoordinates(vMouseCursorPos);
	return vMouseCursorPos;
}

static function string GetHTMLAverageScatterText(float value, optional int places = 2)
{
	local XGParamTag LocTag;
	local string ReturnString, FloatString, TempString;
	local int i;
	local float TempFloat, TestFloat;

	TempFloat = value;
	for (i=0; i< places; i++)
	{
		TempFloat *= 10.0;
	}
	TempFloat = Round(TempFloat);
	for (i=0; i< places; i++)
	{
		TempFloat /= 10.0;
	}

	TempString = string(TempFloat);
	for (i = InStr(TempString, ".") + 1; i < Len(TempString) ; i++)
	{
		FloatString = Left(TempString, i);
		TestFloat = float(FloatString);
		if (TempFloat ~= TestFloat)
		{
			break;
		}
	}

	if (Right(FloatString, 1) == ".")
	{
		FloatString $= "0";
	}

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = FloatString;
	ReturnString = `XEXPAND.ExpandString(default.m_sAverageScatterText);

	return class'UIUtilities_Text'.static.GetColoredText(ReturnString, eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
}

static function bool ShouldShowPsiOffense(XComGameState_Unit UnitState)
{
	return UnitState.IsPsiOperative() ||
		(UnitState.GetRank() == 0 && !UnitState.CanRankUpSoldier() && `XCOMHQ.IsTechResearched('AutopsySectoid'));
}

// KDM : Adds a UIButton, if it exists and is visible, to a UIScreen's Navigator; furthermore, it selects this button
// if SelectionSet was false.
simulated static function bool AddBtnToNavigatorAndSelect(UIScreen TheScreen, UIButton TheButton, bool SelectionSet)
{
	if (TheButton != none && TheButton.bIsVisible)
	{
		TheScreen.Navigator.AddControl(TheButton);
		if (!SelectionSet)
		{
			TheScreen.Navigator.SetSelected(TheButton);
			return true;
		}
	}

	return SelectionSet;
}

defaultproperties
{
	PlotTypes[0]="Duel"
	PlotTypes[1]="Facility"
	PlotTypes[2]="SmallTown"
	PlotTypes[3]="Shanty"
	PlotTypes[4]="Slums"
	PlotTypes[5]="Wilderness"
	PlotTypes[6]="CityCenter"
	PlotTypes[7]="Rooftops"
	PlotTypes[8]="Abandoned"
	PlotTypes[9]="Tunnels_Sewer"
	PlotTypes[10]="Tunnels_Subway"
	PlotTypes[11]="Stronghold"
}
