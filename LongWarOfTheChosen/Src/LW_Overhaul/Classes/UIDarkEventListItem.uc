//---------------------------------------------------------------------------------------
//  FILE:    UIDarkEventListItem.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: An Individual List Item used for building larger lists of DarkEvents
//--------------------------------------------------------------------------------------- 
class UIDarkEventListItem extends UIPanel;

var UIList List; // the list that owns this item
var StateObjectReference DarkEventRef; // reference to a XComGameState_DarkEvent

// BG is created as this panel
var UIButton	ButtonBG;
var name		ButtonBGLibID;

var UIBGBox		ButtonFill; // used to handle the button being filled with solid red

var UIScrollingText DarkEventNameText;
var UIScrollingText DarkEventInfoText;

var string DarkEventName, DarkEventInfo;

simulated function UIDarkEventListItem InitDarkEventListItem(StateObjectReference initDarkEventRef)
{
	DarkEventRef = initDarkEventRef;

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
	ButtonBG.SetColor(class'UIUtilities_Colors'.const.BAD_HTML_COLOR);
	ButtonBG.SetSize(width, height);

	//Spawn a filler box to prevent button from being solid red
	ButtonFill = Spawn(class'UIBGBox', self);
	ButtonFill.bAnimateOnInit = false;
	ButtonFill.InitBG('DarkEventFill', 0, 0, width, height, eUIState_Bad);

	DarkEventNameText = Spawn(class'UIScrollingText', self);
	DarkEventNameText.bAnimateOnInit = false;
	DarkEventNameText.InitScrollingText('DarkEventNameText', "", 250, 12, 2, true);
	//DarkEventNameText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText("Sample Dark Event", eUIState_Bad));

	DarkEventInfoText = Spawn(class'UIScrollingText', self);	
	DarkEventInfoText.bAnimateOnInit = false;
	DarkEventInfoText.InitScrollingText('DarkEventInfoText', "", 500, 280, 5);
	//DarkEventInfoText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText("Sample Dark Event information text. The Dark Event does ...", eUIState_Bad));

	return self;
}

simulated function Update()
{
	local XComGameState_DarkEvent DarkEventState;

	DarkEventState = XComGameState_DarkEvent(`XCOMHISTORY.GetGameStateForObjectID(DarkEventRef.ObjectID));

	DarkEventName = DarkEventState.GetDisplayName();
	if (DarkEventName == "")
		DarkEventName = "ERROR: No loc for " $ string(DarkEventState.GetMyTemplateName());
	DarkEventNameText.SetSubTitle(class'UIUtilities_Text'.static.GetColoredText(DarkEventName, (bIsFocused ? -1 : eUIState_Bad)));
	
	DarkEventInfo = DarkEventState.GetSummary();
	DarkEventInfoText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(DarkEventInfo,  (bIsFocused ? -1 : eUIState_Bad)));

	ButtonFill.SetBGColor((bIsFocused ? "red_highlight" : "red"));
}

simulated function OnReceiveFocus()
{
	ButtonFill.SetBGColor("red_highlight");
	DarkEventNameText.SetSubTitle(class'UIUtilities_Text'.static.GetColoredText(DarkEventName, -1 ));
	DarkEventInfoText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(DarkEventInfo,  -1 ));

	super.OnReceiveFocus();
}

simulated function OnLoseFocus()
{
	ButtonFill.SetBGColor("red");
	DarkEventNameText.SetSubTitle(class'UIUtilities_Text'.static.GetColoredText(DarkEventName, eUIState_Bad));
	DarkEventInfoText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(DarkEventInfo, eUIState_Bad));

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
	height = 36;
	bProcessesMouseEvents = true;
	//bIsNavigable = true;

	bAnimateOnInit = false;
}