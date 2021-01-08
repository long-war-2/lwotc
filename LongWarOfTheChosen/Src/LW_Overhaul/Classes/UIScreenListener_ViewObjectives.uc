//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ViewObjectives.uc
//  AUTHOR:  KDM
//  PURPOSE: The objective screen modified such that objective descriptions are scrollable.
//---------------------------------------------------------------------------------------

class UIScreenListener_ViewObjectives extends UIScreenListener config(LW_Overhaul);

var UIViewObjectives ObjectiveScreen;
var UIPanel MouseEventPanel;

var localized string ScrollObjectiveDescriptionStr;

event OnInit(UIScreen Screen)
{
	ObjectiveScreen = UIViewObjectives(Screen);
	if (ObjectiveScreen.List != none)
	{
		// KDM : When list selection changes a new objective is being looked at; when this happens,
		// we will be resetting the objective description scroll.
		ObjectiveScreen.List.OnSelectionChanged = OnObjectiveSelectionChanged;
	}
	if (ObjectiveScreen.ItemCard != none)
	{
		// KDM : Enable the scrollbar for the objective description; within Flash, it is an
		// object of type 'VerticalAutoScrollText'.
		ObjectiveScreen.ItemCard.MC.ChildFunctionVoid("description", "EnableScrollbar");
		// KDM : By default, the objective description can only be scrolled through 'direct'
		// scrollbar manipulation. In order to allow the user to scroll with the mouse wheel,
		// in the general area, a hidden UIPanel is placed over top of the objective's ItemCard.
		// Originally, I tried to set up the ItemCard directly; however, this would suddenly
		// kill 'direct' scrollbar manipulation. 
		if (MouseEventPanel == none && ObjectiveScreen.ListContainer != none)
		{
			MouseEventPanel = ObjectiveScreen.Spawn(class'UIPanel', ObjectiveScreen.ListContainer);
			MouseEventPanel.bAnimateOnInit = false;
			MouseEventPanel.bIsNavigable = false;
			MouseEventPanel.bShouldPlayGenericUIAudioEvents = false;
			// KDM : We want the UIPanel to be a 'generic pixel' panel; this makes sure that
			// mouse event processing can occur.
			MouseEventPanel.InitPanel(, class'UIUtilities_Controls'.const.MC_GenericPixel);
			// KDM : Place the hidden UIPanel over the ItemCard.
			MouseEventPanel.SetPosition(613, 0);
			MouseEventPanel.SetSize(535, 805);
			// KDM : 'Soft' hide the UIPanel so that it can still process mouse events.
			MouseEventPanel.SetAlpha(0);
			MouseEventPanel.ProcessMouseEvents(OnItemCardMouseEvent);
		}
	}
	
	`HQPRES.ScreenStack.SubscribeToOnInputForScreen(Screen, OnViewObjectivesCommand);
	AddNavHelp();
}

simulated function OnObjectiveSelectionChanged(UIList List, int Index)
{
	if (ObjectiveScreen != none)
	{
		// KDM : Previously List.OnSelectionChanged was hooked up to ObjectiveScreen.SelectedItemChanged; 
		//therefore, when the selection does change, make sure to call ObjectiveScreen.SelectedItemChanged.
		ObjectiveScreen.SelectedItemChanged(List, Index);

		if (ObjectiveScreen.ItemCard != none)
		{
			ObjectiveScreen.ItemCard.MC.ChildFunctionVoid("description", "ResetScroll");
			// KDM : Within Flash, VerticalAutoScrollText.ResetScroll calls VerticalAutoScrollText.refreshScrollbar;
			// this sets the scrollbar visibility, but doesn't touch the scrollbar's slider location. Consequently,
			// I need to call ScrollbarControl.SetThumbAtPercent in order to reset the slider location.
			ObjectiveScreen.ItemCard.MC.ChildFunctionNum("description.scrollbar", "SetThumbAtPercent", 0);
		}
	}
}

simulated function OnItemCardMouseEvent(UIPanel Control, int cmd)
{
	switch(cmd)
	{
	case class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_DOWN:
		if (ObjectiveScreen.ItemCard != none)
		{
			ObjectiveScreen.ItemCard.MC.ChildFunctionBool("description.scrollbar", "ClickArrow", false);
		}
		break;
	case class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_UP:
		if (ObjectiveScreen.ItemCard != none)
		{
			ObjectiveScreen.ItemCard.MC.ChildFunctionBool("description.scrollbar", "ClickArrow", true);
		}
		break;
	}
}

event OnReceiveFocus(UIScreen Screen)
{
	AddNavHelp();
}

event OnRemoved(UIScreen Screen)
{
	if (MouseEventPanel != none)
	{
		MouseEventPanel.IgnoreMouseEvents();
		MouseEventPanel.Remove();
		MouseEventPanel = none;
	}

	if (ObjectiveScreen != none)
	{
		if (ObjectiveScreen.List != none)
		{
			ObjectiveScreen.List.OnSelectionChanged = none;
		}
		ObjectiveScreen = none;
	}

	`HQPRES.ScreenStack.UnsubscribeFromOnInputForScreen(Screen, OnViewObjectivesCommand);
	RemoveNavHelp();
}

simulated protected function bool OnViewObjectivesCommand(UIScreen Screen, int cmd, int arg)
{
	local bool bHandled;

	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	switch (cmd)
	{
	// KDM : Right stick up scrolls the objective description up.
	case class'UIUtilities_Input'.const.FXS_VIRTUAL_RSTICK_UP:
		OnItemCardMouseEvent(none, class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_DOWN);
		break;

	// KDM : Right stick down scrolls the objective description down.
	case class'UIUtilities_Input'.const.FXS_VIRTUAL_RSTICK_DOWN:
		OnItemCardMouseEvent(none, class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_UP);
		break;

	default:
		bHandled = false;
		break;
	}

	return bHandled;
}

simulated function AddNavHelp()
{
	local UINavigationHelp NavHelp;
	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	if (`ISCONTROLLERACTIVE)
	{
		NavHelp.AddLeftHelp(ScrollObjectiveDescriptionStr, class'UIUtilities_Input'.const.ICON_RSTICK);
	}
}

simulated function RemoveNavHelp()
{
	local UINavigationHelp NavHelp;
	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	if (`ISCONTROLLERACTIVE)
	{
		NavHelp.ClearButtonHelp();
	}
}

defaultproperties
{
	ScreenClass=UIViewObjectives
}
