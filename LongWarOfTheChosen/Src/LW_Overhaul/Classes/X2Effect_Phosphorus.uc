class X2Effect_Phosphorus extends X2Effect_Persistent config(LW_SoldierSkills);

struct BonusShred
{
    var name WeaponTech;
    var int Shred;
};

var config array<BonusShred> ShredPerWeaponTech;

var array<name> AllowedAbilities;
var array<name> AllowedDamageTypes;

function bool ChangeModifyDamageValueForAttacker(
    XComGameState_Effect EffectState,
    out int bIsImmuneToDamage,
    X2Effect_ApplyWeaponDamage WeaponDamageEffect,
    out WeaponDamageValue DamageValue,
    Damageable Target,
    out array<name> AppliedDamageTypes,
    XComGameState_Item SourceWeapon,
    XComGameState_Unit SourceUnit,
    XComGameState_Ability AbilityState)
{
    if (SourceUnit != none)
    {
        if (AllowedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
        {
            if (AllowedDamageTypes.Find(DamageValue.DamageType) != INDEX_NONE)
            {
                if (Target.IsImmuneToDamage(DamageValue.DamageType))
                {
                    bIsImmuneToDamage = 0;
                    AppliedDamageTypes.AddItem(DamageValue.DamageType);
                    return true;
                }
            }
        }
    }

    return false;
}

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local XComGameState_Item            SourceWeapon;
    local X2WeaponTemplate              WeaponTemplate;
    local int                           Index;

    DamageEffect = X2Effect_ApplyWeaponDamage(GetX2Effect(AppliedData.EffectRef));

    if (!DamageEffect.bApplyOnHit)
    {
        return 0;
    }

    if (AllowedAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
    {
        SourceWeapon = AbilityState.GetSourceWeapon();
        if (SourceWeapon != none)
        {
            WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
            if (WeaponTemplate != none)
            {
                Index = ShredPerWeaponTech.Find('WeaponTech', WeaponTemplate.WeaponTech);
                if (Index != INDEX_NONE)
                {
                    return ShredPerWeaponTech[Index].Shred;
                }
            }
        }
    }

    return 0;
}

defaultproperties
{
    EffectName = Phosphorus
    DuplicateResponse = eDupe_Ignore
}
