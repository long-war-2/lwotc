class X2AbilityCooldown_Banish extends X2AbilityCooldown;

var bool bUseCharges;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{

    if(kAbility.iCharges > 0 && bUseCharges)
    {
        return 1;
    }
    
    if(bUseCharges)
    {
        kAbility = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', kAbility.ObjectID));
        kAbility.iCharges = 1;
    }

    if (XComGameState_Unit(AffectState).HasAbilityFromAnySource('TheBanisher_LW'))
        return iNumTurns - 1;

    return iNumTurns;
}

DefaultProperties
{
    iNumTurns = 2;
}