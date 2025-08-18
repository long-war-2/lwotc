class X2Effect_LWApplyCombatStimsToWorld extends X2Effect_LWApplyAdditionalSmokeEffectToWorld;

event array<X2Effect> GetTileEnteredEffects()
{
    local array<X2Effect> TileEnteredEffects;

    TileEnteredEffects.AddItem(class'X2Effect_LWCombatStims'.static.CombatStimsEffect(true));

    return TileEnteredEffects;
}

static function X2Effect_LWApplyAdditionalSmokeEffectToWorld CombatStimsWorldEffect()
{
    local X2Effect_LWApplyAdditionalSmokeEffectToWorld  Effect;
    local X2Condition_AbilityProperty                   AbilityCondition;

    Effect = new class'X2Effect_LWApplyCombatStimsToWorld';
    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem(class'X2Effect_LWCombatStims'.default.RelevantAbilityName);
    Effect.TargetConditions.AddItem(AbilityCondition);

    return Effect;
}