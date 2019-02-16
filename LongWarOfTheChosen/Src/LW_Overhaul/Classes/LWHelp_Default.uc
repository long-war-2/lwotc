//---------------------------------------------------------------------------------------
//  FILE:    LWHelp_Default
//  AUTHOR:  amineri / Pavonis Interactive
//
//  PURPOSE: Creates help templates
//--------------------------------------------------------------------------------------- 

class LWHelp_Default extends X2StrategyElement config(LW_Overhaul);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<LWHelpTemplate> Templates;
	
	`LWTrace("  >> LWHelp_Default.CreateTemplates()");

    Templates.AddItem(AddHelpTemplate('ResistanceManagement_Help'));
    Templates.AddItem(AddHelpTemplate('OutpostManagement_Help'));
    Templates.AddItem(AddHelpTemplate('Personnel_SquadBarracks_Help'));
    Templates.AddItem(AddHelpTemplate('SquadSelect_Help'));

    return Templates;
}

static function LWHelpTemplate AddHelpTemplate(name HelpName)
{
    local LWHelpTemplate Template;
	`CREATE_X2TEMPLATE(class'LWHelpTemplate', Template, HelpName);
    return Template;
}