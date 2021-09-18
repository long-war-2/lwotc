class X2Ability_Immolator extends X2Ability_DefaultAbilitySet	dependson (XComGameStateContext_Ability) config(GameData_WeaponData);

var config int FLAMETHROWER_TILE_WIDTH, FLAMETHROWER_TILE_LENGTH;
var config float FIRECHANCE_LVL1, FIRECHANCE_LVL2, FIRECHANCE_LVL3, CHEMSTORM_RADIUS_METERS, CHEMSTORM_FIRECHANCE_LVL1, CHEMSTORM_FIRECHANCE_LVL2, CHEMSTORM_FIRECHANCE_LVL3, ChemSuppress_CoverMod;
var config int Chemstorm_Ammocost, Chemstorm_Cooldown, Chemstorm_Crit, Fulmination_AmmoCost, Fulmination_Cooldown, Fumigate_AmmoCost, Fumigate_Cooldown, Medispray_Charges, Medispray_TeamSpirit_Charges, ChemSuppress_Ammo, RoaringFlame_Crit;

var config int CorrodingCompounds_Shred, CorrodingCompounds_Pierce, ThermalShock_Bonus, UnstableReaction_Bonus, DissonantEnergies_Bonus, ThermalBulwark_Chance, Fumigate_ThermalBulwark_Chance, PressureBlast_Cooldown, PressureBlast_Ammo, PressureBlast_Knockback, PressureBlast_Crit;
var config int BurningRush_Cooldown, BurningRush_Ammo, ExpandedCanister_Charges, ExpandedCanister_MedicCharges, Counteragent_Bonus, ChemKillZone_Cooldown;
var config bool ThermalShock_CrossClass, UnstableReaction_CrossClass, DissonantEnergies_CrossClass, bFUMIGATE_IS_TURN_ENDING, bMEDISPRAY_IS_TURN_ENDING, bMedispray_AffectSelf, bFumigate_AffectSelf;

var config array<name> ChemthrowerAttacks, ChemthrowerOverwatchAttacks, ChemthrowerGuardianAttacks, TeamSpirit_CleanseEffectNames, ExpandedCanister_AbilityNames, FixTargetedRangeLimitChemAbilities;
var config int Incandescence_CritMod, Incandescence_Duration, ViscousAccelerant_Bonus, ViscousAccelerant_Duration, NightmareFuel_Chance, ParticulateHaze_Duration;
var config float ParticulateHaze_VisionMult, Fulmination_Scalar, Fulmination_RemoteStart_DamageMult, Fulmination_RemoteStart_RadiusMult, DesolateHomeland_DRMult, PressureBlast_DamageBonus;

var localized string ThermalBEffectName, ThermalBEffectDesc, ChemicalDeflectorSquadName, ChemicalDeflectorSquadDesc;
var localized string IncandescenceEffectName, IncandescenceEffectDesc, ViscousAccelerantEffectName, ViscousAccelerantEffectDesc;

var config int IMMOLATOR_COOLDOWN;
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	//Immolator basic abilities
	Templates.AddItem(CreateFlameThrower());
	Templates.AddItem(CreateFlameThrowerOverwatchShot());

	Templates.AddItem(Suppression());
	Templates.AddItem(SuppressionShot());
	//Templates.AddItem(CreateFulmination());
	return Templates;
}

	

static function X2AbilityTemplate CreateFlameThrower()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Cone_LWFlamethrower	ConeMultiTarget;
	local X2AbilityToHitCalc_StandardAim	StandardAim;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2Effect_PersistentStatChange     DisorientedEffect;
	local X2Effect_ApplyMedikitHeal			MedikitHeal;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Effect_ApplyFireToWorld			FireToWorldEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityCooldown_Immolator		Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFireThrower');


	Cooldown = new class'X2AbilityCooldown_Immolator';
	Cooldown.iNumTurns = default.IMMOLATOR_COOLDOWN;
	Cooldown.SharingCooldownsWith.AddItem('Overwatch');
	Template.AbilityCooldown = Cooldown;

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongSoldierClass');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllEffects.AddItem('LWBurningRush');
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = true;
	StandardAim.bAllowCrit = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
	Template.AbilityMultiTargetConditions.AddItem(new class'X2Condition_FineControl');

	Template.bAllowBonusWeaponEffects = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = false;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = default.FIRECHANCE_LVL1;
	FireToWorldEffect.FireChance_Level2 = default.FIRECHANCE_LVL2;
	FireToWorldEffect.FireChance_Level3 = default.FIRECHANCE_LVL3;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
	Template.AddMultiTargetEffect(FireToWorldEffect);

	MedikitHeal = new class'X2Effect_ApplyMedikitHeal';
	MedikitHeal.PerUseHP = 1;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Phoenix');
	MedikitHeal.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(MedikitHeal);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.iNumTurns = 2;
	DisorientedEffect.DamageTypes.AddItem('Mental');
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('FlamePanic');
	DisorientedEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(DisorientedEffect);

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.ConeEndDiameter = default.FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleBsc', 2, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleAdv', 3, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleSup', 4, 0);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleBsc', 0, 1);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleAdv', 0, 2);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleSup', 0, 3);
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = false;

	Template.ActionFireClass =  class'X2Action_Fire_Flamethrower_LW';

	Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Iridar_Flamethrower";

	Template.PostActivationEvents.AddItem('ChemthrowerActivated');

	Template.SuperConcealmentLoss = 100;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.Hostility = eHostility_Offensive;

	return Template;
}


static function X2AbilityTemplate CreateFlameThrowerOverwatchShot()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2AbilityMultiTarget_Cone_LWFlamethrower			ConeMultiTarget;
	local X2AbilityToHitCalc_StandardAim	StandardAim;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2Condition_UnitProperty          ShooterCondition;
	local X2Effect_PersistentStatChange     DisorientedEffect;
	local X2Effect_ApplyMedikitHeal			MedikitHeal;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Effect_ApplyFireToWorld			FireToWorldEffect;
	local X2Condition_UnitImmunities		UnitImmunityCondition;
	local array<name>                       SkipExclusions;
	local X2Effect_Persistent               BladestormTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource BladestormTargetCondition;
	local X2AbilityCooldown_Immolator	Cooldown;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZFireThrowerOverwatchShot');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY + 1;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Cooldown = new class'X2AbilityCooldown_Immolator';
	Cooldown.iNumTurns = default.IMMOLATOR_COOLDOWN;
	Cooldown.SharingCooldownsWith.AddItem('MZFireThrower');
	Cooldown.SharingCooldownsWith.AddItem('Overwatch');
	Template.AbilityCooldown = Cooldown;

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint);
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	StandardAim.bOnlyMultiHitWithSuccess = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);

	// Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for over watch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = false;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	Template.AbilityTargetConditions.AddItem(new class'X2Condition_WithinChemthrowerRange');
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
	Template.AbilityMultiTargetConditions.AddItem(new class'X2Condition_FineControl');

		//Prevent repeatedly hammering on a unit with Bladestorm triggers.
	//(This effect does nothing, but enables many-to-many marking of which Bladestorm attacks have already occurred each turn.)
	BladestormTargetEffect = new class'X2Effect_Persistent';
	BladestormTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BladestormTargetEffect.EffectName = 'OverwatchTarget';
	BladestormTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(BladestormTargetEffect);
	
	BladestormTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BladestormTargetCondition.AddExcludeEffect('OverwatchTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BladestormTargetCondition);

	Template.bAllowBonusWeaponEffects = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = false;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddTargetEffect(WeaponDamageEffect);

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = default.FIRECHANCE_LVL1;
	FireToWorldEffect.FireChance_Level2 = default.FIRECHANCE_LVL2;
	FireToWorldEffect.FireChance_Level3 = default.FIRECHANCE_LVL3;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
	Template.AddMultiTargetEffect(FireToWorldEffect);

	MedikitHeal = new class'X2Effect_ApplyMedikitHeal';
	MedikitHeal.PerUseHP = 1;
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Phoenix');
	MedikitHeal.TargetConditions.AddItem(AbilityCondition);
	Template.AddShooterEffect(MedikitHeal);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.iNumTurns = 2;
	DisorientedEffect.DamageTypes.AddItem('Mental');
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('FlamePanic');
	DisorientedEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(DisorientedEffect);
	Template.AddTargetEffect(DisorientedEffect);

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.ConeEndDiameter = default.FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleBsc', 2, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleAdv', 3, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleSup', 4, 0);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleBsc', 0, 1);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleAdv', 0, 2);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleSup', 0, 3);
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = false;
	Template.bAllowFreeFireWeaponUpgrade = false;

	Template.ActionFireClass =  class'X2Action_Fire_Flamethrower_LW';

	Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

	Template.ActivationSpeech = 'Flamethrower';
	//Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildVisualizationFn = OverwatchShot_BuildVisualization;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.Hostility = eHostility_Offensive;

	return Template;
}


static function X2AbilityTemplate CreateFulmination()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_ApplyCanisterDamage		WeaponDamageEffect;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Cone_LWFlamethrower			ConeMultiTarget;
	local X2AbilityToHitCalc_StandardAim	StandardAim;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2Effect_TriggerEvent				InsanityEvent;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_RemoteStart				RemoteStartEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWFulmination');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongSoldierClass');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_gatekeeper_deathexplosion";
	Template.ShotHUDPriority = 340;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.Fulmination_AmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Fulmination_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = true;
	Template.AbilityToHitCalc = StandardAim;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	//Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
	Template.AbilityMultiTargetConditions.AddItem(new class'X2Condition_FineControl');

	Template.bAllowBonusWeaponEffects = false;

	RemoteStartEffect = new class'X2Effect_RemoteStart';
	RemoteStartEffect.UnitDamageMultiplier = default.Fulmination_RemoteStart_DamageMult;
	RemoteStartEffect.DamageRadiusMultiplier = default.Fulmination_RemoteStart_RadiusMult;
	Template.AddMultiTargetEffect(RemoteStartEffect);

	WeaponDamageEffect = new class'X2Effect_ApplyCanisterDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.Element = 'NoFireExplosion';
	WeaponDamageEffect.Scalar = default.Fulmination_Scalar;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	InsanityEvent = new class'X2Effect_TriggerEvent';
	InsanityEvent.TriggerEventName = 'LWFulminationFuse';
	InsanityEvent.ApplyChance = 100;
	Template.AddMultiTargetEffect(InsanityEvent);

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.ConeEndDiameter = default.FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleBsc', 2, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleAdv', 3, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleSup', 4, 0);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleBsc', 0, 1);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleAdv', 0, 2);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleSup', 0, 3);
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = false;

	Template.ActionFireClass =  class'X2Action_Fire_Flamethrower_LW';
	Template.CustomFireAnim = 'FF_FireLWCanister';

	Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Iridar_Flamethrower";

	Template.PostActivationEvents.AddItem('ChemthrowerActivated');
	Template.AdditionalAbilities.AddItem('LWFulminationFuse');

	Template.SuperConcealmentLoss = 100;
	Template.Hostility = eHostility_Offensive;
	Template.ConcealmentRule = eConceal_Never;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}


static function X2AbilityTemplate CreatePressureBlast()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_ApplyCanisterDamage		WeaponDamageEffect;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2AbilityToHitCalc_StandardAim	StandardAim;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityCooldown					Cooldown;
	local MZ_Effect_Knockback				KnockbackEffect;
	local X2Effect_PersistentStatChange		Disorient;
	local X2Condition_AbilityProperty		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MZPressureBlast');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongSoldierClass');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_archon_blast";
	Template.ShotHUDPriority = 335;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.PressureBlast_Ammo;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PressureBlast_Cooldown;
	Template.AbilityCooldown = Cooldown;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = true;
	StandardAim.BuiltInCritMod = default.PressureBlast_Crit;
	Template.AbilityToHitCalc = StandardAim;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
	Template.AbilityMultiTargetConditions.AddItem(new class'X2Condition_FineControl');

	Template.bAllowBonusWeaponEffects = true;

	WeaponDamageEffect = new class'X2Effect_ApplyCanisterDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.bIgnoreBaseDamage = false;
	WeaponDamageEffect.Scalar = default.PressureBlast_DamageBonus;
	//WeaponDamageEffect.EffectDamageValue.DamageType = 'Explosion';
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	KnockbackEffect = new class'MZ_Effect_Knockback';
	KnockbackEffect.KnockbackDistance = default.PressureBlast_Knockback;
	KnockbackEffect.OnlyOnDeath = false;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddMultiTargetEffect(KnockbackEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('LWOppressiveHeat');
	Disorient = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, 0, false);
	Disorient.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(Disorient);

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.ConeEndDiameter = default.FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleBsc', 2, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleAdv', 3, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleSup', 4, 0);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleBsc', 0, 1);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleAdv', 0, 2);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleSup', 0, 3);
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = false;
	Template.bPreventsTargetTeleport = true;

	Template.ActionFireClass =  class'X2Action_Fire_Flamethrower_LW';

	Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Iridar_Flamethrower";

	Template.PostActivationEvents.AddItem('ChemthrowerActivated');

	Template.SuperConcealmentLoss = 100;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.Hostility = eHostility_Offensive;

	return Template;
}


static function X2AbilityTemplate Suppression()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local X2Effect_Suppression              SuppressionEffect;
	local X2Condition_UnitProperty			TargetPropertyCondition;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2Effect_PersistentStatChange		Disorient;
	local X2Condition_AbilityProperty		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWChemthrowerSuppression');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.ChemSuppress_Ammo;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	Template.AddShooterEffectExclusions();
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveActionPoints';
	ReserveActionPointsEffect.ReserveType = 'Suppression';
	Template.AddShooterEffect(ReserveActionPointsEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	TargetPropertyCondition = new class'X2Condition_UnitProperty';
	TargetPropertyCondition.ExcludeDead = true;
	TargetPropertyCondition.TreatMindControlledSquadmateAsHostile = false;
	TargetPropertyCondition.ExcludeFriendlyToSource = true;
	TargetPropertyCondition.RequireWithinRange = true;
	TargetPropertyCondition.WithinRange = default.FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityTargetConditions.AddItem(TargetPropertyCondition);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_WithinChemthrowerRange');
	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
	Template.AbilityMultiTargetConditions.AddItem(new class'X2Condition_FineControl');

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.ActionFireClass =  class'X2Action_Fire_Flamethrower_LW';
	Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.ConeEndDiameter = default.FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleBsc', 2, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleAdv', 3, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleSup', 4, 0);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleBsc', 0, 1);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleAdv', 0, 2);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleSup', 0, 3);
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	SuppressionEffect = new class'X2Effect_Suppression';
	SuppressionEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	SuppressionEffect.bRemoveWhenTargetDies = true;
	SuppressionEffect.bRemoveWhenSourceDamaged = true;
	SuppressionEffect.bBringRemoveVisualizationForward = true;
	SuppressionEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionTargetEffectDesc, Template.IconImage);
	SuppressionEffect.SetSourceDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, class'X2Ability_GrenadierAbilitySet'.default.SuppressionSourceEffectDesc, Template.IconImage);
	Template.AddTargetEffect(SuppressionEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('LWOppressiveHeat');
	Disorient = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, 0, false);
	Disorient.TargetConditions.AddItem(AbilityCondition);
	Template.AddMultiTargetEffect(Disorient);
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.AdditionalAbilities.AddItem('LWChemthrowerSuppressionShot');
	Template.bIsASuppressionEffect = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	Template.bAllowBonusWeaponEffects = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SuppressionBuildVisualization;
	Template.BuildAppliedVisualizationSyncFn = SuppressionBuildVisualizationSync;
	Template.CinescriptCameraType = "StandardSuppression";

	Template.Hostility = eHostility_Offensive;

	Template.PostActivationEvents.AddItem('ChemthrowerActivated');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Suppression'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Suppression'

	return Template;	
}

simulated function SuppressionBuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        ActionMetadata;

	local XComGameState_Ability         Ability;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	
	class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	class'X2Action_StartSuppression'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		//****************************************************************************************
	//Configure the visualization track for the target
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Good);
	if (XComGameState_Unit(ActionMetadata.StateObject_OldState).ReserveActionPoints.Length != 0 && XComGameState_Unit(ActionMetadata.StateObject_NewState).ReserveActionPoints.Length == 0)
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(none, class'XLocalizedData'.default.OverwatchRemovedMsg, '', eColor_Good);
	}
	}

simulated function SuppressionBuildVisualizationSync(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata)
{
	local X2Action_ExitCover ExitCover;

	if (EffectName == class'X2Effect_Suppression'.default.EffectName)
	{
		ExitCover = X2Action_ExitCover(class'X2Action_ExitCover'.static.AddToVisualizationTree( ActionMetadata, VisualizeGameState.GetContext() ));
		ExitCover.bIsForSuppression = true;

		class'X2Action_StartSuppression'.static.AddToVisualizationTree( ActionMetadata, VisualizeGameState.GetContext() );
	}
}

static function X2AbilityTemplate SuppressionShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ReserveActionPoints ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityTrigger_EventListener	Trigger;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitEffectsWithAbilitySource TargetEffectCondition;
	local X2Effect_RemoveEffects            RemoveSuppression;
	local X2AbilityMultiTarget_Cone			ConeMultiTarget;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	//local X2Effect_Persistent               KillZoneEffect;
	//local X2Condition_UnitEffectsWithAbilitySource  KillZoneCondition;
	local X2Effect_PersistentStatChange		Disorient;
	local X2Condition_AbilityProperty		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWChemthrowerSuppressionShot');

	Template.bDontDisplayInAbilitySummary = true;
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem('Suppression');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	StandardAim.bOnlyMultiHitWithSuccess = false;
	StandardAim.LOW_COVER_BONUS *= default.ChemSuppress_CoverMod;
	StandardAim.HIGH_COVER_BONUS *= default.ChemSuppress_CoverMod;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_WithinChemthrowerRange');

	TargetEffectCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	TargetEffectCondition.AddRequireEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsNotSuppressed');
	Template.AbilityTargetConditions.AddItem(TargetEffectCondition);

	TargetVisibilityCondition = new class'X2Condition_Visibility';	
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	Template.bAllowAmmoEffects = false;
	
	RemoveSuppression = new class'X2Effect_RemoveEffects';
	RemoveSuppression.EffectNamesToRemove.AddItem(class'X2Effect_Suppression'.default.EffectName);
	RemoveSuppression.bCheckSource = true;
	RemoveSuppression.SetupEffectOnShotContextResult(true, true);
	//RemoveSuppression.bApplyOnMiss = true;
	Template.AddShooterEffect(RemoveSuppression);
	
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	//Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'ObjectMoved';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.TypicalOverwatchListener;
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
	Template.AbilityMultiTargetConditions.AddItem(new class'X2Condition_FineControl');

	Template.bAllowBonusWeaponEffects = false;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.AddTargetEffect(WeaponDamageEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('LWOppressiveHeat');
	Disorient = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, 0, false);
	Disorient.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(Disorient);

	
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	ConeMultiTarget.ConeEndDiameter = default.FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleBsc', 2, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleAdv', 3, 0);
	ConeMultiTarget.AddBonusConeSize('LWWidthNozzleSup', 4, 0);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleBsc', 0, 1);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleAdv', 0, 2);
	ConeMultiTarget.AddBonusConeSize('LWLengthNozzleSup', 0, 3);
	Template.AbilityMultiTargetStyle = ConeMultiTarget;
	
	
	/*
	//  Do not shoot targets that were already hit by this unit this turn with this ability
	KillZoneCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	KillZoneCondition.AddExcludeEffect('KillZoneTarget', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(KillZoneCondition);
	//  Mark the target as shot by this unit so it cannot be shot again this turn
	KillZoneEffect = new class'X2Effect_Persistent';
	KillZoneEffect.EffectName = 'KillZoneTarget';
	KillZoneEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	KillZoneEffect.SetupEffectOnShotContextResult(true, true);      //  mark them regardless of whether the shot hit or missed
	Template.AddTargetEffect(KillZoneEffect);
	*/

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = false;

	Template.ActionFireClass =  class'X2Action_Fire_Flamethrower_LW';

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';

	//don't want to exit cover, we are already in suppression/alert mode.
	Template.bSkipExitCoverWhenFiring = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bAllowFreeFireWeaponUpgrade = false;

	//Template.PostActivationEvents.AddItem('ChemthrowerActivated');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SuppressionShot'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SuppressionShot'
	
	return Template;	
}


static function ThermalBVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	if (EffectApplyResult != 'AA_Success')
		return;
	if (!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), default.ThermalBEffectName, '', eColor_Good, "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_deflectshot");
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}