//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ApplyExplosiveFalloffWeaponDamage.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Adds damage falloff for explosives and similar area damage
//--------------------------------------------------------------------------------------- 
class X2Effect_ApplyExplosiveFalloffWeaponDamage extends X2Effect_ApplyWeaponDamage dependson(LWTemplateMods) config(LW_SoldierSkills);

var array<name> UnitDamageAbilityExclusions; // if has any of these abilities, skip any falloff
var array<name> EnvironmentDamageAbilityExclusions; // if has any of these abilities, skip any falloff

var array<DamageStep> UnitDamageSteps;
var array<DamageStep> EnvironmentDamageSteps;

var config int SAPPER_ENV_DAMAGE_BONUS;
var config int COMBAT_ENGINEER_ENV_DAMAGE_BONUS;
var config int IMPROVED_WARHEADS_ENV_DMG_BONUS;
var config int CONCUSSION_WARHEADS_ENV_DMG_BONUS;

var config array<Name>IMPROVED_WARHEADS_AFFECT_ABILITIES;
var config array<Name>CONCUSSION_WARHEADS_AFFECT_ABILITIES;

var config int MAX_ENV_DAMAGE_RANGE_PCT;

// Cannot pass bools as out params, so use an int. Zero is false, non-zero is true.
simulated function int CalculateDamageAmount(
		const out EffectAppliedData ApplyEffectParameters,
		out int ArmorMitigation,
		out int NewRupture,
		out int NewShred,
		out array<Name> AppliedDamageTypes,
		out int bAmmoIgnoresShields,
		out int bFullyImmune,
		out array<DamageModifierInfo> SpecialDamageMessages,
		optional XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit kSourceUnit;
	local XComGameState_Ability kAbility;
	//local XComGameState_Item kSourceItem, LoadedAmmo;
	local XComGameState_Unit DamagedUnit;
	local array<vector> HitLocations;
	local vector HitLocation, TargetLocation;
	local float AbilityRadius, Distance, MinDistance, DistanceRatio, MinDistanceRatio, DamageRatio;
	local int idx;
	local int WeaponDamage, NewWeaponDamage, MinDamage, DamageFalloff;
	
	// LWOTC: Vars for Faket's fix to Shredder/Shredstorm damage falloff.
	local GameRulesCache_VisibilityInfo OutVisibilityInfo;
	local vector SourceUnitPosition;
	local XGUnit SourceUnit;
	local int OutCoverIndex;
	local UnitPeekSide OutPeekSide;
	local int OutRequiresLean;
	local int bOutCanSeeFromDefault;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityMultiTargetStyle TargetStyle;

	WeaponDamage = super.CalculateDamageAmount(
			ApplyEffectParameters, ArmorMitigation, NewRupture,
			NewShred, AppliedDamageTypes, bAmmoIgnoresShields,
			bFullyImmune, SpecialDamageMessages, NewGameState);

	History = `XCOMHISTORY;
	kSourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));	
	kAbility = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	//if (kAbility.SourceAmmo.ObjectID > 0)
		//kSourceItem = XComGameState_Item(History.GetGameStateForObjectID(kAbility.SourceAmmo.ObjectID));		
	//else
		//kSourceItem = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));		

	if((WeaponDamage > 1) && ShouldApplyUnitDamageFalloff(kSourceUnit))
	{
		SourceUnit = XGUnit(History.GetVisualizer(kSourceUnit.ObjectID));
		SourceUnit.GetDirectionInfoForPosition(ApplyEffectParameters.AbilityInputContext.TargetLocations[0], OutVisibilityInfo, OutCoverIndex, OutPeekSide, bOutCanSeeFromDefault, OutRequiresLean);
		SourceUnitPosition = SourceUnit.GetExitCoverPosition(OutCoverIndex, OutPeekSide);	
		SourceUnitPosition.Z += 8.0f;

		DamagedUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		if(DamagedUnit != none)
		{
			TargetLocation = `XWORLD.GetPositionFromTileCoordinates(DamagedUnit.TileLocation);
			if(kAbility != none)
			{
				AbilityTemplate = kAbility.GetMyTemplate();
				if (AbilityTemplate != none)
					TargetStyle = AbilityTemplate.AbilityMultiTargetStyle;

				AbilityRadius = kAbility.GetAbilityRadius();
				if (X2AbilityMultiTarget_Cone(TargetStyle) != none)
					AbilityRadius = X2AbilityMultiTarget_Cone(TargetStyle).GetConeLength(kAbility);
				HitLocations = ApplyEffectParameters.AbilityInputContext.TargetLocations;

				MinDistanceRatio = 1.0;
				MinDistance = AbilityRadius;
				//if there are multiple hit locations, choose the nearest -- so the smallest distance ratio
				foreach HitLocations(HitLocation, idx)
				{
					// LWOTC: Use the shooter's location if this is for a cone attack.
					if (X2AbilityMultiTarget_Cone(TargetStyle) != none)
						HitLocation = SourceUnitPosition;

					Distance = FClamp(VSize(TargetLocation - HitLocation), 0.0, AbilityRadius);
					MinDistance = FMin(MinDistance, Distance);
					DistanceRatio = Distance / AbilityRadius;
					
					MinDistanceRatio = FMin(MinDistanceRatio, DistanceRatio);
				}
				`LOG("Explosive Damage Falloff : MinDistance=" $ MinDistance $ ", MinDistanceRatio=" $ MinDistanceRatio);
			}
		}
		DamageRatio = GetUnitDamageRatio(MinDistanceRatio);
		MinDamage = Max(1, FFloor(DamageRatio * float(WeaponDamage)));
		DamageFalloff = `SYNC_RAND(WeaponDamage - MinDamage + 1);
		`LOG("Explosive Damage Falloff: DamageRatio=" $ DamageRatio $ ", MinDamage=" $ MinDamage $ ", RolledDamageFalloff=" $ DamageFalloff);
	}
	NewWeaponDamage = WeaponDamage - DamageFalloff;
	`LOG("Explosive Damage Falloff: Final Damage=" $ NewWeaponDamage);
	// Set the effect's damage
	return NewWeaponDamage;
}

simulated function float GetUnitDamageRatio(float DistanceRatio)
{
	local DamageStep Step;
	local int idx;
	local float LowestDamage;

	LowestDamage = 1.0;
	foreach UnitDamageSteps(Step, idx)
	{
		//`LOG("Explosive Damage Falloff : Testing Step " $ idx $ ", DistanceRatio=" $ Step.DistanceRatio $ ", DamageRatio=" $ Step.DamageRatio);
		// find the lowest damage which meets the required distance ratio
		if (DistanceRatio < Step.DistanceRatio)
		{
			LowestDamage = FMin(LowestDamage, Step.DamageRatio);
			break;
			//`LOG("Explosive Damage Falloff : New LowestRatio=" $ LowestDamage);
		}
	}
	return LowestDamage;
}

simulated function bool ShouldApplyUnitDamageFalloff(XComGameState_Unit SourceUnit)
{
	local name AbilityExclusion;

	foreach UnitDamageAbilityExclusions(AbilityExclusion)
	{
		if(SourceUnit.HasSoldierAbility(AbilityExclusion))
			return false;

		//additional check for aliens, checking character 
		if(SourceUnit.FindAbility(AbilityExclusion).ObjectId > 0)
			return false;
	}
	return true;
}


//---------- ENVIRONMENTAL DAMAGE ----------------

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
	local GameRulesCache_VisibilityInfo OutVisibilityInfo;
	local int OutCoverIndex;
	local UnitPeekSide OutPeekSide;
	local int OutRequiresLean;
	local int bOutCanSeeFromDefault;
	local X2AbilityTemplate AbilityTemplate;	
	local XComGameState_Item LoadedAmmo, SourceAmmo;	
	local Vector HitLocation;	
	local int i, HitLocationCount, HitLocationIndex, RandRoll;
	local float DamageChange;
	local array<vector> HitLocationsArray;
	local bool bLinearDamage;
	local X2AbilityMultiTargetStyle TargetStyle;

	local int StepIdx, StepEnvironmentDamage;
	local bool bShouldApplyStepDamage;

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
			

			// Check for perks
			if (SourceStateObject.HasSoldierAbility('Sapper', true) && DamageAmount > 0)
					DamageAmount += default.SAPPER_ENV_DAMAGE_BONUS;
			if (SourceStateObject.HasSoldierAbility('CombatEngineer', true) && DamageAmount > 0)
					DamageAmount += default.COMBAT_ENGINEER_ENV_DAMAGE_BONUS;
			if(SourceStateObject.HasAbilityFromAnySource('ImprovedMunitions_LW') && DamageAmount > 0 && default.IMPROVED_WARHEADS_AFFECT_ABILITIES.find(AbilityTemplate.DataName) != INDEX_NONE)
					DamageAmount += default.IMPROVED_WARHEADS_ENV_DMG_BONUS;
			if(SourceStateObject.HasAbilityFromAnySource('ConcussionWarheads_LW') && DamageAmount > 0 && default.CONCUSSION_WARHEADS_AFFECT_ABILITIES.find(AbilityTemplate.DataName) != INDEX_NONE)
					DamageAmount += default.CONCUSSION_WARHEADS_ENV_DMG_BONUS;

			// Randomize damage
			if (!bLinearDamage && AbilityRadius > 0.0f && DamageAmount > 0)
			{
				RandRoll = `SYNC_RAND((default.MAX_ENV_DAMAGE_RANGE_PCT * 2) + 1) - default.MAX_ENV_DAMAGE_RANGE_PCT;
				//`LOG ("DAMAGE AMOUNT BEFORE:" @ string (DamageAmount) @ "RandRoll" @ string (RandRoll));
				DamageChange = float(DamageAmount) * (float (RandRoll) / 100);
				//`LOG ("DAMAGE CHANGE:" @ string (DamageChange));
				DamageAmount += int (DamageChange);
				//`LOG ("DAMAGE AMOUNT AFTER:" @ string (DamageAmount));
			}

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

				bShouldApplyStepDamage = ShouldApplyEnvironmentDamageFalloff(SourceStateObject);  // exclusions for abilities
				for( HitLocationIndex = 0; HitLocationIndex < HitLocationCount; ++HitLocationIndex )
				{
					HitLocation = HitLocationsArray[HitLocationIndex];

					`LOG("Explosive Envir Falloff: bShouldApplyStepDamage=" $ bShouldApplyStepDamage $ ", BaseEnvironmentalDamage=" $ DamageAmount);

					//submit multiple environment damage gamestates for each hit location -- one for each step in damage
					for(StepIdx = 0; StepIdx < EnvironmentDamageSteps.Length; StepIdx++)
					{
						DamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateStateObject(class'XComGameState_EnvironmentDamage'));	
						DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_ApplyWeaponDamage:ApplyEffectToWorld";
						DamageEvent.DamageTypeTemplateName = DamageTypeTemplateName;
						DamageEvent.HitLocation = HitLocation;
						DamageEvent.Momentum = (AbilityRadius == 0.0f) ? DamageDirection : vect(0,0,0);
						DamageEvent.PhysImpulse = PhysicalImpulseAmount;
						if(bShouldApplyStepDamage)
						{
							StepEnvironmentDamage = int(float(DamageAmount) * EnvironmentDamageSteps[StepIdx].DamageRatio);
							DamageEvent.DamageAmount = StepEnvironmentDamage; // adjust for the current step
							`LOG("Explosive Envir Falloff: Step=" $ StepIdx $ ", Damage=" $ StepEnvironmentDamage);
						}
						else
						{
							DamageEvent.DamageAmount = DamageAmount; // Use the base amount everywhere
						}

						if( bLinearDamage )
						{
							TargetStyle.GetValidTilesForLocation(AbilityStateObject, DamageEvent.HitLocation, DamageEvent.DamageTiles);
						}
						else if (AbilityRadius > 0.0f)
						{
							if(bShouldApplyStepDamage)
								TargetStyle.GetValidTilesForLocation(AbilityStateObject, DamageEvent.HitLocation, DamageEvent.DamageTiles);  // explicitly mark tiles even for radius so we can break them into steps
							else
								DamageEvent.DamageRadius = AbilityRadius;
						}
						else
						{					
							DamageEvent.DamageTiles.AddItem(`XWORLD.GetTileCoordinatesFromPosition(DamageEvent.HitLocation));
						}

						if( X2AbilityMultiTarget_Cone(TargetStyle) != none )
						{
							DamageEvent.bAffectFragileOnly = AbilityTemplate.bFragileDamageOnly;
							DamageEvent.CosmeticConeEndDiameter = X2AbilityMultiTarget_Cone(TargetStyle).ConeEndDiameter;
							DamageEvent.CosmeticConeLength = X2AbilityMultiTarget_Cone(TargetStyle).GetConeLength(AbilityStateObject);
							DamageEvent.CosmeticConeLocation = SourceUnitPosition;
							DamageEvent.CosmeticDamageShape = SHAPE_CONE;
							DamageEvent.HitLocation = SourceUnitPosition;

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

						if(bShouldApplyStepDamage)
						{
							`LOG("Explosive Envir Falloff: Step=" $ StepIdx $ ",PreFilterTiles=" $ DamageEvent.DamageTiles.Length);
							FilterTilesByStep(StepIdx, DamageEvent.HitLocation, AbilityRadius, DamageEvent.DamageTiles);  // filter out all tiles not in the current step
							`LOG("Explosive Envir Falloff: Step=" $ StepIdx $ ",PostFilterTiles=" $ DamageEvent.DamageTiles.Length);
						}
						DamageEvent.DamageCause = SourceStateObject.GetReference();
						DamageEvent.DamageSource = DamageEvent.DamageCause;
						DamageEvent.bRadialDamage = AbilityRadius > 0;
						NewGameState.AddStateObject(DamageEvent);

						if(!bShouldApplyStepDamage) // only loop once, since all tiles are affected
							break;
					}
				}
			}
		}
	}
}

simulated function FilterTilesByStep(int StepIdx, vector SourceLocation, float AbilityRadius, out array<TTile> ValidTiles)
{
	local XComWorldData World;
	local TTile Tile;
	local vector TileLocation;
	local float LowerBound, UpperBound, DistanceRatio, Distance;
	//local int CheckTileCount, RemoveTileCount, KeepTileCount;
	local array<TTile> RemoveTiles;

	if(AbilityRadius <= 0)
		return;

	World = `XWORLD;
	
	if(StepIdx == 0)
		LowerBound = 0.0;
	else
		LowerBound = EnvironmentDamageSteps[StepIdx-1].DistanceRatio;

	UpperBound = EnvironmentDamageSteps[StepIdx].DistanceRatio;

	foreach ValidTiles(Tile)
	{
		//CheckTileCount++;
		TileLocation = World.GetPositionFromTileCoordinates(Tile);
		//Distance = FClamp(VSize(SourceLocation - TileLocation), 0.0, AbilityRadius);
		Distance = VSize(SourceLocation - TileLocation);
		DistanceRatio = Distance / AbilityRadius;

		if((DistanceRatio >= UpperBound) || (DistanceRatio < LowerBound))
		{
			//RemoveTileCount++;
			RemoveTiles.AddItem(Tile);
		}
		else
		{
			//KeepTileCount++;
		}
	}
	//`LOG ("Explosive Envir Falloff: Step=" $ StepIdx $ ", Processed " $ CheckTileCount $ " tiles. Removed " $ RemoveTileCount $ ", kept " $ KeepTileCount $ " Tiles.");
	foreach RemoveTiles(Tile)
	{
		ValidTiles.RemoveItem(Tile);
	}
}

simulated function bool ShouldApplyEnvironmentDamageFalloff(XComGameState_Unit SourceUnit)
{
	local name AbilityExclusion;

	foreach EnvironmentDamageAbilityExclusions(AbilityExclusion)
	{
		if(SourceUnit.HasSoldierAbility(AbilityExclusion))
			return false;

		//additional check for aliens, checking character 
		if(SourceUnit.FindAbility(AbilityExclusion).ObjectId > 0)
			return false;
	}
	return true;
}

