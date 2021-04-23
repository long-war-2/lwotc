class X2Ability_ShieldAbilitySet extends X2Ability config(LW_SoldierSkills);

var config int SHIELD_WALL_DODGE;
var config int SHIELD_WALL_DEFENSE;
var config bool SHIELD_WALL_FREE_ACTION;

var config int SHIELD_POINTS_CV;
var config int SHIELD_POINTS_MG;
var config int SHIELD_POINTS_BM;

var config int SHIELD_MOBILITY_PENALTY;
var config int SHIELD_AIM_PENALTY;

var config int OFA_BASE_SHIELD;
var config int OFA_MG_BONUS;
var config int OFA_BM_BONUS;
var config int SHIELD_BASH_COOLDOWN;

var config int GREATER_PADDING_CV;
var config int GREATER_PADDING_MG;
var config int GREATER_PADDING_BM;

var config bool bLog;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(OneForAll());
	Templates.AddItem(BallisticShield('TemplarBallisticShield_CV', default.SHIELD_POINTS_CV));
	Templates.AddItem(BallisticShield('TemplarBallisticShield_MG', default.SHIELD_POINTS_MG));
	Templates.AddItem(BallisticShield('TemplarBallisticShield_BM', default.SHIELD_POINTS_BM));
	Templates.AddItem(GreaterPadding('GreaterPadding_CV', default.GREATER_PADDING_CV));
	Templates.AddItem(GreaterPadding('GreaterPadding_MG', default.GREATER_PADDING_MG));
	Templates.AddItem(GreaterPadding('GreaterPadding_BM', default.GREATER_PADDING_BM));

	Templates.AddItem(ShieldBash());
	Templates.AddItem(ShieldAnimSet());
	Templates.AddItem(BallisticShield_GenerateCover());	
	
	return Templates;
}

static function X2AbilityTemplate OneForAll()
{
	local X2AbilityTemplate Template;
	local X2Effect_ShieldWall CoverEffect;
	local X2Effect_OneForAll	ShieldedEffect;
	Template = class'X2Ability_DefaultAbilitySet'.static.AddHunkerDownAbility('OneForAll');

	X2AbilityCost_ActionPoints(Template.AbilityCosts[0]).AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.MomentumActionPoint);

	Template.IconImage = "img:///WoTC_Shield_UI_LW.ShieldWall_Icon";

	if (default.SHIELD_WALL_FREE_ACTION)
	{
		Template.AbilityCosts.Length = 0;
		Template.AbilityCosts.AddItem(default.FreeActionCost);
	}

	X2Condition_UnitProperty(Template.AbilityShooterConditions[0]).ExcludeNoCover = false;
	X2Effect_PersistentStatChange(Template.AbilityTargetEffects[0]).EffectName = 'NOTHUNKERDOWN';
	X2Effect_PersistentStatChange(Template.AbilityTargetEffects[0]).m_aStatChanges[0].StatAmount = default.SHIELD_WALL_DODGE;
	X2Effect_PersistentStatChange(Template.AbilityTargetEffects[0]).m_aStatChanges[1].StatAmount = default.SHIELD_WALL_DEFENSE;

	CoverEffect = new class'X2Effect_ShieldWall';
	CoverEffect.EffectName = 'ShieldWall';
	CoverEffect.bRemoveWhenMoved = true;
	CoverEffect.bRemoveOnOtherActivation = true;
	CoverEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	CoverEffect.CoverType = CoverForce_High;
	CoverEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(CoverEffect);

	ShieldedEffect = new class'X2Effect_OneForAll';
	ShieldedEffect.BaseShieldHPIncrease = default.OFA_BASE_SHIELD;
	ShieldedEffect.MK2ShieldIncrease= default.OFA_MG_BONUS;
	ShieldedEffect.MK3ShieldIncrease= default.OFA_BM_BONUS;
	ShieldedEffect.BuildPersistentEffect (1, false, false, false, eGameRule_PlayerTurnBegin);
	ShieldedEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,false,, Template.AbilitySourceName);
	Template.AddTargetEffect(ShieldedEffect);


	Template.OverrideAbilities.AddItem('HunkerDown');

	//	WAR Suit's "Shieldwall" ability. Redundant with *this* Shield Wall.
	//	Also its OnEffectRemoved it does UnitState.bGeneratesCover = false, effectivelly turning off the X2Effect_GenerateCover in the BallisticShield passive.
	//	Kinda big deal.
	Template.OverrideAbilities.AddItem('HighCoverGenerator');	

	return Template;
}

static function X2AbilityTemplate BallisticShield(name TemplateName, int ShieldHPAmount)
{
	local X2AbilityTemplate Template;
	local X2Effect_EnergyShield ShieldedEffect;
	local X2Effect_PersistentStatChange PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";
	Template.IconImage = "img:///WoTC_Shield_UI_LW.BallisticShield_Icon";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(1, true, false, true, eGameRule_TacticalGameStart);
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true, , Template.AbilitySourceName);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, ShieldHPAmount);
	ShieldedEffect.EffectName = 'Ballistic_Shield_Effect';	//	Brawler Class depends on this Effect Name, don't change pl0x
	ShieldedEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(ShieldedEffect);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SHIELD_MOBILITY_PENALTY);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, default.SHIELD_AIM_PENALTY);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	//	UI Stat Markup has no effect on abilities that are not a part of the soldier's skill tree.
	//Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.SHIELD_MOBILITY_PENALTY);
	//Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, default.SHIELD_AIM_PENALTY);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate BallisticShield_GenerateCover()
{
	local X2AbilityTemplate Template;
	local X2Effect_GenerateCover CoverEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TemplarBallisticShield_GenerateCover');

	Template.IconImage = "img:///WoTC_Shield_UI_LW.BallisticShield_Icon";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	CoverEffect = new class'X2Effect_GenerateCover';
	CoverEffect.EffectName = 'BallisticShield';
	CoverEffect.bRemoveWhenMoved = false;
	CoverEffect.bRemoveOnOtherActivation = false;
	CoverEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	CoverEffect.CoverType = CoverForce_Low;
	CoverEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(CoverEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate ShieldBash()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Knockback KnockbackEffect;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;
	local X2AbilityCooldown Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ShieldBash_LW');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///WoTC_Shield_UI_LW.ShieldBash_Icon";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SHIELD_BASH_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	AdjacencyCondition.TreatMindControlledSquadmateAsHostile = true;
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	
	if (!class'X2Ability_PerkPackAbilitySet'.default.NO_MELEE_ATTACKS_WHEN_ON_FIRE)
	{
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	}

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;


	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	KnockbackEffect.OnlyOnDeath = false; 
	Template.AddTargetEffect(KnockbackEffect);

	Template.DefaultSourceItemSlot = eInvSlot_SecondaryWeapon;

	//alternatively NO_ShieldBash
	Template.CustomFireAnim = 'FF_MeleeShieldBash';
	Template.CustomFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnLeftFireKillAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireAnim = 'FF_MeleeShieldBash';
	Template.CustomMovingTurnRightFireKillAnim = 'FF_MeleeShieldBash';



	return Template;
}

static function X2AbilityTemplate ShieldAnimSet()
{
    local X2AbilityTemplate						Template;
    local X2Effect_AdditionalAnimSets			AnimSets;
	//local X2Effect_ShieldAim					ShieldAim;
	//local X2Condition_ExcludeCharacterTemplates	Condition;

    `CREATE_X2ABILITY_TEMPLATE(Template, 'ShieldAnimSet');

    Template.AbilitySourceName = 'eAbilitySource_Item';
    Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
    Template.Hostility = eHostility_Neutral;
    Template.bDisplayInUITacticalText = false;
    
    Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
    Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
    AnimSets = new class'X2Effect_AdditionalAnimSets';
    AnimSets.EffectName = 'ShieldAnimSet';
    //AnimSets.AddAnimSetWithPath("AnimSet'WoTC_Shield_Animations_LW.Anims.AS_Shield_Melee'");
	AnimSets.AddAnimSetWithPath("AnimSet'WoTC_Shield_Animations_LW.Anims.AS_Shield_Grenade'");
	AnimSets.AddAnimSetWithPath("AnimSet'WoTC_Shield_Animations_LW.Anims.AS_Shield_Medkit'");
    AnimSets.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
    AnimSets.DuplicateResponse = eDupe_Ignore;

	//	This effect will apply only to units whose character template name is not in the exclusion list.
	//Condition = new class'X2Condition_ExcludeCharacterTemplates';
	//AnimSets.TargetConditions.AddItem(Condition);

    Template.AddTargetEffect(AnimSets);

	//	Gives the token +20 Aim to abilities attached to the shield (the Shield Bash).
	//	Doing it this way instead of giving Aim directly to the weapon template out of concern for the UI Sat Markup.
	//ShieldAim = new class'X2Effect_ShieldAim';
	//ShieldAim.BuildPersistentEffect(1, true);
	//Template.AddTargetEffect(ShieldAim);
    
    Template.bSkipFireAction = true;
    Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
    Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

    return Template;
}


static function	X2AbilityTemplate GreaterPadding(name AbilityName, int Amount)
{

	local X2AbilityTemplate						Template;
	local X2Effect_GreaterPadding					GreaterPaddingEffect;
	local X2Condition_UnitProperty              TargetProperty;

	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFieldSurgeon";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;


	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.RequireSquadmates = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);	

	
	GreaterPaddingEffect = new class 'X2Effect_GreaterPadding';
	GreaterPaddingEffect.BuildPersistentEffect (1, true, false);
	GreaterPaddingEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	GreaterPaddingEffect.Padding_HealHP = Amount;	
	Template.AddTargetEffect(GreaterPaddingEffect);

	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;



	
}