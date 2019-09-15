// This is an Unreal Script
class X2Ability_AdditionalPurifierAbilities extends X2Ability
	config(GameData_SoldierSkills);

	var config int ADVPURIFIER_FLAMETHROWER_AMMOCOST;
var config int ADVPURIFIER_FLAMETHROWER_ACTIONPOINTCOST;
var config int ADVPURIFIER_FLAMETHROWER_TILE_LENGTH;
var config int ADVPURIFIER_FLAMETHROWER_TILE_WIDTH;
var config float ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL1;
var config float ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL2M2;
var config float ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL3M2;
var config float ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL2M3;
var config float ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL3M3;
var config array<name> ADVPURIFIER_FLAMETHROWER_GUARANTEEHIT_TYPES;

var config int ADVPURIFIER_FLAMETHROWER_DMG_PER_TICKM2;
var config int ADVPURIFIER_FLAMETHROWER_SPREAD_PER_TICKM2;
var config int ADVPURIFIER_FLAMETHROWER_DMG_PER_TICKM3;
var config int ADVPURIFIER_FLAMETHROWER_SPREAD_PER_TICKM3;

	static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CreateAdvPurifierFlamethrowerM2());
	Templates.AddItem(CreateAdvPurifierFlamethrowerM3());
	return Templates;
}


	static function X2AbilityTemplate CreateAdvPurifierFlamethrowerM2()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Cone ConeMultiTarget;
	local X2Effect_ApplyFireToWorld FireToWorldEffect;
	local X2AbilityToHitCalc_StandardAim StandardAim;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Effect_Burning BurningEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AdvPurifierFlamethrowerM2');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongSoldierClass');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;	

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.ADVPURIFIER_FLAMETHROWER_ACTIONPOINTCOST;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();
Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = default.ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL1;
	FireToWorldEffect.FireChance_Level2 = default.ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL2M2;
	FireToWorldEffect.FireChance_Level3 = default.ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL3M2;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
	Template.AddMultiTargetEffect(FireToWorldEffect);

	// Guaranteed to hit units don't get this damage
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes = default.ADVPURIFIER_FLAMETHROWER_GUARANTEEHIT_TYPES;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitTypeCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.ADVPURIFIER_FLAMETHROWER_DMG_PER_TICKM2, default.ADVPURIFIER_FLAMETHROWER_SPREAD_PER_TICKM2);
	BurningEffect.TargetConditions.AddItem(UnitTypeCondition);
	Template.AddMultiTargetEffect(BurningEffect);

	// These are the effects that hit the guaranteed unit types
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.IncludeTypes = default.ADVPURIFIER_FLAMETHROWER_GUARANTEEHIT_TYPES;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitTypeCondition);
	WeaponDamageEffect.bApplyOnMiss = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.ADVPURIFIER_FLAMETHROWER_DMG_PER_TICKM2, default.ADVPURIFIER_FLAMETHROWER_SPREAD_PER_TICKM2);
	BurningEffect.TargetConditions.AddItem(UnitTypeCondition);
	BurningEffect.bApplyOnMiss = true;
	Template.AddMultiTargetEffect(BurningEffect);

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.ADVPURIFIER_FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.ADVPURIFIER_FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.ActionFireClass = class'X2Action_Fire_Flamethrower_Purifier';

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
//BEGIN AUTOGENERATED CODE: Template Overrides 'AdvPurifierFlamethrower'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'AdvPurifierFlamethrower'

	Template.DamagePreviewFn = AdvPurifierFlamethrower_DamagePreview;

	return Template;
}

	static function X2AbilityTemplate CreateAdvPurifierFlamethrowerM3()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2AbilityMultiTarget_Cone ConeMultiTarget;
	local X2Effect_ApplyFireToWorld FireToWorldEffect;
	local X2AbilityToHitCalc_StandardAim StandardAim;
	local X2Condition_UnitType UnitTypeCondition;
	local X2Effect_Burning BurningEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AdvPurifierFlamethrowerM3');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WrongSoldierClass');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;	

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.ADVPURIFIER_FLAMETHROWER_ACTIONPOINTCOST;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();
Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);

	FireToWorldEffect = new class'X2Effect_ApplyFireToWorld';
	FireToWorldEffect.bUseFireChanceLevel = true;
	FireToWorldEffect.bDamageFragileOnly = true;
	FireToWorldEffect.FireChance_Level1 = default.ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL1;
	FireToWorldEffect.FireChance_Level2 = default.ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL2M3;
	FireToWorldEffect.FireChance_Level3 = default.ADVPURIFIER_FLAMETHROWER_FIRECHANCE_LVL3M3;
	FireToWorldEffect.bCheckForLOSFromTargetLocation = false; //The flamethrower does its own LOS filtering
	Template.AddMultiTargetEffect(FireToWorldEffect);

	// Guaranteed to hit units don't get this damage
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes = default.ADVPURIFIER_FLAMETHROWER_GUARANTEEHIT_TYPES;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitTypeCondition);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.ADVPURIFIER_FLAMETHROWER_DMG_PER_TICKM3, default.ADVPURIFIER_FLAMETHROWER_SPREAD_PER_TICKM3);
	BurningEffect.TargetConditions.AddItem(UnitTypeCondition);
	Template.AddMultiTargetEffect(BurningEffect);

	// These are the effects that hit the guaranteed unit types
	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.IncludeTypes = default.ADVPURIFIER_FLAMETHROWER_GUARANTEEHIT_TYPES;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.TargetConditions.AddItem(UnitTypeCondition);
	WeaponDamageEffect.bApplyOnMiss = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.ADVPURIFIER_FLAMETHROWER_DMG_PER_TICKM3, default.ADVPURIFIER_FLAMETHROWER_SPREAD_PER_TICKM3);
	BurningEffect.TargetConditions.AddItem(UnitTypeCondition);
	BurningEffect.bApplyOnMiss = true;
	Template.AddMultiTargetEffect(BurningEffect);

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bUseWeaponRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.ADVPURIFIER_FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = default.ADVPURIFIER_FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	Template.ActionFireClass = class'X2Action_Fire_Flamethrower_Purifier';

	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.ActivationSpeech = 'Flamethrower';
	Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
//BEGIN AUTOGENERATED CODE: Template Overrides 'AdvPurifierFlamethrower'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'AdvPurifierFlamethrower'

	Template.DamagePreviewFn = AdvPurifierFlamethrower_DamagePreview;

	return Template;
}

function bool AdvPurifierFlamethrower_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	AbilityState.GetMyTemplate().AbilityMultiTargetEffects[1].GetDamagePreview(TargetRef, AbilityState, false, MinDamagePreview, MaxDamagePreview, AllowsShield);
	return true;
}