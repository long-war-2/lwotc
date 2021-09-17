//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityCooldown_Immolator.uc
//  AUTHOR:  Joshua Bouscher
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2AbilityCooldown_Immolator extends X2AbilityCooldown_Shared;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	if (XComGameState_Unit(AffectState).HasSoldierAbility('LWAutoloaderFuelBsc'))
		return iNumTurns - 1;

	return iNumTurns;
}

DefaultProperties
{
	iNumTurns = 2;
}