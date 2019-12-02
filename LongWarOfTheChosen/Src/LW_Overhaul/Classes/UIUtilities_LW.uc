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
				return default.m_strConcealedStart @ ExpandedString;
			}
		}
		return default.m_strConcealedStart;
	}
	else
	{
		return default.m_strRevealedStart;
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

function static BuildMissionInfoPanel(UIScreen ParentScreen, StateObjectReference MissionRef, bool IsInfiltrating)
{
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_MissionSite MissionState;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_LWPersistentSquad InfiltratingSquad;
	local UIPanel MissionExpiryPanel;
	local UIBGBox MissionExpiryBG;
	local UIX2PanelHeader MissionExpiryTitle;
	local XComGameState_MissionSiteRendezvous_LW RendezvousMissionState;
	local X2CharacterTemplate FacelessTemplate;
	local String MissionTime;
	local float TotalMissionHours;
	local string MissionInfoTimer, MissionInfo1, MissionInfo2, HeaderStr, InfilInfo;
	local int EvacFlareTimer;

	SquadMgr = `LWSQUADMGR;
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));

	//if (SquadMgr.IsValidInfiltrationMission(MissionRef) &&
			//MissionState.ExpirationDateTime.m_iYear < 2100)

	ActivityState = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);
	if(ActivityState != none)
		TotalMissionHours = int(ActivityState.SecondsRemainingCurrentMission() / 3600.0);
	else
		TotalMissionHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(MissionState.ExpirationDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()) / 3600.0;
	MissionInfoTimer = "";

	InfiltratingSquad = SquadMgr.GetSquadOnMission(MissionRef);
	if (IsInfiltrating)
	{
		InfilInfo = GetInfiltrationString(MissionState, ActivityState, InfiltratingSquad) $ "\n";
	}
	MissionInfo1 = "<font size=\"16\">";
	MissionInfo1 $= GetMissionTypeString (MissionRef) @ default.m_strBullet $ " ";

	if (InfiltratingSquad != none)
	{
		EvacFlareTimer = GetCurrentEvacDelay(SquadMgr.GetSquadOnMission(MissionRef),ActivityState);
	}
	else
	{
		EvacFlareTimer = -1;
	}
	if (GetEvacTypeString (MissionState) != "")
	{
		MissionInfo1 $= GetEvacTypeString (MissionState);
		if (EvacFlareTimer >= 0 && (default.EvacFlareMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1 || default.EvacFlareEscapeMissions.Find (MissionState.GeneratedMission.Mission.MissionName) != -1))
		{
			MissionInfo1 @= "(" $ string (EvacFlareTimer) @ GetTurnsLabel(EvacFlareTimer) $ ")";
		}
		MissionInfo1 @= default.m_strBullet $ " ";
	}
	MissionInfo1 $= default.m_strMaxSquadSize @ string(MissionState.GeneratedMission.Mission.MaxSoldiers);
	MissionInfo2 = "";
	MissionInfo2 $= GetTimerInfoString (MissionState);
	if (GetTimerInfoString (MissionState) != "")
	{
		MissionInfo2 @= default.m_strBullet $ " ";
	}
	if (HasSweepObjective(MissionState))
	{
		MissionInfo2 $= default.m_strSweepObjective @ default.m_strBullet $ " ";
	}
	if (FullSalvage(MissionState))
	{
		MissionInfo2 $= default.m_strGetCorpses @ default.m_strBullet $ " ";
	}

    if (MissionState.GeneratedMission.Mission.sType == "Rendezvous_LW")
	{
		RendezvousMissionState = XComGameState_MissionSiteRendezvous_LW(MissionState);
		FacelessTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('Faceless');
		MissionInfo2 $= FacelessTemplate.strCharacterName $ ":" @ RendezvousMissionState.FacelessSpies.Length @ default.m_strBullet $ " ";
	}
	MissionInfo2 $= GetMissionConcealStatusString (MissionRef);
	MissionTime = class'UISquadSelect_InfiltrationPanel'.static.GetDaysAndHoursString(TotalMissionHours);

	// Try to find an existing panel first. If we have one, remove it - we need to refresh.
	MissionExpiryPanel = ParentScreen.GetChildByName('ExpiryPanel', false);
	if (MissionExpiryPanel != none)
	{
		MissionExpiryPanel.Remove();
	}
	MissionExpiryPanel = ParentScreen.Spawn(class'UIPanel', ParentScreen);
	MissionExpiryPanel.InitPanel('ExpiryPanel').SetPosition(725, 180);
	MissionExpiryBG = ParentScreen.Spawn(class'UIBGBox', MissionExpiryPanel);
	MissionExpiryBG.LibID = class'UIUtilities_Controls'.const.MC_X2Background;

	// Adjust the panel size depending on whether or not we are infiltrating - the infiltation
	// status string needs some extra lines in a large-ish font.
	MissionExpiryBG.InitBG('ExpiryBG', 0, 0, 470, IsInfiltrating ? 200 : 130);
	MissionExpiryTitle = ParentScreen.Spawn(class'UIX2PanelHeader', MissionExpiryPanel);

	if (TotalMissionHours >= 0.0 && TotalMissionHours <= 10000.0 && MissionState.ExpirationDateTime.m_iYear < 2100)
	{
		if (ActivityState != none && ActivityState.bMustLaunch)
		{
			MissionInfoTimer = class'UIMission_LWLaunchDelayedMission'.default.m_strMustLaunchMission $ "\n";
		}
		else
		{
			MissionInfoTimer = class'UISquadSelect_InfiltrationPanel'.default.strMissionTimeTitle @ MissionTime $ "\n";
		}
	}

	HeaderStr = class'UIMissionIntro'.default.m_strMissionTitle;
	HeaderStr -= ":";
	MissionExpiryTitle.InitPanelHeader('MissionExpiryTitle',
										HeaderStr,
										InfilInfo $ MissionInfoTimer $ MissionInfo1 $ "\n" $ MissionInfo2 $ "</font>");
	MissionExpiryTitle.SetHeaderWidth(MissionExpiryBG.Width - 20);
	MissionExpiryTitle.SetPosition(MissionExpiryBG.X + 10, MissionExpiryBG.Y + 10);
	MissionExpiryPanel.Show();
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
