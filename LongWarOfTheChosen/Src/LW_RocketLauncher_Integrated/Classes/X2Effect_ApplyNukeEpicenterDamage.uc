class X2Effect_ApplyNukeEpicenterDamage extends X2Effect_ApplyWeaponDamage config(Rockets);

//	Applies damage to the object (unit) only if it is within a certain percent of overall detonation radius.
var config array<name> REMOVE_EFFECTS_BEFORE_APPLYING_DAMAGE;
var config bool KILL_ON_BLEED_OUT;

// Implementation copied from X2Effect_ApplyWeaponDamage::ApplyFalloff
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local Damageable			Target;
	local XComGameState_Unit	TargetUnit;
	local XComGameState_Ability	kAbility;
	local int					KillAmount;
	//local name					RemoveEffectName;
	//local XComGameState_Effect	RemoveEffectState;
	
	Target = Damageable(kNewTargetState);
	kAbility = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	//	Apply damage effect only if the target is within Epicenter Radius
	if (Target != none && kAbility != none)
	{
		if (IsTargetInRange(ApplyEffectParameters.AbilityInputContext.TargetLocations[0], Target, kAbility.GetAbilityRadius()))
		{
			//	Remove some specific effects before applying Nuke's epicenter damage.
			//TargetUnit = XComGameState_Unit(kNewTargetState);
			//if (TargetUnit != none)
			//{
			//	foreach default.REMOVE_EFFECTS_BEFORE_APPLYING_DAMAGE(RemoveEffectName)
			//	{
			//		//`LOG("Looking for effect: " @ RemoveEffectName @ "from unit " @ TargetUnit.GetFullName(),, 'IRINUKE');
			//		RemoveEffectState = TargetUnit.GetUnitAffectedByEffectState(RemoveEffectName);
			//		if (RemoveEffectState != none) 
			//		{
			//			//`LOG("Removing effect: " @ RemoveEffectName @ "from unit " @ TargetUnit.GetFullName(),, 'IRINUKE');
			//			RemoveEffectState.RemoveEffect(NewGameState, NewGameState, true);
			//		}
			//	}
			//}

			//	Apply Nuke's damage.
			super.OnEffectAdded(ApplyEffectParameters, kNewTargetState,NewGameState, NewEffectState);

			//	Kill any bleeding out targets, if configured so.
			if (default.KILL_ON_BLEED_OUT)
			{
				TargetUnit = XComGameState_Unit(kNewTargetState);
				if (TargetUnit != none && TargetUnit.IsBleedingOut())
				{
					////`LOG("Target unit is bleeding out: " @ TargetUnit.GetFullName() @ "In range:" @ IsTargetInRange(ApplyEffectParameters.AbilityInputContext.TargetLocations[0], Target, kAbility.GetAbilityRadius()),, 'IRIDEAD');

					KillAmount = TargetUnit.GetCurrentStat(eStat_HP) + TargetUnit.GetCurrentStat(eStat_ShieldHP);
					TargetUnit.TakeEffectDamage(self, KillAmount, 0, 0, ApplyEffectParameters, NewGameState, false, false);
				}
			}
			//	If target is dead after Epicenter Damage goes through, mark it for disintegration
			////TargetUnit = XComGameState_Unit(kNewTargetState);
			//if (TargetUnit != none && TargetUnit.IsDead())
			//{
			//	TargetUnit.bSpecialDeathOccured = true;
			//	TargetUnit.SetUnitFloatValue('IRI_NukeEpicenterKill_Value', 1, eCleanup_BeginTactical);
			//	//`LOG("Marking dead unit for disintegration: " @ TargetUnit.GetFullName(),, 'IRIDEAD');
			//}
		}
	}
}

public static function bool IsTargetInRange(const vector TargetPos, Damageable Target, float Radius, optional bool bLog = false)
{
	local float			Interp;
	local int			RadiusTiles, idx, ClosestRadius, TestRadius;
	local TTile			TargetTile, VisibilityKeystone, TestTile;
	local array<TTile>	AllTiles;
	local X2GameRulesetVisibilityInterface VisibilityTarget;

	TargetTile = `XWORLD.GetTileCoordinatesFromPosition(TargetPos);

	VisibilityTarget = X2GameRulesetVisibilityInterface(Target);
	VisibilityTarget.GetKeystoneVisibilityLocation(VisibilityKeystone);
	VisibilityTarget.GetVisibilityLocation(AllTiles);

	if (bLog)
	{
		//`LOG("Visibility tiles: " @ AllTiles.Length,, 'IRIDEAD');
	}

	// reduce all the tiles to the ones in the slice of the keystone Z
	for (idx = AllTiles.Length - 1; idx >= 0; --idx)
	{
		if (AllTiles[idx].Z > VisibilityKeystone.Z)
			AllTiles.Remove( idx, 1 );
	}
	
	RadiusTiles = Radius / class'XComWorldData'.const.WORLD_StepSize;
	ClosestRadius = RadiusTiles;
	foreach AllTiles(TestTile)
	{
		TestRadius = max(abs(TargetTile.X - TestTile.X), abs(TargetTile.Y - TestTile.Y));
		ClosestRadius = min(ClosestRadius, TestRadius);
	}

	//	Interp takes a value between 0 and 1 depending on how far the target is from the detonation point. 0 = on top of it, 1 = at the very edge of the outer radius.
	Interp = ClosestRadius / float(RadiusTiles);

	return Interp <= class'X2Rocket_Nuke'.default.EPICENTER_RELATIVE_RADIUS;
}

//	Copy of the original effect to apply environmental damage only to objects inside epicenter radius.
simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_EnvironmentDamage DamageEvent;
	local XComGameState_Ability AbilityStateObject;
	local XComGameState_Unit SourceStateObject;
	local XComGameState_Item SourceItemStateObject;
	local X2WeaponTemplate WeaponTemplate;
	local float AbilityRadius;
	local vector DamageDirection;
	local vector SourceUnitPosition;
	local XComGameStateContext_Ability AbilityContext;
	local int DamageAmount;
	local int PhysicalImpulseAmount;
	local name DamageTypeTemplateName;
	local XGUnit SourceUnit;
	local int OutCoverIndex;
	local UnitPeekSide OutPeekSide;
	local int OutRequiresLean;
	local int bOutCanSeeFromDefault;
	local X2AbilityTemplate AbilityTemplate;	
	local XComGameState_Item LoadedAmmo, SourceAmmo;	
	local Vector HitLocation;	
	local int i, HitLocationCount, HitLocationIndex;
	local array<vector> HitLocationsArray;
	local bool bLinearDamage;
	local X2AbilityMultiTargetStyle TargetStyle;
	local GameRulesCache_VisibilityInfo OutVisibilityInfo;

	// Variable for Issue #200
	local XComLWTuple ModifyEnvironmentDamageTuple;

	//If this damage effect has an associated position, it does world damage
	if( ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0 || ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations.Length > 0 )
	{
		History = `XCOMHISTORY;
		SourceStateObject = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		SourceItemStateObject = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));	
		if (SourceItemStateObject != None)
			WeaponTemplate = X2WeaponTemplate(SourceItemStateObject.GetMyTemplate());
		AbilityStateObject = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());

		if( (SourceStateObject != none && AbilityStateObject != none) && (SourceItemStateObject != none || EnvironmentalDamageAmount > 0) )
		{	
			AbilityTemplate = AbilityStateObject.GetMyTemplate();
			if( AbilityTemplate != None )
			{
				TargetStyle = AbilityTemplate.AbilityMultiTargetStyle;

				if( TargetStyle != none && TargetStyle.IsA('X2AbilityMultiTarget_Line') )
				{
					bLinearDamage = true;
				}
			}
			AbilityRadius = AbilityStateObject.GetAbilityRadius();

			//Here, we want to use the target location as the input for the direction info since a miss location might possibly want a different step out
			SourceUnit = XGUnit(History.GetVisualizer(SourceStateObject.ObjectID));
			SourceUnit.GetDirectionInfoForPosition(ApplyEffectParameters.AbilityInputContext.TargetLocations[0], OutVisibilityInfo, OutCoverIndex, OutPeekSide, bOutCanSeeFromDefault, OutRequiresLean);
			SourceUnitPosition = SourceUnit.GetExitCoverPosition(OutCoverIndex, OutPeekSide);	
			SourceUnitPosition.Z += 8.0f;
			
			DamageAmount = EnvironmentalDamageAmount;
			if ((SourceItemStateObject != none) && !bIgnoreBaseDamage)
			{
				SourceAmmo = AbilityStateObject.GetSourceAmmo();
				if (SourceAmmo != none)
				{
					DamageAmount += SourceAmmo.GetItemEnvironmentDamage();
				}
				else if(SourceItemStateObject.HasLoadedAmmo())
				{
					LoadedAmmo = XComGameState_Item(History.GetGameStateForObjectID(SourceItemStateObject.LoadedAmmo.ObjectID));
					if(LoadedAmmo != None)
					{	
						DamageAmount += LoadedAmmo.GetItemEnvironmentDamage();
					}
				}
				
				DamageAmount += SourceItemStateObject.GetItemEnvironmentDamage();				
			}

			if (WeaponTemplate != none)
			{
				PhysicalImpulseAmount = WeaponTemplate.iPhysicsImpulse;
				DamageTypeTemplateName = WeaponTemplate.DamageTypeTemplateName;
			}
			else
			{
				PhysicalImpulseAmount = 0;

				if( EffectDamageValue.DamageType != '' )
				{
					// If the damage effect's damage type is filled out, use that
					DamageTypeTemplateName = EffectDamageValue.DamageType;
				}
				else if( DamageTypes.Length > 0 )
				{
					// If there is at least one DamageType, use the first one (may want to change
					// in the future to make a more intelligent decision)
					DamageTypeTemplateName = DamageTypes[0];
				}
				else
				{
					// Default to explosive
					DamageTypeTemplateName = 'Explosion';
				}
			}
			
			// Issue #200 Start, allow listeners to modify environment damage
			ModifyEnvironmentDamageTuple = new class'XComLWTuple';
			ModifyEnvironmentDamageTuple.Id = 'ModifyEnvironmentDamage';
			ModifyEnvironmentDamageTuple.Data.Add(3);
			ModifyEnvironmentDamageTuple.Data[0].kind = XComLWTVBool;
			ModifyEnvironmentDamageTuple.Data[0].b = false;  // override? (true) or add? (false)
			ModifyEnvironmentDamageTuple.Data[1].kind = XComLWTVInt;
			ModifyEnvironmentDamageTuple.Data[1].i = 0;  // override/bonus environment damage
			ModifyEnvironmentDamageTuple.Data[2].kind = XComLWTVObject;
			ModifyEnvironmentDamageTuple.Data[2].o = AbilityStateObject;  // ability being used

			`XEVENTMGR.TriggerEvent('ModifyEnvironmentDamage', ModifyEnvironmentDamageTuple, self, NewGameState);
			
			if(ModifyEnvironmentDamageTuple.Data[0].b)
			{
				DamageAmount = ModifyEnvironmentDamageTuple.Data[1].i;
			}
			else
			{
				DamageAmount += ModifyEnvironmentDamageTuple.Data[1].i;
			}

			// Issue #200 End

			if( ( bLinearDamage || AbilityRadius > 0.0f || AbilityContext.ResultContext.HitResult == eHit_Miss) && DamageAmount > 0 )
			{
				// Loop here over projectiles if needed. If not single hit and use the first index.
				if(ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations.Length > 0)
				{
					HitLocationsArray = ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations;
				}
				else
				{
					HitLocationsArray = ApplyEffectParameters.AbilityInputContext.TargetLocations;
				}

				HitLocationCount = 1;
				if( bApplyWorldEffectsForEachTargetLocation )
				{
					HitLocationCount = HitLocationsArray.Length;
				}
								
				for( HitLocationIndex = 0; HitLocationIndex < HitLocationCount; ++HitLocationIndex )
				{
					HitLocation = HitLocationsArray[HitLocationIndex];

					DamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateNewStateObject(class'XComGameState_EnvironmentDamage'));	
					DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_ApplyWeaponDamage:ApplyEffectToWorld";
					DamageEvent.DamageAmount = DamageAmount;
					DamageEvent.DamageTypeTemplateName = DamageTypeTemplateName;
					DamageEvent.HitLocation = HitLocation;
					DamageEvent.Momentum = (AbilityRadius == 0.0f) ? DamageDirection : vect(0,0,0);
					DamageEvent.PhysImpulse = PhysicalImpulseAmount;

					if( bLinearDamage )
					{
						TargetStyle.GetValidTilesForLocation(AbilityStateObject, DamageEvent.HitLocation, DamageEvent.DamageTiles);
					}
					else if (AbilityRadius > 0.0f)
					{
						//	CHANGED BY IRIDAR
						//	Epicenter Damage Effect deals environmental damage in reduced radius. 
						//	The Outer Damage Effect will still deal environmental damage inside the Epicenter, but we don't care about that, because Epicenter Damage will already have everything destroyed.
						DamageEvent.DamageRadius = AbilityRadius * class'X2Rocket_Nuke'.default.EPICENTER_RELATIVE_RADIUS;
						//	END OF CHANGED
					}
					else
					{					
						DamageEvent.DamageTiles.AddItem(`XWORLD.GetTileCoordinatesFromPosition(DamageEvent.HitLocation));
					}

					if( X2AbilityMultiTarget_Cone(TargetStyle) != none )
					{
						DamageEvent.bAffectFragileOnly = AbilityTemplate.bFragileDamageOnly;
						DamageEvent.CosmeticConeEndDiameter = X2AbilityMultiTarget_Cone(TargetStyle).GetConeEndDiameter(AbilityStateObject);
						DamageEvent.CosmeticConeLength = X2AbilityMultiTarget_Cone(TargetStyle).GetConeLength(AbilityStateObject);
						DamageEvent.CosmeticConeLocation = SourceUnitPosition;
						DamageEvent.CosmeticDamageShape = SHAPE_CONE;

						if (AbilityTemplate.bCheckCollision)
						{
							for (i = 0; i < AbilityContext.InputContext.VisibleTargetedTiles.Length; i++)
							{
								DamageEvent.DamageTiles.AddItem( AbilityContext.InputContext.VisibleTargetedTiles[i] );
							}

							for (i = 0; i < AbilityContext.InputContext.VisibleNeighborTiles.Length; i++)
							{
								DamageEvent.DamageTiles.AddItem( AbilityContext.InputContext.VisibleNeighborTiles[i] );
							}
						}
					}

					DamageEvent.DamageCause = SourceStateObject.GetReference();
					DamageEvent.DamageSource = DamageEvent.DamageCause;
					DamageEvent.bRadialDamage = AbilityRadius > 0;
				}
			}
		}
	}
}
/*
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local XComGameState_Unit	TargetUnit;
	local UnitValue				UV;
	local X2Action_PlayEffect	EffectAction;

	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);

	TargetUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if(TargetUnit != none && TargetUnit.bSpecialDeathOccured && TargetUnit.GetUnitValue('IRI_NukeEpicenterKill_Value', UV))
	{
		//`LOG("Applying special death effect to unit: " @ TargetUnit.GetFullName() @ "location: " @ ActionMetadata.VisualizeActor.Location,, 'IRIVIZ');
		class'X2Action_RemoveUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);

		EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		EffectAction.EffectName = "IRI_RocketNuke.PFX_Nuke.P_Dust_Poof"; //PS_Disintegrate"; 
		EffectAction.EffectLocation = ActionMetadata.VisualizeActor.Location;
		EffectAction.EffectRotation = Rotator(vect(0, 1, 0));
		EffectAction.bWaitForCompletion = false;
		EffectAction.bWaitForCameraArrival = false;
		EffectAction.bWaitForCameraCompletion = false;
	}
}*/

defaultproperties
{
	DamageTag="IRI_Nuke_Primary"
	bIgnoreBaseDamage=true
	bExplosiveDamage=true
	bIgnoreArmor=false
	bBypassSustainEffects=true
	bApplyWorldEffectsForEachTargetLocation=false
	bAllowFreeKill=false
	bAppliesDamage=true
}
