class X2Effect_PassiveShredder_LW extends X2Effect_Persistent config(LW_SoldierSkills);

struct BonusShred
{
    var name WeaponTech;
    var int Shred;
};

var config array<BonusShred>    ShredderPerWeaponTech;


function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
    local X2Effect_Shredder         ShredderEffect;
    local XComGameState_Item        SourceWeapon;
    local X2WeaponTemplate          WeaponTemplate;
    local int                       i;

    ShredderEffect = X2Effect_Shredder(GetX2Effect(AppliedData.EffectRef));

    if (ShredderEffect == none)
        return 0;

    if (!ShredderEffect.bApplyOnHit)
        return 0;

    SourceWeapon = AbilityState.GetSourceWeapon();

    if (SourceWeapon == none)
        return 0;

    WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

    if (WeaponTemplate == none)
        return 0;

    i = default.ShredderPerWeaponTech.Find('WeaponTech', WeaponTemplate.WeaponTech);

    if (i == INDEX_NONE)
        return 0;

    switch (default.ShredderPerWeaponTech[i].WeaponTech)
    {
        case 'magnetic':
            return default.ShredderPerWeaponTech[i].Shred - class'X2Effect_Shredder'.default.MagneticShred;

        case 'beam':
            return default.ShredderPerWeaponTech[i].Shred - class'X2Effect_Shredder'.default.BeamShred;

        default:
            return default.ShredderPerWeaponTech[i].Shred - class'X2Effect_Shredder'.default.ConventionalShred;
    }

    return 0;
}


defaultproperties
{
    DuplicateResponse = eDupe_Ignore
    EffectName = "Shredder_LW"
}
