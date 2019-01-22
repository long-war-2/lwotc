//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_SMGAbilities.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Adds stat modifier abilities for all tech tiers of SMG
//           
//---------------------------------------------------------------------------------------
class X2Ability_SMGAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(GameData_WeaponData);
	
// ***** Mobility bonuses for SMGs
var config int SMG_CONVENTIONAL_MOBILITY_BONUS;
var config int SMG_MAGNETIC_MOBILITY_BONUS;
var config int SMG_COIL_MOBILITY_BONUS;
var config int SMG_BEAM_MOBILITY_BONUS;

// *****DetectionRadius bonuses for SMGs
var config float SMG_CONVENTIONAL_DETECTIONRADIUSMODIFER;
var config float SMG_MAGNETIC_DETECTIONRADIUSMODIFER;
var config float SMG_COIL_DETECTIONRADIUSMODIFER;
var config float SMG_BEAM_DETECTIONRADIUSMODIFER;

/// Creates the abilities that add passive Mobility for SMGs
Static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(AddSMGConventionalBonusAbility());
	Templates.AddItem(AddSMGMagneticBonusAbility());
	//Templates.AddItem(AddSMGCoilBonusAbility());
	Templates.AddItem(AddSMGBeamBonusAbility());

	return Templates;
}

// ******************* Stat Bonuses **********************

static function X2AbilityTemplate AddSMGConventionalBonusAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SMG_CV_StatBonus');
	Template.IconImage = "img:///gfxXComIcons.NanofiberVest";  

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SMG_CONVENTIONAL_MOBILITY_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.SMG_CONVENTIONAL_DETECTIONRADIUSMODIFER);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate AddSMGMagneticBonusAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SMG_MG_StatBonus');
	Template.IconImage = "img:///gfxXComIcons.NanofiberVest";  

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SMG_MAGNETIC_MOBILITY_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.SMG_MAGNETIC_DETECTIONRADIUSMODIFER);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate AddSMGCoilBonusAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SMG_CG_StatBonus');
	Template.IconImage = "img:///gfxXComIcons.NanofiberVest";  

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SMG_COIL_MOBILITY_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.SMG_COIL_DETECTIONRADIUSMODIFER);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}
static function X2AbilityTemplate AddSMGBeamBonusAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SMG_BM_StatBonus');
	Template.IconImage = "img:///gfxXComIcons.NanofiberVest";  

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SMG_BEAM_MOBILITY_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.SMG_BEAM_DETECTIONRADIUSMODIFER);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}
