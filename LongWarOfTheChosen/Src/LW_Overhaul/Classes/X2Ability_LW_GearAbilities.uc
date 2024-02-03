//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LW_GearAbilities.uc
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Defines gear-based ability templates for LW Overhaul
//--------------------------------------------------------------------------------------- 

class X2Ability_LW_GearAbilities extends X2Ability config(LW_Overhaul);

var config int SCOPE_BSC_AIM_BONUS;
var config int SCOPE_ADV_AIM_BONUS;
var config int SCOPE_SUP_AIM_BONUS;
var config int SCOPE_EMPOWER_BONUS;

var config int TRIGGER_BSC_AIM_BONUS;
var config int TRIGGER_ADV_AIM_BONUS;
var config int TRIGGER_SUP_AIM_BONUS;
var config int TRIGGER_EMPOWER_BONUS;

var config int STOCK_BSC_SW_AIM_BONUS;
var config int STOCK_ADV_SW_AIM_BONUS;
var config int STOCK_SUP_SW_AIM_BONUS;
var config int STOCK_EMPOWER_BONUS;

var config int STOCK_BSC_SUCCESS_CHANCE;
var config int STOCK_ADV_SUCCESS_CHANCE;
var config int STOCK_SUP_SUCCESS_CHANCE;

var config int CERAMIC_PLATING_HP;
var config int ALLOY_PLATING_HP;
var config int CARAPACE_PLATING_HP;
var config int CHITIN_PLATING_HP;

var config int SPARK_KEVLAR_PLATING_HP;
var config int SPARK_PLATED_PLATING_HP;
var config int SPARK_POWERED_PLATING_HP;

var config int PLATED_BIT_CRIT_REDUCE;
var config int POWERED_BIT_CRIT_REDUCE;

var config int SPARK_PLATED_ARMOR_DEF;
var config int SPARK_POWERED_ARMOR_DEF;

var config int PLATED_BIT_DODGE_BONUS;
var config int POWERED_BIT_DODGE_BONUS;
var config int PLATED_BIT_DEF_BONUS;
var config int POWERED_BIT_DEF_BONUS;

var config int NANOFIBER_CRITDEF_BONUS;

var config int BONUS_COILGUN_SHRED;

var config int BLUESCREEN_DISORIENT_CHANCE;

var localized string strWeight;
var localized string AblativeHPLabel;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	`Log("LW_GearAbilitySet.CreateTemplates --------------------------------");

	Templates.AddItem(CreateScopeBonus('Scope_LW_Bsc_Ability', default.SCOPE_BSC_AIM_BONUS));
	Templates.AddItem(CreateScopeBonus('Scope_LW_Adv_Ability', default.SCOPE_ADV_AIM_BONUS));
	Templates.AddItem(CreateScopeBonus('Scope_LW_Sup_Ability', default.SCOPE_SUP_AIM_BONUS));

	Templates.AddItem(CreateHairTriggerBonus('Hair_Trigger_LW_Bsc_Ability', default.TRIGGER_BSC_AIM_BONUS));
	Templates.AddItem(CreateHairTriggerBonus('Hair_Trigger_LW_Adv_Ability', default.TRIGGER_ADV_AIM_BONUS));
	Templates.AddItem(CreateHairTriggerBonus('Hair_Trigger_LW_Sup_Ability', default.TRIGGER_SUP_AIM_BONUS));
	
	Templates.AddItem(CreateStockSteadyWeaponAbility('Stock_LW_Bsc_Ability', default.STOCK_BSC_SW_AIM_BONUS));
	Templates.AddItem(CreateStockSteadyWeaponAbility('Stock_LW_Adv_Ability', default.STOCK_ADV_SW_AIM_BONUS));
	Templates.AddItem(CreateStockSteadyWeaponAbility('Stock_LW_Sup_Ability', default.STOCK_SUP_SW_AIM_BONUS));

	Templates.AddItem(CreateStockGrazingFireAbility('Stock_GF_Bsc_Ability', default.STOCK_BSC_SUCCESS_CHANCE));
	Templates.AddItem(CreateStockGrazingFireAbility('Stock_GF_Adv_Ability', default.STOCK_ADV_SUCCESS_CHANCE));
	Templates.AddItem(CreateStockGrazingFireAbility('Stock_GF_Sup_Ability', default.STOCK_SUP_SUCCESS_CHANCE));

	Templates.AddItem(CreateAblativeHPAbility('Ceramic_Plating_Ability', default.CERAMIC_PLATING_HP));
	Templates.AddItem(CreateAblativeHPAbility('Alloy_Plating_Ability', default.ALLOY_PLATING_HP));
	Templates.AddItem(CreateAblativeHPAbility('Chitin_Plating_Ability', default.CHITIN_PLATING_HP));
	Templates.AddItem(CreateAblativeHPAbility('Carapace_Plating_Ability', default.CARAPACE_PLATING_HP));
	Templates.AddItem(CreateAblativeHPAbility('SPARK_Kevlar_Plating_Ability', default.SPARK_KEVLAR_PLATING_HP));
	Templates.AddItem(CreateAblativeHPAbility('SPARK_Plated_Plating_Ability', default.SPARK_PLATED_PLATING_HP));
	Templates.AddItem(CreateAblativeHPAbility('SPARK_Powered_Plating_Ability', default.SPARK_POWERED_PLATING_HP));

	Templates.AddItem(CreateBonusDodgeAbility('Plated_BIT_Bonus_Dodge',default.PLATED_BIT_DODGE_BONUS));
	Templates.AddItem(CreateBonusDodgeAbility('Powered_BIT_Bonus_Dodge',default.POWERED_BIT_DODGE_BONUS));

	Templates.AddItem(CreateBonusDefAbility('SPARK_Plated_Armor_Def', default.SPARK_PLATED_ARMOR_DEF));
	Templates.AddItem(CreateBonusDefAbility('SPARK_Powered_Armor_Def', default.SPARK_POWERED_ARMOR_DEF));

	Templates.AddItem(CreateHazmatVestBonusAbility_LW());
	Templates.AddItem(CreateNanofiberBonusAbility_LW());
	Templates.AddItem(CreateNeurowhipAbility());
	Templates.AddItem(CreateStilettoRoundsAbility());
	Templates.AddItem(CreateFlechetteRoundsAbility());

	Templates.AddItem(PurePassive('Needle_Rounds_Ability', "img:///UILibrary_PerkIcons.UIPerk_ammo_needle", false, 'eAbilitySource_Item'));
	Templates.AddItem(PurePassive('Redscreen_Rounds_Ability', "img:///UILibrary_LWOTC.LW_AbilityRedscreen", false, 'eAbilitySource_Item'));
	Templates.AddItem(PurePassive('Shredder_Rounds_Ability', "img:///UILibrary_PerkIcons.UIPerk_maximumordanance", false, 'eAbilitySource_Item'));
	
	Templates.AddItem(PurePassive('Dragon_Rounds_Ability_PP', "img:///UILibrary_PerkIcons.UIPerk_ammo_incendiary", false, 'eAbilitySource_Item'));
	Templates.AddItem(PurePassive('Bluescreen_Rounds_Ability_PP', "img:///UILibrary_PerkIcons.UIPerk_ammo_bluescreen", false, 'eAbilitySource_Item'));
	Templates.AddItem(PurePassive('Talon_Rounds_Ability_PP', "img:///UILibrary_PerkIcons.UIPerk_ammo_talon", false, 'eAbilitySource_Item'));
	Templates.AddItem(PurePassive('AP_Rounds_Ability_PP', "img:///UILibrary_PerkIcons.UIPerk_ammo_ap", false, 'eAbilitySource_Item'));
	Templates.AddItem(PurePassive('Venom_Rounds_Ability_PP', "img:///UILibrary_LWOTC.LW_AbilityVenomRounds", false, 'eAbilitySource_Item'));
	Templates.AddItem(PurePassive('Tracer_Rounds_Ability_PP', "img:///UILibrary_PerkIcons.UIPerk_ammo_tracer", false, 'eAbilitySource_Item'));

	Templates.AddItem(PurePassive('FireControl25', "img:///UILibrary_LWOTC.LW_AbilityFireControl", false));
	Templates.AddItem(PurePassive('FireControl50', "img:///UILibrary_LWOTC.LW_AbilityFireControl", false));
	Templates.AddItem(PurePassive('FireControl75', "img:///UILibrary_LWOTC.LW_AbilityFireControl", false));

	Templates.AddItem(CreateSmallItemWeightAbility());
	Templates.AddItem(RemoveGrenadeWeightAbility()); // does not work

	Templates.AddItem(CreateSedateAbility());
	Templates.AddItem(CreateBonusShredAbility('CoilgunBonusShredAbility', default.BONUS_COILGUN_SHRED));

	Templates.AddItem(CreateBluescreenRoundsDisorient());
	//Templates.AddItem(CreateConsumeWhenActivatedAbility ('ConsumeShapedCharge', 'ShapedChargeUsed'));

	return Templates;
}

static function X2AbilityTemplate CreateScopeBonus(name TemplateName, int Bonus)
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_ModifyNonReactionFire	ScopeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	Template.AbilitySourceName = 'eAbilitySource_Item';

	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	ScopeEffect=new class'X2Effect_ModifyNonReactionFire';
	ScopeEffect.BuildPersistentEffect(1,true,false,false);
	//ScopeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ScopeEffect.To_Hit_Modifier = Bonus;
	ScopeEffect.Upgrade_Empower_Bonus = default.SCOPE_EMPOWER_BONUS;
	ScopeEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(ScopeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreateHairTriggerBonus(name TemplateName, int Bonus)
{
	local X2AbilityTemplate				Template;
	local X2Effect_HairTrigger			TriggerEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);	
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	TriggerEffect=new class'X2Effect_HairTrigger';
	TriggerEffect.BuildPersistentEffect(1,true,false,false);
	//TriggerEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TriggerEffect.To_Hit_Modifier = Bonus;
	TriggerEffect.Upgrade_Empower_Bonus = default.TRIGGER_EMPOWER_BONUS;
	TriggerEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(TriggerEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate CreateStockSteadyWeaponAbility(name TemplateName, int Bonus)
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_SteadyWeapon				ToHitModifier;
	local X2Condition_UnitEffects			SuppressedCondition;
	local X2AbilityCost_Ammo				AmmoCost;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySteadyWeapon";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bSkipFireAction=true;
	Template.bShowActivation=true;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
	Template.bCrossClassEligible = false;
	//Template.DefaultKeyBinding = 539;
	//Template.bNoConfirmationWithHotKey = true;
	Template.AddShooterEffectExclusions();

	//require 1 ammo but don't actually consume it, so you can't steady an empty weapon.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;    
	Template.AbilityCosts.AddItem(ActionPointCost);

    Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.CinescriptCameraType = "Overwatch";
	ToHitModifier = new class'X2Effect_SteadyWeapon';
	ToHitModifier.BuildPersistentEffect(2, false, true, false, eGameRule_PlayerTurnBegin);
	ToHitModifier.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	ToHitModifier.DuplicateResponse = eDupe_Refresh;
	ToHitModifier.Aim_Bonus = Bonus;
	ToHitModifier.Crit_Bonus = Bonus;
	ToHitModifier.Upgrade_Empower_Bonus = default.STOCK_EMPOWER_BONUS;
	Template.AddTargetEffect(ToHitModifier);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate CreateStockGrazingFireAbility(name TemplateName, int Chance)
{
	local X2AbilityTemplate					Template;
	local X2Effect_GrazingFire				GrazingEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, TemplateName);

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityGrazingFire";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bCrossClassEligible = true;
	GrazingEffect = new class'X2Effect_GrazingFire';
	GrazingEffect.SuccessChance = Chance;
	GrazingEffect.BuildPersistentEffect (1, true, false);
	//GrazingEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	Template.AddTargetEffect(GrazingEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	return Template;
}


static function X2AbilityTemplate CreateAblativeHPAbility(name TemplateName, int AblativeHPAmt)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		AblativeHP;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bShowActivation=false;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	AblativeHP = new class'X2Effect_PersistentStatChange';
	AblativeHP.BuildPersistentEffect(1, true, false, false);
	AblativeHP.AddPersistentStatChange(eStat_ShieldHP, AblativeHPAmt);
	Template.AddTargetEffect(AblativeHP);
	Template.SetUIStatMarkup(default.AblativeHPLabel, eStat_ShieldHP, AblativeHPAmt);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate CreateBonusDodgeAbility(name TemplateName, int DodgeAmount)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		DodgeBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bShowActivation=false;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	DodgeBonus = new class'X2Effect_PersistentStatChange';
	DodgeBonus.BuildPersistentEffect(1, true, false, false);
	DodgeBonus.AddPersistentStatChange(eStat_Dodge, DodgeAmount);
	Template.AddTargetEffect(DodgeBonus);
	Template.SetUIStatMarkup(default.AblativeHPLabel, eStat_Dodge, DodgeAmount);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate CreateBonusDefAbility(name TemplateName, int DefAmount)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		DefBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bShowActivation=false;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	DefBonus = new class'X2Effect_PersistentStatChange';
	DefBonus.BuildPersistentEffect(1, true, false, false);
	DefBonus.AddPersistentStatChange(eStat_Dodge, DefAmount);
	Template.AddTargetEffect(DefBonus);
	Template.SetUIStatMarkup(default.AblativeHPLabel, eStat_Dodge, DefAmount);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate CreateCritReductionAbility(name TemplateName, int CritReductionAmount)
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Resilience		CritDefEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bShowActivation=false;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	CritDefEffect = new class'X2Effect_Resilience';
	CritDefEffect.CritDef_Bonus = CritReductionAmount;
	CritDefEffect.BuildPersistentEffect (1, true, false, false);
	Template.AddTargetEffect(CritDefEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}


static function X2AbilityTemplate CreateHazmatVestBonusAbility_LW()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local X2Effect_DamageImmunity           DamageImmunity;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HazmatVestBonus_LW');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_flamesealant";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Bonus to health stat Effect, also gives protection from fire and poison
	//
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.HAZMAT_VEST_HP_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.ImmuneTypes.AddItem('Fire');
	DamageImmunity.ImmuneTypes.AddItem('Poison');
	DamageImmunity.ImmuneTypes.AddItem('Acid'); /// ADDING THIS
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	DamageImmunity.BuildPersistentEffect(1, true, false, false);
	DamageImmunity.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	Template.AddTargetEffect(DamageImmunity);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreateNanoFiberBonusAbility_LW()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local X2Effect_Resilience				CritDefEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'NanofiberVestBonus_LW');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to health stat Effect
	//
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.NANOFIBER_VEST_HP_BONUS);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	CritDefEffect = new class'X2Effect_Resilience';
	CritDefEffect.CritDef_Bonus = default.NANOFIBER_CRITDEF_BONUS;
	CritDefEffect.BuildPersistentEffect (1, true, false, false);
	Template.AddTargetEffect(CritDefEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


static function X2AbilityTemplate CreateStilettoRoundsAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_StilettoRounds			Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Stiletto_Rounds_Ability');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_stiletto";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_StilettoRounds';
	Effect.BonusDmg = class'X2Item_LWUtilityItems'.default.STILETTO_ALIEN_DMG;
	Effect.BuildPersistentEffect (1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect (Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate CreateFlechetteRoundsAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_FlechetteRounds			Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Flechette_Rounds_Ability');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_fletchette";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_FlechetteRounds';
	Effect.BonusDmg = class'X2Item_LWUtilityItems'.default.FLECHETTE_BONUS_DMG;
	Effect.BuildPersistentEffect (1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate CreateNeurowhipAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Neurowhip_Ability');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_PsiOffense, float(class'X2Item_LWUtilityItems'.default.NEUROWHIP_PSI_BONUS));
	Effect.AddPersistentStatChange(eStat_Will, -float(class'X2Item_LWUtilityItems'.default.NEUROWHIP_WILL_MALUS));
	Effect.BuildPersistentEffect (1, true, false, false);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

// function SetUIStatMarkup(string InLabel, optional X2TacticalGameRulesetDataStructures.ECharStatType InStatType, optional int Amount, optional bool ForceShow, optional delegate<SpecialRequirementsDelegate> ShowUIStatFn)

static function X2AbilityTemplate CreateSmallItemWeightAbility()
{
	local X2AbilityTemplate								Template;	
	local X2Effect_ItemWeight							WeightEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'SmallItemWeight');
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ammo_stiletto";

	WeightEffect = new class'X2Effect_ItemWeight';
	WeightEffect.EffectName = 'SmallItemWeight';
	WeightEffect.BuildPersistentEffect (1, true, false, false);
	//WeightEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	WeightEffect.bUniqueTarget = true;
	WeightEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(WeightEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

// This doesn't work
static function X2AbilityTemplate RemoveGrenadeWeightAbility()
{
	local X2AbilityTemplate						Template;	
	local X2Effect_RemoveEffects				RemoveEffects;
	local X2AbilityTrigger_OnAbilityActivated	GrenadeTossTrigger, GrenadeLaunchTrigger;
	local X2AbilityCharges					Charges;
	local X2AbilityCost_Charges				ChargeCost;
	local X2Condition_UnitEffects			UntriggeredCondition;
	local X2Effect_Persistent				TriggeredEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RemoveGrenadeWeight');
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	GrenadeTossTrigger=new class 'X2AbilityTrigger_OnAbilityActivated';
	GrenadeTossTrigger.SetListenerData('ThrowGrenade');
	Template.AbilityTriggers.AddItem(GrenadeTossTrigger);

	GrenadeLaunchTrigger=new class 'X2AbilityTrigger_OnAbilityActivated';
	GrenadeLaunchTrigger.SetListenerData('LaunchGrenade');
	Template.AbilityTriggers.AddItem(GrenadeLaunchTrigger);

	Charges = new class'X2AbilityCharges';
    Charges.InitialCharges = 1;
    Template.AbilityCharges = Charges;

    ChargeCost = new class'X2AbilityCost_Charges';
    ChargeCost.NumCharges = 1;
    Template.AbilityCosts.AddItem(ChargeCost);

	UntriggeredCondition = new class 'X2Condition_UnitEffects';
	UntriggeredCondition.AddExcludeEffect('GrenadeWeightLoss', 'AA_UnitAlreadyAffected');
	Template.AbilityTargetConditions.AddItem(UntriggeredCondition);

	TriggeredEffect = new class 'X2Effect_Persistent';
	TriggeredEffect.EffectName = 'GrenadeWeightLoss';
	TriggeredEffect.bCanTickEveryAction = true;
	TriggeredEffect.BuildPersistentEffect(1,false,false,false,eGameRule_UseActionPoint);
	Template.AddTargetEffect(TriggeredEffect);

	//Maybe a once-per condition 

	RemoveEffects = new class'X2Effect_RemoveEffects';
	RemoveEffects.EffectNamesToRemove.AddItem('SmallItemWeight');
	Template.AddTargetEffect(RemoveEffects);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function SedatedVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    if(EffectApplyResult != 'AA_Success')
    {
        return;
    }
    if(XComGameState_Unit(ActionMetadata.StateObject_NewState) == none)
    {
        return;
    }
    class'X2StatusEffects'.static.AddEffectMessageToTrack(
		ActionMetadata,
		class'X2StatusEffects'.default.UnconsciousEffectAcquiredString,
		VisualizeGameState.GetContext(),
		class'UIEventNoticesTactical'.default.UnconsciousTitle,
		"img:///UILibrary_Common.status_unconscious",
		eUIState_Good);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function X2Effect_Persistent CreateSedatedStatusEffect()
{
    local X2Effect_Persistent PersistentEffect;

    PersistentEffect = new class'X2Effect_Persistent';
    PersistentEffect.EffectName = class'X2StatusEffects'.default.UnconsciousName;
    PersistentEffect.DuplicateResponse = eDupe_Ignore;
    PersistentEffect.BuildPersistentEffect(1, true, false);
    PersistentEffect.bRemoveWhenTargetDies = true;
    PersistentEffect.bIsImpairing = true;
    PersistentEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.UnconsciousFriendlyName, class'X2StatusEffects'.default.UnconsciousFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun", true, "img:///UILibrary_Common.status_unconscious");
    PersistentEffect.EffectAddedFn = class'X2StatusEffects'.static.UnconsciousEffectAdded;
    PersistentEffect.EffectRemovedFn = class'X2StatusEffects'.static.UnconsciousEffectRemoved;
    PersistentEffect.VisualizationFn = SedatedVisualization;
    PersistentEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.UnconsciousVisualizationTicked;
    PersistentEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.UnconsciousVisualizationRemoved;
    PersistentEffect.CleansedVisualizationFn =class'X2StatusEffects'.static.UnconsciousCleansedVisualization;
    PersistentEffect.EffectHierarchyValue = class'X2StatusEffects'.default.UNCONCIOUS_HIERARCHY_VALUE;
    PersistentEffect.DamageTypes.AddItem('Unconscious');
    return PersistentEffect;
}


static function X2AbilityTemplate CreateSedateAbility()
{
	local X2AbilityTemplate						Template;	
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2Condition_UnitProperty				UnitPropertyCondition;
	local X2Condition_Sedate					SedateCondition;
	local X2AbilityCharges						Charges;
	local X2AbilityCost_Charges					ChargeCost;
	local X2AbilityTarget_Single				SingleTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Sedate');
		
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sedation";
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
    Template.ShotHUDPriority = 1101;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 2;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.bOnlyOnHit = true;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.bIncludeSelf = false;
	Template.AbilityTargetStyle = SingleTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeHostileToSource = true;
    UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeStunned = false;
	UnitPropertyCondition.ExcludeAlien = true;
	UnitPropertyCondition.IsAdvent = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.IsPlayerControlled = true;
	UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.WithinRange = 144;	// 1 adjacent tile
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	SedateCondition = new class 'X2Condition_Sedate';
	Template.AbilityTargetConditions.AddItem(SedateCondition);

	Template.AddTargetEffect(CreateSedatedStatusEffect());

	Template.ActivationSpeech = 'StabilizingAlly';
	Template.bShowActivation = true;
	
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//Doesn't work
static function X2AbilityTemplate CreateConsumeWhenActivatedAbility(name AbilityName, name EventName)
{
    local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
	Template.AbilityToHitCalc = default.DeadEye;
	Template.bDontDisplayInAbilitySummary = true;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;

    Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.AbilityCosts.AddItem(new class'X2AbilityCost_ConsumeItem');

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = EventName;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Unit;
    Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

// Passive ability that grants soldiers bonus shred based on the primary weapon
// they're using.
static function X2AbilityTemplate CreateBonusShredAbility(name AbilityName, int BonusShred)
{
	local X2AbilityTemplate Template;
	local X2Effect_BonusShred BonusShredEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shredder";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	BonusShredEffect = new class'X2Effect_BonusShred';
	BonusShredEffect.BonusShredvalue = BonusShred;
	Template.AddTargetEffect(BonusShredEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}

static function X2AbilityTemplate CreateBluescreenRoundsDisorient()
{
	local X2AbilityTemplate Template;
	local X2Effect_Persistent Effect;
	local X2Condition_UnitProperty Condition_UnitProperty;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'BluescreenRoundsDisorient');
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	Effect.ApplyChance=default.BLUESCREEN_DISORIENT_CHANCE;
	Template.AddTargetEffect(Effect);

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = true;
	Condition_UnitProperty.IncludeWeakAgainstTechLikeRobot = true;
	Condition_UnitProperty.TreatMindControlledSquadmateAsHostile = true;
	Condition_UnitProperty.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(Condition_UnitProperty);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}
	
