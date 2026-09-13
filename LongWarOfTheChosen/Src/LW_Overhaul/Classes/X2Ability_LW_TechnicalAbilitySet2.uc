//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_TechnicalAbilitySet2.uc
//  AUTHOR:  Merist
//  PURPOSE: Defines Flamethrower abilities for the new Gauntlet setup
//---------------------------------------------------------------------------------------

class X2Ability_LW_TechnicalAbilitySet2 extends X2Ability_LW_TechnicalAbilitySet config(LW_SoldierSkills);

var config array<name> FlamethrowerWeaponCategories;
var config array<name> FlamethrowerAbilitiesToFinalize;

var config bool bSalvoAffectsFlamethrower;
var config bool bSalvoAffectsFirestorm;

var config float Firestorm_fRadiusMultiplier;
var config bool Firestorm_bApplyIncinerator;
var config int Firestorm_BurnChance;

var config array<name> PhosphorusAbilities;
var config array<name> PhosphorusDamageTypes;

var config int NapalmX_BaseStrength;

var config int Quickburn_ActivationsPerUse;
var config bool Quickburn_bAllowCBACOverride;
var config int Quickburn_Duration;

var config array<name> FireAndSteel_AdditionalWeaponCategories;

var privatewrite name NapalmXEventName;
var privatewrite name NapalmXDamageTag;
var privatewrite name FlamethrowerEventName;
var privatewrite name FlamethrowerBurnDamageTag;
var privatewrite name FirestormEventName;

var localized string QuickburnEffectDesc;
var localized string RoustDebuffEffectDesc;
var localized string BurningFriendlyDesc;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(FlamethrowerDummy());
    Templates.AddItem(Flamethrower());
    Templates.AddItem(Roust());
    /*>>*/Templates.AddItem(RoustDamage());
    Templates.AddItem(Firestorm());
    /*>>*/Templates.AddItem(FirestormActivation());
    /*>>*/Templates.AddItem(FirestormFireImmunity());
    Templates.AddItem(Phosphorus());
    Templates.AddItem(NapalmX());
    /*>>*/Templates.AddItem(NapalmXPassive());
    Templates.AddItem(Quickburn());
    Templates.AddItem(FireAndSteel());
    Templates.AddItem(Burnout());
    /*>>*/Templates.AddItem(BurnoutPassive());
    Templates.AddItem(Incinerator());

    return Templates;
}

// Used for the Weapon UI
static function X2AbilityTemplate FlamethrowerDummy()
{
    local X2AbilityTemplate Template;
    local X2Condition_HasValidWeapon Condition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'LWFlamethrower_Dummy');

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

    Condition = new class'X2Condition_HasValidWeapon';
    Condition.bCheckCanEverBeValid = true;
    Condition.bCannotEverBeValid = true;
    Template.AbilityShooterConditions.AddItem(Condition);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    return Template;
}

static function X2AbilityTemplate Flamethrower(optional name DataName = 'LWFlamethrower')
{
    local X2AbilityTemplate                     Template;
    local X2AbilityToHitCalc_StandardAim        StandardAim;
    local X2AbilityTarget_Cursor                CursorTarget;
    local X2AbilityMultiTarget_Flamethrower     ConeMultiTarget;
    local X2AbilityCost_ActionPoints            ActionPointCost;
    local X2AbilityCharges_Extended             Charges;
    local X2AbilityCost_Charges                 ChargeCost;
    local X2Effect_Burning                      BurningEffect;
    local X2Effect_ApplyWeaponDamage            DamageEffect;
    local X2Effect_ApplyFireToWorld_Limited     FireToWorldEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

    Template.bCrossClassEligible = false;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bGuaranteedHit = true;
    StandardAim.bAllowCrit = false;
    Template.AbilityToHitCalc = StandardAim;

    CursorTarget = new class'X2AbilityTarget_Cursor';
    CursorTarget.bRestrictToWeaponRange = true;
    Template.AbilityTargetStyle = CursorTarget;

    Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

    ConeMultiTarget = new class'X2AbilityMultiTarget_Flamethrower';
    ConeMultiTarget.bUseWeaponRadius = true;
    ConeMultiTarget.bUseWeaponRangeForLength = true;
    ConeMultiTarget.AddBonusConeSizeMultiplier('Incinerator', default.INCINERATOR_RADIUS_MULTIPLIER, default.INCINERATOR_RANGE_MULTIPLIER);
    ConeMultiTarget.bIgnoreBlockingCover = true;
    ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    AddShooterSuppressedExclusions(Template);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    if (default.bSalvoAffectsFlamethrower)
    {
        ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
    }
    Template.AbilityCosts.AddItem(ActionPointCost);

    Charges = new class'X2AbilityCharges_Extended';
    Charges.InitialCharges = default.FLAMETHROWER_CHARGES;
    Charges.AddBonusChargeFromItem('HighPressureTanks', default.FLAMETHROWER_HIGH_PRESSURE_CHARGES);
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    BurningEffect = FlamethrowerBurningEffect();
    BurningEffect.ApplyChance = default.FLAMETHROWER_DIRECT_APPLY_CHANCE;
    Template.AddMultiTargetEffect(BurningEffect);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(DamageEffect);

    FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
    FireToWorldEffect.bUseFireChanceLevel = true;
    FireToWorldEffect.bDamageFragileOnly = true;
    FireToWorldEffect.FireChance_Level1 = 0.25f;
    FireToWorldEffect.FireChance_Level2 = 0.15f;
    FireToWorldEffect.FireChance_Level3 = 0.10f;
    FireToWorldEffect.bCheckForLOSFromTargetLocation = false; // The flamethrower does its own LOS filtering
    Template.AddMultiTargetEffect(FireToWorldEffect);

    Template.AddMultiTargetEffect(NapalmXActivationEffect());

    Template.bCheckCollision = true;
    Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = true;

    Template.ActionFireClass = class'X2Action_Fire_Flamethrower_LW';

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

    // Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.ActivationSpeech = 'Flamethrower';
    Template.CinescriptCameraType = "Soldier_HeavyWeapons";

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

    Template.PostActivationEvents.AddItem(default.FlamethrowerEventName);

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2Effect_Burning FlamethrowerBurningEffect()
{
    local X2Effect_Burning              BurningEffect;
    local X2Effect_ApplyWeaponDamage    BurnDamage;

    BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(
        default.FLAMETHROWER_BURNING_BASE_DAMAGE, default.FLAMETHROWER_BURNING_DAMAGE_SPREAD);

    BurnDamage = BurningEffect.GetBurnDamage();
    BurnDamage.DamageTag = default.FlamethrowerBurnDamageTag;

    BurningEffect.FriendlyDescription = default.BurningFriendlyDesc;

    return BurningEffect;
}

static function X2AbilityTemplate Roust()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityMultiTarget_Flamethrower ConeMultiTarget;
    local X2AbilityCharges_Extended         Charges;
    local X2Effect_Burning                  BurningEffect;
    local X2Effect_ApplyWeaponDamage        DamageEffect;
    local X2Effect_PersistentStatChange     StatChangeEffect;
    local X2Effect_ApplyFireToWorld_Limited FireToWorldEffect;
    local X2Effect_FallBack                 FallBackEffect;

    Template = Flamethrower('Roust');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityRoust";
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

    ConeMultiTarget = new class'X2AbilityMultiTarget_Flamethrower';
    ConeMultiTarget.bUseWeaponRadius = true;
    ConeMultiTarget.bUseWeaponRangeForLength = true;
    ConeMultiTarget.AddBonusConeSizeMultiplier(, default.ROUST_RADIUS_MULTIPLIER, default.ROUST_RANGE_MULTIPLIER);
    ConeMultiTarget.AddBonusConeSizeMultiplier('Incinerator', default.INCINERATOR_RADIUS_MULTIPLIER, default.INCINERATOR_RANGE_MULTIPLIER);
    ConeMultiTarget.bIgnoreBlockingCover = true;
    ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = ConeMultiTarget;

    Charges = new class'X2AbilityCharges_Extended';
    Charges.InitialCharges = default.ROUST_CHARGES;
    Charges.AddBonusChargeFromItem('HighPressureTanks', default.ROUST_HIGH_PRESSURE_CHARGES);
    Template.AbilityCharges = Charges;

    Template.AbilityMultiTargetEffects.Length = 0;

    BurningEffect = FlamethrowerBurningEffect();
    BurningEffect.ApplyChance = default.ROUST_DIRECT_APPLY_CHANCE;
    Template.AddMultiTargetEffect(BurningEffect);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(DamageEffect);

    StatChangeEffect = new class'X2Effect_PersistentStatChange';
    StatChangeEffect.EffectName = 'Roust_Debuff';
    StatChangeEffect.DuplicateResponse = eDupe_Refresh;
    StatChangeEffect.AddPersistentStatChange(eStat_Mobility, -1 * default.ROUST_MOB_REDUCTION);
    StatChangeEffect.AddPersistentStatChange(eStat_Defense, -1 * default.ROUST_DEF_REDUCTION);
    StatChangeEffect.BuildPersistentEffect(default.ROUST_STATEFFECT_DURATION, false, false, true, eGameRule_PlayerTurnBegin);
    StatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, default.RoustDebuffEffectDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddMultiTargetEffect(StatChangeEffect);

    FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
    FireToWorldEffect.bUseFireChanceLevel = true;
    FireToWorldEffect.bDamageFragileOnly = true;
    FireToWorldEffect.FireChance_Level1 = 0.20f;
    FireToWorldEffect.FireChance_Level2 = 0.00f;
    FireToWorldEffect.FireChance_Level3 = 0.00f;
    FireToWorldEffect.bCheckForLOSFromTargetLocation = false; // The flamethrower does its own LOS filtering
    Template.AddMultiTargetEffect(FireToWorldEffect);

    FallBackEffect = new class'X2Effect_FallBack';
    FallBackEffect.BehaviorTree = 'FlushRoot';
    Template.AddMultiTargetEffect(FallBackEffect);

    Template.AddMultiTargetEffect(NapalmXActivationEffect());

    Template.AdditionalAbilities.AddItem('Roust_DamagePenalty');

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2AbilityTemplate RoustDamage()
{
    local X2AbilityTemplate         Template;
    local X2Effect_DamageModifier   Effect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Roust_DamagePenalty');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityRoust";
    Template.AbilitySourceName = 'eAbilitySource_Item';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    Effect = new class'X2Effect_DamageModifier';
    Effect.EffectName = 'Roust_DamagePenalty';
    Effect.DamageModifier = -1 * 100 * default.ROUST_DAMAGE_PENALTY;
    Effect.AllowedAbilities.AddItem('Roust');
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
    Template.AddTargetEffect(Effect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2AbilityTemplate Firestorm(name DataName = 'Firestorm')
{
    local X2AbilityTemplate                     Template;
    local X2AbilityToHitCalc_StandardAim        StandardAim;
    local X2AbilityTarget_Cursor                CursorTarget;
    local X2AbilityMultiTarget_Firestorm        RadiusMultiTarget;
    local X2AbilityCost_ActionPoints            ActionPointCost;
    local X2AbilityCharges_Extended             Charges;
    local X2AbilityCost_Charges                 ChargeCost;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityFirestorm";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

    Template.bCrossClassEligible = false;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bGuaranteedHit = true;
    StandardAim.bAllowCrit = false;
    Template.AbilityToHitCalc = StandardAim;

    CursorTarget = new class'X2AbilityTarget_Cursor';
    Template.AbilityTargetStyle = CursorTarget;

    Template.TargetingMethod = class'X2TargetingMethod_PathTarget';

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Firestorm';
    if (default.FIRESTORM_RADIUS_METERS > 0)
    {
        RadiusMultiTarget.fTargetRadius = default.FIRESTORM_RADIUS_METERS;
    }
    else
    {
        RadiusMultiTarget.bUseWeaponRadius = true;
        RadiusMultiTarget.AddRadiusMultiplier(, default.Firestorm_fRadiusMultiplier);
    }
    if (default.Firestorm_bApplyIncinerator)
    {
        RadiusMultiTarget.AddRadiusMultiplier('Incinerator', default.INCINERATOR_RANGE_MULTIPLIER);
    }
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    AddShooterSuppressedExclusions(Template);

    ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 2;
    ActionPointCost.bConsumeAllPoints = true;
    if (default.bSalvoAffectsFirestorm)
    {
        ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
    }
    Template.AbilityCosts.AddItem(ActionPointCost);

    Charges = new class'X2AbilityCharges_Extended';
    Charges.InitialCharges = default.FIRESTORM_NUM_CHARGES;
    Charges.AddBonusChargeFromItem('HighPressureTanks', default.FIRESTORM_HIGH_PRESSURE_CHARGES);
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

    Template.bCheckCollision = true;
    Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = true;

    // Template.ActionFireClass = class'X2Action_Fire_Firestorm';
    Template.bSKipFireAction = true;
    Template.bShowActivation = true;

    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

    Template.DamagePreviewFn = Firestorm_DamagePreview;

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.ActivationSpeech = 'Flamethrower';

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

    Template.PostActivationEvents.AddItem(default.FirestormEventName);

    Template.AdditionalAbilities.AddItem('Firestorm_Activation');
    Template.AdditionalAbilities.AddItem('Firestorm_FireImmunity');

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

function bool Firestorm_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
    local XComGameStateHistory      History;
    local XComGameState_Unit        AbilityOwner;
    local StateObjectReference      PreviewAbilityRef;
    local XComGameState_Ability     PreviewAbilityState;

    History = `XCOMHISTORY;

    AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
    PreviewAbilityRef = AbilityOwner.FindAbility('Firestorm_Activation');
    PreviewAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(PreviewAbilityRef.ObjectID));
    if (PreviewAbilityState != none)
    {
        PreviewAbilityState.GetDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
    }

    return true;
}

static function X2AbilityTemplate FirestormActivation(name DataName = 'Firestorm_Activation')
{
    local X2AbilityTemplate                     Template;
    local X2AbilityToHitCalc_StandardAim        StandardAim;
    local X2AbilityMultiTarget_Firestorm        RadiusMultiTarget;
    local X2AbilityTrigger_EventListener        Trigger;
    local X2Effect_Burning                      BurningEffect;
    local X2Effect_ApplyWeaponDamage            DamageEffect;
    local X2Effect_ApplyFireToWorld_Limited     FireToWorldEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, DataName);

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityFirestorm";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Offensive;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;

    Template.bCrossClassEligible = false;

    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bGuaranteedHit = true;
    StandardAim.bAllowCrit = false;
    Template.AbilityToHitCalc = StandardAim;

    Template.AbilityTargetStyle = default.SelfTarget;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Firestorm';
    if (default.FIRESTORM_RADIUS_METERS > 0)
    {
        RadiusMultiTarget.fTargetRadius = default.FIRESTORM_RADIUS_METERS;
    }
    else
    {
        RadiusMultiTarget.bUseWeaponRadius = true;
        RadiusMultiTarget.AddRadiusMultiplier(, default.Firestorm_fRadiusMultiplier);
    }
    if (default.Firestorm_bApplyIncinerator)
    {
        RadiusMultiTarget.AddRadiusMultiplier('Incinerator', default.INCINERATOR_RANGE_MULTIPLIER);
    }
    RadiusMultiTarget.bIgnoreBlockingCover = true;
    RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = default.FirestormEventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 80;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
    AddShooterSuppressedExclusions(Template);

    BurningEffect = FlamethrowerBurningEffect();
    if (default.Firestorm_BurnChance > 0)
        BurningEffect.ApplyChance = default.Firestorm_BurnChance;
    else
        BurningEffect.ApplyChance = default.FLAMETHROWER_DIRECT_APPLY_CHANCE;
    Template.AddMultiTargetEffect(BurningEffect);

    DamageEffect = new class'X2Effect_ApplyWeaponDamage';
    DamageEffect.EffectDamageValue.Damage = default.FIRESTORM_DAMAGE_BONUS;
    DamageEffect.EffectDamageValue.DamageType = 'Fire';
    DamageEffect.EnvironmentalDamageAmount = default.FIRESTORM_ENV_DAMAGE;
    DamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(DamageEffect);

    FireToWorldEffect = new class'X2Effect_ApplyFireToWorld_Limited';
    FireToWorldEffect.bUseFireChanceLevel = true;
    FireToWorldEffect.bDamageFragileOnly = true;
    FireToWorldEffect.FireChance_Level1 = 0.15f;
    FireToWorldEffect.FireChance_Level2 = 0.25f;
    FireToWorldEffect.FireChance_Level3 = 0.60f;
    FireToWorldEffect.bCheckForLOSFromTargetLocation = false; // The flamethrower does its own LOS filtering
    Template.AddMultiTargetEffect(FireToWorldEffect);

    Template.AddMultiTargetEffect(NapalmXActivationEffect());

    Template.bCheckCollision = true;
    Template.bAffectNeighboringTiles = true;
    Template.bFragileDamageOnly = true;

    Template.ActionFireClass = class'X2Action_Fire_Firestorm';

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
    Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
    Template.ModifyNewContextFn = Firestorm_ModifyContext;

    Template.CinescriptCameraType = "Soldier_HeavyWeapons";

    Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
    Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;

    Template.PostActivationEvents.AddItem(default.FlamethrowerEventName);

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function Firestorm_ModifyContext(XComGameStateContext Context)
{
    local XComGameStateContext_Ability AbilityContext;
    local XComGameState_Unit UnitState;
    local XComGameStateHistory History;

    History = `XCOMHISTORY;
    AbilityContext = XComGameStateContext_Ability(Context);
    UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

    AbilityContext.InputContext.TargetLocations.Length = 0;
    AbilityContext.InputContext.TargetLocations.AddItem(`XWORLD.GetPositionFromTileCoordinates(UnitState.TileLocation));
}

static function X2AbilityTemplate FirestormFireImmunity()
{
    local X2AbilityTemplate         Template;
    local X2Effect_DamageImmunity   DamageImmunity;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Firestorm_FireImmunity');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityFirestorm";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    DamageImmunity = new class'X2Effect_DamageImmunity';
    DamageImmunity.EffectName = 'Firestorm_FireImmunity';
    DamageImmunity.ImmuneTypes.AddItem('Fire');
    DamageImmunity.BuildPersistentEffect(1, true, false);
    DamageImmunity.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(DamageImmunity);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2AbilityTemplate Phosphorus()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Phosphorus   PhosphorusEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'PhosphorusPassive');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityPhosphorus";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    PhosphorusEffect = new class'X2Effect_Phosphorus';
    PhosphorusEffect.EffectName = 'PhosphorusPassive';
    PhosphorusEffect.AllowedAbilities = default.PhosphorusAbilities;
    PhosphorusEffect.AllowedDamageTypes = default.PhosphorusDamageTypes;
    PhosphorusEffect.BuildPersistentEffect(1, true, false);
    PhosphorusEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(PhosphorusEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2AbilityTemplate NapalmX()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityToHitCalc_StatCheck_DamageTag ToHitCalc;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2Condition_UnitProperty          UnitPropertyCondition;
    local X2Effect_Panicked                 PanicEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'NapalmX');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityNapalmX";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    ToHitCalc = new class'X2AbilityToHitCalc_StatCheck_DamageTag';
    ToHitCalc.BaseValue = default.NapalmX_BaseStrength;
    ToHitCalc.AttackerDamageTag = default.NapalmXDamageTag;
    Template.AbilityToHitCalc = ToHitCalc;
    Template.AbilityTargetStyle = default.SimpleSingleTarget;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = default.NapalmXEventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 75;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = true;
    UnitPropertyCondition.ExcludeFriendlyToSource = true;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

    PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
    PanicEffect.MinStatContestResult = 1;
    PanicEffect.MaxStatContestResult = 0;
    PanicEffect.bRemoveWhenSourceDies = false;
    Template.AddTargetEffect(PanicEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bSkipPerkActivationActions = true;
    Template.bSkipFireAction = true;

    Template.AdditionalAbilities.AddItem('NapalmX_Passive');

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2Effect NapalmXActivationEffect()
{
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Effect_TriggerEvent         EventEffect;

    EventEffect = new class'X2Effect_TriggerEvent';
    EventEffect.TriggerEventName = default.NapalmXEventName;

    AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('NapalmX');
    EventEffect.TargetConditions.AddItem(AbilityCondition);

    return EventEffect;
}

static function X2AbilityTemplate NapalmXPassive()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_DamageBonusByEffectName  Effect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'NapalmX_Passive');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityNapalmX";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    Effect = new class'X2Effect_DamageBonusByEffectName';
    Effect.EffectName = 'NapalmX_DamageBonus';
    Effect.AddDamageBonus(class'X2StatusEffects'.default.BurningName, default.NAPALMX_BURN_DMG_BONUS);
    Effect.bMatchSourceWeapon = true;
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2AbilityTemplate Quickburn()
{
    local X2AbilityTemplate     Template;
    local X2AbilityCooldown     Cooldown;
    local X2Effect_Quickburn    QuickburnEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Quickburn');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityQuickburn";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
    Template.Hostility = eHostility_Neutral;
    Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY;
    Template.DisplayTargetHitChance = false;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = default.QUICKBURN_COOLDOWN;
    Template.AbilityCooldown = Cooldown;
    Template.AbilityCosts.AddItem(default.FreeActionCost);

    QuickburnEffect = new class'X2Effect_Quickburn';
    QuickburnEffect.EffectName = 'Quickburn';
    QuickburnEffect.AllowedAbilities = default.QUICKBURN_ABILITIES;
    QuickburnEffect.ActivationsPerUse = default.Quickburn_ActivationsPerUse;
    QuickburnEffect.bAllowCBACOverride = default.Quickburn_bAllowCBACOverride;
    QuickburnEffect.BuildPersistentEffect(default.Quickburn_Duration, false, true, false, eGameRule_PlayerTurnBegin);
    QuickburnEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, default.QuickburnEffectDesc, Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(QuickburnEffect);

    Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bSkipFireAction = true;
    Template.bShowActivation = true;

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2AbilityTemplate FireAndSteel()
{
    local X2AbilityTemplate                 Template;
    local X2Effect_DamageBonusByWeaponCat   Effect;
    local name WeaponCat;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'FireAndSteel');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityFireandSteel";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    Effect = new class'X2Effect_DamageBonusByWeaponCat';
    Effect.EffectName = 'FireAndSteel';
    Effect.AddDamageBonus(class'X2Item_LWGauntlet2'.default.Flamethrower_WeaponCat, default.FIRE_AND_STEEL_DAMAGE_BONUS);
    Effect.AddDamageBonus(class'X2Item_LWGauntlet2'.default.RocketLauncher_WeaponCat, default.FIRE_AND_STEEL_DAMAGE_BONUS);
    foreach default.FireAndSteel_AdditionalWeaponCategories(WeaponCat)
    {
        Effect.AddDamageBonus(WeaponCat, default.FIRE_AND_STEEL_DAMAGE_BONUS);
    }
    Effect.BuildPersistentEffect(1, true, false);
    Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(Effect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2AbilityTemplate Burnout()
{
    local X2AbilityTemplate                 Template;
    local X2AbilityTrigger_EventListener    Trigger;
    local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
    local X2Effect_ApplySmokeGrenadeToWorld WorldSmokeEffect;
    local X2Effect                          SmokeEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Burnout');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityIgnition";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;

    RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
    RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(default.BURNOUT_RADIUS);
    Template.AbilityMultiTargetStyle = RadiusMultiTarget;

    Trigger = new class'X2AbilityTrigger_EventListener';
    Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
    Trigger.ListenerData.EventID = default.FlamethrowerEventName;
    Trigger.ListenerData.Filter = eFilter_Unit;
    Trigger.ListenerData.Priority = 80;
    Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
    Template.AbilityTriggers.AddItem(Trigger);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

    WorldSmokeEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
    Template.AddTargetEffect(WorldSmokeEffect);
    Template.AddMultiTargetEffect(WorldSmokeEffect);

    SmokeEffect = class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect();
    Template.AddTargetEffect(SmokeEffect);
    Template.AddMultiTargetEffect(SmokeEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    Template.bSkipFireAction = true;

    Template.AdditionalAbilities.AddItem('Burnout_Passive');

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2AbilityTemplate BurnoutPassive()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   PersistentEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Burnout_Passive');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityIgnition";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = 'Burnout_Passive';
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(PersistentEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2AbilityTemplate Incinerator()
{
    local X2AbilityTemplate     Template;
    local X2Effect_Persistent   PersistentEffect;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'Incinerator');

    Template.IconImage = "img:///UILibrary_LWOTC.LW_AbilityHighPressure";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
    Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bIsPassive = true;
    Template.bUniqueSource = true;

    Template.bCrossClassEligible = false;

    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = 'Incinerator';
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(PersistentEffect);

    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

    if (default.FlamethrowerAbilitiesToFinalize.Find(Template.DataName) != INDEX_NONE)
    {
        Template.AbilityShooterConditions.AddItem(FlamethrowerWeaponCategoryCondition());
    }
    Template.DefaultSourceItemSlot = class'X2Item_LWGauntlet2'.default.Flamethrower_InventorySlot;

    return Template;
}

static function X2Condition FlamethrowerWeaponCategoryCondition()
{
    local X2Condition_HasValidWeapon Condition;

    Condition = new class'X2Condition_HasValidWeapon';
    Condition.AllowedWeaponCategories = default.FlamethrowerWeaponCategories;
    Condition.bCheckCanEverBeValid = true;

    return Condition;
}

static function AddShooterSuppressedExclusions(out X2AbilityTemplate Template)
{
    local X2Condition_UnitEffects SuppressedCondition;

    SuppressedCondition = new class'X2Condition_UnitEffects';
    SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
    SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
    Template.AbilityShooterConditions.AddItem(SuppressedCondition);
}

// Handles reattaching Flamethrower abilities to the Flamethrower weapon.
static function HandleFinalizeFlamethrowerAbilities(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState)
{
    local XComGameStateHistory      History;
    local array<XComGameState_Item> CurrentInventory;
    local XComGameState_Item        SourceWeapon, NewSourceWeapon;
    local bool                      bCheckedInventory;
    local int                       i;

    History = `XCOMHISTORY;
    for (i = 0; i < SetupData.Length; i++)
    {
        if (default.FlamethrowerAbilitiesToFinalize.Find(SetupData[i].TemplateName) != INDEX_NONE)
        {
            if (SetupData[i].SourceWeaponRef.ObjectID > 0)
            {
                if (StartState != none)
                    SourceWeapon = XComGameState_Item(StartState.GetGameStateForObjectID(SetupData[i].SourceWeaponRef.ObjectID));
                if (SourceWeapon == none)
                    SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(SetupData[i].SourceWeaponRef.ObjectID));

                if (default.FlamethrowerWeaponCategories.Find(SourceWeapon.GetWeaponCategory()) != INDEX_NONE)
                {
                    `LWTrace(" >>> '" $ SetupData[i].TemplateName $ "' is already bound to a flamethrower");
                    continue;
                }
            }

            if (!bCheckedInventory)
            {
                CurrentInventory = UnitState.GetAllInventoryItems(StartState);
                foreach CurrentInventory(SourceWeapon)
                {
                    if (default.FlamethrowerWeaponCategories.Find(SourceWeapon.GetWeaponCategory()) != INDEX_NONE)
                    {
                        NewSourceWeapon = SourceWeapon;
                        break;
                    }
                }
                bCheckedInventory = true;
            }

            if (NewSourceWeapon.ObjectID > 0)
            {
                `LWTrace(" >>> Binding ability '" $ SetupData[i].TemplateName $ "' to [" $ NewSourceWeapon.GetMyTemplateName() $ ", " $ NewSourceWeapon.InventorySlot $ "] for unit " $ UnitState.GetMyTemplateName());
                SetupData[i].SourceWeaponRef = NewSourceWeapon.GetReference();
            }
            else
            {
                `LWTrace(" >>> Failed to rebind ability '" $ SetupData[i].TemplateName $ "' for unit " $ UnitState.GetMyTemplateName());
            }
        }
    }
}

defaultproperties
{
    NapalmXEventName = NapalmX_Activated
    NapalmXDamageTag = LWNapalmX_Strength
    FlamethrowerEventName = FlamethrowerActivated
    FlamethrowerBurnDamageTag = LWFlamethrower_Burning
    FirestormEventName = LWFirestorm_Activation
}