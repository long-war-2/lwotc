//---------------------------------------------------------------------------------------
//  FILE:    X2LWMoveThenActFix.uc
//  PURPOSE: Fix for "move then act" abilities (TypicalMoveEndAbility_* : a move followed
//           by a follow-up action) that become invalid in the middle of the move
//           (Burning, Stunned, ...).
//
//           Without this fix the engine's interrupt chain simply gives up (Validate()
//           fails), so no resume state is created:
//             - the visualization has no final state (long stall before the turn continues)
//             - UnitMoveFinished never fires (bWaitingOnEndMoveEvent stays true, so
//               enemy scamper behavior trees never start)
//
//           What this fix does:
//             - finishes the move (the unit ends up at its destination tile)
//             - skips the follow-up action and its rewards (Focus, Momentum, ...)
//             - keeps the follow-up action animation from playing
//             - still fires ObjectMoved + UnitMoveFinished through the resume state
//             - if the unit can no longer act (dead / stunned / panicked / ...) it stops
//               the movement where it was hit (the interrupted state stays the last visual
//               state, exactly like vanilla) and only releases the AI gate
//
//           Only abilities listed in the config whitelist are patched:
//             Config/XComLW_Overhaul.ini -> [LW_Overhaul.X2LWMoveThenActFix] -> +AllowedAbilities=...
//---------------------------------------------------------------------------------------
class X2LWMoveThenActFix extends Object config(LW_Overhaul);

// Master switch (config)
var config bool bEnabled;

// Whether the aborted ability still spends its costs (action points, charges, cooldown).
// true  = costs are charged (default)
// false = the aborted move-then-act ability is completely free
var config bool bApplyCostOnSkip;

// Whitelist (config): only these abilities are patched
var config array<name> AllowedAbilities;

// Marker stored on the unit. Values:
//   0 = normal (follow-up action applied)
//   1 = move finished, follow-up action skipped -> visualize as a plain move
var name NoAttackMarker;

//----------------------------------------------------------------------------------------
// Templates patching
//----------------------------------------------------------------------------------------
static function PatchTemplates()
{
	local X2AbilityTemplateManager TemplateMgr;
	local X2DataTemplate DataTemplate;
	local X2AbilityTemplate Template;
	local X2AbilityTrigger Trigger;
	local X2AbilityTrigger_EventListener EventListener;
	local X2Condition_UnitValue Cond;
	local array<name> FollowupEvents;
	local name EventName;

	if (!default.bEnabled)
	{
		`log("X2LWMoveThenActFix: disabled by config");
		return;
	}

	`log("X2LWMoveThenActFix: enabled, whitelist=" $ default.AllowedAbilities.Length);

	if (default.AllowedAbilities.Length == 0)
	{
		return;
	}

	TemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	// ---------- Pass 1: wrap whitelisted abilities and collect their PostActivationEvents ----------
	foreach TemplateMgr.IterateTemplates(DataTemplate, none)
	{
		Template = X2AbilityTemplate(DataTemplate);
		if (Template == none)
			continue;

		if (default.AllowedAbilities.Find(Template.DataName) == INDEX_NONE)
			continue;

		// A custom ModifyNewContextFn cannot be chained, so such abilities are skipped
		if (Template.ModifyNewContextFn != none)
		{
			`log("X2LWMoveThenActFix: SKIP" @ Template.DataName @ "(already has ModifyNewContextFn)");
			continue;
		}

		Template.ModifyNewContextFn        = class'X2LWMoveThenActFix'.static.ModifyNewContext;
		Template.BuildInterruptGameStateFn = class'X2LWMoveThenActFix'.static.BuildInterruptGameState;
		Template.BuildVisualizationFn      = class'X2LWMoveThenActFix'.static.BuildVisualization;

		// Collect the post-activation events of THIS ability so that its follow-up
		// abilities (Focus, Momentum, FirestormActivation, ...) can be guarded
		foreach Template.PostActivationEvents(EventName)
		{
			if (FollowupEvents.Find(EventName) == INDEX_NONE)
				FollowupEvents.AddItem(EventName);
		}

		`log("X2LWMoveThenActFix: PATCHED" @ Template.DataName);
	}

	// ---------- Pass 2: abilities listening to those post-activation events must not
	//            trigger when the ability was aborted ----------
	foreach TemplateMgr.IterateTemplates(DataTemplate, none)
	{
		Template = X2AbilityTemplate(DataTemplate);
		if (Template == none)
			continue;

		foreach Template.AbilityTriggers(Trigger)
		{
			EventListener = X2AbilityTrigger_EventListener(Trigger);
			if (EventListener == none)
				continue;
			if (FollowupEvents.Find(EventListener.ListenerData.EventID) == INDEX_NONE)
				continue;

			Cond = new class'X2Condition_UnitValue';
			Cond.AddCheckValue(default.NoAttackMarker, 0, eCheck_Exact);
			Template.AbilityShooterConditions.AddItem(Cond);
			break;
		}
	}
}

//----------------------------------------------------------------------------------------
// On activation: allow the engine to skip mid-move re-validation when the ability
// was valid at activation time; also clear the marker left by a previous activation
//----------------------------------------------------------------------------------------
static function ModifyNewContext(XComGameStateContext Context)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit Unit;
	local XComGameState_Ability Ability;

	AbilityContext = XComGameStateContext_Ability(Context);
	if (AbilityContext == none)
		return;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	Ability = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

	if (Unit == none || Ability == none)
		return;

	// If the ability is valid at activation, let it continue even if it becomes invalid
	// mid-move (otherwise the engine abandons the whole interrupt chain).
	// If it is already invalid at activation, keep normal validation so the engine rejects it.
	AbilityContext.bSkipValidation = (Ability.CanActivateAbility(Unit) == 'AA_Success');

	Unit.SetUnitFloatValue(default.NoAttackMarker, 0, eCleanup_BeginTurn);
}

//----------------------------------------------------------------------------------------
// Visualization: states carrying marker 1 are visualized as a plain move
//----------------------------------------------------------------------------------------
static function BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateContext_Ability Context;
	local XComGameState_Unit Unit;
	local UnitValue Value;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	if (Context != none)
	{
		Unit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
		if (Unit != none && Unit.GetUnitValue(default.NoAttackMarker, Value) && Value.fValue > 0.0)
		{
			// Move only: no follow-up action animation (melee swing, arc wave, ...)
			class'X2Ability_DefaultAbilitySet'.static.MoveAbility_BuildVisualization(VisualizeGameState);
			return;
		}
	}

	class'X2Ability'.static.TypicalAbility_BuildVisualization(VisualizeGameState);
}

//----------------------------------------------------------------------------------------
// Interrupt / resume state building
//----------------------------------------------------------------------------------------
static function XComGameState BuildInterruptGameState(XComGameStateContext Context, int InterruptStep, EInterruptionStatus InterruptionStatus)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit Unit;
	local bool bCannotAct;

	AbilityContext = XComGameStateContext_Ability(Context);
	if (AbilityContext == none)
		return none;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

	bCannotAct = (Unit != none && (Unit.IsDead() || Unit.bRemovedFromPlay || Unit.IsIncapacitated()
		|| Unit.IsBleedingOut() || Unit.IsStunned() || Unit.IsDazed() || Unit.IsPanicked()));

	if (bCannotAct)
	{
		// Only release the gate if it is actually set (i.e. a reveal queued a scamper)
		if (`BEHAVIORTREEMGR.bWaitingOnEndMoveEvent)
		{
			`BEHAVIORTREEMGR.bWaitingOnEndMoveEvent = false;
			`BEHAVIORTREEMGR.TryUpdateBTQueue();
		}

		// Interrupt: stop building further movement states. Otherwise ObjectMoved keeps
		// firing for tiles the unit never reaches, which reveals (and pans the camera to)
		// pods that are only visible from the destination tile.
		return none;
	}

	if (InterruptionStatus == eInterruptionStatus_Resume
		&& AbilityState != none
		&& AbilityState.GetMyTemplate() != none
		&& AbilityState.GetMyTemplate().Hostility != eHostility_Movement)
	{
		return BuildResumeState(AbilityContext, InterruptStep);
	}

	return class'X2Ability'.static.TypicalMoveEndAbility_BuildInterruptGameState(Context, InterruptStep, InterruptionStatus);
}

//----------------------------------------------------------------------------------------
// Build the resume state
//----------------------------------------------------------------------------------------
static function XComGameState BuildResumeState(XComGameStateContext_Ability AbilityContext, int InterruptStep)
{
	local XComGameState NewGameState;
	local XComGameStateContext_Ability NewContext;
	local XComGameState_Ability AbilityState;
	local XComGameState_Ability CostAbilityState;
	local XComGameState_Unit NewUnit;
	local bool bSkipAttack;

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, AbilityContext);
	NewContext = XComGameStateContext_Ability(NewGameState.GetContext());

	// Apply the whole move (including tile-entered effects such as Burning) and trigger
	// ObjectMoved + UnitMoveFinished
	class'X2Ability_DefaultAbilitySet'.static.MoveAbility_FillOutGameState(NewGameState, false);

	NewContext.SetInterruptionStatus(eInterruptionStatus_Resume);
	NewContext.ResultContext.InterruptionStep = InterruptStep;

	// The ability state is not copied into the new state by MoveAbility_FillOutGameState,
	// so fall back to the history version when it is missing
	AbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(NewContext.InputContext.AbilityRef.ObjectID));
	if (AbilityState == none)
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(NewContext.InputContext.AbilityRef.ObjectID));

	NewUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(NewContext.InputContext.SourceObject.ObjectID));

	bSkipAttack = ShouldSkipAttack(NewUnit, AbilityState);
	if (NewUnit != none)
	{
		// Move completed; marker 1 = visualize the move, skip the follow-up action
		NewUnit.SetUnitFloatValue(default.NoAttackMarker, bSkipAttack ? 1 : 0, eCleanup_BeginTurn);
	}

	if (bSkipAttack)
	{
		// Costs (action points, charges, cooldown) are only charged when bApplyCostOnSkip
		// is enabled.
		//
		// IMPORTANT: apply the cost to the ability state INSIDE NewGameState, otherwise
		// charges/cooldown would be written to the history object directly.
		if (default.bApplyCostOnSkip && NewUnit != none && AbilityState != none && AbilityState.GetMyTemplate() != none)
		{
			CostAbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(
				class'XComGameState_Ability', NewContext.InputContext.AbilityRef.ObjectID));

			if (CostAbilityState != none && CostAbilityState.GetMyTemplate() != none)
				CostAbilityState.GetMyTemplate().ApplyCost(NewContext, CostAbilityState, NewUnit, none, NewGameState);
		}

		return NewGameState;
	}

	// Normal case: identical to the original behaviour
	class'X2Ability'.static.TypicalAbility_FillOutGameState(NewGameState);
	return NewGameState;
}

//----------------------------------------------------------------------------------------
// Decide whether the follow-up action should be skipped for this state
//----------------------------------------------------------------------------------------
static function bool ShouldSkipAttack(XComGameState_Unit NewUnit, XComGameState_Ability AbilityState)
{
	local name AvailableCode;

	if (NewUnit == none)
		return true;

	// Dead / removed / knocked out / bleeding out / stunned / dazed / panicked
	if (NewUnit.IsDead() || NewUnit.bRemovedFromPlay || NewUnit.IsIncapacitated() || NewUnit.IsBleedingOut()
		|| NewUnit.IsStunned() || NewUnit.IsDazed() || NewUnit.IsPanicked())
	{
		return true;
	}

	if (AbilityState == none)
		return false;

	// If the ability is no longer valid for ANY reason (Burning, Stunned, ...),
	// finish the move but skip the follow-up action. This is the same check the engine's
	// own Validate() uses, so the abort decision stays consistent with vanilla.
	AvailableCode = AbilityState.CanActivateAbility(NewUnit);
	if (AvailableCode != 'AA_Success')
	{
		`log("X2LWMoveThenActFix: skip follow-up action, ability invalid:" @ AvailableCode
			@ "for" @ NewUnit.GetMyTemplateName());
		return true;
	}

	return false;
}

defaultproperties
{
	NoAttackMarker = "LWMoveThenActNoAttack"
}
