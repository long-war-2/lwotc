//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_LWAlienAI.uc
//  AUTHOR:  amineri / Pavonis Interactive
//---------------------------------------------------------------------------------------
class X2StrategyElement_LWAlienAI extends X2StrategyElement_DefaultAlienAI;



static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> AIComponents;

	`LWTrace("  >> X2StrategyElement_LWAlienAI.CreateTemplates()");
	
	// Actions
	// A: the following four work by using the inherited functions, but which will replace the existing template, using delegates defined in this class
	AIComponents.AddItem(CreateAddFacilityDoomTemplate());
	AIComponents.AddItem(CreateStartGeneratingFortressDoomTemplate());
	AIComponents.AddItem(CreateStopGeneratingFortressDoomTemplate());
	AIComponents.AddItem(CreateAddFortressDoomTemplate());

	AIComponents.AddItem(CreatePlayerInstantLossTemplate()); // this is a new LWS-created action

	// Conditions
	AIComponents.AddItem(CreateAvatarObjectiveNotCompletedTemplate());
	AIComponents.AddItem(CreateDoomMeterFullIncludingHiddenTemplate());

	return AIComponents;
}

static function ModifyAddFortressDoomTemplate()
{
	local X2StrategyElementTemplateManager TemplateMgr;
	local X2AlienStrategyActionTemplate Template;
	
	TemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	Template = X2AlienStrategyActionTemplate(TemplateMgr.FindStrategyElementTemplate('AlienAI_AddFortressDoom'));
	if(Template == none)
		return;

	Template.PerformActionFn = AddFortressDoom;

	//replace the default timer complete condition with the dynamically modifiable one
	Template.Conditions.RemoveItem('AlienAICondition_FortressDoomTimerComplete');
	Template.Conditions.AddItem('AlienAICondition_LWModifiableFortressDoomTimerComplete');
}

static function AddFortressDoom()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	if(AlienHQ != none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("AIAction: AddFortressDoom");
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		NewGameState.AddStateObject(AlienHQ);
	

	OnFortressDoomTimerComplete(AlienHQ, NewGameState);

	// Complete the Avatar reveal project after 3 pips are added to the fortress so players know what they're up against.
	if(AlienHQ.GetCurrentDoom(true) >= 3)
	{
		`LWTrace("Triggering Avatar Project reveal...");
		class'XComGameState_Objective'.static.StartObjectiveByName(NewGameState, 'LW_T2_M1_N2_RevealAvatarProject');
		`XEVENTMGR.TriggerEvent('StartAvatarProjectReveal');
	}

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}

static function OnFortressDoomTimerComplete(XComGameState_HeadquartersAlien AlienHQ, XComGameState NewGameState)
{
	class'XComGameState_LWAlienActivityManager'.static.AddDoomToFortress(NewGameState, AlienHQ.NextFortressDoomToAdd);
	AlienHQ.StartGeneratingFortressDoom();
}

// #######################################################################################
// -------------------- ACTIONS ----------------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreatePlayerInstantLossTemplate()
{
	local X2AlienStrategyActionTemplate Template;

	Template = new class'X2AlienStrategyActionTemplate';
	Template.SetTemplateName('AlienAI_PlayerInstantLoss');
	Template.PerformActionFn = PlayerLossAction;

	// Conditions
	Template.Conditions.AddItem('AlienAICondition_DoomMeterFullIncludingHidden');
	Template.Conditions.AddItem('AlienAICondition_AvatarObjectiveNotCompleted');
	
	return Template;
}

// #######################################################################################
// -------------------- CONDITIONS -------------------------------------------------------
// #######################################################################################

static function X2DataTemplate CreateDoomMeterFullIncludingHiddenTemplate()
{
	local X2AlienStrategyConditionTemplate Template;

	Template = new class'X2AlienStrategyConditionTemplate';
	Template.SetTemplateName('AlienAICondition_DoomMeterFullIncludingHidden');
	Template.IsConditionMetFn = DoomMeterFullIncludingHidden;

	return Template;
}

static function bool DoomMeterFullIncludingHidden()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	// WOTC TODO: Requires LW modifications to XCGS_HeadquartersAlien in highlander
	// return (AlienHQ.GetCurrentDoom(, true) >= AlienHQ.GetMaxDoom());
	return (AlienHQ.GetCurrentDoom() >= AlienHQ.GetMaxDoom());
}

static function X2DataTemplate CreateAvatarObjectiveNotCompletedTemplate()
{
	local X2AlienStrategyConditionTemplate Template;

	Template = new class'X2AlienStrategyConditionTemplate';
	Template.SetTemplateName('AlienAICondition_AvatarObjectiveNotCompleted');
	Template.IsConditionMetFn = AvatarProjectObjectiveNotCompleted;

	return Template;
}

static function bool AvatarProjectObjectiveNotCompleted()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	return !XComHQ.IsObjectiveCompleted('S0_RevealAvatarProject');
}

static function X2DataTemplate CreateModifiableFortressDoomTimerCompleteTemplate()
{
	local X2AlienStrategyConditionTemplate Template;

	Template = new class'X2AlienStrategyConditionTemplate';
	Template.SetTemplateName('AlienAICondition_LWModifiableFortressDoomTimerComplete');
	Template.IsConditionMetFn = ModifiableFortressDoomTimerComplete;

	return Template;
}
static function bool ModifiableFortressDoomTimerComplete()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local TDateTime ModifiedEndDateTime;
	local XComGameState_LWAlienActivityManager ActivityMgr;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	//insert code to adjust the timer
	ActivityMgr = `LWACTIVITYMGR;
	ModifiedEndDateTime = AlienHQ.FortressDoomIntervalEndTime;
	if (ActivityMgr != none)
	{
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(ModifiedEndDateTime, ActivityMgr.GetDoomUpdateModifierHours());
	}
	return (class'X2StrategyGameRulesetDataStructures'.static.LessThan(ModifiedEndDateTime, `STRATEGYRULES.GameTime));
}