//---------------------------------------------------------------------------------------
//  FILE:    UIResistanceManagement_ListItem
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: List Item (one row) for UIResistanceManagement
//---------------------------------------------------------------------------------------

class UIResistanceManagement_ListItem extends UIPanel;

var StateObjectReference OutpostRef;
var UIScrollingText RegionLabel;
var UIText RebelCount, RegionStatusLabel, AdviserLabel, IncomeLabel;
var UIButton ButtonBG;
var UIList List;

simulated function BuildItem()
{
    local XComGameState_LWOutpost Outpost;

    Outpost = XComGameState_LWOutpost(`XCOMHISTORY.GetGameStateForObjectID(OutpostRef.ObjectID));

    List = UIList(GetParent(class'UIList'));

    Width = UIResistanceManagement_LW(Screen).List.Width;
    ButtonBG = Spawn(class'UIButton', self);
	ButtonBG.bIsNavigable = false;
	ButtonBG.InitButton();
    ButtonBG.SetResizeToText(false);
    ButtonBG.SetSize(Width - 4, Height - 4);

    RegionLabel = Spawn(class'UIScrollingText', self).InitScrollingText(, , Width * 0.25, 15, 3, true);
	RegionStatusLabel = Spawn(class'UIText', self).InitText(,,true);
	RegionStatusLabel.SetSize(Width * 0.17, Height).SetPosition(RegionLabel.Width, 3);
    RebelCount = Spawn(class 'UIText', self).InitText(,,true);
    RebelCount.SetSize(Width * 0.30, Height).SetPosition(RegionLabel.Width + RegionStatusLabel.Width, 3);
    AdviserLabel = Spawn(class 'UIText', self).InitText(,,true);
    IncomeLabel = Spawn(class 'UIText', self).InitText(,,true);
    IncomeLabel.SetSize(Width * 0.2, Height);

    if (Outpost.HasLiaisonOfKind('Soldier'))
    {
        AdviserLabel.SetSize(Width * 0.08, Height).SetPosition(RegionLabel.Width + RegionStatusLabel.Width + RebelCount.Width, 3);
        IncomeLabel.SetPosition(RegionLabel.Width + RegionStatusLabel.Width + RebelCount.Width + AdviserLabel.Width, 3);
    } else {
        AdviserLabel.SetSize(Width * 0.04, Height).SetPosition(RegionLabel.Width + RegionStatusLabel.Width + RebelCount.Width + Width * 0.02, 3);
        IncomeLabel.SetPosition(RegionLabel.Width + RegionStatusLabel.Width + RebelCount.Width + AdviserLabel.Width + Width * 0.04, 3);
    }


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
    local XComGameState_LWOutpost Outpost;
    local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
    local String strRegion, strCount, strStatus, strJobDetail, strAdviser, strMoolah;
	local XGParamTag ParamTag;
	local XComGameState_Unit Liaison;
	local StateObjectReference LiaisonRef;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
    Outpost = XComGameState_LWOutpost(`XCOMHISTORY.GetGameStateForObjectID(OutpostRef.ObjectID));
    Region = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(Outpost.Region.ObjectID));
	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);

	if (Region.IsStartingRegion())
	{
		strRegion = class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_ResHQ", 24, 24, -8);
	}
	else
	{
		if (Region.ResistanceLevel >= eResLevel_Outpost)
		{
			strRegion = class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_Outpost", 24, 24, -8);
		}
		else
		{
			strRegion = "";
		}
	}
	strRegion $= Region.GetDisplayName();

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

	RegionLabel.SetText(class'UIUtilities_Text'.static.GetColoredText(strRegion, Focused ? -1 : eUIState_Normal));

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
	RegionStatusLabel.SetCenteredText (class'UIUtilities_Text'.static.GetColoredText(strStatus, Focused ? -1: eUIState_Normal, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D));

    strCount = class'UIUtilities_Text'.static.GetColoredText(string(Outpost.GetRebelCount()),
        Focused ? -1 : eUIState_Normal,
        class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
    strCount $= class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_Resistance", 24, 24, -8);
	strCount $= "  ";

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = Outpost.GetNumRebelsOnJob('Resupply');
	ParamTag.IntValue1 = Outpost.GetNumRebelsOnJob('Intel');
	ParamTag.IntValue2 = Outpost.GetNumRebelsOnJob('Recruit');
	strJobDetail = `XEXPAND.ExpandString(class'UIStrategyMapItem_Region_LW'.default.m_strStaffingPinText);
	ParamTag.IntValue0 = Outpost.GetNumRebelsOnJob('Hiding');
	strJobDetail = strJobDetail @ `XEXPAND.ExpandString(class'UIStrategyMapItem_Region_LW'.default.m_strStaffingPinTextMore);

	strCount $= class'UIUtilities_Text'.static.GetColoredText(strJobDetail, Focused ? -1: eUIState_Normal, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);

    if (Outpost.GetResistanceMecCount() > 0)
    {
        strCount $= "  ";
        strCount $= class'UIUtilities_Text'.static.GetColoredText(string(Outpost.GetResistanceMecCount()), Focused ? -1 : eUIState_Normal, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D);
        strCount $= class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_LW_Overhaul.Resistance_Mec_icon", 24, 24, -8);
    }

    RebelCount.SetCenteredText(strCount);
	if (OutPost.HasLiaisonOfKind ('Soldier'))
    {
		LiaisonRef = OutPost.GetLiaison();
        Liaison = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LiaisonRef.ObjectID));
		strAdviser = class'UIUtilities_Text'.static.InjectImage(Liaison.GetSoldierClassTemplate().IconImage, 28, 28, -5);
		strAdviser $= class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.static.GetRankIcon(Liaison.GetRank(), Liaison.GetSoldierClassTemplateName()), 28, 28, -5);
	}
	if (OutPost.HasLiaisonOfKind ('Engineer'))
	{
		strAdviser = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.EventQueue_Engineer, 28, 28, -5);
	}
	if (OutPost.HasLiaisonOfKind ('Scientist'))
	{
		strAdviser = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.EventQueue_Science, 28, 28, -5);
	}

	if (strAdviser != "")
	{
		AdviserLabel.SetCenteredText (class'UIUtilities_Text'.static.GetColoredText(strAdviser, Focused ? -1: eUIState_Normal, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D));
    }

	ParamTag.IntValue0 = int(Outpost.GetIncomePoolForJob('Resupply'));
    ParamTag.IntValue1 = int(Outpost.GetProjectedMonthlyIncomeForJob('Resupply'));
	strMoolah = `XEXPAND.ExpandString(class'UIStrategyMapItem_Region_LW'.default.m_strMonthlyRegionalIncome);
	IncomeLabel.SetCenteredText (class'UIUtilities_Text'.static.GetColoredText(strMoolah, Focused ? -1: eUIState_Normal, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D));

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


defaultproperties
{
    Height = 52;
    bProcessesMouseEvents = true;
	bIsNavigable = true;
}
