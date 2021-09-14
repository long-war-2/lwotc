class X2Effect_AggregateAmmo extends X2Effect;

//	this effect basically duplicates the functionality of XComGameState_Unit::MergeAmmoAsNeeded().
//	This is necessary because that function runs only if the WeaponTemplate.bMergeAmmo == true, which isn't the case for Rockets.

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit	UnitState;
	local XComGameState_Item	ItemState;
	
	UnitState = XComGameState_Unit(kNewTargetState);
	ItemState = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	
	////`LOG("X2Effect_AggregateAmmo applied to" @ UnitState.GetFullName() @ ItemState.GetMyTemplateName(),, 'IRIROCK');
	if (UnitState != none && ItemState != none)
	{
		////`LOG("Ammo before: " @ ItemState.Ammo,, 'IRIROCK');
		ItemState.Ammo += UnitState.GetBonusWeaponAmmoFromAbilities(ItemState, NewGameState);	//	GetBonusWeaponAmmoFromAbilities in XComGameState_Unit must be unprotected for this to build
		////`LOG("Ammo after: " @ ItemState.Ammo,, 'IRIROCK');
		////`LOG("=========================================",, 'IRIROCK');
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
/*
defaultproperties
{
	EffectName = "IRI_Effect_AggregateRocketAmmo"
}*/