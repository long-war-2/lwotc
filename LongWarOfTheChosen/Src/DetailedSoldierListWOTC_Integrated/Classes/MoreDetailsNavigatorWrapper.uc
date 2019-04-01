class MoreDetailsNavigatorWrapper extends UINavigator;

var UINavigator ChildNavigator;

simulated function bool OnUnrealCommand( int Cmd, int Arg )
{
	local bool bHandled;
	local MoreDetailsManager MMMgr;

	MMMgr = MoreDetailsManager(OwnerControl.GetChildByName('DSL_MoreDetailsMgr', false));

	if (MMMgr != none)
	{
		switch( Cmd )
		{
			case class'UIUtilities_Input'.const.FXS_BUTTON_RTRIGGER:
			case class'UIUtilities_Input'.const.FXS_KEY_TAB:
				MMMgr.OnToggleDetails();
				bHandled = true;
				break;
			default:
				bHandled = false;
				break;
		}
	}
	else
	{
		bHandled = false;
	}

	if (bHandled)
		return true;

	return ChildNavigator.OnUnrealCommand(Cmd, Arg);
}

public function AddControl(UIPanel Control)
{
	ChildNavigator.AddControl(Control);
}

public function RemoveControl(UIPanel Control)
{
	ChildNavigator.RemoveControl(Control);
}

simulated function AddNavTarget( UIPanel Control, int Cmd, int Arg )
{
	ChildNavigator.AddNavTarget(Control, Cmd, Arg);
}

simulated function Clear()
{
	ChildNavigator.Clear();
}

simulated function ClearAllNavigationTargets()
{
	ChildNavigator.NavigationTargets.Length = 0;
}

public function ClearSelectionHierarchy()
{
	ChildNavigator.ClearSelectionHierarchy();
}

public function bool SelectFirstAvailableIfNoCurrentSelection()
{
	return ChildNavigator.SelectFirstAvailableIfNoCurrentSelection();
}


public function UIPanel GetSelected()
{
	return ChildNavigator.GetSelected();
}

public function UIPanel GetControl(int Index)
{
	return ChildNavigator.GetControl(Index);
}

public function int GetIndexOf(UIPanel Control)
{
	return ChildNavigator.GetIndexOf(Control);
}

simulated function bool IsValid(int Index)
{
	return ChildNavigator.IsValid(Index);
}

public function bool Next(optional bool ReturningFromChild = false, optional bool bNewFocus = false, optional bool IsRepeat = false)
{
	return ChildNavigator.Next(ReturningFromChild, bNewFocus, IsRepeat);
}

public function bool Prev(optional bool ReturningFromChild = false, optional bool bNewFocus = false, optional bool IsRepeat = false)
{
	return ChildNavigator.Prev(ReturningFromChild, bNewFocus, IsRepeat);
}

simulated function OnLoseFocus()
{
	ChildNavigator.OnLoseFocus();
}

simulated function OnReceiveFocus()
{
	ChildNavigator.OnReceiveFocus();
}

simulated function RemoveNavTargetByCmd(int Cmd)
{
	ChildNavigator.RemoveNavTargetByCmd(Cmd);
}

simulated function RemoveNavTargetByControl(UIPanel Control)
{
	ChildNavigator.RemoveNavTargetByControl(Control);
}

public function bool SelectFirstAvailable()
{
	return ChildNavigator.SelectFirstAvailable();
}

simulated function bool SendToNavigationTargets( int Cmd, int Arg )
{
	return ChildNavigator.SendToNavigationTargets(Cmd, Arg);
}

public function SetSelected( optional UIPanel SelectedControl = none )
{
	ChildNavigator.SetSelected(SelectedControl);
}