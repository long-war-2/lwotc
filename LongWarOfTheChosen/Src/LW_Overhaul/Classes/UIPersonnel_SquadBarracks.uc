//---------------------------------------------------------------------------------------
//  FILE:    UIPersonnel_SquadBarracks.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Provides custom behavior for personnel selection screen squad selection
//--------------------------------------------------------------------------------------- 

class UIPersonnel_SquadBarracks extends UIPersonnel config(LW_Content);

//external config variables
var bool bHideSelect;
var bool bSelectSquad;

var StateObjectReference ExternalSelectedSquadRef;

//var UIList m_kList;  // this parent list is used specifically for the lower soldier list items
var UIBGBox SquadListBG; // a persistent background behind the list to avoid having it redraw when the list does
var UIList m_kSquadList; // this new list is used specifically for the upper squad list items

var UIPanel UpperContainer;  // container for upper section

//UI elements of upper section
var UIImage SquadImage;
var UIScrollingText SquadMissionsText;
var UITextContainer SquadBiography;
var UILargeButton SelectOrViewBtn;
var UIButton CreateSquadBtn, DeleteSquadBtn;
var UIButton RenameSquadBtn, EditBiographyButton, ViewUnassignedBtn;
var UIButton SquadImageSelectLeftButton, SquadImageSelectRightButton;

var int CurrentSquadSelection;
var bool bViewUnassignedSoldiers;
var array<StateObjectReference> CachedSquad;
var bool bRestoreCachedSquad;

var config int SQUAD_MAX_NAME_LENGTH;
var config int MAX_CHARACTERS_BIO;

var localized string strSquadBarrackTitle;
var localized string strUnassignedSoldierTitle;
var localized string strEdit, strSquad, strSelect, strRenameSquad, strDeleteSquad, strAddSquad, strViewUnassigned, strViewSquad, strEditBiography;
var localized string strDeleteSquadConfirm;
var localized string strDeleteSquadConfirmDesc;
var localized string strMissions;
var localized string strDefaultSquadBiography;

var config array<string> SquadImagePaths;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	// Init UI
	super(UIScreen).InitScreen(InitController, InitMovie, InitName);

	//shift the whole screen over to make room for the squad list
	SetPosition(340, 0);

	SquadListBG = Spawn(class'UIBGBox', self);
	SquadListBG.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	SquadListBG.InitBG('ListBG', -241, 123, 702, 863);

	m_kSquadList = Spawn(class'UIList', self);
	m_kSquadList.bIsNavigable = false;
	m_kSquadList.ItemPadding = 3;
	m_kSquadList.InitList(, SquadListBG.X + 11, SquadListBG.Y + 11, SquadListBG.width-47, SquadListBG.height-22, false /*not horizontal*/); //, true /*AddBG*/, class'UIUtilities_Controls'.const.MC_X2Background);
	m_kSquadList.bStickyHighlight = false;
	m_kSquadList.SetSelectedIndex(0);
	m_kSquadList.OnItemClicked = SquadListButtonCallback;

    // Redirect all mouse events for the background to the list. Ensures all mouse
    // wheel events get processed by the list instead of consumed by the background
    // when the cursor falls "between" list items.
    SquadListBG.ProcessMouseEvents(m_kSquadList.OnChildMouseEvent);

	DeleteSquadBtn = Spawn(class'UIButton', self);
	DeleteSquadBtn.SetResizeToText(false);
	DeleteSquadBtn.InitButton(, strDeleteSquad, OnDeleteClicked).SetPosition(SquadListBG.X+5, SquadListBG.Y - 28).SetWidth(190);

	CreateSquadBtn = Spawn(class'UIButton', self);
	CreateSquadBtn.SetResizeToText(false);
	CreateSquadBtn.InitButton(, strAddSquad, OnCreateSquadClicked).SetPosition(SquadListBG.X + SquadListBG.Width - 194, SquadListBG.Y - 28).SetWidth(190);

	m_kList = Spawn(class'UIList', self);
	m_kList.bIsNavigable = true;
	m_kList.InitList('listAnchor', 487, 316, m_iMaskWidth, m_iMaskHeight);
	m_kList.bStickyHighlight = false;

	UpperContainer = Spawn(class'UIPanel', self).InitPanel().SetPosition(492, 145).SetSize(994, 132);

	SquadImage = UIImage(Spawn(class'UIImage', UpperContainer).InitImage().SetSize(100, 100).SetPosition(8, 2));
	SquadImage.bProcessesMouseEvents = true;
	SquadImage.MC.FunctionVoid("processMouseEvents");
	SquadImage.OnClickedDelegate = OnSquadIconClicked;

	SquadImageSelectLeftButton = Spawn(class'UIButton', UpperContainer);
	SquadImageSelectLeftButton.LibID = 'X2DrawerButton';
	SquadImageSelectLeftButton.bAnimateOnInit = false;
	SquadImageSelectLeftButton.InitButton(,,OnImageScrollButtonClicked); 

	SquadImageSelectRightButton = Spawn(class'UIButton', UpperContainer);
	SquadImageSelectRightButton.LibID = 'X2DrawerButton';
	SquadImageSelectRightButton.bAnimateOnInit = false;
	SquadImageSelectRightButton.InitButton(,,OnImageScrollButtonClicked); 
	UpdateLeftRightButtonPositions();

	SquadMissionsText = Spawn(class'UIScrollingText', UpperContainer).InitScrollingText(, "Squad Name", 600,,,true);
	SquadMissionsText.SetPosition(11, 97);

	SquadBiography = Spawn(class'UITextContainer', UpperContainer);	
	SquadBiography.InitTextContainer( , "", 131, 5, 430, 121);
	SquadBiography.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText("Bravely bold Sir Robin rode forth from Camelot\nHe was not afraid to die, O brave Sir Robin\nHe was not at all afraid to be killed in nasty ways\nBrave, brave, brave, brave Sir Robin\nHe was not in the least bit scared to be mashed into a pulp\nOr to have his eyes gouged out and his elbows broken\nTo have his kneecaps split and his body burned away\nAnd his limbs all hacked and mangled, brave Sir Robin", eUIState_Normal));
	//SquadBiography.SetHeight(121);

	SelectOrViewBtn = Spawn(class'UILargeButton', UpperContainer);
	if(bSelectSquad)
		SelectOrViewBtn.InitLargeButton(, strSelect, strSquad, OnEditOrSelectClicked).SetPosition(566, 14);
	else
		SelectOrViewBtn.InitLargeButton(, strEdit, strSquad, OnEditOrSelectClicked).SetPosition(566, 14);

	RenameSquadBtn = Spawn(class'UIButton', UpperContainer);
	RenameSquadBtn.SetResizeToText(false);
	RenameSquadBtn.InitButton(, strRenameSquad, OnRenameClicked).SetPosition(772, 14).SetWidth(190);

	EditBiographyButton = Spawn(class'UIButton', UpperContainer);
	EditBiographyButton.SetResizeToText(false);
	EditBiographyButton.InitButton(, strEditBiography, OnEditBiographyClicked).SetPosition(772, 54).SetWidth(190);

	ViewUnassignedBtn = Spawn(class'UIButton', UpperContainer);
	ViewUnassignedBtn.SetResizeToText(false);
	ViewUnassignedBtn.InitButton(, strViewUnassigned, OnViewUnassignedClicked).SetPosition(772, 94).SetWidth(190);

	m_arrNeededTabs.AddItem(m_eListType);
	m_arrTabButtons[eUIPersonnel_Soldiers] = CreateTabButton('SoldierTab', m_strSoldierTab, SoldiersTab);
	m_arrTabButtons[eUIPersonnel_Soldiers].bIsNavigable = false;

	if(ExternalSelectedSquadRef.ObjectID < 0)
		CurrentSquadSelection = -1;
	else
		CurrentSquadSelection = SelectInitialSquad(ExternalSelectedSquadRef);

	CreateSortHeaders();
	
	RefreshAllData();

	EnableNavigation();
	Navigator.LoopSelection = true;
	Navigator.SelectedIndex = 0;
	Navigator.OnSelectedIndexChanged = SelectedHeaderChanged;
}

simulated function int SelectInitialSquad(StateObjectReference SquadRef)
{
	return `LWSQUADMGR.Squads.Find('ObjectID', SquadRef.ObjectID);
}

simulated function OnImageScrollButtonClicked(UIButton Button)
{
	local XComGameState NewGameState;
	local int CurrentIndex;
	local XComGameState_LWPersistentSquad Squad;
	
	Squad = GetCurrentSquad();

	//figure out what index the current image is
	CurrentIndex = SquadImagePaths.Find(Squad.GetSquadImagePath());

	if(CurrentIndex == -1)
		CurrentIndex = 0;

	// Determine which button was clicked
	if (Button ==SquadImageSelectLeftButton)
		CurrentIndex -= 1;
	else if (Button == SquadImageSelectRightButton)
		CurrentIndex += 1;

	if(CurrentIndex < 0)
	{
		CurrentIndex = SquadImagePaths.Length - 1;
	}
	else if (CurrentIndex >= SquadImagePaths.Length)
	{
		CurrentIndex = 0;
	}

	if(SquadImagePaths[CurrentIndex] == Squad.GetSquadImagePath())
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Change Squad ImagePath");
	Squad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', Squad.ObjectID));
	Squad.SquadImagePath = SquadImagePaths[CurrentIndex];
	NewGameState.AddStateObject(Squad);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	UpdateSquadHeader();
	UpdateSquadList();
}

simulated function UpdateLeftRightButtonPositions()
{
	SquadImageSelectLeftButton.SetPosition(-8, 71);
	SquadImageSelectLeftButton.MC.ChildFunctionString("bg.arrow", "gotoAndStop", "left");
	SquadImageSelectRightButton.SetPosition(108, 71);
	SquadImageSelectRightButton.MC.FunctionString("gotoAndStop", "right");
	SquadImageSelectRightButton.MC.ChildFunctionString("bg.arrow", "gotoAndStop", "left");
}

simulated function CreateSortHeaders()
{
	m_kSoldierSortHeader = Spawn(class'UIPanel', self);
	m_kSoldierSortHeader.bIsNavigable = false;
	m_kSoldierSortHeader.InitPanel('soldierSort', 'SoldierSortHeader');
	m_kSoldierSortheader.SetPosition(489, 276);
	m_kSoldierSortHeader.Hide();

	//keep these two so we can hide them
	m_kDeceasedSortHeader = Spawn(class'UIPanel', self);
	m_kDeceasedSortHeader.InitPanel('deceasedSort', 'DeceasedSortHeader');
	m_kDeceasedSortHeader.Hide();
	
	m_kPersonnelSortHeader = Spawn(class'UIPanel', self);
	m_kPersonnelSortHeader.InitPanel('personnelSort', 'PersonnelSortHeader');
	m_kPersonnelSortHeader.Hide();

	// Create Soldiers header
	Spawn(class'UIFlipSortButton', m_kSoldierSortHeader).InitFlipSortButton("rankButton", ePersonnelSoldierSortType_Rank, m_strButtonLabels[ePersonnelSoldierSortType_Rank]);
	Spawn(class'UIFlipSortButton', m_kSoldierSortHeader).InitFlipSortButton("nameButton", ePersonnelSoldierSortType_Name, m_strButtonLabels[ePersonnelSoldierSortType_Name]);
	Spawn(class'UIFlipSortButton', m_kSoldierSortHeader).InitFlipSortButton("classButton", ePersonnelSoldierSortType_Class, m_strButtonLabels[ePersonnelSoldierSortType_Class]);
	Spawn(class'UIFlipSortButton', m_kSoldierSortHeader).InitFlipSortButton("statusButton", ePersonnelSoldierSortType_Status, m_strButtonLabels[ePersonnelSoldierSortType_Status], m_strButtonValues[ePersonnelSoldierSortType_Status]);

	m_eSortType = ePersonnelSoldierSortType_Rank;
	m_eCurrentTab = eUIPersonnel_Soldiers;
	m_kList.OnItemClicked = OnSoldierSelected;
	m_kSoldierSortHeader.Show();

}

simulated function XComGameState_LWPersistentSquad GetCurrentSquad()
{
	local StateObjectReference SquadRef;
	local XComGameState_LWPersistentSquad SquadState;

	if(CurrentSquadSelection < 0)
		return none;

	SquadRef = UISquadListItem(m_kSquadList.GetItem(CurrentSquadSelection)).SquadRef;
	SquadState = XComGameState_LWPersistentSquad(`XCOMHISTORY.GetGameStateForObjectID(SquadRef.ObjectID));
	return SquadState;
}

simulated function OnReceiveFocus()
{
	//local Object ThisObj;
	local XComGameState UpdateState;
	local XComGameState_HeadquartersXCom XComHQ;

	//this is for handling receiving focus back from UISquadSelect
	//ThisObj = self;
	//`XEVENTMGR.UnRegisterFromEvent(ThisObj, 'PostSquadSelectInit');

	//restore previous squad to squad select, if there was one
	if(bRestoreCachedSquad)
	{
		UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Restore previous soldiers to XComHQ Squad");
		XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', `XCOMHQ.ObjectID));
		XComHQ.Squad = CachedSquad;
		UpdateState.AddStateObject(XComHQ);
		`GAMERULES.SubmitGameState(UpdateState);

		bRestoreCachedSquad = false;
		CachedSquad.Length = 0;
	}
	`LWTRACE("OnReceiveFocus: CurrentSquadSelect=" $ CurrentSquadSelection);
	RefreshAllData();

	super(UIScreen).OnReceiveFocus();
}

simulated function bool CanTransferSoldier(StateObjectReference UnitRef, optional XComGameState_LWPersistentSquad SquadState)
{
    local XComGameState_Unit Unit;
	local array<XComGameState_Unit> SquadSoldiers;
	local int NumSoldiers, MaxSize;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	//can't move soldiers that are on a mission (this does not include haven liaisons)
	if(class'LWDLCHelpers'.static.IsUnitOnMission(Unit) && !`LWOUTPOSTMGR.IsUnitAHavenLiaison(Unit.GetReference()))
		return false;

	if(SquadState == none)
		SquadState = GetCurrentSquad();

	if(SquadState != none)
	{
		//can't add soldiers to squads that are on a mission
		if(SquadState.bOnMission || SquadState.CurrentMission.ObjectID > 0)
			if(bViewUnassignedSoldiers)
				return false;

		//can't add to a max-size squad
		SquadSoldiers = SquadState.GetSoldiers();
		NumSoldiers = SquadSoldiers.Length;
		MaxSize = class'XComGameState_LWSquadManager'.default.MAX_SQUAD_SIZE;
		if(NumSoldiers >= MaxSize)
			if(bViewUnassignedSoldiers)
				return false;
	}

	return true;
}

//==============================================================================
//=================== COMPONENT UPDATING =======================================
//==============================================================================

//update everything
simulated function RefreshAllData()
{
	UpdateSquadList();
	RefreshData(); // this is just the soldier list inherited from UIPersonnel
	UpdateNavHelp();
	UpdateSquadHeader();
}

simulated function UpdateNavHelp()
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.ClearButtonHelp();
	NavHelp.AddBackButton(OnCancel);
		
	// Don't allow jumping to the geoscape from the armory in the tutorial or when coming from squad select
	//if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M7_WelcomeToGeoscape') != eObjectiveState_InProgress)
		NavHelp.AddGeoscapeButton();

	class'LWHelpTemplate'.static.AddHelpButton_Nav('Personnel_SquadBarracks_Help');
}

//squad header info above the individual soldier listings
simulated function UpdateSquadHeader()
{
	local XComGameState_LWPersistentSquad SquadState;
	local int i;
	local string HeaderString, MissionsString;
	local XGParamTag ParamTag;

	SquadState = GetCurrentSquad();

	//title
	if(CurrentSquadSelection == -1 || bViewUnassignedSoldiers || SquadState == none)
	{
		HeaderString = strUnassignedSoldierTitle;
	}
	else
	{
		ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		ParamTag.StrValue0 = SquadState.sSquadName;
		HeaderString = `XEXPAND.ExpandString(strSquadBarrackTitle);
	}
	SetScreenHeader(HeaderString);
	for( i = 0; i < m_arrTabButtons.length; i++ )
		m_arrTabButtons[i].Hide();

	if(CurrentSquadSelection == -1 || bViewUnassignedSoldiers || SquadState == none)
	{
		SquadImageSelectLeftButton.Hide();
		SquadImageSelectRightButton.Hide();
		SquadImage.Hide();
	}
	else
	{
		SquadImage.LoadImage(SquadState.GetSquadImagePath());
		SquadImageSelectLeftButton.Show();
		SquadImageSelectRightButton.Show();
		SquadImage.Show();
	}
	//buttons
	if(CurrentSquadSelection == -1 || SquadState == none)
	{
		SelectOrViewBtn.SetDisabled(true);
		RenameSquadBtn.Hide();
		DeleteSquadBtn.Hide();
		ViewUnassignedBtn.Hide();
		EditBiographyButton.Hide();
	}
	else
	{
		if (bSelectSquad && SquadState.bOnMission)
			SelectOrViewBtn.SetDisabled(true);
		else
			SelectOrViewBtn.SetDisabled(false);

		RenameSquadBtn.Show();
		if (SquadState.bOnMission || SquadState.CurrentMission.ObjectID > 0)
			DeleteSquadBtn.Hide();
		else
			DeleteSquadBtn.Show();
		ViewUnassignedBtn.Show();
		EditBiographyButton.Show();
	}
	if(bHideSelect)
		SelectOrViewBtn.Hide();

	if(bViewUnassignedSoldiers || SquadState == none)
	{
		SquadMissionsText.SetText("");
		SquadBiography.SetHTMLText("");
	}
	else
	{
		ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		ParamTag.IntValue0 = SquadState.iNumMissions;
		MissionsString = `XEXPAND.ExpandString(strMissions);
		SquadMissionsText.SetText(MissionsString);
		SquadBiography.SetHTMLText(SquadState.sSquadBiography);
	}
}

//squad list
simulated function UpdateSquadList()
{
	local XComGameState_LWSquadManager SquadMgr;
	local int SquadListLength, idx, idx2;
	local UISquadListItem SquadListItem;

	SquadMgr = `LWSQUADMGR;
	SquadListLength = SquadMgr.Squads.Length;
	for(idx = 0; idx < SquadListLength; idx ++)
	{
		SquadListItem = UISquadListItem(m_kSquadList.GetItem(idx));
		if(SquadListItem == none)
		{
			SquadListItem = UISquadListItem(m_kSquadList.CreateItem(class'UISquadListItem'));
			SquadListItem.InitSquadListItem(SquadMgr.Squads[idx]);
		}
		SquadListItem.SquadRef = SquadMgr.Squads[idx];
		SquadListItem.Update();
		SquadListItem.Show();
	}
	// remove any additional list items
	if(m_kSquadList.GetItemCount() >= idx)
	{
		for(idx2 = idx; idx2 < m_kSquadList.GetItemCount(); idx2++)
		{
			SquadListItem = UISquadListItem(m_kSquadList.GetItem(idx));
			SquadListItem.Remove();
		}
	}

	m_kSquadList.SetSelectedIndex(CurrentSquadSelection);
}

simulated function UpdateData()
{
	local XComGameState_LWSquadManager SquadMgr;

	m_arrSoldiers.Length = 0;
	SquadMgr = `LWSQUADMGR;

	if(CurrentSquadSelection < 0 || bViewUnassignedSoldiers)
		m_arrSoldiers = SquadMgr.GetUnassignedSoldiers();		
	else
		m_arrSoldiers = SquadMgr.GetSquad(CurrentSquadSelection).GetSoldierRefs(true);
}

//used by UIPersonnel.RefreshData to determine what the soldier list should be
//simulated function array<StateObjectReference> GetCurrentData()
//{
	//local XComGameState_LWSquadManager SquadMgr;
	//local array<StateObjectReference> ReturnList;
//
	//SquadMgr = `LWSQUADMGR;
//
	//if(CurrentSquadSelection < 0 || bViewUnassignedSoldiers)
		//ReturnList = SquadMgr.GetUnassignedSoldiers();		
	//else
		//ReturnList = SquadMgr.GetSquad(CurrentSquadSelection).GetSoldierRefs(true);
//
	//return ReturnList;
//}

//updates the soldier list -- overriding to allow disabling of soldier items in some cases
simulated function UpdateList()
{
	local int i;
	local UIPersonnel_ListItem UnitItem;
	local XComGameState_LWPersistentSquad SquadState;
	
	super.UpdateList();

	SquadState = GetCurrentSquad();

	// loop through every soldier and update whether soldier can be transferred or not
	for(i = 0; i < m_kList.itemCount; ++i)
	{
		UnitItem = UIPersonnel_ListItem(m_kList.GetItem(i));

		// If we are looking at a squad and that squad is on-mission, mark units that are
		// not on the mission by showing them with lower alpha.
		if(SquadState != none && 
			SquadState.IsDeployedOnMission() &&
			!SquadState.IsSoldierOnMission(UnitItem.UnitRef))
		{
			UnitItem.SetAlpha(30);
		}

		if(!CanTransferSoldier(UnitItem.UnitRef))
			UnitItem.SetDisabled(true);
	}
}

//==============================================================================
//=================== CALLBACK HANDLERS ========================================
//==============================================================================

//callback from clicking a squad list item
simulated function SquadListButtonCallback( UIList kList, int index )
{
	`LWTRACE("SquadListButtonCallback: index=" @ index);
	if(CurrentSquadSelection == index)
		return;

	CurrentSquadSelection = index;
	`LWTRACE("SquadListButtonCallback: CurrentSquadSelect=" $ CurrentSquadSelection);
	UpdateSquadHeader();
	RefreshData(); // this is just the soldier list inherited from UIPersonnel
}

// callback from selecting a soldier
simulated function OnSoldierSelected( UIList kList, int index )
{
	local XComGameState NewGameState;
	local XComGameState_LWPersistentSquad SquadState;
	local UIPersonnel_ListItem UnitItem;
	local XComGameState_Unit UnitState;

	`LWTRACE("OnSoldierSelected" @ index);

	//selecting soldiers does nothing if there's no current squad selected
	if(CurrentSquadSelection < 0) 
		return;

	if( UIPersonnel_ListItem(kList.GetItem(index)).IsDisabled )
		return;

	SquadState = GetCurrentSquad();
	UnitItem = UIPersonnel_ListItem(m_kList.GetItem(index));
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitItem.UnitRef.ObjectID));	

	if(!CanTransferSoldier(UnitState.GetReference(), SquadState))
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Transferring Soldier");
	SquadState = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', SquadState.ObjectID));
	NewGameState.AddStateObject(SquadState);

	if(bViewUnassignedSoldiers)
		SquadState.AddSoldier(UnitState.GetReference());
	else
		SquadState.RemoveSoldier(UnitState.GetReference());

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	RefreshAllData();
}

// callback from clicking the rename squad button
function OnRenameClicked(UIButton Button)
{
	local TInputDialogData kData;

	`LWTRACE("OnRenameClicked: CurrentSquadSelect=" $ CurrentSquadSelection);

	kData.strTitle = strRenameSquad;
	kData.iMaxChars = SQUAD_MAX_NAME_LENGTH;
	kData.strInputBoxText = GetCurrentSquad().sSquadName;
	kData.fnCallback = OnNameInputBoxClosed;

	`HQPRES.UIInputDialog(kData);
}

// TEXT INPUT BOX (PC)
function OnNameInputBoxClosed(string text)
{
	local XComGameState NewGameState;
	local XComGameState_LWPersistentSquad Squad;

	`LWTRACE("SquadBarracks: text=" $ text $ ", CurrentSquadSelect=" $ CurrentSquadSelection);
	if(text != "" && CurrentSquadSelection >= 0)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Renaming Squad");
		Squad = GetCurrentSquad();
		Squad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', Squad.ObjectID));
		Squad.sSquadName = text;
		Squad.bTemporary = false;
		NewGameState.AddStateObject(Squad);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	UpdateSquadList();
	UpdateSquadHeader();
}

// callback from clicking the edit biography button
function OnEditBiographyClicked(UIButton Button)
{
	local TInputDialogData kData;

	if(CurrentSquadSelection >= 0)
	{
		kData.strTitle = strEditBiography;
		kData.iMaxChars = MAX_CHARACTERS_BIO;
		kData.strInputBoxText = GetCurrentSquad().sSquadBiography;
		kData.fnCallback = OnBackgroundInputBoxClosed;
		kData.DialogType = eDialogType_MultiLine;

		Movie.Pres.UIInputDialog(kData);
	}
}

function OnBackgroundInputBoxClosed(string text)
{
	local XComGameState NewGameState;
	local XComGameState_LWPersistentSquad Squad;

	if(text != "" && CurrentSquadSelection >= 0)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Edit Squad Biography");
		Squad = GetCurrentSquad();
		Squad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', Squad.ObjectID));
		Squad.sSquadBiography = text;
		NewGameState.AddStateObject(Squad);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	UpdateSquadHeader();
}

// callback from clicking the delete squad button
function OnDeleteClicked(UIButton Button)
{
	local TDialogueBoxData DialogData;

	if(m_kSquadList.SelectedIndex < 0) 
		return;

	DialogData.eType = eDialog_Normal;
	DialogData.strTitle = default.strDeleteSquadConfirm;
	DialogData.strText = default.strDeleteSquadConfirmDesc;
	DialogData.fnCallback = OnDeleteSquadDialogCallback;
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	DialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
	Movie.Pres.UIRaiseDialog(DialogData);
}

simulated function OnDeleteSquadDialogCallback(Name eAction)
{
	local StateObjectReference SquadRef;

	if(eAction == 'eUIAction_Accept')
	{
		SquadRef = UISquadListItem(m_kSquadList.GetItem(CurrentSquadSelection)).SquadRef;
		`LWSQUADMGR.RemoveSquadByRef(SquadRef);
		CurrentSquadSelection = -1;
		RefreshAllData();
	}
}

// callback from clicking the view unassigned button
function OnViewUnassignedClicked(UIButton Button)
{
	if(bViewUnassignedSoldiers)
	{
		ViewUnassignedBtn.SetText(strViewUnassigned);
		bViewUnassignedSoldiers = false;
	}
	else
	{
		ViewUnassignedBtn.SetText(strViewSquad);
		bViewUnassignedSoldiers = true;
	}
	RefreshData();
	UpdateSquadHeader();
}

// callback from clicking the view unassigned button
function OnCreateSquadClicked(UIButton Button)
{
	`LWSQUADMGR.CreateEmptySquad();
	CurrentSquadSelection = m_kSquadList.GetItemCount();
	RefreshAllData();
}

//callback from edit viewer
function OnEditOrSelectClicked(UIButton Button)
{
	local XComGameState UpdateState;
	local XComGameState_LWPersistentSquad SquadState;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_LWSquadManager UpdatedSquadMgr;
	local UISquadSelect SquadSelect;
	local UISquadContainer SquadContainer;

	`LWTRACE("OnEditOrSelectClicked: CurrentSquadSelect=" $ CurrentSquadSelection);

	SquadState = GetCurrentSquad();
	if(bSelectSquad)
	{
		if(SquadState != none && !SquadState.bOnMission)
		{
			UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Assign persistent squad as current mission squad");
			SquadMgr = `LWSQUADMGR;
			UpdatedSquadMgr = XComGameState_LWSquadManager(UpdateState.CreateStateObject(SquadMgr.Class, SquadMgr.ObjectID));
			UpdateState.AddStateObject(UpdatedSquadMgr);
			UpdatedSquadMgr.LaunchingMissionSquad = SquadState.GetReference();

			//logic in common code in SquadState, accounting for possible special characters on DLC Story Missions
			SquadState.SetSquadCrew(UpdateState, false /* bOnMissionSoldiers */ , false /* bForDisplayOnly */);

			`GAMERULES.SubmitGameState(UpdateState);

			SquadSelect = SquadMgr.GetSquadSelect();
			if (SquadSelect != none)
			{
				SquadContainer = UISquadContainer(SquadSelect.GetChildByName('SquadSelect_SquadContainer_LW', false));
			}
			if (SquadContainer != none)
			{
				SquadContainer.SquadButton.SquadRef = SquadState.GetReference();
				SquadContainer.SquadButton.Update(); // this updates the active squad in the button
				SquadContainer.SquadButton.OnLoseFocus();
			}
		}
		CloseScreen();
	}
	else
	{
		//logic in common code in SquadState, accounting for possible special characters on DLC Story Missions
		SquadState.SetSquadCrew(, SquadState.bTemporary /* bOnMissionSoldiers */ ,true /* bForDisplayOnly */);

		CachedSquad = `XCOMHQ.Squad;
		bRestoreCachedSquad = true;

		//Invoke the UI
		`HQPRES.UISquadSelect();
	}
}

// LWOTC: Integrated from robojumper's Better Squad Icon Selector mod
simulated function OnSquadIconClicked(UIImage Image)
{
	local LW2_UISquadIconSelectionScreen TempScreen;
	local XComPresentationLayerBase Pres;
	
	// `PRES is tactical (strategy is `HQPRES, generic is `PRESBASE)
	Pres = `HQPRES;

	if (Pres != none && Pres.ScreenStack.IsNotInStack(class'LW2_UISquadIconSelectionScreen'))
	{
		TempScreen = Pres.Spawn(class'LW2_UISquadIconSelectionScreen', Pres);
		//TempScreen.InitSquadImageSelector(XComPlayerController(Pres.Owner), Pres.Get2DMovie(), '', UIPersonnel_SquadBarracks(Image.ParentPanel.Screen));
		TempScreen.BelowScreen = UIPersonnel_SquadBarracks(Image.ParentPanel.Screen);
		TempScreen.BelowScreen.bHideOnLoseFocus = false;
		Pres.ScreenStack.Push(TempScreen, Pres.Get2DMovie());
	}
}

simulated function CloseScreen()
{
	local UISquadSelect SquadSelect;
	local UISquadContainer SquadContainer;

	SquadSelect = `LWSQUADMGR.GetSquadSelect();
	if (SquadSelect != none)
	{
		SquadContainer = UISquadContainer(SquadSelect.GetChildByName('SquadSelect_SquadContainer_LW', false));
	}
	if (SquadContainer != none)
	{
		SquadContainer.m_k_SquadDropDown.RefreshData(); // this updates the list of squads in case any were added or removed
	}

	super.CloseScreen();
}

//event handler to set the current squad as the correct squad in squad select
//function EventListenerReturn OnPostSquadSelectInit(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
//{
	//local UISquadSelect SquadSelect;
//
	//SquadSelect = UISquadSelect(EventSource);
	//if(SquadSelect == none) return ELR_NoInterrupt;
//
	//GetCurrentSquad().SetSquadCrew(false);
	//`LOG("OnPostSquadSelectInit: CurrentSquadSelect=" $ CurrentSquadSelection);
//
	//return ELR_NoInterrupt;
//}


defaultproperties
{
	MCName          = "theScreen";
	Package = "/ package/gfxSoldierList/SoldierList";

	m_eListType = eUIPersonnel_Soldiers;
	//m_eSortType = ePersonnelSoldierSortType_Name;

	m_iMaskWidth = 961;
	m_iMaskHeight = 658;

}