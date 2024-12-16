// Author: Tedster
// Purpose: new LWoTC chosen actions.
class X2StrategyElement_LWChosenActions extends X2StrategyElement config(GameData);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Actions;

	Actions.AddItem(CreateChosenReinforceTemplate());
	Actions.AddItem(CreateChosenDoNothingTemplate());

	return Actions;
}

static function X2DataTemplate CreateChosenReinforceTemplate()
{
	local X2ChosenActionTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ChosenActionTemplate', Template, 'ChosenAction_ReinforceRegion');
	Template.Category = "ChosenAction";
    Template.OnActivatedFn = ActivateChosenReinforce;
	Template.OnChooseActionDelegate = OnChosenReinforceSelected;
	Template.CanBePlayedFn = CanChosenReinforceActivate;
	

	return Template;
}

static function ActivateChosenReinforce(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
    local StateObjectReference PrimaryRegionRef;
	local XComGameState_LWAlienActivity NewActivityState;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local X2StrategyElementTemplateManager StrategyElementTemplateMgr;

	`LWTrace("Attempting to activate chosen RNF action.");

	StrategyElementTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	ActivityTemplate = X2LWAlienActivityTemplate(StrategyElementTemplateMgr.FindStrategyElementTemplate('ChosenReinforceActivity'));

	`LWTrace("Activity Template found:" @ActivityTemplate);
	// For future reference, this 3rd parameter here gets the State Object for InRef, grabs the object for a StateObjectReference on InRef, which is the ChosenState.
	ActivityTemplate.ActivityCreation.InitActivityCreation(ActivityTemplate, NewGameState, XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectId)).ChosenRef.ObjectId)));
	ActivityTemplate.ActivityCreation.GetNumActivitiesToCreate(NewGameState, XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectId)).ChosenRef.ObjectId)));
	PrimaryRegionRef = ActivityTemplate.ActivityCreation.GetBestPrimaryRegion(NewGameState, XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(XComGameState_ChosenAction(NewGameState.GetGameStateForObjectID(InRef.ObjectId)).ChosenRef.ObjectId)));

	`LWTrace("PrimaryRegionRef:" @PrimaryRegionRef.ObjectID);
	if(PrimaryRegionRef.ObjectID > 0)
	{
		NewActivityState = ActivityTemplate.CreateInstanceFromTemplate(PrimaryRegionRef, NewGameState);
		NewGameState.AddStateObject(NewActivityState);

	}
}

static function OnChosenReinforceSelected(XComGameState NewGameState, XComGameState_ChosenAction ActionState)
{
	`LWTrace("Chosen RNF action selected by a chosen.");
}

// Reimplement global cooldown here.
function bool CanChosenReinforceActivate(StateObjectReference CheckChosenRef, optional XComGameState NewGameState = none)
{
	local X2StrategyElementTemplateManager StratMgr;

	local XComGameState_AdventChosen CheckChosenState;
	local array<XComGameState_AdventChosen> AllChosen;

	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen Chosen;

	local X2ChosenActionTemplate ActionTemplate;

	local int ICooldown, GCooldown;

	`LWTrace("Can Activate Chosen Reinforce called.");

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	if(NewGameState != none)
	{
		CheckChosenState = XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(CheckChosenRef.ObjectID));
	}
	else
	{
		CheckChosenState = XComGameState_AdventChosen(`XCOMHISTORY.GetGameStateForObjectID(CheckChosenRef.ObjectID));
	}

	if (CheckChosenState == NONE)
		return false;

	

	ICooldown = CheckChosenState.GetMonthsSinceAction('ChosenAction_ReinforceRegion');

	AllChosen = AlienHQ.GetAllChosen();

	ActionTemplate = X2ChosenActionTemplate(StratMgr.FindStrategyElementTemplate('ChosenAction_ReinforceRegion'));

	foreach AllChosen(Chosen)
	{
		if(NewGameState != none)
		{
			Chosen = XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(Chosen.ObjectID));
		}
        // The fix is the below line, ChosenState changed to Chosen
		ICooldown = Chosen.GetMonthsSinceAction('ChosenAction_ReinforceRegion');

		//`LWTrace(Chosen.GetMyTemplateName() @ "Months since Reinforce:" @ICooldown);

		if(ICooldown > 0 && (ICooldown < GCooldown || GCooldown <= 0))
		{
			GCooldown = ICooldown;
		}
	}
	//`LWTrace("Global Cooldown:" @GCooldown);

	if(GCooldown > 0 && GCooldown <= ActionTemplate.GlobalCooldown)
	{
		return false;
	}

	return true;

}

static function X2DataTemplate CreateChosenDoNothingTemplate()
{
	local X2ChosenActionTemplate Template;
	`CREATE_X2TEMPLATE(class'X2ChosenActionTemplate', Template, 'ChosenAction_DoNothing');
	Template.Category = "ChosenAction";

	return Template;
}