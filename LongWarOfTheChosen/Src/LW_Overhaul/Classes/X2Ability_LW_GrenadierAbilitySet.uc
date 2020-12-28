//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_GrenadierAbilitySet.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines all Long War Grenadier-specific abilities
//---------------------------------------------------------------------------------------

class X2Ability_LW_GrenadierAbilitySet extends X2Ability
	dependson (XComGameStateContext_Ability) config(LW_SoldierSkills);

var protectedwrite name BlueScreenBombsAbilityName;

var config int HEAVY_ORDNANCE_LW_BONUS_CHARGES;
var config int PROTECTOR_BONUS_CHARGES;
var config int HEAT_WARHEADS_PIERCE;
var config int HEAT_WARHEADS_SHRED;
var config int BLUESCREENBOMB_HACK_DEFENSE_CHANGE;
var config int VANISHINGACT_CHARGES;
var config int NEEDLE_BONUS_UNARMORED_DMG;
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_GrenadierAbilitySet.CreateTemplates --------------------------------");

	//Effects implemented in same code that handles damage falloff for both units and environment
	Templates.AddItem(PurePassive('Sapper', "img:///UILibrary_LW_Overhaul.LW_AbilitySapper", true));
	Templates.AddItem(PurePassive('CombatEngineer', "img:///UILibrary_LW_Overhaul.LW_AbilityCombatEngineer", true));
	Templates.AddItem(PurePassive('TandemWarheads', "img:///UILibrary_LW_Overhaul.LW_AbilityTandemWarheads", true));
	//Templates.AddItem(PurePassive('NeedleGrenades', "img:///UILibrary_LW_Overhaul.LW_AbilityNeedleGrenades", true));
	Templates.AddItem(NeedleGrenades());
	Templates.AddItem(PurePassive('BluescreenBombs', "img:///UILibrary_LW_Overhaul.LW_AbilityBluescreenBombs", true));
	
	Templates.AddItem(AddHeavyOrdnance_LW());
	Templates.AddItem(AddProtector());
	Templates.AddItem(AddHEATWarheads());
	Templates.AddItem(AddBombard());
	Templates.AddItem(AddGhostGrenadeAbility());
	Templates.AddItem(AddVanishingActAbility());
	Templates.AddItem(AddBiggestBooms_LW());

	//temporary common abilities so the UI will load
	Templates.AddItem(PurePassive('FireInTheHole', "img:///UILibrary_LW_Overhaul.LW_AbilityFireInTheHole", true));

	return Templates;
}

static function X2AbilityTemplate AddBiggestBooms_LW()
{
    local X2AbilityTemplate Template;
    local X2AbilityTargetStyle TargetStyle;
    local X2AbilityTrigger Trigger;
    local X2Effect_BiggestBooms_LW BiggestBoomsEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BiggestBooms_LW');
    Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_biggestbooms";
    Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
    Template.AbilityToHitCalc = default.DeadEye;
    TargetStyle = new class'X2AbilityTarget_Self';
    Template.AbilityTargetStyle = TargetStyle;
    Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
    Template.AbilityTriggers.AddItem(Trigger);
    BiggestBoomsEffect = new class'X2Effect_BiggestBooms_LW';
    BiggestBoomsEffect.BuildPersistentEffect(1, true, false, true);
    BiggestBoomsEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
    Template.AddTargetEffect(BiggestBoomsEffect);
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    return Template;
}

//this ability will increase range of thrown grenades and grenade launcher
static function X2AbilityTemplate AddBombard()
{
	local X2AbilityTemplate				Template;
	local X2Effect_Bombard				BombardEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Bombard_LW');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBombard"; 
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	BombardEffect = new class 'X2Effect_Bombard';
	BombardEffect.BuildPersistentEffect (1, true, false);
	BombardEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (BombardEffect);
	
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


//this ability grants armor piercing to all damage-causing grenades
static function X2AbilityTemplate AddHEATWarheads()
{
	local X2AbilityTemplate				Template;
	local X2Effect_HEATGrenades			HEATEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HEATWarheads');
	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityHEATWarheads"; 
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	HEATEffect = new class 'X2Effect_HEATGrenades';
	HEATEffect.Pierce = default.HEAT_WARHEADS_PIERCE;
	HEATEffect.Shred=default.HEAT_WARHEADS_SHRED;
	HEATEffect.BuildPersistentEffect (1, true, false);
	HEATEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (HEATEffect);
	
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


//this ability grants the unit +1 charge for each damaging grenade in a grenade slot
static function X2AbilityTemplate AddHeavyOrdnance_LW()
{
	local X2AbilityTemplate						Template;
	local X2Effect_BonusGrenadeSlotUse			BonusGrenadeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HeavyOrdnance_LW');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aceinthehole";  // re-use icon from base-game Heavy Ordnance
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	BonusGrenadeEffect = new class 'X2Effect_BonusGrenadeSlotUse';
	BonusGrenadeEffect.EffectName='HeavyOrdnance_LWEffect';
	BonusGrenadeEffect.bDamagingGrenadesOnly = true;
	BonusGrenadeEffect.BonusUses = default.HEAVY_ORDNANCE_LW_BONUS_CHARGES;
	BonusGrenadeEffect.SlotType = eInvSlot_GrenadePocket;
	BonusGrenadeEffect.BuildPersistentEffect (1, true, false);
	BonusGrenadeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (BonusGrenadeEffect);
	
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this ability grants the unit +1 charge for each non-damaging grenade in a grenade slot
static function X2AbilityTemplate AddProtector()
{
	local X2AbilityTemplate						Template;
	local X2Effect_BonusGrenadeSlotUse			BonusGrenadeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Protector');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityProtector";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;

	BonusGrenadeEffect = new class 'X2Effect_BonusGrenadeSlotUse';
	BonusGrenadeEffect.EffectName='ProtectorEffect';
	BonusGrenadeEffect.bNonDamagingGrenadesOnly = true;
	BonusGrenadeEffect.BonusUses = default.PROTECTOR_BONUS_CHARGES;
	BonusGrenadeEffect.SlotType = eInvSlot_GrenadePocket;
	BonusGrenadeEffect.BuildPersistentEffect (1, true, false);
	BonusGrenadeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (BonusGrenadeEffect);
	
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//This is an effect which will be added to the existing flashbang/sting grenade item/ability
static function X2Effect_PersistentStatChange CreateBluescreenBombsHackReductionEffect()
{
	local X2Effect_PersistentStatChange		HackDefenseChangeEffect;
	local X2Condition_AbilityProperty       BluescreenCondition;
	local X2Condition_UnitProperty			UnitCondition;

	HackDefenseChangeEffect = class'Helpers_LW'.static.CreateHackDefenseReductionStatusEffect(
		'Bluescreen Bombs Hack Bonus',
		default.BLUESCREENBOMB_HACK_DEFENSE_CHANGE);

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = true;
	UnitCondition.ExcludeFriendlyToSource = true;

	BluescreenCondition = new class'X2Condition_AbilityProperty';
	BluescreenCondition.OwnerHasSoldierAbilities.AddItem(default.BlueScreenBombsAbilityName);

	HackDefenseChangeEffect.TargetConditions.AddItem(UnitCondition);
	HackDefenseChangeEffect.TargetConditions.AddItem(BluescreenCondition);

	return HackDefenseChangeEffect;
}

//This is an effect which will be added to the existing flashbang/sting grenade item/ability
static function X2Effect_PersistentStatChange CreateBluescreenBombsDisorientEffect()
{
	local X2Effect_PersistentStatChange		DisorientEffect;
	local X2Condition_AbilityProperty       BluescreenCondition;
	local X2Condition_UnitProperty			UnitCondition;

	DisorientEffect = CreateRoboticDisorientedStatusEffect();

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = true;
	UnitCondition.ExcludeFriendlyToSource = true;

	BluescreenCondition = new class'X2Condition_AbilityProperty';
	BluescreenCondition.OwnerHasSoldierAbilities.AddItem(default.BlueScreenBombsAbilityName);

	DisorientEffect.TargetConditions.AddItem(UnitCondition);
	DisorientEffect.TargetConditions.AddItem(BluescreenCondition);

	return DisorientEffect;
}

static function X2Effect_PersistentStatChange CreateRoboticDisorientedStatusEffect(float DelayVisualizationSec=0.0f)
{
	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = class'X2AbilityTemplateManager'.default.DisorientedName;
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
	PersistentStatChangeEffect.BuildPersistentEffect(class'X2StatusEffects'.default.DISORIENTED_TURNS,, false,,eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.DisorientedFriendlyName, class'X2StatusEffects'.default.DisorientedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_disoriented");
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, class'X2StatusEffects'.default.DISORIENTED_MOBILITY_ADJUST);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, class'X2StatusEffects'.default.DISORIENTED_AIM_ADJUST);
	PersistentStatChangeEffect.VisualizationFn = class'X2StatusEffects'.static.DisorientedVisualization;
	PersistentStatChangeEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.DisorientedVisualizationTicked;
	PersistentStatChangeEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static. DisorientedVisualizationRemoved;
	PersistentStatChangeEffect.EffectHierarchyValue = class'X2StatusEffects'.default.DISORIENTED_HIERARCHY_VALUE;
	PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
	PersistentStatChangeEffect.bIsImpairingMomentarily = true;
	PersistentStatChangeEffect.EffectAddedFn = class'X2StatusEffects'.static.DisorientedAdded;
	PersistentStatChangeEffect.DelayVisualizationSec = DelayVisualizationSec;

	if (class'X2StatusEffects'.default.DisorientedParticle_Name != "")
	{
		PersistentStatChangeEffect.VFXTemplateName = class'X2StatusEffects'.default.DisorientedParticle_Name;
		PersistentStatChangeEffect.VFXSocket = class'X2StatusEffects'.default.DisorientedSocket_Name;
		PersistentStatChangeEffect.VFXSocketsArrayName = class'X2StatusEffects'.default.DisorientedSocketsArray_Name;
	}

	return PersistentStatChangeEffect;
}

static function X2AbilityTemplate AddGhostGrenadeAbility()
{
	local X2AbilityTemplate			Template;
	local X2Effect_TemporaryItem	TemporaryItemEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'GhostGrenade');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ghost";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.EffectName = 'GhostGrenadeEffect';
	TemporaryItemEffect.ItemName = 'GhostGrenade';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate AddVanishingActAbility()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty		TargetProperty, ShooterProperty;
	local X2Effect_ApplySmokeGrenadeToWorld WeaponEffect;
	local X2Effect_RangerStealth		StealthEffect;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2Condition_UnitEffects			NotCarryingCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'VanishingAct');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ghost"; 
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.bCrossClassEligible = false;
	Template.bIsPassive = false;
	Template.bDisplayInUITacticalText = false;
    //Template.bHideWeaponDuringFire = true;
	Template.bLimitTargetIcons = true;
	Template.bUseLaunchedGrenadeEffects = true;
    //Template.bHideAmmoWeaponDuringFire = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
    ActionPointCost.iNumPoints = 1;
    ActionPointCost.bConsumeAllPoints = true;
    Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
    Template.AddShooterEffectExclusions();
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	
	ShooterProperty = new class'X2Condition_UnitProperty';
	ShooterProperty.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterProperty);

	TargetProperty = new class'X2Condition_UnitProperty';
    TargetProperty.ExcludeDead = true;
    TargetProperty.ExcludeHostileToSource = true;
    TargetProperty.ExcludeFriendlyToSource = false;
    TargetProperty.RequireSquadmates = true;
	TargetProperty.ExcludeConcealed = true;
	TargetProperty.ExcludeCivilian = true;
	TargetProperty.ExcludeImpaired = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.IsAdvent = false;
	TargetProperty.ExcludePanicked = true;
	TargetProperty.ExcludeAlien = true;
	TargetProperty.IsBleedingOut = false;
	TargetProperty.IsConcealed = false;
	TargetProperty.ExcludeStunned = true;
	TargetProperty.IsImpaired = false;
    Template.AbilityTargetConditions.AddItem(TargetProperty);
	
	NotCarryingCondition = new class'X2Condition_UnitEffects';
	NotCarryingCondition.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_CarryingUnit');
	NotCarryingCondition.AddExcludeEffect(class'X2StatusEffects'.default.BurningName, 'AA_UnitIsBurning');
	NotCarryingCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BoundName, 'AA_UnitIsBound');
	Template.AbilityTargetConditions.AddItem(NotCarryingCondition);

	Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = default.VANISHINGACT_CHARGES;
    Template.AbilityCharges = Charges;
    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.bUseSourceWeaponLocation = false;
	RadiusMultiTarget.fTargetRadius = 2; // meters
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	
	WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
	Template.AddTargetEffect(WeaponEffect);
	Template.AddTargetEffect(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());

	StealthEffect = new class'X2Effect_RangerStealth';
    StealthEffect.BuildPersistentEffect(1, true, false, false, 8);
    StealthEffect.SetDisplayInfo(1, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
    StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
    Template.AddTargetEffect(StealthEffect);
    Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	Template.TargetingMethod = class'X2TargetingMethod_OvertheShoulder';
    Template.CinescriptCameraType = "Grenadier_GrenadeLauncher";

	Template.TargetHitSpeech = 'ActivateConcealment';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

	return Template;
}


static function X2AbilityTemplate NeedleGrenades()
{
	local X2AbilityTemplate				Template;
	local X2Effect_NeedleGrenades		Bonus;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'NeedleGrenades');

	Template.IconImage = "img:///UILibrary_LW_Overhaul.LW_AbilityNeedleGrenades";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = true;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = false;

	Bonus = new class'X2Effect_NeedleGrenades';
	Bonus.BuildPersistentEffect(1, true, false, true);
	Bonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
	Bonus.BonusDamage = default.NEEDLE_BONUS_UNARMORED_DMG;

	Template.AddTargetEffect(Bonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

defaultProperties
{
	BlueScreenBombsAbilityName="BluescreenBombs"
}
