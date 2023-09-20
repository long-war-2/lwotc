class X2AbilityCooldown_MindScorch extends X2AbilityCooldown_LocalAndGlobal;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	if (XComGameState_Unit(AffectState).HasSoldierAbility('MindScorchDangerZone'))
		return iNumTurns - 1;

	return iNumTurns;
}