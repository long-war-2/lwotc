//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_AdventGrenadeLauncher
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Links up any carried grenades with a grenade launcher
//--------------------------------------------------------------------------------------- 

class X2Effect_AdventGrenadeLauncher extends X2Effect;

`include(..\..\XComGame\Mods\LongWaroftheChosen\Src\LW_AlienPack_Integrated\LW_AlienPack.uci)

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit					UnitState; 
	local XComGameState_Item					InventoryItem;
	local array<XComGameState_Item> CurrentInventory;
	local X2AbilityTemplateManager				AbilityManager;
	local X2AbilityTemplate						AbilityTemplate;
	local XComGameState_Item					SecondaryWeapon;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState == none)
		return;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityManager.FindAbilityTemplate('LaunchGrenade');
	if(AbilityTemplate == none)
	{
		`REDSCREEN("ADVENT Grenade Launcher : No Launch Grenade ability template found");
		return;
	}
	SecondaryWeapon = UnitState.GetSecondaryWeapon();
	if(SecondaryWeapon == none)
	{
		`REDSCREEN("ADVENT Grenade Launcher : No item found in secondary slot");
		return;
	}

	CurrentInventory = UnitState.GetAllInventoryItems();
	//  populate a version of the ability for every grenade in the inventory
	foreach CurrentInventory(InventoryItem)
	{
		`APTRACE("ADVENT Grenade Launcher: Checking item" @ InventoryItem.GetMyTemplateName());
		if (InventoryItem.bMergedOut) 
			continue;

		if (X2GrenadeTemplate(InventoryItem.GetMyTemplate()) != none)
		{
			`APDEBUG("ADVENT Grenade Launcher: Is Grenade. Adding Ability" @ AbilityTemplate.DataName @ "for weapon" @ SecondaryWeapon.GetMyTemplateName() @ "using ammo" @ InventoryItem.GetMyTemplateName());
			`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState, SecondaryWeapon.GetReference(), InventoryItem.GetReference());
		}
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
