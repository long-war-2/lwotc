//---------------------------------------------------------------------------------------
//  I STOLE THIS FROM LONG WAR 2. I TAKE NO CREDIT FOR INVENTING THIS.
//  ORIGINAL FILE:    X2AbilityCooldown_RunAndGun_LW.uc
//  ORIGINAL AUTHOR:  Amineri (Pavonis Interactive)
//---------------------------------------------------------------------------------------
class X2AbilityCooldown_Grapple extends X2AbilityCooldown config(GameData_SoldierSkills);

// Set up config values so users can edit this
var config int GRAPPLE_COOLDOWN;
var config int PARKOUR_COOLDOWN_REDUCTION;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	// When an ability invokes this function, check if the soldier has Parkour
	if (XComGameState_Unit(AffectState).HasSoldierAbility('Parkour'))
	{
		// If yes, set the ability's cooldown to three minus one (two, for people who failed kindergarten)
		return default.GRAPPLE_COOLDOWN - default.PARKOUR_COOLDOWN_REDUCTION;
	}
	// If no, set the ability's cooldown to three
	return default.GRAPPLE_COOLDOWN;
}

