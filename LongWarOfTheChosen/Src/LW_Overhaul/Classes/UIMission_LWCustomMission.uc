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

// LW2 : Don't use eMissionUI_GoldenPath for the final mission.
enum EMissionUIType
{
	eMissionUI_GuerrillaOps,
	eMissionUI_SupplyRaid,
	eMissionUI_LandedUFO,
	eMissionUI_GoldenPath,
	eMissionUI_AlienFacility,
	eMissionUI_GPIntel,
	eMissionUI_Council,
	eMissionUI_Retaliation,
    eMissionUI_Rendezvous,
	eMissionUI_Invasion
};

var UIButton IgnoreButton;
// KDM : MissionInfoText is now a UIVerticalScrollingText2 rather than a UITextContainer. UIVerticalScrollingText2
// is a LW created text container which fixes UITextContainer's inability to display auto-scrolled text.
// More specifically, when using a UITextContainer, text which starts outside of the text container's visible 
// area remains invisible even when scrolling into view.
//
// UIVerticalScrollingText2's only allow for auto-scroll; therefore, MissionInfoText will auto-scroll for 
// both controller users and mouse and keyboard users. This is not a problem though as :
// 1.] This is consistant with other UI elements on the Guerrilla Ops mission panel, which also auto-scroll.
// 2.] Very rarely will scrolling be necessary since the mission info text tends to be quite short, and its 
// font size, particularly for mouse and keyboard users, is very small.
var UIVerticalScrollingText2 MissionInfoText;

// MissionUIType tells us which type of mission is being dealt with; this allows us to customize the UI accordingly.
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

// ----------------------------------------------------------------------
// ----------------- STEP 1. INITIALIZE THE SCREEN ----------------------
// ----------------------------------------------------------------------

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState_LWAlienActivity AlienActivity;

	super.InitScreen(InitController, InitMovie, InitName);

	AlienActivity = GetAlienActivity();
	if (AlienActivity == none)
	{
		CloseScreen();
		return;
	}

	BuildScreen();
}

// ----------------------------------------------------------------------
// ----------------- STEP 2. BUILD THE SCREEN ---------------------------
// ----------------------------------------------------------------------

simulated function BuildScreen()
{
	PlaySFX(GetSFX());
	XComHQPresentationLayer(Movie.Pres).CAMSaveCurrentLocation();
	`HQPres.StrategyMap2D.HideCursor();

	if(bInstantInterp)
	{
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM, 0);
	}
	else
	{
		XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM);
	}

	// LW2 : Add interception warning and Shadow Chamber information.
	`LWACTIVITYMGR.UpdateMissionData(GetMission());

	// KDM : UIMission.BuildScreen is concerned with :
	// 1.] Creating common buttons and panels, and binding them to their Flash counterparts via BindLibraryItem. 
	// 2.] Updating a variety of mission information via UpdateData.
	// 3.] Building the 'Mission Panel' found on the left side of the screen via BuildMissionPanel.
	// 4.] Building the 'Options Panel' found on the right side of the screen via BuildOptionsPanel.
	super.BuildScreen();

	// LW2 : Create a Long War specific 'mission information' panel which includes a variety of extra information
	// including : squad size, concealment type, evacuation mode ... etc.
	class'UIUtilities_LW'.static.BuildMissionInfoPanel(self, MissionRef, false);

	// KDM : Any calls to BuildConfirmPanel are unneccessary because :
	// GetLibraryID never returns ''; therefore, LibraryPanel is never 'none' and, consequently,
	// BuildConfirmPanel always exits without performing any actions.
}

// ----------------------------------------------------------------------
// ---- STEP 3. CREATE COMMON BUTTONS/PANELS + BIND THEM TO FLASH UI ----
// ----------------------------------------------------------------------

simulated function BindLibraryItem()
{
	local Name AlertLibID;
	local UIPanel DefaultPanel;

	switch(MissionUIType)
	{
	// LW2 : Alien facilities and golden path missions make use of a special 'DefaultPanel'; therefore,
	// they must be overridden here.
	case eMissionUI_AlienFacility:
	case eMissionUI_GoldenPath:
		AlertLibID = GetLibraryID();
		if (AlertLibID != '')
		{
			// KDM : Navigation setup is dealt with in RefreshNavigation; therefore, navigation calls
			// have been removed here. Additionally, UI styling has been moved to the bottom of this function
			// so they apply to all mission types.
			LibraryPanel = Spawn(class'UIPanel', self);
			LibraryPanel.bAnimateOnInit = false;
			LibraryPanel.InitPanel('', AlertLibID);
			
			DefaultPanel = Spawn(class'UIPanel', LibraryPanel);
			DefaultPanel.bAnimateOnInit = false;
			DefaultPanel.InitPanel('DefaultPanel');
			
			ConfirmButton = Spawn(class'UIButton', DefaultPanel);
			ConfirmButton.InitButton('ConfirmButton', "", OnLaunchClicked);
			
			ButtonGroup = Spawn(class'UIPanel', DefaultPanel);
			ButtonGroup.InitPanel('ButtonGroup', '');
			
			Button1 = Spawn(class'UIButton', ButtonGroup);
			Button1.InitButton('Button0', "");
			
			Button2 = Spawn(class'UIButton', ButtonGroup);
			Button2.InitButton('Button1', "");
			
			Button3 = Spawn(class'UIButton', ButtonGroup);
			Button3.InitButton('Button2', "");
			
			ShadowChamber = Spawn(class'UIAlertShadowChamberPanel', LibraryPanel);
			// KDM : The parameters to ShadowChamber.InitPanel have been updated to stay consistent with
			// UIMission.BindLibraryItem, UIMission_AlienFacility.BindLibraryItem and UIMission_GoldenPath.BindLibraryItem.
			// I think this is correct; however, I'm keeping the old code 'just in case'.
			ShadowChamber.InitPanel('UIAlertShadowChamberPanel', 'Alert_ShadowChamber');
			// ShadowChamber.InitPanel('ShadowChamber');
			
			SitrepPanel = Spawn(class'UIAlertSitRepPanel', LibraryPanel);
			SitrepPanel.InitPanel('SitRep', 'Alert_SitRep');
			SitrepPanel.SetTitle(m_strSitrepTitle);

			ChosenPanel = Spawn(class'UIPanel', LibraryPanel);
			ChosenPanel.InitPanel(, 'Alert_ChosenRegionInfo');
		}
		break;

	// KDM : For most mission screens we just want to call UIMission.BindLibraryItem.
	default:
		super.BindLibraryItem();
		break;
	}

	// KDM : Display parent-panel centered hotlinks for controller users, and parent-panel centered buttons
	// for mouse and keyboard users. Generally speaking, Button1 is a 'launch mission' hotlink/button while 
	// Button2 is a 'cancel mission' hotlink/button.
	//
	// The 'Guerrilla Ops' option panel is distinct since Button1 is used to display a region name rather 
	// than act as a 'clickable' button. Consequently, Button1 on the Guerrilla Ops screen should never be
	// a hotlink, nor should it resize itself.
	if (`ISCONTROLLERACTIVE && !IsGuerrillaOpMission())
	{
		// KDM : Allow the hotlink to be shorter than 150 pixels, its flash-based default.
		Button1.MC.SetNum("MIN_WIDTH", 50);
		// KDM : Actually 'make' it a hotlink with a gamepad icon; furthermore, enable resizing.
		Button1.SetStyle(eUIButtonStyle_HOTLINK_BUTTON, , true);
		Button1.SetGamepadIcon(class'UIUtilities_Input'.static.GetAdvanceButtonIcon());
		// KDM : Center the hotlink within its parent panel, once it has been realized.
		Button1.OnSizeRealized = OnUnlockedButtonSizeRealized;

		Button2.MC.SetNum("MIN_WIDTH", 50);
		Button2.SetStyle(eUIButtonStyle_HOTLINK_BUTTON, , true);
		Button2.SetGamepadIcon(class'UIUtilities_Input'.static.GetBackButtonIcon());
		Button2.OnSizeRealized = OnUnlockedButtonSizeRealized;

		Button3.SetResizeToText(false);
	}
	else if (!`ISCONTROLLERACTIVE)
	{
		// KDM : Turn off text resizing, for mouse and keyboard users, so their buttons are nice and wide.
		Button1.SetResizeToText(false);
		Button2.SetResizeToText(false);
		Button3.SetResizeToText(false);
		ConfirmButton.SetResizeToText(false);
	}
}

// ----------------------------------------------------------------------
// ----------------- STEP 4. UPDATE NECESSARY DATA ----------------------
// ----------------------------------------------------------------------

simulated function UpdateData()
{
	// WOTC TODO : Should we use different sound effects for different missions ?
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Geoscape_AlienOperation");
	
	// KDM : The following function calls are not needed :
	// - XComHQPresentationLayer.CAMLookAtEarth, since it is already called in self.BuildScreen.
	// - BuildMissionPanel, since it is already called in super.BuildScreen.

	// XCom : Region panel.
	if (LibraryPanel == none)
	{
		UpdateTitle('Region', GetRegion().GetMyTemplate().DisplayName, GetLabelColor(), 50);
	}

	/*********************************** Issue #140 ***********************************
	* The below code is replacing the call to super.UpdateData(). The code from the parent
	* class version of UpdateData() is pasted here except the call to UpdateMissionSchedules().
	**********************************************************************************/
	// WARNING! We cannot call UpdateMissionSchedules() under any circumstances as it
	// will change the mission schedule using vanilla force and alert levels rather than
	// the ones calculated by the alien activity manager!
	UpdateMissionTacticalTags();
	AddMissionTacticalTags();

	// This is an infiltration mission, so don't display the Shadow Chamber info as
	// it won't necessarily be representative of what's on the map when the mission
	// is actually launched.
	// UpdateShadowChamber();
	ShadowChamber.Hide();
	UpdateSitreps();
	UpdateChosen();
	/*********************************** Issue #140 ***********************************
	* This is the end of the code replacing the call to super.UpdateData().
	**********************************************************************************/

	// KDM : 
	// 1.] Within WotC, UIMission_SupplyRaid and UIMission_LandedUFO override UpdateData so they can
	// call BuildOptionsPanel after super.UpdateData. This is not needed since BuildOptionsPanel is already
	// called in super.BuildScreen; therefore, no modifications need to be made for them.
	// 2.] Within WotC, UIMission_GPIntelOptions overrides UpdateData so it can call UpdateDisplay after
	// super.UpdateData. We need not worry about UIMission_GPIntelOptions since it is a special screen for 
	// end game missions and is not considered a 'LW Custom Mission'.
}

// ----------------------------------------------------------------------
// ------ STEP 5. BUILD MISSION PANEL ON LEFT SIDE OF THE SCREEN --------
// ----------------------------------------------------------------------

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

// ----------------------------------------------------------------------
// ------ STEP 6. BUILD OPTIONS PANEL ON RIGHT SIDE OF THE SCREEN -------
// ----------------------------------------------------------------------

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

// ----------------------------------------------------------------------
// ----------- BUILD MISSION PANEL (MISSION SPECIFIC) CODE --------------
// ----------------------------------------------------------------------

simulated function BuildGuerrillaOpsMissionPanel()
{
	local bool HasDarkEvent;
	local int MissionInfoFontSize;
	local string DarkEventLabel, DarkEventValue, DarkEventTime;
	local XComGameState_LWAlienActivity AlienActivity;
	local XComGameState_MissionSite MissionState;

	MissionState = GetMission();
	HasDarkEvent = MissionState.HasDarkEvent();

	if (HasDarkEvent)
	{
		DarkEventLabel = class'UIMission_GOps'.default.m_strDarkEventLabel;
		DarkEventValue = MissionState.GetDarkEvent().GetDisplayName();
		DarkEventTime = MissionState.GetDarkEvent().GetPreMissionText();
	}
	else
	{
		DarkEventLabel = "";
		DarkEventValue = "";
		DarkEventTime = "";
	}

	LibraryPanel.MC.BeginFunctionOp("UpdateGuerrillaOpsInfoBlade");
	LibraryPanel.MC.QueueString(GetRegion().GetMyTemplate().DisplayName);
	LibraryPanel.MC.QueueString(class'UIMission_GOps'.default.m_strGOpsTitle);
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionLabel);				// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionDifficulty_start);	// defined locally
	LibraryPanel.MC.QueueString(class'UIUtilities_Text_LW'.static.GetDifficultyString(GetMission()));	// defined in UIMission
	LibraryPanel.MC.QueueString(m_strReward);					// defined in UIX2SimpleScreen
	LibraryPanel.MC.QueueString(GetModifiedRewardString());		// defined in UIMission
	LibraryPanel.MC.QueueString(DarkEventLabel);				// defined locally
	LibraryPanel.MC.QueueString(DarkEventValue);				// defined locally
	LibraryPanel.MC.QueueString(DarkEventTime);					// defined locally
	LibraryPanel.MC.QueueString(GetRewardIcon());				// defined in UIMission
	LibraryPanel.MC.EndOp();

	// KDM : Add a LW2 specific text container.
	if (MissionInfoText == none)
	{
		MissionInfoText = Spawn(class'UIVerticalScrollingText2', LibraryPanel);
		MissionInfoText.bAnimateOnInit = false;
		MissionInfoText.MCName = 'MissionInfoText_LW';
		if (HasDarkEvent)
		{
			MissionInfoText.InitVerticalScrollingText('MissionInfoText_LW', , 212, 822 + 15, 320, 87);
		}
		else
		{
			// LW2 : MissionInfoText can take up more vertical space if there is no dark event text displayed
			// in the Guerrilla Ops mission panel.
			MissionInfoText.InitVerticalScrollingText('MissionInfoText_LW', , 212, 822 - 80, 320, 87 + 80);
		}
	}

	MissionInfoText.Show();

	AlienActivity = `LWACTIVITYMGR.FindAlienActivityByMission(MissionState);
	if(AlienActivity != none)
	{
		// KDM : Display LW specific mission information; make the text a bit bigger for controller users
		// since it can be quite difficult to read.
		MissionInfoFontSize = `ISCONTROLLERACTIVE ? 20 : 16;
		MissionInfoText.SetHTMLText(
			class'UIUtilities_Text'.static.GetColoredText(AlienActivity.GetMissionDescriptionForActivity(), 
			eUIState_Normal, MissionInfoFontSize));
	}
	else
	{
		MissionInfoText.Hide();
	}
}

// KDM : I believe this function is never called since eMissionUI_Council is never referenced within 
// XComLW_Activities.ini
simulated function BuildCouncilMissionPanel()
{
	// KDM : UpdateCouncilInfoBlade takes 11 parameters, not 13 !
	LibraryPanel.MC.BeginFunctionOp("UpdateCouncilInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString("../AssetLibraries/ProtoImages/Proto_HeadFirebrand.tga");
	LibraryPanel.MC.QueueString("../AssetLibraries/TacticalIcons/Objective_VIPGood.tga");
	LibraryPanel.MC.QueueString(class'UIMission_Council'.default.m_strImageGreeble);
	LibraryPanel.MC.QueueString(GetRegion().GetMyTemplate().DisplayName);
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission
	LibraryPanel.MC.QueueString(GetRewardIcon());				// defined in UIMission
	LibraryPanel.MC.QueueString(m_strReward);					// defined in UIX2SimpleScreen
	LibraryPanel.MC.QueueString(GetModifiedRewardString());		// defined in UIMission
	LibraryPanel.MC.EndOp();

	// KDM : Option panel buttons should be dealt with in BuildCouncilOptionsPanel, not here.
}

// KDM : The code within BuildSupplyRaidMissionPanel and BuildSupplyRaidOptionsPanel has been swapped
// since mission panels should deal with 'info blades' and option panels should deal with 'button blades'.
simulated function BuildSupplyRaidMissionPanel()
{
	// KDM : UpdateSupplyRaidInfoBlade takes 7 parameters, not 11 !
	LibraryPanel.MC.BeginFunctionOp("UpdateSupplyRaidInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_SupplyRaid'.default.m_strSupplyMission);
	LibraryPanel.MC.QueueString(GetRegion().GetMyTemplate().DisplayName);
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_SupplyRaid'.default.m_strSupplyRaidGreeble);
	LibraryPanel.MC.EndOp();
}

// KDM : The code within BuildLandedUFOMissionPanel and BuildLandedUFOOptionsPanel has been swapped
// since mission panels should deal with 'info blades' and option panels should deal with 'button blades'.
simulated function BuildLandedUFOMissionPanel()
{
	// KDM : UpdateSupplyRaidInfoBlade takes 7 parameters, not 11 !
	LibraryPanel.MC.BeginFunctionOp("UpdateSupplyRaidInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_LandedUFO'.default.m_strLandedUFOMission);
	LibraryPanel.MC.QueueString(GetRegion().GetMyTemplate().DisplayName);
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_LandedUFO'.default.m_strLandedUFOGreeble);
	LibraryPanel.MC.EndOp();
}

simulated function BuildRetaliationMissionPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationInfoBlade");
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(GetRegion().GetMyTemplate().DisplayName));
	LibraryPanel.MC.QueueString(class'UIMission_Retaliation'.default.m_strRetaliationMission);
	LibraryPanel.MC.QueueString(class'UIMission_Retaliation'.default.m_strRetaliationWarning);
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission
	LibraryPanel.MC.EndOp();
}

simulated function BuildRendezvousMissionPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationInfoBlade");
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(GetRegion().GetMyTemplate().DisplayName));
	LibraryPanel.MC.QueueString(m_strRendezvousMission);
	LibraryPanel.MC.QueueString(m_strUrgent);
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission
	LibraryPanel.MC.EndOp();
}

simulated function BuildInvasionMissionPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationInfoBlade");
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(GetRegion().GetMyTemplate().DisplayName));
	LibraryPanel.MC.QueueString(m_strInvasionMission);
	LibraryPanel.MC.QueueString(m_strInvasionWarning);
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission
	LibraryPanel.MC.EndOp();
}

simulated function BuildAlienFacilityMissionPanel()
{
	local XComGameState_LWAlienActivity Activity;

	Activity = GetAlienActivity();

	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionTitle());
	LibraryPanel.MC.QueueString(GetRegionName());				// defined in UIMission
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(super.GetObjectiveString());	// defined in UIMission -- don't pull the activity subobjective string
	
	if (Activity == none)
	{
		LibraryPanel.MC.QueueString(class'UIMission_AlienFacility'.default.m_strFlavorText);
	}
	else
	{
		LibraryPanel.MC.QueueString(Activity.GetMissionDescriptionForActivity());
	}
	
	if (GetMission().GetRewardAmountString() != "")
	{
		LibraryPanel.MC.QueueString(m_strReward $ ":");
		LibraryPanel.MC.QueueString(GetMission().GetRewardAmountString());
	}
	
	LibraryPanel.MC.EndOp();
}

simulated function BuildGoldenPathMissionPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathInfoBlade");
	LibraryPanel.MC.QueueString(GetMissionTitle());				// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIMission_GoldenPath'.default.m_strGPMissionSubtitle);
	LibraryPanel.MC.QueueString(GetMissionImage());				// defined in UIMission
	LibraryPanel.MC.QueueString(GetOpName());					// defined in UIMission
	LibraryPanel.MC.QueueString(m_strMissionObjective);			// defined in UIMission
	LibraryPanel.MC.QueueString(GetObjectiveString());			// defined in UIMission *
	LibraryPanel.MC.QueueString(GetMission().GetMissionSource().MissionFlavorText);	// defined in UIMission
	
	if (GetMission().GetRewardAmountString() != "")				// defined in UIMission
	{
		LibraryPanel.MC.QueueString(m_strReward $ ":");			// defined in UIMission
		LibraryPanel.MC.QueueString(GetMission().GetRewardAmountString());	// defined in UIMission
	}
	
	LibraryPanel.MC.EndOp();
}

// ----------------------------------------------------------------------
// ----------- BUILD OPTIONS PANEL (MISSION SPECIFIC) CODE --------------
// ----------------------------------------------------------------------

simulated function BuildGuerrillaOpsOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateGuerrillaOpsButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_GOps'.default.m_strGOpsSite);
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(GetRegionName());
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericConfirm);
	LibraryPanel.MC.QueueString(CanBackOut() ? m_strIgnore : "");	// defined in UIX2SimpleScreen
	LibraryPanel.MC.EndOp();

	Button1.SetText(GetRegionName());
	// KDM : Focus Button1, the region's name, so it appears highlighted; this is purely cosmetic.
	Button1.OnReceiveFocus();
	// LW2 : Guerrilla Ops only display 1 mission; therefore, hide Button2 and Button3.
	Button2.Hide();
	Button3.Hide();
	AddIgnoreButton();

	// KDM : UpdateGOpButtons need not be called since :
	// 1.] Button2 and Button3 are already hidden. 
	// 2.] RefreshNavigation is already called in super.BuildScreen, after option panel setup.
}

// KDM : I believe this function is never called since eMissionUI_Council is never referenced within 
// XComLW_Activities.ini
simulated function BuildCouncilOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateCouncilButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_Council'.default.m_strCouncilMission);
	LibraryPanel.MC.QueueString(m_strLaunchMission);			// defined in UIMission
	LibraryPanel.MC.QueueString(m_strIgnore);					// defined in UIX2SimpleScreen
	LibraryPanel.MC.EndOp();

	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.OnClickedDelegate = OnCancelClicked;

	Button3.Hide();
	ConfirmButton.Hide();
}

simulated function BuildSupplyRaidOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateSupplyRaidButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_SupplyRaid'.default.m_strSupplyRaidTitleGreeble);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(class'UIMission_SupplyRaid'.default.m_strRaidDesc));
	LibraryPanel.MC.QueueString(m_strLaunchMission);			// defined in UIMission
	LibraryPanel.MC.QueueString(m_strIgnore);					// defined in UIX2SimpleScreen
	LibraryPanel.MC.EndOp();

	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.OnClickedDelegate = OnCancelClicked;	
	
	Button3.Hide();
	ConfirmButton.Hide();
}

simulated function BuildLandedUFOOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateSupplyRaidButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_LandedUFO'.default.m_strLandedUFOTitleGreeble);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(class'UIMission_LandedUFO'.default.m_strMissionDesc));
	LibraryPanel.MC.QueueString(m_strLaunchMission);			// defined in UIMission
	LibraryPanel.MC.QueueString(m_strIgnore);					// defined in UIX2SimpleScreen
	LibraryPanel.MC.EndOp();

	Button1.OnClickedDelegate = OnLaunchClicked;
	Button2.OnClickedDelegate = OnCancelClicked;

	Button3.Hide();
	ConfirmButton.Hide();
}

simulated function BuildRetaliationOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationButtonBlade");
	LibraryPanel.MC.QueueString(class'UIMission_Retaliation'.default.m_strRetaliationWarning);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(class'UIMission_Retaliation'.default.m_strRetaliationDesc));
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericConfirm);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);
	LibraryPanel.MC.QueueString("");							// LockedTitle
	LibraryPanel.MC.QueueString("");							// LockedDesc
	LibraryPanel.MC.QueueString("");							// LockedOKButton
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

simulated function BuildRendezvousOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationButtonBlade");
	LibraryPanel.MC.QueueString(m_strUrgent);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(m_strRendezvousDesc));
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericConfirm);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);
	LibraryPanel.MC.QueueString("");							// LockedTitle
	LibraryPanel.MC.QueueString("");							// LockedDesc
	LibraryPanel.MC.QueueString("");							// LockedOKButton
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

simulated function BuildInvasionOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationButtonBlade");
	LibraryPanel.MC.QueueString(m_strInvasionWarning);
	LibraryPanel.MC.QueueString(GetRegionLocalizedDesc(m_strInvasionDesc));
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericConfirm);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);
	LibraryPanel.MC.QueueString("");							// LockedTitle
	LibraryPanel.MC.QueueString("");							// LockedDesc
	LibraryPanel.MC.QueueString("");							// LockedOKButton
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

simulated function BuildAlienFacilityOptionsPanel()
{
	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathIntel");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.EndOp();

	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathButtonBlade");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(class'UIMission_AlienFacility'.default.m_strLaunchMission);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);

	if (!CanTakeAlienFacilityMission())
	{
		LibraryPanel.MC.QueueString(m_strLocked);
		LibraryPanel.MC.QueueString(class'UIMission_AlienFacility'.default.m_strLockedHelp);
		LibraryPanel.MC.QueueString(m_strOK);					// OnCancelClicked
	}
	LibraryPanel.MC.EndOp();

	if (!CanTakeAlienFacilityMission())
	{
		// XCom : Hook up to the flash assets for locked info.
		LockedPanel = Spawn(class'UIPanel', LibraryPanel);
		LockedPanel.InitPanel('lockedMC', '');

		LockedButton = Spawn(class'UIButton', LockedPanel);
		LockedButton.InitButton('ConfirmButton', "", OnCancelClicked);
		
		// KDM : LockedButton should be a parent-panel centered hotlink for controller users, and a parent-panel 
		// centered button for mouse and keyboard users.
		if (`ISCONTROLLERACTIVE)
		{
			// KDM : Allow the hotlink to be shorter than 150 pixels, its flash-based default.
			LockedButton.MC.SetNum("MIN_WIDTH", 50);
			// KDM : Actually 'make' it a hotlink with a gamepad icon; furthermore, enable resizing.
			LockedButton.SetStyle(eUIButtonStyle_HOTLINK_BUTTON, , true);
			LockedButton.SetGamepadIcon(class'UIUtilities_Input'.static.GetBackButtonIcon());
			// KDM : Center the hotlink within its parent panel, once it has been realized.
			LockedButton.OnSizeRealized = OnLockedButtonSizeRealized;
		}
		else
		{
			// KDM : Turn off text resizing, for mouse and keyboard users, so LockedButton is nice and wide.
			LockedButton.SetResizeToText(false);
			LockedButton.SetPosition(50, 120);
		}

		LockedButton.SetText(m_strOK);
		LockedButton.Show();
	}
	else
	{
		Button1.OnClickedDelegate = OnLaunchClicked;
		Button2.OnClickedDelegate = OnCancelClicked;
	}

	Button1.SetBad(true);
	Button2.SetBad(true);

	if (!CanTakeAlienFacilityMission())
	{
		Button1.Hide();
		Button2.Hide();
	}
	Button3.Hide();
	ConfirmButton.Hide();
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

	LibraryPanel.MC.BeginFunctionOp("UpdateGoldenPathButtonBlade");
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(m_strLaunchMission);			// defined in UIMission
	LibraryPanel.MC.QueueString(class'UIUtilities_Text'.default.m_strGenericCancel);

	if (!CanTakeMission())
	{
		LibraryPanel.MC.QueueString(m_strLocked);
		LibraryPanel.MC.QueueString(class'UIMission_GoldenPath'.default.m_strLockedHelp);
		LibraryPanel.MC.QueueString(m_strOK);					// OnCancelClicked
	}
	LibraryPanel.MC.EndOp();

	if (!CanTakeMission())
	{
		// XCom : Hook up to the flash assets for locked info.
		LockedPanel = Spawn(class'UIPanel', LibraryPanel);
		LockedPanel.InitPanel('lockedMC', '');

		LockedButton = Spawn(class'UIButton', LockedPanel);
		LockedButton.InitButton('ConfirmButton', "", OnCancelClicked);
		
		// KDM : LockedButton should be a parent-panel centered hotlink for controller users, and a parent-panel 
		// centered button for mouse and keyboard users.
		if (`ISCONTROLLERACTIVE)
		{
			// KDM : Allow the hotlink to be shorter than 150 pixels, its flash-based default.
			LockedButton.MC.SetNum("MIN_WIDTH", 50);
			// KDM : Actually 'make' it a hotlink with a gamepad icon; furthermore, enable resizing.
			LockedButton.SetStyle(eUIButtonStyle_HOTLINK_BUTTON, , true);
			LockedButton.SetGamepadIcon(class'UIUtilities_Input'.static.GetBackButtonIcon());
			// KDM : Center the hotlink within its parent panel, once it has been realized.
			LockedButton.OnSizeRealized = OnLockedButtonSizeRealized;
		}
		else
		{
			// KDM : Turn off text resizing, for mouse and keyboard users, so LockedButton is nice and wide.
			LockedButton.SetResizeToText(false);
			LockedButton.SetPosition(50, 120);
		}

		LockedButton.SetText(m_strOK);
		LockedButton.Show();
		
		Button1.SetDisabled(true);
		Button2.SetDisabled(true);
	}
	else
	{
		Button1.OnClickedDelegate = OnLaunchClicked;
		Button2.OnClickedDelegate = OnCancelClicked;
	}

	Button1.SetBad(true);
	Button2.SetBad(true);

	if (!CanTakeMission())
	{
		Button1.Hide();
		Button2.Hide();
	}
	Button3.Hide();
	ConfirmButton.Hide();
}

// ----------------------------------------------------------------------
// -------------------------- HELPER FUNCTIONS --------------------------
// ----------------------------------------------------------------------

simulated function Name GetLibraryID()
{
	// LW2 : Allows for manual overrides.
	if (LibraryID != '')
	{
		return LibraryID;
	}

	switch(MissionUIType)
	{
	case eMissionUI_GuerrillaOps:
		return 'Alert_GuerrillaOpsBlades';
	case eMissionUI_SupplyRaid:
	case eMissionUI_LandedUFO:
		return 'Alert_SupplyRaidBlades';			// Used for 'Supply Raid' and 'Landed UFO' missions.
	case eMissionUI_GoldenPath:
	case eMissionUI_AlienFacility:
	case eMissionUI_GPIntel:
		return 'Alert_GoldenPath';					// Used for 'Alien Facility', 'Golden Path', and 'GPIntel' missions.
	case eMissionUI_Council:
		return 'Alert_CouncilMissionBlades';		// KDM : Likely never used since it's not referenced within XComLW_Activities.ini.
	case eMissionUI_Retaliation:
	case eMissionUI_Rendezvous:
	case eMissionUI_Invasion:
		return 'Alert_RetaliationBlades';
	default:
		return 'Alert_GuerrillaOpsBlades';
	}
}

simulated function string GetSFX()
{
	// LW2 : Allows for manual overrides.
	if (GeoscapeSFX != "")
	{
		return GeoscapeSFX;
	}

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

simulated function OnUnlockedButtonSizeRealized()
{
	local int XOffset, YOffset;

	// KDM : Supply Raid and Landed UFO option panels look different from other option panels; therefore,
	// their buttons need to be re-positioned a bit.
	XOffset = 0;
	YOffset = (IsSupplyRaidMission() || IsLandedUFOMission()) ? -20 : 0;

	Button1.SetX((-Button1.Width / 2.0) + XOffset);
	Button2.SetX((-Button2.Width / 2.0) + XOffset);
	
	Button1.SetY(10.0 + YOffset);
	Button2.SetY(40.0 + YOffset);
}

simulated function OnLockedButtonSizeRealized()
{
	LockedButton.SetX(200 - LockedButton.Width / 2.0);
	LockedButton.SetY(125.0);
}

simulated function OnButtonSizeRealized()
{
	// LW2 : Override this function to suppress UIMission.OnButtonSizeRealized which modifies the confirm 
	// button's X location.
}

simulated function bool IsAlienFacilityMission()
{
	return MissionUIType == eMissionUI_AlienFacility;
}

simulated function bool IsGoldenPathMission()
{
	return MissionUIType == eMissionUI_GoldenPath;
}

simulated function bool IsGuerrillaOpMission()
{
	return MissionUIType == eMissionUI_GuerrillaOps;
}

simulated function bool IsSupplyRaidMission()
{
	return MissionUIType == eMissionUI_SupplyRaid;
}

simulated function bool IsLandedUFOMission()
{
	return MissionUIType == eMissionUI_LandedUFO;
}

simulated function String GetMissionTitle()
{
	return GetMission().GetMissionDescription();
}

simulated function bool CanBackOut()
{
	return (super.CanBackOut() && class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M7_WelcomeToGeoscape'));
}

simulated function OnRemoved()
{
	super.OnRemoved();

	// KDM : Removed LW code found here since it already exists within UIMission.OnRemoved.
	// I am leaving this function here as a reminder of the change.
}

simulated function AddIgnoreButton()
{
	// XCom : Flash shows IgnoreButton by default; therefore, it needs to be hidden manually if desired.
	IgnoreButton = Spawn(class'UIButton', LibraryPanel);
	
	if (CanBackOut())
	{
		if (!`ISCONTROLLERACTIVE)
		{
			IgnoreButton.InitButton('IgnoreButton', "", OnCancelClicked);
			IgnoreButton.SetResizeToText(false);
		}
		else
		{
			IgnoreButton.InitButton('IgnoreButton', "", OnCancelClicked, eUIButtonStyle_HOTLINK_BUTTON);
			IgnoreButton.SetResizeToText(true);
			IgnoreButton.SetGamepadIcon(class'UIUtilities_Input'.static.GetBackButtonIcon());
			IgnoreButton.SetX(1450.0);
			IgnoreButton.SetY(644.0);
		}
	}
	else
	{
		IgnoreButton.InitButton('IgnoreButton').Hide();
	}
}

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
	if (AlienActivity != none)
	{
		return AlienActivity.GetMissionImage(MissionSite);
	}

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
		RewardString = "$$$" $ RewardString;	// LW2 : This is intended to handle any repeats.
		OldCaptureRewardString = Mid(RewardString, 0, Instr(RewardString, ","));
		NewCaptureRewardString = OldCaptureRewardString @ class'UIUtilities_LW'.default.m_strVIPCaptureReward;
		RewardString = Repl (RewardString, OldCaptureRewardString, NewCaptureRewardString);
		RewardString -= "$$$";
	}
	return RewardString;
}

simulated function bool CanTakeAlienFacilityMission()
{
	return GetRegion().HaveMadeContact();
}

// KDM : The navigation system, set up in UIMission.RefreshNavigation, is a mess; override it here and 
// clean it up.
simulated function RefreshNavigation()
{
	local bool SelectionSet;
	local UIPanel DefaultPanel;

	SelectionSet = false;

	// KDM : Enable focus cascading so Navigator.Clear kills 'all' UI focus.
	LibraryPanel.bCascadeFocus = true;
	ButtonGroup.bCascadeFocus = true;
	DefaultPanel = LibraryPanel.GetChildByName('DefaultPanel', false);
	if (DefaultPanel != none)
	{
		DefaultPanel.bCascadeFocus = true;
	}

	// KDM : Empty the navigation system.
	Navigator.Clear();
	Navigator.LoopSelection = true;

	// KDM : The navigation system need not be setup for controller users, since they use hotlinks.
	if (!`ISCONTROLLERACTIVE)
	{
		// KDM : If a button exists, and is visible, then add it to the Navigator.
		SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(self, LockedButton, SelectionSet);
		SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(self, ConfirmButton, SelectionSet);
		SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(self, IgnoreButton, SelectionSet);
		
		// The 'Guerrilla Ops' option panel is distinct since Button1 is used to display a region name rather 
		// than act as a 'clickable' button.
		if (!IsGuerrillaOpMission())
		{
			SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(self, Button1, SelectionSet);
			SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(self, Button2, SelectionSet);
			SelectionSet = class'UIUtilities_LW'.static.AddBtnToNavigatorAndSelect(self, Button3, SelectionSet);
		}
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local UIButton SelectedButton;

	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	switch(cmd)
	{
	// KDM : The spacebar and enter key 'click' on the selected button. Previously, the spacebar and
	// enter key would only attempt to 'click' ConfirmButton or Button1.
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
		SelectedButton = UIButton(Navigator.GetSelected());
		if (SelectedButton != none && SelectedButton.OnClickedDelegate != none)
		{
			SelectedButton.Click();
			return true;
		}
		break;
	}

	return super.OnUnrealCommand(cmd, arg);
}

defaultproperties
{
	Package = "/ package/gfxAlerts/Alerts";
	InputState = eInputState_Consume;
}
