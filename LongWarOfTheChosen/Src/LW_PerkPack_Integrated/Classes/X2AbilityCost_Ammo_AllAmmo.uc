class X2AbilityCost_Ammo_AllAmmo extends X2AbilityCost_Ammo;

simulated function int CalcAmmoCost(XComGameState_Ability Ability, XComGameState_Item ItemState, XComGameState_BaseObject TargetState)
{
    return Ability.GetSourceAmmo().Ammo;
}