// Code from Merist

class OPTC_Phosphorus extends X2DownloadableContentInfo config(LW_SoldierSkills);

var config array<name> PhosphorusAbilities;

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager AbilityTemplateManager;
    local name AbilityName;

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    foreach default.PhosphorusAbilities(AbilityName)
    {
        AddPhosphorusToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName));
    }
}

static function AddPhosphorusToAbility(X2AbilityTemplate Template)
{
    local X2Effect_ApplyWeaponDamage    DamageEffect;
    local X2Condition_Phosphorus        PhosphorusCondition;
    local X2Effect                      Effect;

    if (Template != none)
    {
        PhosphorusCondition = new class'X2Condition_Phosphorus';
        foreach Template.AbilityTargetEffects(Effect)
        {
            DamageEffect = X2Effect_ApplyWeaponDamage(Effect);
            if (DamageEffect != none)
            {
                if (DamageEffect.bIgnoreBaseDamage && DamageEffect.EffectDamageValue.DamageType == 'Fire')
                {
                    DamageEffect.EffectDamageValue.DamageType = 'Napalm';
                }
                DamageEffect.TargetConditions.AddItem(PhosphorusCondition);
            }
        }
        foreach Template.AbilityMultiTargetEffects(Effect)
        {
            DamageEffect = X2Effect_ApplyWeaponDamage(Effect);
            if (DamageEffect != none)
            {
                if (DamageEffect.bIgnoreBaseDamage && DamageEffect.EffectDamageValue.DamageType == 'Fire')
                {
                    DamageEffect.EffectDamageValue.DamageType = 'Napalm';
                }
                DamageEffect.TargetConditions.AddItem(PhosphorusCondition);
            }
        }
        
    }
}