class X2DownloadableContentInfo_LWModJamFixes extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager  AbilityTemplateManager;

    `LWTrace("LWModJamFixes OPTC firing");
    //  Get the Ability Template Manager.
    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    PatchSolaceBack(AbilityTemplateManager.FindAbilityTemplate('Solace_LW'));
    FixObliterator(AbilityTemplateManager.FindAbilityTemplate('Obliterator'));
    // 2 different collateral damage abilities
    PatchCollateral(AbilityTemplateManager.FindAbilityTemplate('RM_CollateralDamage'));
    PatchCollateral(AbilityTemplateManager.FindAbilityTemplate('Collateral'));
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

static function FixObliterator(X2AbilityTemplate Template)
{
    local X2Effect_MeleeBonusDamage DamageEffect;
    local X2Effect_ToHitModifier HitModEffect;

    if(Template != none)
    {

        Template.AbilityTargetEffects.Length = 0;

        DamageEffect = new class'X2Effect_MeleeBonusDamage';
	    DamageEffect.BonusDamageFlat = 2;
	    DamageEffect.BuildPersistentEffect(1, true, false, false);
	    DamageEffect.EffectName = 'Obliterator';
    	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
    	Template.AddTargetEffect(DamageEffect);

    	HitModEffect = new class'X2Effect_ToHitModifier';
    	HitModEffect.AddEffectHitModifier(eHit_Success, 20, Template.LocFriendlyName, , true, false, true, true);
    	HitModEffect.BuildPersistentEffect(1, true, false, false);
    	HitModEffect.EffectName = 'ObliteratorAim';
    	Template.AddTargetEffect(HitModEffect);
    }
}

// Swap their targeting to LW's more forgiving targeting
static function PatchCollateral(X2AbilityTemplate Template)
{
    if(Template != none)
    {
        Template.TargetingMethod = class'LW_PerkPack_Integrated.X2TargetingMethod_Collateral';
    }
}