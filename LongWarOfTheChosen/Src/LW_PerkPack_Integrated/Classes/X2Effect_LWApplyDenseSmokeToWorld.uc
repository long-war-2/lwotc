class X2Effect_LWApplyDenseSmokeToWorld extends X2Effect_LWApplyAdditionalSmokeEffectToWorld;

event array<X2Effect> GetTileEnteredEffects()
{
    local array<X2Effect> TileEnteredEffects;

    TileEnteredEffects.AddItem(class'X2Effect_LWDenseSmoke'.static.DenseSmokeEffect(true));

    return TileEnteredEffects;
}

static function X2Effect_LWApplyAdditionalSmokeEffectToWorld DenseSmokeWorldEffect()
{
    local X2Effect_LWApplyAdditionalSmokeEffectToWorld  Effect;
    local X2Condition_AbilityProperty                   AbilityCondition;

    Effect = new class'X2Effect_LWApplyDenseSmokeToWorld';
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(class'X2Effect_LWDenseSmoke'.default.RelevantAbilityName);
    Effect.TargetConditions.AddItem(AbilityCondition);

    return Effect;
}