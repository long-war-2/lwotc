class X2Effect_ApplyPlasmaEjectorDamage extends X2Effect_ApplyWeaponDamage config(Rockets);

var config float DAMAGE_LOSS_PER_TILE;
var config float ENVIRONMENTAL_DAMAGE_MULTIPLIER;
const bLog = false;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue		ReturnDamageValue;
	local XComGameState_Unit	TargetUnit;
	local XComGameState_Unit	AdditionalTarget;
	local array<XComGameState_Unit>	AdditionalTargets;
	local XComWorldData			WorldData;
	local XComGameStateHistory	History;
	local vector				ShooterLocation, TargetLocation;
	local array<StateObjectReference>	UnitsOnTile;
	local StateObjectReference			UnitRef;
	local TTile					TargetTile;
	local array<TilePosPair>			Tiles;
	local int i;
	local array<XComDestructibleActor>	DestructibleActors;

	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	ReturnDamageValue = EffectDamageValue;

	////`LOG("Targeting: " @ TargetRef.ObjectID, bLog, 'IRIROCK');

	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
	if (TargetUnit != none) 
	{

		////`LOG("Target is a unit: " @ TargetUnit.GetFullName(), bLog, 'IRIROCK');
		////`LOG("Calculating unit damage: " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
		TargetTile = TargetUnit.TileLocation;

		//	first, reduce damage based on tile distance to the target.
		ReturnDamageValue.Damage -= default.DAMAGE_LOSS_PER_TILE * TileDistanceBetweenTiles(SourceUnit.TileLocation, TargetTile);
		////`LOG("Distance adjust: " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
		//	If that would reduce damage to zero or lower, exit the function then and there.
		if (ReturnDamageValue.Damage <= 0) 
		{
			ReturnDamageValue.Shred = 0;
			ReturnDamageValue.Damage = 0;
		}
		else
		{
			//	otherwise, get positions for both shooter and this current target
			ShooterLocation = WorldData.GetPositionFromTileCoordinates(SourceUnit.TileLocation);
			TargetLocation = WorldData.GetPositionFromTileCoordinates(TargetTile);

			//	grab all the tiles between the shooter and the target
			WorldData.CollectTilesInCapsule(Tiles, ShooterLocation, TargetLocation, 1.0f); //WORLD_StepSize

			//	cycle through grabbed tiles
			for (i = 0; i < Tiles.Length; i++)
			{
				//	and try to find any units on it
				UnitsOnTile = WorldData.GetUnitsOnTile(Tiles[i].Tile);
				foreach UnitsOnTile(UnitRef)
				{
					AdditionalTarget = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

					//	Add the Unit to the list of additional targets only if it's not the shooter, and not the primary target of this effect, and it's not in the list already
					//	and it's actually alive and not in Stasis
					if (AdditionalTarget != none && 
						UnitRef.ObjectID != TargetUnit.ObjectID &&
						UnitRef.ObjectID != SourceUnit.ObjectID && 
						AdditionalTargets.Find(AdditionalTarget) == INDEX_NONE &&
						AdditionalTarget.IsAlive() &&
						!AdditionalTarget.IsInStasis()) 
					{
						AdditionalTargets.AddItem(AdditionalTarget);
					}
				}
			}

			//	Cycle through filtered out targets and reduce damage dealt to this current target by the cumulitive amount of HP and Armor of all the units between the shooter and this current target
			for (i = 0; i < AdditionalTargets.Length; i++)
			{
				ReturnDamageValue.Damage -= AdditionalTargets[i].GetCurrentStat(eStat_HP);
				ReturnDamageValue.Damage -= AdditionalTargets[i].GetCurrentStat(eStat_ArmorMitigation); //	armor mitigates damage before being shredded
				////`LOG("Target adjust: " @ AdditionalTargets[i].GetFullName() @ ": " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
			}

			//	Then grab all the destructible objects between shooter and target. this includes ONLY things like cars and gas tanks, but not cover objects. (?)
			WorldData.CollectDestructiblesInTiles(Tiles, DestructibleActors);
			for (i = 0; i < DestructibleActors.Length; i++)
			{
				ReturnDamageValue.Damage -= int(DestructibleActors[i].Health / default.ENVIRONMENTAL_DAMAGE_MULTIPLIER);
				////`LOG("Destructible adjust: " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
				////`LOG("Destructible on the path, actor health: " @ DestructibleActors[i].Health, bLog, 'IRIROCK');
			}

			if (ReturnDamageValue.Damage <= 0) 
			{
				ReturnDamageValue.Damage = 0;
			}		
			//	clamp shred by damage
			if (ReturnDamageValue.Shred < ReturnDamageValue.Damage) 
			{
				ReturnDamageValue.Shred = ReturnDamageValue.Damage;
			}	
		}
	}
	////`LOG("Calculated target damage: " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
	return ReturnDamageValue;
}

function int GetEnvironmentalDamageValue(const XComGameState_Ability AbilityState, const XComGameState_Unit SourceUnit, const vector TargetLocation)
{
	local WeaponDamageValue			ReturnDamageValue;
	local XComGameState_Unit		AdditionalTarget;
	local array<XComGameState_Unit>	AdditionalTargets;
	local XComWorldData				WorldData;
	local XComGameStateHistory		History;
	local vector					ShooterLocation;
	local array<StateObjectReference>	UnitsOnTile;
	local StateObjectReference			UnitRef;
	local array<TilePosPair>			Tiles;
	local array<XComDestructibleActor>	DestructibleActors;
	local int Distance;
	local int i;

	History = `XCOMHISTORY;
	WorldData = `XWORLD;

	//ReturnDamageValue.Damage = class'X2Rocket_Plasma_Ejector'.default.IENVIRONMENTDAMAGE;

	//	Environmental damage is initially set to be the same as normal damage
	ReturnDamageValue.Damage = EffectDamageValue.Damage;
	//`LOG("Calculating environment damage: " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');

	ShooterLocation = WorldData.GetPositionFromTileCoordinates(SourceUnit.TileLocation);

	//	first, reduce damage based on tile distance to the target.
	Distance = TileDistanceBetweenVectors(ShooterLocation, TargetLocation);
	Distance--;	//	reduce distance by 1 tile so that targets right next to the soldier receive full damage
	if (Distance < 0) Distance = 0;

	ReturnDamageValue.Damage -= default.DAMAGE_LOSS_PER_TILE * Distance;
	//`LOG("Distance adjust: " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
	////`LOG("Calculated distance: " @ TileDistanceBetweenTiles(SourceUnit.TileLocation, TargetTile), bLog, 'IRIROCK');

	//	If that would reduce damage to zero or lower, exit the function then and there.
	if (ReturnDamageValue.Damage <= 0) 
	{
		ReturnDamageValue.Damage = 0;
	}
	else
	{
		//	grab all the tiles between the shooter and the target
		WorldData.CollectTilesInCapsule(Tiles, ShooterLocation, TargetLocation, WorldData.WORLD_HalfStepSize); //WORLD_StepSize

		//	cycle through grabbed tiles
		for (i = 0; i < Tiles.Length; i++)
		{
			//	and try to find any units on it
			UnitsOnTile = WorldData.GetUnitsOnTile(Tiles[i].Tile);
			foreach UnitsOnTile(UnitRef)
			{
				AdditionalTarget = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

				//	Add the Unit to the list of additional targets only if it's not the shooter, and not the primary target of this effect, and it's not in the list already
				//	and it's actually alive and not in Stasis
				if (AdditionalTarget != none && 
					UnitRef.ObjectID != SourceUnit.ObjectID && 
					AdditionalTargets.Find(AdditionalTarget) == INDEX_NONE &&
					/*AdditionalTarget.IsAlive() &&*/ 
					!AdditionalTarget.IsInStasis()) 
				{
					AdditionalTargets.AddItem(AdditionalTarget);
				}
			}
		}

		//	Cycle through filtered out targets and reduce damage dealt to this current target by the cumulitive amount of HP and Armor of all the units between the shooter and this current target
		for (i = 0; i < AdditionalTargets.Length; i++)
		{
			//`LOG(" >> Before target adjust: " @ AdditionalTargets[i].GetFullName() @ ": " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');

			ReturnDamageValue.Damage -= AdditionalTargets[i].GetCurrentStat(eStat_HP);
			ReturnDamageValue.Damage -= AdditionalTargets[i].GetCurrentStat(eStat_ArmorMitigation); //	Shredding armor consumes damage

			//`LOG(" << After target adjust: " @ AdditionalTargets[i].GetFullName() @ ": " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
		}

		//	Then grab all the destructible objects between shooter and target. this includes ONLY things like cars and gas tanks, but not cover objects. (?)
		WorldData.CollectDestructiblesInTiles(Tiles, DestructibleActors);
		for (i = 0; i < DestructibleActors.Length; i++)
		{
			ReturnDamageValue.Damage -= DestructibleActors[i].Health;
			//`LOG("Destructible adjust: " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
			////`LOG("E Destructible on the path, actor health: " @ DestructibleActors[i].Health, bLog, 'IRIROCK');
		}

		if (ReturnDamageValue.Damage <= 0) 
		{
			ReturnDamageValue.Damage = 0;
		}		
	}
	ReturnDamageValue.Damage *= default.ENVIRONMENTAL_DAMAGE_MULTIPLIER;

	//`LOG("Calculated environment damage: " @ ReturnDamageValue.Damage, bLog, 'IRIROCK');
	return ReturnDamageValue.Damage;
}

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
	local int PhysicalImpulseAmount;
	local name DamageTypeTemplateName;
	//local vector SourceUnitPosition;
	local XGUnit SourceUnit;
	local int OutCoverIndex;
	local UnitPeekSide OutPeekSide;
	local int OutRequiresLean;
	local int bOutCanSeeFromDefault;
	local Vector HitLocation;	
	local int HitLocationIndex;
	local int DamageAmount;
	//local array<vector> HitLocationsArray;
	local GameRulesCache_VisibilityInfo OutVisibilityInfo;
	local XComWorldData WorldData;

	// Variable for Issue #200
	local XComLWTuple ModifyEnvironmentDamageTuple;

	WorldData = `XWORLD;

	//If this damage effect has an associated position, it does world damage
	if( ApplyEffectParameters.AbilityInputContext.TargetLocations.Length > 0 || ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations.Length > 0 )
	{
		History = `XCOMHISTORY;
		SourceStateObject = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		SourceItemStateObject = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));	
		if (SourceItemStateObject != None)
			WeaponTemplate = X2WeaponTemplate(SourceItemStateObject.GetMyTemplate());
		AbilityStateObject = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

		if( SourceStateObject != none && AbilityStateObject != none )
		{	
			AbilityRadius = AbilityStateObject.GetAbilityRadius();

			//Here, we want to use the target location as the input for the direction info since a miss location might possibly want a different step out
			SourceUnit = XGUnit(History.GetVisualizer(SourceStateObject.ObjectID));
			SourceUnit.GetDirectionInfoForPosition(ApplyEffectParameters.AbilityInputContext.TargetLocations[0], OutVisibilityInfo, OutCoverIndex, OutPeekSide, bOutCanSeeFromDefault, OutRequiresLean);
			//SourceUnitPosition = SourceUnit.GetExitCoverPosition(OutCoverIndex, OutPeekSide);	
			//SourceUnitPosition.Z += 8.0f;

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
			// not running this out of fear it would screw something 
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
				// not allowing mods to entirely override environmental damage, since that would ruin the intended scaling
				//DamageAmount = ModifyEnvironmentDamageTuple.Data[1].i;
			}
			else
			{
				//	feel free to increase or reduce it, though.
				DamageAmount += ModifyEnvironmentDamageTuple.Data[1].i;
			}
			
			// Issue #200 End

			// Loop here over projectiles if needed. If not single hit and use the first index.
			////`LOG("" @ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations.Length, bLog, 'IRIROCK');
			////`LOG("" @ApplyEffectParameters.AbilityInputContext.TargetLocations.Length, bLog, 'IRIROCK');
			////`LOG("" @ApplyEffectParameters.AbilityInputContext.ProjectileEvents.Length, bLog, 'IRIROCK');
			/*
			if(ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations.Length > 0)
			{
				HitLocationsArray = ApplyEffectParameters.AbilityResultContext.ProjectileHitLocations;
			}
			else
			{
				HitLocationsArray = ApplyEffectParameters.AbilityInputContext.TargetLocations;
			}
			*/
			//HitLocationCount = HitLocationsArray.Length;
				
			//	Cycle through all tiles containing objects hit by the projectile, and create Environment Damage events on each one
			for( HitLocationIndex = 0; HitLocationIndex < ApplyEffectParameters.AbilityInputContext.ProjectileEvents.Length; ++HitLocationIndex )
			{
				HitLocation = ApplyEffectParameters.AbilityInputContext.ProjectileEvents[HitLocationIndex].HitLocation;

				DamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateNewStateObject(class'XComGameState_EnvironmentDamage'));	
				DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_ApplyWeaponDamage:ApplyEffectToWorld";
				DamageEvent.DamageAmount = DamageAmount + GetEnvironmentalDamageValue(AbilityStateObject, SourceStateObject, HitLocation);
				DamageEvent.DamageTypeTemplateName = DamageTypeTemplateName;
				DamageEvent.HitLocation = HitLocation;
				DamageEvent.Momentum = (AbilityRadius == 0.0f) ? DamageDirection : vect(0,0,0);
				DamageEvent.PhysImpulse = PhysicalImpulseAmount;

				DamageEvent.DamageTiles.AddItem(WorldData.GetTileCoordinatesFromPosition(HitLocation));

				DamageEvent.DamageCause = SourceStateObject.GetReference();
				DamageEvent.DamageSource = DamageEvent.DamageCause;
				DamageEvent.bRadialDamage = AbilityRadius > 0;
			}
		}
	}
}

static function int TileDistanceBetweenTiles(const TTile TileLocation1, const TTile TileLocation2)
{
	local XComWorldData WorldData;
	local vector Loc1, Loc2;
	local float Dist;
	local int Tiles;

	WorldData = `XWORLD;
	Loc1 = WorldData.GetPositionFromTileCoordinates(TileLocation1);
	Loc2 = WorldData.GetPositionFromTileCoordinates(TileLocation2);
	Dist = VSize(Loc1 - Loc2);
	Tiles = Dist / WorldData.WORLD_StepSize;
	return Tiles;
}

static function int TileDistanceBetweenVectors(const vector Loc1, const vector Loc2)
{
	return VSize(Loc1 - Loc2) / class'XComWorldData'.const.WORLD_StepSize;
}
simulated function int CalculateDamageAmount(const out EffectAppliedData ApplyEffectParameters, out int ArmorMitigation, out int NewRupture, out int NewShred, out array<Name> AppliedDamageTypes, out int bAmmoIgnoresShields, out int bFullyImmune, out array<DamageModifierInfo> SpecialDamageMessages, optional XComGameState NewGameState)
{
	local int TotalDamage, WeaponDamage, DamageSpread, ArmorPiercing, EffectDmg, CritDamage;

	local XComGameStateHistory History;
	local XComGameState_Unit kSourceUnit;
	local Damageable kTarget;
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item kSourceItem, LoadedAmmo;
	local XComGameState_Ability kAbility;
	local XComGameState_Effect EffectState;
	local StateObjectReference EffectRef;
	local X2Effect_Persistent EffectTemplate;
	local WeaponDamageValue BaseDamageValue, ExtraDamageValue, BonusEffectDamageValue, AmmoDamageValue, UpgradeTemplateBonusDamage, UpgradeDamageValue;
	local X2AmmoTemplate AmmoTemplate;
	local int RuptureCap, RuptureAmount, OriginalMitigation, UnconditionalShred;
	local int TargetBaseDmgMod;
	local XComDestructibleActor kDestructibleActorTarget;
	local array<X2WeaponUpgradeTemplate> WeaponUpgradeTemplates;
	local X2WeaponUpgradeTemplate WeaponUpgradeTemplate;
	local DamageModifierInfo ModifierInfo;
	local bool bWasImmune, bHadAnyDamage;

	ArmorMitigation = 0;
	NewRupture = 0;
	NewShred = 0;
	bAmmoIgnoresShields = 0;    // FALSE
	bWasImmune = true;			//	as soon as we check any damage we aren't immune to, this will be set false
	bHadAnyDamage = false;

	//Cheats can force the damage to a specific value
	if (`CHEATMGR != none && `CHEATMGR.NextShotDamageRigged )
	{
		`CHEATMGR.NextShotDamageRigged = false;
		return `CHEATMGR.NextShotDamage;
	}

	History = `XCOMHISTORY;
	kSourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));	
	kTarget = Damageable(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	kDestructibleActorTarget = XComDestructibleActor(History.GetVisualizer(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	kAbility = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (kAbility != none && kAbility.SourceAmmo.ObjectID > 0)
		kSourceItem = XComGameState_Item(History.GetGameStateForObjectID(kAbility.SourceAmmo.ObjectID));		
	else
		kSourceItem = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));		

	if( bAlwaysKillsCivilians )
	{
		TargetUnit = XComGameState_Unit(kTarget);

		if( (TargetUnit != none) && (TargetUnit.GetTeam() == eTeam_Neutral) )
		{
			// Return the amount of health the civlian has so that it will be euthanized
			return TargetUnit.GetCurrentStat(eStat_HP) + TargetUnit.GetCurrentStat(eStat_ShieldHP);
		}
	}

	//`LOG("===" $ GetFuncName() $ "===", true, 'XCom_HitRolls');

	if (kSourceItem != none)
	{
		//`LOG("Attacker ID:" @ kSourceUnit.ObjectID @ "With Item ID:" @ kSourceItem.ObjectID @ "Target ID:" @ ApplyEffectParameters.TargetStateObjectRef.ObjectID, true, 'XCom_HitRolls');
		if (!bIgnoreBaseDamage)
		{
			kSourceItem.GetBaseWeaponDamageValue(XComGameState_BaseObject(kTarget), BaseDamageValue);
			if (BaseDamageValue.Damage > 0) bHadAnyDamage = true;

			bWasImmune = bWasImmune && ModifyDamageValue(BaseDamageValue, kTarget, AppliedDamageTypes);
		}
		if (DamageTag != '')
		{
			kSourceItem.GetWeaponDamageValue(XComGameState_BaseObject(kTarget), DamageTag, ExtraDamageValue);
			if (ExtraDamageValue.Damage > 0) bHadAnyDamage = true;

			bWasImmune = bWasImmune && ModifyDamageValue(ExtraDamageValue, kTarget, AppliedDamageTypes);
		}
		if (kSourceItem.HasLoadedAmmo() && !bIgnoreBaseDamage)
		{
			LoadedAmmo = XComGameState_Item(History.GetGameStateForObjectID(kSourceItem.LoadedAmmo.ObjectID));
			AmmoTemplate = X2AmmoTemplate(LoadedAmmo.GetMyTemplate());
			if (AmmoTemplate != none)
			{
				AmmoTemplate.GetTotalDamageModifier(LoadedAmmo, kSourceUnit, XComGameState_BaseObject(kTarget), AmmoDamageValue);
				if (AmmoTemplate.bBypassShields)
				{
					bAmmoIgnoresShields = 1;  // TRUE
				}
			}
			else
			{
				LoadedAmmo.GetBaseWeaponDamageValue(XComGameState_BaseObject(kTarget), AmmoDamageValue);
			}
			if (AmmoDamageValue.Damage > 0) bHadAnyDamage = true;
			bWasImmune = bWasImmune && ModifyDamageValue(AmmoDamageValue, kTarget, AppliedDamageTypes);
		}
		if (bAllowWeaponUpgrade)
		{
			WeaponUpgradeTemplates = kSourceItem.GetMyWeaponUpgradeTemplates();
			foreach WeaponUpgradeTemplates(WeaponUpgradeTemplate)
			{
				if (WeaponUpgradeTemplate.BonusDamage.Tag == DamageTag)
				{
					UpgradeTemplateBonusDamage = WeaponUpgradeTemplate.BonusDamage;

					if (UpgradeTemplateBonusDamage.Damage > 0) bHadAnyDamage = true;
					bWasImmune = bWasImmune && ModifyDamageValue(UpgradeTemplateBonusDamage, kTarget, AppliedDamageTypes);

					UpgradeDamageValue.Damage += UpgradeTemplateBonusDamage.Damage;
					UpgradeDamageValue.Spread += UpgradeTemplateBonusDamage.Spread;
					UpgradeDamageValue.Crit += UpgradeTemplateBonusDamage.Crit;
					UpgradeDamageValue.Pierce += UpgradeTemplateBonusDamage.Pierce;
					UpgradeDamageValue.Rupture += UpgradeTemplateBonusDamage.Rupture;
					UpgradeDamageValue.Shred += UpgradeTemplateBonusDamage.Shred;
					//  ignores PlusOne as there is no good way to add them up
				}
			}
		}
		// Issue #237 start
		// Treat new CH upgrade damage as base damage unless a tag is specified
		WeaponUpgradeTemplates = kSourceItem.GetMyWeaponUpgradeTemplates();
		foreach WeaponUpgradeTemplates(WeaponUpgradeTemplate)
		{
			if ((!bIgnoreBaseDamage && DamageTag == '') || WeaponUpgradeTemplate.CHBonusDamage.Tag == DamageTag)
			{
				UpgradeTemplateBonusDamage = WeaponUpgradeTemplate.CHBonusDamage;

				if (UpgradeTemplateBonusDamage.Damage > 0) bHadAnyDamage = true;
				bWasImmune = bWasImmune && ModifyDamageValue(UpgradeTemplateBonusDamage, kTarget, AppliedDamageTypes);

				UpgradeDamageValue.Damage += UpgradeTemplateBonusDamage.Damage;
				UpgradeDamageValue.Spread += UpgradeTemplateBonusDamage.Spread;
				UpgradeDamageValue.Crit += UpgradeTemplateBonusDamage.Crit;
				UpgradeDamageValue.Pierce += UpgradeTemplateBonusDamage.Pierce;
				UpgradeDamageValue.Rupture += UpgradeTemplateBonusDamage.Rupture;
				UpgradeDamageValue.Shred += UpgradeTemplateBonusDamage.Shred;
				//  ignores PlusOne as there is no good way to add them up
			}
		}
		// Issue #237 end
	}

	// non targeted objects take the environmental damage amount
	if( kDestructibleActorTarget != None)
	{
		return GetEnvironmentalDamageValue(kAbility, kSourceUnit, kDestructibleActorTarget.MajorTileAxis);
	}

	BonusEffectDamageValue = GetBonusEffectDamageValue(kAbility, kSourceUnit, kSourceItem, ApplyEffectParameters.TargetStateObjectRef);
	if (BonusEffectDamageValue.Damage > 0 || BonusEffectDamageValue.Crit > 0 || BonusEffectDamageValue.Pierce > 0 || BonusEffectDamageValue.PlusOne > 0 ||
		BonusEffectDamageValue.Rupture > 0 || BonusEffectDamageValue.Shred > 0 || BonusEffectDamageValue.Spread > 0)
	{
		bWasImmune = bWasImmune && ModifyDamageValue(BonusEffectDamageValue, kTarget, AppliedDamageTypes);
		bHadAnyDamage = true;
	}

	WeaponDamage = BaseDamageValue.Damage + ExtraDamageValue.Damage + BonusEffectDamageValue.Damage + AmmoDamageValue.Damage + UpgradeDamageValue.Damage;
	DamageSpread = BaseDamageValue.Spread + ExtraDamageValue.Spread + BonusEffectDamageValue.Spread + AmmoDamageValue.Spread + UpgradeDamageValue.Spread;
	CritDamage = BaseDamageValue.Crit + ExtraDamageValue.Crit + BonusEffectDamageValue.Crit + AmmoDamageValue.Crit + UpgradeDamageValue.Crit;
	ArmorPiercing = BaseDamageValue.Pierce + ExtraDamageValue.Pierce + BonusEffectDamageValue.Pierce + AmmoDamageValue.Pierce + UpgradeDamageValue.Pierce;
	NewRupture = BaseDamageValue.Rupture + ExtraDamageValue.Rupture + BonusEffectDamageValue.Rupture + AmmoDamageValue.Rupture + UpgradeDamageValue.Rupture;
	NewShred = BaseDamageValue.Shred + ExtraDamageValue.Shred + BonusEffectDamageValue.Shred + AmmoDamageValue.Shred + UpgradeDamageValue.Shred;
	RuptureCap = WeaponDamage;

	//`LOG(`ShowVar(bIgnoreBaseDamage) @ `ShowVar(DamageTag), true, 'XCom_HitRolls');
	//`LOG("Weapon damage:" @ WeaponDamage @ "Potential spread:" @ DamageSpread, true, 'XCom_HitRolls');

	if (DamageSpread > 0)
	{
		WeaponDamage += DamageSpread;                          //  set to max damage based on spread
		WeaponDamage -= `SYNC_RAND(DamageSpread * 2 + 1);      //  multiply spread by 2 to get full range off base damage, add 1 as rand returns 0:x-1, not 0:x
	}
	//`LOG("Damage with spread:" @ WeaponDamage, true, 'XCom_HitRolls');
	if (PlusOneDamage(BaseDamageValue.PlusOne))
	{
		WeaponDamage++;
		//`LOG("Rolled for PlusOne off BaseDamage, succeeded. Damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}
	if (PlusOneDamage(ExtraDamageValue.PlusOne))
	{
		WeaponDamage++;
		//`LOG("Rolled for PlusOne off ExtraDamage, succeeded. Damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}
	if (PlusOneDamage(BonusEffectDamageValue.PlusOne))
	{
		WeaponDamage++;
		//`LOG("Rolled for PlusOne off BonusEffectDamage, succeeded. Damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}
	if (PlusOneDamage(AmmoDamageValue.PlusOne))
	{
		WeaponDamage++;
		//`LOG("Rolled for PlusOne off AmmoDamage, succeeded. Damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}

	if (ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
	{
		WeaponDamage += CritDamage;
		//`LOG("CRIT! Adjusted damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}
	else if (ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Graze)
	{
		WeaponDamage *= GRAZE_DMG_MULT;
		//`LOG("GRAZE! Adjusted damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}

	RuptureAmount = min(kTarget.GetRupturedValue() + NewRupture, RuptureCap);
	if (RuptureAmount != 0)
	{
		WeaponDamage += RuptureAmount;
		//`LOG("Target is ruptured, increases damage by" @ RuptureAmount $", new damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}

	if( kSourceUnit != none)
	{
		//  allow target effects that modify only the base damage
		TargetUnit = XComGameState_Unit(kTarget);
		if (TargetUnit != none)
		{
			foreach TargetUnit.AffectedByEffects(EffectRef)
			{
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
				EffectTemplate = EffectState.GetX2Effect();
				EffectDmg = EffectTemplate.GetBaseDefendingDamageModifier(EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters, WeaponDamage, self, NewGameState);
				if (EffectDmg != 0)
				{
					TargetBaseDmgMod += EffectDmg;
					//`LOG("Defender effect" @ EffectTemplate.EffectName @ "adjusting base damage by" @ EffectDmg, true, 'XCom_HitRolls');

					if (EffectTemplate.bDisplayInSpecialDamageMessageUI)
					{
						ModifierInfo.Value = EffectDmg;
						ModifierInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
						ModifierInfo.SourceID = EffectRef.ObjectID;
						SpecialDamageMessages.AddItem(ModifierInfo);
					}
				}
			}
			if (TargetBaseDmgMod != 0)
			{
				WeaponDamage += TargetBaseDmgMod;
				//`LOG("Total base damage after defender effect mods:" @ WeaponDamage, true, 'XCom_HitRolls');
			}			
		}

		//  Allow attacker effects to modify damage output before applying final bonuses and reductions
		foreach kSourceUnit.AffectedByEffects(EffectRef)
		{
			ModifierInfo.Value = 0;

			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectTemplate = EffectState.GetX2Effect();
			EffectDmg = EffectTemplate.GetAttackingDamageModifier(EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters, WeaponDamage, NewGameState);
			if (EffectDmg != 0)
			{
				WeaponDamage += EffectDmg;
				//`LOG("Attacker effect" @ EffectTemplate.EffectName @ "adjusting damage by" @ EffectDmg $ ", new damage:" @ WeaponDamage, true, 'XCom_HitRolls');				

				ModifierInfo.Value += EffectDmg;
			}
			EffectDmg = EffectTemplate.GetExtraArmorPiercing(EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters);
			if (EffectDmg != 0)
			{
				ArmorPiercing += EffectDmg;
				//`LOG("Attacker effect" @ EffectTemplate.EffectName @ "adjusting armor piercing by" @ EffectDmg $ ", new pierce:" @ ArmorPiercing, true, 'XCom_HitRolls');				

				ModifierInfo.Value += EffectDmg;
			}
			EffectDmg = EffectTemplate.GetExtraShredValue(EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters);
			if (EffectDmg != 0)
			{
				NewShred += EffectDmg;
				//`LOG("Attacker effect" @ EffectTemplate.EffectName @ "adjust new shred value by" @ EffectDmg $ ", new shred:" @ NewShred, true, 'XCom_HitRolls');

				ModifierInfo.Value += EffectDmg;
			}

			if( ModifierInfo.Value != 0 && EffectTemplate.bDisplayInSpecialDamageMessageUI )
			{
				ModifierInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
				ModifierInfo.SourceID = EffectRef.ObjectID;
				SpecialDamageMessages.AddItem(ModifierInfo);
			}
		}

		// run through the effects again for any conditional shred.  A second loop as it is possibly dependent on shred outcome of the unconditional first loop.
		UnconditionalShred = NewShred;
		foreach kSourceUnit.AffectedByEffects(EffectRef)
		{
			ModifierInfo.Value = 0;
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectTemplate = EffectState.GetX2Effect();

			EffectDmg = EffectTemplate.GetConditionalExtraShredValue(UnconditionalShred, EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters);
			if (EffectDmg != 0)
			{
				NewShred += EffectDmg;
				//`LOG("Attacker effect" @ EffectTemplate.EffectName @ "adjust new shred value by" @ EffectDmg $ ", new shred:" @ NewShred, true, 'XCom_HitRolls');

				ModifierInfo.Value += EffectDmg;
			}

			if( ModifierInfo.Value != 0 && EffectTemplate.bDisplayInSpecialDamageMessageUI )
			{
				ModifierInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
				ModifierInfo.SourceID = EffectRef.ObjectID;
				SpecialDamageMessages.AddItem(ModifierInfo);
			}
		}

		//  If this is a unit, apply any effects that modify damage
		TargetUnit = XComGameState_Unit(kTarget);
		if (TargetUnit != none)
		{
			foreach TargetUnit.AffectedByEffects(EffectRef)
			{
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
				EffectTemplate = EffectState.GetX2Effect();
				EffectDmg = EffectTemplate.GetDefendingDamageModifier(EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters, WeaponDamage, self, NewGameState);
				if (EffectDmg != 0)
				{
					WeaponDamage += EffectDmg;
					//`LOG("Defender effect" @ EffectTemplate.EffectName @ "adjusting damage by" @ EffectDmg $ ", new damage:" @ WeaponDamage, true, 'XCom_HitRolls');				

					if( EffectTemplate.bDisplayInSpecialDamageMessageUI )
					{
						ModifierInfo.Value = EffectDmg;
						ModifierInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
						ModifierInfo.SourceID = EffectRef.ObjectID;
						SpecialDamageMessages.AddItem(ModifierInfo);
					}
				}
			}
		}

		if (kTarget != none && !bIgnoreArmor)
		{
			ArmorMitigation = kTarget.GetArmorMitigation(ApplyEffectParameters.AbilityResultContext.ArmorMitigation);
			if (ArmorMitigation != 0)
			{				
				OriginalMitigation = ArmorMitigation;
				ArmorPiercing += kSourceUnit.GetCurrentStat(eStat_ArmorPiercing);				
				//`LOG("Armor mitigation! Target armor mitigation value:" @ ArmorMitigation @ "Attacker armor piercing value:" @ ArmorPiercing, true, 'XCom_HitRolls');
				ArmorMitigation -= ArmorPiercing;				
				if (ArmorMitigation < 0)
					ArmorMitigation = 0;
				// Issue #321
				if (ArmorMitigation >= WeaponDamage && !default.NO_MINIMUM_DAMAGE)
					ArmorMitigation = WeaponDamage - 1;
				if (ArmorMitigation < 0)    //  WeaponDamage could have been 0
					ArmorMitigation = 0;    
				//`LOG("  Final mitigation value:" @ ArmorMitigation, true, 'XCom_HitRolls');
			}
		}
	}
	//Shred can only shred as much as the maximum armor mitigation
	NewShred = Min(NewShred, OriginalMitigation);
	
	//if (`SecondWaveEnabled('ExplosiveFalloff'))
	//{
	//	ApplyFalloff( WeaponDamage, kTarget, kSourceItem, kAbility, NewGameState );
	//}

	TotalDamage = WeaponDamage - ArmorMitigation;

	if ((WeaponDamage > 0 && TotalDamage < 0) || (WeaponDamage < 0 && TotalDamage > 0))
	{
		// Do not allow the damage reduction to invert the damage amount (i.e. heal instead of hurt, or vice-versa).
		TotalDamage = 0;
	}
	//`LOG("Total Damage:" @ TotalDamage, true, 'XCom_HitRolls');
	//`LOG("Shred from this attack:" @ NewShred, NewShred > 0, 'XCom_HitRolls');

	// Set the effect's damage
	bFullyImmune = (bWasImmune && bHadAnyDamage) ? 1 : 0;
	//`LOG("FULLY IMMUNE", bFullyImmune == 1, 'XCom_HitRolls');

	return TotalDamage;
}

simulated function GetDamagePreview(StateObjectReference TargetRef, XComGameState_Ability AbilityState, bool bAsPrimaryTarget, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	Super.GetDamagePreview(TargetRef, AbilityState, bAsPrimaryTarget, MinDamagePreview, MaxDamagePreview, AllowsShield);

	MinDamagePreview.Damage = 1;
}

/*
static function array<XComGameState_Unit> SortUnitsByDistance(const XComGameState_Unit SourceUnit, out array<XComGameState_Unit> Targets)
{
	//local XComGameState_Unit Target;
	local array<XComGameState_Unit> ReturnArray;
	local int ShortestDistance, CurrentDistance;
	local int i, ShortestIndex;
	do
	{
		ShortestDistance = 0;
		for (i = 0; i < Targets.Length; i++)
		{
			CurrentDistance = SourceUnit.TileDistanceBetween(Targets[i]);
			if (ShortestDistance <= CurrentDistance) 
			{
				ShortestDistance = CurrentDistance;
				ShortestIndex = i;
			}
		}
		ReturnArray.AddItem(Targets[ShortestIndex]);
		Targets.Remove(ShortestIndex, 1);
	}
	Until(Targets.Length == 0);
	
	return ReturnArray;
}*/

DefaultProperties
{	
	bApplyWorldEffectsForEachTargetLocation = true
	bAllowFreeKill = false
	bAllowWeaponUpgrade = false
	bIgnoreBaseDamage = false
}
/*
function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
	local array<StateObjectReference>	UnitsOnTile;
	local array<TilePosPair>			PierceTiles;
	local StateObjectReference			UnitRef;
	local vector	ShooterLocation, TargetedLocation, PierceLocation;
	local int		PierceDistance;
	local XComWorldData WorldData;
	local XComGameState_Item	WeaponState;
	local X2RocketTemplate		RocketTemplate;
	local array<XComDestructibleActor>	DestructibleActors;
	local int i;

	WorldData = `XWORLD;
	//	Get vector location of the primary target selected by the player
	TargetedLocation = GetTargetedActor().Location;
	ShooterLocation = FiringUnit.Location;

	//	Get the pierce distance in tiles configured for this rocket
	WeaponState = Ability.GetSourceWeapon();
	if (WeaponState == none) return false;
	RocketTemplate = X2RocketTemplate(WeaponState.GetMyTemplate());
	if (RocketTemplate == none) return false;
	PierceDistance = RocketTemplate.PierceDistance;

	//	Calculate DIRECTION from the shooter to the target.
	PierceLocation = Normal(TargetedLocation - ShooterLocation);
	//	Multiply that direction by PierceDistance tiles
	PierceLocation *= (PierceDistance + 1) * WorldData.WORLD_StepSize;

	//	Project the resulting vector from target's location
	//	This should always get us a vector pointing behind the target.
	PierceLocation += TargetedLocation;

	//PierceLocation.Z = WorldData.GetFloorZForPosition(PierceLocation);
	//TargetedLocation.Z = WorldData.GetFloorZForPosition(TargetedLocation);
	

	//	Grab tiles located alongside that vector.
	//	It will grab "tiles" hanging in the air as well. 
	WorldData.CollectTilesInCapsule(PierceTiles, TargetedLocation, PierceLocation, WorldData.WORLD_StepSize); //WORLD_HalfStepSize

	// Cycle through all grabbed tiles, and if there are any units there, add them to the array of additional targets.
	
	for (i = 0; i < PierceTiles.Length; i++)
	{
		UnitsOnTile = WorldData.GetUnitsOnTile(PierceTiles[i].Tile);
		foreach UnitsOnTile(UnitRef)
		{
			//////`LOG("Adding target: " @ UnitRef.ObjectID, bLog, 'IRIROCK');
			AdditionalTargets.AdditionalTargets.AddItem(UnitRef);
		}
	}

	WorldData.CollectDestructiblesInTiles(PierceTiles, DestructibleActors);
	for (i = 0; i < DestructibleActors.Length; i++)
	{
		AdditionalTargets.AdditionalTargets.AddItem(DestructibleActors[i].GetVisualizedStateReference());
	}

    return true;
}

*/




















// This gets you damage scaling with distance.
/*
function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue		ReturnDamageValue;
	local XComGameState_Unit	TargetUnit;

	ReturnDamageValue = EffectDamageValue;

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));

	if (TargetUnit != none)
	{
		ReturnDamageValue.Damage -= SourceUnit.TileDistanceBetween(TargetUnit);
	}

	return ReturnDamageValue;
}

DefaultProperties
{
	bAllowFreeKill = false
	bAllowWeaponUpgrade = false
	bIgnoreBaseDamage = true
}*/
