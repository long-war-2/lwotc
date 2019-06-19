//---------------------------------------------------------------------------------------
//  FILE:    LWTemplateMods_Utilities
//  AUTHOR:  tracktwo and Amineri / Pavonis Interactive
//
//  PURPOSE: Early game hook to allow template modifications.
//--------------------------------------------------------------------------------------- 

class LWTemplateMods_Utilities extends Object;

static function UpdateTemplates()
{
    local X2StrategyElementTemplateManager		StrategyTemplateMgr;
    local X2AbilityTemplateManager				AbilityTemplateMgr;
    local X2CharacterTemplateManager			CharacterTemplateMgr;
    local X2ItemTemplateManager					ItemTemplateMgr;
    local X2MissionNarrativeTemplateManager		NarrativeTemplateMgr;
	local X2SoldierClassTemplateManager			SoldierClassTemplateMgr;
    local X2HackRewardTemplateManager           HackRewardTemplateMgr;

    local array<X2StrategyElementTemplate>		TemplateMods;
    local X2LWTemplateModTemplate				ModTemplate;
    local int idx;

	`LWTrace("Template Mods: Starting Template Modifications");

	//retrieve all needed template managers
    StrategyTemplateMgr		= class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
    AbilityTemplateMgr		= class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
    CharacterTemplateMgr	= class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
    ItemTemplateMgr			= class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	NarrativeTemplateMgr	= class'X2MissionNarrativeTemplateManager'.static.GetMissionNarrativeTemplateManager();
	SoldierClassTemplateMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
    HackRewardTemplateMgr   = class'X2HackRewardTemplateManager'.static.GetHackRewardTemplateManager();

    TemplateMods = StrategyTemplateMgr.GetAllTemplatesOfClass(class'X2LWTemplateModTemplate');
    for (idx = 0; idx < TemplateMods.Length; ++idx)
    {
        ModTemplate = X2LWTemplateModTemplate(TemplateMods[idx]);
        if (ModTemplate.AbilityTemplateModFn != none)
        {
			`LWTrace("Template Mods: Updating Ability Templates for " $ ModTemplate.DataName);
            PerformAbilityTemplateMod(ModTemplate, AbilityTemplateMgr);
        }
		if (ModTemplate.CharacterTemplateModFn != none)
        {
			`LWTrace("Template Mods: Updating Character Templates for " $ ModTemplate.DataName);
            PerformCharacterTemplateMod(ModTemplate, CharacterTemplateMgr);
        }
        if (ModTemplate.ItemTemplateModFn != none)
        {
			`LWTrace("Template Mods: Updating Item Templates for " $ ModTemplate.DataName);
            PerformItemTemplateMod(ModTemplate, ItemTemplateMgr);
        }
		if (ModTemplate.StrategyElementTemplateModFn != none)
		{
			`LWTrace("Template Mods: Updating Strategy Templates for " $ ModTemplate.DataName);
			PerformStrategyElementTemplateMod(ModTEmplate, StrategyTemplateMgr);
		}
        if (ModTemplate.MissionNarrativeTemplateModFn != none)
        {
			`LWTrace("Template Mods: Updating Narrative Templates for " $ ModTemplate.DataName);
            PerformMissionNarrativeTemplateMod(ModTemplate, NarrativeTemplateMgr);
        }
		if (ModTemplate.SoldierClassTemplateModFn != none)
		{
			`LWTrace("Template Mods: Updating SoldierClass Templates for " $ ModTemplate.DataName);
			PerformSoldierClassTemplateMod(ModTemplate, SoldierClassTemplateMgr);
		}
        if (ModTemplate.HackRewardTemplateModFn != none)
        {
            `LWTrace("Template mods: Updating HackReward templates for " $ ModTemplate.DataName);
            PerformHackRewardTemplateMod(ModTemplate, HackRewardTemplateMgr);
        }
    }
	`LWTrace("Template Mods: Parsed " $ TemplateMods.Length $ " TemplateMods");
}

static function PerformAbilityTemplateMod(X2LWTemplateModTemplate Template, X2DataTemplateManager TemplateManager)
{
    local X2AbilityTemplate AbilityTemplate;
    local array<Name> TemplateNames;
    local Name TemplateName;
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
    local int Difficulty;

    TemplateManager.GetTemplateNames(TemplateNames);

    foreach TemplateNames(TemplateName)
    {
		TemplateManager.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
		foreach DataTemplates(DataTemplate)
		{
			AbilityTemplate = X2AbilityTemplate(DataTemplate);
			if(AbilityTemplate != none)
			{
				Difficulty = GetDifficultyFromTemplateName(TemplateName);
				Template.AbilityTemplateModFn(AbilityTemplate, Difficulty);
			}
		}
    }
}

static function PerformCharacterTemplateMod(X2LWTemplateModTemplate Template, X2DataTemplateManager TemplateManager)
{
    local X2CharacterTemplate CharacterTemplate;
    local array<Name> TemplateNames;
    local Name TemplateName;
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
    local int Difficulty;
    
    TemplateManager.GetTemplateNames(TemplateNames);

    foreach TemplateNames(TemplateName)
    {
		TemplateManager.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
		foreach DataTemplates(DataTemplate)
		{
			CharacterTemplate = X2CharacterTemplate(DataTemplate);
			if(CharacterTemplate != none)
			{
				Difficulty = GetDifficultyFromTemplateName(TemplateName);
				Template.CharacterTemplateModFn(CharacterTemplate, Difficulty);
			}
		}
    }
}

static function PerformItemTemplateMod(X2LWTemplateModTemplate Template, X2ItemTemplateManager TemplateManager)
{
    local X2ItemTemplate ItemTemplate;
    local array<Name> TemplateNames;
    local Name TemplateName;
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
    local int Difficulty;

	TemplateManager.GetTemplateNames(TemplateNames);

	foreach TemplateNames(TemplateName)
	{
		TemplateManager.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
		foreach DataTemplates(DataTemplate)
		{
			ItemTemplate = X2ItemTemplate(DataTemplate);
			if (ItemTemplate != none)
			{
				Difficulty = GetDifficultyFromTemplateName(TemplateName);
				Template.ItemTemplateModFn(ItemTemplate, Difficulty);
			}
		}
	}
}

static function PerformStrategyElementTemplateMod(X2LWTemplateModTemplate Template, X2DataTemplateManager TemplateManager)
{
	local X2StrategyElementTemplate StrategyTemplate;
	local array<Name> TemplateNames;
	local Name TemplateName;
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
    local int Difficulty;

    TemplateManager.GetTemplateNames(TemplateNames);
	
	foreach TemplateNames(TemplateName)
	{
 		TemplateManager.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
		foreach DataTemplates(DataTemplate)
		{
			StrategyTemplate = X2StrategyElementTemplate(DataTemplate);
			if(StrategyTemplate != none)
			{
				Difficulty = GetDifficultyFromTemplateName(TemplateName);
				Template.StrategyElementTemplateModFn(StrategyTemplate, Difficulty);
			}
		}
	}
}

static function PerformMissionNarrativeTemplateMod(X2LWTemplateModTemplate Template, X2DataTemplateManager TemplateManager)
{
    local X2MissionNarrativeTemplate NarrativeTemplate;
	local array<Name> TemplateNames;
	local Name TemplateName;
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
    //local int Difficulty;

    TemplateManager.GetTemplateNames(TemplateNames);

	foreach TemplateNames(TemplateName)
	{
 		TemplateManager.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
		foreach DataTemplates(DataTemplate)
		{
			NarrativeTemplate = X2MissionNarrativeTemplate(DataTemplate);
			if(NarrativeTemplate != none)
			{
				//Difficulty = GetDifficultyFromTemplateName(TemplateName);
				Template.MissionNarrativeTemplateModFn(NarrativeTemplate);
			}
		}
	}
}

static function PerformHackRewardTemplateMod(X2LWTemplateModTemplate Template, X2HackRewardTemplateManager TemplateManager)
{
    local X2HackRewardTemplate HackRewardTemplate;
    local array<Name> TemplateNames;
    local Name TemplateName;
    local array<X2DataTemplate> DataTemplates;
    local X2DataTemplate DataTemplate;
    local int Difficulty;

    TemplateManager.GetTemplateNames(TemplateNames);

    foreach TemplateNames(TemplateName)
    {
        TemplateManager.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
        foreach DataTemplates(DataTemplate)
        {
            HackRewardTemplate = X2HackRewardTemplate(DataTemplate);
            if (HackRewardTemplate != none)
            {
                Difficulty = GetDifficultyFromTemplateName(TemplateName);
                Template.HackRewardTemplateModFn(HackRewardTemplate, Difficulty);
            }
        }
    }
}

static function PerformSoldierClassTemplateMod(X2LWTemplateModTemplate Template, X2DataTemplateManager TemplateManager)
{
	local X2SoldierClassTemplate SoldierClassTemplate;
	local array<Name> TemplateNames;
	local Name TemplateName;
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
    local int Difficulty;

    TemplateManager.GetTemplateNames(TemplateNames);
	
	foreach TemplateNames(TemplateName)
	{
 		TemplateManager.FindDataTemplateAllDifficulties(TemplateName, DataTemplates);
		foreach DataTemplates(DataTemplate)
		{
			SoldierClassTemplate = X2SoldierClassTemplate(DataTemplate);
			if(SoldierClassTemplate != none)
			{
				Difficulty = GetDifficultyFromTemplateName(TemplateName);
				Template.SoldierClassTemplateModFn (SoldierClassTemplate, Difficulty);
			}
		}
	}
}

//=================================================================================
//================= UTILITY CLASSES ===============================================
//=================================================================================

static function int GetDifficultyFromTemplateName(name TemplateName)
{
	return int(GetRightMost(string(TemplateName)));
}


