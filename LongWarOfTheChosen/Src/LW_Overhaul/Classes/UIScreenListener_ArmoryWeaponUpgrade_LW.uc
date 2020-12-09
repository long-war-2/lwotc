//---------------------------------------------------------------------------------------
//	FILE:    UIScreenListener_ArmoryWeaponUpgrade_LW.uc
//	AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Adds button to allow stripping a weapon of mods
//
//	KDM : CHANGES THAT HAVE BEEN MADE :
//	1.] The UIButton, StripWeaponUpgradesButton, was removed as it was never used.
//	2.] RegisterForEvents() has been removed because it registered for an event, WeaponUpgradeListChanged, which is never triggered.
//		Additionally, its callback function, OnWeaponUpgradeListChanged(), was removed since it is never called.
//	3.] UpdateNavHelp() and AddedNavHelp are no longer used to update the navigation UI; instead we listen for the event
//	UIArmory_WeaponUpgrade_NavHelpUpdated within X2EventListener_Headquarters.
//
//	GENERAL UI STRUCTURE OF UIArmory_WeaponUpgrade :
//	- SlotsListContainer contains SlotsList and CustomizeList.
//		- SlotsList is the list of upgrades which are currently attached to this weapon.
//		- CustomizeList, located below SlotsList, contains buttons which allow you to modify the weapon's name, colour, and pattern.
//	- UpgradesListContainer contains UpgradesList.
//		- UpgradesList is the list of 'potential' weapon upgrades you can choose from when you click on a weapon slot within SlotsList.
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ArmoryWeaponUpgrade_LW extends UIScreenListener;

// KDM : When you click on a slot, in order to choose a weapon upgrade, save its selected index. This allows us to re-select this
// 'clicked' slot once the weapon upgrade has been chosen; the default behaviour was to always select the 1st slot.
var int SavedSlotsListIndex;

var StateObjectReference WeaponRef;

var localized string strStripWeaponUpgradesButton;
var localized string StripAllWeaponUpgradesStr;
var localized string strStripWeaponUpgradesTooltip;
var localized string strStripWeaponUpgradeDialogueTitle;
var localized string strStripWeaponUpgradeDialogueText;

var int MenuHeight;
var int SlotHeight;

// We want to deal with UIArmory_WeaponUpgrade, but not its subclass UIArmory_WeaponTrait.
function UIArmory_WeaponUpgrade ValidateScreen(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade WeaponUpgradeScreen;

	WeaponUpgradeScreen = UIArmory_WeaponUpgrade(Screen);
	
	if (WeaponUpgradeScreen != none && UIArmory_WeaponTrait(WeaponUpgradeScreen) == none)
	{
		return WeaponUpgradeScreen;
	}

	return none;
}

event OnInit(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade WeaponUpgradeScreen;
	local XComHQPresentationLayer HQPres;
	
	HQPres = `HQPRES;
	WeaponUpgradeScreen = ValidateScreen(Screen);
	
	if (WeaponUpgradeScreen != none)
	{
		if (!WeaponUpgradeScreen.CustomizeList.bIsInited)
		{
			WeaponUpgradeScreen.CustomizeList.AddOnInitDelegate(UpdateCustomizationStripWeapon);
		}
		RefreshScreen(WeaponUpgradeScreen);
		
		// KDM : Intercept UIArmory_WeaponUpgrade's OnUnrealCommand so we can add additional controller commands.
		HQPres.ScreenStack.SubscribeToOnInputForScreen(WeaponUpgradeScreen, OnWeaponUpgradeCommand);
	}
}

event OnRemoved(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade WeaponUpgradeScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	WeaponUpgradeScreen = ValidateScreen(Screen);
	
	if (WeaponUpgradeScreen != none)
	{
		// KDM : Stop intercepting UIArmory_WeaponUpgrade's OnUnrealCommand.
		HQPres.ScreenStack.UnsubscribeFromOnInputForScreen(WeaponUpgradeScreen, OnWeaponUpgradeCommand);
	}
}

event OnReceiveFocus(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade WeaponUpgradeScreen;

	WeaponUpgradeScreen = ValidateScreen(Screen);
	if (WeaponUpgradeScreen != none)
	{
		RefreshScreen(WeaponUpgradeScreen);
	}
}

simulated function UpdateCustomizationStripWeapon(UIPanel Panel)
{
	local UIArmory_WeaponUpgrade WeaponUpgradeScreen;

	WeaponUpgradeScreen = ValidateScreen(Panel.Screen);

	if (WeaponUpgradeScreen != none)
	{
		RefreshScreen(WeaponUpgradeScreen);
	}
}

simulated function bool IsSlotsListSelected(UIArmory_WeaponUpgrade WeaponUpgradeScreen)
{
	local UIList SlotsList;
	local UIPanel SlotsListContainer;
	
	SlotsListContainer = WeaponUpgradeScreen.SlotsListContainer;
	SlotsList = WeaponUpgradeScreen.SlotsList;
	
	return ((WeaponUpgradeScreen.Navigator.GetSelected() == SlotsListContainer) && (SlotsListContainer.Navigator.GetSelected() == SlotsList));
}

simulated function bool IsCustomizeListSelected(UIArmory_WeaponUpgrade WeaponUpgradeScreen)
{
	local UIList CustomizeList;
	local UIPanel SlotsListContainer;
	
	SlotsListContainer = WeaponUpgradeScreen.SlotsListContainer;
	CustomizeList = WeaponUpgradeScreen.CustomizeList;
	
	return ((WeaponUpgradeScreen.Navigator.GetSelected() == SlotsListContainer) && (SlotsListContainer.Navigator.GetSelected() == CustomizeList));
}

simulated function bool IsUpgradesListSelected(UIArmory_WeaponUpgrade WeaponUpgradeScreen)
{
	local UIList UpgradesList;
	local UIPanel UpgradesListContainer;
	
	UpgradesListContainer = WeaponUpgradeScreen.UpgradesListContainer;
	UpgradesList = WeaponUpgradeScreen.UpgradesList;
	
	return ((WeaponUpgradeScreen.Navigator.GetSelected() == UpgradesListContainer) && (UpgradesListContainer.Navigator.GetSelected() == UpgradesList));
}

simulated function bool AllowWeaponStripping(UIArmory_WeaponUpgrade WeaponUpgradeScreen)
{
	// KDM : Don't allow weapon stripping if either the 1.] upgrade slot list is open 2.] colour selector is open.
	return (!(IsUpgradesListSelected(WeaponUpgradeScreen) || (WeaponUpgradeScreen.ColorSelector != none)));
}

simulated function bool OnWeaponUpgradeCommand(UIScreen Screen, int cmd, int arg)
{
	local bool A_Pressed, B_Pressed, LBumper_Pressed, RBumper_Pressed, bHandled;
	local UIArmory_WeaponUpgrade WeaponUpgradeScreen;
	
	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	WeaponUpgradeScreen = UIArmory_WeaponUpgrade(Screen);

	A_Pressed = (cmd == class'UIUtilities_Input'.static.GetAdvanceButtonInputCode()) ? true : false;
	B_Pressed = (cmd == class'UIUtilities_Input'.static.GetBackButtonInputCode()) ? true : false;
	LBumper_Pressed = (cmd == class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER) ? true : false;
	RBumper_Pressed = (cmd == class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER) ? true : false;

	if (A_Pressed && IsSlotsListSelected(WeaponUpgradeScreen))
	{
		// KDM : The A button was pressed while a weapon slot was selected; therefore, we want to save its index.
		SavedSlotsListIndex = WeaponUpgradeScreen.SlotsList.SelectedIndex;
	}
	else if ((A_Pressed || B_Pressed) && IsUpgradesListSelected(WeaponUpgradeScreen))
	{
		// KDM : The A or B button was pressed while an upgrade slot was selected; therefore, the upgrade slot list will likely be hidden,
		// and the weapon slot list will likely be shown. Get ready to re-select the previously 'clicked' weapon slot.
		
		// KDM : Allow normal code to flow via WeaponUpgradeScreen.OnUnrealCommand(); this will result in a call to OnAccept() or OnCancel().
		WeaponUpgradeScreen.OnUnrealCommand(cmd, arg);
		
		// KDM : If the weapon slot list has, in fact, regained focus, re-select the previously 'clicked' weapon slot.
		if (IsSlotsListSelected(WeaponUpgradeScreen))
		{
			WeaponUpgradeScreen.SlotsList.SetSelectedIndex(SavedSlotsListIndex);
		}

		// KDM : We have handled the input so just return true.
		return true;
	}
	else if (LBumper_Pressed || RBumper_Pressed)
	{
		// KDM : Focus is lost when we cycle weapons; we are going to fix this after normal OnUnrealCommand() code has executed. 
		WeaponUpgradeScreen.OnUnrealCommand(cmd, arg);

		// KDM : If the customize list had focus before weapon cycling, it retains that focus after weapon cycling; we don't want this 
		// to happen so remove its selection and, hence, focus.
		WeaponUpgradeScreen.CustomizeList.SetSelectedIndex(-1);
		
		// KDM : Select the weapon slot list, then proceed to select its 1st list item.
		WeaponUpgradeScreen.Navigator.SetSelected(WeaponUpgradeScreen.SlotsListContainer);
		WeaponUpgradeScreen.SlotsListContainer.Navigator.SetSelected(WeaponUpgradeScreen.SlotsList);
		WeaponUpgradeScreen.SlotsList.SetSelectedIndex(0);

		// KDM : We have handled the input so just return true.
		return true;
	}

	switch (cmd)
	{
		// KDM : Left stick click strips all weapon upgrades.
		case class'UIUtilities_Input'.const.FXS_BUTTON_L3:
			if (AllowWeaponStripping(WeaponUpgradeScreen))
			{
				OnStripUpgrades();
			}
			break;

		// KDM : Right stick click strips this weapon's upgrades.
		case class'UIUtilities_Input'.const.FXS_BUTTON_R3:
			if (AllowWeaponStripping(WeaponUpgradeScreen))
			{
				OnStripWeaponClicked();
			}
			break;

		default:
			bHandled = false;
			break;
	}

	return bHandled;
}

simulated function RefreshScreen(UIArmory_WeaponUpgrade WeaponUpgradeScreen)
{
	local UIMechaListItem StripMechaItem;
	
	// Save off references to the weapon, for later callbacks
	WeaponRef = WeaponUpgradeScreen.WeaponRef;
	
	// KDM : Controller users don't need a button to strip a weapon's upgrades, since this has been integrated into OnUnrealCommand().
	if (!`ISCONTROLLERACTIVE)
	{
		StripMechaItem = WeaponUpgradeScreen.GetCustomizeItem(3);
		// KDM : Don't wrap UIMechaListItem descriptions in font tags else they won't change colour when item focus changes.
		// This is all handled in ActionScript anyways.
		StripMechaItem.UpdateDataDescription(strStripWeaponUpgradesButton, OnStripWeaponClicked);
		WeaponUpgradeScreen.CustomizeList.SetPosition(WeaponUpgradeScreen.CustomizationListX, WeaponUpgradeScreen.CustomizationListY - 
			WeaponUpgradeScreen.CustomizeList.ShrinkToFit() - WeaponUpgradeScreen.CustomizationListYPadding);
		WeaponUpgradeScreen.CustomizeList.SetHeight(MenuHeight);
		WeaponUpgradeScreen.SlotsList.SetHeight(SlotHeight);
	}
}

simulated static function OnStripUpgrades()
{
	local TDialogueBoxData DialogData;
	DialogData.eType = eDialog_Normal;
	DialogData.strTitle = class'UIUtilities_LW'.default.m_strStripWeaponUpgradesConfirm;
	DialogData.strText = class'UIUtilities_LW'.default.m_strStripWeaponUpgradesConfirmDesc;
	DialogData.fnCallback = OnStripUpgradesDialogCallback;
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	DialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
	`HQPRES.UIRaiseDialog(DialogData);
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

simulated function OnStripUpgradesDialogCallback(Name eAction)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState UpdateState;
	local array<StateObjectReference> Inventory;
	local array<XComGameState_Unit> Soldiers;
	local int idx;
	local StateObjectReference ItemRef;
	local XComGameState_Item ItemState;
	local X2EquipmentTemplate EquipmentTemplate;
	local TWeaponUpgradeAvailabilityData WeaponUpgradeAvailabilityData;
	local XComGameState_Unit OwningUnitState;
	local UIArmory_Loadout LoadoutScreen;

	LoadoutScreen = UIArmory_Loadout(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory_Loadout'));

	if (eAction == 'eUIAction_Accept')
	{
		History = `XCOMHISTORY;
		XComHQ =`XCOMHQ;

		// Strip upgrades from weapons that aren't equipped to any soldier. We need to fetch, strip, and put the items back in the HQ inventory,
		// which will involve de-stacking and re-stacking items, so do each one in an individual gamestate submission.
		Inventory = class'UIUtilities_Strategy'.static.GetXComHQ().Inventory;
		foreach Inventory(ItemRef)
		{
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
			if (ItemState != none)
			{
				OwningUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.OwnerStateObject.ObjectID));
				if (OwningUnitState == none) // only if the item isn't owned by a unit
				{
					EquipmentTemplate = X2EquipmentTemplate(ItemState.GetMyTemplate());
					if(EquipmentTemplate != none && EquipmentTemplate.InventorySlot == eInvSlot_PrimaryWeapon && ItemState.HasBeenModified()) // primary weapon that has been modified
					{
						UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Strip Unequipped Upgrades");
						XComHQ = XComGameState_HeadquartersXCom(UpdateState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

						// If this is the only instance of this weapon in the inventory we'll just get back a non-updated state.
						// That's ok, StripWeaponUpgradesFromItem will create/add it if it's not already in the update state. If it
						// is, we'll use that one directly to do the stripping.
						XComHQ.GetItemFromInventory(UpdateState, ItemState.GetReference(), ItemState);
						StripWeaponUpgradesFromItem(ItemState, XComHQ, UpdateState);
						ItemState = XComGameState_Item(UpdateState.GetGameStateForObjectID(ItemState.ObjectID));
						XComHQ.PutItemInInventory(UpdateState, ItemState);
						`GAMERULES.SubmitGameState(UpdateState);
					}
				}
			}
		}

		// Strip upgrades from weapons on soldiers that aren't active. These can all be batched in one state because
		// soldiers maintain their equipped weapon, so there is no stacking of weapons to consider.
		UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Strip Unequipped Upgrades");
		XComHQ = XComGameState_HeadquartersXCom(UpdateState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		Soldiers = GetSoldiersToStrip(XComHQ, UpdateState);
		for (idx = 0; idx < Soldiers.Length; idx++)
		{
			class'UIUtilities_Strategy'.static.GetWeaponUpgradeAvailability(Soldiers[idx], WeaponUpgradeAvailabilityData);
			if (!WeaponUpgradeAvailabilityData.bCanWeaponBeUpgraded)
			{
				continue;
			}

			ItemState = Soldiers[idx].GetItemInSlot(eInvSlot_PrimaryWeapon, UpdateState);
			if (ItemState != none && ItemState.HasBeenModified())
			{
				StripWeaponUpgradesFromItem(ItemState, XComHQ, UpdateState);
			}
		}

		`GAMERULES.SubmitGameState(UpdateState);
	}
	if (LoadoutScreen != none)
	{
		LoadoutScreen.UpdateNavHelp();
	}
}

function StripWeaponUpgradesFromItem(XComGameState_Item ItemState, XComGameState_HeadquartersXCom XComHQ, XComGameState UpdateState)
{
	local int k;
	local array<X2WeaponUpgradeTemplate> UpgradeTemplates;
	local XComGameState_Item UpdateItemState, UpgradeItemState;

	UpdateItemState = XComGameState_Item(UpdateState.GetGameStateForObjectID(ItemState.ObjectID));
	if (UpdateItemState == none)
	{
		UpdateItemState = XComGameState_Item(UpdateState.ModifyStateObject(class'XComGameState_Item', ItemState.ObjectID));
	}

	UpgradeTemplates = ItemState.GetMyWeaponUpgradeTemplates();
	for (k = 0; k < UpgradeTemplates.length; k++)
	{
		UpgradeItemState = UpgradeTemplates[k].CreateInstanceFromTemplate(UpdateState);
		XComHQ.PutItemInInventory(UpdateState, UpgradeItemState);
	}

	UpdateItemState.NickName = "";
	UpdateItemState.WipeUpgradeTemplates();
}

simulated function array<XComGameState_Unit> GetSoldiersToStrip(XComGameState_HeadquartersXCom XComHQ, XComGameState UpdateState)
{
	local array<XComGameState_Unit> Soldiers;
	local int idx;
	local UIArmory ArmoryScreen;
	local UISquadSelect SquadSelectScreen;

	// Look for an armory screen. This will tell us what soldier we're looking at right now, we never want
	// to strip this one.
	ArmoryScreen = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));

	// Look for a squad select screen. This will tell us which soldiers we shouldn't strip because they're
	// in the active squad.
	SquadSelectScreen = UISquadSelect(`SCREENSTACK.GetFirstInstanceOf(class'UISquadSelect'));

	// Start with all soldiers: we only want to selectively ignore the ones in XComHQ.Squad if we're
	// in squad select. Otherwise it contains stale unit refs and we can't trust it.
	Soldiers = XComHQ.GetSoldiers(false);

	// LWS : revamped loop to remove multiple soldiers
	for(idx = Soldiers.Length - 1; idx >= 0; idx--)
	{

		// Don't strip items from the guy we're currently looking at (if any)
		if (ArmoryScreen != none)
		{
			if(Soldiers[idx].ObjectID == ArmoryScreen.GetUnitRef().ObjectID)
			{
				Soldiers.Remove(idx, 1);
				continue;
			}
		}
		// LWS: prevent stripping of gear of soldier with eStatus_CovertAction
		if(Soldiers[idx].GetStatus() == eStatus_CovertAction)
		{
			Soldiers.Remove(idx, 1);
			continue;
		}
		// Prevent stripping of soldiers in current XComHQ.Squad if we're in squad
		// select. Otherwise ignore XComHQ.Squad as it contains stale unit refs.
		if (SquadSelectScreen != none)
		{
			if (XComHQ.Squad.Find('ObjectID', Soldiers[idx].ObjectID) != -1)
			{
				Soldiers.Remove(idx, 1);
				continue;
			}
		}
	}

	return Soldiers;
}

simulated function OnStripWeaponClicked()
{
	local TDialogueBoxData DialogData;
	local XComPresentationLayerBase Pres;
	
	Pres = `PRESBASE;
	Pres.PlayUISound(eSUISound_MenuSelect);

	DialogData.eType = eDialog_Warning;
	DialogData.strTitle = strStripWeaponUpgradeDialogueTitle;
	DialogData.strText = strStripWeaponUpgradeDialogueText;
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNO;
	DialogData.fnCallback = ConfirmStripWeaponUpgradesCallback;
	Pres.UIRaiseDialog(DialogData);
}

simulated function ConfirmStripWeaponUpgradesCallback(Name eAction)
{
	local int Index, k;
	local array<X2WeaponUpgradeTemplate> UpgradeTemplates;
	local UIArmory_WeaponUpgrade UpgradeScreen;
	local UIScreenStack ScreenStack;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Item ItemState, UpgradeItemState;
	
	if (eAction == 'eUIAction_Accept')
	{
		ScreenStack = `SCREENSTACK;
		for (Index = 0; Index < ScreenStack.Screens.Length; ++Index)
		{
			if (UIArmory_WeaponUpgrade(ScreenStack.Screens[Index]) != none)
			{
				UpgradeScreen = UIArmory_WeaponUpgrade(ScreenStack.Screens[Index]);
			}
		}

		if (UpgradeScreen.CustomizationState != none)
		{
			ItemState = UpgradeScreen.UpdatedWeapon;
		}

		if (ItemState == none)
		{
			UpgradeScreen.CreateCustomizationState();
			ItemState = UpgradeScreen.UpdatedWeapon;
		}

		if (!ItemState.HasBeenModified()) 
		{
			return;
		}
		
		XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
		XComHQ = XComGameState_HeadquartersXCom(UpgradeScreen.CustomizationState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		UpgradeScreen.CustomizationState.AddStateObject(XComHQ);
		UpgradeTemplates = ItemState.GetMyWeaponUpgradeTemplates();
		for (k = 0; k < UpgradeTemplates.length; k++)
		{
			UpgradeItemState = UpgradeTemplates[k].CreateInstanceFromTemplate(UpgradeScreen.CustomizationState);
			UpgradeScreen.CustomizationState.AddStateObject(UpgradeItemState);
			XComHQ.PutItemInInventory(UpgradeScreen.CustomizationState, UpgradeItemState);
		}

		ItemState.NickName = "";
		ItemState.WipeUpgradeTemplates();

		`GAMERULES.SubmitGameState(UpgradeScreen.CustomizationState);

		UpgradeScreen.CustomizationState = none;
		UpgradeScreen.UpdatedWeapon = none;

		UpgradeScreen.SetWeaponReference(UpgradeScreen.WeaponRef);
		// And update the active list *again*. This was already done by SetWeaponReference, and triggers
		// refreshing the weapon pawn. But when it was done in SetWeaponReference the weapon pawn was
		// recreated before the slot list was cleared, so it keeps whatever you had in the topmost
		// upgrade slot visible on the pawn as an "upgrade preview". Doing it again after the slot 
		// list has been cleared ensures the pawn is free of upgrades.
		UpgradeScreen.ChangeActiveList(UpgradeScreen.SlotsList, true);
	}
}

defaultproperties
{
	ScreenClass = none;
	MenuHeight = 180;
	SlotHeight = 600;

	SavedSlotsListIndex = -1;
}
