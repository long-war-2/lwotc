class X2Effect_LWDenseSmoke extends X2Effect_LWAdditionalSmokeEffect;

var config int DefenseBonus; // Keep this positive

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotMod;

    if (Target.IsInWorldEffectTile(default.WorldEffectClass.Name))
    {
        ShotMod.ModType = eHit_Success;
        ShotMod.Value = -1 * default.DefenseBonus; // negative
        ShotMod.Reason = FriendlyName;
        ShotModifiers.AddItem(ShotMod);
    }
}

static function X2Effect DenseSmokeEffect(optional bool bSkipAbilityCheck)
{
    local X2Effect_LWDenseSmoke         Effect;
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Condition_UnitProperty      UnitPropertyCondition;

    Effect = new class'X2Effect_LWDenseSmoke';
    Effect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus,
        default.strEffectBonusName,
        default.strEffectBonusDesc,
        "img:///UILibrary_LW_PerkPack.LW_AbilityDenseSmoke",
        true,,'eAbilitySource_Perk');

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.FailOnNonUnits = true;
    Effect.TargetConditions.AddItem(UnitPropertyCondition);

    if (!bSkipAbilityCheck)
    {
        AbilityCondition = new class'X2Condition_AbilityProperty';
        AbilityCondition.OwnerHasSoldierAbilities.AddItem(class'X2Effect_LWApplyDenseSmokeToWorld'.default.RelevantAbilityName);
        Effect.TargetConditions.AddItem(AbilityCondition);
    }

    return Effect;
}

defaultproperties
{
    EffectName = DenseSmoke
    WorldEffectClass = class'X2Effect_LWApplyDenseSmokeToWorld'
}