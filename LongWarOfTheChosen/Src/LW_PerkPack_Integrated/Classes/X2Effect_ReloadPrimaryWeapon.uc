//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_ReloadPrimaryWeapon.uc
//  AUTHOR:  Grobobobo/Taken  from Favid
//  PURPOSE: Effect that reloads primary weapon.
//---------------------------------------------------------------------------------------
class X2Effect_ReloadPrimaryWeapon extends X2Effect;

var int AmmoToReload;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item WeaponState, NewWeaponState;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	if (TargetUnit != none)
	{
		WeaponState = TargetUnit.GetItemInSlot(eInvSlot_PrimaryWeapon, NewGameState);
		if (WeaponState != none)
		{
			NewWeaponState = XComGameState_Item(NewGameState.ModifyStateObject(WeaponState.Class, WeaponState.ObjectID));
			if (NewWeaponState.Ammo < WeaponState.GetClipSize())
			{
				NewWeaponState.Ammo += Min(AmmoToReload, WeaponState.GetClipSize() - NewWeaponState.Ammo);
			}
		}
	}
}
