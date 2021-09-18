class X2Ability_ChemthrowerUpgrades extends XMBAbility config(GameData_WeaponData);

var config array<int> RangeMod_LengthNozzleBsc, RangeMod_LengthNozzleAdv, RangeMod_LengthNozzleSup;
var config int Autoloader_Reloads_Bsc, Autoloader_Reloads_Adv, Autoloader_Reloads_Sup, Autoloader_Reloads_EmpoweredBonus;
var config int ReactionFrame_Aim_Bsc, ReactionFrame_Aim_Adv, ReactionFrame_Aim_Sup, ReactionFrame_Aim_Empower;
var config int FlankFrame_Crit_Bsc, FlankFrame_Crit_Adv, FlankFrame_Crit_Sup, FlankFrame_Crit_Empower;
var config int FuelLine_Charges_Bsc, FuelLine_Charges_Adv, FuelLine_Charges_Sup;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Length additions have to be handled in abilities, but the passive provides an aim mod so you don't miss at your new range.
	Templates.AddItem(AddHiddenPassive('LWLengthNozzleBsc'));

	// Actual effects of wide-angle nozzles are handled in the abilities.
	Templates.AddItem(AddHiddenPassive('LWWidthNozzleBsc'));

	Templates.AddItem(AddHiddenPassive('LWAutoloaderFuelBsc'));

	Templates.AddItem(FuelLineAttachment('LWFuelLineBsc', default.FuelLine_Charges_Bsc));

	Templates.AddItem(AddHiddenPassive('LWFlankCritFrameBsc'));

	Templates.AddItem(ReactionFireFrameAttachment());

	return Templates;
}

static function X2AbilityTemplate AddHiddenPassive(name TemplateName)
{
	local X2AbilityTemplate				Template;
	local X2Effect_Persistent			Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aggression";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	//effect.
	Effect = new class'X2Effect_Persistent';
	Effect.BuildPersistentEffect(1, true, false, , eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false, , Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}


static function X2AbilityTemplate ReactionFireFrameAttachment()
{
	local XMBEffect_ConditionalBonus Effect;
	local X2Condition_WeaponCategoryList Condition;
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange	PersistentStatChangeEffect;

	Template = AddHiddenPassive('LWReactionFireFrameBsc');

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';

	//Need to add for all of them because apparently if you crit you don't hit lol
	Effect.AddPercentDamageModifier(-35, eHit_Success);
	Effect.AddPercentDamageModifier(-35, eHit_Graze);
	Effect.AddPercentDamageModifier(-35, eHit_Crit);
	Effect.EffectName = 'FlamerDamageReduction';

	Condition = new class'X2Condition_WeaponCategoryList';
	Condition.IncludeWeaponCategories.AddItem('lwchemthrower');
	Condition.IncludeWeaponCategories.AddItem('LWCanister');
	// The effect only applies while wounded
	EFfect.AbilityShooterConditions.AddItem(Condition);

	Template.AddTargetEffect(EFfect);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	// PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, default.MediumPlatedHealthBonusName, default.MediumPlatedHealthBonusDesc, Template.IconImage);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, 1);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, 1);

	return Template;
}


static function X2AbilityTemplate FuelLineAttachment(name TemplateName, int Bonus)
{
	local X2AbilityTemplate					Template;
	local X2Effect_AddAbilityCharges		StockEffect;
	local X2AbilityTrigger_UnitPostBeginPlay PostBeginPlayTrigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);	

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	PostBeginPlayTrigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	PostBeginPlayTrigger.Priority = 10;        // Lower priority to canister abilities have already been init.
	Template.AbilityTriggers.AddItem(PostBeginPlayTrigger);

	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;
	
	// This will tick once during application at the start of the player's turn and increase ammo of the specified ability by the specified amounts
	StockEffect = new class'X2Effect_AddAbilityCharges';
	StockEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	StockEffect.NumCharges = Bonus;
	StockEffect.DuplicateResponse = eDupe_Allow;
	StockEffect.AbilityNames = class'X2Ability_Immolator'.default.ExpandedCanister_AbilityNames;
	StockEffect.FriendlyName = Template.LocFriendlyName;
	Template.AddTargetEffect(StockEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}