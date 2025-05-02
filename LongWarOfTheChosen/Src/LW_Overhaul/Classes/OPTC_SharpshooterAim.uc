class OPTC_SharpshooterAim extends X2DownloadableContentInfo;

var config(LW_SoldierSkills) array<name> Aim_AllowedAbilities;

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager AbilityTemplateManager;
    local name AbilityName;

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    foreach default.Aim_AllowedAbilities(AbilityName)
    {
        AddSharpshooterAimToAbility(AbilityTemplateManager.FindAbilityTemplate(AbilityName));
    }
}

static function AddSharpshooterAimToAbility(X2AbilityTemplate Template)
{
    local int i;

    if (Template != none)
    {
        for (i = Template.AbilityTargetEffects.Length - 1; i >= 0; i--)
        {
            if (Template.AbilityTargetEffects[i].IsA('X2Effect_SharpshooterAim'))
            {
                Template.AbilityTargetEffects.Remove(i, 1);
            }
        }

        Template.AddTargetEffect(class'X2Effect_SharpshooterAim_LW'.static.SharpshooterAimEffect());
    }
}