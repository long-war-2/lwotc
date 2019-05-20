//---------------------------------------------------------------------------------------
//  FILE:    UIMission_LWCustomMission.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Provides controls viewing a generic mission, including multiple of the same type in a region
//			 This is used for initiating infiltration/investigation of a mission site
//			 Launching a mission after investigation has begun is handled in UIMission_LWLaunchDelayedMission
//---------------------------------------------------------------------------------------

// WOTC TODO - This file is probably better split up into separate versions for particular mission sub-types like
// they are in WOTC. These sub-classes involve many override functions called from the base UIMission and may need
// to take different actions depending on which mission type is involved.

class UIMission_LWCustomMission extends UIMission config(LW_Overhaul);

enum EMissionUIType
{
	eMissionUI_GuerrillaOps,
	eMissionUI_SupplyRaid,
	eMissionUI_LandedUFO,
	eMissionUI_GoldenPath,   // don't use this for the final mission
	eMissionUI_AlienFacility,
	eMissionUI_GPIntel,
	eMissionUI_Council,
	eMissionUI_Retaliation,
    eMissionUI_Rendezvous,
	eMissionUI_Invasion
};

var UIButton IgnoreButton;

var UITextContainer MissionInfoText;

// for customizing per mission
var EMissionUIType MissionUIType;
var name LibraryID;
var string GeoscapeSFX;

var localized string m_strUrgent;
var localized string m_strRendezvousMission;
var localized string m_strRendezvousDesc;
var localized string m_strMissionDifficulty_start;
var localized string m_strInvasionMission;
var localized string m_strInvasionWarning;
var localized string m_strInvasionDesc;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState_LWAlienActivity AlienActivity;

	super.InitScreen(InitController, InitMovie, InitName);

	//FindMission('MissionSource_Council'); // we're doing a specific mission here, so set it before invoking InitScreen
	AlienActivity = GetAlienActivity();
	if (AlienActivity == none) // sanity check
	{
		CloseScreen();
		return;
	}

	BuildScreen();
}

simulated function Name GetLibraryID()
{
	//allow manual overrides
	if(LibraryID != '')
		return LibraryID;

	switch(MissionUIType)
	{
		case eMissionUI_GuerrillaOps:
			return 'Alert_GuerrillaOpsBlades';
		case eMissionUI_SupplyRaid:
		case eMissionUI_LandedUFO:
			return 'Alert_SupplyRaidBlades';  // used for Supply Raid, Landed UFO
		case eMissionUI_GoldenPath:
		case eMissionUI_AlienFacility:
		case eMissionUI_GPIntel:
			return 'Alert_GoldenPath';  // used for AlienFacility, GoldenPath, GPIntel
		case eMissionUI_Council:
			return 'Alert_CouncilMissionBlades';
		case eMissionUI_Retaliation:
        case eMissionUI_Rendezvous:
		case eMissionUI_Invasion:
			return 'Alert_RetaliationBlades';
		default:
			return 'Alert_GuerrillaOpsBlades';
	}
}

// Override, because we use a DefaultPanel in the AlienFacility
simulated function BindLibraryItem()
{
	local Name AlertLibID;
	local UIPanel DefaultPanel;

	switch(MissionUIType)
	{
		case eMissionUI_AlienFacility:
		case eMissionUI_GoldenPath:
			AlertLibID = GetLibraryID();
			if( AlertLibID != '' )
			{
				LibraryPanel = Spawn(class'UIPanel', self);
				LibraryPanel.bAnimateOnInit = false;
				LibraryPanel.InitPanel('', AlertLibID);
				LibraryPanel.SetSelectedNavigation();

				DefaultPanel = Spawn(class'UIPanel', LibraryPanel);
				DefaultPanel.bAnimateOnInit = false;
				DefaultPanel.bCascadeFocus = false;
				DefaultPanel.InitPanel('DefaultPanel');
				DefaultPanel.SetSelectedNavigation();

				ConfirmButton = Spawn(class'UIButton', DefaultPanel);
				ConfirmButton.SetResizeToText(false);
				ConfirmButton.InitButton('ConfirmButton', "", OnLaunchClicked);

				ButtonGroup = Spawn(class'UIPanel', DefaultPanel);
				ButtonGroup.InitPanel('ButtonGroup', '');

				Button1 = Spawn(class'UIButton', ButtonGroup);
				Button1.SetResizeToText(false);
				Button1.InitButton('Button0', "");

				Button2 = Spawn(class'UIButton', ButtonGroup);
				Button2.SetResizeToText(false);
				Button2.InitButton('Button1', "");

				Button3 = Spawn(class'UIButton', ButtonGroup);
				Button3.SetResizeToText(false);
				Button3.InitButton('Button2', "");

				// WOTC TODO: Changed `UIPanel` to `UIAlertShadowChamberPanel` - check it works!
				ShadowChamber = Spawn(class'UIAlertShadowChamberPanel', LibraryPanel);
				ShadowChamber.InitPanel('ShadowChamber');
			}

			break;
		default:
			super.BindLibraryItem();

			//Issue #140 Hide the Shadow Chamber panel. Do not want to show for anything other than
			//Golden Path missions.
			ShadowChamber.Hide();
		    break;
	}
}

simulated function string GetSFX()
{
	//allow manual overrides
	if(GeoscapeSFX != "")
		return GeoscapeSFX;

	switch(MissionUIType)
	{
		case eMissionUI_GuerrillaOps:
			return "GeoscapeFanfares_GuerillaOps";
		case eMissionUI_SupplyRaid:
			return "Geoscape_Supply_Raid_Popup";
		case eMissionUI_LandedUFO:
			return "Geoscape_UFO_Landed";
		case eMissionUI_GoldenPath:
		case eMissionUI_GPIntel:
			return "GeoscapeFanfares_GoldenPath";
		case eMissionUI_AlienFacility:
        case eMissionUI_Rendezvous:
			return "GeoscapeFanfares_AlienFacility";
		case eMissionUI_Council:
			return "Geoscape_NewResistOpsMissions";
		case eMissionUI_Retaliation:
		case eMissionUI_Invasion:
			return "GeoscapeFanfares_Retaliation";
		default:
			return "Geoscape_NewResistOpsMissions";
	}
}

simulated function String GetMissionTitle()
{
	return GetMission().GetMissionDescription();
}


simulated function BuildScreen()
{
	PlaySFX(GetSFX());
	XComHQPresentationLayer(Movie.Pres).CAMSaveCurrentLocation();
	`HQPres.StrategyMap2D.HideCursor();

	if(bInstantInterp)
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM, 0);
	else
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM);

	// Add Interception warning and Shadow Chamber info
	`LWACTIVITYMGR.UpdateMissionData(GetMission());

	// Base version is responsible for showing most mission info, including the mission and options panels,
	// shadow chamber, chosen, sitreps, etc.
	super.BuildScreen();

	// Add the LW-specific mission info: squad size, concealment type, evac mode, etc.
	class'UIUtilities_LW'.static.BuildMissionInfoPanel(self, MissionRef, false);

	// This call does nothing, but is left in for comparison to the original UIMission_GOps class.
	//BuildConfirmPanel();
}

// Called when screen is removed from Stack
simulated function OnRemoved()
{
	super.OnRemoved();

	//Restore the saved camera location
	if(GetMission().GetMissionSource().DataName != 'MissionSource_Final' || class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T5_M3_CompleteFinalMission') != eObjectiveState_InProgress)
	{
		HQPRES().CAMRestoreSavedLocation();
	}

	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();

	class'UIUtilities_Sound'.static.PlayCloseSound();
}


simulated function BuildMissionPanel()
{
	switch(MissionUIType)
	{
		case eMissionUI_GuerrillaOps:
			BuildGuerrillaOpsMissionPanel();
			break;
		case eMissionUI_SupplyRaid:
			BuildSupplyRaidMissionPanel();
			break;
		case eMissionUI_LandedUFO:
			BuildLandedUFOMissionPanel();
			break;
		case eMissionUI_GoldenPath:
			BuildGoldenPathMissionPanel();
			break;
		case eMissionUI_GPIntel:
			BuildGoldenPathMissionPanel();
			break;
		case eMissionUI_AlienFacility:
			BuildAlienFacilityMissionPanel();
			break;
		case eMissionUI_Council:
			BuildCouncilMissionPanel();
			break;
		case eMissionUI_Retaliation:
			BuildRetaliationMissionPanel();
			break;
        case eMissionUI_Rendezvous:
            BuildRendezvousMissionPanel();
			break;
		case eMissionUI_Invasion:
			BuildInvasionMissionPanel();
            break;
		default:
			BuildGuerrillaOpsMissionPanel();
			break;
	}
}

simulated function BuildOptionsPanel()
{
	switch(MissionUIType)
	{
		case eMissionUI_GuerrillaOps:
			BuildGuerrillaOpsOptionsPanel();
			break;
		case eMissionUI_SupplyRaid:
			BuildSupplyRaidOptionsPanel();
			break;
		case eMissionUI_LandedUFO:
			BuildLandedUFOOptionsPanel();
			break;
		case eMissionUI_GoldenPath:
			BuildGoldenPathOptionsPanel();
			break;
		case eMissionUI_GPIntel:
			BuildGoldenPathOptionsPanel();
			break;
		case eMissionUI_AlienFacility:
			BuildAlienFacilityOptionsPanel();
			break;
		case eMissionUI_Council:
			BuildCouncilOptionsPanel();
			break;
		case eMissionUI_Retaliation:
			BuildRetaliationOptionsPanel();
			break;
        case eMissionUI_Rendezvous:
            BuildRendezvousOptionsPanel();
            break;
		case eMissionUI_Invasion:
			BuildInvasionOptionsPanel();
			break;
		default:
			BuildGuerrillaOpsOptionsPanel();
			break;
	}
}

simulated function AddIgnoreButton()
{
	//Button is controlled by flash and shows by default. Hide if need to.
	//local UIButton IgnoreButton;

	IgnoreButton = Spawn(class'UIButton', LibraryPanel);
	if(CanBackOut())
	{
		if( `ISCONTROLLERACTIVE == false )
		{
			IgnoreButton.SetResizeToText(false);
			IgnoreButton.InitButton('IgnoreButton', "", OnCancelClicked);
		}
		else
		{
			IgnoreButton.InitButton('IgnoreButton', "", OnCancelClicked, eUIButtonStyle_HOTLINK_WHEN_SANS_MOUSE);
			IgnoreButton.SetGamepadIcon(class'UIUtilities_Input'.static.GetBackButtonIcon());
			//IgnoreButton.OnSizeRealized = OnIgnoreButtonSizeRealized;
			IgnoreButton.SetX(1450.0);
			IgnoreButton.SetY(644.0);
		}

		IgnoreButton.DisableNavigation();
	}
	else
	{
		IgnoreButton.InitButton('IgnoreButton').Hide();
	}
}

simulated function OnButtonSizeRealized()
{
	// Override - do nothing. The base version will alter the position of the
	// confirm button, so an empty version is necessary to suppress that.
}

simulated function UpdateData()
{
	// WOTC TODO different sfx for different missions?
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Geoscape_AlienOperation");
	XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM);

	BuildMissionPanel();
	//RefreshNavigation();

	// Region Panel
	if( LibraryPanel == none )
	{
		UpdateTitle('Region', GetRegion().GetMyTemplate().DisplayName, GetLabelColor(), 50);
	}
	
	/*********************************** Issue #140 ***********************************
	* The below code is replacing the call to super.UpdateData(). The code from the parent
	* class version of UpdateData() is pasted here except the call to UpdateMissionSchedules()
	* was removed as it was doing something to the mission schedules where it would create
	* a new schedule for the mission with alert level of 1 so all missions would have
	* much lower alert levels than they should causing baseline enemy activity to be wrong.
	**********************************************************************************/
	UpdateMissionTacticalTags();
	AddMissionTacticalTags();
	UpdateShadowChamber();
	UpdateSitreps();
	UpdateChosen();
}

simulated function bool CanBackOut()
{
	return (super.CanBackOut() && class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M7_WelcomeToGeoscape'));
}

// ----------------------------------------------------------------------
// -------- UTILITY CLASSSES FOR VARIOUS MISSION TYPES ------------------
// ----------------------------------------------------------------------

//--=- GAME DATA HOOKUP ----
simulated function String GetRegionLocalizedDesc(string strDesc)
{
	local XGParamTag ParamTag;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = GetRegionName();

	return `XEXPAND.ExpandString(strDesc);
}

simulated function bool CanTakeMission()
{
	return GetRegion().HaveMadeContact() || !GetMission().bNotAtThreshold;
}

simulated function String GetMissionImage()
{
	local XComGameState_LWAlienActivity AlienActivity;
	local XComGameState_MissionSite MissionSite;

	MissionSite = GetMission();

	AlienActivity = GetAlienActivity();
	if(AlienActivity != none)
		return AlienActivity.GetMissionImage(MissionSite);

	return "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Guerrilla_Ops";
}

simulated function String GetObjectiveString()
{
	local string ObjectiveString;
	local XComGameState_LWAlienActivity AlienActivity;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local string ActivityObjective;

	ObjectiveString = super.GetObjectiveString();
	ObjectiveString $= "\n";

	AlienActivity = GetAlienActivity();

	if (AlienActivity != none)
	{
		ActivityTemplate = AlienActivity.GetMyTemplate();
		ActivityObjective = ActivityTemplate.ActivityObjectives[AlienActivity.CurrentMissionLevel];
	}
	else
	{
		ActivityObjective = "";
	}
	//if(ActivityObjective == "")
		//ActivityObjective = "Missing ActivityObjectives[" $ AlienActivity.CurrentMissionLevel $ "] for AlienActivity " $ ActivityTemplate.DataName;

	ObjectiveString $= ActivityObjective;

	return ObjectiveString;
}

simulated function XComGameState_LWAlienActivity GetAlienActivity()
{
	return class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(GetMission());
}

simulated function string GetModifiedRewardString()
{
	local XComGameState_MissionSite MissionState;
	local string RewardString, OldCaptureRewardString, NewCaptureRewardString;

	MissionState = GetMission();
	RewardString = GetRewardString();
	if (MissionState.GeneratedMission.Mission.MissionFamily == "Neutralize_LW")
	{
		RewardString = "$$$" $ RewardString;	// Intended to handle any repeats
		OldCaptureRewardString = Mid(RewardString, 0, Instr(RewardString, ","));
		//`log ("MODIFYING REWARD STRING" @ OldCaptureRewardString);
		NewCaptureRewardString = OldCaptureRewardString @ class'UIUtilities_LW'.default.m_strVIPCaptureReward;
		RewardString = Repl (RewardString, OldCaptureRewardString, NewCaptureRewardString);
		RewardString -= "$$$";
	}
	return RewardString;
}


// ----------------------------------------------------------------------
// ----------------- START FLASH INTERFACES -----------------------------
// ----------------------------------------------------------------------

// ---- GUERRILLA OPS ----

simulated function BuildGuerrillaOpsMissionPanel()
{
	local string strDarkEventLabel, strDarkEventValue, strDarkEventTime;
	local XComGameState_LWAlienActivity AlienActivity;
	local bool bHasDarkEvent;
	local XComGameState_MissionSite MissionState;

	MissionState = GetMission();
	bHasDarkEvent = MissionState.HasDarkEvent();

	if(bHasDarkEvent)
	{
		strDarkEventLabel = class'UIMission_GOps'.default.m_strDarkEventLabel;
		strDarkEventValue = MissionState.GetDarkEvent().GetDisplayName();
		strDarkEventTime = MissionState.GetDarkEvent().GetPreMissionText();
	}
	else
	{
		strDarkEventLabel = "";
		strDarkEventValue = "";
		strDarkEventTime = "";
	}

	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateGuerrillaOpsInfoBlade");
	LibraryPanel.MC.QueueString(GetRegion().GetMyTemplate().DisplayName);
	LibraryPanel.MC.QueueString(class'UIMission_GOps'.default.m_strGOpsTitle);
	LibraryPanel.MC.QueueString(GetMissionImage());			// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionLabel);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());				// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);		// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());		// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionDifficulty_start);	// defined locally
	LibraryPanel.MC.QueueString(class'UIUtilities_Text_LW'.static.GetDifficultyString(GetMission()));		// defined in UIMission
	LibraryPanel.MC.QueueString(m_strReward);				// defined in UIX2SimpleScreen
	LibraryPanel.MC.QueueString(GetModifiedRewardString());			// defined in UIMission
	LibraryPanel.MC.QueueString(strDarkEventLabel);			// defined locally
	LibraryPanel.MC.QueueString(strDarkEventValue);			// defined locally
	LibraryPanel.MC.QueueString(strDarkEventTime);			// defined locally
	LibraryPanel.MC.QueueString(GetRewardIcon());			// defined in UIMission
	LibraryPanel.MC.EndOp();

	if (MissionInfoText == none)
	{
		MissionInfoText = Spawn(class'UITextContainer', LibraryPanel);
		MissionInfoText.bAnimateOnInit = false;
		MissionInfoText.MCName = 'MissionInfoText_LW';
		if (bHasDarkEvent)
			MissionInfoText.InitTextContainer('MissionInfoText_LW', , 212, 822+15, 320, 87);
		else // use a larger area to display more text if there's no dark event
			MissionInfoText.InitTextContainer('MissionInfoText_LW', , 212, 822-80, 320, 87+80);
	}

	MissionInfoText.Show();

	AlienActivity = `LWACTIVITYMGR.FindAlienActivityByMission(MissionState);
	if(AlienActivity != none)
		MissionInfoText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(AlienActivity.GetMissionDescriptionForActivity(), eUIState_Normal));
	else
		MissionInfoText.Hide();
}

simulated function UpdateGOpButtons()
{
	// GOps have no button2/3 for extra missions
	Button2.MC.FunctionVoid("Hide");
	Button3.MC.FunctionVoid("Hide");
	RefreshNavigation();
}

simulated function BuildGuerrillaOpsOptionsPanel()
{
	// only allowing one mission option here
	// Mission 1
	Button1.SetText(GetRegionName());
	Button1.Show();
	Button2.DisableNavigation();
	Button2.Hide();
	Button2.Remove();
	Button3.DisableNavigation();
	Button3.Hide();
	Button3.Remove();

	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateGuerrillaOpsButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_GOps'.default.m_strGOpsSite);
	LibraryPanel.MC.QueueString("") ; //GetUnlockHelpString());
	LibraryPanel.MC.QueueString(GetRegionName()); //GetGOpsMissionLocString(0));
	LibraryPanel.MC.QueueString(""); //GetGOpsMissionLocString(1));
	LibraryPanel.MC.QueueString(""); //GetGOpsMissionLocString(2));
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericConfirm);
	LibraryPanel.MC.QueueString(CanBackOut() ? m_strIgnore : ""); // defined in UIX2SimpleScreen
	LibraryPanel.MC.EndOp();

	// ----------------------------------------------------------------------

	// WOTC TODO Other mission types may be missing these
	// BuildConfirmPanel does nothing, but left in for comparison with UIMission_GOps.
	// BuildConfirmPanel();
	AddIgnoreButton();
	SetTimer(0.3, false, 'UpdateGOpButtons');
}

// ---- COUNCIL ----

simulated function BuildCouncilMissionPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateCouncilInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionImage());					// defined in UIMission
	LibraryPanel.MC.QueueString("../AssetLibraries/ProtoImages/Proto_HeadFirebrand.tga");
	LibraryPanel.MC.QueueString("../AssetLibraries/TacticalIcons/Objective_VIPGood.tga");
	LibraryPanel.MC.QueueString(class'UIMission_Council'.default.m_strImageGreeble);
	LibraryPanel.MC.QueueString(GetRegion().GetMyTemplate().DisplayName);
	LibraryPanel.MC.QueueString(GetOpName());						// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);				// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());				// defined in UIMission
	LibraryPanel.MC.QueueString(GetRewardIcon());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strReward);						// defined in UIX2SimpleScreen
	LibraryPanel.MC.QueueString(GetModifiedRewardString());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strLaunchMission);				// defined in UIMission
	LibraryPanel.MC.QueueString(m_strIgnore);						// defined in UIX2SimpleScreen
	LibraryPanel.MC.EndOp();

	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.OnClickedDelegate = OnCancelClicked;
	Button3.Hide();
	ConfirmButton.Hide();
}

simulated function BuildCouncilOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateCouncilButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_Council'.default.m_strCouncilMission);
	LibraryPanel.MC.QueueString(m_strLaunchMission);				// defined in UIMission
	LibraryPanel.MC.QueueString(m_strIgnore);						// defined in UIX2SimpleScreen
	LibraryPanel.MC.EndOp();
}

// ---- SUPPLY RAID ----

simulated function BuildSupplyRaidMissionPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateSupplyRaidButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_SupplyRaid'.default.m_strSupplyRaidTitleGreeble);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(class'UIMission_SupplyRaid'.default.m_strRaidDesc));
	LibraryPanel.MC.QueueString(m_strLaunchMission);				// defined in UIMission
	LibraryPanel.MC.QueueString(m_strIgnore);						// defined in UIX2SimpleScreen
	LibraryPanel.MC.EndOp();

	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.OnClickedDelegate = OnCancelClicked;

	Button3.Hide();
	ConfirmButton.Hide();
}

simulated function BuildSupplyRaidOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateSupplyRaidInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_SupplyRaid'.default.m_strSupplyMission);
	LibraryPanel.MC.QueueString(GetRegion().GetMyTemplate().DisplayName);
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_SupplyRaid'.default.m_strSupplyRaidGreeble);

	// Launch/Help Panel
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");

	LibraryPanel.MC.EndOp();
}

// ---- LANDED UFO ----

simulated function BuildLandedUFOMissionPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateSupplyRaidButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_LandedUFO'.default.m_strLandedUFOTitleGreeble);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(class'UIMission_LandedUFO'.default.m_strMissionDesc));
	LibraryPanel.MC.QueueString(m_strLaunchMission);				// defined in UIMission
	LibraryPanel.MC.QueueString(m_strIgnore);						// defined in UIX2SimpleScreen
	LibraryPanel.MC.EndOp();

	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.OnClickedDelegate = OnCancelClicked;

	Button3.Hide();
	ConfirmButton.Hide();
}

simulated function BuildLandedUFOOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateSupplyRaidInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_LandedUFO'.default.m_strLandedUFOMission);
	LibraryPanel.MC.QueueString(GetRegion().GetMyTemplate().DisplayName);
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_LandedUFO'.default.m_strLandedUFOGreeble);

	// Launch/Help Panel
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");

	LibraryPanel.MC.EndOp();
}

// ---- RETALIATION ----

simulated function BuildRetaliationMissionPanel()
{
	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationInfoBlade");
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS( GetRegion().GetMyTemplate().DisplayName ));
	LibraryPanel.MC.QueueString(class'UIMission_Retaliation'.default.m_strRetaliationMission);
	LibraryPanel.MC.QueueString(class'UIMission_Retaliation'.default.m_strRetaliationWarning);
	LibraryPanel.MC.QueueString(GetMissionImage());					// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());						// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);				// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());				// defined in UIMission
	LibraryPanel.MC.EndOp();
}

simulated function BuildRetaliationOptionsPanel()
{
	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_Retaliation'.default.m_strRetaliationWarning);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(class'UIMission_Retaliation'.default.m_strRetaliationDesc));
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericConfirm);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);
	LibraryPanel.MC.QueueString("" /*LockedTitle*/);
	LibraryPanel.MC.QueueString("" /*LockedDesc*/);
	LibraryPanel.MC.QueueString("" /*LockedOKButton*/);
	LibraryPanel.MC.EndOp();

	Button1.SetText(class'UIUtilities_Text'.default.m_strGenericConfirm);
	Button1.SetBad(true);
	Button1.OnClickedDelegate = OnLaunchClicked;

	Button2.SetText(class'UIUtilities_Text'.default.m_strGenericCancel);
	Button2.SetBad(true);
	Button2.OnClickedDelegate = OnCancelClicked;

	Button3.Hide();
	ConfirmButton.Hide();
}

// ---- RENDEZVOUS ----

simulated function BuildRendezvousMissionPanel()
{
	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationInfoBlade");
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS( GetRegion().GetMyTemplate().DisplayName ));
	LibraryPanel.MC.QueueString(m_strRendezvousMission);
	LibraryPanel.MC.QueueString(m_strUrgent);
	LibraryPanel.MC.QueueString(GetMissionImage());					// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());						// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);				// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());				// defined in UIMission
	LibraryPanel.MC.EndOp();
}

simulated function BuildRendezvousOptionsPanel()
{
	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationButtonBlade");
	LibraryPanel.MC.QueueString(m_strUrgent);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(m_strRendezvousDesc));
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericConfirm);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);
	LibraryPanel.MC.QueueString("" /*LockedTitle*/);
	LibraryPanel.MC.QueueString("" /*LockedDesc*/);
	LibraryPanel.MC.QueueString("" /*LockedOKButton*/);
	LibraryPanel.MC.EndOp();

	Button1.SetText(class'UIUtilities_Text'.default.m_strGenericConfirm);
	Button1.SetBad(true);
	Button1.OnClickedDelegate = OnLaunchClicked;

	Button2.SetText(class'UIUtilities_Text'.default.m_strGenericCancel);
	Button2.SetBad(true);
	Button2.OnClickedDelegate = OnCancelClicked;

	Button3.Hide();
	ConfirmButton.Hide();
}


// ---- INVASION ----

simulated function BuildInvasionMissionPanel()
{
	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationInfoBlade");
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS( GetRegion().GetMyTemplate().DisplayName ));
	LibraryPanel.MC.QueueString(m_strInvasionMission);
	LibraryPanel.MC.QueueString(m_strInvasionWarning);
	LibraryPanel.MC.QueueString(GetMissionImage());					// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());						// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);				// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());				// defined in UIMission
	LibraryPanel.MC.EndOp();
}

simulated function BuildInvasionOptionsPanel()
{
	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationButtonBlade");
	LibraryPanel.MC.QueueString(m_strInvasionWarning);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(m_strInvasionDesc));
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericConfirm);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);
	LibraryPanel.MC.QueueString("" /*LockedTitle*/);
	LibraryPanel.MC.QueueString("" /*LockedDesc*/);
	LibraryPanel.MC.QueueString("" /*LockedOKButton*/);
	LibraryPanel.MC.EndOp();

	Button1.SetText(class'UIUtilities_Text'.default.m_strGenericConfirm);
	Button1.SetBad(true);
	Button1.OnClickedDelegate = OnLaunchClicked;

	Button2.SetText(class'UIUtilities_Text'.default.m_strGenericCancel);
	Button2.SetBad(true);
	Button2.OnClickedDelegate = OnCancelClicked;

	Button3.Hide();
	ConfirmButton.Hide();
}



// ---- ALIEN FACILITY ----

simulated function BuildAlienFacilityMissionPanel()
{
	local XComGameState_LWAlienActivity Activity;

	Activity = GetAlienActivity();

	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionTitle());
	LibraryPanel.MC.QueueString(GetRegionName());				// defined in UIMission
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(super.GetObjectiveString());			// defined in UIMission -- don't pull the activity subobjective string
	if (Activity == none)
		LibraryPanel.MC.QueueString(class'UIMission_AlienFacility'.default.m_strFlavorText);
	else
		LibraryPanel.MC.QueueString(Activity.GetMissionDescriptionForActivity());
	if( GetMission().GetRewardAmountString() != "" )
	{
		LibraryPanel.MC.QueueString(m_strReward $":");
		LibraryPanel.MC.QueueString(GetMission().GetRewardAmountString());
	}
	LibraryPanel.MC.EndOp();
}

simulated function bool CanTakeAlienFacilityMission()
{
	return GetRegion().HaveMadeContact();
}


simulated function BuildAlienFacilityOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathIntel");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.EndOp();

	// ---------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathButtonBlade");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(class'UIMission_AlienFacility'.default.m_strLaunchMission);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);

	if( !CanTakeAlienFacilityMission() )
	{
		LibraryPanel.MC.QueueString(m_strLocked);
		LibraryPanel.MC.QueueString(class'UIMission_AlienFacility'.default.m_strLockedHelp);
		LibraryPanel.MC.QueueString(m_strOK); //OnCancelClicked
	}
	LibraryPanel.MC.EndOp();

	// ---------------------

	if( !CanTakeAlienFacilityMission() )
	{
		// Hook up to the flash assets for locked info.
		LockedPanel = Spawn(class'UIPanel', LibraryPanel);
		LockedPanel.InitPanel('lockedMC', '');

		LockedButton = Spawn(class'UIButton', LockedPanel);
		LockedButton.SetResizeToText(false);
		LockedButton.InitButton('ConfirmButton', "");
		LockedButton.SetText(m_strOK);
		LockedButton.OnClickedDelegate = OnCancelClicked;
		LockedButton.Show();
	}
	else
	{
		Button1.OnClickedDelegate = OnLaunchClicked;
		Button2.OnClickedDelegate = OnCancelClicked;
	}

	Button1.SetBad(true);
	Button2.SetBad(true);

	Button3.Hide();
	ConfirmButton.Hide();
}

// ---- GOLDEN PATH ----

simulated function BuildGoldenPathMissionPanel()
{
	// Send over to flash ---------------------------------------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionTitle());								// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_GoldenPath'.default.m_strGPMissionSubtitle);
	LibraryPanel.MC.QueueString(GetMissionImage());								// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());									// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);							// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());							// defined in UIMission ***
	LibraryPanel.MC.QueueString(GetMission().GetMissionSource().MissionFlavorText);						// defined in UIMission
	if( GetMission().GetRewardAmountString() != "" )							// defined in UIMission
	{
		LibraryPanel.MC.QueueString(m_strReward $":");							// defined in UIMission
		LibraryPanel.MC.QueueString(GetMission().GetRewardAmountString());		// defined in UIMission
	}
	LibraryPanel.MC.EndOp();
}

simulated function BuildGoldenPathOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathIntel");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.EndOp();

	// ---------------------

	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathButtonBlade");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(m_strLaunchMission);							// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);

	if( !CanTakeMission() )
	{
		LibraryPanel.MC.QueueString(m_strLocked);
		LibraryPanel.MC.QueueString(class'UIMission_GoldenPath'.default.m_strLockedHelp);

		LibraryPanel.MC.QueueString(m_strOK); //OnCancelClicked
	}
	LibraryPanel.MC.EndOp();

	// ---------------------

	Button1.SetBad(true);
	Button2.SetBad(true);

	if( !CanTakeMission() )
	{
		// Hook up to the flash assets for locked info.
		LockedPanel = Spawn(class'UIPanel', LibraryPanel);
		LockedPanel.InitPanel('lockedMC', '');

		LockedButton = Spawn(class'UIButton', LockedPanel);
		LockedButton.SetResizeToText(false);
		LockedButton.InitButton('ConfirmButton', "");
		LockedButton.SetText(m_strOK);
		LockedButton.OnClickedDelegate = OnCancelClicked;
		LockedButton.Show();

		Button1.SetDisabled(true);
		Button2.SetDisabled(true);
	}


	if( CanTakeMission() )
	{
		Button1.OnClickedDelegate = OnLaunchClicked;
		Button2.OnClickedDelegate = OnCancelClicked;
	}
	Button3.Hide();
	ConfirmButton.Hide();
}


defaultproperties
{
	Package = "/ package/gfxAlerts/Alerts";
	InputState = eInputState_Consume;
}
