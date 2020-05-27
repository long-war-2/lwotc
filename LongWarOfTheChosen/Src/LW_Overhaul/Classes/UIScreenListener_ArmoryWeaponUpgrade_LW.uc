//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ArmoryWeaponUpgrade_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Adds button to allow stripping a weapon of mods
//
//	KDM : CHANGES THAT HAVE BEEN MADE :
//	1.] The UIButton, StripWeaponUpgradesButton, was removed as it was never used.
//	2.] RegisterForEvents() has been removed because it registered for an event, WeaponUpgradeListChanged, which is never triggered.
//		Additionally, its callback function, OnWeaponUpgradeListChanged(), was removed since it is never called.
//	3.] UpdateNavHelp() and AddedNavHelp are no longer used to update the navigation UI; instead we listen for the event
//		UIArmory_WeaponUpgrade_NavHelpUpdated within X2EventListener_Headquarters.
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
	local XComGameState_LWListenerManager ListenerManager;

	if (!Screen.CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	WeaponUpgradeScreen = UIArmory_WeaponUpgrade(Screen);

	ListenerManager = class'XComGameState_LWListenerManager'.static.GetListenerManager();

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
				ListenerManager.OnStripUpgrades();
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
