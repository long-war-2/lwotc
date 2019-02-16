//---------------------------------------------------------------------------------------
//  FILE:    UISquad_DropDown.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: A simple dropdown list for selecting squads -- based on UIPersonnel_DropDown
//--------------------------------------------------------------------------------------- 
class UISquad_DropDown extends UIPanel;

//----------------------------------------------------------------------------
// MEMBERS

// UI
var int m_iMaskWidth;
var int m_iMaskHeight;

var UIList m_kList;

// Gameplay
var XComGameState GameState; // setting this allows us to display data that has not yet been submitted to the history 
var array<StateObjectReference> m_arrSquads;
//var StateObjectReference SquadRef;

// Delegates
var bool m_bRemoveWhenSquadSelected;
var public delegate<OnSquadElementSelected> onSelectedDelegate;
var public delegate<OnDropDownSizeRealized> OnDropDownSizeRealizedDelegate;

delegate OnSquadElementSelected(StateObjectReference selectedSquad);
delegate OnButtonClickedDelegate(UIButton ButtonControl);
delegate OnDropDownSizeRealized(float CtlWidth, float CtlHeight);

//----------------------------------------------------------------------------
// FUNCTIONS

simulated function InitDropDown(optional delegate<OnDropDownSizeRealized> OnDropDownSizeRealizedDel)
{	
	// Init UI
	super.InitPanel();

	m_kList = Spawn(class'UIList', self);
	m_kList.bIsNavigable = true;
	m_kList.InitList('listAnchor', , 5, m_iMaskWidth, m_iMaskHeight);
	m_kList.bStickyHighlight = false;
	m_kList.OnItemClicked = OnSquadSelected;
	
	OnDropDownSizeRealizedDelegate = OnDropDownSizeRealizedDel;
	
	RefreshData();
}

simulated function ClearDelayTimer()
{
	ClearTimer('CloseMenu');
}

simulated function TryToStartDelayTimer()
{	
	local string TargetPath; 
	local int iFoundIndex; 

	TargetPath = Movie.GetPathUnderMouse();
	iFoundIndex = InStr(TargetPath, MCName);

	if( iFoundIndex == -1 ) //We're moused completely off this movie clip, which includes all children.
	{
		SetTimer(1.0, false, 'CloseMenu');
	}
}

simulated function CloseMenu()
{
	Hide();
}

simulated function Show()
{
	RefreshData();
	super.Show();
}

simulated function RefreshData()
{
	UpdateData();
	UpdateList();
}

simulated function UpdateData()
{
	local int i;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_LWPersistentSquad Squad; 

	SquadMgr = `LWSQUADMGR;

	// Destroy old data
	m_arrSquads.Length = 0;
		
	for(i = 0; i < SquadMgr.Squads.Length; i++)
	{
		Squad = SquadMgr.GetSquad(i);

		if (!Squad.bOnMission && Squad.CurrentMission.ObjectID == 0)
		{
			m_arrSquads.AddItem(Squad.GetReference());
		}
	}
}

simulated function UpdateList()
{
	m_kList.ClearItems();
	PopulateListInstantly();
	m_kList.Navigator.SelectFirstAvailable();
}

simulated function UpdateItemWidths()
{
	local int Idx;
	local float MaxWidth, MaxHeight;

	for ( Idx = 0; Idx < m_kList.itemCount; ++Idx )
	{
		if ( !UISquadListItem_Small(m_kList.GetItem(Idx)).bSizeRealized )
		{
			return;
		}

		MaxWidth = Max(MaxWidth, m_kList.GetItem(Idx).Width);
		MaxHeight += m_kList.GetItem(Idx).Height;
	}

	Width = MaxWidth;
	Height = MaxHeight;

	for ( Idx = 0; Idx < m_kList.itemCount; ++Idx )
	{
		m_kList.GetItem(Idx).SetWidth(Width);
	}

	if (OnDropDownSizeRealizedDelegate != none)
	{
		OnDropDownSizeRealizedDelegate(Width, Height);
	}

	m_kList.SetWidth(MaxWidth);
}

// calling this function will add items instantly
simulated function PopulateListInstantly()
{
	local UISquadListItem_Small kItem;
	local int idx;

	for (idx = 0; idx < m_arrSquads.Length ; idx++)
	{
		kItem = Spawn(class'UISquadListItem_Small', m_kList.itemContainer);
		kItem.OnDimensionsRealized = UpdateItemWidths;
		kItem.InitSquadListItem_Small(m_arrSquads[idx],, self);
	}
}

//------------------------------------------------------

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			OnAccept();
			return true;

		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			return true;
	}

	if (m_kList.Navigator.OnUnrealCommand(cmd, arg))
		return true;

	return super.OnUnrealCommand(cmd, arg);
}

//------------------------------------------------------

simulated function OnSquadSelected( UIList kList, int index )
{
	if( onSelectedDelegate != none )
	{
		onSelectedDelegate(m_arrSquads[index]);
		Hide();
	}
}

//------------------------------------------------------

simulated function OnAccept()
{
	OnSquadSelected(m_kList, m_kList.selectedIndex  < 0 ? 0 : m_kList.selectedIndex);
}

simulated function OnCancel()
{
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Stop_AvengerAmbience");
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_AvengerNoRoom");
	Hide();
}

//==============================================================================

defaultproperties
{
	LibID = "EmptyControl"; // the dropdown itself is just an empty container

	bIsNavigable = false;
	m_iMaskWidth = 350;
	m_iMaskHeight = 794;
}
