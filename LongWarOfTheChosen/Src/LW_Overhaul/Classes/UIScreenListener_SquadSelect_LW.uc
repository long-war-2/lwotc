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
	local float RequiredInfiltrationPct;
	local string BriefingString;

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

		MissionBriefText = SquadSelect.Spawn (class'UITextContainer', SquadSelect);
		MissionBriefText.MCName = 'SquadSelect_MissionBrief_LW';
		MissionBriefText.bAnimateOnInit = false;
		MissionBriefText.InitTextContainer('',, 35, 375, 400, 300, false);
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