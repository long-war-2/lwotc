//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_TheLost_LW.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Defines all Long War lost-specific abilities
//---------------------------------------------------------------------------------------
class X2Ability_TheLost_LW extends X2Ability config(LW_SoldierSkills); 


static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;
    
	Templates.AddItem(CreateLostBladestormAttack());
	Templates.AddItem(CreateLostBladestorm());
	Templates.AddItem(CreateBruteAcid());
	return Templates;
}

static function X2AbilityTemplate CreateLostBladestorm()
{
	local X2AbilityTemplate Template;
	Template = PurePassive('LostBladestorm', "img:///UILibrary_PerkIcons.UIPerk_bladestorm", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('LostBladestormAttack');
	return Template;
}

static function X2DataTemplate CreateLostBladestormAttack()
{
	local X2AbilityTemplate Template;
	local X2Condition_NotItsOwnTurn NotItsOwnTurnCondition;
	local X2Condition_Unitproperty RangeCondition;
	Template = class'X2Ability_RangerAbilitySet'.static.BladestormAttack('LostBladestormAttack');

	// necessary to limit range to 1 tile because of weapon range configuration
	RangeCondition = new class'X2Condition_Unitproperty';
	RangeCondition.RequireWithinRange = true;
	RangeCondition.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	
	Template.AbilityTargetConditions.AddItem(RangeCondition);

	/* values from Lost melee attack */
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_escape";
	Template.Hostility = eHostility_Offensive;
//	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
//	Template.MergeVisualizationFn = LostAttack_MergeVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.CustomFireAnim = 'FF_Melee';
	Template.CinescriptCameraType = "Lost_Attack";

	NotItsOwnTurnCondition = new class'X2Condition_NotItsOwnTurn';
	Template.AbilityShooterConditions.AddItem(NotItsOwnTurnCondition);

	return Template;
}

static function X2AbilityTemplate CreateBruteAcid()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ApplyWeaponDamage            DamageEffect;
	local X2AbilityMultiTarget_Radius MultiTarget;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Effect_ApplyAcidToWorld AcidEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BruteAcid');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Defensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_burn";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.DamageTypes.AddItem('Acid');
	Template.AddTargetEffect(DamageEffect);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(2,1));
	AcidEffect = new class'X2Effect_ApplyAcidToWorld';	
	Template.AddMultiTargetEffect(AcidEffect);

	MultiTarget = new class'X2AbilityMultiTarget_Radius';
    MultiTarget.bUseWeaponRadius = true;
	MultiTarget.bExcludeSelfAsTargetIfWithinRadius = false;
	Template.AbilityMultiTargetStyle = MultiTarget;

	// This ability fires when the unit takes damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitTakeEffectDamage';
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.bSkipFireAction = true;
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}
