//---------------------------------------------------------------------------------------
//  FILE:    UIStrategyMapItem_AlienNetworkComponent_LW
//  AUTHOR:  Joey Martinez -- 05/06/2019
//  PURPOSE: This file represents an alien network spot on the StrategyMap for Long War of the Chosen.
//--------------------------------------------------------------------------------------- 

class UIStrategyMapItem_AlienNetworkComponent_LW extends UIStrategyMapItem_AlienNetworkComponent;

var UIScanButton ScanButton;  // used for missions being infiltrated
var UIText InfilPct;
var UIText InfilLabel;

var UIImage SquadImage; // for cases where there is an infiltrating squad
var string CachedImageName;

//var UIStrategyMap_MissionIcon_LW MissionSiteIcon; // used for pending missions not yet infiltrated 
var UIProgressBar ProgressBar; // used to show remaining time for missions not yet infiltrated

var int InDepth; // tracks depth of mouse in and outs, since it's recording from two possibly overlapping elements (2D and 3D icons)

var localized string strRecon;

var transient bool bScanButtonResized;
var transient float CachedScanButtonWidth;

simulated function UIStrategyMapItem InitMapItem(out XComGameState_GeoscapeEntity Entity)
{
	// override the super so we can always use MI_alienfacility to allow displaying of doom pips
	//super.InitMapItem(Entity);

	local string PinImage;
	// Initialize static data
	InitPanel(Name(Entity.GetUIWidgetName()), 'MI_alienFacility');

	PinImage = Entity.GetUIPinImagePath();
	if( PinImage != "" )
	{
		SetImage(PinImage);
	}

	InitFromGeoscapeEntity(Entity);

	ScanButton = Spawn(class'UIScanButton', self).InitScanButton();
	ScanButton.SetButtonIcon("");
	ScanButton.SetDefaultDelegate(OpenInfiltrationMissionScreen);
	ScanButton.SetButtonType(eUIScanButtonType_Default);

	SquadImage = Spawn(class'UIImage', self);
	SquadImage.bAnimateOnInit = false;
	SquadImage.InitImage().SetSize(48, 48);

	InfilPct = Spawn(class'UIText', ScanButton).InitText('InfilPct_LW', "");
	InfilPct.SetWidth(60); 
	InfilPct.SetPosition(154, 3);

	InfilLabel = Spawn(class'UIText', ScanButton).InitText('InfilLabel_LW', "");
	InfilLabel.SetWidth(60); 
	InfilLabel.SetPosition(154 - 5, 23);

	ProgressBar = Spawn(class'UIProgressBar', self).InitProgressBar('MissionInfiltrationProgress', -32, 5, 64, 8, 0.5, eUIState_Normal);
	//MissionSiteIcon = Spawn(class'UIStrategyMap_MissionIcon_LW', self);
	//MissionSiteIcon.InitMissionIcon(-1);

	bScanButtonResized = false;

	InstanceMapItem3DMaterial();

	return self;
}

function InstanceMapItem3DMaterial()
{
	local int i;
	local MaterialInterface Mat;
	local MaterialInstanceConstant MIC, NewMIC;

	if (MapItem3D == none)
		return;

	

	for (i = 0; i < MapItem3D.OverworldMeshs[MapItem3D.ROOT_TILE].GetNumElements(); ++i)
	{
		Mat = MapItem3D.GetMeshMaterial(i);
		MIC = MaterialInstanceConstant(Mat);

		// It is possible for there to be MITVs in these slots, so check
		if (MIC != none)
		{
			// If this is not a child MIC, make it one. This is done so that the material updates below don't stomp
			// on each other between units.
			if (InStr(MIC.Name, "MaterialInstanceConstant") == INDEX_NONE)
			{
				NewMIC = new (self) class'MaterialInstanceConstant';
				NewMIC.SetParent(MIC);
				MapItem3D.SetMeshMaterial(i, NewMIC);
				MIC = NewMIC;
			}
		}
	}

}

function UpdateFromGeoscapeEntity(const out XComGameState_GeoscapeEntity GeoscapeEntity)
{
	local XComGameState_MissionSite MissionState;
	local string MissionTitle;
	local string InfiltrationPctValue;
	local string MissionInfo;
	local int InfiltrationPct;
	local XComGameState_LWPersistentSquad InfiltratingSquad;
	local X2MissionTemplate MissionTemplate;
	local float ScanWidth;

	if( !bIsInited ) return; 

	super(UIStrategyMapItem).UpdateFromGeoscapeEntity(GeoscapeEntity);

	InfiltratingSquad = GetInfiltratingSquad();
	 
	MissionState = GetMission();
	if(InfiltratingSquad != none)
	{
		InfiltrationPct = int(InfiltratingSquad.CurrentInfiltration * 100.0);
		InfiltrationPctValue = string(InfiltrationPct) $ "%";
		InfilPct.SetHTMLText(CenterText(class'UIUtilities_Text'.static.AddFontInfo(InfiltrationPctValue, false, true,, 20)));

		if (!bScanButtonResized)
		{
			MissionTitle = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(InfiltratingSquad.sSquadName);
			MissionTemplate = class'X2MissionTemplateManager'.static.GetMissionTemplateManager().FindMissionTemplate(MissionState.GeneratedMission.Mission.MissionName);
			MissionInfo = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(MissionTemplate.PostMissionType); 

			ScanButton.SetText(MissionTitle, MissionInfo, " ", " "); // have to leave blank spaces so that Flash will size BG big enough 
			SetLevel(0); // show 0 doom pips

			InfilLabel.SetHTMLText(CenterText(class'UIUtilities_Text'.static.GetSizedText(strRecon, 16)));
			bScanButtonResized = true;

			CachedImageName = InfiltratingSquad.GetSquadImagePath();
			SquadImage.LoadImage(CachedImageName);
		}
		ScanButton.DefaultState();
		ScanButton.PulseScanner(false);
		ScanButton.ShowScanIcon(false);
		ScanButton.Realize();

		// but the MC queuing system means that the width isn't set here the first time it's been invoked
		ScanWidth = ScanButton.MC.GetNum("bg._width"); 

		if (ScanWidth != CachedScanButtonWidth)
		{
			InfilPct.SetX(ScanWidth - 60);
			InfilLabel.SetX(ScanWidth - 65);
			ScanButton.SetX(- (ScanWidth/2));
			
			CachedScanButtonWidth = ScanWidth;

			SquadImage.SetPosition(-(ScanWidth/2 + 48), 0);
		}
		if (CachedImageName != InfiltratingSquad.GetSquadImagePath())
		{
			CachedImageName = InfiltratingSquad.GetSquadImagePath();
			SquadImage.LoadImage(CachedImageName);
		}

		ProgressBar.Hide();
	}
	else if (MissionState.MakesDoom())
	{
		SetLevel(MissionState.Doom);
		ProgressBar.Hide();
		ScanButton.Hide();
		bScanButtonResized = false;
	}
	else
	{
		ProgressBar.Show();
		UpdateProgressBar(MissionState);

		ScanButton.Hide();
		SquadImage.Hide();
		bScanButtonResized = false;
	}
}

simulated function string CenterText(string Text)
{
	return class'UIUtilities_Text'.static.AlignCenter(Text);
}

simulated function XComGameState_LWPersistentSquad GetInfiltratingSquad()
{
	return `LWSQUADMGR.GetSquadOnMission(GeoscapeEntityRef);
}

simulated function XComGameState_MissionSite GetMission()
{
	return XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(GeoscapeEntityRef.ObjectID));
}

function OpenInfiltrationMissionScreen()
{
	local UIMission_LWLaunchDelayedMission MissionScreen;
	local XComHQPresentationLayer HQPres;
	
	// WOTC DEBUGGING
	`LWTrace(">> Launching delayed mission UI");
	// END

	HQPres = `HQPRES;
	MissionScreen = HQPres.Spawn(class'UIMission_LWLaunchDelayedMission', HQPres);
	MissionScreen.MissionRef = GeoscapeEntityRef;
	MissionScreen.bInstantInterp = false;
	MissionScreen = UIMission_LWLaunchDelayedMission(HQPres.ScreenStack.Push(MissionScreen));
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	local XComGameStateHistory History;
	local XComGameState_GeoscapeEntity GeoscapeEntity;
	local XComGameState_LWPersistentSquad InfiltratingSquad;

	if(GetStrategyMap().m_eUIState == eSMS_Flight)
	{
		return;
	}

	switch(cmd) 
	{ 
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
		OnMouseIn();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
		OnMouseOut();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
		History = `XCOMHISTORY;
		InfiltratingSquad = GetInfiltratingSquad();
		if(InfiltratingSquad == none)
		{
			GeoscapeEntity = XComGameState_GeoscapeEntity(History.GetGameStateForObjectID(GeoscapeEntityRef.ObjectID));
			GeoscapeEntity.AttemptSelectionCheckInterruption();
		}
		else
		{
			OpenInfiltrationMissionScreen();
		}
		break;
	}
}

simulated function UpdateProgressBar(XComGameState_MissionSite MissionState)
{
	local int RemainingSeconds;

	if(ProgressBar == none)
		return;

	if(MissionState.ExpirationDateTime.m_iYear < 2100)
	{
		RemainingSeconds = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(MissionState.ExpirationDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime());
		ProgressBar.SetPercent(1.0);
		SetProgressBarColor(RemainingSeconds);
		ProgressBar.Show();
	}
	else
	{
		ProgressBar.SetPercent(0.0);
		ProgressBar.Hide();
	}
}

simulated function SetProgressBarColor(float RemainingSeconds)
{
	local float PercentIdealInfiltration;

	PercentIdealInfiltration = (RemainingSeconds / 3600.0) / class'XComGameState_LWPersistentSquad'.static.GetBaselineHoursToInfiltration(GeoscapeEntityRef);

	if (PercentIdealInfiltration >= 1.0)
	{
		ProgressBar.SetColor(class'UIUtilities_Colors'.const.GOOD_HTML_COLOR);
	} 
	else if(PercentIdealInfiltration >= 0.5)
	{
		ProgressBar.SetColor(class'UIUtilities_Colors'.const.WARNING_HTML_COLOR);
	}
	else if(RemainingSeconds >= 86400.0)
	{
		ProgressBar.SetColor(class'UIUtilities_Colors'.const.WARNING2_HTML_COLOR);
	}
	else
	{
		ProgressBar.SetColor(class'UIUtilities_Colors'.const.BAD_HTML_COLOR);
	}

}

//---------------- 3D Map Icon Handling -------------------
simulated function OnMouseIn()
{
	if (InDepth == 0)
	{ 
		super(UIStrategyMapItem).OnMouseIn();

		if(MapItem3D != none)
			MapItem3D.SetHoverMaterialValue(1);
		if(AnimMapItem3D != none)
			AnimMapItem3D.SetHoverMaterialValue(1);
	}
	InDepth++;
	//`LOG ("Mouse IN  : In Depth = " $ InDepth);
}

// Clear mouse hover special behavior
simulated function OnMouseOut()
{
	InDepth--;
	//`LOG ("Mouse OUT : In Depth = " $ InDepth);

	if (InDepth <= 0)
	{
		super(UIStrategyMapItem).OnMouseOut();

		if(MapItem3D != none)
			MapItem3D.SetHoverMaterialValue(0);
		if(AnimMapItem3D != none)
			AnimMapItem3D.SetHoverMaterialValue(0);
	}
}

simulated function Show()
{
	// override to always allow showing items
	super(UIPanel).Show();
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
}

DefaultProperties
{
	bDisableHitTestWhenZoomedOut = false;
	bFadeWhenZoomedOut = false;
}
