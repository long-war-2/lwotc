//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityCooldown_LWFlamethrower.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Variable cooldown on flamethrower
//---------------------------------------------------------------------------------------
class X2AbilityCooldown_LWFlamethrower extends X2AbilityCooldown;

var array<name> AbilityModifiers;
var array<int> CooldownModifiers;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local name AbilityName;
	local int idx, TempTurns;
	
	TempTurns = iNumTurns;
	foreach AbilityModifiers(AbilityName, idx)
	{
		if (XComGameState_Unit(AffectState).HasSoldierAbility(AbilityName))
			TempTurns += CooldownModifiers[idx];

	}

	return TempTurns;
}

DefaultProperties
{
	iNumTurns = 2;
}