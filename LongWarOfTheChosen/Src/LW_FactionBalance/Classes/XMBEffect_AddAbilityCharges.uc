//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_AddAbilityCharges.uc
//  AUTHOR:  xylthixlm
//
//  An effect which adds additional charges to a limited-use ability.
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  InspireAgility
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  XMBEffectUtilities.uc
//---------------------------------------------------------------------------------------
class XMBEffect_AddAbilityCharges extends X2Effect;

var Array<name> AbilityNames;				// List of ability template names that will have charges added
var int BonusCharges;						// Number of bonus charges to add
var int MaxCharges;							// Maximum number of charges after adding bonus. A negative 
											// value means no limit.
var bool bAllowUseAmmoAsCharges;			// Some abilities display the amount of ammo left in place of
											// the ability charges, for example LaunchGrenade. If this is
											// true, this effect will give those abilities extra ammo
											// instead of extra charges.


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit NewUnit;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local StateObjectReference ObjRef;
	local int Charges, NewCharges;
	
	NewUnit = XComGameState_Unit(kNewTargetState);
	if (NewUnit == none)
		return;

	History = `XCOMHISTORY;

	if (class'XMBEffectUtilities'.static.SkipForDirectMissionTransfer(ApplyEffectParameters))
		return;

	foreach NewUnit.Abilities(ObjRef)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ObjRef.ObjectID));
		if (IsValidAbility(AbilityState))
		{
			Charges = bAllowUseAmmoAsCharges ? AbilityState.GetCharges() : AbilityState.iCharges;
			if (MaxCharges < 0 || Charges < MaxCharges)
			{
				NewCharges = Charges + BonusCharges;
				if (MaxCharges >= 0 && NewCharges > MaxCharges)
					NewCharges = MaxCharges;

				AddCharges(AbilityState, NewCharges - Charges, NewGameState);
			}
		}
	}
}

function bool IsValidAbility(XComGameState_Ability AbilityState)
{
	return AbilityNames.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE;
}

simulated function AddCharges(XComGameState_Ability Ability, int Charges, XComGameState NewGameState)
{
	local XComGameState_Item Weapon;
	local X2AbilityTemplate Template;

	Template = Ability.GetMyTemplate();

	`Log("[XMBEffect_AddAbilityCharges] Adding" @ Charges @ "charges to" @ Template.LocFriendlyName);

	if (Template != None && Template.bUseAmmoAsChargesForHUD && bAllowUseAmmoAsCharges)
	{
		if (Ability.SourceAmmo.ObjectID > 0)
		{
			Weapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Ability.SourceAmmo.ObjectID));
			if (Weapon != none)
			{
				Weapon = XComGameState_Item(NewGameState.ModifyStateObject(Weapon.class, Weapon.ObjectID));
				Weapon.Ammo += Charges * Template.iAmmoAsChargesDivisor;
			}
		}
		else
		{
			Weapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Ability.SourceWeapon.ObjectID));
			if (Weapon != none)
			{
				Weapon = XComGameState_Item(NewGameState.ModifyStateObject(Weapon.class, Weapon.ObjectID));
				Weapon.Ammo += Charges * Template.iAmmoAsChargesDivisor;
			}
		}
	}
	else
	{
		Ability = XComGameState_Ability(NewGameState.ModifyStateObject(Ability.class, Ability.ObjectID));
		Ability.iCharges += Charges;
	}
}


defaultproperties
{
	BonusCharges = 1
	MaxCharges = -1
	bAllowUseAmmoAsCharges = true;
}