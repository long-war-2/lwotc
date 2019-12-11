//---------------------------------------------------------------------------------------
//  FILE:    X2LWFactionTemplateMods
//  AUTHOR:  Peter Ledbrook
//
//  PURPOSE: Creates the faction mod templates.
//--------------------------------------------------------------------------------------- 

class X2LWFactionTemplateMods extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateModifyAbilitiesTemplate());
	Templates.AddItem(CreateModifyItemsTemplate());
	return Templates;
}

static function X2LWTemplateModTemplate CreateModifyAbilitiesTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWModTemplate_FactionAbilities', Template, 'UpdateAbilities');
	return Template;
}

static function X2LWTemplateModTemplate CreateModifyItemsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWModTemplate_FactionItems', Template, 'UpdateItems');
	return Template;
}
