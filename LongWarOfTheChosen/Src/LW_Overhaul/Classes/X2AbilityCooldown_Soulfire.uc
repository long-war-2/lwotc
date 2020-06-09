//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityCooldown_Soulfire.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Makes Soul Steal INCREASE the soulfire's cooldown.
//---------------------------------------------------------------------------------------
class X2AbilityCooldown_Soulfire extends X2AbilityCooldown;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	if (XComGameState_Unit(AffectState).HasSoldierAbility('SoulSteal'))
		return iNumTurns + 1;

	return iNumTurns;
}

DefaultProperties
{
	iNumTurns = 2;
}