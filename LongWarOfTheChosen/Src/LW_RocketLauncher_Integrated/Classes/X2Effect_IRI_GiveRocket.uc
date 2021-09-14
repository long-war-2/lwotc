class X2Effect_IRI_GiveRocket extends X2Effect_Persistent dependson(X2Condition_RocketArmedCheck);

//	Most of this class is taken from LW2 AirDrop ability, and then modified where necessary

var name DataName;							// The name of the item template to grant.
var int BaseCharges;						// Number of charges of the item to add.
var int BonusCharges;						// Number of extra charges of the item to add for each item of that type already in the inventory.
var array<name> SkipAbilities;				// List of abilities to not add
var name AnimationToPlay;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2ItemTemplate		ItemTemplate;
	local XComGameState_Unit	NewUnit;
	local XComGameState_Unit	SourceUnit;
	local XComGameState_Ability Ability;
	local XComGameState_Item	ItemState;
	local EArmedRocketStatus	RocketStatus;

	NewUnit = XComGameState_Unit(kNewTargetState);
	if (NewUnit == none) return;

	Ability = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	ItemState = Ability.GetSourceWeapon();
	ItemTemplate = ItemState.GetMyTemplate();

	DataName = ItemTemplate.DataName;
	
	SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	RocketStatus = class'X2Condition_RocketArmedCheck '.static.GetRocketArmedStatus(SourceUnit, ApplyEffectParameters.ItemStateObjectRef.ObjectID);
	
	////`LOG(SourceUnit.GetFullName() @ " is giving the rocket " @ ItemState.ObjectID @ " to " @ NewUnit.GetFullName() @ "status: " @ RocketStatus,, 'IRIROCK');
	AddUtilityItem(NewUnit, ItemTemplate, NewGameState, NewEffectState, RocketStatus);

	//	Disarm this rocket for this unit after Giving it.
	//	-- Done by an ability activated with Post Activation Event.
	//if (RocketStatus > eRocketArmed_DoesNotRequireArming)
	//{
	//	class'X2Effect_DisarmRocket'.static.DisarmThisRocketForUnit(SourceUnit, ApplyEffectParameters.ItemStateObjectRef.ObjectID);
	//}
}

simulated function AddUtilityItem(XComGameState_Unit NewUnit, X2ItemTemplate ItemTemplate, XComGameState NewGameState, XComGameState_Effect NewEffectState, EArmedRocketStatus RocketStatus)
{
	local X2EquipmentTemplate	EquipmentTemplate;
	local X2WeaponTemplate		WeaponTemplate;
	local XComGameState_Item	ItemState;
	local XGUnit				UnitVisualizer;
	local name					AbilityName;
	local X2AbilityTemplateManager	AbilityTemplateMan;
	local X2AbilityTemplate			AbilityTemplate;
	local XComGameStateHistory		History;
	local array<SoldierClassAbilityType> EarnedSoldierAbilities;
	local int idx;
	
	History = `XCOMHISTORY;

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	EquipmentTemplate = X2EquipmentTemplate(ItemTemplate);
	if (EquipmentTemplate == none)
	{
		`RedScreen(`location $": Missing equipment template for" @ DataName);
		return;
	}

	// Check for items that can be merged
	WeaponTemplate = X2WeaponTemplate(EquipmentTemplate);
	if (WeaponTemplate != none && WeaponTemplate.bMergeAmmo)
	{
		for (idx = 0; idx < NewUnit.InventoryItems.Length; idx++)
		{
			ItemState = XComGameState_Item(NewGameState.GetGameStateForObjectID(NewUnit.InventoryItems[idx].ObjectID));
			if (ItemState == none)
				ItemState = XComGameState_Item(History.GetGameStateForObjectID(NewUnit.InventoryItems[idx].ObjectID));
			if (ItemState != none && !ItemState.bMergedOut && ItemState.GetMyTemplate() == WeaponTemplate)
			{
				ItemState = XComGameState_Item(NewGameState.ModifyStateObject(ItemState.class, ItemState.ObjectID));
				ItemState.Ammo += BaseCharges + ItemState.MergedItemCount * BonusCharges;
				return;
			}
		}
	}
	
	//ItemState.Nickname = " ";	//	reset the nickname of the rocket we're passing to another soldier so it can be reprocessed by SpawnRockets animnotify

	if (BaseCharges <= 0)
		return;

	// No items to merge with, so create the item
	ItemState = EquipmentTemplate.CreateInstanceFromTemplate(NewGameState);
	ItemState.Ammo = BaseCharges;
	ItemState.Quantity = 0;  // Flag as not a real item

	// Temporarily turn off equipment restrictions so we can add the item to the unit's inventory
	NewUnit.bIgnoreItemEquipRestrictions = true;

	//	Equip the rocket on the target soldier. The cosmetic rocket will be equipped on them at the same time.
	NewUnit.AddItemToInventory(ItemState, eInvSlot_Utility, NewGameState);

	//	SoldierKitOwner in the rocket's Item State contains the ObjectID of the cosmetic rocket that's linked to it.
	if (ItemState.SoldierKitOwner.ObjectID == 0) `redscreen("X2Effect_IRI_GiveRocket -> Soldier Kit Owner is zero.-Iridar");

	//	Put the Unit Value with the Object ID of the cosmetic rocket on the target soldier.
	//	This Unit Value will be looked at in Weapon Initialized to temporarily move the added rocket to a hidden socket on the soldier's body.
	//	This is necessary, because otherwise the rocket would instantly appear on the soldier's body before the Take Rocket animation had a chance to go through.
	//	The Unit Value will then be looked at at in Spawn Rockets anim notify to move the cosmetic rocket from a hidden socket into its appropriate socket, and then Unit Value is cleared.
	//	The overall lifetime of the Unit Value is less than a second, so it's brief, but heroic.
	NewUnit.SetUnitFloatValue('IRI_Rocket_Value', ItemState.SoldierKitOwner.ObjectID, eCleanup_BeginTactical);

	//	START Arm Rocket and Give Rocket interaction

	//	If the rocket that is being Given was Armed this turn,
	if (RocketStatus > eRocketArmed_ArmedPerm && 
		!class'X2Condition_RocketArmedCheck'.static.DoesSoldierHasArmedNukes(NewUnit))	// And the target soldier does not already have an Armed Nuke
	{
		// then Arm the Given rocket for the target soldier as well.
		class'X2Effect_ArmRocket'.static.ArmThisRocketForUnit(NewUnit, ItemState.ObjectID);
	}
	//	END

	NewUnit.bIgnoreItemEquipRestrictions = false;

	// Update the unit's visualizer to include the new item
	// Note: Normally this should be done in an X2Action, but since this effect is normally used in
	// a PostBeginPlay trigger, we just apply the change immediately.
	UnitVisualizer = XGUnit(NewUnit.GetVisualizer());
	UnitVisualizer.ApplyLoadoutFromGameState(NewUnit, NewGameState);

	NewEffectState.CreatedObjectReference = ItemState.GetReference();

	// Add equipment-dependent soldier abilities
	EarnedSoldierAbilities = NewUnit.GetEarnedSoldierAbilities();
	for (idx = 0; idx < EarnedSoldierAbilities.Length; ++idx)
	{
		AbilityName = EarnedSoldierAbilities[idx].AbilityName;
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);

		if (SkipAbilities.Find(AbilityName) != INDEX_NONE)
			continue;

		// Add utility-item abilities
		if (EarnedSoldierAbilities[idx].ApplyToWeaponSlot == eInvSlot_Utility &&
			EarnedSoldierAbilities[idx].UtilityCat == ItemState.GetWeaponCategory())
		{
			InitAbility(AbilityTemplate, NewUnit, NewGameState, ItemState.GetReference());
		}

		// Add grenade abilities
		/*
		if (AbilityTemplate.bUseLaunchedGrenadeEffects && X2GrenadeTemplate(EquipmentTemplate) != none)
		{
			InitAbility(AbilityTemplate, NewUnit, NewGameState, NewUnit.GetItemInSlot(EarnedSoldierAbilities[idx].ApplyToWeaponSlot, NewGameState).GetReference(), ItemState.GetReference());
		}*/
	}

	// Add abilities from the equipment item itself. Add these last in case they're overridden by soldier abilities.
	foreach EquipmentTemplate.Abilities(AbilityName)
	{
		if (SkipAbilities.Find(AbilityName) != INDEX_NONE)
			continue;

		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);

		InitAbility(AbilityTemplate, NewUnit, NewGameState, ItemState.GetReference());
	}
}

simulated function InitAbility(X2AbilityTemplate AbilityTemplate, XComGameState_Unit NewUnit, XComGameState NewGameState, optional StateObjectReference ItemRef, optional StateObjectReference AmmoRef)
{
	local XComGameState_Ability OtherAbility;
	local StateObjectReference AbilityRef;
	local XComGameStateHistory History;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local name AdditionalAbility;

	History = `XCOMHISTORY;
	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	// Check for ability overrides
	foreach NewUnit.Abilities(AbilityRef)
	{
		OtherAbility = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));

		if (OtherAbility.GetMyTemplate().OverrideAbilities.Find(AbilityTemplate.DataName) != INDEX_NONE)
			return;
	}

	AbilityRef = `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, NewUnit, NewGameState, ItemRef, AmmoRef);

	// Add additional abilities
	foreach AbilityTemplate.AdditionalAbilities(AdditionalAbility)
	{
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AdditionalAbility);

		// Check for overrides of the additional abilities
		foreach NewUnit.Abilities(AbilityRef)
		{
			OtherAbility = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));

			if (OtherAbility.GetMyTemplate().OverrideAbilities.Find(AbilityTemplate.DataName) != INDEX_NONE)
				return;
		}

		AbilityRef = `TACTICALRULES.InitAbilityForUnit(AbilityTemplate, NewUnit, NewGameState, ItemRef, AmmoRef);
	}
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	if (RemovedEffectState.CreatedObjectReference.ObjectID > 0)
		NewGameState.RemoveStateObject(RemovedEffectState.CreatedObjectReference.ObjectID);
}

function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local XComGameState NewGameState;

	NewGameState = UnitState.GetParentGameState();

	if (EffectState.CreatedObjectReference.ObjectID > 0)
		NewGameState.RemoveStateObject(EffectState.CreatedObjectReference.ObjectID);
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	/*local X2Action_PlayAnimation		PlayAnimation;

	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	PlayAnimation.Params.AnimName = AnimationToPlay;*/
	//PlayAnimation.Params.BlendTime = StartAnimBlendTime;
}

defaultproperties
{
	SkipAbilities(0)="IRI_DisplayRocket"
	BaseCharges = 1
}