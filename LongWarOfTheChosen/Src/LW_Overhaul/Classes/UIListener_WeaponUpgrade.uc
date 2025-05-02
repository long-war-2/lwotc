//---------------------------------------------------------------------------------------
//  AUTHOR:  Xymanek / Used by Tedster with permission
//  PURPOSE: Controller input handler for dropping weapon mods
//---------------------------------------------------------------------------------------
//  WOTCStrategyOverhaul Team
//---------------------------------------------------------------------------------------

class UIListener_WeaponUpgrade extends UIScreenListener;

event OnInit (UIScreen Screen)
{
	local UIArmory_WeaponUpgrade WeaponUpgradeScreen;

	WeaponUpgradeScreen = UIArmory_WeaponUpgrade(Screen);
	if (WeaponUpgradeScreen == none) return;

	// Only if we can reuse upgrades
	if (!`XCOMHQ.bReuseUpgrades) return;

	WeaponUpgradeScreen.Movie.Stack.SubscribeToOnInputForScreen(WeaponUpgradeScreen, OnUnrealCommand);
}

static protected function bool OnUnrealCommand (UIScreen Screen, int cmd, int arg)
{
	local UIArmory_WeaponUpgrade WeaponUpgradeScreen;
	local UIArmory_WeaponUpgradeItem CurrentSlot;
	local UIScreenStack ScreenStack;

	ScreenStack = `SCREENSTACK;
	WeaponUpgradeScreen = UIArmory_WeaponUpgrade(ScreenStack.GetCurrentScreen());

	if (WeaponUpgradeScreen.ActiveList == WeaponUpgradeScreen.SlotsList && cmd == class'UIUtilities_Input'.const.FXS_BUTTON_X && arg == class'UIUtilities_Input'.const.FXS_ACTION_RELEASE)
	{
		CurrentSlot = UIArmory_WeaponUpgradeItem(WeaponUpgradeScreen.SlotsList.GetSelectedItem());

		if (CurrentSlot != none && CurrentSlot.UpgradeTemplate != none)
		{
			class'UIUtilities_LW'.static.RemoveWeaponUpgrade(CurrentSlot);
			`SOUNDMGR.PlaySoundEvent("Generic_Mouse_Click");
		}

		return true;
	}

	return false;
}