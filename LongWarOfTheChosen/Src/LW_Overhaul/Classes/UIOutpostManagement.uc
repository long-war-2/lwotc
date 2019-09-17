//---------------------------------------------------------------------------------------
//  FILE:    UIOutpostManagement
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: UI for managing a single outpost
//--------------------------------------------------------------------------------------- 

class UIOutpostManagement extends UIScreen
    dependson(XComGameState_LWOutpost);

var name DisplayTag;
var name CameraTag;

var localized string m_strTitle;
var localized string m_strLabel;
var localized string m_strName;
var localized string m_strMission;
var localized string m_strBuildRadioRelay;
var localized string m_strLiaisonTitle;
var localized string m_strRegionalInfo;
var localized string m_strResistanceMecs;
var localized string m_strProhibited;
var localized string m_strCannotChangeLiaisonTitle;
var localized string m_strCannotChangeLiaison;

var UIButton RadioTowerUpgradeButton;

var UIList List;
var UIBGBox ListBG;
var UIPanel MainPanel;
var UIX2PanelHeader ListTitle;
var UIPanel DividerLine;
var UIPanel HeaderPanel;
var UIButton NameHeaderButton;
var UIButton JobHeaderButton;
var UIText LiaisonTitle;
var UIButton LiaisonButton;
var UIImage LiaisonImage;
var UIText LiaisonName;

var UIScrollingText RegionalInfo;
var UIScrollingText ResistanceMecs;
var UIScrollingText JobDetail;

var UIPersonnel_Liaison LiaisonScreen;

var StateObjectReference OutpostRef;
var array<RebelUnit> CachedRebels;
var array<Name> CachedJobNames;
var StateObjectReference CachedLiaison;

var bool IsDirty;

//var int panelX;
var int panelY;
var int panelH;
var int panelW;

// Debug options
var bool ShowFaceless;

simulated function bool ShowRadioTowerUpgradeButton()
{
	return class'UIUtilities_Strategy'.static.GetXComHQ().IsOutpostResearched() && GetRegion().ResistanceLevel == eResLevel_Contact && !GetRegion().bCanScanForOutpost;
}

simulated function XComGameState_WorldRegion GetRegion()
{
    local XComGameState_WorldRegion Region;
    local XComGameState_LWOutpost Outpost;
    local XComGameStateHistory History;

    History = `XCOMHISTORY;
	Outpost = XComGameState_LWOutpost(History.GetGameStateForObjectID(OutpostRef.ObjectID));
    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(Outpost.Region.ObjectID));
	return Region;
}

function OnRadioTowerUpgradeClicked(UIButton Button)
{
	`HQPRES.UIBuildOutpost(GetRegion());
}

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
    local int NextY;
    local XComGameState_WorldRegion Region;
    local XComGameState_LWOutpost Outpost;
    local XComGameStateHistory History;
	local string strRegionalInfo;
    local string strResistanceMecs;
	local string strJobDetail;
	local XGParamTag kTag;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;
	local bool IntelProhibited, SupplyProhibited, RecruitProhibited;
	local int k;

 	// Init UI
	super.InitScreen(InitController, InitMovie, InitName);
	
    MainPanel = Spawn(class 'UIPanel', self);
    MainPanel.InitPanel('ListContainer').SetPosition((Movie.UI_RES_X / 2) - (panelW / 2), panelY);
    ListBG = Spawn(class'UIBGBox', MainPanel);
	ListBG.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	ListBG.InitBG('ListBG', 0, 0, panelW, panelH);
    ListBG.bIsNavigable = false;

    History = `XCOMHISTORY;
    Outpost = XComGameState_LWOutpost(History.GetGameStateForObjectID(OutpostRef.ObjectID));
    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(Outpost.Region.ObjectID));
    ListTitle = Spawn(class'UIX2PanelHeader', MainPanel).InitPanelHeader('TitleHeader', m_strTitle, Region.GetDisplayName());
	ListTitle.SetHeaderWidth(ListBG.Width - 20);
    ListTitle.SetPosition(ListBG.X + 10, ListBG.Y + 10);

    NextY = ListTitle.Y + ListTitle.Height;

    // Region Info
	RegionalInfo = Spawn(class'UIScrollingText', MainPanel).InitScrollingText('Outpost_RegionalInfo_LW', "", 500, 453, ListBG.Y + 10 + 36.75);
	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	RegionalAIState = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);
	if (!RegionalAIState.bLiberated)
	{
		kTag.IntValue0 = RegionalAIState.LocalAlertLevel;
		kTag.IntValue1 = RegionalAIState.LocalVigilanceLevel;
		kTag.IntValue2 = RegionalAIState.LocalForceLevel;
		strRegionalInfo = `XEXPAND.ExpandString(m_strRegionalInfo);
	}
	else
	{
		strRegionalInfo = class'UIResistanceManagement_LW'.default.m_strLiberated;
	}
	RegionalInfo.SetHTMLText("<p align=\'RIGHT\'><font size=\'24\' color=\'#fef4cb\'>" $ strRegionalInfo $ "</font></p>");
	RegionalInfo.SetAlpha(67.1875);

    // Resistance MECs
    if (Outpost.GetResistanceMecCount() > 0)
    {
        ResistanceMecs = Spawn(class'UIScrollingText', MainPanel).InitScrollingText('Outpost_ResistanceMecs_LW', "", 500, 453, RegionalInfo.Y + RegionalInfo.Height + 6);
        kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
        kTag.IntValue0 = Outpost.GetResistanceMecCount();
        strResistanceMecs = `XEXPAND.ExpandString(m_strResistanceMecs);
        ResistanceMecs.SetHTMLText("<p align=\'RIGHT\'><font size=\'24\' color=\'#fef4cb\'>" $ strResistanceMecs $ "</font></p>");
        ResistanceMecs.SetAlpha(67.1875);
    }

	for (k=0; k< Outpost.prohibitedjobs.length; k++)	
	{
		if (OutPost.ProhibitedJobs[k].Job == 'Intel' && Outpost.ProhibitedJobs[k].DaysLeft > 0)
			IntelProhibited = true;
		if (OutPost.ProhibitedJobs[k].Job == 'Resupply' && OutPost.ProhibitedJobs[k].DaysLeft > 0)
			SupplyProhibited = true;
		if (OutPost.ProhibitedJobs[k].Job == 'Recruit' && Outpost.ProhibitedJobs[k].DaysLeft > 0)
			RecruitProhibited = true;
	}

	if (IntelProhibited)
	{
		strJobDetail @= OutPost.GetJobName('Intel') $ ":";
		strJobDetail @= m_strProhibited;
	}
	if (SupplyProhibited)
	{
		strJobDetail @= OutPost.GetJobName('Resupply') $ ":";
		strJobDetail @= m_strProhibited;
	}
	if (RecruitProhibited)
	{
		strJobDetail @= OutPost.GetJobName('Recruit') $ ":";
		strJobDetail @= m_strProhibited;
	}

	if (IntelProhibited || SupplyProhibited || RecruitProhibited)
	{
	    JobDetail = Spawn(class'UIScrollingText', MainPanel).InitScrollingText('OutPost_JobDetail_LW', "", 500, 453, RegionalInfo.Y + RegionalInfo.Height + (OutPost.GetResistanceMecCount() > 0) ? (ResistanceMECs.Height + 12.0f) : 6.0f);
	    JobDetail.SetHTMLText("<p align=\'RIGHT\'><font size=\'24\' color=\'#fef4cb\'>" $ strJobDetail $ "</font></p>");
		JobDetail.SetAlpha(67.1875);
	}

    LiaisonButton = Spawn(class'UIButton', MainPanel);
    LiaisonButton.InitButton(, , OnLiaisonClicked);
    LiaisonButton.SetSize(72, 72);
    LiaisonButton.SetPosition(11, NextY);
    LiaisonImage = Spawn(class'UIImage', LiaisonButton).InitImage();
    LiaisonImage.SetPosition(4, 4);
    LiaisonImage.SetSize(64, 64);

    LiaisonTitle = Spawn(class'UIText', MainPanel);
    LiaisonTitle.InitText('', "");
    LiaisonTitle.SetPosition(11 + LiaisonButton.Width + 3, NextY);
    LiaisonTitle.SetSubTitle(m_strLiaisonTitle);

    LiaisonName = Spawn(class'UIText', MainPanel);
    LiaisonName.InitText('',"");
    LiaisonName.SetPosition(LiaisonTitle.X, NextY + LiaisonTitle.Height);

    NextY += 75;

    DividerLine = Spawn(class'UIPanel', MainPanel);
	DividerLine.bIsNavigable = false;
	DividerLine.LibID = class'UIUtilities_Controls'.const.MC_GenericPixel;
	DividerLine.InitPanel('DividerLine').SetPosition(15, NextY).SetWidth(ListBG.Width - 20);
    DividerLine.SetAlpha(20);

    NextY += DividerLine.Height + 5;

    // Outpost Staff 
    // Header buttons
    HeaderPanel = Spawn(class'UIPanel', MainPanel);
    HeaderPanel.InitPanel('Header').SetPosition(15, NextY).SetSize(ListBG.Width - 56, 32);

    NameHeaderButton = Spawn(class'UIButton', HeaderPanel);
    NameHeaderButton.InitButton(, m_strName);
    NameHeaderButton.SetResizeToText(false);
    NameHeaderButton.SetWidth(HeaderPanel.Width * 0.7f);
    NameHeaderButton.SetPosition(0, 0);
    NameHeaderButton.SetWarning(true);

    JobHeaderButton = Spawn(class'UIButton', HeaderPanel);
    JobHeaderButton.InitButton(, m_strMission, OnJobHeaderButtonClicked);
    JobHeaderButton.SetResizeToText(false);
    JobHeaderButton.SetWidth(HeaderPanel.Width * 0.3f);
    JobHeaderButton.SetPosition(NameHeaderButton.X + NameHeaderButton.Width + 2, 0);
    JobHeaderButton.SetWarning(true);

    NextY += 32 + 5;
 
	List = Spawn(class'UIList', MainPanel);
	List.bIsNavigable = true;
	List.InitList(, 15, NextY, ListBG.Width - 50, panelH - NextY - 5);
	List.bStickyHighlight = false; 

	//check to see if we are in geoscape
	if (`HQGAME == none || `HQPRES == none || `HQPRES.StrategyMap2D == none)
	{
	}
	else
	{
		RadioTowerUpgradeButton = Spawn(class'UIButton', MainPanel);
		RadioTowerUpgradeButton.InitButton(, m_strBuildRadioRelay, OnRadioTowerUpgradeClicked);
		RadioTowerUpgradeButton.AnchorTopLeft();
		RadioTowerUpgradeButton.OriginTopRight();
		RadioTowerUpgradeButton.SetPosition(1430, 168);
		//RadioTowerUpgradeButton.Hide();
	}
    // Redirect all mouse events for the background to the list. Ensures all mouse
    // wheel events get processed by the list instead of consumed by the background
    // when the cursor falls "between" list items.
    ListBG.ProcessMouseEvents(List.OnChildMouseEvent);

    InitJobNameCache();

    RefreshNavHelp();
    GetData();
    RefreshData();
    Show();
}

function OnJobHeaderButtonClicked(UIButton Button)
{
	local int i, j, k;
    local XComGameState_LWOutpost Outpost;
	local bool GoodJobFound;
	local UIOutpostManagement_ListItem ListItem;

	Outpost = XComGameState_LWOutpost(`XCOMHISTORY.GetGameStateForObjectID(OutpostRef.ObjectID));
	i = CachedJobNames.Find(CachedRebels[0].Job);
	GoodJobFound = false;
	While (!GoodJobFound)
	{
		GoodJobFound = true;
		i += 1;
		if (i >= CachedJobNames.Length)
			i = 0;
		for (k = 0; k < Outpost.ProhibitedJobs.length; k++)
		{
			if (Outpost.ProhibitedJobs[k].DaysLeft > 0 && CachedJobNames[i] == OutPost.ProhibitedJobs[k].Job)
			{
				GoodJobFound = false;
			}
		}
	}
	for (j = 0; j < OutPost.Rebels.Length; j++)
	{
		if (CachedJobNames[i] == class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB || j < OutPost.MaxRebels)
		{
			CachedRebels[j].Job = CachedJobNames[i];		
		}
		else
		{
			if (j >= OutPost.MaxRebels)
			{
				CachedRebels[j].Job = class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB;
			}
		}
		IsDirty = true;
		List.SetSelectedIndex(j);
		ListItem = UIOutpostManagement_ListItem(List.GetSelectedItem());	
		ListItem.SetJobName(class'XComGameState_LWOutpost'.static.GetJobName(CachedRebels[j].Job));		
	}	
}

simulated function InitJobNameCache()
{
    local X2StrategyElementTemplateManager StrategyTemplateMgr;
    local array<X2StrategyElementTemplate> Templates;
    local LWRebelJobTemplate JobTemplate;
    local int idx;

    StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
    Templates = StrategyTemplateMgr.GetAllTemplatesOfClass(class'LWRebelJobTemplate');

    for (idx = 0; idx < Templates.Length; ++idx)
    {
        JobTemplate = LWRebelJobTemplate(Templates[idx]);
        CachedJobNames.AddItem(JobTemplate.DataName);
    }
}

simulated function SetOutpost(StateObjectReference Ref)
{
    OutpostRef = Ref;
}

simulated function RefreshData()
{
    //SortData();
    UpdateLiaison();
    UpdateList();
	if( ShowRadioTowerUpgradeButton() )
		RadioTowerUpgradeButton.Show();
	else
		RadioTowerUpgradeButton.Hide();
}

simulated function GetData()
{
    local int i;
    local XComGameStateHistory History;
    local XComGameState_LWOutpost Outpost;

	History = `XCOMHISTORY;
    Outpost = XComGameState_LWOutpost(History.GetGameStateForObjectID(OutpostRef.ObjectID));
    CachedRebels.Length = 0;

    for (i = 0; i < Outpost.Rebels.Length; ++i)
    {
        CachedRebels.AddItem(Outpost.Rebels[i]);
    }

    CachedLiaison = Outpost.GetLiaison();
}

simulated function UpdateLiaison()
{
    local XComGameState_Unit Liaison;
    local Texture2D LiaisonPicture;
    local String Str;

    if (CachedLiaison.ObjectID == 0)
    {
        LiaisonName.SetText("");
        LiaisonImage.Hide();
    }
    else
    {
        Liaison = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(CachedLiaison.ObjectID));
        if (Liaison.IsSoldier())
        {
			Str = class'UIUtilities_Text'.static.InjectImage(Liaison.GetSoldierClassTemplate().IconImage, 40, 40, -20);
            Str $= class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.static.GetRankIcon(Liaison.GetRank(), Liaison.GetSoldierClassTemplateName()), 40, 40, -20);
            Str $= Liaison.GetName(eNameType_FullNick);
        }
        else
        {
            if (Liaison.IsEngineer())
                Str = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.EventQueue_Engineer, 32, 32, -8);
            else if (Liaison.IsScientist())
                Str = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.EventQueue_Science, 32, 32, -8);
            Str $= Liaison.GetFullName();
        }
        LiaisonName.SetText(Str);

        LiaisonPicture = class'UIUtilities_LW'.static.TakeUnitPicture(CachedLiaison, OnPictureTaken);
        if (LiaisonPicture != none)
        {
            LiaisonImage.LoadImage(PathName(LiaisonPicture));
            LiaisonImage.Show();
        }
    }
}

simulated function UpdateList()
{
    local UIOutpostManagement_ListItem ListItem;
    local XComGameState_Unit Unit;
    local XComGameStateHistory History;
    local int i;

    List.ClearItems();
    History = `XCOMHISTORY;

    for (i = 0; i < CachedRebels.Length; ++i)
    {
        Unit = XComGameState_Unit(History.GetGameStateForObjectID(CachedRebels[i].Unit.ObjectID));
        ListItem = UIOutpostManagement_ListItem(List.CreateItem(class'UIOutpostManagement_ListItem')).InitListItem();
        ListItem.SetMugShot(Unit.GetReference());
        if (ShowFaceless && CachedRebels[i].IsFaceless)
        {
            ListItem.SetRebelName("* " $ Unit.GetFullName());
        }
        else
        {
            ListItem.SetRebelName(Unit.GetFullName());
        }
        ListItem.SetLevel(CachedRebels[i].Level);
        ListItem.SetJobName(class'XComGameState_LWOutpost'.static.GetJobName(CachedRebels[i].Job));

        AddAbilities(Unit, ListItem);
    }
}

simulated function AddAbilities(XComGameState_Unit Unit, UIOutpostManagement_ListItem ListItem)
{
    local array<SoldierClassAbilityType> Abilities;
    local X2AbilityTemplate AbilityTemplate;
    local X2AbilityTemplateManager AbilityTemplateManager;
    local int i;

    Abilities = Unit.GetEarnedSoldierAbilities();
    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    for (i = 0; i < Abilities.Length; ++i)
    {
        AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(Abilities[i].AbilityName);
        if (!AbilityTemplate.bDontDisplayInAbilitySummary)
        {
            ListItem.AddAbility(AbilityTemplate);
        }
    }
}

simulated function RefreshNavHelp()
{
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	`HQPRES.m_kAvengerHUD.NavHelp.AddBackButton(OnCancel);
	class'LWHelpTemplate'.static.AddHelpButton_Nav('OutpostManagement_Help');
}

simulated function OnCancel()
{
    if (IsDirty)
        SaveOutpost();

    Movie.Stack.Pop(self);

	`XEVENTMGR.TriggerEvent('OnLeaveOutpost', self, self); // this is needed to advance objective LW_T2_M0_S1_ReviewOutpost
}

simulated function OnAccept()
{
    if (IsDirty)
        SaveOutpost();

	`XEVENTMGR.TriggerEvent('OnLeaveOutpost', self, self); // this is needed to advance objective LW_T2_M0_S1_ReviewOutpost
}

simulated function OnReceiveFocus()
{
    super.OnReceiveFocus();

    JobHeaderButton.SetWidth(HeaderPanel.Width * 0.3f);
    Show();
    RefreshNavHelp();
    RefreshData();
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
    Hide();
}

simulated function SetDirty()
{
    IsDirty = true;
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
			/*if (!bHandled)
			{
				bHandled = List.Navigator.OnUnrealCommand(cmd, arg);
			}*/
            // Keyboard nav between lists would go here

			break;
	}
	if (bHandled)
	{
		return true;
	}
	return super.OnUnrealCommand(cmd, arg);
}

function int CountNonHidingRebels()
{
    local int NumNonHidingRebels;
    local int i;

    // Count the number of non-hiding rebels, and if it's at the cap we can't change this one.
    for (i = 0; i < CachedRebels.Length; ++i)
    {
        if (CachedRebels[i].Job != class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB)
            ++NumNonHidingRebels;
    }

    return NumNonHidingRebels;
}

function OnJobChanged(UIOutpostManagement_ListItem ListItem, int Direction)
{
    local int RebelIdx;
    local int i, k;
	local XComGameState_LWOutpost Outpost;
	local bool GoodJobFound;

    RebelIdx = List.GetItemIndex(ListItem);
	Outpost = XComGameState_LWOutpost(`XCOMHISTORY.GetGameStateForObjectID(OutpostRef.ObjectID));
    i = CachedJobNames.Find(CachedRebels[RebelIdx].Job);

	GoodJobFound = false;
	while (!GoodJobFound)
	{
		GoodJobFound = true;
	    i += Direction;
	    if (i >= CachedJobNames.Length)
			i = 0;
		else if (i < 0)
			i = CachedJobNames.Length - 1;
		if (CachedJobNames[i] != class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB)
		{
			for (k = 0; k < Outpost.ProhibitedJobs.length; k++)
			{
				if (Outpost.ProhibitedJobs[k].DaysLeft > 0 && CachedJobNames[i] == OutPost.ProhibitedJobs[k].Job)
				{
					GoodJobFound = false;
				}
			}
		}
	}

    // Special logic needed if this rebel is hiding - it's possible the outpost is already at max
    // and we shouldn't be able to set them to a real job. If they aren't hiding then they can always
    // be adjusted.
	if (CachedRebels[RebelIdx].Job == class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB)
	{
        if (CountNonHidingRebels() >= Outpost.MaxRebels)
        {
            // Too many rebels on the job. Return without changing anything.
		    `SOUNDMGR.PlaySoundEvent("Play_MenuClickNegative");
            return;
        }
	}
   
    CachedRebels[RebelIdx].Job = CachedJobNames[i];
	IsDirty = true;
		 // Tell the list item to refresh itself.
	ListItem.SetJobName(class'XComGameState_LWOutpost'.static.GetJobName(CachedRebels[RebelIdx].Job));
}


function SaveOutpost()
{
    local XComGameState_LWOutpost Outpost;
    local XComGameStateHistory History;
    local XComGameState NewGameState;
    local int I;

    History = `XCOMHISTORY;
    Outpost = XComGameState_LWOutpost(History.GetGameStateForObjectID(OutpostRef.ObjectID));
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Saving Outpost Changes");
    Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
	
    for (I = 0; I < CachedRebels.Length; ++I)
    {
        Outpost.SetRebelJob(CachedRebels[I].Unit, CachedRebels[I].Job);
    }
    Outpost.UpdateJobs(NewGameState);

    // This should be redundant because liaison changes are saved immediately.
    SaveLiaison();

	NewGameState.AddStateObject(Outpost);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
    `HQPRES.m_kAvengerHUD.UpdateResources();
}

// Debug: Show or hide faceless
function ToggleShowFaceless()
{
    if (ShowFaceless)
    {
        ShowFaceless = false;
    }
    else
    {
        ShowFaceless = true;
    }

    RefreshData();
}

simulated function OnLiaisonClicked(UIButton theButton)
{
    local TDialogueBoxData DialogData;
    local XComGameState_LWOutpost Outpost;

    Outpost = XComGameState_LWOutpost(`XCOMHISTORY.GetGameStateForObjectID(OutpostRef.ObjectID));

    if (!Outpost.CanLiaisonBeMoved())
    {
        DialogData.eType = eDialog_Normal;
        DialogData.strTitle = m_strCannotChangeLiaisonTitle;
        DialogData.strText = m_strCannotChangeLiaison;
        DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
        Movie.Pres.UIRaiseDialog(DialogData);
        return;
    }

    if (CachedLiaison.ObjectID != 0)
    {
        // Clear the existing liaison
        CachedLiaison.ObjectID = 0;
        SetDirty();
        UpdateLiaison();
        SaveLiaison();
    }
    else
    {
        //`HQPRES.UIPersonnel(eUIPersonnel_All, OnPersonnelSelected);
        LiaisonScreen = Spawn( class'UIPersonnel_Liaison', self );
		LiaisonScreen.m_eListType = eUIPersonnel_All;
		LiaisonScreen.onSelectedDelegate = OnPersonnelSelected;
		LiaisonScreen.m_bRemoveWhenUnitSelected = true;
        Movie.Stack.Push(LiaisonScreen);
    }
}

simulated function OnPersonnelSelected(StateObjectReference SelectedUnitRef)
{
    CachedLiaison = SelectedUnitRef;
    UpdateLiaison();
    SaveLiaison();
    SetDirty();
}

// We need to update the outpost liaison state immediately in order to display the unit
// status correctly. E.g. if you have a liaison set (and saved) and you enter the screen and
// clear the liaison then click it again to choose a new one, we need to show the unit that was
// previously the liaison as available.
simulated function SaveLiaison()
{
    local XComGameState_LWOutpost Outpost;
    local XComGameStateHistory History;
    local XComGameState NewGameState;
    local XComGameState_Unit Unit;
    local XComGameState_HeadquartersXCom XComHQ;
    local StateObjectReference OldLiaison;

    History = `XCOMHISTORY;
    Outpost = XComGameState_LWOutpost(History.GetGameStateForObjectID(OutpostRef.ObjectID));

    // Check for a new liaison
    OldLiaison = Outpost.GetLiaison();
    if (OldLiaison.ObjectID != CachedLiaison.ObjectID)
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Saving Outpost Liaison Changes");

        // Set up the new liaison in the outpost (does not require a new outpost state: it only affects the staff slot)
        Outpost.SetLiaison(CachedLiaison, NewGameState);

        // For soldiers we need to set the on-mission status.
        // Clear the "on mission" status from the old one and add it to the new.
        if (OldLiaison.ObjectID != 0)
        {
            Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', OldLiaison.ObjectID));
            Unit.SetStatus(eStatus_Active);
        }
        
        if (CachedLiaison.ObjectID != 0)
        {
            Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', CachedLiaison.ObjectID));
            class'LWDLCHelpers'.static.SetOnMissionStatus(Unit, NewGameState);
        }

        // Tell XComHQ that we have a potential staffing change to update any sci/eng jobs.
        XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
        `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
        XComHQ.HandlePowerOrStaffingChange();
    }
}

simulated function OnPictureTaken(StateObjectReference UnitRef)
{
    local Texture2D LiaisonPicture;
	
    LiaisonPicture = class'UIUtilities_LW'.static.FinishUnitPicture(UnitRef);
    if (LiaisonPicture != none)
    {
        LiaisonImage.LoadImage(PathName(LiaisonPicture));
        LiaisonImage.Show();
    }
}

defaultproperties
{
    bConsumeMouseEvents = true;
	InputState    = eInputState_Consume;

    // Main panel positioning. Note X is not defined, it's set to centered
    // based on the movie width and panel width.
    panelY = 150;
    panelW = 961;
    panelH = 724;
}

