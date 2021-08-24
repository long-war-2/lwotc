class X2EventListener_XComScamper extends X2EventListener config(Scamper);

var config bool GrantOnlyToRevealer;
var config bool DoNotTriggerOnLost;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListeners());

	return Templates;
}

static function X2EventListenerTemplate CreateListeners()
{
	local X2EventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EventListenerTemplate', Template, 'XComScamper');
	Template.AddEvent('ScamperEnd', OnScamperEnd);
	Template.RegisterInTactical = true;

	return Template;
}

static protected function EventListenerReturn OnScamperEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext, FirstRedAlertContext;
	local XComGameStateContext_XComScamper XComScamperContext;
	local array<int> UnitsConsideredForFirstRedAlert;
	local XComTacticalController TacticalController;
	local XComGameState_Unit InstigatorUnitState;
	local X2TacticalGameRuleset TacticalRules;
	local XComGameState_Ability AbilityState;
	local XComGameState_AIGroup GroupState;
	local XComGameStateHistory History;

	GroupState = XComGameState_AIGroup(EventSource);
	History = `XCOMHISTORY;
	
	if (GroupState == none)
	{
		`RedScreen("XComScamper: Received ScamperEnd without XComGameState_AIGroup - aborting");
		return ELR_NoInterrupt;
	}

	if (
		GroupState.TeamName == eTeam_XCom ||
		GroupState.TeamName == eTeam_Resistance ||
		(default.DoNotTriggerOnLost && GroupState.TeamName == eTeam_TheLost)
	)
	{
		`log("Received ScamperEnd by " $ GroupState.TeamName $ " - ignoring",, 'XComScamper');
		return ELR_NoInterrupt;
	}
	
	TacticalController = XComTacticalController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController());
	TacticalRules = `TACTICALRULES;
	
	if (TacticalRules.GetCachedUnitActionPlayerRef() != TacticalController.ControllingPlayer)
	{
		`log("Received ScamperEnd but currently not XCom turn - ignoring",, 'XComScamper');
		return ELR_NoInterrupt;
	}

	// Find when the first RedAlert was activated for this group
	// Note that XComGameStateContext_RevealAI is useless for this purpose as it's added to history after all player-instigated movements (and reactions to them) are proccessed
	foreach History.IterateContextsByClassType(class'XComGameStateContext_Ability', AbilityContext)
	{
		// A unit can have multiple RedAlerts activated if it ever fell back to another group.
		// As such, this guards against considering reveals of unit's ex-group(s)
		// Note that since we are searching backwards, we will always encounter the RedAlert activation for current group first
		if (UnitsConsideredForFirstRedAlert.Find(AbilityContext.InputContext.SourceObject.ObjectID) != INDEX_NONE) continue;

		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID,, AbilityContext.AssociatedState.HistoryIndex));

		if (AbilityState.GetMyTemplateName() == 'RedAlert' && GroupState.m_arrMembers.Find('ObjectID', AbilityContext.InputContext.SourceObject.ObjectID) != INDEX_NONE)
		{
			if (FirstRedAlertContext == none || AbilityContext.AssociatedState.HistoryIndex < FirstRedAlertContext.AssociatedState.HistoryIndex)
			{
				FirstRedAlertContext = AbilityContext;
			}

			UnitsConsideredForFirstRedAlert.AddItem(AbilityContext.InputContext.SourceObject.ObjectID);

			// Small optimization to prevent needlessly traversing the entire history
			if (UnitsConsideredForFirstRedAlert.Length == GroupState.m_arrMembers.Length) break;
		}
	}

	if (FirstRedAlertContext == none)
	{
		`warn("Failed to find RedAlert activation for scampering group - cannot determine when the scamper has started. Aborting",, 'XComScamper');
		return ELR_NoInterrupt;
	}

	foreach History.IterateContextsByClassType(class'XComGameStateContext_Ability', AbilityContext)
	{
		// If this ability was activated later than when the group was transitioned to red alert, then we don't consider it
		// In particular, this fixes the issue where the unit moves to pick up loot (which is an ability, but it's without movement)
		if (AbilityContext.AssociatedState.HistoryIndex > FirstRedAlertContext.AssociatedState.HistoryIndex) continue;

		InstigatorUnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

		if (InstigatorUnitState != none && InstigatorUnitState.ControllingPlayer == TacticalController.ControllingPlayer && AbilityState.IsAbilityInputTriggered())
		{
			if (AbilityContext.GetMovePathIndex(InstigatorUnitState.ObjectID) == INDEX_NONE)
			{
				`log("Received ScamperEnd but it wasn't caused by player issuing action that involved movement - ignoring",, 'XComScamper');
				return ELR_NoInterrupt;
			}
			else
			{
				// We confirmed that the last player activated ability was some sort of move
				break;
			}
		}
	}

	XComScamperContext = XComGameStateContext_XComScamper(class'XComGameStateContext_XComScamper'.static.CreateXComGameStateContext());
	XComScamperContext.RevealerUnitRef = AbilityContext.InputContext.SourceObject;

	TacticalRules.SubmitGameStateContext(XComScamperContext);

	return ELR_NoInterrupt;
}
