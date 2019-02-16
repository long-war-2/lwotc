//---------------------------------------------------------------------------------------
//  FILE:    UIButtonIconPC.uc
//  AUTHOR:  amineri / Pavonis Interactive
//	PURPOSE: Extension of regular button for use with FlashControl XComButtonIconPC
//			 Normally accessible only through NavHelp
//---------------------------------------------------------------------------------------

class UIButtonIconPC extends UIPanel;

var bool            IsDisabled;
var bool            IsSelected;
var EButtonIconPC	IconType;

// mouse callbacks
delegate OnClickedDelegate(UIButtonIconPC Button);
delegate OnDoubleClickedDelegate(UIButtonIconPC Button);

simulated function UIButtonIconPC InitButton(optional name InitName, optional delegate<OnClickedDelegate> InitOnClicked, optional string TooltipText)
{
	InitPanel(InitName);
	OnClickedDelegate = InitOnClicked;

	SetIcon(IconType);
	if (TooltipText != "")
		SetTooltipText(TooltipText);

	return self;
}

simulated function UIButtonIconPC SetSelected(bool selected)
{
	if(IsSelected != selected)
	{
		IsSelected = selected;
		mc.FunctionVoid(IsSelected ? "select" : "deselect");
	}
	return self;
}

simulated function UIButtonIconPC SetIcon(EButtonIconPC newIconType)
{
	//local string s;
	//local int i;
	
	IconType = newIconType;
	//i = IconType;
	//s = string(i);

	mc.BeginFunctionOp("setIcon");
	mc.QueueNumber(int(IconType));
	mc.EndOp(); 

	return self;
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	local bool bHandled;

	// send a clicked callback
	if( cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP )
	   bHandled = Click();
	else if( cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP_DELAYED && `XENGINE.m_SteamControllerManager.IsSteamControllerActive() )
		bHandled = Click();
	else if( cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP )
		bHandled = DoubleClick();

	if(!bHandled)
		super.OnMouseEvent(cmd, args);
}

simulated function bool Click()
{
	if( OnClickedDelegate != none && !IsDisabled && bIsVisible )
	{
		OnClickedDelegate(self);
		return true;
	}
	return false;
}

simulated function bool DoubleClick()
{
	if( OnDoubleClickedDelegate != none && !IsDisabled && bIsVisible )
	{
		OnDoubleClickedDelegate(self);
		return true;
	}
	return false;
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	bHandled = true;

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_A:
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
		Click();
		break;
	default:
		bHandled = false;
		break;
	}
	return bHandled || super.OnUnrealCommand(cmd, arg);
}

//simulated function OnCommand(string cmd, string arg)
//{
	//local array<string> sizeData;
	//if( cmd == "RealizeSize" )
	//{
		//sizeData = SplitString(arg, ",");
		//Width = float(sizeData[0]);
		//Height = float(sizeData[1]);
		//SizeRealized = true;
//
		//if( OnSizeRealized != none )
			//OnSizeRealized();
	//}
//}

defaultproperties
{
	LibID = "XComButtonIconPC";
	IconType = eButtonIconPC_Details;
	IsDisabled = false;
	IsSelected = false;
	bProcessesMouseEvents = true;
	bIsNavigable = true;
	bAnimateOnInit = false;
}
