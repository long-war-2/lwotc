// Tedster - a copy of X2AbilityCooldown_RunAndGun_LW.uc also from LW2

class X2AbilityCooldown_SparkMelee extends X2AbilityCooldown;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	// When an ability invokes this function, check if the soldier has Concussive Strike
	if (XComGameState_Unit(AffectState).HasAbilityFromAnySource('ConcussiveStrike_LW'))
	{
		// If yes, set the ability's cooldown to three minus one (two, for people who failed kindergarten)
		return iNumTurns - 1;
	}
	// If no, set the ability's cooldown to three
	return iNumTurns;
}
