//from Alterd-Rushnano
class X2Ability_LW_FactionBalance_FullOverrideAbilitySet extends X2Ability config(LW_FactionBalance);

var config int LW2WotC_RECKONING_COOLDOWN;
var config int RECKONING_SLASH_COOLDOWN;


static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(Battlemaster());
	Templates.AddItem(LW2WotC_Reckoning());
	Templates.AddItem(SkirmisherFleche());
	Templates.AddItem(SkirmisherSlash());

    return Templates;
}



	static function X2AbilityTemplate Battlemaster() 
{
	local X2AbilityTemplate             	Template;
	local X2Effect_DamnGoodGround			AimandDefModifiers;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Battlemaster');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_ManualOverride";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimandDefModifiers = new class 'X2Effect_DamnGoodGround';
	AimandDefModifiers.BuildPersistentEffect (1, true, true);
	AimandDefModifiers.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimandDefModifiers);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;		
}


static function X2AbilityTemplate LW2WotC_Reckoning()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown				Cooldown;

	Template = PurePassive('LW2WotC_Reckoning', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Reckoning");
	Template.AdditionalAbilities.AddItem('SkirmisherFleche');
	Template.AdditionalAbilities.AddItem('SkirmisherSlash');
	Template.AdditionalAbilities.AddItem('CoupDeGrace2');
	Template.AdditionalAbilities.AddItem('Cutthroat');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LW2WotC_RECKONING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	return Template;
}

static function X2AbilityTemplate SkirmisherFleche()
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2AbilityCooldown				Cooldown;
	local int i;

	Template = class'X2Ability_RangerAbilitySet'.static.AddSwordSliceAbility('SkirmisherFleche');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.CinescriptCameraType = "Skirmisher_Melee";
	
	for (i = 0; i < Template.AbilityCosts.Length; ++i)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);
		if (ActionPointCost != none)
			ActionPointCost.bConsumeAllPoints = false;
	}
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LW2WotC_RECKONING_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	return Template;
}


static function X2AbilityTemplate SkirmisherSlash()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2AbilityCooldown					Cooldown;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_UnitProperty			AdjacencyCondition;	

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SkirmisherSlash');

	// Standard melee attack setup
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
    Template.bDisplayInUITacticalText = true;
    Template.DisplayTargetHitChance = true;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;

	// Costs one action and doesn't end turn
	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.RECKONING_SLASH_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
	
	// Targetted melee attack against a single target
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;
    Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target must be alive and adjacent
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
	AdjacencyCondition = new class'X2Condition_UnitProperty';
	AdjacencyCondition.RequireWithinRange = true;
	AdjacencyCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(AdjacencyCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);
	
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.bAllowBonusWeaponEffects = true;
	
	// VGamepliz matters
	Template.SourceMissSpeech = 'SwordMiss';
	Template.bSkipMoveStop = true;

	// Typical melee visualizations
	Template.CinescriptCameraType = "Ranger_Reaper";
    Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	// Standard interactions with Shadow, Chosen, and the Lost
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}
