//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_LaserSMGAbilities.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Adds stat modifier abilities for all laser tier of SMG
//           
//---------------------------------------------------------------------------------------
class X2Ability_LaserSMGAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config (GameData_WeaponData);
	
// ***** Mobility bonuses for SMGs
var config int SMG_LASER_MOBILITY_BONUS;

// *****DetectionRadius bonuses for SMGs
var config float SMG_LASER_DETECTIONRADIUSMODIFER;

/// <summary>
/// Creates the abilities that add passive Mobility for SMGs
/// </summary>
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	`LWTrace("  >> X2Ability_LaserSMGAbilities.CreateTemplates()");
	
	Templates.AddItem(AddSMGLaserBonusAbility());

	return Templates;
}

// ******************* Stat Bonuses **********************

static function X2AbilityTemplate AddSMGLaserBonusAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SMG_LS_StatBonus');
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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SMG_LASER_MOBILITY_BONUS);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.SMG_LASER_DETECTIONRADIUSMODIFER);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}
