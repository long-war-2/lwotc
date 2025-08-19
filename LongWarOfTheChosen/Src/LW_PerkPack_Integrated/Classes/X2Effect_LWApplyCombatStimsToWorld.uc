class X2Effect_LWApplyCombatStimsToWorld extends X2Effect_LWApplyAdditionalSmokeEffectToWorld;

event array<X2Effect> GetTileEnteredEffects()
{
    local array<X2Effect> TileEnteredEffects;

    TileEnteredEffects.AddItem(class'X2Effect_LWCombatStims'.static.CombatStimsEffect(true));

    return TileEnteredEffects;
}

defaultproperties
{
    RelevantAbilityName = CombatStims_LW
}