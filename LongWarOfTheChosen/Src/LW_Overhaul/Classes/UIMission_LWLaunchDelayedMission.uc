//---------------------------------------------------------------------------------------
//  FILE:    UIMission_LWLaunchDelayedMission.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Provides controls for actually launching a mission that has been infiltrated
//---------------------------------------------------------------------------------------
class UIMission_LWLaunchDelayedMission extends UIMission config(LW_InfiltrationSettings);

//Issue #140
//This needs to be here for the function BindLibraryItem() so that it can behave the same
//as the BindLibraryItem() function in class UIMission_LWCustomMission().
var EMissionUIType MissionUIType;

var UITextContainer InfiltrationInfoText;
var UITextContainer MissionInfoText;

var localized string m_strMission;
var localized string m_strOptions;
var localized string m_strImageGreeble;
var localized string m_strWait;
var localized string m_strAbort;

var localized string m_strBoostInfiltration;
var localized string m_strAlreadyBoostedInfiltration;
var localized string m_strInsufficentIntelForBoostInfiltration;
var localized string m_strViewSquad;

var localized string m_strInfiltrationStatusExpiring;
var localized string m_strInfiltrationStatusNonExpiring;
var localized string m_strInfiltrationStatusMissionEnding;
var localized string m_strInfiltrationConsequence;
var localized string m_strMustLaunchMission;
var localized string m_strInsuffientInfiltrationToLaunch;

var localized string m_strBoostInfiltrationDescription;

var localized array<string> m_strAlertnessModifierDescriptions;

var UIButton IgnoreButton;

var bool bCachedMustLaunch;
var bool bAborted;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState_LWAlienActivity AlienActivity;

	super.InitScreen(InitController, InitMovie, InitName);

	AlienActivity = GetActivity();
	bCachedMustLaunch = AlienActivity != none && AlienActivity.bMustLaunch;

	BuildScreen();
}

simulated function Name GetLibraryID()
{
	return 'Alert_GuerrillaOpsBlades';
}

/*********************************** Issue #140 ***********************************
* This function needs to be here because this is the function that displays the
* shadow chamber information on the top right of the mission information panel.
* have to do the same thing that was done in class UIMission_LWCustomMission for
* the BindLibraryItem() fucntion there.
**********************************************************************************/
simulated function BindLibraryItem()
{
	super.BindLibraryItem();
	
	if(MissionUIType != eMissionUI_GoldenPath)
	{
		//Issue #140 Hide the Shadow Chamber panel. Do not want to show for anything other than
		//Golden Path missions.
		ShadowChamber.Hide();
	}
}

simulated function BuildScreen()
{
	PlaySFX("Geoscape_NewResistOpsMissions");
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
	class'UIUtilities_LW'.static.BuildMissionInfoPanel(self, MissionRef, true);

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
	local string strDarkEventLabel, strDarkEventValue, strDarkEventTime;
	local XComGameState_LWAlienActivity AlienActivity;
	local bool bHasDarkEvent;
	local X2RewardTemplate UnknownTemplate;
	local X2StrategyElementTemplateManager StratMgr;
	local XComGameState_MissionSite Mission;
	local X2StrategyElementTemplateManager TemplateMgr;
	local X2ObjectiveTemplate Template;

	Mission = GetMission();

	bHasDarkEvent = Mission.HasDarkEvent();

	if(bHasDarkEvent)
	{
		strDarkEventLabel = class'UIMission_GOps'.default.m_strDarkEventLabel;
		strDarkEventValue = Mission.GetDarkEvent().GetDisplayName();
		strDarkEventTime = Mission.GetDarkEvent().GetPreMissionText();
	}
	else
	{
		strDarkEventLabel = "";
		strDarkEventValue = "";
		strDarkEventTime = "";
	}

	LibraryPanel.MC.BeginFunctionOp("UpdateGuerrillaOpsInfoBlade");
	LibraryPanel.MC.QueueString(GetRegion().GetMyTemplate().DisplayName);
	LibraryPanel.MC.QueueString(m_strMission);
	LibraryPanel.MC.QueueString(GetMissionImage());
	LibraryPanel.MC.QueueString(m_strMissionLabel);
	LibraryPanel.MC.QueueString(GetOpName());
	LibraryPanel.MC.QueueString(m_strMissionObjective);
	LibraryPanel.MC.QueueString(GetObjectiveString());
	LibraryPanel.MC.QueueString(m_strMissionDifficulty);
	LibraryPanel.MC.QueueString(class'UIUtilities_Text_LW'.static.GetDifficultyString(Mission));
	LibraryPanel.MC.QueueString(m_strReward);

	if(GetRewardString() != "")
	{
		LibraryPanel.MC.QueueString(GetRewardString());
	}
	else
	{
		StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
		UnknownTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Dummy_Unknown'));
		LibraryPanel.MC.QueueString(UnknownTemplate.DisplayName);
	}
	LibraryPanel.MC.QueueString(strDarkEventLabel);
	LibraryPanel.MC.QueueString(strDarkEventValue);
	LibraryPanel.MC.QueueString(strDarkEventTime);
	LibraryPanel.MC.QueueString(GetRewardIcon());
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

	AlienActivity = `LWACTIVITYMGR.FindAlienActivityByMission(Mission);
	if(AlienActivity != none)
	{
		MissionInfoText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(AlienActivity.GetMissionDescriptionForActivity(), eUIState_Normal));
	}
	else
	{
		if (Mission.GetMissionSource().bGoldenPath)
		{
			switch (Mission.GetMissionSource().DataName)
			{
				case 'MissionSource_BlackSite':
				case 'MissionSource_Forge':
				case 'MissionSource_PsiGate':
					MissionInfoText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(Mission.GetMissionSource().MissionFlavorText, eUIState_Normal));
					break;
				case 'MissionSource_Broadcast':
					TemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
					if (TemplateMgr != none)
					{
						Template = X2ObjectiveTemplate(TemplateMgr.FindStrategyElementTemplate('T5_M2_CompleteBroadcastTheTruthMission'));
						if (Template != none)
						{
							MissionInfoText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(Template.LocLongDescription, eUIState_Normal));
						}
					}
					break;
				default:
					MissionInfoText.Hide();
					break;
			}
		}
		else
		{
			MissionInfoText.Hide();
		}
	}
}

simulated function BuildOptionsPanel()
{
	local string Reason;

	LibraryPanel.MC.BeginFunctionOp("UpdateGuerrillaOpsButtonBlade");
	LibraryPanel.MC.QueueString(m_strOptions);
	LibraryPanel.MC.QueueString(""); //// left blank in favor of a separately placed string, InfiltrationInfoText
	//LibraryPanel.MC.QueueString(GetInfiltrationString());
	LibraryPanel.MC.QueueString(m_strBoostInfiltration);
	LibraryPanel.MC.QueueString(m_strViewSquad);
	LibraryPanel.MC.QueueString(m_strAbort);
	LibraryPanel.MC.QueueString(m_strLaunchMission);
	LibraryPanel.MC.QueueString((bCachedMustLaunch ? class'UISkyrangerArrives'.default.m_strReturnToBase : m_strWait));
	LibraryPanel.MC.EndOp();

	Button1.OnClickedDelegate = OnBoostInfiltrationClicked;
	Button2.OnClickedDelegate = OnViewSquadClicked;
	//If mission is expiring, can't Cancel/wait, so need to disable
	Button3.OnClickedDelegate = OnAbortClicked;

	BuildConfirmPanel();

	if (CanBoostInfiltration(Reason))
		Button1.SetDisabled(false);
	else
		Button1.SetDisabled(true, Reason);

	if (CanLaunchInfiltration(Reason))
		ConfirmButton.SetDisabled(false);
	else
		ConfirmButton.SetDisabled(true, Reason);

	// BuildConfirmPanel does nothing, but left in for comparison with UIMission_GOps.
	// BuildConfirmPanel();
	AddIgnoreButton();
	RefreshNavigation();
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
		if (ActivityTemplate != none)
		{
			ActivityObjective = ActivityTemplate.ActivityObjectives[AlienActivity.CurrentMissionLevel];
		}
		//if(ActivityObjective == "")
			//ActivityObjective = "Missing ActivityObjectives[" $ AlienActivity.CurrentMissionLevel $ "] for AlienActivity " $ ActivityTemplate.DataName;
	}
	ObjectiveString $= ActivityObjective;

	return ObjectiveString;
}

simulated function XComGameState_LWAlienActivity GetAlienActivity()
{
	return class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(GetMission());
}

simulated function bool CanBoostInfiltration(out string Reason)
{
	local XComGameState_LWPersistentSquad Squad;
	local XGParamTag ParamTag;
	local bool bCanBoost, bCanAfford;
	local StrategyCost BoostInfiltrationCost;
	local array<StrategyCostScalar> CostScalars;

	bCanBoost = true;
	Squad =  GetInfiltratingSquad();
	BoostInfiltrationCost = Squad.GetBoostInfiltrationCost();
	CostScalars.Length = 0;
	bCanAfford = `XCOMHQ.CanAffordAllStrategyCosts(BoostInfiltrationCost, CostScalars);
	if (Squad.bHasBoostedInfiltration)
	{
		ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		ParamTag.StrValue0 = Squad.sSquadName;
		Reason = `XEXPAND.ExpandString(m_strAlreadyBoostedInfiltration);

		bCanBoost = false;
	}
	else if (!bCanAfford)
	{
		Reason = m_strInsufficentIntelForBoostInfiltration;

		bCanBoost = false;
	}

	return bCanBoost;
}

simulated function bool CanLaunchInfiltration(out string Reason)
{
	local XComGameState_LWPersistentSquad Squad;
	local XComGameState_MissionSite MissionState;
	local XGParamTag ParamTag;

	Squad =  GetInfiltratingSquad();
	MissionState = GetMission();

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = Round(Squad.GetRequiredPctInfiltrationToLaunch(MissionState));
	Reason = `XEXPAND.ExpandString(m_strInsuffientInfiltrationToLaunch);

	return Squad.HasSufficientInfiltrationToStartMission(MissionState);
}

simulated function string GetMissionImage()
{
	local XComGameState_LWAlienActivity AlienActivity;

	AlienActivity = GetActivity();
	if(AlienActivity != none)
		return AlienActivity.GetMissionImage(GetMission());

	return "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Guerrilla_Ops";
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
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Geoscape_AlienOperation");
	XComHQPresentationLayer(Movie.Pres).CAMLookAtEarth(GetMission().Get2DLocation(), CAMERA_ZOOM);

	BuildMissionPanel();
	//RefreshNavigation();

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

simulated function XComGameState_LWPersistentSquad GetInfiltratingSquad()
{
	local XComGameState_LWSquadManager SquadMgr;

	SquadMgr = `LWSQUADMGR;
	if(SquadMgr == none)
	{
		`REDSCREEN("UIStrategyMapItem_Mission_LW: No SquadManager");
		return none;
	}
	return SquadMgr.GetSquadOnMission(MissionRef);
}

simulated public function OnLaunchClicked(UIButton button)
{
	local XComGameState_LWPersistentSquad InfiltratingSquad;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState UpdateState;

	InfiltratingSquad = GetInfiltratingSquad();
	if(InfiltratingSquad == none)
	{
		`REDSCREEN("UIMission_LWLaunchDelayedMission: No Infiltrating Squad");
		return;
	}
	// update the XComHQ mission ref first, so that it is available when setting the squad
	XComHQ = `XCOMHQ;
	UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update XComHQ for current mission being started");
	XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	XComHQ.MissionRef = InfiltratingSquad.CurrentMission;
	UpdateState.AddStateObject(XComHQ);
	`GAMERULES.SubmitGameState(UpdateState);

	InfiltratingSquad.SetSquadCrew();

	XComHQ.PauseProjectsForFlight();
	XComHQ.ResumeProjectsPostFlight();

	//TODO : handle black transition screen
	GetMission().ConfirmMission();
}

simulated public function OnBoostInfiltrationClicked(UIButton button)
{
	local TDialogueBoxData kDialogData;
	local XGParamTag ParamTag;
	local XComGameState_LWPersistentSquad Squad;
	local StrategyCost BoostInfiltrationCost;
	local array<StrategyCostScalar> CostScalars;

	Squad =  GetInfiltratingSquad();
	BoostInfiltrationCost = Squad.GetBoostInfiltrationCost();
	CostScalars.Length = 0;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.StrValue0 = class'UIUtilities_Strategy'.static.GetStrategyCostString(BoostInfiltrationCost, CostScalars);
	//ParamTag.IntValue0 = Squad.DefaultBoostInfiltrationCost[`STRATEGYDIFFICULTYSETTING];
	ParamTag.IntValue1 = Round((Squad.DefaultBoostInfiltrationFactor[`STRATEGYDIFFICULTYSETTING] - 1.0) * 100.0);

	PlaySound(SoundCue'SoundUI.HUDOnCue');

	kDialogData.eType = eDialog_Normal;
	kDialogData.strTitle = m_strBoostInfiltration;
	kDialogData.isModal = true;
	kDialogData.strText = `XEXPAND.ExpandString(m_strBoostInfiltrationDescription);
	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	kDialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNO;
	kDialogData.fnCallback = ConfirmBoostInfiltrationCallback;

	Movie.Pres.UIRaiseDialog(kDialogData);
	return;

}

simulated function ConfirmBoostInfiltrationCallback(Name Action)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_LWPersistentSquad Squad, UpdatedSquad;

	if(Action == 'eUIAction_Accept')
	{
		History = `XCOMHISTORY;
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Boost Infiltration");
		Squad = GetInfiltratingSquad();
		UpdatedSquad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', Squad.ObjectID));
		NewGameState.AddStateObject(UpdatedSquad);
		UpdatedSquad.bHasBoostedInfiltration = true;
		UpdatedSquad.SpendBoostResource(NewGameState);

		if (NewGameState.GetNumGameStateObjects() > 0)
			`GAMERULES.SubmitGameState(NewGameState);
		else
			History.CleanupPendingGameState(NewGameState);

        // update the infiltration status, but don't pause the game. We're already in a popup and actually paused completely, and this
        // update "pause" actually resets to 'slow time' and causes a hang.
		UpdatedSquad.UpdateInfiltrationState(false);

		`LWACTIVITYMGR.UpdateMissionData(GetMission()); // update units on the mission, since AlertLevel likely changed

		// rebuild the panels to display the updated status
		BuildMissionPanel();
		BuildOptionsPanel();
		class'UIUtilities_LW'.static.BuildMissionInfoPanel(self, MissionRef, true);

		Movie.Pres.PlayUISound(eSUISound_SoldierPromotion);
	}
	else
		Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
}

// START Copied from View Infiltrating Squad mod by LeaderEnemyBoss
simulated public function OnViewSquadClicked(UIButton button)
{
	local UIPersonnel_LEBVS kPersonnelList;
	local UIMission_LWLaunchDelayedMission LWLaunchScreen;
	local UIScreen CurrScreen;

	foreach `SCREENSTACK.Screens(CurrScreen)
	{
		if(UIMission_LWLaunchDelayedMission(CurrScreen) != none ) break;
	}

	LWLaunchScreen = UIMission_LWLaunchDelayedMission(CurrScreen);

	if (`HQPRES.ScreenStack.IsNotInStack(class'UIPersonnel_LEBVS'))
	{
		kPersonnelList = `HQPRES.Spawn(class'UIPersonnel_LEBVS', `HQPRES);
		kPersonnelList.SoldierList = LWLaunchScreen.GetInfiltratingSquad().SquadSoldiersOnMission;
		kPersonnelList.onSelectedDelegate = OnPersonnelSelected;
		`HQPRES.ScreenStack.Push(kPersonnelList);
	}
}

simulated function OnPersonnelSelected(StateObjectReference selectedUnitRef)
{
	`HQPRES.UIArmory_MainMenu(selectedUnitRef);
}
// END

simulated public function OnAbortClicked(UIButton button)
{
	local XComGameStateHistory History;
	local XComGameState_Skyranger SkyrangerState;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_GeoscapeEntity ThisEntity;
	local XComGameState_MissionSite Mission;
	local XComGameState_LWPersistentSquad Squad;

	if(CanBackOut())
	{
		Mission = GetMission();

		if(Mission.GetMissionSource().DataName != 'MissionSource_Final' || class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T5_M3_CompleteFinalMission') != eObjectiveState_InProgress)
		{
			//Restore the saved camera location
			XComHQPresentationLayer(Movie.Pres).CAMRestoreSavedLocation();
		}
		History = `XCOMHISTORY;
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Set Squad As On Board");
		SkyrangerState = XComGameState_Skyranger(NewGameState.CreateStateObject(class'XComGameState_Skyranger', XComHQ.SkyrangerRef.ObjectID));
		SkyrangerState.SquadOnBoard = true;
		NewGameState.AddStateObject(SkyrangerState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

		if (Mission.Region == XComHQ.Region || Mission.Region.ObjectID == 0)
		{
			// move skyranger directly to mission
			ThisEntity = Mission;
			XComHQ.SetPendingPointOfTravel(ThisEntity);
		}
		else
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Store cross continent mission reference");
			XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			NewGameState.AddStateObject(XComHQ);
			XComHQ.CrossContinentMission = MissionRef;
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

			// move skyranger to region first
			ThisEntity = Mission.GetWorldRegion();
			XComHQ.SetPendingPointOfTravel(ThisEntity);
		}

		if (bCachedMustLaunch)
		{
			Squad = `LWSQUADMGR.GetSquadOnMission(MissionRef);
			if (Squad != none)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Mark Squad Abort Status");
				Squad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', Squad.ObjectID));
				NewGameState.AddStateObject(Squad);
				Squad.bCannotCancelAbort = true;
				`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
			}
		}

		bAborted = true;
		CloseScreen();
	}
}

simulated function CloseScreen()
{
	local UIScreenStack ScreenStack;
	local UIStrategyMap StrategyMap;
	//local UIScreen aScreen;

	ScreenStack = `SCREENSTACK;
	//foreach ScreenStack.Screens(aScreen)
	//{
		//`LOG("Closing LaunchDelayedMission:" @ aScreen.Class);
	//}

	if(bCachedMustLaunch && !bAborted)
	{
		super.CloseScreen();
		StrategyMap = UIStrategyMap(ScreenStack.GetScreen(class'UIStrategyMap'));
		StrategyMap.CloseScreen();
	}
	else
	{
		super.CloseScreen();
	}
}

simulated function XComGameState_LWAlienActivity GetActivity()
{
	return `LWACTIVITYMGR.FindAlienActivityByMission(GetMission());
}

defaultproperties
{
	Package = "/ package/gfxAlerts/Alerts";
	InputState = eInputState_Consume;
}
