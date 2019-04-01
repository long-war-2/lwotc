//---------------------------------------------------------------------------------------
//  FILE:    UISquadListItem.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: An individual item within the squad list
//--------------------------------------------------------------------------------------- 
class UISquadListItem extends UIPanel config(LW_Overhaul);

// the list that owns this item
var UIList List;

// BG is created as this panel
//var UIBGBox BG;
var UIButton	ButtonBG;
var name ButtonBGLibID;

var UIBGBox		ButtonFill; // used to handle click-and-drag weirdness with UIButton

var UIImage SquadImage;
var UIScrollingTextField SquadNameText;
var UIScrollingTextField SquadCovertnessText;
var UIScrollingTextField SquadStatusText;
var UIList ClassIconList;

var string SquadName;

var StateObjectReference SquadRef; // reference to a XComGameState_LWPersistentSquad

var localized string sSquadOnMission, sSquadAvailable, sCovertness;

simulated function UISquadListItem InitSquadListItem(StateObjectReference initSquadRef)
{
	SquadRef = initSquadRef;

	InitPanel(); 

	List = UIList(GetParent(class'UIList')); // list items must be owned by UIList.ItemContainer
	if(List == none)
	{
		ScriptTrace();
		`warn("UI list items must be owned by UIList.ItemContainer");
	}
	SetWidth(List.width);

	//Spawn in the init, so that set up functions have access to its data. 
	ButtonBG = Spawn(class'UIButton', self);
	ButtonBG.bAnimateOnInit = false;
	ButtonBG.bIsNavigable = false;
	ButtonBG.InitButton(ButtonBGLibID);
	ButtonBG.SetSize(width, height);

	//Spawn a filler box to prevent button from being messed up on click/drag
	ButtonFill = Spawn(class'UIBGBox', self);
	ButtonFill.bAnimateOnInit = false;
	ButtonFill.InitBG('DarkEventFill', 0, 0, width, height, eUIState_Normal);

	SquadImage = Spawn(class'UIImage', self);
	SquadImage.bAnimateOnInit = false;
	SquadImage.InitImage().SetSize(60, 60).SetPosition(12, 10);

	SquadNameText = Spawn(class'UIScrollingTextField', self);
	SquadNameText.bAnimateOnInit = false;
	SquadNameText.InitScrollingText(, "Squad Name", 400, 80, 1, true);

	SquadStatusText = Spawn(class'UIScrollingTextField', self);
	SquadStatusText.bAnimateOnInit = false;
	SquadStatusText.InitScrollingText(, "STATUS", 130, 510, 10, false);

	SquadCovertnessText = Spawn(class'UIScrollingTextField', self);
	SquadCovertnessText.bAnimateOnInit = false;
	SquadCovertnessText.InitScrollingText(, "", 130, 510, 44, false);

	ClassIconList = Spawn(class'UIList', self);
	ClassIconList.bAnimateOnInit = false;
	ClassIconList.ItemPadding = -3;
	ClassIconList.InitList(, 80, 38, 460, 40, true /*horizontal*/, false /*AddBG*/);

	return self;
}

simulated function Update()
{
	local XComGameState_LWPersistentSquad SquadState;
	local array<XComGameState_Unit> arrUnitStates;
	local XComGameState_Unit UnitState;
	//local XGParamTag ParamTag;
	//local string CovertnessString;
	local int idx, StartIndex;
	local UISquadClassItem ClassItem;
	//local UIImage ClassIcon;

	SquadState = XComGameState_LWPersistentSquad(`XCOMHISTORY.GetGameStateForObjectID(SquadRef.ObjectID));

	SquadImage.LoadImage(SquadState.GetSquadImagePath());

	SquadName = SquadState.sSquadName;
	SquadNameText.SetTitle(SquadName, bIsFocused, true);
	
	if(SquadState.IsDeployedOnMission())
		SquadStatusText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(sSquadOnMission, eUIState_Warning,,"RIGHT"));
	else
		SquadStatusText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(sSquadAvailable, eUIState_Good,,"RIGHT"));

	// JL removed 10/27 because this is often bugged and not providing useful information	

	//ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	//ParamTag.IntValue0 = Max(0, SquadState.GetSquadCovertness(SquadState.SquadSoldiers));

	//CovertnessString = `XEXPAND.ExpandString(sCovertness);
	//SquadCovertnessText.SetHTMLText(class'UIUtilities_Text'.static.AlignRight(CovertnessString));

	arrUnitStates = SquadState.GetSoldiers();
	for(idx = 0; idx < arrUnitStates.Length; idx ++)  // add icons for permanent soldiers
	{
		UnitState = arrUnitStates[idx];
		ClassItem = UISquadClassItem(ClassIconList.GetItem(idx));
		if(ClassItem == none)
		{
			ClassItem = UISquadClassItem(ClassIconList.CreateItem(class'UISquadClassItem'));
			ClassItem.bAnimateOnInit = false;
			ClassItem.InitSquadClassItem();
			ClassItem.SetSize(38, 38);
		}
		ClassItem.LoadClassImage(UnitState.GetSoldierClassTemplate().IconImage);
		ClassItem.SetAlpha(GetClassIconAlphaStatus(UnitState, SquadState)); // add dimming effect for unavailable soldiers
		ClassItem.ShowTempIcon(false);
		ClassItem.Show();
		//TODO : set up tooltips with soldier name on each class icon
	}
	StartIndex = idx;
	arrUnitStates = SquadState.GetTempSoldiers();
	for(idx = StartIndex; idx < StartIndex + arrUnitStates.Length; idx ++)  // add icons for temporary soldiers
	{
		UnitState = arrUnitStates[idx-StartIndex];
		ClassItem = UISquadClassItem(ClassIconList.GetItem(idx));
		if(ClassItem == none)
		{
			ClassItem = UISquadClassItem(ClassIconList.CreateItem(class'UISquadClassItem'));
			ClassItem.bAnimateOnInit = false;
			ClassItem.InitSquadClassItem();
			ClassItem.SetSize(38, 38);
		}
		ClassItem.LoadClassImage(UnitState.GetSoldierClassTemplate().IconImage);
		ClassItem.SetAlpha(GetClassIconAlphaStatus(UnitState, SquadState)); // add dimming effect for unavailable soldiers
		ClassItem.ShowTempIcon(true);
		ClassItem.Show();
		//TODO : set up tooltips with soldier name on each class icon
	}
	StartIndex = idx;
	// hide any additional icons
	if(ClassIconList.GetItemCount() > StartIndex)
	{
		for(idx = StartIndex; idx < ClassIconList.GetItemCount(); idx++)
		{
			ClassItem = UISquadClassItem(ClassIconList.GetItem(idx));
			ClassItem.Hide();
		}
	}
	if (ClassIconList.GetItemCount() > 13)
	{
		ClassIconList.ProcessMouseEvents(ClassIconList.OnChildMouseEvent);
	}
	if (bIsFocused)
		ButtonFill.Hide(); //SetBGColor("cyan_highlight");
	else
	{
		ButtonFill.SetBGColor("cyan");
		ButtonFill.Show();
	}
}

simulated function int GetClassIconAlphaStatus(XComGameState_Unit UnitState, XComGameState_LWPersistentSquad SquadState)
{
	// Dim the icon if the squad is on-mission and this soldier isn't on the mission, regardless of their actual status.
	if (SquadState.IsDeployedOnMission() && !SquadState.IsSoldierOnMission(UnitState.GetReference()))
		return 30;

	// Otherwise set the status by unit status.
	switch(UnitState.GetStatus()) 
	{
		case eStatus_Active:
			if (SquadState.bOnMission && SquadState.IsSoldierTemporary(UnitState.GetReference()))
				return 50;
			else
				return 100;
		case eStatus_CovertAction:
			// Ensure Liaisons dimmed when viewing a squad so they appear unavailable
			return `LWOUTPOSTMGR.IsUnitAHavenLiaison(UnitState.GetReference()) ? 50 : 100;
		case eStatus_PsiTraining:
		case eStatus_PsiTesting:
		case eStatus_Training:
		case eStatus_Healing:
		case eStatus_Dead:
		default:
			return 50;
	}
}

simulated function OnReceiveFocus()
{
	//ButtonFill.SetBGColor("cyan_highlight");
	ButtonFill.Hide();

	SquadNameText.SetTitle(SquadName, true, true);
	SquadStatusText.ShowShadow();
	SquadCovertnessText.ShowShadow();

	super.OnReceiveFocus();
}

simulated function OnLoseFocus()
{
	ButtonFill.SetBGColor("cyan");
	ButtonFill.Show();

	SquadNameText.SetTitle(SquadName, false, true);
	SquadStatusText.HideShadow();
	SquadCovertnessText.HideShadow();

	super.OnLoseFocus();
}

//override the UIPanel OnMouseEvent to enable sticky highlighting of selected squad
simulated function OnMouseEvent(int cmd, array<string> args)
{
	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
		`SOUNDMGR.PlaySoundEvent("Generic_Mouse_Click");
		if( List.HasItem(self) )
		{
			List.SetSelectedIndex(List.GetItemIndex(self));
			if(List.OnItemClicked != none)
				List.OnItemClicked(List, List.SelectedIndex);
		}
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP_DELAYED:
		if( `XENGINE.m_SteamControllerManager.IsSteamControllerActive() )
		{
			if( List.HasItem(self) )
			{
				List.SetSelectedIndex(List.GetItemIndex(self));
				if(List.OnItemClicked != none)
					List.OnItemClicked(List, List.SelectedIndex);
			}
		}
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP:
		`SOUNDMGR.PlaySoundEvent("Generic_Mouse_Click");
		if( List.HasItem(self) )
		{
			List.SetSelectedIndex(List.GetItemIndex(self));
			if(List.OnItemDoubleClicked != none)
				List.OnItemDoubleClicked(List, List.SelectedIndex);
		}
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER:
		`SOUNDMGR.PlaySoundEvent("Play_Mouseover");
		//OnReceiveFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_RELEASE_OUTSIDE:
		//OnLoseFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_DOWN:
		if( List.Scrollbar != none )
			List.Scrollbar.OnMouseScrollEvent(1);
		break;
	case class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_UP:
		if( List.Scrollbar != none )
			List.Scrollbar.OnMouseScrollEvent(-1);
		break;
	}

	if( OnMouseEventDelegate != none )
		OnMouseEventDelegate(self, cmd);
}

defaultproperties
{
	ButtonBGLibID = "theButton"; // in flash 
	//width = 667;
	height = 81;
	bProcessesMouseEvents = true;
	//bIsNavigable = true;

	bAnimateOnInit = false;
}