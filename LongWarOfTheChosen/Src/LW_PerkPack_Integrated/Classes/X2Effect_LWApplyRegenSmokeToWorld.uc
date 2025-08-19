class X2Effect_LWApplyRegenSmokeToWorld extends X2Effect_LWApplyAdditionalSmokeEffectToWorld;

event array<X2Effect> GetTileEnteredEffects()
{
    local array<X2Effect> TileEnteredEffects;

    TileEnteredEffects.AddItem(class'X2Effect_LWRegenSmoke'.static.RegenSmokeEffect(true));

    return TileEnteredEffects;
}

defaultproperties
{
    RelevantAbilityName = RegenSmoke_LW
}