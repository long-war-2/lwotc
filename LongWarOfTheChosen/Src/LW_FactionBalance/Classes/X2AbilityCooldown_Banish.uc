class X2AbilityCooldown_Banish extends X2AbilityCooldown;


simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
    if (XComGameState_Unit(AffectState).HasAbilityFromAnySource('TheBanisher_LW'))
        return iNumTurns - 1;

    return iNumTurns;
}

DefaultProperties
{
    iNumTurns = 2;
}