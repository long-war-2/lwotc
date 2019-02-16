//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ArmoryWeaponUpgrade_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Adds button to allow stripping a weapon of mods
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ArmoryWeaponUpgrade_LW extends UIScreenListener;

var UIButton StripWeaponUpgradesButton;
var StateObjectReference WeaponRef;

var localized string strStripWeaponUpgradesButton;
var localized string strStripWeaponUpgradesTooltip;
var localized string strStripWeaponUpgradeDialogueTitle;
var localized string strStripWeaponUpgradeDialogueText;

var int MenuHeight;
var int SlotHeight;

// Track whether or not we've added the strip button to the nav help.
var bool AddedNavHelp;

// Is this a screen we care about? We want to hook the UIArmory_WeaponUpgrade
// screen, but not the UIArmory_WeaponTrait screen.
function UIArmory_WeaponUpgrade ValidateScreen(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade UpgradeScreen;

	UpgradeScreen = UIArmory_WeaponUpgrade(Screen);
	if (UpgradeScreen != none && UIArmory_WeaponTrait(UpgradeScreen) == none)
	{
		return UpgradeScreen;
	}

	return none;
}

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade UpgradeScreen;
	UpgradeScreen = ValidateScreen(Screen);
	if (UpgradeScreen != none)
	{
		if(!UpgradeScreen.CustomizeList.bIsInited)
		{
			UpgradeScreen.CustomizeList.AddOnInitDelegate(UpdateCustomizationStripWeapon);
		}
		RefreshScreen(UpgradeScreen);
		RegisterForEvents();
		UpdateNavHelp(UpgradeScreen);
	}
}

event OnRemoved(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade UpgradeScreen;
	local Object ThisObj;

	ThisObj = self;
	UpgradeScreen = ValidateScreen(Screen);
	if (UpgradeScreen != none)
	{
		`XEVENTMGR.UnRegisterFromAllEvents(ThisObj);
		AddedNavHelp = false;
	}
}

function RegisterForEvents()
{
	local X2EventManager EventMgr;
	local Object ThisObj; 

	EventMgr = `XEVENTMGR;
	ThisObj = self;

	EventMgr.UnRegisterFromAllEvents(ThisObj);
	EventMgr.RegisterForEvent(ThisObj, 'WeaponUpgradeListChanged', OnWeaponUpgradeListChanged);
}

function EventListenerReturn OnWeaponUpgradeListChanged(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local UIArmory_WeaponUpgrade UpgradeScreen;
	local UIList NewList;

	// This event gets triggered by a refresh of the nav help in the screen, so our button has been removed.
	AddedNavHelp = false;

	UpgradeScreen = ValidateScreen(UIScreen(EventSource));
	NewList = UIList(EventData);
	if (UpgradeScreen != none && NewList == UpgradeScreen.SlotsList)
	{
		UpdateNavHelp(UpgradeScreen);
	}

	return ELR_NoInterrupt;
}

function UpdateNavHelp(UIArmory_WeaponUpgrade UpgradeScreen)
{
	local XComGameState_LWListenerManager ListenerManager;

	if (!AddedNavHelp)
	{
		ListenerManager = class'XComGameState_LWListenerManager'.static.GetListenerManager();
		UpgradeScreen.NavHelp.AddLeftHelp(class'UIUtilities_LW'.default.m_strStripWeaponUpgrades, "", ListenerManager.OnStripUpgrades, false, class'UIUtilities_LW'.default.m_strTooltipStripWeapons);
		UpgradeScreen.NavHelp.Show();
		AddedNavHelp = true;
	}
}

event OnReceiveFocus(UIScreen Screen)
{
	local UIArmory_WeaponUpgrade UpgradeScreen;

	UpgradeScreen = ValidateScreen(Screen);
	if (UpgradeScreen != none)
	{
		AddedNavHelp = false;
		RefreshScreen(UpgradeScreen);
		UpdateNavHelp(UpgradeScreen);
	}
}

simulated function UpdateCustomizationStripWeapon(UIPanel Panel)
{
	local UIArmory_WeaponUpgrade UpgradeScreen;

	UpgradeScreen = ValidateScreen(Panel.Screen);
	if (UpgradeScreen != none)
		RefreshScreen(UpgradeScreen);
}

simulated function RefreshScreen (UIArmory_WeaponUpgrade UpgradeScreen)
{
	local UIMechaListItem StripMechaItem;

	// save off references to the weapon, for later callbacks
	WeaponRef = UpgradeScreen.WeaponRef;
	StripMechaItem = UpgradeScreen.GetCustomizeItem(3);
	StripMechaItem.UpdateDataDescription(class'UIUtilities_Text'.static.GetColoredText(strStripWeaponUpgradesButton, eUIState_Normal), OnStripWeaponClicked);
	UpgradeScreen.CustomizeList.SetPosition(UpgradeScreen.CustomizationListX, UpgradeScreen.CustomizationListY - UpgradeScreen.CustomizeList.ShrinkToFit() - UpgradeScreen.CustomizationListYPadding);
	UpgradeScreen.CustomizeList.SetHeight(MenuHeight);

	UpgradeScreen.SlotsList.SetHeight(SlotHeight);
}

simulated function OnStripWeaponClicked()
{
	local XComPresentationLayerBase Pres;
	local TDialogueBoxData DialogData;

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
	local XComGameState_Item ItemState, UpgradeItemState;
	local UIScreenStack ScreenStack;
	local int Index, k;
	local UIArmory_WeaponUpgrade UpgradeScreen;
	local array<X2WeaponUpgradeTemplate> UpgradeTemplates;
	local XComGameState_HeadquartersXCom XComHQ;

	if (eAction == 'eUIAction_Accept')
	{
		ScreenStack = `SCREENSTACK;
		for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
		{
			if(UIArmory_WeaponUpgrade(ScreenStack.Screens[Index]) != none )
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

		if (!ItemState.HasBeenModified()) { return; }
		
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
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none;
	MenuHeight = 180
	SlotHeight = 600
}