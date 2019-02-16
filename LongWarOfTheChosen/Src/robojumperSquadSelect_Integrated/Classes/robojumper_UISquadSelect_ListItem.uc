// This is a container for all the things: list with equipment, soldier panel and extra panels
class robojumper_UISquadSelect_ListItem extends UISquadSelect_ListItem config(robojumperSquadSelect);


// The item is just a gigantic list of all slots (+placeholders) above and the soldier panel below
var UIList TheList;

var UIPanel DynamicPanel;
var UIText SelectSoldierText;

var array<robojumper_UISquadSelect_EquipItem> EquipmentItems;
var array<robojumper_UISquadSelect_UtilityItem> SmallItems;
var robojumper_UISquadSelect_SoldierPanel TheSoldierPanel;

var robojumper_UISquadSelect_SkillsPanel TheSkillsPanel;
var robojumper_UISquadSelect_StatsPanel TheStatsPanel;

var array<UIPanel> ExtraInfoBoxes;
var int InfoBoxHeight;

var bool bSkipRefocus;


struct SlotPriorityOverride
{
	var EInventorySlot Slot;
	var int Priority;
};

var config array<SlotPriorityOverride> PriorityOverrides;

const MAX_SMALLITEMS_IN_ROW = 4;

simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	super(UIPanel).InitPanel(InitName, InitLibID);

	SetDirty(true, false);

	return self;
}

function UIPanel CreateDynamicPanel()
{
	DynamicPanel = Spawn(class'UIPanel', self);
	DynamicPanel.bAnimateOnInit = false;
	DynamicPanel.InitPanel('', 'X2Button');
	DynamicPanel.ProcessMouseEvents(OnSelectSoldierMouseEvent);
	DynamicPanel.SetSize(width, 240);
	DynamicPanel.SetY(-240);
	SelectSoldierText = Spawn(class'UIText', DynamicPanel);
	SelectSoldierText.bAnimateOnInit = false;
	SelectSoldierText.InitText();
	SelectSoldierText.SetPosition(10, 100);
	SelectSoldierText.SetWidth(Width - 20);
	
	return DynamicPanel;
}

function UIList CreateList()
{
	TheList = Spawn(class'UIList', self).InitList('', 0, 0, width, 400);
	TheList.bSelectFirstAvailable = true;
	TheList.ShrinkToFit();
	// this is neccessary to properly send navigation commands to list childs
	// don't call "SetSelected" because it onvokes focus changes
	Navigator.SelectedIndex = 0;
	return TheList;
}

// for now,
simulated function UpdateData(optional int Index = -1, optional bool bDisableEdit, optional bool bDisableDismiss, optional bool bDisableLoadout, optional array<EInventorySlot> CannotEditSlotsList)
{
	local XComGameState_Unit Unit;

	if (bDisabled)
		return;

	SlotIndex = Index != -1 ? Index : SlotIndex;

	bDisabledEdit = bDisableEdit;
	bDisabledDismiss = bDisableDismiss;
	bDisabledLoadout = bDisableLoadout;
	CannotEditSlots = CannotEditSlotsList;

	Unit = GetUnit();
	if (Unit == none)
	{
		SetEmpty();
		SpawnExtraInfoBoxes();
		RealizeHeight();
		if (bIsFocused)
		{
			Navigator.SetSelected(DynamicPanel);
		}
		else
		{
			// force this without considering focus -- we might not be focused but need to be ready in case we get focus
			Navigator.SelectedIndex = 0;
		}
	}
	else
	{
		SetFilled();
		TheList.ClearItems();
		if (TheSkillsPanel != none) TheSkillsPanel.Remove();
		if (TheStatsPanel != none) TheStatsPanel.Remove();
		
		TheSkillsPanel = none;
		TheStatsPanel = none;
		TheSoldierPanel = none;
		EquipmentItems.Length = 0;
		SmallItems.Length = 0;

		// Assuming that civilian units don't have an inventory
		if (!Unit.IsCivilian())
		{
			if (class'robojumper_SquadSelectConfig'.static.IsCHHLMinVersionInstalled(1, 9))
			{
				SetupItemsHighlander();
			}
			else
			{
				SetupItemsRegular();
			}
		}

		TheSoldierPanel = robojumper_UISquadSelect_SoldierPanel(Spawn(class'robojumper_UISquadSelect_SoldierPanel', TheList.itemContainer).InitPanel());
		TheSoldierPanel.UpdateData(bDisabledEdit, bDisabledDismiss);
		SpawnExtraInfoBoxes();
		RealizeHeight();

		if (class'robojumper_SquadSelectConfig'.static.ShouldShowStats())
		{
			TheStatsPanel = robojumper_UISquadSelect_StatsPanel(Spawn(class'robojumper_UISquadSelect_StatsPanel', self).InitPanel());
			TheStatsPanel.UpdateData();
		}

		// Only Soldiers have skills
		if (class'robojumper_SquadSelectConfig'.static.ShowMeTheSkills() && Unit.IsSoldier())
		{
			TheSkillsPanel = robojumper_UISquadSelect_SkillsPanel(Spawn(class'robojumper_UISquadSelect_SkillsPanel', self).InitPanel());
			TheSkillsPanel.UpdateData();
		}
		
		if (bIsFocused)
		{
			TheList.SetSelectedIndex(0);
		}
		else
		{
			// force this without considering focus -- we might not be focused but need to be ready in case we get focus
			TheList.SelectedIndex = 0;
			TheList.Navigator.SelectedIndex = 0;
		}
	}
	SetDirty(false, false);
}

// Sets up the items using the Highlander's slot functionality
simulated function SetupItemsHighlander()
{
	local array<EInventorySlot> Slots;
	local array<int> Priorities;
	
	local CHUIItemSlotEnumerator En;
	local int i, NumSmall;
	local array<int> SmallItemLayout;
	local int iCurrInRow, iCurrRow;
	local StateObjectReference EmptyRef;

	for (i = 0; i < PriorityOverrides.Length; i++)
	{
		Slots.AddItem(PriorityOverrides[i].Slot);
		Priorities.AddItem(PriorityOverrides[i].Priority);
	}
	En = class'CHUIItemSlotEnumerator'.static.CreateEnumeratorZipPriorities(GetUnit(), , Slots, Priorities, true /* UseUnlockHints */);

	NumSmall = 0;
	while (En.HasNext())
	{
		En.Next();
		if (!class'CHItemSlot'.static.SlotIsSmall(En.Slot))
		{
				EquipmentItems.AddItem(Spawn(class'robojumper_UISquadSelect_EquipItem', TheList.itemContainer)
						.InitEquipItem(En.Slot,
						En.ItemState != none ? En.ItemState.GetReference() : EmptyRef,
						En.IsLocked || CannotEditSlots.Find(En.Slot) != INDEX_NONE));
		}
		else
		{
			NumSmall += 1;
			SmallItems.AddItem(Spawn(class'robojumper_UISquadSelect_UtilityItem', TheList.itemContainer)
				.InitUtilityItem(En.Slot,
						En.ItemState != none ? En.ItemState.GetReference() : EmptyRef,
						En.IsLocked || CannotEditSlots.Find(En.Slot) != INDEX_NONE,
						En.IndexInSlot));
		}
	}

	// Layout
	// integer division
	for (i = 0; i < NumSmall / MAX_SMALLITEMS_IN_ROW; i++)
	{
		SmallItemLayout.AddItem(MAX_SMALLITEMS_IN_ROW);
	}
	if (NumSmall % MAX_SMALLITEMS_IN_ROW != 0)
	{
		SmallItemLayout.AddItem(NumSmall % MAX_SMALLITEMS_IN_ROW);
	}
	
	// if we have at least two rows, even out the last two rows
	if (SmallItemLayout.Length > 1)
	{
		// move an item slot from the upper row to the lower row while their difference is larger than 1
		// we will end with either the top row having 1 more slot than or the same number of slots as the lower row
		while (SmallItemLayout[SmallItemLayout.Length - 2] - SmallItemLayout[SmallItemLayout.Length - 1] > 1)
		{
			SmallItemLayout[SmallItemLayout.Length - 1]++;
			SmallItemLayout[SmallItemLayout.Length - 2]--;
		}
	}
	iCurrInRow = 0;
	iCurrRow = 0;
	for (i = 0; i < NumSmall; i++)
	{
		SmallItems[i].SetLayoutInfo(iCurrInRow, SmallItemLayout[iCurrRow]);
		iCurrInRow++;
		if (iCurrInRow == SmallItemLayout[iCurrRow])
		{
			iCurrInRow = 0;
			iCurrRow++;
		}
	}
}

// Sets up the items regularly
simulated function SetupItemsRegular()
{
	local XComGameState_Unit Unit;
	local int iSmallItemSlots, iUtilitySlots, iVisualLockedSlot, iCurrInRow, iCurrRow, iThisSmallItem;
	local array<int> SmallItemLayout;
	local int i;

	Unit = GetUnit();

	// heavy weapon
	// this one checks if one is allowed
	if (Unit.HasHeavyWeapon())
	{
		AddTypicalSlot(Unit, eInvSlot_HeavyWeapon);
	}
	// armor
	AddTypicalSlot(Unit, eInvSlot_Armor);
	// primary
	AddTypicalSlot(Unit, eInvSlot_PrimaryWeapon);
	// secondary
	if (Unit.NeedsSecondaryWeapon())
	{
		AddTypicalSlot(Unit, eInvSlot_SecondaryWeapon);
	}

	// utility
	iVisualLockedSlot = -1;
	iUtilitySlots = Unit.GetCurrentStat(eStat_UtilityItems);
	// if we don't have an extra utility slot from our armor [WotC: armor or ability], show a locked icon
	// but only if we have utility slots at all [WotC or we are reapers]
	// causes all sorts of weirdnesses with Navigation
	// also don't show a locked icon if we have 3 or more slots, not neccessary
	if (!Unit.HasExtraUtilitySlot()
		&& (iUtilitySlots > 0 || Unit.GetResistanceFaction() != none && Unit.GetResistanceFaction().GetMyTemplateName() == 'Faction_Reapers') 
		&& iUtilitySlots < 3)
	{
		iVisualLockedSlot = iUtilitySlots++;
	}
	iSmallItemSlots = iUtilitySlots;
	if (Unit.HasAmmoPocket()) iSmallItemSlots++;
	if (Unit.HasGrenadePocket()) iSmallItemSlots++;
	
	// integer division
	for (i = 0; i < iSmallItemSlots / MAX_SMALLITEMS_IN_ROW; i++)
	{
		SmallItemLayout.AddItem(MAX_SMALLITEMS_IN_ROW);
	}
	if (iSmallItemSlots % MAX_SMALLITEMS_IN_ROW != 0)
	{
		SmallItemLayout.AddItem(iSmallItemSlots % MAX_SMALLITEMS_IN_ROW);
	}
	
	// if we have at least two rows, even out the last two rows
	if (SmallItemLayout.Length > 1)
	{
		// move an item slot from the upper row to the lower row while their difference is larger than 1
		// we will end with either the top row having 1 more slot than or the same number of slots as the lower row
		while (SmallItemLayout[SmallItemLayout.Length - 2] - SmallItemLayout[SmallItemLayout.Length - 1] > 1)
		{
			SmallItemLayout[SmallItemLayout.Length - 1]++;
			SmallItemLayout[SmallItemLayout.Length - 2]--;
		}
	}
	iCurrInRow = 0;
	iCurrRow = 0;
	iThisSmallItem = 0;
	for (i = 0; i < iUtilitySlots; i++)
	{
		AddSmallItemSlot(Unit, eInvSlot_Utility, iCurrInRow, SmallItemLayout[iCurrRow], i, iVisualLockedSlot == iThisSmallItem);
		iCurrInRow++;
		iThisSmallItem++;
		if (iCurrInRow == SmallItemLayout[iCurrRow])
		{
			iCurrInRow = 0;
			iCurrRow++;
		}
	}
	// ammo
	if (Unit.HasAmmoPocket())
	{
		AddSmallItemSlot(Unit, eInvSlot_AmmoPocket, iCurrInRow, SmallItemLayout[iCurrRow]);
		iCurrInRow++;
		iThisSmallItem++;
		if (iCurrInRow == SmallItemLayout[iCurrRow])
		{
			iCurrInRow = 0;
			iCurrRow++;
		}
	}
	// grenade
	if (Unit.HasGrenadePocket())
	{
		AddSmallItemSlot(Unit, eInvSlot_GrenadePocket, iCurrInRow, SmallItemLayout[iCurrRow]);
		iCurrInRow++;
		iThisSmallItem++;
		if (iCurrInRow == SmallItemLayout[iCurrRow])
		{
			iCurrInRow = 0;
			iCurrRow++;
		}
	}
}

// get the extra space we need in order to maybe display skills etc.
// used by robojumper_UISquadSelect, it adjusts the list y position
// used to realize height too, can't rename :(
simulated function int GetExtraHeight()
{
	local int runningY;
	
	runningY = 0;
	if (TheStatsPanel != none)
	{
		TheStatsPanel.SetY(runningY);
		runningY += TheStatsPanel.Height;
	}
	if (TheSkillsPanel != none)
	{
		TheSkillsPanel.SetY(runningY);
		runningY += TheSkillsPanel.Height;
	}
	return runningY;
}

simulated function AddTypicalSlot(XComGameState_Unit Unit, EInventorySlot InvSlot)
{
	EquipmentItems.AddItem(Spawn(class'robojumper_UISquadSelect_EquipItem', TheList.itemContainer)
		.InitEquipItem(InvSlot,
						SafeGetReference(Unit, InvSlot),
						CannotEditSlots.Find(InvSlot) != INDEX_NONE));
}

simulated function AddSmallItemSlot(XComGameState_Unit Unit, EInventorySlot InvSlot, int iCurrInRow, int iTotalInRow, optional int Index = -1, optional bool bLocked = false)
{
	SmallItems.AddItem(Spawn(class'robojumper_UISquadSelect_UtilityItem', TheList.itemContainer)
		.InitUtilityItem(InvSlot,
						SafeGetReference(Unit, InvSlot, Index),
						CannotEditSlots.Find(InvSlot) != INDEX_NONE || bLocked,
						Max(Index, 0), // i'st utility item
						iCurrInRow, // iCurrInRow'st item in current row
						iTotalInRow)); // total items per row
}

// gets the item reference in the slot at the specified location without throwing None and Out of Bounds errors if the item doesn't exist
simulated function StateObjectReference SafeGetReference(XComGameState_Unit Unit, EInventorySlot InvSlot, optional int idx = -1)
{
	local XComGameState_Item ItemState;
	local array<XComGameState_Item> ItemStates;
	local StateObjectReference EmptyRef;
	if (idx == -1)	
	{
		ItemState = Unit.GetItemInSlot(InvSlot, none, false);
	}
	else
	{
		ItemStates = Unit.GetAllItemsInSlot(InvSlot, none, false, true);
		if (idx < ItemStates.Length)
		{
			ItemState = ItemStates[idx];
		}
	}
	return ItemState != none ? ItemState.GetReference() : EmptyRef;
}

simulated function SetEmpty()
{
	if (TheList != none)
	{
		TheList.Remove();
		TheList = none;
		if (TheSkillsPanel != none)
			TheSkillsPanel.Remove();
		TheSkillsPanel = none;
		if (TheStatsPanel != none)
			TheStatsPanel.Remove();
		TheStatsPanel = none;
	}
	ClearExtraInfoBoxes();
	if (DynamicPanel == none)
	{
		CreateDynamicPanel();
	}
	SelectSoldierText.SetHtmlText(class'UIUtilities_Text'.static.AddFontInfo(class'UIUtilities_Text'.static.GetColoredText(GetSelectUnitString(), bIsFocused ? -1 : eUIState_Normal, 26, "CENTER"), false, true));
}

simulated function SetFilled()
{
	if (DynamicPanel != none)
	{
		DynamicPanel.Remove();
		DynamicPanel = none;
	}
	ClearExtraInfoBoxes();
	if (TheList == none)
	{
		CreateList();
	}
	// we're gonna shrink it again. shrunk lists can not grow by default
	TheList.SetHeight(1000);
}

simulated function ClearExtraInfoBoxes()
{
	local UIPanel Panel;
	foreach ExtraInfoBoxes(Panel)
	{
		Panel.Remove();
	}
	ExtraInfoBoxes.Length = 0;
}

simulated function SpawnExtraInfoBoxes()
{
	local XComLWTuple Tuple, InnerTuple;
	local int i;
	
	Tuple = new class'XComLWTuple';
	Tuple.Id = 'rjSquadSelect_ExtraInfo';

	Tuple.Data.Length = 1;
	Tuple.Data[0].kind = XComLWTVInt;
	Tuple.Data[0].i = SlotIndex;

	`XEVENTMGR.TriggerEvent('rjSquadSelect_ExtraInfo', Tuple, Tuple, none);

	for (i = 1; i < Tuple.Data.Length; i++)
	{
		InnerTuple = XComLWTuple(Tuple.Data[i].o);
		SpawnInfoBox(InnerTuple.Data[0].s, InnerTuple.Data[1].s, InnerTuple.Data[2].s);
	}
}

simulated function SpawnInfoBox(string strText, string strTextColor, string strBGColor)
{
	local UIPanel Panel;
	local UIPanel BGBox;
	local UIScrollingText Text;

	Panel = Spawn(class'UIPanel', self);
	Panel.bIsNavigable = false;
	Panel.InitPanel();
	Panel.SetAlpha(0.7);

	BGBox = Spawn(class'UIPanel', Panel);
	BGBox.InitPanel('theBG', class'UIUtilities_Controls'.const.MC_X2BackgroundSimple);
	BGBox.SetSize(Width, InfoBoxHeight);
	BGBox.SetColor(strBGColor);

	Text = Spawn(class'UIScrollingText', Panel).InitScrollingText('theText', "", width - 20, 10, 0);
	Text.SetHTMLText("<p align='CENTER'><font size='26' color='#" $ strTextColor $ "'>" $ strText $ "</font></p>");

	ExtraInfoBoxes.AddItem(Panel);
}

simulated function string GetSelectUnitString()
{
	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'rjSquadSelect_SelectUnitString';

	Tuple.Data.Length = 2;
	Tuple.Data[0].kind = XComLWTVInt;
	Tuple.Data[0].i = SlotIndex;
	Tuple.Data[1].kind = XComLWTVString;
	Tuple.Data[1].s = m_strSelectUnit;

	`XEVENTMGR.TriggerEvent('rjSquadSelect_SelectUnitString', Tuple, Tuple, none);

	return Tuple.Data[1].s;
}

simulated function DisableSlot()
{
	/*bDisabled = true;
	TheList.SetVisible(false);*/
}

simulated function RealizeHeight()
{
	local int iheight;
	if (TheList != none)
	{
		iheight = TheList.ShrinkToFit();
		TheList.SetHeight(iheight);
		TheList.SetY(/*240*/ - iheight);
	}
	StackInfoBoxes();
}

simulated function StackInfoBoxes()
{
	local int i, startY;

	if (DynamicPanel != none)
	{
		startY = DynamicPanel.Y;
	}
	else if (TheList != none)
	{
		startY = TheList.Y;
	}

	for (i = 0; i < ExtraInfoBoxes.Length; i++)
	{
		ExtraInfoBoxes[i].SetY(startY - (i + 1) * InfoBoxHeight);
	}
}

simulated function OnSelectSoldierMouseEvent(UIPanel control, int cmd)
{
	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
		SetSelectedNavigation();
		OnReceiveFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
		OnLoseFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
		OnClickedSelectUnitButton();
		break;
	}
}


simulated function XComGameState_Unit GetUnit()
{
	return GetUnitRef().ObjectID > 0 ? XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(GetUnitRef().ObjectID)) : none;
	//return XComTacticalController(GetALocalPlayerController()).ControllingUnitVisualizer.GetVisualizedGameState();
}

// do it manually
// it's delay * 1.5 because we want us to animate in a bit before our children animate in
simulated function AnimateIn(optional float Delay = -1.0)
{
	local int i;
	super(UIPanel).AnimateIn(Delay);
	
	for (i = 0; i < EquipmentItems.Length; i++)
	{
		EquipmentItems[i].AnimateIn((Delay * 1.5) + (i * class'UIUtilities'.const.INTRO_ANIMATION_DELAY_PER_INDEX));
	}
	for (i = 0; i < SmallItems.Length; i++)
	{
		SmallItems[i].AnimateIn((Delay * 1.5) + ((i + EquipmentItems.Length) * class'UIUtilities'.const.INTRO_ANIMATION_DELAY_PER_INDEX));
	}
	if (TheSkillsPanel != none)
	{
		TheSkillsPanel.AnimateIn(Delay * 1.5);
	}
}

simulated function OnReceiveFocus()
{
	super(UIPanel).OnReceiveFocus();
	if (TheList != none)
	{
		TheList.OnReceiveFocus();
		TheSoldierPanel.RealizeDismissImageState(); // controller
	}
	else if (DynamicPanel != none)
	{
		DynamicPanel.OnReceiveFocus();
		SelectSoldierText.SetHtmlText(class'UIUtilities_Text'.static.AddFontInfo(class'UIUtilities_Text'.static.GetColoredText(GetSelectUnitString(), , 26, "CENTER"), false, true));
	}
}

simulated function SetSelectedNavigation()
{
	local UIPanel SelectedControl;

	SelectedControl = ParentPanel.Navigator.GetSelected();
	if (SelectedControl != none) 
		SelectedControl.OnLoseFocus();

	super.SetSelectedNavigation();
	robojumper_UIList_SquadEditor(GetParent(class'robojumper_UIList_SquadEditor', true)).NavigatorSelectionChangedPanel(self);
}

// added as a fix for the list item highlighting when selecting extra panels
simulated function SetSelectedNavigationSoldierPanel()
{
	TheList.SetSelectedItem(TheSoldierPanel);
	SetSelectedNavigation();
}

simulated function OnLoseFocus()
{
	super(UIPanel).OnLoseFocus();
	// neccessary to clear focused list items which would stay focused otherwise
	if (TheList != none)
	{
		TheList.OnLoseFocus();
		//TheList.GetSelectedItem().OnLoseFocus();
		TheSoldierPanel.RealizeDismissImageState(); // controller
	}
	else if (DynamicPanel != none)
	{
		DynamicPanel.OnLoseFocus();
		SelectSoldierText.SetHtmlText(class'UIUtilities_Text'.static.AddFontInfo(class'UIUtilities_Text'.static.GetColoredText(GetSelectUnitString(), eUIState_Normal, 26, "CENTER"), false, true));
	}
}

simulated function OnClickedDismissButton()
{
	local UISquadSelect SquadScreen;
	local XComGameState_HeadquartersXCom XComHQ;

	if (GetUnit() == none) return;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	if(!XComHQ.IsObjectiveCompleted('T0_M3_WelcomeToHQ') || bDisabledDismiss)
	{
		class'UIUtilities_Sound'.static.PlayNegativeSound();
		return;
	}
	// don't need that in here
//	HandleButtonFocus(m_eActiveButton, false);
	SquadScreen = UISquadSelect(screen);
	SquadScreen.m_iSelectedSlot = SlotIndex;
	SquadScreen.ChangeSlot();
	UpdateData(); // passing no params clears the slot
}

simulated function OnClickedSelectUnitButton()
{
	if (GetUnit() != none || bDisabled) return;
	super.OnClickedSelectUnitButton();
}

simulated function OnClickedEditUnitButton()
{
	local UISquadSelect SquadScreen;
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	if(!XComHQ.IsObjectiveCompleted('T0_M3_WelcomeToHQ') || bDisabledEdit || GetUnit().IsCivilian())
	{
		class'UIUtilities_Sound'.static.PlayNegativeSound();
		return;
	}

	SquadScreen = UISquadSelect(screen);
	SquadScreen.m_iSelectedSlot = SlotIndex;
	
	if( XComHQ.Squad[SquadScreen.m_iSelectedSlot].ObjectID > 0 )
	{
		//UISquadSelect(Screen).bDirty = true;
		SetDirty(true);
//		SquadScreen.SnapCamera();
		`HQPRES.UIArmory_MainMenu(XComHQ.Squad[SquadScreen.m_iSelectedSlot]);//, 'PreM_CustomizeUI', 'PreM_SwitchToSoldier', 'PreM_GoToLineup', 'PreM_CustomizeUI_Off', 'PreM_SwitchToLineup');
//		`XCOMGRI.DoRemoteEvent('PreM_GoToSoldier');
	}
}

simulated function OnClickedPromote()
{
	UISquadSelect(Screen).m_iSelectedSlot = SlotIndex;
	if( GetUnitRef().ObjectID > 0 )
	{
		SetDirty(true);
		SetTimer(0.1f, false, nameof(GoPromote));
	}
}


simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;
	
	bHandled = true;
	switch (cmd)
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_Y:
			OnClickedDismissButton();
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_X:
			OnClickedEditUnitButton();
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			if (GetUnit() == none)
				OnClickedSelectUnitButton();
			else
				bHandled = false;
			break;
		default:
			bHandled = false;
			break;
	}

	return bHandled || Navigator.OnUnrealCommand(cmd, arg);
}

defaultproperties
{
	LibID = "EmptyControl";
	width = 282;
	InfoBoxHeight = 32;
}
 