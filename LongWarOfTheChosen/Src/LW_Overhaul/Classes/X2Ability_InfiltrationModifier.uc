//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_InfiltrationModifier.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Provides ability definition for tactical infiltration modifiers applied to aliens
//---------------------------------------------------------------------------------------
class X2Ability_InfiltrationModifier extends X2Ability config(LW_Toolbox);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateInfiltrationModifierAbility());

	return Templates;
}

static function X2AbilityTemplate CreateInfiltrationModifierAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_UnitPostBeginPlay PostBeginPlayTrigger;
	local X2Effect_InfiltrationModifier InfiltrationModifierEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'InfiltrationTacticalModifier_LW');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_criticallywounded";  
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	PostBeginPlayTrigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(PostBeginPlayTrigger);

	//Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	
	InfiltrationModifierEffect = new class'X2Effect_InfiltrationModifier';
	InfiltrationModifierEffect.BuildPersistentEffect(1, true, true, false); 
	InfiltrationModifierEffect.SetDisplayInfo	(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), "", false);
	Template.AddTargetEffect(InfiltrationModifierEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = none;

	return Template;
}

DefaultProperties
{
}
