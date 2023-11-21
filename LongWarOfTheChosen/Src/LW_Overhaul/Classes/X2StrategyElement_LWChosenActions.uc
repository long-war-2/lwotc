// Author: Tedster
// Purpose: new LWoTC chosen actions.
class X2StrategyElement_LWChosenActions extends X2StrategyElement config(GameData);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Actions;

	Actions.AddItem(CreateTransferStrengthTemplate());

	return Actions;
}

static function X2DataTemplate CreateTransferStrengthTemplate()
{
	local X2ChosenActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ChosenActionTemplate', Template, 'ChosenAction_TransferStrength');
	Template.Category = "ChosenAction";
    Template.OnActivatedFn = ActivateStrengthTransfer;
	

	return Template;
}

static function ActivateStrengthTransfer(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
    
}