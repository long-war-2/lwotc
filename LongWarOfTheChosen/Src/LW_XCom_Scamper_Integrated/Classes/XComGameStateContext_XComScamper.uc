class XComGameStateContext_XComScamper extends XComGameStateContext;

var StateObjectReference RevealerUnitRef;

var localized string FlyOverText;

event string SummaryString()
{
	return "XCom Scamper";
}

function bool Validate(optional EInterruptionStatus InInterruptionStatus)
{
	// Supposedly we should check here that we are going to return a state in ContextBuildGameState or not
	// Unfortunately, game rules seem to never actually call this function so ¯\_(?)_/¯
	return true;
}

function XComGameState ContextBuildGameState()
{
	local X2Effect_ScamperPenalty ScamperPenalty;
	local array<XComGameState_Unit> Units;
	local XComGameStateHistory History;
	local EffectAppliedData EffectData;
	local XComGameState_Unit UnitState;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;
	NewGameState = History.CreateNewGameState(true, self);

	if (class'X2Effect_ScamperPenalty'.default.EnableScamperPenalty)
	{
		ScamperPenalty = X2Effect_ScamperPenalty(class'XComEngine'.static.GetClassDefaultObject(class'X2Effect_ScamperPenalty'));
		ScamperPenalty = X2Effect_ScamperPenalty(ScamperPenalty.GetPersistantTemplate());

		EffectData.PlayerStateObjectRef = `TACTICALRULES.GetCachedUnitActionPlayerRef();
		EffectData.EffectRef.LookupType = TELT_PersistantEffect;
		EffectData.EffectRef.SourceTemplateName = class'X2Effect_ScamperPenalty'.Name;
	}

	`TACTICALGRI.m_kBattle.GetLocalPlayer().GetAliveUnits(Units,, true);

	foreach Units(UnitState)
	{
		if (ShouldGrantActionPointToUnit(UnitState))
		{
			`log("Giving movement point to" @ UnitState.GetFullName(),, 'XComScamper');
			
			UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
			UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
			
			if (ScamperPenalty != none)
			{
				`log("Adding penalty to" @ UnitState.GetFullName(),, 'XComScamper');

				EffectData.SourceStateObjectRef = UnitState.GetReference();
				EffectData.TargetStateObjectRef = UnitState.GetReference();

				ScamperPenalty.ApplyEffect(EffectData, UnitState, NewGameState);
			}
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		return NewGameState;
	}
	
	`log("No units found that are in need of an action point",, 'XComScamper');
	History.CleanupPendingGameState(NewGameState);

	return none;
}

function bool ShouldGrantActionPointToUnit(XComGameState_Unit Unit)
{
	// Do not grant AP if the unit has some remaining
	if (Unit.ActionPoints.Length > 0) return false;
	
	// Do not grant AP if the unit is on overwatch, killzone, etc
	if (Unit.ReserveActionPoints.Length > 0) return false;

	// Do not grant AP to units that should not use them anyway
	if (!Unit.IsAbleToAct()) return false;
	if (Unit.GetMyTemplate().bIsCosmetic) return false;

	// Do not grant if player has requested to grant only to revealer
	if (class'X2EventListener_XComScamper'.default.GrantOnlyToRevealer && (Unit.GetReference() != RevealerUnitRef)) return false;

	return true;
}

protected function ContextBuildVisualization()
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_UpdateUI MovesUpdate, BuffsUpdate;
	local X2Action_CameraLookAt LookAtAction;
	local array<XComGameState_Unit> Units;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local X2Action_Delay Delay;
	local array<X2Action> AdditionalParents;

	History = `XCOMHISTORY;

	foreach AssociatedState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.GetReference() == RevealerUnitRef)
		{
			// The revealer is always shown first
			Units.InsertItem(0, UnitState);
		}
		else
		{
			Units.AddItem(UnitState);
		}
	}

	// When visualizng the first unit those will not be set - that's expected - prevent compiler warnings
	SoundAndFlyOver = none;
	MovesUpdate = none;
	BuffsUpdate = none;

	foreach Units(UnitState)
	{
		History.GetCurrentAndPreviousGameStatesForObjectID(UnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState,, AssociatedState.HistoryIndex);
		ActionMetadata.VisualizeActor = History.GetVisualizer(UnitState.ObjectID);
		
		// If we had a UI update before, add that as parent to vis of this unit
		AdditionalParents.Length = 0;
		if (MovesUpdate != none) AdditionalParents.AddItem(MovesUpdate);
		if (BuffsUpdate != none) AdditionalParents.AddItem(BuffsUpdate);

		LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, self,, SoundAndFlyOver, AdditionalParents));
		LookAtAction.LookAtObject = ActionMetadata.StateObject_NewState;
		LookAtAction.UseTether = true;
		LookAtAction.LookAtDuration = 0.2f;
		LookAtAction.BlockUntilFinished = true;

		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, self,, LookAtAction));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(none, FlyOverText, '', eColor_Good,, 0.4, true);

		// Do not show the new action point instantly, but wait for flyout to animate in
		Delay = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, self,, LookAtAction));
		Delay.Duration = 0.2;
		Delay.bIgnoreZipMode = true;

		MovesUpdate = X2Action_UpdateUI(class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, self,, Delay));
		MovesUpdate.UpdateType = EUIUT_UnitFlag_Moves;
		MovesUpdate.SpecificID = UnitState.ObjectID;

		BuffsUpdate = X2Action_UpdateUI(class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, self,, Delay));
		BuffsUpdate.UpdateType = EUIUT_UnitFlag_Buffs;
		BuffsUpdate.SpecificID = UnitState.ObjectID;
	}
}

defaultproperties
{
	bVisualizationFence = true;
	AssociatedPlayTiming = SPT_AfterSequential;
}