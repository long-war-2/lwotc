// This is an Unreal Script

class PrimaryMicroLauncher_LoadGrenades extends X2Effect_Persistent;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player) {
	local XComGameState_Unit UnitState;
	local array<XComGameState_Item> ItemStates;
	local XComGameState_Item InventoryItem, WeaponState;
	local X2AbilityTemplateManager AbilityManager;
	local X2AbilityTemplate AbilityTemplate;
			
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityManager.FindAbilityTemplate('LaunchGrenade');

	// Check all of the unit's inventory items
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	ItemStates = UnitState.GetAllInventoryItems(NewGameState);
	WeaponState = UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon);

	foreach ItemStates(InventoryItem) {
		if (InventoryItem.bMergedOut) 
			continue;

		if (X2GrenadeTemplate(InventoryItem.GetMyTemplate()) != none)
		{ 
			`LOG("GRENADE TEMPLATE FOUND WITH NAME: " $ InventoryItem.GetMyTemplate().DataName);
			if ( class'GrimyClassAN_BonusItemCharges'.default.rockets.find(InventoryItem.GetMyTemplateName()) == INDEX_NONE ){
				`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, UnitState, NewGameState, WeaponState.GetReference(), InventoryItem.GetReference());
			}
			else {
				`LOG("But it's a rocket, so not loaded");
			}
		}
	}
	return false;
}