//---------------------------------------------------------------------------------------
//  FILE:    X2SitRep_DefaultSitRepEffects_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Defines the default set of sit rep effect templates for LWOTC.
//---------------------------------------------------------------------------------------

class X2SitRep_DefaultSitRepEffects_LW extends X2SitRepEffect;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Ability Granting Effects
	Templates.AddItem(CreateLethargyEffectTemplate());
	Templates.AddItem(CreateTrackingEffectTemplate());
	Templates.AddItem(CreateCombatRushOnCritEffectTemplate());

	// Miscellaneous effects
	Templates.AddItem(CreateTheLostEffectTemplate());

	// Dark Events support
	Templates.AddItem(CreateHighAlertDEEffectTemplate());
	Templates.AddItem(CreateInfiltratorDEEffectTemplate());
	Templates.AddItem(CreateInfiltratorChryssalidDEEffectTemplate());
	Templates.AddItem(CreateRapidResponseDEEffectTemplate());
	Templates.AddItem(CreateReturnFireDEEffectTemplate());
	Templates.AddItem(CreateSealedArmorDEEffectTemplate());
	Templates.AddItem(CreateUndyingLoyaltyDEEffectTemplate());
	Templates.AddItem(CreateVigilanceDEEffectTemplate());

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

static function X2SitRepEffectTemplate CreateTrackingEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'TrackingEffect');
	Template.DifficultyModifier = -5;
	Template.AbilityTemplateNames.AddItem('Hero_Tracking');
	Template.GrantToSoldiers = true;

	return Template;
}

static function X2SitRepEffectTemplate CreateCombatRushOnCritEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'CombatRushOnCritEffect');
	Template.DifficultyModifier = 0;
	Template.AbilityTemplateNames.AddItem('CombatRushOnCrit');
	Template.Teams.AddItem(eTeam_Alien);
	Template.Teams.AddItem(eTeam_XCom);

	return Template;
}

static function X2SitRepEffectTemplate CreateTheLostEffectTemplate()
{
	local X2SitRepEffectTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffectTemplate', Template, 'TheLostSitRepEffect');
	Template.DifficultyModifier = 3;

	return Template;
}

static function X2SitRepEffectTemplate CreateHighAlertDEEffectTemplate()
{
	local X2SitRepEffect_ModifyTacticalStartState Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyTacticalStartState', Template, 'DarkEventHighAlertEffect');
	Template.DifficultyModifier = 2;
	Template.ModifyTacticalStartStateFn = class'X2StrategyElement_XpackDarkEvents'.static.HighAlertTacticalStartModifier;

	return Template;
}

static function X2SitRepEffectTemplate CreateInfiltratorDEEffectTemplate()
{
	local X2SitRepEffectTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffectTemplate', Template, 'DarkEventInfiltratorEffect');
	Template.DifficultyModifier = 7;

	return Template;
}

static function X2SitRepEffectTemplate CreateInfiltratorChryssalidDEEffectTemplate()
{
	local X2SitRepEffectTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffectTemplate', Template, 'DarkEventInfiltratorChryssalidEffect');
	Template.DifficultyModifier = 8;

	return Template;
}

static function X2SitRepEffectTemplate CreateRapidResponseDEEffectTemplate()
{
	local X2SitRepEffectTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffectTemplate', Template, 'DarkEventRapidResponseEffect');
	Template.DifficultyModifier = 10;

	return Template;
}

static function X2SitRepEffectTemplate CreateReturnFireDEEffectTemplate()
{
	local X2SitRepEffectTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffectTemplate', Template, 'DarkEventReturnFireEffect');
	Template.DifficultyModifier = 2;

	return Template;
}

static function X2SitRepEffectTemplate CreateSealedArmorDEEffectTemplate()
{
	local X2SitRepEffectTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffectTemplate', Template, 'DarkEventSealedArmorEffect');
	Template.DifficultyModifier = 3;

	return Template;
}

static function X2SitRepEffectTemplate CreateUndyingLoyaltyDEEffectTemplate()
{
	local X2SitRepEffectTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffectTemplate', Template, 'DarkEventUndyingLoyaltyEffect');
	Template.DifficultyModifier = 8;

	return Template;
}

static function X2SitRepEffectTemplate CreateVigilanceDEEffectTemplate()
{
	local X2SitRepEffectTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffectTemplate', Template, 'DarkEventVigilanceEffect');
	Template.DifficultyModifier = 2;

	return Template;
}
