//----------------------------------------------------------------------------
//  FILE:    UISquadContainer.uc
//  AUTHOR:  amineri / LongWarStudios
//  PURPOSE: Squad container that will load in and format squad items. 
//----------------------------------------------------------------------------

class UISquadContainer extends UIPanel;

var string Title;

var UISquadListItem_Small SquadButton; 
var UIBGBox BGBox;

var StateObjectReference CurrentSquadRef;

var UISquad_DropDown m_k_SquadDropDown;

var localized string DefaultSquadTitle; 

// do a timer-delayed initiation in order to allow other UI elements to settle
function DelayedInit(float Delay)
{
	SetTimer(Delay, false, nameof(StartDelayedInit));
}

function StartDelayedInit()
{
	InitSquadContainer('SquadSelect_SquadContainer_LW', CurrentSquadRef);
	SetPosition(1150, 0);
}
simulated function UISquadContainer InitSquadContainer(optional name InitName, optional StateObjectReference SquadRef)
{
	InitPanel(InitName);
	
    BGBox = Spawn(class'UIBGBox', self);
	BGBox.InitBG('SquadContainerBG', 0, 0, Width, Height);
    BGBox.bIsNavigable = false;

	// spawn the button
	SpawnSquadButton(SquadRef);

	return self;
}

function SpawnSquadButton(StateObjectReference SquadRef)
{
	if (SquadButton == none)
	{
		SquadButton = Spawn(class'UISquadListItem_Small', self);
		SquadButton.bAnimateOnInit = false;
		SquadButton.InitSquadListItem_Small(SquadRef, OnSquadManagerClicked);
		SquadButton.bShowDropDown = true;
		SquadButton.OwningContainer = self;
		SquadButton.MCName = 'SquadSelect_SquadButton_LW';
		SquadButton.SetPosition(10, 10);
	}
}

function Update()
{
	SquadButton.Update();
	m_k_SquadDropDown.RefreshData();
}

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

		HideDropDown();
	}
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

public simulated function HideDropDown()
{
	if (m_k_SquadDropDown == none)
		return;
	
	m_k_SquadDropDown.TryToStartDelayTimer();
}

public simulated function ShowDropDown()
{
	if (m_k_SquadDropDown != none)
	{
		m_k_SquadDropDown.onSelectedDelegate = OnSquadSelected;
		m_k_SquadDropDown.UpdateData();
	}
	else
	{
		m_k_SquadDropDown = Spawn(class'UISquad_DropDown', self);
		m_k_SquadDropDown.onSelectedDelegate = OnSquadSelected;
		m_k_SquadDropDown.InitDropDown();
	}

	m_k_SquadDropDown.SetPosition(SquadButton.X, Y + Height);
	m_k_SquadDropDown.Show();
}

simulated function OnSquadSelected(StateObjectReference selectedSquad)
{
	SetSquad(selectedSquad);

	SquadButton.SquadRef = selectedSquad;
	SquadButton.Update();

	GetSquadSelect().UpdateData();
	GetSquadSelect().SignalOnReceiveFocus();
}

function SetSquad(optional StateObjectReference NewSquadRef)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState UpdateState;
	local XComGameState_LWPersistentSquad SquadState;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_LWSquadManager UpdatedSquadMgr;

	XComHQ = `XCOMHQ;
	SquadMgr = `LWSQUADMGR;

	if (NewSquadRef.ObjectID > 0)
		CurrentSquadRef = NewSquadRef;
	else
		CurrentSquadRef = SquadMgr.LaunchingMissionSquad;

	if(CurrentSquadRef.ObjectID > 0)
		SquadState = XComGameState_LWPersistentSquad(`XCOMHISTORY.GetGameStateForObjectID(CurrentSquadRef.ObjectID));
	else
		SquadState = SquadMgr.AddSquad(, XComHQ.MissionRef);

	UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Launching Mission Squad");
	UpdatedSquadMgr = XComGameState_LWSquadManager(UpdateState.CreateStateObject(SquadMgr.Class, SquadMgr.ObjectID));
	UpdateState.AddStateObject(UpdatedSquadMgr);
	UpdatedSquadMgr.LaunchingMissionSquad = SquadState.GetReference();
	UpdateState.AddStateObject(XComHQ);
	`GAMERULES.SubmitGameState(UpdateState);

	SquadState.SetSquadCrew(, false /* bOnMissionSoldiers */ ,false /* bForDisplayOnly */);
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	if (super.OnUnrealCommand(cmd, arg))
		return true;

	if (m_k_SquadDropDown != none)
	{
		return m_k_SquadDropDown.OnUnrealCommand(cmd, arg);
	}

	return false;
}

simulated function SetTooltipText(string Text,
								  optional string TooltipTitle,
								  optional float OffsetX,
								  optional float OffsetY,
								  optional bool bRelativeLocation = class'UITextTooltip'.default.bRelativeLocation,
								  optional int TooltipAnchor = class'UITextTooltip'.default.Anchor,
								  optional bool bFollowMouse = class'UITextTooltip'.default.bFollowMouse,
								  optional float Delay = class'UITextTooltip'.default.tDelay)
{
	super.SetTooltipText(Text);
	ProcessMouseEventsForTooltip(true);
}

function ProcessMouseEventsForTooltip(bool bShouldInterceptMouse)
{
	if( bShouldInterceptMouse )
		MC.FunctionVoid("processMouseEvents");
	else
		MC.FunctionVoid("ignoreMouseEvents");
}


defaultproperties
{
	Width = 360;
	Height = 63;
	bAnimateOnInit = false
}
