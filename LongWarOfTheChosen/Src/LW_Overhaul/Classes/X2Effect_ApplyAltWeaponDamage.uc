//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ApplyAltWeaponDamage.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Applies weapon damage from alt stats defined in X2MultiWeaponTemplate
//---------------------------------------------------------------------------------------
class X2Effect_ApplyAltWeaponDamage extends X2Effect_ApplyWeaponDamage config(LW_Overhaul);

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
	local int i, HitLocationCount, HitLocationIndex;
	local array<vector> HitLocationsArray;
	local bool bLinearDamage;
	local X2AbilityMultiTargetStyle TargetStyle;
	local X2MultiWeaponTemplate MultiWeaponTemplate;

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

			`Log("ApplyEffectToWorld for ability " $ AbilityTemplate.DataName $ " (radius = " $ AbilityRadius);

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
				MultiWeaponTemplate = X2MultiWeaponTemplate(SourceItemStateObject.GetMyTemplate());
				if(MultiWeaponTemplate != none)
					DamageAmount += MultiWeaponTemplate.iAltEnvironmentDamage;
				else
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

					DamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateStateObject(class'XComGameState_EnvironmentDamage'));	
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
					NewGameState.AddStateObject(DamageEvent);
				}
			}
		}
	}
}

simulated function GetDamagePreview(
		StateObjectReference TargetRef,
		XComGameState_Ability AbilityState,
		bool bAsPrimaryTarget,
		out WeaponDamageValue MinDamagePreview,
		out WeaponDamageValue MaxDamagePreview,
		out int AllowsShield)
{
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnit, SourceUnit;
	local XComGameState_Item SourceWeapon, LoadedAmmo;
	local WeaponDamageValue UpgradeTemplateBonusDamage, BaseDamageValue, ExtraDamageValue, AmmoDamageValue, BonusEffectDamageValue, UpgradeDamageValue;
	local X2Condition ConditionIter;
	local name AvailableCode;
	local X2AmmoTemplate AmmoTemplate;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent EffectTemplate;
	local int EffectDmg, UnconditionalShred, BaseEffectDmgModMin, BaseEffectDmgModMax;
	local EffectAppliedData TestEffectParams;
	local name DamageType;
	local array<X2WeaponUpgradeTemplate> WeaponUpgradeTemplates;
	local X2WeaponUpgradeTemplate WeaponUpgradeTemplate;
	local array<Name> AppliedDamageTypes;
	local bool bDoesDamageIgnoreShields;
	local X2MultiWeaponTemplate MultiWeaponTemplate;
	local DamageModifierInfo DamageModInfo;
	local array<DamageModifierInfo> DamageMods; // Issue #923

	MinDamagePreview = UpgradeTemplateBonusDamage;
	MaxDamagePreview = UpgradeTemplateBonusDamage;
	bDoesDamageIgnoreShields = bBypassShields;

	if (!bApplyOnHit)
		return;

	History = `XCOMHISTORY;

	if (AbilityState.SourceAmmo.ObjectID > 0)
		SourceWeapon = AbilityState.GetSourceAmmo();
	else
		SourceWeapon = AbilityState.GetSourceWeapon();

	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	if (TargetUnit != None)
	{
		foreach TargetConditions(ConditionIter)
		{
			AvailableCode = ConditionIter.AbilityMeetsCondition(AbilityState, TargetUnit);
			if (AvailableCode != 'AA_Success')
				return;
			AvailableCode = ConditionIter.MeetsCondition(TargetUnit);
			if (AvailableCode != 'AA_Success')
				return;
			AvailableCode = ConditionIter.MeetsConditionWithSource(TargetUnit, SourceUnit);
			if (AvailableCode != 'AA_Success')
				return;
		}
		foreach DamageTypes(DamageType)
		{
			if (TargetUnit.IsImmuneToDamage(DamageType))
				return;
		}
	}
	
	if (bAlwaysKillsCivilians && TargetUnit != None && TargetUnit.GetTeam() == eTeam_Neutral)
	{
		MinDamagePreview.Damage = TargetUnit.GetCurrentStat(eStat_HP) + TargetUnit.GetCurrentStat(eStat_ShieldHP);
		MaxDamagePreview = MinDamagePreview;
		return;
	}
	if (SourceWeapon != None)
	{
		if (!bIgnoreBaseDamage)
		{
			MultiWeaponTemplate = X2MultiWeaponTemplate(SourceWeapon.GetMyTemplate());
			if (MultiWeaponTemplate != none)
				BaseDamageValue = MultiWeaponTemplate.AltBaseDamage;
			else
				SourceWeapon.GetBaseWeaponDamageValue(TargetUnit, BaseDamageValue);

			ModifyDamageValue(BaseDamageValue, TargetUnit, AppliedDamageTypes);
		}
		if (DamageTag != '')
		{
			SourceWeapon.GetWeaponDamageValue(TargetUnit, DamageTag, ExtraDamageValue);
			ModifyDamageValue(ExtraDamageValue, TargetUnit, AppliedDamageTypes);
		}
		if (SourceWeapon.HasLoadedAmmo() && !bIgnoreBaseDamage)
		{
			LoadedAmmo = XComGameState_Item(History.GetGameStateForObjectID(SourceWeapon.LoadedAmmo.ObjectID));
			AmmoTemplate = X2AmmoTemplate(LoadedAmmo.GetMyTemplate()); 
			if (AmmoTemplate != None)
			{
				AmmoTemplate.GetTotalDamageModifier(LoadedAmmo, SourceUnit, TargetUnit, AmmoDamageValue);
				bDoesDamageIgnoreShields = AmmoTemplate.bBypassShields || bDoesDamageIgnoreShields;
			}
			else
			{
				LoadedAmmo.GetBaseWeaponDamageValue(TargetUnit, AmmoDamageValue);
			}
			ModifyDamageValue(AmmoDamageValue, TargetUnit, AppliedDamageTypes);
		}
		if (bAllowWeaponUpgrade)
		{
			WeaponUpgradeTemplates = SourceWeapon.GetMyWeaponUpgradeTemplates();
			foreach WeaponUpgradeTemplates(WeaponUpgradeTemplate)
			{
				if (WeaponUpgradeTemplate.BonusDamage.Tag == DamageTag)
				{
					UpgradeTemplateBonusDamage = WeaponUpgradeTemplate.BonusDamage;

					ModifyDamageValue(UpgradeTemplateBonusDamage, TargetUnit, AppliedDamageTypes);

					//	Start Issue #896
					/// HL-Docs: ref:Bugfixes; issue:896
					///	Call the (hopefully) relevant delegate, if this weapon upgrade has it.
					/// This makes the guaranteed damage on missed shots added by Stocks properly benefit from Insider Knowledge
					if (WeaponUpgradeTemplate.GetBonusAmountFn != none)
					{
						UpgradeDamageValue.Damage += WeaponUpgradeTemplate.GetBonusAmountFn(WeaponUpgradeTemplate);
					}
					else
					{
						UpgradeDamageValue.Damage += UpgradeTemplateBonusDamage.Damage;
					}
					//	End Issue #896
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
		WeaponUpgradeTemplates = SourceWeapon.GetMyWeaponUpgradeTemplates();
		foreach WeaponUpgradeTemplates(WeaponUpgradeTemplate)
		{
			if ((!bIgnoreBaseDamage && DamageTag == '') || WeaponUpgradeTemplate.CHBonusDamage.Tag == DamageTag)
			{
				UpgradeTemplateBonusDamage = WeaponUpgradeTemplate.CHBonusDamage;

				ModifyDamageValue(UpgradeTemplateBonusDamage, TargetUnit, AppliedDamageTypes);

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
	BonusEffectDamageValue = GetBonusEffectDamageValue(AbilityState, SourceUnit, SourceWeapon, TargetRef);
	ModifyDamageValue(BonusEffectDamageValue, TargetUnit, AppliedDamageTypes);

	MinDamagePreview.Damage = BaseDamageValue.Damage + ExtraDamageValue.Damage + AmmoDamageValue.Damage + BonusEffectDamageValue.Damage + UpgradeDamageValue.Damage -
							  BaseDamageValue.Spread - ExtraDamageValue.Spread - AmmoDamageValue.Spread - BonusEffectDamageValue.Spread - UpgradeDamageValue.Spread;

	MaxDamagePreview.Damage = BaseDamageValue.Damage + ExtraDamageValue.Damage + AmmoDamageValue.Damage + BonusEffectDamageValue.Damage + UpgradeDamageValue.Damage +
							  BaseDamageValue.Spread + ExtraDamageValue.Spread + AmmoDamageValue.Spread + BonusEffectDamageValue.Spread + UpgradeDamageValue.Spread;

	MinDamagePreview.Pierce = BaseDamageValue.Pierce + ExtraDamageValue.Pierce + AmmoDamageValue.Pierce + BonusEffectDamageValue.Pierce + UpgradeDamageValue.Pierce;
	MaxDamagePreview.Pierce = MinDamagePreview.Pierce;
	
	MinDamagePreview.Shred = BaseDamageValue.Shred + ExtraDamageValue.Shred + AmmoDamageValue.Shred + BonusEffectDamageValue.Shred + UpgradeDamageValue.Shred;
	MaxDamagePreview.Shred = MinDamagePreview.Shred;

	MinDamagePreview.Rupture = BaseDamageValue.Rupture + ExtraDamageValue.Rupture + AmmoDamageValue.Rupture + BonusEffectDamageValue.Rupture + UpgradeDamageValue.Rupture;
	MaxDamagePreview.Rupture = MinDamagePreview.Rupture;

	if (BaseDamageValue.PlusOne > 0)
		MaxDamagePreview.Damage++;
	if (ExtraDamageValue.PlusOne > 0)
		MaxDamagePreview.Damage++;
	if (AmmoDamageValue.PlusOne > 0)
		MaxDamagePreview.Damage++;
	if (BonusEffectDamageValue.PlusOne > 0)
		MaxDamagePreview.Damage++;

	TestEffectParams.AbilityInputContext.AbilityRef = AbilityState.GetReference();
	TestEffectParams.AbilityInputContext.AbilityTemplateName = AbilityState.GetMyTemplateName();
	TestEffectParams.ItemStateObjectRef = AbilityState.SourceWeapon;
	TestEffectParams.AbilityStateObjectRef = AbilityState.GetReference();
	TestEffectParams.SourceStateObjectRef = SourceUnit.GetReference();
	TestEffectParams.PlayerStateObjectRef = SourceUnit.ControllingPlayer;
	TestEffectParams.TargetStateObjectRef = TargetRef;
	if (bAsPrimaryTarget)
		TestEffectParams.AbilityInputContext.PrimaryTarget = TargetRef;

	// Start Issue #923
	MinDamagePreview.Damage = ApplyPreDefaultDamageModifierEffects(History, SourceUnit, TargetUnit, AbilityState, TestEffectParams, MinDamagePreview.Damage, DamageMods, false);
	MoveDamageModItemsAlt(MinDamagePreview.BonusDamageInfo, DamageMods);
	MaxDamagePreview.Damage = ApplyPreDefaultDamageModifierEffects(History, SourceUnit, TargetUnit, AbilityState, TestEffectParams, MaxDamagePreview.Damage, DamageMods, false);
	MoveDamageModItemsAlt(MaxDamagePreview.BonusDamageInfo, DamageMods);
	// End Issue #923

	if (TargetUnit != none)
	{
		foreach TargetUnit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectTemplate = EffectState.GetX2Effect();
			EffectDmg = EffectTemplate.GetBaseDefendingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MinDamagePreview.Damage, self);
			BaseEffectDmgModMin += EffectDmg;
			if (EffectDmg != 0)
			{
				DamageModInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
				DamageModInfo.Value = EffectDmg;
				MinDamagePreview.BonusDamageInfo.AddItem(DamageModInfo);
			}
			EffectDmg = EffectTemplate.GetBaseDefendingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MaxDamagePreview.Damage, self);
			BaseEffectDmgModMax += EffectDmg;
			if (EffectDmg != 0)
			{
				DamageModInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
				DamageModInfo.Value = EffectDmg;
				MaxDamagePreview.BonusDamageInfo.AddItem(DamageModInfo);
			}
		}
		MinDamagePreview.Damage += BaseEffectDmgModMin;
		MaxDamagePreview.Damage += BaseEffectDmgModMax;
	}

	foreach SourceUnit.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		EffectTemplate = EffectState.GetX2Effect();

		EffectDmg = EffectTemplate.GetAttackingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MinDamagePreview.Damage);
		MinDamagePreview.Damage += EffectDmg;
		if( EffectDmg != 0 )
		{
			DamageModInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
			DamageModInfo.Value = EffectDmg;
			MinDamagePreview.BonusDamageInfo.AddItem(DamageModInfo);
		}
		EffectDmg = EffectTemplate.GetAttackingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MaxDamagePreview.Damage);
		MaxDamagePreview.Damage += EffectDmg;
		if( EffectDmg != 0 )
		{
			DamageModInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
			DamageModInfo.Value = EffectDmg;
			MaxDamagePreview.BonusDamageInfo.AddItem(DamageModInfo);
		}

		EffectDmg = EffectTemplate.GetExtraArmorPiercing(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams);
		MinDamagePreview.Pierce += EffectDmg;
		MaxDamagePreview.Pierce += EffectDmg;

		EffectDmg = EffectTemplate.GetExtraShredValue(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams);
		MinDamagePreview.Shred += EffectDmg;
		MaxDamagePreview.Shred += EffectDmg;
	}

	// run through the effects again for any conditional shred.  A second loop as it is possibly dependent on shred outcome of the unconditional first loop.
	UnconditionalShred = MinDamagePreview.Shred;
	foreach SourceUnit.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		EffectTemplate = EffectState.GetX2Effect();

		EffectDmg = EffectTemplate.GetConditionalExtraShredValue(UnconditionalShred, EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams);
		MinDamagePreview.Shred += EffectDmg;
		MaxDamagePreview.Shred += EffectDmg;
	}

	if (TargetUnit != none)
	{
		foreach TargetUnit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectTemplate = EffectState.GetX2Effect();
			EffectDmg = EffectTemplate.GetDefendingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MinDamagePreview.Damage, self);
			MinDamagePreview.Damage += EffectDmg;
			if( EffectDmg != 0 )
			{
				DamageModInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
				DamageModInfo.Value = EffectDmg;
				MinDamagePreview.BonusDamageInfo.AddItem(DamageModInfo);
			}
			EffectDmg = EffectTemplate.GetDefendingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MaxDamagePreview.Damage, self);
			MaxDamagePreview.Damage += EffectDmg;
			if (EffectDmg != 0)
			{
				DamageModInfo.SourceEffectRef = EffectState.ApplyEffectParameters.EffectRef;
				DamageModInfo.Value = EffectDmg;
				MaxDamagePreview.BonusDamageInfo.AddItem(DamageModInfo);
			}
		}
	}

	// Start Issue #923
	MinDamagePreview.Damage = ApplyPostDefaultDamageModifierEffects(History, SourceUnit, TargetUnit, AbilityState, TestEffectParams, MinDamagePreview.Damage, DamageMods, false);
	MoveDamageModItemsAlt(MinDamagePreview.BonusDamageInfo, DamageMods);
	MaxDamagePreview.Damage = ApplyPostDefaultDamageModifierEffects(History, SourceUnit, TargetUnit, AbilityState, TestEffectParams, MaxDamagePreview.Damage, DamageMods, false);
	MoveDamageModItemsAlt(MaxDamagePreview.BonusDamageInfo, DamageMods);
	// End Issue #923

	if (!bDoesDamageIgnoreShields)
		AllowsShield += MaxDamagePreview.Damage;
}

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
	local int EnvironmentDamage, TargetBaseDmgMod;
	local XComDestructibleActor kDestructibleActorTarget;
	local array<X2WeaponUpgradeTemplate> WeaponUpgradeTemplates;
	local X2WeaponUpgradeTemplate WeaponUpgradeTemplate;
	local X2MultiWeaponTemplate MultiWeaponTemplate;
	local DamageModifierInfo ModifierInfo;
	local bool bWasImmune, bHadAnyDamage;

	ArmorMitigation = 0;
	NewRupture = 0;
	NewShred = 0;
	EnvironmentDamage = 0;
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

	`log("===" $ GetFuncName() $ "===", true, 'XCom_HitRolls');

	if (kSourceItem != none)
	{
		`log("Attacker ID:" @ kSourceUnit.ObjectID @ "With Item ID:" @ kSourceItem.ObjectID @ "Target ID:" @ ApplyEffectParameters.TargetStateObjectRef.ObjectID, true, 'XCom_HitRolls');
		if (!bIgnoreBaseDamage)
		{
			MultiWeaponTemplate = X2MultiWeaponTemplate(kSourceItem.GetMyTemplate());
			if (MultiWeaponTemplate != none)
				BaseDamageValue = MultiWeaponTemplate.AltBaseDamage;
			else
				kSourceItem.GetBaseWeaponDamageValue(XComGameState_BaseObject(kTarget), BaseDamageValue);

			if (MultiWeaponTemplate != none)
				EnvironmentDamage += MultiWeaponTemplate.iAltEnvironmentDamage;
			else
				EnvironmentDamage += kSourceItem.GetItemEnvironmentDamage();

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
				EnvironmentDamage += LoadedAmmo.GetItemEnvironmentDamage();
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

					//	Start Issue #896
					/// HL-Docs: ref:Bugfixes; issue:896
					///	Call the (hopefully) relevant delegate, if this weapon upgrade has it.
					/// This makes the guaranteed damage on missed shots added by Stocks properly benefit from Insider Knowledge
					if (WeaponUpgradeTemplate.GetBonusAmountFn != none)
					{
						UpgradeDamageValue.Damage += WeaponUpgradeTemplate.GetBonusAmountFn(WeaponUpgradeTemplate);
					}
					else
					{
						UpgradeDamageValue.Damage += UpgradeTemplateBonusDamage.Damage;
					}
					//	End Issue #896
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
	if( kDestructibleActorTarget != None && !kDestructibleActorTarget.IsTargetable() )
	{
		return EnvironmentDamage;
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

	`log(`ShowVar(bIgnoreBaseDamage) @ `ShowVar(DamageTag), true, 'XCom_HitRolls');
	`log("Weapon damage:" @ WeaponDamage @ "Potential spread:" @ DamageSpread, true, 'XCom_HitRolls');

	if (DamageSpread > 0)
	{
		WeaponDamage += DamageSpread;                          //  set to max damage based on spread
		WeaponDamage -= `SYNC_RAND(DamageSpread * 2 + 1);      //  multiply spread by 2 to get full range off base damage, add 1 as rand returns 0:x-1, not 0:x
	}
	`log("Damage with spread:" @ WeaponDamage, true, 'XCom_HitRolls');
	if (PlusOneDamage(BaseDamageValue.PlusOne))
	{
		WeaponDamage++;
		`log("Rolled for PlusOne off BaseDamage, succeeded. Damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}
	if (PlusOneDamage(ExtraDamageValue.PlusOne))
	{
		WeaponDamage++;
		`log("Rolled for PlusOne off ExtraDamage, succeeded. Damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}
	if (PlusOneDamage(BonusEffectDamageValue.PlusOne))
	{
		WeaponDamage++;
		`log("Rolled for PlusOne off BonusEffectDamage, succeeded. Damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}
	if (PlusOneDamage(AmmoDamageValue.PlusOne))
	{
		WeaponDamage++;
		`log("Rolled for PlusOne off AmmoDamage, succeeded. Damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}

	if (ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
	{
		WeaponDamage += CritDamage;
		`log("CRIT! Adjusted damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}
	else if (ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Graze)
	{
		WeaponDamage *= GRAZE_DMG_MULT;
		`log("GRAZE! Adjusted damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}

	RuptureAmount = min(kTarget.GetRupturedValue() + NewRupture, RuptureCap);
	if (RuptureAmount != 0)
	{
		WeaponDamage += RuptureAmount;
		`log("Target is ruptured, increases damage by" @ RuptureAmount $", new damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}

	if( kSourceUnit != none)
	{
		// Start Issue #923
		WeaponDamage = ApplyPreDefaultDamageModifierEffects(History, kSourceUnit, kTarget, kAbility, ApplyEffectParameters, WeaponDamage, SpecialDamageMessages,, NewGameState);
		// End Issue #923

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
					`log("Defender effect" @ EffectTemplate.EffectName @ "adjusting base damage by" @ EffectDmg, true, 'XCom_HitRolls');

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
				`log("Total base damage after defender effect mods:" @ WeaponDamage, true, 'XCom_HitRolls');
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
				`log("Attacker effect" @ EffectTemplate.EffectName @ "adjusting damage by" @ EffectDmg $ ", new damage:" @ WeaponDamage, true, 'XCom_HitRolls');				

				ModifierInfo.Value += EffectDmg;
			}
			EffectDmg = EffectTemplate.GetExtraArmorPiercing(EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters);
			if (EffectDmg != 0)
			{
				ArmorPiercing += EffectDmg;
				`log("Attacker effect" @ EffectTemplate.EffectName @ "adjusting armor piercing by" @ EffectDmg $ ", new pierce:" @ ArmorPiercing, true, 'XCom_HitRolls');				

				ModifierInfo.Value += EffectDmg;
			}
			EffectDmg = EffectTemplate.GetExtraShredValue(EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters);
			if (EffectDmg != 0)
			{
				NewShred += EffectDmg;
				`log("Attacker effect" @ EffectTemplate.EffectName @ "adjust new shred value by" @ EffectDmg $ ", new shred:" @ NewShred, true, 'XCom_HitRolls');

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
				`log("Attacker effect" @ EffectTemplate.EffectName @ "adjust new shred value by" @ EffectDmg $ ", new shred:" @ NewShred, true, 'XCom_HitRolls');

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
					`log("Defender effect" @ EffectTemplate.EffectName @ "adjusting damage by" @ EffectDmg $ ", new damage:" @ WeaponDamage, true, 'XCom_HitRolls');				

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

		// Start Issue #923
		WeaponDamage = ApplyPostDefaultDamageModifierEffects(History, kSourceUnit, kTarget, kAbility, ApplyEffectParameters, WeaponDamage, SpecialDamageMessages,, NewGameState);
		// End Issue #923

		if (kTarget != none && !bIgnoreArmor)
		{
			ArmorMitigation = kTarget.GetArmorMitigation(ApplyEffectParameters.AbilityResultContext.ArmorMitigation);
			if (ArmorMitigation != 0)
			{				
				OriginalMitigation = ArmorMitigation;
				ArmorPiercing += kSourceUnit.GetCurrentStat(eStat_ArmorPiercing);				
				`log("Armor mitigation! Target armor mitigation value:" @ ArmorMitigation @ "Attacker armor piercing value:" @ ArmorPiercing, true, 'XCom_HitRolls');
				ArmorMitigation -= ArmorPiercing;				
				if (ArmorMitigation < 0)
					ArmorMitigation = 0;
				// Issue #321
				if (ArmorMitigation >= WeaponDamage)
				{ 
					if (class'X2Effect_ApplyWeaponDamage'.default.NO_MINIMUM_DAMAGE)
					{
						ArmorMitigation = WeaponDamage;
					}
					else
					{
						ArmorMitigation = WeaponDamage - 1;
					}
				}
				// End Issue #321
				if (ArmorMitigation < 0)    //  WeaponDamage could have been 0
					ArmorMitigation = 0;    
				`log("  Final mitigation value:" @ ArmorMitigation, true, 'XCom_HitRolls');
			}
		}
	}
	//Shred can only shred as much as the maximum armor mitigation
	NewShred = Min(NewShred, OriginalMitigation);
	
	if (`SecondWaveEnabled('ExplosiveFalloff'))
	{
		ApplyFalloff( WeaponDamage, kTarget, kSourceItem, kAbility, NewGameState );
	}

	TotalDamage = WeaponDamage - ArmorMitigation;

	if ((WeaponDamage > 0 && TotalDamage < 0) || (WeaponDamage < 0 && TotalDamage > 0))
	{
		// Do not allow the damage reduction to invert the damage amount (i.e. heal instead of hurt, or vice-versa).
		TotalDamage = 0;
	}
	`log("Total Damage:" @ TotalDamage, true, 'XCom_HitRolls');
	`log("Shred from this attack:" @ NewShred, NewShred > 0, 'XCom_HitRolls');

	// Set the effect's damage
	bFullyImmune = (bWasImmune && bHadAnyDamage) ? 1 : 0;
	`log("FULLY IMMUNE", bFullyImmune == 1, 'XCom_HitRolls');

	return TotalDamage;
}

function CalculateDamageValues(XComGameState_Item SourceWeapon, XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, out ApplyDamageInfo DamageInfo, out array<Name> AppliedDamageTypes)
{
	local XComGameState_Item LoadedAmmo;
	local XComGameStateHistory History;
	local WeaponDamageValue UpgradeTemplateBonusDamage;
	local array<X2WeaponUpgradeTemplate> WeaponUpgradeTemplates;
	local X2WeaponUpgradeTemplate WeaponUpgradeTemplate;
	local X2AmmoTemplate AmmoTemplate;
	local X2MultiWeaponTemplate MultiWeaponTemplate;
	
	if (SourceWeapon != None)
	{
		if (!bIgnoreBaseDamage)
		{
			MultiWeaponTemplate = X2MultiWeaponTemplate(SourceWeapon.GetMyTemplate());
			if (MultiWeaponTemplate != none)
				DamageInfo.BaseDamageValue = MultiWeaponTemplate.AltBaseDamage;
			else
				SourceWeapon.GetBaseWeaponDamageValue(TargetUnit, DamageInfo.BaseDamageValue);

			ModifyDamageValue(DamageInfo.BaseDamageValue, TargetUnit, AppliedDamageTypes);
		}

		if (DamageTag != '')
		{
			SourceWeapon.GetWeaponDamageValue(TargetUnit, DamageTag, DamageInfo.ExtraDamageValue);
			ModifyDamageValue(DamageInfo.ExtraDamageValue, TargetUnit, AppliedDamageTypes);
		}

		if (SourceWeapon.HasLoadedAmmo() && !bIgnoreBaseDamage)
		{
			History = `XCOMHISTORY;

			LoadedAmmo = XComGameState_Item(History.GetGameStateForObjectID(SourceWeapon.LoadedAmmo.ObjectID));
			AmmoTemplate = X2AmmoTemplate(LoadedAmmo.GetMyTemplate()); 
			if (AmmoTemplate != None)
			{
				AmmoTemplate.GetTotalDamageModifier(LoadedAmmo, SourceUnit, TargetUnit, DamageInfo.AmmoDamageValue);
				DamageInfo.bDoesDamageIgnoreShields = AmmoTemplate.bBypassShields || DamageInfo.bDoesDamageIgnoreShields;
			}
			else
			{
				LoadedAmmo.GetBaseWeaponDamageValue(TargetUnit, DamageInfo.AmmoDamageValue);
			}

			ModifyDamageValue(DamageInfo.AmmoDamageValue, TargetUnit, AppliedDamageTypes);
		}

		if (bAllowWeaponUpgrade)
		{
			WeaponUpgradeTemplates = SourceWeapon.GetMyWeaponUpgradeTemplates();
			foreach WeaponUpgradeTemplates(WeaponUpgradeTemplate)
			{
				if (WeaponUpgradeTemplate.BonusDamage.Tag == DamageTag)
				{
					UpgradeTemplateBonusDamage = WeaponUpgradeTemplate.BonusDamage;

					ModifyDamageValue(UpgradeTemplateBonusDamage, TargetUnit, AppliedDamageTypes);

					DamageInfo.UpgradeDamageValue.Spread += UpgradeTemplateBonusDamage.Spread;
					DamageInfo.UpgradeDamageValue.Damage += UpgradeTemplateBonusDamage.Damage;
					DamageInfo.UpgradeDamageValue.Crit += UpgradeTemplateBonusDamage.Crit;
					DamageInfo.UpgradeDamageValue.Pierce += UpgradeTemplateBonusDamage.Pierce;
					DamageInfo.UpgradeDamageValue.Rupture += UpgradeTemplateBonusDamage.Rupture;
					DamageInfo.UpgradeDamageValue.Shred += UpgradeTemplateBonusDamage.Shred;
					//  ignores PlusOne as there is no good way to add them up
				}
			}
		}
	}

	DamageInfo.BonusEffectDamageValue = GetBonusEffectDamageValue(AbilityState, SourceUnit, SourceWeapon, TargetUnit.GetReference());
	ModifyDamageValue(DamageInfo.BonusEffectDamageValue, TargetUnit, AppliedDamageTypes);
}

static private function MoveDamageModItemsAlt(out array<DamageModifierInfo> ToArray, out array<DamageModifierInfo> FromArray)
{
	local DamageModifierInfo DamageModInfo;

	foreach FromArray(DamageModInfo)
	{
		ToArray.AddItem(DamageModInfo);
	}
	FromArray.Length = 0;
}
