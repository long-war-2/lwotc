class X2Effect_ApplyNukeOuterDamage extends X2Effect_ApplyWeaponDamage;


//	Applies damage to the object (unit) only if it is within a certain percent of overall detonation radius.

//const DelayTime = 3.0f;

// Implementation copied from X2Effect_ApplyWeaponDamage::ApplyFalloff
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local Damageable	Target;
	local float			Radius, Interp;
	local int			RadiusTiles, idx, ClosestRadius, TestRadius;
	local TTile			TargetTile, VisibilityKeystone, TestTile;
	local array<TTile>	AllTiles;
	local vector		TargetPos;
	local X2GameRulesetVisibilityInterface VisibilityTarget;
	local XComGameState_Ability	kAbility;

	Target = Damageable(kNewTargetState);
	VisibilityTarget = X2GameRulesetVisibilityInterface(Target);

	TargetPos = ApplyEffectParameters.AbilityInputContext.TargetLocations[0];
	TargetTile = `XWORLD.GetTileCoordinatesFromPosition(TargetPos);

	VisibilityTarget.GetKeystoneVisibilityLocation(VisibilityKeystone);
	VisibilityTarget.GetVisibilityLocation(AllTiles);

	// reduce all the tiles to the ones in the slice of the keystone Z
	for (idx = AllTiles.Length - 1; idx >= 0; --idx)
	{
		if (AllTiles[idx].Z > VisibilityKeystone.Z)
			AllTiles.Remove( idx, 1 );
	}
	
	kAbility = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	Radius = kAbility.GetAbilityRadius();
	RadiusTiles = Radius / class'XComWorldData'.const.WORLD_StepSize;

	ClosestRadius = RadiusTiles;
	foreach AllTiles(TestTile)
	{
		TestRadius = max(abs(TargetTile.X - TestTile.X), abs(TargetTile.Y - TestTile.Y));
		ClosestRadius = min(ClosestRadius, TestRadius);
	}

	//	Interp takes a value between 0 and 1 depending on how far the target is from the detonation point. 0 = on top of it, 1 = at the very edge of the outer radius.
	Interp = ClosestRadius / float(RadiusTiles);

	//	Apply damage effect only if the target is within Epicenter Radius
	if (Interp > class'X2Rocket_Nuke'.default.EPICENTER_RELATIVE_RADIUS)
	{
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState,NewGameState, NewEffectState);
	}
}
/*
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_ApplyWeaponDamageToUnit UnitAction;	
	local X2Action_PlaySoundAndFlyOver FlyOverAction;
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_Fire FireAction;
	//local Array<X2Action> ParentArray;
	local Actor SourceVisualizer;
	local X2Action_MoveTurn TurnAction;
	local XComGameState_Unit SourceState;
	local XComGameStateHistory History;
	local XComWorldData XWorld;
	local Vector SourceLocation;
	local X2Action_ExitCover SourceExitCover;
	local X2Action_TimedWait				TimedWait;
	local X2Action_WaitForAbilityEffect		WaitAction;
	
	local name EffectName;
	local int x, OverwatchExclusion;
	local bool bRemovedEffect;
	
	History = `XCOMHISTORY;
	VisMgr = `XCOMVISUALIZATIONMGR;
	XWorld = `XWORLD;

	if( ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit') )
	{		
		if ((HideVisualizationOfResults.Find(EffectApplyResult) != INDEX_NONE) ||
			(HideVisualizationOfResultsAdditional.Find(EffectApplyResult) != INDEX_NONE))
		{
			return;
		}

		AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
		if( AbilityContext.ResultContext.HitResult == eHit_Deflect || AbilityContext.ResultContext.HitResult == eHit_Parry || AbilityContext.ResultContext.HitResult == eHit_Reflect )
		{
			SourceState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex));
			SourceVisualizer = History.GetVisualizer(SourceState.ObjectID);
			FireAction = X2Action_Fire(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire', SourceVisualizer));
			SourceExitCover = X2Action_ExitCover(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover', SourceVisualizer));

			// Jwats: Have the target face the attacker during the exit cover. (unless we are doing a reflect shot since we'll step out and aim)
			if( AbilityContext.ResultContext.HitResult != eHit_Reflect )
			{
				SourceLocation = XWorld.GetPositionFromTileCoordinates(SourceState.TileLocation);
				TurnAction = X2Action_MoveTurn(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_MoveTurn', ActionMetadata.VisualizeActor));
				if( TurnAction == None || TurnAction.m_vFacePoint != SourceLocation )
				{
					TurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, , SourceExitCover.ParentActions));
					TurnAction.ParsePathSetParameters(SourceLocation);

					// Jwats: Make sure fire doesn't start until the target is facing us.
					VisMgr.ConnectAction(FireAction, VisMgr.BuildVisTree, false, TurnAction);
				}
			}

			// Jwats: For Parry and Deflect we want to start the fire animation and the hit reaction at the same time
			
			//if( FireAction != None )
			//{
			//	ParentArray = FireAction.ParentActions;
			//}
		}

		//	ADDED BY IRIDAR
		WaitAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, FireAction));

		TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, WaitAction));
		TimedWait.DelayTimeSec = DelayTime;
		//	END OF ADDED

		//	CHANGED PARENT
		UnitAction = X2Action_ApplyWeaponDamageToUnit(class'X2Action_ApplyWeaponDamageToUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(),, TimedWait));//auto-parent to damage initiating action
		UnitAction.OriginatingEffect = self;

		if (EffectApplyResult == 'AA_Success')
		{
			UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
			if (XComGameState_Unit(ActionMetadata.StateObject_OldState).NumAllReserveActionPoints() > 0 && UnitState.NumAllReserveActionPoints() == 0)
			{
				FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, TimedWait));
				bRemovedEffect = false;
				for (x = 0; x < UnitState.AppliedEffects.Length; ++x)
				{
					EffectName = UnitState.AppliedEffectNames[x];

					if (EffectName == class'X2Effect_Suppression'.default.EffectName)
					{
						FlyOverAction.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.SuppressionRemovedMsg, '', eColor_Bad);
						bRemovedEffect = true;
					}
				}

				if (!bRemovedEffect)
				{
					FlyOverAction.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Bad);
				}
			}
		}
		else
		{
			OverwatchExclusion = class'X2Ability_DefaultAbilitySet'.default.OverwatchExcludeReasons.Find(EffectApplyResult);
			if (OverwatchExclusion != INDEX_NONE)
			{
				FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, TimedWait));
				FlyOverAction.SetSoundAndFlyOverParameters(none, class'X2AbilityTemplateManager'.static.GetDisplayStringForAvailabilityCode(EffectApplyResult), '', eColor_Bad);
			}
			else
			{
				super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
			}
		}
	}
	else if( ActionMetadata.StateObject_NewState.IsA('XComGameState_EnvironmentDamage')
			|| ActionMetadata.StateObject_NewState.IsA('XComGameState_Destructible') )
	{
		if(EffectApplyResult == 'AA_Success')
		{
			
			AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
			SourceVisualizer = History.GetVisualizer(AbilityContext.InputContext.SourceObject.ObjectID);
			FireAction = X2Action_Fire(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire', SourceVisualizer));

			WaitAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, FireAction));

			TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, WaitAction));
			TimedWait.DelayTimeSec = DelayTime;

			//All non-unit damage is routed through XComGameState_EnvironmentDamage state objects, which represent an environmental damage event
			//It is expected that LastActionAdded will be none (causing the action to be autoparented) in most cases.
			//However we pass it in so that when building visualizations, callers can get the action parented to the right thing if they need it to be.
			//`LOG("Creating damage terrain action",, 'IRIROCK');
			class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, AbilityContext,, TimedWait);
			
			class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), , ActionMetadata.LastActionAdded );
		}
	}
}*/

defaultproperties
{
	DamageTag="IRI_Nuke_Secondary"
	bIgnoreBaseDamage=true
	bExplosiveDamage=true
	bIgnoreArmor=false
	bBypassSustainEffects=false
	bApplyWorldEffectsForEachTargetLocation=false
	bAllowFreeKill=false
	bAppliesDamage=true
}
