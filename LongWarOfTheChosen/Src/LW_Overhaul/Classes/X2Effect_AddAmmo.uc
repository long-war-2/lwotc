//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_AddAmmo.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Effect adds a specified amount of ammo to the associated secondary weapon
//---------------------------------------------------------------------------------------
class X2Effect_AddAmmo extends X2Effect;

var int ExtraAmmoAmount;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item WeaponState, NewWeaponState;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
		WeaponState = TargetUnit.GetItemInSlot(eInvSlot_SecondaryWeapon, NewGameState);
		if (WeaponState != none)
		{
			NewWeaponState = XComGameState_Item(NewGameState.CreateStateObject(WeaponState.Class, WeaponState.ObjectID));
			NewWeaponState.Ammo += ExtraAmmoAmount;
			NewGameState.AddStateObject(NewWeaponState);
		}
	}
}
