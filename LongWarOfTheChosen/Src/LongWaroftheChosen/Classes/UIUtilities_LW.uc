//---------------------------------------------------------------------------------------
//  FILE:    UIUtilities_LW
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: Miscellanous UI helper routines
//---------------------------------------------------------------------------------------

class UIUtilities_LW extends Object config(LW_Overhaul);

//`include(LongWaroftheChosen\Src\LW_Overhaul.uci)

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
/* WOTC TODO: Restore when I know how to take photos. Looks like the new Photo Booth may be able to do the job. Required
   by UIOutpostManagement.
function static Texture2D TakeUnitPicture(StateObjectReference UnitRef, delegate<XComPhotographer_Strategy.OnPhotoRequestFinished> Callback)
{
    local XComPhotographer_Strategy Photographer;
	local X2ImageCaptureManager CapMan;
	local Texture2D Pic;

    CapMan = X2ImageCaptureManager(`XENGINE.GetImageCaptureManager());
	Photographer = `GAME.StrategyPhotographer;

    // First check to see if we already have one
	Pic = CapMan.GetStoredImage(UnitRef, name("UnitPictureSmall"$UnitRef.ObjectID));

    // Nope: queue one up
	if (Pic == none)
	{
		// if we have a photo queued then setup a callback so we can swap in the image when it is taken
		if (!Photographer.HasPendingHeadshot(UnitRef, Callback, true))
		{
			Photographer.AddHeadshotRequest(UnitRef, 'UIPawnLocation_ArmoryPhoto', 'SoldierPicture_Passport_Armory', 128, 128, Callback, class'X2StrategyElement_DefaultSoldierPersonalities'.static.Personality_ByTheBook(),,true);
		}

		`GAME.GetGeoscape().m_kBase.m_kCrewMgr.TakeCrewPhotobgraph(UnitRef,,true);
	}

    return Pic;
}

// Complete an asynchronous unit picture request. May return 'none' if the callback was invoked for a picture other than the one we expected.
function static Texture2D FinishUnitPicture(StateObjectReference UnitRef, const out HeadshotRequestInfo ReqInfo, TextureRenderTarget2D RenderTarget)
{
    local X2ImageCaptureManager CapMan;
    local Texture2D Picture;
    local String TextureName;

    // Is this our picture?
    if (ReqInfo.UnitRef.ObjectID != UnitRef.ObjectID)
        return none;

    // Is it the right size?
    if (ReqInfo.Height != 128)
        return none;

    TextureName = "UnitPictureSmall"$ReqInfo.UnitRef.ObjectID;
    CapMan = X2ImageCaptureManager(`XENGINE.GetImageCaptureManager());
    Picture = RenderTarget.ConstructTexture2DScript(CapMan, TextureName, false, false, false);
    CapMan.StoreImage(ReqInfo.UnitRef, Picture, name(TextureName));

    return Picture;
}
*/


// Read the evac delay in the strat layer
/* WOTC TODO: Restore when XComGameState_LWPersistentSquad is added back in
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
*/

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
	//local XComGameState_MissionSite MissionState;

	//MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionRef.ObjectID));

	/* WOTC TODO: Restore when LWSquadManager is added back in
	if (`LWSquadMgr.IsValidInfiltrationMission(MissionRef)) // && MissionState.ExpirationDateTime.m_iYear < 2100)
	{
		return default.m_strInfiltrationMission;
	}
	else
	{
	*/
		return default.m_strQuickResponseMission;
	//}
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
		for (k = 0; k < class'XComGameState_LWListenerManager'.default.MINIMUM_INFIL_FOR_CONCEAL.length; k++)
		{
			if (MissionState.GeneratedMission.Mission.sType == class'XComGameState_LWListenerManager'.default.MINIMUM_INFIL_FOR_CONCEAL[k].MissionType)
			{
				LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
				LocTag.IntValue0 = round (100 * class'XComGameState_LWListenerManager'.default.MINIMUM_INFIL_FOR_CONCEAL[k].MinInfiltration);
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

	Timer = class'SeqAct_InitializeMissionTimer'.static.GetInitialTimer (MissionState.GeneratedMission.Mission.MissionFamily);
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


/* WOTC TODO: Restore when the squad manager is back
function static BuildMissionInfoPanel(UIScreen ParentScreen, StateObjectReference MissionRef)
{
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_MissionSite MissionState;
	local XComGameState_LWAlienActivity ActivityState;
	local UIPanel MissionExpiryPanel;
	local UIBGBox MissionExpiryBG;
	local UIX2PanelHeader MissionExpiryTitle;
	local XComGameState_MissionSiteRendezvous_LW RendezvousMissionState;
	local X2CharacterTemplate FacelessTemplate;
	local String MissionTime;
	local float TotalMissionHours;
	local string MissionInfoTimer, MissionInfo1, MissionInfo2, HeaderStr;
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
	MissionInfo1 = "<font size=\"16\">";
	MissionInfo1 $= GetMissionTypeString (MissionRef) @ default.m_strBullet $ " ";

	if (SquadMgr.GetSquadOnMission(MissionRef) != none)
	{
		// WOTC TODO: Restore when LW_PersistentSquad is added
		//EvacFlareTimer = GetCurrentEvacDelay(SquadMgr.GetSquadOnMission(MissionRef),ActivityState);
		EvacFlareTime = -1;
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
	MissionExpiryPanel.InitPanel('ExpiryPanel').SetPosition(725, 800);
	MissionExpiryBG = ParentScreen.Spawn(class'UIBGBox', MissionExpiryPanel);
	MissionExpiryBG.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	MissionExpiryBG.InitBG('ExpiryBG', 0, 0, 470, 130);
	MissionExpiryTitle = ParentScreen.Spawn(class'UIX2PanelHeader', MissionExpiryPanel);

	if (TotalMissionHours >= 0.0 && TotalMissionHours <= 10000.0 && MissionState.ExpirationDateTime.m_iYear < 2100)
		MissionInfoTimer = class'UISquadSelect_InfiltrationPanel'.default.strMissionTimeTitle @ MissionTime $ "\n";

	HeaderStr = class'UIMissionIntro'.default.m_strMissionTitle;
	HeaderStr -= ":";
	MissionExpiryTitle.InitPanelHeader('MissionExpiryTitle',
										HeaderStr,
										MissionInfoTimer $ MissionInfo1 $ "\n" $ MissionInfo2 $ "</font>");
	MissionExpiryTitle.SetHeaderWidth(MissionExpiryBG.Width - 20);
	MissionExpiryTitle.SetPosition(MissionExpiryBG.X + 10, MissionExpiryBG.Y + 10);
	MissionExpiryPanel.Show();
}
*/

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
