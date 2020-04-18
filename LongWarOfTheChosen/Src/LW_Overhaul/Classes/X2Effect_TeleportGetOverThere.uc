class X2Effect_TeleportGetOverThere extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnitState, TargetUnitState;
	local XComWorldData World;
	local TTile TeleportToTile;
	local Vector PreferredDirection;
	local X2EventManager EventManager;
	local X2Condition_Wrath MeleeCheckCondition;

	World = `XWORLD;

	SourceUnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnitState == none)
		SourceUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnitState != none);
	TargetUnitState = XComGameState_Unit(kNewTargetState);
	`assert(TargetUnitState != none);

	PreferredDirection = Normal(World.GetPositionFromTileCoordinates(SourceUnitState.TileLocation) - World.GetPositionFromTileCoordinates(TargetUnitState.TileLocation));
	MeleeCheckCondition = new class'X2Condition_Wrath';
	MeleeCheckCondition.TargetTile = TargetUnitState.TileLocation;
	if (TargetUnitState.FindAvailableNeighborTileWeighted(PreferredDirection, TeleportToTile, class'X2Condition_Wrath'.static.DefaultMeleeVisibility, MeleeCheckCondition))
	{
		EventManager = `XEVENTMGR;

		// Move the source to this space
		SourceUnitState.SetVisibilityLocation(TeleportToTile);

		EventManager.TriggerEvent('ObjectMoved', SourceUnitState, SourceUnitState, NewGameState);
		EventManager.TriggerEvent('UnitMoveFinished', SourceUnitState, SourceUnitState, NewGameState);
		return;
	}
	`RedScreen("GetOverThere effect could not find a neighbor tile to land in - ability should not have been able to be activated! @gameplay @jbouscher");
}

simulated function AddX2ActionsForVisualizationSource(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local XComGameState_Unit TargetUnitState;
	local X2Action_ApplyWeaponDamageToUnit UnitAction;
	local X2Action_TeleportGetOverThere GetOverThereAction;

	TargetUnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	`assert(TargetUnitState != none);

	// Move the target to this space
	if (EffectApplyResult == 'AA_Success')
	{
		GetOverThereAction = X2Action_TeleportGetOverThere(class'X2Action_TeleportGetOverThere'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));//auto-parent to damage initiating action
		GetOverThereAction.Destination = `XWORLD.GetPositionFromTileCoordinates(TargetUnitState.TileLocation);
	}
	else
	{
		UnitAction = X2Action_ApplyWeaponDamageToUnit(class'X2Action_ApplyWeaponDamageToUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));//auto-parent to damage initiating action
		UnitAction.OriginatingEffect = self;
	}
}
