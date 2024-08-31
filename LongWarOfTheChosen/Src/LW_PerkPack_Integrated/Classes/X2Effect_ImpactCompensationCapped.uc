class X2Effect_ImpactCompensationCapped extends X2Effect_Persistent config(LW_SoldierSkills);

var float DamageModifier;
var float MaxCap;

function float GetPostDefaultDefendingDamageModifier_CH(XComGameState_Effect EffectState, XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const out EffectAppliedData ApplyEffectParameters, float WeaponDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, XComGameState NewGameState)
{
    local array<name> IncomingTypes;
    local int MaxHP, DamageLimit, FinalDamage;
    local float DamageModifierFinal;
    local UnitValue UnitVal;

    WeaponDamageEffect.GetEffectDamageTypes(NewGameState, ApplyEffectParameters, IncomingTypes);
    MaxHP = TargetUnit.GetMaxStat(eStat_HP);

    DamageLimit = MaxHP * MaxCap;

    DamageModifierFinal = DamageModifier;

    if(TargetUnit.HasSoldierAbility('Impenetrable_LW'))
	{
        DamageLimit =- MaxHP * 0.1;
        //DamageModifierFinal += 0.1;
	}


    if (WeaponDamage <= 0)
        return 0;

    if (TargetUnit == none)
        return 0;

    if (MaxHP <= 1)
        return 0;

    TargetUnit.GetUnitValue('DamageThisTurn', UnitVal);

    if (UnitVal.fValue >= DamageLimit)
    {
        return WeaponDamage * -DamageModifier;
    }

    if(UnitVal.fValue + WeaponDamage >= DamageLimit)
    {
        return (WeaponDamage - max(0,(DamageLimit - UnitVal.fValue))) * -DamageModifier;
    }

    if (WeaponDamage >= DamageLimit)
    {
        FinalDamage = -WeaponDamage + DamageLimit;
        return FinalDamage;
    }
}

defaultproperties
{
    bDisplayInSpecialDamageMessageUI = true;
}