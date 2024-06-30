//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Adds additional functionality to SquadSelect_LW (from Toolbox)
//			 Provides support for squad-editting without launching mission
//--------------------------------------------------------------------------------------- 

class UIScreenListener_SquadSelect_LW extends UIScreenListener config(LW_Overhaul);

var localized string strSave;
var localized string strSquad;

var localized string strStart;
var localized string strInfiltration;

var localized string strAreaOfOperations;

//var config array<name> NonInfiltrationMissions;

var bool bInSquadEdit;
var GeneratedMissionData MissionData;

var config float SquadInfo_DelayedInit;
var config bool bLeftMissionInfoPanel;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local UISquadSelect SquadSelect;
	local XComGameState_LWSquadManager SquadMgr;
	local UISquadSelect_InfiltrationPanel InfiltrationInfo;
	local UISquadContainer SquadContainer;
	local XComGameState_MissionSite MissionState;
	local UITextContainer InfilRequirementText, MissionBriefText;
	local UISquadSelect_InfiltrationItem MissionBriefHeader;
	local UISquadSelect_InfiltrationItem MissionTypeText;
	local UISquadSelect_InfiltrationItem MissionTimerText;
	local UISquadSelect_InfiltrationItem EvacTypeText;
	local UISquadSelect_InfiltrationItem SweepObjectiveText;
	local UISquadSelect_InfiltrationItem FullSalvageText;
	local UISquadSelect_InfiltrationItem ConcealStatusText;
	local UISquadSelect_InfiltrationItem PlotTypeText;
	local UIPanel MissionInfoPanel;
	local float RequiredInfiltrationPct;
	local string BriefingString;
	local int rollingY, yOffset, bigYOffset;

	if(!Screen.IsA('UISquadSelect')) return;

	SquadSelect = UISquadSelect(Screen);
	if(SquadSelect == none) return;

	class'LWHelpTemplate'.static.AddHelpButton_Std('SquadSelect_Help', SquadSelect, 1057, 12);

	XComHQ = `XCOMHQ;
	SquadMgr = `LWSQUADMGR;

	// pause and resume all headquarters projects in order to refresh state
	// this is needed because exiting squad select without going on mission can result in projects being resumed w/o being paused, and they may be stale
	XComHQ.PauseProjectsForFlight();
	XComHQ.ResumeProjectsPostFlight();

	XComHQ = `XCOMHQ;
	SquadSelect.XComHQ = XComHQ; // Refresh the squad select's XComHQ since it's been updated

	MissionData = XComHQ.GetGeneratedMissionData(XComHQ.MissionRef.ObjectID);

	UpdateMissionDifficulty(SquadSelect);

	//check if we got here from the SquadBarracks
	bInSquadEdit = `SCREENSTACK.IsInStack(class'UIPersonnel_SquadBarracks');
	if(bInSquadEdit)
	{
		if (`ISCONTROLLERACTIVE)
		{
			// KDM : Hide the 'Save Squad' button which appears while viewing a Long War squad's soldiers.
			// As an aside, I don't believe this functionality actually works.
			SquadSelect.LaunchButton.Hide();
		}
		else
		{
			SquadSelect.LaunchButton.OnClickedDelegate = OnSaveSquad;
			SquadSelect.LaunchButton.SetText(strSquad);
			SquadSelect.LaunchButton.SetTitle(strSave);
		}

		SquadSelect.m_kMissionInfo.Remove();
	} 
	else 
	{
		`Log("UIScreenListener_SquadSelect_LW: Arrived from mission");
		if(SquadMgr.IsValidInfiltrationMission(XComHQ.MissionRef))
		{
			`Log("UIScreenListener_SquadSelect_LW: Setting up for infiltration mission");

			if (`ISCONTROLLERACTIVE)
			{
				SquadSelect.LaunchButton.SetText(class'UIUtilities_Text'.static.InjectImage(
						class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_START, 26, 26, -10) @ strStart);
			}
			else
			{
				SquadSelect.LaunchButton.SetText(strStart);
			}
			SquadSelect.LaunchButton.SetTitle(strInfiltration);

			InfiltrationInfo = SquadSelect.Spawn(class'UISquadSelect_InfiltrationPanel', SquadSelect);
			InfiltrationInfo.MCName = 'SquadSelect_InfiltrationInfo_LW';
			InfiltrationInfo.MissionData = MissionData;
			InfiltrationInfo.SquadSoldiers = SquadSelect.XComHQ.Squad;
			InfiltrationInfo.DelayedInit(default.SquadInfo_DelayedInit);

			// check if we need to infiltrate to 100% and display a message if so
			MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
			RequiredInfiltrationPct = class'XComGameState_LWPersistentSquad'.static.GetRequiredPctInfiltrationToLaunch(MissionState);
			if (RequiredInfiltrationPct > 0.0)
			{
				InfilRequirementText = SquadSelect.Spawn(class'UITextContainer', SquadSelect);
				InfilRequirementText.MCName = 'SquadSelect_InfiltrationRequirement_LW';
				InfilRequirementText.bAnimateOnInit = false;
				InfilRequirementText.InitTextContainer('',, 725, 100, 470, 50, true, /* class'UIUtilities_Controls'.const.MC_X2Background */, /* true */);
				InfilRequirementText.bg.SetColor(class'UIUtilities_Colors'.const.BAD_HTML_COLOR);
				InfilRequirementText.SetHTMLText(RequiredInfiltrationString(RequiredInfiltrationPct));
				InfilRequirementText.SetAlpha(66);
			}
		}

		// KDM : Allow the 'Squad Container', which deals with squad selection on the Squad Select screen,
		// to be hidden through non-creation. My controller-capable Squad Management mod has its own squad 
		// selection and display UI which overlaps with LW2's UI.
		if (!`ISCONTROLLERACTIVE)
		{
			// LW : Create the SquadContainer on a timer, to avoid creation issues that can arise when creating it immediately, when no pawn loading is present
			SquadContainer = SquadSelect.Spawn(class'UISquadContainer', SquadSelect);
			SquadContainer.CurrentSquadRef = SquadMgr.LaunchingMissionSquad;
			SquadContainer.DelayedInit(default.SquadInfo_DelayedInit);
		}

		// 

		MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));

		if(class'UISquadSelect_InfiltrationPanel'.default.USE_NEW_VERSION)
		{
			MissionInfoPanel = SquadSelect.Spawn(class'UIPanel', SquadSelect);
			MissionInfoPanel.InitPanel('LWMissionInfoPanel');

			if(default.bLeftMissionInfoPanel)
				MissionInfoPanel.SetPosition(505, 60);
			else
				MissionInfoPanel.SetPosition(1155, 60);

			rollingY = 0;
			yOffset = 25;
			bigYOffset = 30;

			MissionBriefHeader = MissionInfoPanel.Spawn(class'UISquadSelect_InfiltrationItem', MissionInfoPanel).InitObjectiveListItem(0, rollingY);
			MissionBriefHeader.SetSubtitle(class'UISquadSelect_InfiltrationPanel'.default.strMissionInfoTitle);
			rollingY += YOffset;

			MissionTypeText = MissionInfoPanel.Spawn(class'UISquadSelect_InfiltrationItem', MissionInfoPanel).InitObjectiveListItem(10, rollingY);
			MissionTypeText.SetNewText(class'UIUtilities_LW'.static.GetMissionTypeString (XComHQ.MissionRef));
			rollingY += yOffset;

			MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));

			if (class'UIUtilities_LW'.static.GetTimerInfoString (MissionState) != "")
			{
				MissionTimerText = MissionInfoPanel.Spawn(class'UISquadSelect_InfiltrationItem', MissionInfoPanel).InitObjectiveListItem(10, rollingY);
				MissionTimerText.SetNewText(class'UIUtilities_LW'.static.GetTimerInfoString (MissionState));
				rollingY += yOffset;
			}

			EvacTypeText = MissionInfoPanel.Spawn(class'UISquadSelect_InfiltrationItem', MissionInfoPanel).InitObjectiveListItem(10, rollingY);
			EvacTypeText.SetNewText(class'UIUtilities_LW'.static.GetEvacTypeString (MissionState));
			rollingY += yOffset;

			if (class'UIUtilities_LW'.static.HasSweepObjective(MissionState))
			{
				SweepObjectiveText = MissionInfoPanel.Spawn(class'UISquadSelect_InfiltrationItem', MissionInfoPanel).InitObjectiveListItem(10, rollingY);
				SweepObjectiveText.SetNewText(class'UIUtilities_LW'.default.m_strSweepObjective);
				rollingY += yOffset;
			}
			if (class'UIUtilities_LW'.static.FullSalvage(MissionState))
			{
				FullSalvageText = MissionInfoPanel.Spawn(class'UISquadSelect_InfiltrationItem', MissionInfoPanel).InitObjectiveListItem(10, rollingY);
				FullSalvageText.SetInfoValue(class'UIUtilities_LW'.default.m_strGetCorpses, class'UIUtilities_Colors'.const.GOOD_HTML_COLOR);
				rollingY += yOffset;
			}

			ConcealStatusText = MissionInfoPanel.Spawn(class'UISquadSelect_InfiltrationItem', MissionInfoPanel).InitObjectiveListItem(10, rollingY);
			ConcealStatusText.SetNewText(class'UIUtilities_LW'.static.GetMissionConcealStatusString (XComHQ.MissionRef));
			rollingY += yOffset;

			PlotTypeText = MissionInfoPanel.Spawn(class'UISquadSelect_InfiltrationItem', MissionInfoPanel).InitObjectiveListItem(10, rollingY);
			PlotTypeText.SetNewInfoValue(class'UISquadSelect_InfiltrationPanel'.default.strMapTypeText, class'UIUtilities_LW'.static.GetPlotTypeFriendlyName(MissionState.GeneratedMission.Plot.strType), class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR);

			/* 
			`LWTrace("Initing new mission info panel");
			MissionBriefText = SquadSelect.Spawn (class'UITextContainer', SquadSelect);
			MissionBriefText.MCName = 'SquadSelect_MissionBrief_LW';
			MissionBriefText.bAnimateOnInit = false;
			MissionBriefText.bIsNavigable = false;
			x = 1545;
			y = 375;
			MissionBriefText.InitTextContainer('LWMissionInfoPanel',, x, y, 375, 300, false);
			x=0;
			y=0;

			MissionTypeStr = MissionBriefText.Spawn(class'UIText', MissionBriefText);
			MissionTypeStr.bAnimateOnInit = false;
			MissionTypeStr.bIsNavigable = false;
			MissionTypeStr.InitText();
			MissionTypeStr.SetPosition(X, Y);
			MissionTypeStr.SetSubtitle("Mission Information:");
			MissionTypeStr.Show();
			rollingY = rollingY + MissionTYpeStr.Height;

			if (class'UIUtilities_LW'.static.GetTimerInfoString (MissionState) != "")
			{
				`LWTrace("Adding Timer info string");
				TimerInfoStr = MissionBriefText.Spawn(class'UIText', MissionBriefText);
				TimerInfoStr.bAnimateOnInit = false;
				TimerInfoStr.bIsNavigable = false;
				TimerInfoStr.InitText();
				TimerInfoStr.SetPosition(X, y + rollingY);
				TimerInfoStr.SetText(class'UIUtilities_LW'.static.GetTimerInfoString (MissionState));
				TimerInfoStr.Show();
				rollingY += TimerInfoStr.Height;
			}

			EvacTypeStr = MissionBriefText.Spawn(class'UIText', MissionBriefText);
			EvacTypeStr.bAnimateOnInit = false;
			EvacTypeStr.bIsNavigable = false;
			EvacTypeStr.InitText();
			EvacTypeStr.SetPosition(X, y + rollingY);
			EvacTypeStr.SetHTMLText(class'UIUtilities_LW'.static.GetEvacTypeString (MissionState));
			EvacTypeStr.Show();
			rollingY += EvacTypeStr.Height;

			if (class'UIUtilities_LW'.static.HasSweepObjective(MissionState))
			{
				SweepObjStr = MissionBriefText.Spawn(class'UIText', MissionBriefText);
				SweepObjStr.bAnimateOnInit = false;
				SweepObjStr.bIsNavigable = false;
				SweepObjStr.InitText();
				SweepObjStr.SetPosition(X, y + rollingY);
				SweepObjStr.SetHTMLText(class'UIUtilities_LW'.default.m_strSweepObjective);
				SweepObjStr.Show();
				rollingY += EvacTypeStr.Height;
			}

			if (class'UIUtilities_LW'.static.FullSalvage(MissionState))
			{
				FullSalvageStr = MissionBriefText.Spawn(class'UIText', MissionBriefText);
				FullSalvageStr.bAnimateOnInit = false;
				FullSalvageStr.bIsNavigable = false;
				FullSalvageStr.InitText();
				FullSalvageStr.SetPosition(X, y + rollingY);
				FullSalvageStr.SetHTMLText(class'UIUtilities_LW'.default.m_strGetCorpses);
				FullSalvageStr.Show();
				rollingY += EvacTypeStr.Height;
			}

			ConcealStr = MissionBriefText.Spawn(class'UIText', MissionBriefText);
			ConcealStr.bAnimateOnInit = false;
			ConcealStr.bIsNavigable = false;
			ConcealStr.InitText();
			ConcealStr.SetPosition(X, y + rollingY);
			ConcealStr.SetHTMLText(class'UIUtilities_LW'.static.GetMissionConcealStatusString (XComHQ.MissionRef));
			ConcealStr.Show();
			rollingY += EvacTypeStr.Height;

			AoAString = MissionBriefText.Spawn(class'UIText', MissionBriefText);
			AoAString.bAnimateOnInit = false;
			AoAString.bIsNavigable = false;
			AoAString.InitText();
			AoAString.SetPosition(X, y + rollingY);
			AoAString.SetHTMLText("Map Type: " $class'UIUtilities_LW'.static.GetPlotTypeFriendlyName(MissionState.GeneratedMission.Plot.strType));
			AoAString.Show();

			*/

		}
		else
		{
			MissionBriefText = SquadSelect.Spawn (class'UITextContainer', SquadSelect);
			MissionBriefText.MCName = 'SquadSelect_MissionBrief_LW';
			MissionBriefText.bAnimateOnInit = false;
			MissionBriefText.InitTextContainer('',, 35, 375, 300, 300, false);
			BriefingString = "<font face='$TitleFont' size='22' color='#a7a085'>" $ CAPS(class'UIMissionIntro'.default.m_strMissionTitle) $ "</font>\n";
			BriefingString $= "<font face='$NormalFont' size='22' color='#" $ class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR $ "'>";
			BriefingString $= class'UIUtilities_LW'.static.GetMissionTypeString (XComHQ.MissionRef) $ "\n";
			if (class'UIUtilities_LW'.static.GetTimerInfoString (MissionState) != "")
			{
				BriefingString $= class'UIUtilities_LW'.static.GetTimerInfoString (MissionState) $ "\n";
			}
			BriefingString $= class'UIUtilities_LW'.static.GetEvacTypeString (MissionState) $ "\n";
			if (class'UIUtilities_LW'.static.HasSweepObjective(MissionState))
			{
				BriefingString $= class'UIUtilities_LW'.default.m_strSweepObjective $ "\n";
			}
			if (class'UIUtilities_LW'.static.FullSalvage(MissionState))
			{
				BriefingString $= class'UIUtilities_LW'.default.m_strGetCorpses $ "\n";
			}
			BriefingString $= class'UIUtilities_LW'.static.GetMissionConcealStatusString (XComHQ.MissionRef) $ "\n";
			BriefingString $= "\n";
			BriefingString $= "<font face='$TitleFont' size='22' color='#a7a085'>" $ CAPS(strAreaOfOperations) $ "</font>\n";
			BriefingString $= "<font face='$NormalFont' size='22' color='#" $ class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR $ "'>";
			BriefingString $= class'UIUtilities_LW'.static.GetPlotTypeFriendlyName(MissionState.GeneratedMission.Plot.strType);
			BriefingString $= "\n";
			BriefingString $= "</font>";
			MissionBriefText.SetHTMLText (BriefingString);
		}
		
	}
}

simulated function string RequiredInfiltrationString(float RequiredValue)
{
	local XGParamTag ParamTag;
	local string ReturnString;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = Round(RequiredValue);
	ReturnString = `XEXPAND.ExpandString(class'UIMission_LWLaunchDelayedMission'.default.m_strInsuffientInfiltrationToLaunch);

	return "<p align='CENTER'><font face='$TitleFont' size='20' color='#000000'>" $ ReturnString $ "</font>";
}


function UpdateMissionDifficulty(UISquadSelect SquadSelect)
{
	local XComGameState_MissionSite MissionState;
	local string Text;
	
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	Text = class'UIUtilities_Text_LW'.static.GetDifficultyString(MissionState);
	SquadSelect.m_kMissionInfo.MC.ChildSetString("difficultyValue", "htmlText", Caps(Text));
}

// callback from clicking the rename squad button
function OnSquadManagerClicked(UIButton Button)
{
	local UIPersonnel_SquadBarracks kPersonnelList;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	if (HQPres.ScreenStack.IsNotInStack(class'UIPersonnel_SquadBarracks'))
	{
		kPersonnelList = HQPres.Spawn(class'UIPersonnel_SquadBarracks', HQPres);
		kPersonnelList.bSelectSquad = true;
		HQPres.ScreenStack.Push(kPersonnelList);
	}
}

simulated function OnSaveSquad(UIButton Button)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LWSquadManager SquadMgr;
	local UIPersonnel_SquadBarracks Barracks;
	local UIScreenStack ScreenStack;

	XComHQ = `XCOMHQ;
	ScreenStack = `SCREENSTACK;
	SquadMgr = `LWSQUADMGR;
	Barracks = UIPersonnel_SquadBarracks(ScreenStack.GetScreen(class'UIPersonnel_SquadBarracks'));
	SquadMgr.GetSquad(Barracks.CurrentSquadSelection).SquadSoldiers = XComHQ.Squad;
	GetSquadSelect().CloseScreen();
	ScreenStack.PopUntil(Barracks);

}

simulated function UISquadSelect GetSquadSelect()
{
	local UIScreenStack ScreenStack;
	local int Index;
	ScreenStack = `SCREENSTACK;
	for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(UISquadSelect(ScreenStack.Screens[Index]) != none )
			return UISquadSelect(ScreenStack.Screens[Index]);
	}
	return none; 
}

// This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen)
{
	local UISquadSelect SquadSelect;
	local UISquadSelect_InfiltrationPanel InfiltrationInfo;

	if(!Screen.IsA('UISquadSelect')) return;

	SquadSelect = UISquadSelect(Screen);
	if(SquadSelect == none) return;

	SquadSelect.bDirty = true; // Workaround for bug in currently published version of squad select
	SquadSelect.UpdateData();
	SquadSelect.UpdateNavHelp();

	UpdateMissionDifficulty(SquadSelect);

	InfiltrationInfo = UISquadSelect_InfiltrationPanel(SquadSelect.GetChildByName('SquadSelect_InfiltrationInfo_LW', false));
	if (InfiltrationInfo != none)
	{
		//remove and recreate infiltration info in order to prevent issues with Flash text updates not getting processed
		InfiltrationInfo.Remove();

		InfiltrationInfo = SquadSelect.Spawn(class'UISquadSelect_InfiltrationPanel', SquadSelect).InitInfiltrationPanel();
		InfiltrationInfo.MCName = 'SquadSelect_InfiltrationInfo_LW';
		InfiltrationInfo.MissionData = MissionData;
		InfiltrationInfo.Update(SquadSelect.XComHQ.Squad);
	}
}

// This event is triggered after a screen loses focus
event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen)
{
	local XComGameState_LWSquadManager SquadMgr;
	local StateObjectReference SquadRef, NullRef;
	local XComGameState_LWPersistentSquad SquadState;
	local XComGameState NewGameState;
	local UISquadSelect SquadSelect;

	if(!Screen.IsA('UISquadSelect')) return;

	SquadSelect = UISquadSelect(Screen);

	//need to move camera back to the hangar, if was in SquadManagement
	if(bInSquadEdit)
	{
		`HQPRES.CAMLookAtRoom(`XCOMHQ.GetFacilityByName('Hangar').GetRoom(), `HQINTERPTIME);
	}

	SquadMgr = `LWSQUADMGR;
	SquadRef = SquadMgr.LaunchingMissionSquad;
	if (SquadRef.ObjectID != 0)
	{
		SquadState = XComGameState_LWPersistentSquad(`XCOMHISTORY.GetGameStateForObjectID(SquadRef.ObjectID));
		if (SquadState != none)
		{
			if (SquadState.bTemporary && !SquadSelect.bLaunched)
			{
				SquadMgr.RemoveSquadByRef(SquadRef);
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clearing LaunchingMissionSquad");
				SquadMgr = XComGameState_LWSquadManager(NewGameState.CreateStateObject(class'XComGameState_LWSquadManager', SquadMgr.ObjectID));
				NewGameState.AddStateObject(SquadMgr);
				SquadMgr.LaunchingMissionSquad = NullRef;
				`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
			}
		}
	}
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none;
}