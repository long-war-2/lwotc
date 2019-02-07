//----------------------------------------------------------------------------
//  FILE:    UISquadSelect_OfficerIcon.uc
//  AUTHOR:  amineri / Pavonis Interactive
//  PURPOSE: Custom icon that can pass through focus and clicks to parent list item
//----------------------------------------------------------------------------

class UISquadSelect_OfficerIcon extends UIIcon;

simulated function OnReceiveFocus()
{
	if(!bIsFocused)
	{
		super.OnReceiveFocus();
		GetParent(class'UISquadSelect_ListItem', true).OnReceiveFocus();
	}
}

simulated function OnLoseFocus()
{
	if(bIsFocused)
	{
		super.OnLoseFocus();
		GetParent(class'UISquadSelect_ListItem', true).OnLoseFocus();
	}
}

simulated function OnMouseEvent(int Cmd, array<string> Args)
{
	//Super.OnMouseEvent(Cmd, Args);  // can't use super here because the parent's parent is in a list, so it gets captured there

	switch(cmd)
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
		Args[Args.Length - 2] = "dismissButtonMC";
		GetParent(class'UISquadSelect_ListItem', true).OnMouseEvent(Cmd, Args);
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER:
		OnReceiveFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_RELEASE_OUTSIDE:
		OnLoseFocus();
		break;
	}

	if( OnMouseEventDelegate != none )
		OnMouseEventDelegate(self, cmd);
}

defaultproperties
{
	bShouldPlayGenericUIAudioEvents = false;
	bIsNavigable = true;
	bCascadeFocus = false;
}