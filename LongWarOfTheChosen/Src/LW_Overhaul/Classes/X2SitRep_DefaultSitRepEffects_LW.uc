//---------------------------------------------------------------------------------------
//  FILE:    X2SitRep_DefaultSitRepEffects_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Defines the default set of sit rep effect templates for LWOTC.
//---------------------------------------------------------------------------------------

class X2SitRep_DefaultSitRepEffects_LW extends X2SitRepEffect;

var const name MissionTimerModifierVarName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Ability Granting Effects
	Templates.AddItem(CreateLethargyEffectTemplate());
	Templates.AddItem(CreateTrackingEffectTemplate());
	Templates.AddItem(CreateCombatRushOnCritEffectTemplate());

	// Miscellaneous effects
	Templates.AddItem(CreateIncreaseTimer1EffectTemplate());
	Templates.AddItem(CreateIncreaseTimer2EffectTemplate());
	Templates.AddItem(CreateIncreaseTimer4EffectTemplate());
	Templates.AddItem(CreateTheLostEffectTemplate());

	// Sit rep effects for different levels of underinfiltration
	Templates.AddItem(CreateInfiltrationEasyEffectTemplate());
	Templates.AddItem(CreateInfiltrationModerateEffectTemplate());
	Templates.AddItem(CreateInfiltrationHardEffectTemplate());
	Templates.AddItem(CreateInfiltrationUltraHardEffectTemplate());

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

// ----------------------------------------------------------------------------------------------------------
// Timer Related Effects
// ----------------------------------------------------------------------------------------------------------

static function X2SitRepEffectTemplate CreateIncreaseTimer1EffectTemplate()
{
	local X2SitRepEffect_ModifyTacticalStartState Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyTacticalStartState', Template, 'IncreaseTimer1Effect_LW');
	Template.ModifyTacticalStartStateFn = IncreaseMissionTimerByOneTurn;
	Template.DifficultyModifier = 0;

	return Template;
}

static function X2SitRepEffectTemplate CreateIncreaseTimer2EffectTemplate()
{
	local X2SitRepEffect_ModifyTacticalStartState Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyTacticalStartState', Template, 'IncreaseTimer2Effect_LW');
	Template.ModifyTacticalStartStateFn = IncreaseMissionTimerByTwoTurns;
	Template.DifficultyModifier = 0;

	return Template;
}

static function X2SitRepEffectTemplate CreateIncreaseTimer4EffectTemplate()
{
	local X2SitRepEffect_ModifyTacticalStartState Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_ModifyTacticalStartState', Template, 'IncreaseTimer4Effect_LW');
	Template.ModifyTacticalStartStateFn = IncreaseMissionTimerByFourTurns;
	Template.DifficultyModifier = 0;

	return Template;
}

private static function IncreaseMissionTimerByOneTurn(XComGameState StartState)
{
	ModifyMissionTimerBy(StartState, 1);
}

private static function IncreaseMissionTimerByTwoTurns(XComGameState StartState)
{
	ModifyMissionTimerBy(StartState, 2);
}

private static function IncreaseMissionTimerByFourTurns(XComGameState StartState)
{
	ModifyMissionTimerBy(StartState, 4);
}

private static function ModifyMissionTimerBy(XComGameState StartState, int NumTurns)
{
	local XComGameState_KismetVariableModifier ModifierState;

	// Find any existing modifier for the Timer.LengthDelta variable first
	foreach StartState.IterateByClassType(class'XComGameState_KismetVariableModifier', ModifierState)
	{
		if (ModifierState.VarName == default.MissionTimerModifierVarName)
			break;
		else
			ModifierState = none;
	}

	// Create a new modifier state if there isn't an existing one
	if (ModifierState == none)
	{
		ModifierState = XComGameState_KismetVariableModifier(StartState.CreateNewStateObject(class'XComGameState_KismetVariableModifier'));
		ModifierState.VarName = default.MissionTimerModifierVarName;
	}

	// Modify the state object's delta to apply this timer modifier.
	// Note that we don't have to use `ModifyStateObject()` because
	// this is the start state and we can just change things as we like.
	ModifierState.Delta += NumTurns;
}

// ----------------------------------------------------------------------------------------------------------

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

static function X2SitRepEffectTemplate CreateInfiltrationEasyEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'UnderInfiltrationScalingEasyEffect');
	Template.DifficultyModifier = 2;
	Template.Teams.AddItem(eTeam_Alien);
	Template.AbilityTemplateNames.AddItem('ToughScaling');

	return Template;
}

static function X2SitRepEffectTemplate CreateInfiltrationModerateEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'UnderInfiltrationScalingModerateEffect');
	Template.DifficultyModifier = 4;
	Template.Teams.AddItem(eTeam_Alien);
	Template.AbilityTemplateNames.AddItem('ButchScaling');

	return Template;
}

static function X2SitRepEffectTemplate CreateInfiltrationHardEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'UnderInfiltrationScalingHardEffect');
	Template.DifficultyModifier = 8;
	Template.Teams.AddItem(eTeam_Alien);
	Template.AbilityTemplateNames.AddItem('RockHardScaling');

	return Template;
}

static function X2SitRepEffectTemplate CreateInfiltrationUltraHardEffectTemplate()
{
	local X2SitRepEffect_GrantAbilities Template;

	`CREATE_X2TEMPLATE(class'X2SitRepEffect_GrantAbilities', Template, 'UnderInfiltrationScalingUltraHardEffect');
	Template.DifficultyModifier = 10;
	Template.Teams.AddItem(eTeam_Alien);
	Template.AbilityTemplateNames.AddItem('MonstrousScaling');

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

defaultproperties
{
	MissionTimerModifierVarName = "Timer_LengthDelta"
}
