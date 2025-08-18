class X2Effect_LWApplyRegenSmokeToWorld extends X2Effect_LWApplyAdditionalSmokeEffectToWorld;

event array<X2Effect> GetTileEnteredEffects()
{
    local array<X2Effect> TileEnteredEffects;

    TileEnteredEffects.AddItem(class'X2Effect_LWRegenSmoke'.static.RegenSmokeEffect(true));

    return TileEnteredEffects;
}

static function X2Effect_LWApplyAdditionalSmokeEffectToWorld RegenSmokeWorldEffect()
{
    local X2Effect_LWApplyAdditionalSmokeEffectToWorld  Effect;
    local X2Condition_AbilityProperty                   AbilityCondition;

    Effect = new class'X2Effect_LWApplyRegenSmokeToWorld';
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(class'X2Effect_LWRegenSmoke'.default.RelevantAbilityName);
    Effect.TargetConditions.AddItem(AbilityCondition);

    return Effect;
}