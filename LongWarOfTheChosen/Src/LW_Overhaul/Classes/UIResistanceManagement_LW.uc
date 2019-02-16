//---------------------------------------------------------------------------------------
//  FILE:    UIResistanceManagement_LW
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: UI for overall resistance managemenet
//---------------------------------------------------------------------------------------

class UIResistanceManagement_LW extends UIScreen
    implements (IUISortableScreen);

enum EResistanceSortType
{
	eResistanceSortType_Region,
	eResistanceSortType_RebelCount,
};

var bool FlipSort;
var bool EnableCameraPan;
var EResistanceSortType SortType;

var UIPanel							    m_kAllContainer;
var UIX2PanelHeader						m_MissionHeader;
var UIBGBox                             m_MissionHeaderBox;
var UIX2PanelHeader						m_ObjectiveHeader;
var UIBGBox                             m_ObjectiveHeaderBox;

var name DisplayTag;
var name CameraTag;

var localized string m_strTitle;
var localized string m_strLabel;
var localized string m_strRegionlabel;
var localized string m_strRebelCountLabel;
var localized string m_strAdviserLabel;

var string m_strGlobalResistanceSummary;
var localized string m_strThreatVeryLow;
var localized string m_strThreatLow;
var localized string m_strThreatMedium;
var localized string m_strThreatHigh;
var localized string m_strThreatVeryHigh;
var localized string m_strGlobalInsurgency;
var localized string m_strGlobalAlert;
var localized string m_strLiberatedRegions;
var localized string m_strAvatarPenalty;
var localized string m_strStrength;
var localized string m_strLiberated;
var localized string m_strIncomeLabel;
var localized string m_strADVENTUnitSingular;
var localized string m_strADVENTUnitPlural;

var UIList List;
var UIBGBox ListBG;
var UIPanel MainPanel;
var UIX2PanelHeader ListTitle;
var UIPanel DividerLine;
var UIPanel HeaderPanel;
var UIButton RegionHeaderButton;
var UIButton RegionStatusButton, IncomeHeaderButton, AdviserHeaderButton;
var UIButton RebelCountHeaderButton;

var int m_iMaskWidth;
var int m_iMaskHeight;

//var int panelX;
var int panelY;
var int panelH;
var int panelW;

var array<StateObjectReference> CachedOutposts;

static function string GetThreatLevelStr(int netvig)
{
	if (NetVig < -10)
	{
		return default.m_strThreatVeryLow;
	}
	else
	{
		if (NetVig < 0)
		{
			return default.m_strThreatLow;
		}
		else
		{
			if (NetVig < 10)
			{
				return default.m_strThreatMedium;
			}
			else
			{
				if (NetVig < 20)
				{
					return default.m_strThreatHigh;
				}
				else
				{
					return default.m_strThreatVeryHigh;
				}
			}
		}
	}
}

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
    local int NextY;
	local int MeanAvatarHours;
	local XGParamTag ParamTag;
	local string strAvatarPenalty;

 	// Init UI
	super.InitScreen(InitController, InitMovie, InitName);

    // Move the camera to the council monitor
	if (EnableCameraPan)
	    class'UIUtilities'.static.DisplayUI3D(DisplayTag, CameraTag, `HQINTERPTIME);
	else
	    class'UIUtilities'.static.DisplayUI3D(DisplayTag, CameraTag, 0, true);

    MainPanel = Spawn(class 'UIPanel', self);
	MainPanel.bAnimateOnInit = false;
    MainPanel.InitPanel('ListContainer').SetPosition((Movie.UI_RES_X / 2) - (panelW / 2), panelY);
    ListBG = Spawn(class'UIBGBox', MainPanel);
	ListBG.bAnimateOnInit = false;
	ListBG.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	ListBG.InitBG('ListBG', 0, 0, panelW, panelH);
    ListBG.bIsNavigable = false;

    ListTitle = Spawn(class'UIX2PanelHeader', MainPanel);
	ListTitle.bAnimateOnInit = false;

	m_strGlobalResistanceSummary = m_strGlobalAlert @ string (`LWACTIVITYMGR.GetGlobalAlert());
	if (`LWACTIVITYMGR.GetGlobalAlert() == 1)
	{
		m_strGlobalResistanceSummary @= m_strADVENTUnitSingular;
	}
	else
	{
		m_strGlobalResistanceSummary @= m_strADVENTUnitPlural;
	}

	m_strGlobalResistanceSummary @= m_strGlobalInsurgency @ GetThreatLevelStr (`LWACTIVITYMGR.GetNetVigilance());
	if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'))
	{
		MeanAvatarHours = (class'XComGameState_HeadquartersAlien'.default.MinFortressDoomInterval[`STRATEGYDIFFICULTYSETTING] + class'XComGameState_HeadquartersAlien'.default.MaxFortressDoomInterval[`STRATEGYDIFFICULTYSETTING]) / 2;
		ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		ParamTag.IntValue0 = Round(float(`LWACTIVITYMGR.GetDoomUpdateModifierHours() * 100) / float (MeanAvatarHours));
		strAvatarPenalty = `XEXPAND.ExpandString(m_strAvatarPenalty);
		m_strGlobalResistanceSummary @= strAvatarPenalty;
	}

	ListTitle.InitPanelHeader('TitleHeader', m_strTitle, m_strGlobalResistanceSummary);
	ListTitle.SetHeaderWidth(ListBG.Width - 20);
    ListTitle.SetPosition(ListBG.X + 10, ListBG.Y + 10);

    NextY = ListTitle.Y + ListTitle.Height;

    DividerLine = Spawn(class'UIPanel', MainPanel);
	DividerLine.bIsNavigable = false;
	DividerLine.bAnimateOnInit = false;
	DividerLine.LibID = class'UIUtilities_Controls'.const.MC_GenericPixel;
	DividerLine.InitPanel('DividerLine').SetPosition(15, NextY).SetWidth(ListBG.Width - 20);
    DividerLine.SetAlpha(20);

    NextY += DividerLine.Height + 5;

    // Header buttons
    HeaderPanel = Spawn(class'UIPanel', MainPanel);
	HeaderPanel.bAnimateOnInit = false;
    HeaderPanel.InitPanel('Header').SetPosition(15, NextY).SetSize(ListBG.Width - 56, 32);

    RegionHeaderButton = Spawn(class'UIButton', HeaderPanel);
	RegionHeaderButton.bAnimateOnInit = false;
    RegionHeaderButton.InitButton(, m_strRegionLabel);
    RegionHeaderButton.SetResizeToText(false);
    RegionHeaderButton.SetWidth(HeaderPanel.Width * 0.25f);
    RegionHeaderButton.SetPosition(0, 0);
    RegionHeaderButton.SetWarning(true);
    RegionHeaderButton.ProcessMouseEvents(HeaderMouseEvent);

	RegionStatusButton = Spawn(Class'UIButton', HeaderPanel);
	RegionStatusButton.bAnimateOnInit = false;
	RegionStatusButton.InitButton (, m_strSTrength);
	RegionStatusButton.SetResizeToText(false);
    RegionStatusButton.SetWidth(HeaderPanel.Width * 0.17f);
	RegionStatusButton.SetPosition(RegionHeaderButton.X + RegionHeaderButton.Width + 2, 0);
    RegionStatusButton.SetWarning(true);
    RegionStatusButton.ProcessMouseEvents(HeaderMouseEvent);

    RebelCountHeaderButton = Spawn(class'UIButton', HeaderPanel);
	RebelCountHeaderButton.bAnimateOnInit = false;
    RebelCountHeaderButton.InitButton(, m_strRebelCountLabel);
    RebelCountHeaderButton.SetResizeToText(false);
    RebelCountHeaderButton.SetWidth(HeaderPanel.Width * 0.30f);
    RebelCountHeaderButton.SetPosition(RegionHeaderButton.X + RegionHeaderButton.Width + RegionStatusButton.Width + 2, 0);
    RebelCountHeaderButton.SetWarning(true);
    RebelCountHeaderButton.ProcessMouseEvents(HeaderMouseEvent);

	AdviserHeaderButton = Spawn(class'UIButton', HeaderPanel);
	AdviserHeaderButton.bAnimateOnInit = false;
    AdviserHeaderButton.InitButton(, m_strAdviserLabel);
    AdviserHeaderButton.SetResizeToText(false);
    AdviserHeaderButton.SetWidth(HeaderPanel.Width * 0.08f);
    AdviserHeaderButton.SetPosition(RegionHeaderButton.X + RegionHeaderButton.Width + RegionStatusButton.Width + RebelCountHeaderButton.Width + 2, 0);
    AdviserHeaderButton.SetWarning(true);
    AdviserHeaderButton.ProcessMouseEvents(HeaderMouseEvent);


    IncomeHeaderButton = Spawn(class'UIButton', HeaderPanel);
	IncomeHeaderButton.bAnimateOnInit = false;
    IncomeHeaderButton.InitButton(, m_strIncomeLabel);
    IncomeHeaderButton.SetResizeToText(false);
    IncomeHeaderButton.SetWidth(HeaderPanel.Width * 0.2f);
    IncomeHeaderButton.SetPosition(RegionHeaderButton.X + RegionHeaderButton.Width + RegionStatusButton.Width + RebelCountHeaderButton.Width + AdviserHeaderButton.Width + 2, 0);
    IncomeHeaderButton.SetWarning(true);
    IncomeHeaderButton.ProcessMouseEvents(HeaderMouseEvent);


    NextY += 32 + 5;

	List = Spawn(class'UIList', MainPanel);
	List.bAnimateOnInit = false;
	List.bIsNavigable = true;
	List.InitList(, 15, NextY, ListBG.Width - 50, panelH - NextY - 5);
	List.bStickyHighlight = false;
    List.OnItemClicked = OnRegionSelectedCallback;

    // Redirect all mouse events for the background to the list. Ensures all mouse
    // wheel events get processed by the list instead of consumed by the background
    // when the cursor falls "between" list items.
    ListBG.ProcessMouseEvents(List.OnChildMouseEvent);

    RefreshNavHelp();

    RefreshData();
}

// Handle mouse events on the header buttons
simulated function HeaderMouseEvent(UIPanel Control, int cmd)
{
    switch(cmd)
    {
    // De-select the button if we leave or drag-leave the button.
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
    case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT:
    case class'UIUtilities_Input'.const.FXS_L_MOUSE_RELEASE_OUTSIDE:
        Control.MC.FunctionVoid("mouseOut");
        break;
    }
}

simulated function RefreshData()
{
    GetData();
    //SortData();
    UpdateList();
}


simulated function GetData()
{
    local XComGameState_LWOutpost Outpost;
    local XComGameState_WorldRegion Region;
    local XComGameStateHistory History;

    History = `XCOMHISTORY;
    CachedOutposts.Length = 0;

    foreach History.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
    {
        Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(Outpost.Region.ObjectID));
        if (Region.HaveMadeContact())
            CachedOutposts.AddItem(Outpost.GetReference());
    }
}

simulated function UpdateList()
{
    local StateObjectReference Ref;

    List.ClearItems();

    foreach CachedOutposts(Ref)
    {
        UIResistanceManagement_ListItem(List.CreateItem(class'UIResistanceManagement_ListItem')).InitListItem(Ref);
    }
}

simulated function OnRegionSelectedCallback(UIList listCtrl, int itemIndex)
{
    local UIOutpostManagement OutpostScreen;
    local StateObjectReference OutpostRef;
    local XComHQPresentationLayer HQPres;

    HQPres = `HQPRES;
    OutpostRef = CachedOutposts[itemIndex];
	OutpostScreen = HQPres.Spawn(class'UIOutpostManagement', HQPres);
    OutpostScreen.SetOutpost(OutpostRef);
	`SCREENSTACK.Push(OutpostScreen);
}

simulated function RefreshNavHelp()
{
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	`HQPRES.m_kAvengerHUD.NavHelp.AddBackButton(OnCancel);
	class'LWHelpTemplate'.static.AddHelpButton_Nav('ResistanceManagement_Help');
}

simulated function OnCancel()
{
    Movie.Stack.Pop(self);
}

simulated function OnAccept()
{
}

simulated function OnReceiveFocus()
{
    super.OnReceiveFocus();
    RefreshNavHelp();
	if (EnableCameraPan)
	    class'UIUtilities'.static.DisplayUI3D(DisplayTag, CameraTag, `HQINTERPTIME);
	else
	    class'UIUtilities'.static.DisplayUI3D(DisplayTag, CameraTag, 0, true);

    RefreshData();
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	Movie.Pres.Get3DMovie().HideDisplay(DisplayTag);
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;

	switch( cmd )
	{
`if(`notdefined(FINAL_RELEASE))
		case class'UIUtilities_Input'.const.FXS_KEY_TAB:
`endif
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			OnAccept();
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			break;
		default:
			bHandled = super.OnUnrealCommand(cmd, arg);
			if (!bHandled)
			{
				bHandled = List.Navigator.OnUnrealCommand(cmd, arg);
			}

			break;
	}


	if (bHandled)
	{
		return true;
	}

	return super.OnUnrealCommand(cmd, arg);
}

function bool GetFlipSort()
{
    return FlipSort;
}

function int GetSortType()
{
    return SortType;
}

function SetFlipSort(bool bFlip)
{
    FlipSort = bFlip;
}

function SetSortType(int eSortType)
{
    SortType = EResistanceSortType(eSortType);
}

defaultproperties
{
	bAnimateOnInit = false;
	EnableCameraPan = true;
    bConsumeMouseEvents = true;
	InputState    = eInputState_Consume;

	DisplayTag      = "UIDisplay_Council";
	CameraTag       = "UIDisplayCam_ResistanceScreen";

    // Main panel positioning. Note X is not defined, it's set to centered
    // based on the movie width and panel width.
    panelY = 80;
    panelW = 961;
    panelH = 781;
}
