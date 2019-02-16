//---------------------------------------------------------------------------------------
//  FILE:    UISquadListItem_Small.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: An individual item that can be contained with a list, or used as a separate button, small version for dropdowns
//--------------------------------------------------------------------------------------- 
class UISquadListItem_Small extends UIPanel config(LW_Overhaul);

// possible list that owns this item
var UIList OwningList;

// possible dropdown menu that owns this item
var UISquad_DropDown OwningMenu;

var UISquadContainer OwningContainer;
var UISquad_DropDown OwnedMenu;

var bool bSizeRealized;

// BG is created as this panel
//var UIBGBox BG;
var UIButton	ButtonBG;
var name ButtonBGLibID;

var UIImage SquadImage;
var UIScrollingTextField SquadNameText;
var UIScrollingTextField SquadStatusText;

var string SquadName;

var StateObjectReference SquadRef; // reference to a XComGameState_LWPersistentSquad

var bool bShowDropDown;

delegate OnClickedDelegate(UIButton Button);
delegate OnDimensionsRealized();

simulated function UISquadListItem_Small InitSquadListItem_Small(optional StateObjectReference initSquadRef, optional delegate<OnClickedDelegate> InitOnClicked, optional UISquad_DropDown Menu)
{
	SquadRef = initSquadRef;

	InitPanel(); 

	OwningList = UIList(GetParent(class'UIList')); // list items can be owned by a container
	if(OwningList != none)
	{
		SetWidth(OwningList.width);
	}
	OwningMenu = Menu;


	//Spawn in the init, so that set up functions have access to its data. 
	ButtonBG = Spawn(class'UIButton', self);
	ButtonBG.bAnimateOnInit = false;
	ButtonBG.bIsNavigable = false;
	ButtonBG.InitButton(ButtonBGLibID,, InitOnClicked);
	ButtonBG.SetSize(width, height);

	SquadImage = Spawn(class'UIImage', self);
	SquadImage.bAnimateOnInit = false;
	SquadImage.InitImage().SetSize(36, 36).SetPosition(6, 4);

	SquadNameText = Spawn(class'UIScrollingTextField', self);
	SquadNameText.bAnimateOnInit = false;
	SquadNameText.InitScrollingText(, "Squad Name", 286, 44, 6, true);

	//SquadStatusText = Spawn(class'UIScrollingTextField', self);
	//SquadStatusText.bAnimateOnInit = false;
	//SquadStatusText.InitScrollingText(, "STATUS", 130, 200, 10, false);

	Update(); 

	return self;
}

simulated function Update()
{
	local XComGameState_LWPersistentSquad SquadState;

	bSizeRealized = false;

	SquadState = XComGameState_LWPersistentSquad(`XCOMHISTORY.GetGameStateForObjectID(SquadRef.ObjectID));

	if (SquadState == none)
		return;

	SquadImage.LoadImage(SquadState.GetSquadImagePath());

	SquadName = SquadState.sSquadName;
	SquadNameText.SetSubTitle(SquadName, bIsFocused, true);
	
	Show();

	//if(SquadState.IsDeployedOnMission())
		//SquadStatusText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(class'UISquadListItem'.default.sSquadOnMission, eUIState_Warning,,"RIGHT"));
	//else
		//SquadStatusText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(class'UISquadListItem'.default.sSquadAvailable, eUIState_Good,,"RIGHT"));
}

simulated function OnCommand(string cmd, string arg)
{
	local array<string> sizeData;

	super.OnCommand(cmd, arg);

	if( cmd == "RealizeDimensions" )
	{
		sizeData = SplitString(arg, ",");
		X = float(sizeData[0]);
		Y = float(sizeData[1]);
		Width = float(sizeData[2]);
		Height = float(sizeData[3]);

		bSizeRealized = true;

		if (OnDimensionsRealized != none)
		{
			OnDimensionsRealized();
		}
	}
}

simulated function OnReceiveFocus()
{
	SquadNameText.SetSubTitle(SquadName, true, true);
	ButtonBG.MC.FunctionVoid("mouseIn");
	//SquadStatusText.ShowShadow();

	super.OnReceiveFocus();
}

simulated function OnLoseFocus()
{
	SquadNameText.SetSubTitle(SquadName, false, true);
	ButtonBG.MC.FunctionVoid("mouseOut");
	//SquadStatusText.HideShadow();

	super.OnLoseFocus();
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	if (OwningContainer != none)
	{
		super.OnMouseEvent(cmd,  args);
		switch( cmd )
		{
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER:
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER:
			if (bShowDropDown)
			{
				OwningContainer.ShowDropDown();
			}
			break;
		default:
			break;
		}
	}
	else
	{
		switch( cmd )
		{
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
			`SOUNDMGR.PlaySoundEvent("Generic_Mouse_Click");
			if( OwningList != none && OwningList.HasItem(self) )
			{
				OwningList.SetSelectedIndex(OwningList.GetItemIndex(self));
				if(OwningList.OnItemClicked != none)
					OwningList.OnItemClicked(OwningList, OwningList.SelectedIndex);
			}
			break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP_DELAYED:
			if( `XENGINE.m_SteamControllerManager.IsSteamControllerActive() )
			{
				if( OwningList != none && OwningList.HasItem(self) )
				{
					OwningList.SetSelectedIndex(OwningList.GetItemIndex(self));
					if(OwningList.OnItemClicked != none)
						OwningList.OnItemClicked(OwningList, OwningList.SelectedIndex);
				}
			}
			break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP:
			`SOUNDMGR.PlaySoundEvent("Generic_Mouse_Click");
			if( OwningList != none && OwningList.HasItem(self) )
			{
				OwningList.SetSelectedIndex(OwningList.GetItemIndex(self));
				if(OwningList.OnItemDoubleClicked != none)
					OwningList.OnItemDoubleClicked(OwningList, OwningList.SelectedIndex);
			}
			break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER:
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER:
			`SOUNDMGR.PlaySoundEvent("Play_Mouseover");
			if (OwningMenu != none)
				OwningMenu.ClearDelayTimer();
			OnReceiveFocus();
			break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_RELEASE_OUTSIDE:
			if (OwningMenu != none)
				OwningMenu.CloseMenu();
			break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT:
			if (OwningMenu != none)
				OwningMenu.TryToStartDelayTimer();
			OnLoseFocus();
			break;
		case class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_DOWN:
			if( OwningList != none && OwningList.Scrollbar != none )
				OwningList.Scrollbar.OnMouseScrollEvent(1);
			break;
		case class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_UP:
			if( OwningList != none && OwningList.Scrollbar != none )
				OwningList.Scrollbar.OnMouseScrollEvent(-1);
			break;
		}
		if( OnMouseEventDelegate != none )
			OnMouseEventDelegate(self, cmd);
	}
}

defaultproperties
{
	ButtonBGLibID = "theButton"; // in flash 
	width = 340;
	height = 43;
	bProcessesMouseEvents = true;
	//bIsNavigable = true;

	bAnimateOnInit = false;
}