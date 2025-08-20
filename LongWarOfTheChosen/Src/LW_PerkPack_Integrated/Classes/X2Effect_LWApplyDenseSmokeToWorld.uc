class X2Effect_LWApplyDenseSmokeToWorld extends X2Effect_LWApplyAdditionalSmokeEffectToWorld;

event array<X2Effect> GetTileEnteredEffects()
{
    local array<X2Effect> TileEnteredEffects;

    TileEnteredEffects.AddItem(class'X2Effect_LWDenseSmoke'.static.DenseSmokeEffect(true));

    return TileEnteredEffects;
}

defaultproperties
{
    RelevantAbilityName = DenseSmoke
}