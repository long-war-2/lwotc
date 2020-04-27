//---------------------------------------------------------------------------------------
//  FILE:    UIResistanceManagement_ListItem
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: List Item (one row) for UIResistanceManagement
//---------------------------------------------------------------------------------------

class UIResistanceManagement_ListItem extends UIPanel
	config(LW_UI);

// KDM : Additional Variables Start
var config int m_ListItemFontSize;
// KDM : Additional Variables End

var StateObjectReference OutpostRef;
var UIScrollingText RegionLabel;
var UIText RebelCount, RegionStatusLabel, AdviserLabel, IncomeLabel;
var UIButton ButtonBG;
var UIList List;

simulated function BuildItem()
{
	local int BorderPadding;
    local UIResistanceManagement_LW ParentScreen;

    ParentScreen = UIResistanceManagement_LW(Screen);
	List = ParentScreen.List;
   
    Width = List.Width;
	BorderPadding = 10;
    
	// KDM : Background button which highlights when focused. 
	// The style is now always set to eUIButtonStyle_NONE else hot links, little button icons, will appear when using a controller.
	ButtonBG = Spawn(class'UIButton', self);
	ButtonBG.bIsNavigable = false;
	ButtonBG.InitButton(, , , eUIButtonStyle_NONE);
    ButtonBG.SetResizeToText(false);
	ButtonBG.SetPosition(0, 0);
    ButtonBG.SetSize(Width, Height - 4);

	// KDM : Region name
    RegionLabel = Spawn(class'UIScrollingText', self);
	RegionLabel.InitScrollingText(, , ParentScreen.RegionHeaderButton.Width - BorderPadding * 2,
		ParentScreen.RegionHeaderButton.X + BorderPadding, 7, true);
	
	// KDM : Advent strength and vigilance
	RegionStatusLabel = Spawn(class'UIText', self);
	RegionStatusLabel.InitText(, , true);
	RegionStatusLabel.SetPosition(ParentScreen.RegionStatusButton.X + BorderPadding, 7);
	RegionStatusLabel.SetSize(ParentScreen.RegionStatusButton.Width - BorderPadding * 2, Height);
    
	// KDM : Rebel number and rebels per job header
	RebelCount = Spawn(class'UIText', self);
	RebelCount.InitText(, , true);
	RebelCount.SetPosition(ParentScreen.RebelCountHeaderButton.X + BorderPadding, 7);
    RebelCount.SetSize(ParentScreen.RebelCountHeaderButton.Width - BorderPadding * 2, Height);
    
	// KDM : Haven adviser
	AdviserLabel = Spawn(class'UIText', self);
	AdviserLabel.InitText(, , true);
    AdviserLabel.SetPosition(ParentScreen.AdviserHeaderButton.X + BorderPadding, 7);
    AdviserLabel.SetSize(ParentScreen.AdviserHeaderButton.Width - BorderPadding * 2, Height);

	// KDM : Haven income
	IncomeLabel = Spawn(class'UIText', self);
	IncomeLabel.InitText(, , true);
	IncomeLabel.SetPosition(ParentScreen.IncomeHeaderButton.X + BorderPadding, 7);
    IncomeLabel.SetSize(ParentScreen.IncomeHeaderButton.Width - BorderPadding * 2, Height);
}

simulated function UIResistanceManagement_ListItem InitListItem(StateObjectReference Ref)
{
    OutpostRef = Ref;
    InitPanel();

    BuildItem();
    UpdateData();
    return self;
}

simulated function UpdateData(bool Focused = false)
{
	local int IconOffset, IconSize;
	local String strRegion, strCount, strStatus, strJobDetail, strAdviser, strMoolah;
	
	local StateObjectReference LiaisonRef;
    local XComGameState_LWOutpost Outpost;
    local XComGameState_Unit Liaison;
	local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
    local XGParamTag ParamTag;
	
	IconSize = 32;
	IconOffset = -15;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
    Outpost = XComGameState_LWOutpost(`XCOMHISTORY.GetGameStateForObjectID(OutpostRef.ObjectID));
    Region = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(Outpost.Region.ObjectID));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);

	// KDM : Region name
	// It also displays icons if it : [1] is the starting region [2] has a relay built [3] has been liberated to some extent.
	if (Region.IsStartingRegion())
	{
		strRegion = class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_ResHQ", IconSize, IconSize, IconOffset);
	}
	else
	{
		if (Region.ResistanceLevel >= eResLevel_Outpost)
		{
			strRegion = class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_Outpost", IconSize, IconSize, IconOffset);
		}
		else
		{
			strRegion = "";
		}
	}
	strRegion $= " " $ Region.GetDisplayName() $ " ";

	if (!RegionalAI.bLiberated)
	{
		if (RegionalAI.LiberateStage1Complete)
		{
			strRegion $= class'UIUtilities_LW'.default.m_strBullet;
		}
		if (RegionalAI.LiberateStage2Complete)
		{
			strRegion $= class'UIUtilities_LW'.default.m_strBullet;
		}
	}

	// KDM : IMPORTANT : Originally, SetText() was called; however ImportantDiscoveries.txt explains why SetHTMLText() is the better option
	RegionLabel.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(strRegion, Focused ? -1 : eUIState_Normal, m_ListItemFontSize));

	// KDM : Advent strength and vigilance; dislays liberated status if liberated
	if (RegionalAI.bLiberated)
	{
		strStatus = class'UIResistanceManagement_LW'.default.m_strLiberated;
	}
	else
	{
		ParamTag.IntValue0 = RegionalAI.LocalAlertLevel;
		ParamTag.IntValue1 = RegionalAI.LocalVigilanceLevel;
		strStatus = `XEXPAND.ExpandString(class'UIResistanceManagement_LW'.default.m_strResistanceManagementLevels);
	}

	RegionStatusLabel.SetCenteredText(class'UIUtilities_Text'.static.GetColoredText(strStatus, Focused ? -1: eUIState_Normal, m_ListItemFontSize));

	// KDM : Number of rebels in the haven and number of rebels on : [1] supply [2] intel [3] recruit [4] hiding.
    strCount = class'UIUtilities_Text'.static.GetColoredText(string(Outpost.GetRebelCount()),
        Focused ? -1 : eUIState_Normal, m_ListItemFontSize);
    strCount $= class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_Resistance", IconSize, IconSize, IconOffset);
	strCount $= "  ";

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = Outpost.GetNumRebelsOnJob('Resupply');
	ParamTag.IntValue1 = Outpost.GetNumRebelsOnJob('Intel');
	ParamTag.IntValue2 = Outpost.GetNumRebelsOnJob('Recruit');
	strJobDetail = `XEXPAND.ExpandString(class'UIStrategyMapItem_Region_LW'.default.m_strStaffingPinText);
	ParamTag.IntValue0 = Outpost.GetNumRebelsOnJob('Hiding');
	strJobDetail = strJobDetail @ `XEXPAND.ExpandString(class'UIStrategyMapItem_Region_LW'.default.m_strStaffingPinTextMore);

	strCount $= class'UIUtilities_Text'.static.GetColoredText(strJobDetail, Focused ? -1: eUIState_Normal, m_ListItemFontSize);

    if (Outpost.GetResistanceMecCount() > 0)
    {
        strCount $= "  ";
        strCount $= class'UIUtilities_Text'.static.GetColoredText(string(Outpost.GetResistanceMecCount()), Focused ? -1 : eUIState_Normal, m_ListItemFontSize);
        strCount $= class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_LW_Overhaul.Resistance_Mec_icon", IconSize, IconSize, IconOffset);
    }

    RebelCount.SetCenteredText(strCount);

	// KDM : Haven adviser icon, if a haven adviser exists
	if (OutPost.HasLiaisonOfKind ('Soldier'))
    {
		LiaisonRef = OutPost.GetLiaison();
        Liaison = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LiaisonRef.ObjectID));
		strAdviser = class'UIUtilities_Text'.static.InjectImage(Liaison.GetSoldierClassTemplate().IconImage, IconSize, IconSize, IconOffset);
		strAdviser $= class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.static.GetRankIcon(Liaison.GetRank(), Liaison.GetSoldierClassTemplateName()), IconSize, IconSize, IconOffset);
	}
	if (OutPost.HasLiaisonOfKind ('Engineer'))
	{
		strAdviser = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.EventQueue_Engineer, IconSize, IconSize, IconOffset + 9);
	}
	if (OutPost.HasLiaisonOfKind ('Scientist'))
	{
		strAdviser = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.EventQueue_Science, IconSize, IconSize, IconOffset + 9);
	}

	if (strAdviser != "")
	{
		// KDM : IMPORTANT : If you have a string which only contains an injected image, and then center it, the image is doubled.
		// Get around this apparent bug by placing empty spaces on each side of the injected image.
		AdviserLabel.SetCenteredText (class'UIUtilities_Text'.static.GetColoredText(" " $ strAdviser $ " ", Focused ? -1: eUIState_Normal, m_ListItemFontSize));
    }

	// KDM : Real and projected haven income
	ParamTag.IntValue0 = int(Outpost.GetIncomePoolForJob('Resupply'));
    ParamTag.IntValue1 = int(Outpost.GetProjectedMonthlyIncomeForJob('Resupply'));
	strMoolah = `XEXPAND.ExpandString(class'UIStrategyMapItem_Region_LW'.default.m_strMonthlyRegionalIncome);
	IncomeLabel.SetCenteredText(class'UIUtilities_Text'.static.GetColoredText(strMoolah, Focused ? -1: eUIState_Normal, m_ListItemFontSize));
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
    ButtonBG.MC.FunctionVoid("mouseIn");
	UpdateData(true);
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
    ButtonBG.MC.FunctionVoid("mouseOut");
	UpdateData();
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;
	local int index;
	
	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	bHandled = true;

	switch (cmd)
	{
		// KDM : A button opens the corresponding Haven screen.
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			index = List.GetItemIndex(self);
			UIResistanceManagement_LW(Screen).OnRegionSelectedCallback(List, index);
			break;
		
		default:
			bHandled = false;
			break;
	}

	if (bHandled)
	{
		return true;
	}

	// KDM : If the input has not been handled, allow it to continue on its way
	return super.OnUnrealCommand(cmd, arg);
}

defaultproperties
{
    Height = 52;
    bProcessesMouseEvents = true;
	bIsNavigable = true;
}
