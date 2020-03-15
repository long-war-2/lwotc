//---------------------------------------------------------------------------------------
//  FILE:    X2SitRep_DefaultSitRepEffects_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Defines the default set of sit rep effect templates for LWOTC.
//---------------------------------------------------------------------------------------

class X2SitRep_DefaultSitRepEffects_LW extends X2SitRepEffect;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Intro VO Effects
	
	// Squad Size Effects

	// Timer Effects

	// Spawned Object Effects
	
	// Alert Level Delta Effects

	// Alert Level Clamping Effects

	// Force Level Delta Effects

	// Enemy Pod Size Effects

	// Reinforcements Effects

	// Rank Limit Effects

	// Ability Granting Effects
	Templates.AddItem(CreateLethargyEffectTemplate());

	// Alien Squad Effects

	// Miscellaneous effects
	
	// Resistance Policies support

	// Dark Events support
	
	return Templates;
}

static function X2SitRepEffectTemplate CreateLethargyEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'LethargyEffect');
	Template.DifficultyModifier = 10;
	Template.AbilityTemplateNames.AddItem('Lethargy');

	return Template;
}
