class X2Effect_LWCombatStims extends X2Effect_LWAdditionalSmokeEffect;

var config int AimBonus;
var config int CritBonus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo AimShotModifier;
    local ShotModifierInfo CritShotModifier;

    if (Attacker.IsInWorldEffectTile(default.WorldEffectClass.Name))
    {
        AimShotModifier.ModType = eHit_Success;
        AimShotModifier.Value = default.AimBonus;
        AimShotModifier.Reason = FriendlyName;
        ShotModifiers.AddItem(AimShotModifier);

        CritShotModifier.ModType = eHit_Crit;
        CritShotModifier.Value = default.CritBonus;
        CritShotModifier.Reason = FriendlyName;
        ShotModifiers.AddItem(CritShotModifier);
    }
}

static function X2Effect CombatStimsEffect(optional bool bSkipAbilityCheck)
{
    local X2Effect_LWCombatStims        Effect;
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Condition_UnitProperty      UnitPropertyCondition;

    Effect = new class'X2Effect_LWCombatStims';
    Effect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus,
        default.strEffectBonusName,
        default.strEffectBonusDesc,
        "img:///UILibrary_XPerkIconPack.UIPerk_smoke_shot_2",
        true,,'eAbilitySource_Perk');

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeTurret = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Effect.TargetConditions.AddItem(UnitPropertyCondition);

    if (!bSkipAbilityCheck)
    {
        AbilityCondition = new class'X2Condition_AbilityProperty';
        AbilityCondition.OwnerHasSoldierAbilities.AddItem(class'X2Effect_LWApplyCombatStimsToWorld'.default.RelevantAbilityName);
        Effect.TargetConditions.AddItem(AbilityCondition);
    }

    return Effect;
}

defaultproperties
{
    EffectName = CombatStims_LW
    WorldEffectClass = class'X2Effect_LWApplyCombatStimsToWorld'
}