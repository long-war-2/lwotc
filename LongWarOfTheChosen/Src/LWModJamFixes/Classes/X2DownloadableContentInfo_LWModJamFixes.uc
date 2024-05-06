class X2DownloadableContentInfo_LWModJamFixes extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager  AbilityTemplateManager;

    `LWTrace("LWModJamFixes OPTC firing");
    //  Get the Ability Template Manager.
    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    PatchSolaceBack(AbilityTemplateManager.FindAbilityTemplate('Solace_LW'));
}

static function PatchSolaceBack(X2AbilityTemplate Template)
{
    local int i;

    `LWTrace("Patching template:" @Template.Dataname);

    if(Template != None)
    {
        `LWTrace("Template conditions length:" @Template.AbilityTargetConditions.Length);
        for(i=Template.AbilityTargetConditions.Length-1; i >= 0; i--)
        {
            `LWTrace("Checking targetcondition" @Template.AbilityTargetConditions[i]);
            if(Template.AbilityTargetConditions[i].isa('X2Condition_UnitProperty') && X2Condition_UnitProperty(Template.AbilityTargetConditions[i]).ExcludeFriendlyToSource == true)
            {
                `LWTrace("Removing Condition");
                Template.AbilityTargetConditions.Remove(i,1);
            }
        }
    }
}