class X2Effect_GetOverHere_NOOW extends X2Effect_GetOverHere;


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnitState, TargetUnitState;
	local XComGameStateHistory History;
	local XComWorldData World;
	local TTIle TeleportToTile;
	local Vector PreferredDirection;
	local X2EventManager EventManager;

	History = `XCOMHISTORY;
	World = `XWORLD;

	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnitState != none);
	TargetUnitState = XComGameState_Unit(kNewTargetState);
	`assert(TargetUnitState != none);

	PreferredDirection = Normal(World.GetPositionFromTileCoordinates(TargetUnitState.TileLocation) - World.GetPositionFromTileCoordinates(SourceUnitState.TileLocation));

	// Prioritize selecting a tile that we can use the bind ability from.  (visible without peek, not high cover)
	if( HasBindableNeighborTile(SourceUnitState, PreferredDirection, TeleportToTile) 
							// If that fails, select any valid neighbor tile.  Drop the validator.
		   || (!RequireVisibleTile && SourceUnitState.FindAvailableNeighborTileWeighted(PreferredDirection, TeleportToTile)) )
	{
		EventManager = `XEVENTMGR;

		// Move the target to this space
		TargetUnitState.SetVisibilityLocation(TeleportToTile);
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local XComGameState_Unit TargetUnitState;
	local vector NewUnitLoc;
	local X2Action_ViperGetOverHereTarget GetOverHereTarget;
	local X2Action_ApplyWeaponDamageToUnit UnitAction;

	TargetUnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if( TargetUnitState != None )
	{
		// Move the target to this space
		if( EffectApplyResult == 'AA_Success' )
		{
			GetOverHereTarget = X2Action_ViperGetOverHereTarget(class'X2Action_ViperGetOverHereTarget'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));//auto-parent to damage initiating action
			NewUnitLoc = `XWORLD.GetPositionFromTileCoordinates(TargetUnitState.TileLocation);
			GetOverHereTarget.SetDesiredLocation(NewUnitLoc, XGUnit(ActionMetadata.VisualizeActor));

			if( OverrideStartAnimName != '' )
			{
				GetOverHereTarget.StartAnimName = OverrideStartAnimName;
			}

			if( OverrideStopAnimName != '' )
			{
				GetOverHereTarget.StopAnimName = OverrideStopAnimName;
			}
		}
		else
		{
			UnitAction = X2Action_ApplyWeaponDamageToUnit(class'X2Action_ApplyWeaponDamageToUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));//auto-parent to damage initiating action
			UnitAction.OriginatingEffect = self;
		}
	}
} 