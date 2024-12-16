class X2Effect_ImpactCompensationCapped extends X2Effect_Persistent config(LW_SoldierSkills);

var array<float> DamageModifier;
var array<float> MaxCap;

function float GetPostDefaultDefendingDamageModifier_CH(XComGameState_Effect EffectState, XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const out EffectAppliedData ApplyEffectParameters, float WeaponDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, XComGameState NewGameState)
{
    local array<name> IncomingTypes;
    local int MaxHP, DamageLimit, FinalDamage;
    local float DamageModifierFinal;
    local UnitValue UnitVal;

    WeaponDamageEffect.GetEffectDamageTypes(NewGameState, ApplyEffectParameters, IncomingTypes);
    MaxHP = TargetUnit.GetMaxStat(eStat_HP);

    //`LWTrace("ELA: Unit Max HP:" @MaxHP);

    DamageLimit = MaxHP * MaxCap[`TACTICALDIFFICULTYSETTING];

    //`LWTrace("ELA: MaxCap:" @MaxCap[`TACTICALDIFFICULTYSETTING]);

    //`LWTrace("ELA: DamageLimit:" @DamageLimit);

    DamageModifierFinal = DamageModifier[`TACTICALDIFFICULTYSETTING];

    if(TargetUnit.HasSoldierAbility('Impenetrable_LW'))
	{
        DamageLimit -= MaxHP * 0.1;
        //DamageModifierFinal += 0.1;
	}

    //`LWTrace("ELA: DamageLimit After Impenetrable :" @DamageLimit);

    if (WeaponDamage <= 0)
        return 0;

    if (TargetUnit == none)
        return 0;

    if (MaxHP <= 1)
        return 0;

    TargetUnit.GetUnitValue('DamageThisTurn', UnitVal);

    //`LWTrace("Current Damage This Turn:" @string(int(UnitVal.fValue)));

    if (UnitVal.fValue >= DamageLimit)
    {
        //`LWTrace("If statement 1 hit: UnitVal.fValue >= DamageLimit");
        return WeaponDamage * -DamageModifierFinal;
    }

    if(UnitVal.fValue + WeaponDamage >= DamageLimit)
    {
        //`LWTrace("If Statement 2 hit: UnitVal.fValue + WeaponDamage >= DamageLimit");
        return (WeaponDamage - max(0,(DamageLimit - UnitVal.fValue))) * -DamageModifierFinal;
    }

    if (WeaponDamage >= DamageLimit)
    {
        //`LWTrace("If Statement 3 hit: WeaponDamage >= DamageLimit");
        FinalDamage = -WeaponDamage + DamageLimit;
        return FinalDamage;
    }
    
    return 0;
}

defaultproperties
{
    bDisplayInSpecialDamageMessageUI = true;
}