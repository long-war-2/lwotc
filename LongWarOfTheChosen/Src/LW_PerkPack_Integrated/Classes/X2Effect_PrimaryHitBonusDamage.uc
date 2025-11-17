class X2Effect_PrimaryHitBonusDamage extends X2Effect_Persistent config(LW_SoldierSkills);

var int BonusDmg;
var bool IncludePistols;
var bool IncludeSOS;
var bool bExcludeNonBaseDamage;

var config array<name> CENTER_MASS_PISTOL_CATEGORIES;

function float GetPreDefaultAttackingDamageModifier_CH(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, float CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, XComGameState NewGameState)
{
    local X2WeaponTemplate                  WeaponTemplate;
    local X2AbilityToHitCalc_StandardAim    StandardAim;

    if (bExcludeNonBaseDamage && WeaponDamageEffect.bIgnoreBaseDamage)
        return 0;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            // Don't apply to grenades
            StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
            if (StandardAim != none && StandardAim.bIndirectFire)
                return 0;

            // Don't apply to rocket abilities and Micro Missles
            if (class'X2Effect_BonusRocketDamage_LW'.default.VALID_ABILITIES.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE || AbilityState.GetMyTemplateName() == 'MicroMissiles')
                return 0;

            if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
            {
                if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
                {
                    return BonusDmg + (BonusDmg / 2);
                }
                else
                {
                    return BonusDmg;
                }
            }

            WeaponTemplate = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
            if (WeaponTemplate != none)
            {
                if (IncludePistols && default.CENTER_MASS_PISTOL_CATEGORIES.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
                {
                    return BonusDmg;
                }
                else if (IncludeSOS && WeaponTemplate.WeaponCat == 'sawedoffshotgun')
                {
                    if (AbilityState.GetMyTemplateName() == 'BothBarrels')
                    {
                        return BonusDmg * 2;
                    }
                    else
                    {
                        return BonusDmg;
                    }
                }
            }
        }
    }
    
    return 0;
}

defaultproperties
{
    bExcludeNonBaseDamage = true
}
