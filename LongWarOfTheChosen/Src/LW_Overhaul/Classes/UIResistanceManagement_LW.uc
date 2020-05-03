//---------------------------------------------------------------------------------------
//  FILE:    UIResistanceManagement_LW
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: UI for overall resistance managemenet
//---------------------------------------------------------------------------------------

class UIResistanceManagement_LW extends UIScreen
	config(LW_UI) implements (IUISortableScreen);

enum EResistanceSortType
{
	eResistanceSortType_Region,
	eResistanceSortType_RebelCount,
};

var config bool USE_LARGE_VERSION;
var config int HEADER_BUTTON_HEIGHT_MK, HEADER_FONT_SIZE_MK;
var config int HEADER_BUTTON_HEIGHT_CTRL, HEADER_FONT_SIZE_CTRL;

// KDM : Best to explain by way of an example :
// Assume a controller user is on the Resistance overview screen and clicks on 'Western Canada'; this will bring up the 
// Haven screen for 'Western Canada'. Now, when we are done dealing with the haven, and re-enter the Resistance overview screen,
// we want to make sure 'Western Canada' is still selected for consistency. 
var int SelectedIndexOnFocusLost;

// KDM : Determines how wide each of the columns will be.
var float RegionHeaderPct, RegionStatusPct, RebelCountPct, AdviserHeaderPct, IncomeHeaderPct; 

var bool FlipSort;
var bool EnableCameraPan;
var EResistanceSortType SortType;

var UIPanel m_kAllContainer;
var UIX2PanelHeader m_MissionHeader;
var UIBGBox m_MissionHeaderBox;
var UIX2PanelHeader m_ObjectiveHeader;
var UIBGBox m_ObjectiveHeaderBox;

var name DisplayTag;
var name CameraTag;

var localized string FlyToHavenStr, ViewHavenStr;
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
var localized string m_strResistanceManagementLevels;

var UIList List;
var UIBGBox ListBG;
var UIPanel MainPanel;
var UIX2PanelHeader ListTitle;
var UIPanel DividerLine;
var UIPanel HeaderPanel;
var UIButton RegionHeaderButton, RegionStatusButton, IncomeHeaderButton, AdviserHeaderButton, RebelCountHeaderButton;

var int m_iMaskWidth;
var int m_iMaskHeight;

var int panelY;
var int panelH;
var int panelW;

var array<StateObjectReference> CachedOutposts;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local int BorderPadding, ItemPadding, NextY, ScrollbarPadding, TheHeaderButtonHeight, TheHeaderFontSize;
	local float AvailableHeaderSpace;

	SelectedIndexOnFocusLost = INDEX_NONE;

	BorderPadding = 15;
	ItemPadding = 10;
	ScrollbarPadding = 10;

	RegionHeaderPct = 0.25f;
	RegionStatusPct = 0.17f;
	RebelCountPct = 0.28f;
	AdviserHeaderPct = 0.12f;
	IncomeHeaderPct = 0.18f; 

	NextY = 0;
	
	if (`ISCONTROLLERACTIVE)
	{
		TheHeaderButtonHeight = HEADER_BUTTON_HEIGHT_CTRL;
		TheHeaderFontSize = HEADER_FONT_SIZE_CTRL;
	}
	else
	{
		TheHeaderButtonHeight = HEADER_BUTTON_HEIGHT_MK;
		TheHeaderFontSize = HEADER_FONT_SIZE_MK;
	}

	super.InitScreen(InitController, InitMovie, InitName);

	panelW = 1150;

	// KDM : We need to make the Resistance management screen taller if it is to show all havens without scrollbars.
	if (USE_LARGE_VERSION)
	{
		panelH = 1000;
	}
	else
	{
		panelH = 830;
	}

	// KDM : The Resistance overview screen is centered horizontally and vertically when viewed via the strategy map.
	// Normally, when viewed via the Avenger, its vertical position is set manually in order to fit a fancy 3D background; however,
	// if we are going to use the large version, we will center it vertically since it won't really fit the fancy 3D background anyways.
	if (class'Utilities_LW'.static.IsOnStrategyMap() || USE_LARGE_VERSION)
	{
		panelY = (Movie.UI_RES_Y / 2) - (panelH / 2);
	}
	else
	{
		panelY = 80;
	}

	// KDM : On the Avenger, both the Haven screen and, this, Resistance overview screen are placed within a 3D movie;
	// consequently, a 3D camera needs to be specified. Note that EnableCameraPan determines whether this screen will
	// swoop in from the side of the screen or simply appear.
	if (!class'Utilities_LW'.static.IsOnStrategyMap())
	{
		if (EnableCameraPan)
		{
			class'UIUtilities'.static.DisplayUI3D(DisplayTag, CameraTag, `HQINTERPTIME);
		}
		else
		{
			class'UIUtilities'.static.DisplayUI3D(DisplayTag, CameraTag, 0, true);
		}
	}

	// KDM : Container which will hold our UI components : it's invisible
	MainPanel = Spawn(class 'UIPanel', self);
	MainPanel.bAnimateOnInit = false;
	MainPanel.bIsNavigable = false;
	MainPanel.InitPanel('ListContainer');
	MainPanel.SetPosition((Movie.UI_RES_X / 2) - (panelW / 2), panelY);

	// KDM : Background rectangle
	ListBG = Spawn(class'UIBGBox', MainPanel);
	ListBG.bAnimateOnInit = false;
	ListBG.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	ListBG.InitBG('ListBG', 0, 0, panelW, panelH);
	
	// KDM : Header (includes title, resistance summary sub-title, and background image) 
	ListTitle = Spawn(class'UIX2PanelHeader', MainPanel);
	ListTitle.bAnimateOnInit = false;
	ListTitle.bIsNavigable = false;
	ListTitle.InitPanelHeader('TitleHeader', m_strTitle, GetResistanceSummaryString());
	ListTitle.SetPosition(BorderPadding, BorderPadding);
	ListTitle.SetHeaderWidth(panelW - BorderPadding * 2);
	
	NextY = ListTitle.Y + ListTitle.Height;

	// KDM : Thin dividing line
	DividerLine = Spawn(class'UIPanel', MainPanel);
	DividerLine.bAnimateOnInit = false;
	DividerLine.bIsNavigable = false;
	DividerLine.LibID = class'UIUtilities_Controls'.const.MC_GenericPixel;
	DividerLine.InitPanel('DividerLine');
	DividerLine.SetPosition(BorderPadding, NextY);
	DividerLine.SetWidth(panelW - BorderPadding * 2);
	DividerLine.SetAlpha(20);

	NextY += ItemPadding;

	// KDM : Container for column headers : it's invisible
	HeaderPanel = Spawn(class'UIPanel', MainPanel);
	HeaderPanel.bAnimateOnInit = false;
	HeaderPanel.bIsNavigable = false;
	HeaderPanel.InitPanel('Header');
	HeaderPanel.SetPosition(BorderPadding, NextY);
	HeaderPanel.SetSize(panelW - BorderPadding * 2 - ScrollbarPadding, 32);

	// KDM : Available header space = total header width - 2 pixels between each of the 5 column headers. 
	AvailableHeaderSpace = HeaderPanel.Width - 4 * 2;

	// KDM : Region name header
	RegionHeaderButton = Spawn(class'UIButton', HeaderPanel);
	RegionHeaderButton.bAnimateOnInit = false;
	RegionHeaderButton.bIsNavigable = false;
	RegionHeaderButton.ResizeToText = false;
	RegionHeaderButton.InitButton(, m_strRegionLabel);
	RegionHeaderButton.SetPosition(0, 0);
	RegionHeaderButton.SetSize(AvailableHeaderSpace * RegionHeaderPct, TheHeaderButtonHeight);
	RegionHeaderButton.SetStyle(eUIButtonStyle_NONE, TheHeaderFontSize);
	RegionHeaderButton.SetWarning(true);
	// KDM : Since the region column header can't be clicked, remove its hit testing so mouse events don't change its colour
	// and make users think the button is active. The same is done for all of the column headers below.
	RegionHeaderButton.SetHitTestDisabled(true);

	// KDM : Advent strength and vigilance header
	RegionStatusButton = Spawn(Class'UIButton', HeaderPanel);
	RegionStatusButton.bAnimateOnInit = false;
	RegionStatusButton.bIsNavigable = false;
	RegionStatusButton.ResizeToText = false;
	RegionStatusButton.InitButton (, m_strSTrength);
	RegionStatusButton.SetPosition(RegionHeaderButton.X + RegionHeaderButton.Width + 2, 0);
	RegionStatusButton.SetSize(AvailableHeaderSpace * RegionStatusPct, TheHeaderButtonHeight);
	RegionStatusButton.SetStyle(eUIButtonStyle_NONE, TheHeaderFontSize);
	RegionStatusButton.SetWarning(true);
	RegionStatusButton.SetHitTestDisabled(true);

	// KDM : Rebel number and rebels per job header
	RebelCountHeaderButton = Spawn(class'UIButton', HeaderPanel);
	RebelCountHeaderButton.bAnimateOnInit = false;
	RebelCountHeaderButton.bIsNavigable = false;
	RebelCountHeaderButton.ResizeToText = false;
	RebelCountHeaderButton.InitButton(, m_strRebelCountLabel);
	RebelCountHeaderButton.SetPosition(RegionStatusButton.X + RegionStatusButton.Width + 2, 0);
	RebelCountHeaderButton.SetSize(AvailableHeaderSpace * RebelCountPct, TheHeaderButtonHeight);
	RebelCountHeaderButton.SetStyle(eUIButtonStyle_NONE, TheHeaderFontSize);
	RebelCountHeaderButton.SetWarning(true);
	RebelCountHeaderButton.SetHitTestDisabled(true);

	// KDM : Haven adviser header
	AdviserHeaderButton = Spawn(class'UIButton', HeaderPanel);
	AdviserHeaderButton.bAnimateOnInit = false;
	AdviserHeaderButton.bIsNavigable = false;
	AdviserHeaderButton.ResizeToText = false;
	AdviserHeaderButton.InitButton(, m_strAdviserLabel);
	AdviserHeaderButton.SetPosition(RebelCountHeaderButton.X + RebelCountHeaderButton.Width + 2, 0);
	AdviserHeaderButton.SetSize(AvailableHeaderSpace * AdviserHeaderPct, TheHeaderButtonHeight);
	AdviserHeaderButton.SetStyle(eUIButtonStyle_NONE, TheHeaderFontSize);
	AdviserHeaderButton.SetWarning(true);
	AdviserHeaderButton.SetHitTestDisabled(true);

	// KDM : Haven income header
	IncomeHeaderButton = Spawn(class'UIButton', HeaderPanel);
	IncomeHeaderButton.bAnimateOnInit = false;
	IncomeHeaderButton.bIsNavigable = false;
	IncomeHeaderButton.ResizeToText = false;
	IncomeHeaderButton.InitButton(, m_strIncomeLabel);
	IncomeHeaderButton.SetPosition(AdviserHeaderButton.X + AdviserHeaderButton.Width + 2, 0);
	IncomeHeaderButton.SetSize(AvailableHeaderSpace * IncomeHeaderPct, TheHeaderButtonHeight);
	IncomeHeaderButton.SetStyle(eUIButtonStyle_NONE, TheHeaderFontSize);
	IncomeHeaderButton.SetWarning(true);
	IncomeHeaderButton.SetHitTestDisabled(true);

	NextY += 30 + ItemPadding;

	// KDM : List container which will hold rows of haven information
	List = Spawn(class'UIList', MainPanel);
	List.bAnimateOnInit = false;
	List.bIsNavigable = true;
	List.bStickyHighlight = false;
	List.InitList(, BorderPadding, NextY, HeaderPanel.Width, panelH - NextY - BorderPadding);
	List.OnItemClicked = OnRegionSelectedCallback;

	// LWS : Redirect all background mouse events to the list so mouse wheel scrolling doesn't get lost when the mouse is positioned between list items.
	ListBG.ProcessMouseEvents(List.OnChildMouseEvent);

	RefreshNavHelp();
	RefreshData();

	// KDM : Automatically select the 1st rebel row when using a controller.
	if (`ISCONTROLLERACTIVE)
	{
		List.NavigatorSelectionChanged(0);
	}
}

simulated function string GetResistanceSummaryString()
{
	local int MeanAvatarHours;
	local string strAvatarPenalty;
	local XGParamTag ParamTag;

	// KDM : Global advent strength (number of legions)
	m_strGlobalResistanceSummary = m_strGlobalAlert @ string(`LWACTIVITYMGR.GetGlobalAlert());
	if (`LWACTIVITYMGR.GetGlobalAlert() == 1)
	{
		m_strGlobalResistanceSummary @= m_strADVENTUnitSingular;
	}
	else
	{
		m_strGlobalResistanceSummary @= m_strADVENTUnitPlural;
	}

	// KDM : Global resistance threat
	m_strGlobalResistanceSummary @= m_strGlobalInsurgency @ GetThreatLevelStr(`LWACTIVITYMGR.GetNetVigilance());

	// KDM : How much Avatar progress has been slowed by
	if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'))
	{
		MeanAvatarHours = (class'XComGameState_HeadquartersAlien'.default.MinFortressDoomInterval[`STRATEGYDIFFICULTYSETTING] + class'XComGameState_HeadquartersAlien'.default.MaxFortressDoomInterval[`STRATEGYDIFFICULTYSETTING]) / 2;
		ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		ParamTag.IntValue0 = Round(float(`LWACTIVITYMGR.GetDoomUpdateModifierHours() * 100) / float (MeanAvatarHours));
		strAvatarPenalty = `XEXPAND.ExpandString(m_strAvatarPenalty);
		m_strGlobalResistanceSummary @= strAvatarPenalty;
	}

	return m_strGlobalResistanceSummary;
}

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

// Handle mouse events on the header buttons
simulated function HeaderMouseEvent(UIPanel Control, int cmd)
{
	switch (cmd)
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
	local StateObjectReference OutpostRef;
	local UIOutpostManagement OutpostScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;
	OutpostRef = CachedOutposts[itemIndex];

	OutpostScreen = HQPres.Spawn(class'UIOutpostManagement', HQPres);
	OutpostScreen.SetOutpost(OutpostRef);

	// KDM : On the Avenger, both the Haven screen and, this, Resistance overview screen are placed within a 3D movie
	// so they can be put atop a fancy 3D background. This is unneccesary on the strategy map; therefore, in that case,
	// both screens are placed within a 2D movie.
	if (class'Utilities_LW'.static.IsOnStrategyMap())
	{
		HQPres.ScreenStack.Push(OutpostScreen, HQPres.Get2DMovie());
	}
	else
	{
		HQPres.ScreenStack.Push(OutpostScreen, HQPres.Get3DMovie());
	}
}

simulated function RefreshNavHelp()
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;
	NavHelp.ClearButtonHelp();
	NavHelp.bIsVerticalHelp = `ISCONTROLLERACTIVE;
	NavHelp.AddBackButton(OnCancel);

	// KDM : Controller specific navigation help
	if (`ISCONTROLLERACTIVE)
	{
		// KDM : A button opens the Haven screen
		NavHelp.AddLeftHelp(ViewHavenStr, class'UIUtilities_Input'.static.GetAdvanceButtonIcon());

		// KDM : Right stick click sends the Avenger to the selected haven, if on the strategy map.
		if (class'Utilities_LW'.static.IsOnStrategyMap())
		{
			NavHelp.AddLeftHelp(FlyToHavenStr, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_RSCLICK_R3);
		}
	}
	else
	{
		class'LWHelpTemplate'.static.AddHelpButton_Nav('ResistanceManagement_Help');
	}
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

	// KDM : The calls to DisplayUI3D() have been removed as they appear unnecessary.

	RefreshData();

	if (`ISCONTROLLERACTIVE)
	{
		if (SelectedIndexOnFocusLost == INDEX_NONE)
		{
			// KDM : We don't know which list item was selected, so select the 1st one.
			List.NavigatorSelectionChanged(0);
		}
		else
		{
			// KDM : Re-select the list item which was selected when we lost focus.
			List.NavigatorSelectionChanged(SelectedIndexOnFocusLost);
		}
	}
}

simulated function OnLoseFocus()
{
	// KDM : Keep track of the selected list item so it can be re-selected when this Haven screen regains focus.
	// This is described in more detail at the top of the file.
	if (`ISCONTROLLERACTIVE)
	{
		SelectedIndexOnFocusLost = List.SelectedIndex;
	}

	super.OnLoseFocus();
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();

	// KDM : The call to HideDisplay() has been removed as it appears unnecessary.
}

simulated function FlyToSelectedHaven()
{
	local StateObjectReference OutpostRef;
	local UIStrategyMapItem_Region_LW MapItem;
	local XComGameState_LWOutpost Outpost;
	local XComGameState_WorldRegion Region;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	OutpostRef = CachedOutposts[List.GetItemIndex(List.GetSelectedItem())];
	Outpost = XComGameState_LWOutpost(History.GetGameStateForObjectID(OutpostRef.ObjectID));
	Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(Outpost.Region.ObjectID));

	MapItem = UIStrategyMapItem_Region_LW(`HQPRES.StrategyMap2D.GetMapItem(Region));
	
	// KDM : Simulate the clicking of a haven's scan button in order to travel to that haven.
	// Since this is used by controller users, we need to make sure that the scan button is visible, else we may run into problems.
	if (MapItem.ScanButton.bIsVisible)
	{
		MapItem.OnDefaultClicked();

		// KDM : Close this Resistance overview screen.
		OnCancel();
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	bHandled = true;

	switch (cmd)
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			break;
		
		// KDM : Right stick click sends the Avenger to the selected haven, if on the strategy map.
		case class'UIUtilities_Input'.const.FXS_BUTTON_R3:
			if (class'Utilities_LW'.static.IsOnStrategyMap())
			{
				FlyToSelectedHaven();
			}
			break;

		default:
			// KDM : Formerly, the A button, Enter key, and Spacebar called OnAccept() which did nothing; they will now
			// trickle down to the selected list item's OnUnrealCommand() and simulate a click.
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

	// KDM : If the input has not been handled, allow it to continue on its way.
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
	InputState = eInputState_Consume;

	DisplayTag = "UIDisplay_Council";
	CameraTag = "UIDisplayCam_ResistanceScreen";

	// Main panel positioning. Note X is not defined, it's set to centered
	// based on the movie width and panel width.
	panelY = 80;
	panelW = 961;
	panelH = 781;

	// KDM : See the comments in UIMouseGuard_LW for more information.
	MouseGuardClass = class'UIMouseGuard_LW';
}

