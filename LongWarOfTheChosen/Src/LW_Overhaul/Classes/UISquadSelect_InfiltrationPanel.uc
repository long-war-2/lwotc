//---------------------------------------------------------------------------------------
//  FILE:    UISquadSelect_InfiltrationPanel
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Panel/container for displaying Infiltration information about mission being selected
//--------------------------------------------------------------------------------------- 
class UISquadSelect_InfiltrationPanel extends UIPanel config(LW_Overhaul);

var GeneratedMissionData MissionData;

var vector2d InitPos;

var UIMask InfiltrationMask;

var UISquadSelect_InfiltrationItem TitleText;
var UISquadSelect_InfiltrationItem OverallTime;

var UISquadSelect_InfiltrationItem BaseInfiltrationText;
var UISquadSelect_InfiltrationItem BaseInfiltrationTime;

var UISquadSelect_InfiltrationItem SquadSizeText;
var UISquadSelect_InfiltrationItem SquadSizeValue;

var UISquadSelect_InfiltrationItem CovertnessText;
var UISquadSelect_InfiltrationItem SquadCovertnessValue;

var UISquadSelect_InfiltrationItem LiberationText;
var UISquadSelect_InfiltrationItem LiberationValue;

var UISquadSelect_InfiltrationItem MissionTimeTitleText;
var UISquadSelect_InfiltrationItem MissionTimeText;

var array<StateObjectReference> SquadSoldiers;

var localized string strInfiltrationTitle;
var localized string strBaseInfiltrationTitle;
var localized string strSquadSizeTitle;
var localized string strCovertnessTitle;
var localized string strMissionTimeTitle;

var localized string strDaysAndHours;
var localized string strMinusDaysAndHours;
var localized string strPlusDaysAndHours;
var localized string strMissionIndefinite;

var localized string strLiberationTitle;

// do a timer-delayed initiation in order to allow other UI elements to settle
function DelayedInit(float Delay)
{
	SetTimer(Delay, false, nameof(StartDelayedInit));
}

function StartDelayedInit()
{
	InitInfiltrationPanel(,,-375, 0, 375, 450);
	MCName = 'SquadSelect_InfiltrationInfo_LW';
	Update(SquadSoldiers);
}

simulated function UISquadSelect_InfiltrationPanel InitInfiltrationPanel(optional name InitName, 
										  optional name InitLibID = '', 
										  optional int InitX = 0, 
										  optional int InitY = 0,
										  optional int InitWidth = 375,
										  optional int InitHeight = 450)  
{
	//local XComGameStateHistory History;
	//local XComGameState_ObjectivesList ObjectiveList;
	//local XComGameState_MissionSite MissionState;

	InitPanel(InitName, InitLibID);
	
	Hide();

	AnchorTopRight();
	//OriginTopRight();

	SetSize(InitWidth, InitHeight);
	SetPosition(InitX, InitY);

	//Save out this info 
	InitPos = vect2d(X, Y);

	//Debug square to show location:
	//Spawn(class'UIPanel', self).InitPanel('BGBoxSimpleHit', class'UIUtilities_Controls'.const.MC_X2BackgroundShading).SetSize(InitWidth, InitHeight);

	MissionTimeText = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(0, 44);

	OverallTime = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(0, 123.5);
	BaseInfiltrationTime = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(20, 196);
	SquadSizeValue = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(20, 262);
	SquadCovertnessValue = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(20, 328);

	MissionTimeTitleText = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(0, 16);
	MissionTimeTitleText.SetSubTitle(default.strMissionTimeTitle, "FAF0C8");

	TitleText = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(-29, 82);
	TitleText.SetTitleTest(default.strInfiltrationTitle);

	BaseInfiltrationText = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(20, 168);
	BaseInfiltrationText.SetSubTitle(default.strBaseInfiltrationTitle);

	SquadSizeText = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(20, 234);
	SquadSizeText.SetSubTitle(default.strSquadSizeTitle);

	CovertnessText = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(20, 300);
	CovertnessText.SetSubTitle(default.strCovertnessTitle);

	LiberationValue = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(20, 394);
	LiberationText = Spawn(class'UISquadSelect_InfiltrationItem', self).InitObjectiveListItem(20, 366);
	
	// TODO: UPDATE THIS IF LOC UPDATED

	if (GetLanguage() == "INT")
	{
		LiberationText.SetSubTitle(strLiberationTitle);
	}
	else
	{
		//LiberationText.SetSubTitle(class'UIResistance'.default.m_strResOps @ class'UIFacility_ProvingGround'.default.m_strProgress);
		LiberationText.SetSubTitle(class'UIX2SimpleScreen'.default.m_strResistanceStatus $ ":");
	}
	
	// m_strResistanceStatus=Resistance Status
	// m_strTitle=Resistance Operations
	// m_strControl=Advent Control
	// m_strResOps=Resistance Ops
	// m_strResistanceActivity=RESISTANCE ACTIVITY:
	// m_strAdvent=ADVENT
	// m_strStatusLabel=STATUS:
	// m_strProgress=PROGRESS:
	// m_strListTitle=Resistance

	InfiltrationMask = Spawn(class'UIMask', self).InitMask('TacticalMask', self);
	InfiltrationMask.SetPosition(6, 0);
	InfiltrationMask.SetSize(InitWidth, InitHeight);

	return self;
}

simulated function Update(array<StateObjectReference> Soldiers)
{
	local XComGameState_MissionSite MissionState;
    local XComGameState_LWAlienActivity ActivityState;
	local float TotalInfiltrationHours, TotalMissionHours;
	local int SquadSizeHours, CovertnessHours, NumSoldiers, LiberationHours;
	local string OverallTimeColor;
	local StateObjectReference Soldier;
	
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(MissionData.MissionID));

	TotalInfiltrationHours = class'XComGameState_LWPersistentSquad'.static.GetHoursToFullInfiltration_Static(Soldiers, MissionState.GetReference(), SquadSizeHours, CovertnessHours, LiberationHours);

	TotalMissionHours = 99999;
	if(MissionState.ExpirationDateTime.m_iYear < 2100)
	{
		ActivityState = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);
		if(ActivityState != none)
			TotalMissionHours = int(ActivityState.SecondsRemainingCurrentMission() / 3600.0);
		else
			TotalMissionHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInSeconds(MissionState.ExpirationDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()) / 3600.0;
	}

	foreach Soldiers (Soldier)
	{
		if (Soldier.ObjectID > 0)
			NumSoldiers++;
	}

	BaseInfiltrationTime.SetText(GetDaysAndHoursString(Round(class'XComGameState_LWPersistentSquad'.static.GetBaselineHoursToInfiltration(MissionState.GetReference()))));
	if(TotalMissionHours < 4320) // 6 months
	{
		MissionTimeText.SetText(GetDaysAndHoursString(TotalMissionHours));
	}
	else
	{
		MissionTimeText.SetText(strMissionIndefinite);
	}

	if (NumSoldiers == 0)
	{
		TitleText.Hide();
		OverallTime.Hide();

		SquadSizeText.Hide();
		SquadSizeValue.Hide();

		CovertnessText.Hide();
		SquadCovertnessValue.Hide();

	}
	else
	{
		if (TotalMissionHours > TotalInfiltrationHours || NumSoldiers == 0)
			OverallTimeColor = class'UIUtilities_Colors'.const.GOOD_HTML_COLOR;
		else if (TotalMissionHours > TotalInfiltrationHours * 1.5)
			OverallTimeColor = class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR;
		else if (TotalMissionHours > TotalInfiltrationHours * (class'XComGameState_LWPersistentSquad'.static.GetRequiredPctInfiltrationToLaunch(MissionState) / 100.0))
			OverallTimeColor = class'UIUtilities_Colors'.const.WARNING2_HTML_COLOR;
		else
			OverallTimeColor = class'UIUtilities_Colors'.const.BAD_HTML_COLOR;

		OverallTime.SetInfoValue(GetDaysAndHoursString(TotalInfiltrationHours), OverallTimeColor);

		if(SquadSizeHours < 0)
			SquadSizeValue.SetInfoValue(GetDaysAndHoursString(Abs(SquadSizeHours), default.strMinusDaysAndHours), GetColorForHours(SquadSizeHours));
		else
			SquadSizeValue.SetInfoValue(GetDaysAndHoursString(SquadSizeHours, default.strPlusDaysAndHours), GetColorForHours(SquadSizeHours));

		if(CovertnessHours < 0)
			SquadCovertnessValue.SetInfoValue(GetDaysAndHoursString(Abs(CovertnessHours), default.strMinusDaysAndHours), GetColorForHours(CovertnessHours));
		else
			SquadCovertnessValue.SetInfoValue(GetDaysAndHoursString(CovertnessHours, default.strPlusDaysAndHours), GetColorForHours(CovertnessHours));

		//CovertnessValue_Bad.SetText(GetDaysAndHoursString(`SYNC_RAND(100))); 
	}

	if (class'XComGameState_LWPersistentSquad'.default.MissionsAffectedByLiberationStatus.Find (MissionState.GeneratedMission.Mission.MissionName) == -1)
	{
		LiberationText.Hide();
		LiberationValue.Hide();
	}
	else
	{
		if(LiberationHours < 0)
			LiberationValue.SetInfoValue(GetDaysAndHoursString(Abs(LiberationHours), default.strMinusDaysAndHours), GetColorForHours(LiberationHours));
		else
			LiberationValue.SetInfoValue(GetDaysAndHoursString(LiberationHours, default.strPlusDaysAndHours), GetColorForHours(LiberationHours));
	}

	Show();

}

simulated function string GetSubTitleHTML(string Text)
{
	return "<font face='$TitleFont' size='22' color='#a7a085'>" $ CAPS(Text) $ "</font>";
}

simulated function string GetTextHTML(string Text, string TextColor)
{
	return "<font face='$NormalFont' size='22' color='#" $ TextColor $ "'>" $ Text  $ "</font>";
}


function string GetColorForHours(int iHours)
{
	if(iHours <= 0)
	{
		if(iHours <= -24)
			return class'UIUtilities_Colors'.const.GOOD_HTML_COLOR;
		else
			return class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR;
	}
	else
	{
		if(iHours >= 24)
			return class'UIUtilities_Colors'.const.BAD_HTML_COLOR;
		else
			return class'UIUtilities_Colors'.const.WARNING2_HTML_COLOR;
	}
}

static function string GetDaysAndHoursString(int iHours, optional string locString)
{
	local int ActualHours, ActualDays;
	local XGParamTag ParamTag;
	local string ReturnString;

	if(locString == "")
		locString = default.strDaysAndHours;

	ActualDays = iHours / 24;
	ActualHours = iHours - 24 * ActualDays;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = ActualDays;
	ParamTag.IntValue1 = ActualHours;
	ReturnString = `XEXPAND.ExpandString(locString);
	return ReturnString;
}

//Defaults: ------------------------------------------------------------------------------
defaultproperties
{
	bIsNavigable = false; 
	bAnimateOnInit = false;
}