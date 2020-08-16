//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_TechnicalAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Specialist-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_TechnicalAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(LW_SoldierSkills);

var config int FLAMETHROWER_BURNING_BASE_DAMAGE;
var config int FLAMETHROWER_BURNING_DAMAGE_SPREAD;
var config int FLAMETHROWER_DIRECT_APPLY_CHANCE;
var config int FLAMETHROWER_CHARGES;
var config int FLAMETHROWER_HIGH_PRESSURE_CHARGES;
var config int FLAMETHROWER_TILE_WIDTH;
var config int FLAMETHROWER_TILE_LENGTH;

// LW2 flamethrower targeting
var config float ROUST_RADIUS_MULTIPLIER;
var config float ROUST_RANGE_MULTIPLIER;

// Used for the vanilla flamethrower targeting
// var config int ROUST_TILE_WIDTH;
// var config int ROUST_TILE_LENGTH;

var config int ROUST_DIRECT_APPLY_CHANCE;
var config int ROUST_CHARGES;
var config float ROUST_DAMAGE_PENALTY;
var config int ROUST_HIGH_PRESSURE_CHARGES;

// LW2 flamethrower targeting
var config float INCINERATOR_RADIUS_MULTIPLIER;
var config float INCINERATOR_RANGE_MULTIPLIER;

// Used for the vanilla flamethrower targeting
var config int INCINERATOR_CONEEND_DIAMETER_MODIFIER;
var config int INCINERATOR_CONELENGTH_MODIFIER;

var config int FIRESTORM_NUM_CHARGES;
var config int FIRESTORM_HIGH_PRESSURE_CHARGES;
var config int FIRESTORM_RADIUS_METERS;
var config float FIRESTORM_DAMAGE_BONUS;
var config int SHOCK_AND_AWE_BONUS_CHARGES;
var config int JAVELIN_ROCKETS_BONUS_RANGE_TILES;
var config WeaponDamageValue BUNKER_BUSTER_DAMAGE_VALUE;
var config float BUNKER_BUSTER_RADIUS_METERS;
var config int BUNKER_BUSTER_ENV_DAMAGE;
var config int FIRE_AND_STEEL_DAMAGE_BONUS;
var config int CONCUSSION_ROCKET_RADIUS_TILES;
var config int CONCUSSION_ROCKET_TARGET_WILL_MALUS_DISORIENT;
var config int CONCUSSION_ROCKET_TARGET_WILL_MALUS_STUN;
var config WeaponDamageValue CONCUSSION_ROCKET_DAMAGE_VALUE;
var config int CONCUSSION_ROCKET_ENV_DAMAGE;
var config float BURNOUT_RADIUS;
var config int MOVEMENT_SCATTER_AIM_MODIFIER;
var config int MOVEMENT_SCATTER_TILE_MODIFIER;
var config int NUM_AIM_SCATTER_ROLLS;
var config array<name> SCATTER_REDUCTION_ABILITIES;
var config array<int> SCATTER_REDUCTION_MODIFIERS;
var config array<int> ROCKET_RANGE_PROFILE;
var config int QUICKBURN_COOLDOWN;
var config int PHOSPHORUS_BONUS_SHRED;

var name PanicImpairingAbilityName;

var localized string strMaxScatter;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_TechnicalAbilitySet.CreateTemplates --------------------------------");
	Templates.AddItem(PurePassive('HeavyArmaments', "img:///UILibrary_LW_Overhaul.LW_AbilityHeavyArmaments"));

	Templates.AddItem(CreateLWFlamethrowerAbility());

	Templates.AddItem(PurePassive('PhosphorusPassive', "img:///UILibrary_LW_Overhaul.LW_AbilityPhosphorus"));
	Templates.AddItem(PurePassive('NapalmX', "img:///UILibrary_LW_Overhaul.LW_AbilityNapalmX"));
	Templates.AddItem(PurePassive('Incinerator', "img:///UILibrary_LW_Overhaul.LW_AbilityHighPressure"));
	Templates.AddItem(AddQuickburn());
	Templates.AddItem(CreateRoustAbility());
	Templates.AddItem(CreateBurnoutAbility());
	Templates.AddItem(BurnoutPassive());
	Templates.AddItem(RoustDamage());
	Templates.AddItem(CreateFirestorm());
	Templates.AddItem(FirestormDamage());
	Templates.AddItem(CreateHighPressureAbility());
	Templates.AddItem(CreateTechnicalFireImmunityAbility());
	Templates.AddItem(CreatePhosphorusBonusAbility());

	Templates.AddItem(LWRocketLauncherAbility());
	Templates.AddItem(LWBlasterLauncherAbility());
	Templates.AddItem(PurePassive('FireInTheHole', "img:///UILibrary_LW_Overhaul.LW_AbilityFireInTheHole"));
	Templates.AddItem(PurePassive('TandemWarheads', "img:///UILibrary_LW_Overhaul.LW_AbilityTandemWarheads"));
	Templates.AddItem(AddShockAndAwe());
	Templates.AddItem(AddJavelinRockets());
	Templates.AddItem(CreateConcussionRocketAbility());
	Templates.AddItem(CreateBunkerBusterAbility());

	Templates.AddItem(CreateNapalmXPanicEffectAbility());

	Templates.AddItem(CreateFireandSteelAbility());

	return Templates;
}

//this ability increase the range of rockets fire from gauntlet
static function X2AbilityTemplate AddJavelinRockets()
{
	local X2AbilityTemplate				Template;
	local X2Effect_JavelinRockets		JavelinRocketsEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'JavelinRockets');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityJavelinRockets";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	JavelinRocketsEffect = new class 'X2Effect_JavelinRockets';
	JavelinRocketsEffect.BuildPersistentEffect (1, true, false);
	JavelinRocketsEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (JavelinRocketsEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this ability will add +1 charge to the rocket launcher portion of gauntlet
static function X2AbilityTemplate AddShockAndAwe()
{
	local X2AbilityTemplate				Template;
	local X2Effect_BonusRocketCharges	RocketChargesEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ShockAndAwe');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityShockAndAwe";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	RocketChargesEffect = new class 'X2Effect_BonusRocketCharges';
	RocketChargesEffect.BonusUses=default.SHOCK_AND_AWE_BONUS_CHARGES;
	RocketChargesEffect.SlotType=eInvSlot_SecondaryWeapon;

	RocketChargesEffect.BuildPersistentEffect (1, true, false);
	RocketChargesEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (RocketChargesEffect);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate CreateLWFlamethrowerAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityTarget_Cursor				CursorTarget;
	local X2AbilityMultiTarget_Cone_LWFlamethrower	ConeMultiTarget;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput			InputTrigger;
	local X2Effect_ApplyFireToWorld_Limited		FireToWorldEffect;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2Effect_Burning						BurningEffect;
	local X2AbilityCharges_BonusCharges			Charges;
	local X2AbilityCost_Charges					ChargeCost;
	local X2Condition_UnitEffects				SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWFlamethrower');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;
	//Template.bUseAmmoAsChargesForHUD = true;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Charges = new class'X2AbilityCharges_BonusCharges';
	Charges.InitialCharges = default.FLAMETHROWER_CHARGES;
	Charges.BonusAbility = 'HighPressure';
	Charges.BonusItem = 'HighPressureTanks';
	Charges.BonusChargesCount =  default.FLAMETHROWER_HIGH_PRESSURE_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	//ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickburn');
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	Template.AddShooterEffectExclusions();

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
	ConeMultiTarget.bUseWeaponRadius = true;
	// WOTC TODO: In LW2, X2AbilityMultiTarget_Cone_LWFlamethrower used the range
	// and radius values from the Alt weapon of the Guantlet's X2MultiWeaponTemplate.
	// All the values for all tiers were the same, so I don't think it's necessary
	// to do that, but it may be something to consider in the future.
	// ConeMultiTarget.ConeEndDiameter = default.FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	// ConeMultiTarget.ConeLength = default.FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.AddConeSizeMultiplier('Incinerator', default.INCINERATOR_RANGE_MULTIPLIER, default.INCINERATOR_RADIUS_MULTIPLIER);
	// Next line used for vanilla targeting
	// ConeMultiTarget.AddConeSizeMultiplier('Incinerator', default.INCINERATOR_CONEEND_DIAMETER_MODIFIER, default.INCINERATOR_CONELENGTH_MODIFIER);
	ConeMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AdditionalAbilities.AddItem(default.PanicImpairingAbilityName);
	//Panic effects need to come before the damage. This is needed for proper visualization ordering.
	//Effect on a successful flamethrower attack is triggering the Apply Panic Effect Ability
	Template.AddMultiTargetEffect(CreateNapalmXPanicEffect());

	Template.AdditionalAbilities.AddItem('Phosphorus');

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.25f;
	FireToWorldEffect.FireChance_Level2 = 0.15f;
	FireToWorldEffect.FireChance_Level3 = 0.10f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);
	BurningEffect.ApplyChance = default.FLAMETHROWER_DIRECT_APPLY_CHANCE;
	Template.AddMultiTargetEffect(BurningEffect);

	Template.AddMultiTargetEffect(CreateFlamethrowerDamageAbility());
	Template.AddMultiTargetEffect(FireToWorldEffect);

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.ActionFireClass = class'X2Action_Fire_Flamethrower_LW';
	// For vanilla targeting
	// Template.ActionFireClass = class'X2Action_Fire_Flamethrower';
	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.PostActivationEvents.AddItem('FlamethrowerActivated');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = LWFlamethrower_BuildVisualization;

	// Interactions with the Chosen and Shadow
	// NOTE: Does NOT increase rate of Lost spawns
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate CreatePhosphorusBonusAbility()
{
	local X2AbilityTemplate			Template;
	local X2Effect_Phosphorus		PhosphorusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Phosphorus');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityPhosphorus";
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PhosphorusEffect = new class'X2Effect_Phosphorus';
	PhosphorusEffect.BuildPersistentEffect (1, true, false);
	PhosphorusEffect.bDisplayInUI = false;
	PhosphorusEffect.BonusShred = default.PHOSPHORUS_BONUS_SHRED;
	Template.AddTargetEffect(PhosphorusEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;

}


static function X2AbilityTemplate CreateRoustAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityTarget_Cursor				CursorTarget;
	local X2AbilityMultiTarget_Cone_LWFlamethrower	ConeMultiTarget;
	local X2Condition_UnitProperty				UnitPropertyCondition, ShooterCondition;
	local X2AbilityTrigger_PlayerInput			InputTrigger;
	local X2Effect_ApplyFireToWorld_Limited		FireToWorldEffect;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2Effect_Burning						BurningEffect;
	local X2AbilityCharges_BonusCharges			Charges;
	local X2AbilityCost_Charges					ChargeCost;
	local X2Effect_FallBack						FallBackEffect;
	local X2Condition_UnitEffects				SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Roust');

	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityRoust";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY - 1;
	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);
	Template.bPreventsTargetTeleport = false;

	Charges = new class 'X2AbilityCharges_BonusCharges';
	Charges.InitialCharges = default.ROUST_CHARGES;
	Charges.BonusAbility = 'HighPressure';
	Charges.BonusItem = 'HighPressureTanks';
	Charges.BonusChargesCount =  default.ROUST_HIGH_PRESSURE_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	//ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickburn');
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	Template.AddShooterEffectExclusions();

	ShooterCondition=new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
	ConeMultiTarget.bUseWeaponRadius = false;
	ConeMultiTarget.bIgnoreBlockingCover = true;
	// Used by vanilla targeting
	// ConeMultiTarget.ConeEndDiameter = default.ROUST_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	// ConeMultiTarget.ConeLength = default.ROUST_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.AddConeSizeMultiplier('Incinerator', default.INCINERATOR_RANGE_MULTIPLIER, default.INCINERATOR_RADIUS_MULTIPLIER);
	ConeMultiTarget.AddConeSizeMultiplier(, default.ROUST_RANGE_MULTIPLIER, default.ROUST_RADIUS_MULTIPLIER);
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.20f;
	FireToWorldEffect.FireChance_Level2 = 0.00f;
	FireToWorldEffect.FireChance_Level3 = 0.00f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);
	BurningEffect.ApplyChance = default.ROUST_DIRECT_APPLY_CHANCE;
	Template.AddMultiTargetEffect(BurningEffect);

	Template.AddMultiTargetEffect(CreateFlamethrowerDamageAbility());
	Template.AddMultiTargetEffect(FireToWorldEffect);

	FallBackEffect = new class'X2Effect_FallBack';
	FallBackEffect.BehaviorTree = 'FlushRoot';
	Template.AddMultiTargetEffect(FallBackEffect);

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.ActionFireClass = class'X2Action_Fire_Flamethrower_LW';
	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.AdditionalAbilities.AddItem('RoustDamage');
	Template.PostActivationEvents.AddItem('FlamethrowerActivated');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = LWFlamethrower_BuildVisualization;

	// Interactions with the Chosen and Shadow
	// NOTE: Does NOT increase rate of Lost spawns
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate RoustDamage()
{
	local X2AbilityTemplate						Template;
	local X2Effect_RoustDamage					DamagePenalty;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'RoustDamage');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityRoust";
	Template.bDontDisplayInAbilitySummary = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;

	DamagePenalty = new class'X2Effect_RoustDamage';
	DamagePenalty.Roust_Damage_Modifier = default.ROUST_DAMAGE_PENALTY;
	DamagePenalty.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(DamagePenalty);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate CreateFirestorm()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCharges_BonusCharges			Charges;
	local X2AbilityCost_Charges					ChargeCost;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityTarget_Cursor				CursorTarget;
	local X2AbilityMultiTarget_Radius			RadiusMultiTarget;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput			InputTrigger;
	local X2Effect_ApplyFireToWorld_Limited		FireToWorldEffect;
	local X2AbilityToHitCalc_StandardAim		StandardAim;
	local X2Effect_Burning						BurningEffect;
	local X2Condition_UnitEffects				SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Firestorm');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityFirestorm";
	//Template.bUseAmmoAsChargesForHUD = true;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Charges = new class 'X2AbilityCharges_BonusCharges';
	Charges.InitialCharges = default.FIRESTORM_NUM_CHARGES;
	Charges.BonusAbility = 'HighPressure';
	Charges.BonusItem = 'HighPressureTanks';
	Charges.BonusChargesCount = default.FIRESTORM_HIGH_PRESSURE_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	//ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Quickburn');
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.AdditionalAbilities.AddItem(default.PanicImpairingAbilityName);
	//Panic effects need to come before the damage. This is needed for proper visualization ordering.
	Template.AddMultiTargetEffect(CreateNapalmXPanicEffect());

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = 0.10f;
	FireToWorldEffect.FireChance_Level2 = 0.25f;
	FireToWorldEffect.FireChance_Level3 = 0.60f;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);
	BurningEffect.ApplyChance = default.FLAMETHROWER_DIRECT_APPLY_CHANCE;
	Template.AddMultiTargetEffect(BurningEffect);

	Template.AddMultiTargetEffect(CreateFlamethrowerDamageAbility());
	Template.AddMultiTargetEffect(FireToWorldEffect);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = false;
	CursorTarget.FixedAbilityRange = 1;
	Template.AbilityTargetStyle = CursorTarget;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.FIRESTORM_RADIUS_METERS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.ActionFireClass = class'X2Action_Fire_Firestorm';
	Template.TargetingMethod = class'X2TargetingMethod_Grenade';

	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.AdditionalAbilities.AddItem('TechnicalFireImmunity');
	Template.AdditionalAbilities.AddItem('FirestormDamage');

	Template.PostActivationEvents.AddItem('FlamethrowerActivated');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = LWFlamethrower_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Interactions with the Chosen and Shadow
	// NOTE: Does NOT increase rate of Lost spawns
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate FirestormDamage()
{
	local X2AbilityTemplate						Template;
	local X2Effect_AbilityDamageMult			DamageBonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'FirestormDamage');
	Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityFirestorm";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;

	DamageBonus = new class'X2Effect_AbilityDamageMult';
	DamageBonus.Penalty = false;
	DamageBonus.Mult = false;
	DamageBonus.DamageMod = default.FIRESTORM_DAMAGE_BONUS;
	DamageBonus.ActiveAbility = 'Firestorm';
	DamageBonus.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(DamageBonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate CreateTechnicalFireImmunityAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_DamageImmunity           DamageImmunity;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TechnicalFireImmunity');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityFirestorm";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = true;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.ImmuneTypes.AddItem('Fire');
	DamageImmunity.BuildPersistentEffect(1, true, false, false);
	DamageImmunity.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	Template.AddTargetEffect(DamageImmunity);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2Effect_ApplyAltWeaponDamage CreateFlamethrowerDamageAbility()
{
	local X2Effect_ApplyAltWeaponDamage	WeaponDamageEffect;
	local X2Condition_UnitProperty		Condition_UnitProperty;
	local X2Condition_Phosphorus		PhosphorusCondition;

	WeaponDamageEffect = new class'X2Effect_ApplyAltWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;

	PhosphorusCondition = new class'X2Condition_Phosphorus';
	WeaponDamageEffect.TargetConditions.AddItem(PhosphorusCondition);

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeFriendlyToSource = false;
	WeaponDamageEffect.TargetConditions.AddItem(Condition_UnitProperty);

	return WeaponDamageEffect;
}

static function X2AbilityTemplate CreateBurnoutAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener	Trigger;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Burnout');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityIgnition";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = true;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.bDontDisplayInAbilitySummary = true;

	Template.bSkipFireAction = true;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'FlamethrowerActivated';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.bUseSourceWeaponLocation = false;
	RadiusMultiTarget.fTargetRadius = default.BURNOUT_RADIUS * 1.5; // meters
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
	Template.AddTargetEffect (WeaponEffect);

	// Fix for issue #233. Need to add a single target effect as well because for some
	// reason the multi target effect for this does not update to give the smoke cover
	// on the tile the soldier is on even though smoke is actually created there.
	Template.AddTargetEffect(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());

	Template.AddMultiTargetEffect(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());

	Template.AdditionalAbilities.AddItem('BurnoutPassive');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate BurnoutPassive()
{
	return PurePassive('BurnoutPassive', "img:///UILibrary_LW_Overhaul.LW_AbilityIgnition", false, 'eAbilitySource_Perk', true);
}

// this is a hack to allow the flamethrower to be merged with rocket launcher, but still have custom anims at each tier
function LWFlamethrower_BuildVisualization(XComGameState VisualizeGameState)
{
	local X2AbilityTemplate				AbilityTemplate;
	local AbilityInputContext			AbilityContext;
	local XComGameStateContext_Ability	Context;
	local X2WeaponTemplate				WeaponTemplate;
	local XComGameState_Item			SourceWeapon;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);
	SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.ItemObject.ObjectID));
	if (SourceWeapon != None)
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	}
	AbilityTemplate.CustomFireAnim = 'FF_FireFlameThrower'; // default to something safe
	if(WeaponTemplate != none)
	{
		switch (WeaponTemplate.DataName)
		{
			case 'LWGauntlet_CG':
			case 'LWGauntlet_BM':
				AbilityTemplate.CustomFireAnim = 'FF_FireFlameThrower_Lv2'; // use the fancy animation
				break;
			default:
				break;
		}
	}

	//Continue building the visualization as normal.
	TypicalAbility_BuildVisualization(VisualizeGameState);
}


static function X2Effect_ImmediateMultiTargetAbilityActivation CreateNapalmXPanicEffect()
{
	local X2Effect_ImmediateMultiTargetAbilityActivation	NapalmXEffect;
	local X2Condition_AbilityProperty						NapalmXCondition;
	local X2Condition_UnitProperty							UnitCondition;

	NapalmXEffect = new class 'X2Effect_ImmediateMultiTargetAbilityActivation';

	NapalmXEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	NapalmXEffect.EffectName = 'ImmediateDisorientOrPanic';
	NapalmXEffect.AbilityName = default.PanicImpairingAbilityName;
	NapalmXEffect.bRemoveWhenTargetDies = true;
	//NapalmXEffect.VisualizationFn = PanickingAbilityEffectTriggeredVisualization;

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = false;
	UnitCondition.ExcludeRobotic = true;
	UnitCondition.ExcludeAlive = false;
	UnitCondition.ExcludeDead = true;
	UnitCondition.FailOnNonUnits = true;
	UnitCondition.ExcludeFriendlyToSource = true;

	NapalmXCondition = new class'X2Condition_AbilityProperty';
	NapalmXCondition.OwnerHasSoldierAbilities.AddItem('NapalmX');

	NapalmXEffect.TargetConditions.AddItem(UnitCondition);
	NapalmXEffect.TargetConditions.AddItem(NapalmXCondition);

	return NapalmXEffect;
}

static function X2DataTemplate CreateNapalmXPanicEffectAbility()
{
	local X2AbilityTemplate             Template;
	local X2Condition_UnitProperty      UnitPropertyCondition;
	//local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Effect_Panicked             PanicEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.PanicImpairingAbilityName);

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');      //  ability is activated by another ability that hits

	// Target Conditions
	//
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_LWFlamethrower';

	//  Panic effect for 3-4 unblocked psi hits
	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.MinStatContestResult = 1;
	PanicEffect.MaxStatContestResult = 0;
	PanicEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(PanicEffect);

	Template.bSkipPerkActivationActions = true;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate CreateFireandSteelAbility()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_BonusWeaponDamage		DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FireandSteel');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityFireandSteel";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	DamageEffect = new class'X2Effect_BonusWeaponDamage';
	DamageEffect.BonusDmg = default.FIRE_AND_STEEL_DAMAGE_BONUS;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function PanickingAbilityEffectTriggeredVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateContext Context;
	local XComGameStateContext_Ability TestAbilityContext;
	local int i, j;
	local XComGameStateHistory History;
	local bool bAbilityWasSuccess;
	local X2AbilityTemplate AbilityTemplate;
	local X2VisualizerInterface TargetVisualizerInterface;

	if( (EffectApplyResult != 'AA_Success') || (XComGameState_Unit(BuildTrack.StateObject_NewState) == none) )
	{
		return;
	}

	Context = VisualizeGameState.GetContext();
	AbilityContext = XComGameStateContext_Ability(Context);

	if( AbilityContext.EventChainStartIndex != 0 )
	{
		History = `XCOMHISTORY;

		// This GameState is part of a chain, which means there may be a stun to the target
		for( i = AbilityContext.EventChainStartIndex; !Context.bLastEventInChain; ++i )
		{
			Context = History.GetGameStateFromHistory(i).GetContext();

			TestAbilityContext = XComGameStateContext_Ability(Context);
			bAbilityWasSuccess = (TestAbilityContext != none) && class'XComGameStateContext_Ability'.static.IsHitResultHit(TestAbilityContext.ResultContext.HitResult);

			if( bAbilityWasSuccess &&
				TestAbilityContext.InputContext.AbilityTemplateName == default.PanicImpairingAbilityName &&
				TestAbilityContext.InputContext.SourceObject.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID &&
				TestAbilityContext.InputContext.PrimaryTarget.ObjectID == AbilityContext.InputContext.PrimaryTarget.ObjectID )
			{
				// The Panic Impairing Ability has been found with the same source and target
				// Move that ability's visualization forward to this track
				AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(TestAbilityContext.InputContext.AbilityTemplateName);

				for( j = 0; j < AbilityTemplate.AbilityTargetEffects.Length; ++j )
				{
					AbilityTemplate.AbilityTargetEffects[j].AddX2ActionsForVisualization(Context.AssociatedState, BuildTrack, TestAbilityContext.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[j]));
				}

				TargetVisualizerInterface = X2VisualizerInterface(BuildTrack.VisualizeActor);
				if (TargetVisualizerInterface != none)
				{
					TargetVisualizerInterface.BuildAbilityEffectsVisualization(Context.AssociatedState, BuildTrack);
				}
			}
		}
	}
}

static function X2AbilityTemplate LWRocketLauncherAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWRocketLauncher');
	Template.Hostility = eHostility_Offensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.bUseAmmoAsChargesForHUD = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';  // this version includes scatter

	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate LWBlasterLauncherAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LWBlasterLauncher');
	Template.Hostility = eHostility_Offensive;

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_blasterlauncher";
	Template.bUseAmmoAsChargesForHUD = true;
	Template.TargetingMethod = class'X2TargetingMethod_LWBlasterLauncher';

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.AddShooterEffectExclusions();

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.ActivationSpeech = 'BlasterLauncher';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;
}

// Custom passive to make sure it's created first
static function X2AbilityTemplate CreateHighPressureAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_UnitPostBeginPlay	PostBeginPlayTrigger;
	local X2Effect_Persistent					PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HighPressure');
	PostBeginPlayTrigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	PostBeginPlayTrigger.Priority = 40;
	Template.AbilityTriggers.AddItem(PostBeginPlayTrigger);
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityInferno";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.bCrossClassEligible =false;
	return Template;
}

static function X2AbilityTemplate CreateConcussionRocketAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Effect_PersistentStatChange		DisorientedEffect;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	//local X2Effect_SmokeGrenade				SmokeEffect;
	local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;
	local X2Effect_Stunned					StunnedEffect;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Condition_UnitType				ImmuneUnitCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ConcussionRocket');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityConcussionRocket";
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem (UnitPropertyCondition);
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	ImmuneUnitCondition = new class'X2Condition_UnitType';
	ImmuneUnitCondition.ExcludeTypes.AddItem('PsiZombie');
	ImmuneUnitCondition.ExcludeTypes.AddItem('AdvPsiWitchM2');
	ImmuneUnitCondition.ExcludeTypes.AddItem('AdvPsiWitchM3');
	Template.AbilityTargetConditions.AddItem(ImmuneUnitCondition);
	Template.AbilityMultiTargetConditions.AddItem(ImmuneUnitCondition);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = default.CONCUSSION_ROCKET_RADIUS_TILES * 1.5; // meters
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EffectDamageValue=default.CONCUSSION_ROCKET_DAMAGE_VALUE;
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.EnvironmentalDamageAmount=default.CONCUSSION_ROCKET_ENV_DAMAGE;
	//Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2,100,false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	StunnedEffect.ApplyChanceFn = ApplyChance_Concussion_Stunned;
	//Template.AddTargetEffect(StunnedEffect);
	Template.AddMultiTargetEffect(StunnedEffect);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.ApplyChanceFn = ApplyChance_Concussion_Disoriented;
	//Template.AddTargetEffect(DisorientedEffect);
	Template.AddMultiTargetEffect(DisorientedEffect);

	WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
	Template.AddMultiTargetEffect (WeaponEffect);

	Template.AddMultiTargetEffect (class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());

	Template.ActivationSpeech = 'Explosion';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;
}

static function name ApplyChance_Concussion_Stunned (const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local int RandRoll;
	local XComGameState_Ability AbilityState;
	local XComGameState_Item SourceItemState;
	local X2MultiWeaponTemplate MultiWeaponTemplate;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	SourceItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));
	MultiWeaponTemplate = X2MultiWeaponTemplate(SourceItemState.GetMyTemplate());

	UnitState = XComGameState_Unit(kNewTargetState);
	RandRoll = `SYNC_RAND_STATIC(100);
	if (UnitState != none && MultiWeaponTemplate != none)
	{
		if (RandRoll >= UnitState.GetCurrentStat (eStat_Will) - default.CONCUSSION_ROCKET_TARGET_WILL_MALUS_STUN - MultiWeaponTemplate.iAltStatStrength + 50 )
		{
			return 'AA_Success';
		}
	}
	return 'AA_EffectChanceFailed';
}

static function name ApplyChance_Concussion_Disoriented (const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local int RandRoll;

	UnitState = XComGameState_Unit(kNewTargetState);
	RandRoll = `SYNC_RAND_STATIC(100);

	if (UnitState != none)
	{
		if (!UnitState.IsStunned())
		{
			if (RandRoll >= UnitState.GetCurrentStat (eStat_Will) - default.CONCUSSION_ROCKET_TARGET_WILL_MALUS_DISORIENT)
			{
			return 'AA_Success';
			}
		}
	}
	return 'AA_EffectChanceFailed';
}


static function X2AbilityTemplate CreateBunkerBusterAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BunkerBuster');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_heavy_rockets";
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_LWRocketLauncher';
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = default.BUNKER_BUSTER_RADIUS_METERS; // meters
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EffectDamageValue=default.BUNKER_BUSTER_DAMAGE_VALUE;
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.EnvironmentalDamageAmount=default.BUNKER_BUSTER_ENV_DAMAGE;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.ActivationSpeech = 'Explosion';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Spawns more lost and always breaks Shadow
	Template.SuperConcealmentLoss = 100;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;
}


//this ability allows the next use (this turn) of smoke grenade or flashbang to be free
static function X2AbilityTemplate AddQuickburn()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Quickburn			QuickburnEffect;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Quickburn');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityQuickburn";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STASIS_LANCE_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AddShooterEffectExclusions();
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.QUICKBURN_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	QuickburnEffect = new class 'X2Effect_Quickburn';
	QuickburnEffect.BuildPersistentEffect (1, false, false, true, eGameRule_PlayerTurnEnd);
	QuickburnEFfect.EffectName = 'QuickburnEffect';
	QuickburnEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (QuickburnEffect);

	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Quickburn_BuildVisualization;
	Template.bShowActivation = false;

	return Template;
}

// plays Quickburn flyover and message when the ability is activated
static function Quickburn_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		context;
	local StateObjectReference				InteractingUnitRef;
	local VisualizationActionMetadata		EmptyTrack, BuildTrack;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover;
	local XComGameState_Ability				Ability;

	History = `XCOMHISTORY;
	context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
	InteractingUnitRef = context.InputContext.SourceObject;
	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
	SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_xcom);

}

//--------------------------------------------------------------------------------------------
//-----------------------  ROCKET SCATTER UTILITY  -------------------------------------------
//--------------------------------------------------------------------------------------------

static function vector GetScatterAmount(XComGameState_Unit Unit, vector ScatteredTargetLoc)
{
	local vector ScatterVector, ReturnPosition;
	local float EffectiveOffense;
	local int Idx, NumAimRolls, TileDistance, TileScatter;
	local float AngleRadians;
	local XComWorldData WorldData;

	`LWTRACE("GetScatterAmount: Starting Calculation");

	WorldData = `XWORLD;

	NumAimRolls = GetNumAimRolls(Unit);
	TileDistance = TileDistanceBetween(Unit, ScatteredTargetLoc);
	NumAimRolls = Min(NumAimRolls, TileDistance);  	//clamp the scatter for short range

	EffectiveOffense = GetEffectiveOffense(Unit, TileDistance);

	`LWTRACE("GetScatterAmount: (Distance) Offense=" $ EffectiveOffense $ ", Rolls=" $ NumAimRolls $ ", Tiles=" $ TileDistance);

	for(Idx=0 ; Idx < NumAimRolls  ; Idx++)
	{
		if(`SYNC_RAND_STATIC(100) >= EffectiveOffense)
			TileScatter += 1;
	}

	`LWTRACE("GetScatterAmount: (Select) TileScatter=" $ TileScatter);

	//pick a random direction in radians
	AngleRadians = `SYNC_FRAND_STATIC() * 2.0 * 3.141592653589793;
	ScatterVector.x = Cos(AngleRadians) * TileScatter * WorldData.WORLD_StepSize;
	ScatterVector.y = Sin(AngleRadians) * TileScatter * WorldData.WORLD_StepSize;
	ReturnPosition = ScatteredTargetLoc + ScatterVector;

	`LWTRACE("GetScatterAmount: (FracResult) OutVector=" $ string(ReturnPosition) $ ", InVector=" $ string(ScatteredTargetLoc) $ ", ScatterVec=" $ string(ScatterVector) $ ", Angle=" $ AngleRadians);

	ReturnPosition = WorldData.FindClosestValidLocation(ReturnPosition, true, true);

	`LWTRACE("GetScatterAmount: (ValidResult) OutVector=" $ string(ReturnPosition) $ ", InVector=" $ string(ScatteredTargetLoc) $ ", ScatterVec=" $ string(ScatterVector) $ ", Angle=" $ AngleRadians);

	return ReturnPosition;
}

static function float GetExpectedScatter(XComGameState_Unit Unit, vector TargetLoc)
{
	local float ExpectedScatter, EffectiveOffense;
	local int TileDistance;

	TileDistance = TileDistanceBetween(Unit, TargetLoc);
	EffectiveOffense = GetEffectiveOffense(Unit, TileDistance);
	ExpectedScatter = (100.0 - GetEffectiveOffense(Unit, TileDistance))/100.0 * float(GetNumAimRolls(Unit));
	`LWTRACE("ExpectedScatter=" $ ExpectedScatter $ ", EffectiveOffense=" $ EffectiveOffense $ ", TileDistance=" $ TileDistance);
	return ExpectedScatter;
}

static function float GetEffectiveOffense(XComGameState_Unit Unit, int TileDistance)
{
	local float EffectiveOffense;

	EffectiveOffense = Unit.GetCurrentStat(eStat_Offense);
	if(Unit.ActionPoints.Length <= 1)
		EffectiveOffense += default.MOVEMENT_SCATTER_AIM_MODIFIER;

	//adjust effective aim for distance
	if(default.ROCKET_RANGE_PROFILE.Length > 0)
	{
		if(TileDistance < default.ROCKET_RANGE_PROFILE.Length)
			EffectiveOffense += default.ROCKET_RANGE_PROFILE[TileDistance];
		else  //  if this tile is not configured, use the last configured tile
			EffectiveOffense += default.ROCKET_RANGE_PROFILE[default.ROCKET_RANGE_PROFILE.Length-1];
	}
	return EffectiveOffense;
}

static function int GetNumAimRolls(XComGameState_Unit Unit)
{
	local int NumAimRolls;
	local name AbilityName;
	local int Idx;

	//set up baseline value
	NumAimRolls = default.NUM_AIM_SCATTER_ROLLS;

	foreach default.SCATTER_REDUCTION_ABILITIES(AbilityName, Idx)
	{
		if(Unit.FindAbility(AbilityName).ObjectID > 0)
			NumAimRolls += default.SCATTER_REDUCTION_MODIFIERS[Idx];
	}

	if(Unit.ActionPoints.Length <= 1)
		NumAimRolls += default.MOVEMENT_SCATTER_TILE_MODIFIER;

	return NumAimRolls;
}

static function int TileDistanceBetween(XComGameState_Unit Unit, vector TargetLoc)
{
	local XComWorldData WorldData;
	local vector UnitLoc;
	local float Dist;
	local int Tiles;

	WorldData = `XWORLD;
	UnitLoc = WorldData.GetPositionFromTileCoordinates(Unit.TileLocation);
	Dist = VSize(UnitLoc - TargetLoc);
	Tiles = Dist / WorldData.WORLD_StepSize;
	return Tiles;
}


defaultProperties
{
	PanicImpairingAbilityName = "NapalmPanic"
}
