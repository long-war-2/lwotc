//---------------------------------------------------------------------------------------
//  FILE:    XMBAbility.uc
//  AUTHOR:  xylthixlm
//
//  This class provides additional helpers for defining ability templates. Simply
//  declare your ability sets to extend XMBAbility instead of X2Ability, and then use
//  whatever helpers you need.
//
//  USAGE
//
//  class X2Ability_MyClassAbilitySet extends XMBAbility;
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  Core
//  XMBCondition_CoverType.uc
//  XMBCondition_HeightAdvantage.uc
//  XMBCondition_ReactionFire.uc
//  XMBCondition_Dead.uc
//---------------------------------------------------------------------------------------

class XMBAbility extends X2Ability;

// Used by ActionPointCost and related functions
enum EActionPointCost
{
	eCost_Free,					// No action point cost, but you must have an action point available.
	eCost_Single,				// Costs a single action point.
	eCost_SingleConsumeAll,		// Costs a single action point, ends the turn.
	eCost_Double,				// Costs two action points.
	eCost_DoubleConsumeAll,		// Costs two action points, ends the turn.
	eCost_Weapon,				// Costs as much as a weapon shot.
	eCost_WeaponConsumeAll,		// Costs as much as a weapon shot, ends the turn.
	eCost_Overwatch,			// No action point cost, but displays as ending the turn. Used for 
								// abilities that have an X2Effect_ReserveActionPoints or similar.
	eCost_None,					// No action point cost. For abilities which may be triggered during
								// the enemy turn. You should use eCost_Free for activated abilities.
};

// Predefined conditions for use with XMBEffect_ConditionalBonus and similar effects.

// Careful, these objects should NEVER be modified - only constructed by default.
// They can be freely used by any ability template, but NEVER modified by them.

// Cover conditions. Only work as target conditions, not shooter conditions.
var const XMBCondition_CoverType FullCoverCondition;				// The target is in full cover
var const XMBCondition_CoverType HalfCoverCondition;				// The target is in half cover
var const XMBCondition_CoverType NoCoverCondition;					// The target is not in cover
var const XMBCondition_CoverType FlankedCondition;					// The target is not in cover and can be flanked

// Height advantage conditions. Only work as target conditions, not shooter conditions.
var const XMBCondition_HeightAdvantage HeightAdvantageCondition;	// The target is higher than the shooter
var const XMBCondition_HeightAdvantage HeightDisadvantageCondition;	// The target is lower than the shooter

// Reaction fire conditions. Only work as target conditions, not shooter conditions. Nonsensical
// if used on an X2AbilityTemplate, since it will always be either reaction fire or not.
var const XMBCondition_ReactionFire ReactionFireCondition;			// The attack is reaction fire

// Liveness conditions. Work as target or shooter conditions.
var const XMBCondition_Dead DeadCondition;							// The target is dead

// Result conditions. Only work as target conditions, not shooter conditions. Doesn't work if used
// on an X2AbilityTemplate since the hit result isn't known when selecting targets.
var const XMBCondition_AbilityHitResult HitCondition;				// The ability hits (including crits and grazes)
var const XMBCondition_AbilityHitResult MissCondition;				// The ability misses
var const XMBCondition_AbilityHitResult CritCondition;				// The ability crits
var const XMBCondition_AbilityHitResult GrazeCondition;				// The ability grazes

// Matching weapon conditions. Only work as target conditions. Doesn't work if used on an
// X2AbilityTemplate.
var const XMBCondition_MatchingWeapon MatchingWeaponCondition;		// The ability matches the weapon of the 
																	// ability defining the condition

var const XMBCondition_AbilityProperty MeleeCondition;
var const XMBCondition_AbilityProperty RangedCondition;

// Unit property conditions.
var const X2Condition_UnitProperty LivingFriendlyTargetProperty;	// The target is alive and an ally.

// Use this for ShotHUDPriority to have the priority calculated automatically
var const int AUTO_PRIORITY;

// This is an implementation detail. It holds templates added via AddSecondaryAbility().
var array<X2AbilityTemplate> ExtraTemplates;

// Checks if a conditional effect shouldn't have a bonus marker when active because it will always be active.
static function bool AlwaysRelevant(XMBEffect_ConditionalBonus Effect)
{
	if (Effect.AbilityTargetConditions.Length > 0 && class'XMBEffect_ConditionalBonus'.static.AllConditionsAreUnitConditions(Effect.AbilityTargetConditions))
		return false;
	if (Effect.AbilityShooterConditions.Length > 0)
		return false;
	if (Effect.ScaleValue != none)
		return false;

	return true;
}

// Helper method for quickly defining a non-pure passive. Works like PurePassive, except it also 
// takes an X2Effect_Persistent.
static function X2AbilityTemplate Passive(name DataName, string IconImage, optional bool bCrossClassEligible = false, optional X2Effect Effect = none)
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus ConditionalBonusEffect;
	local XMBEffect_ConditionalStatChange ConditionalStatChangeEffect;
	local X2Effect_Persistent PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, DataName);
	Template.IconImage = IconImage;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentEffect = X2Effect_Persistent(Effect);
	ConditionalBonusEffect = XMBEffect_ConditionalBonus(Effect);
	ConditionalStatChangeEffect = XMBEffect_ConditionalStatChange(Effect);

	if (ConditionalBonusEffect != none && !AlwaysRelevant(ConditionalBonusEffect))
	{
		ConditionalBonusEffect.BuildPersistentEffect(1, true, false, false);
		ConditionalBonusEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true,,Template.AbilitySourceName);
		ConditionalBonusEffect.bHideWhenNotRelevant = true;

		PersistentEffect = new class'X2Effect_Persistent';
		PersistentEffect.EffectName = name(DataName $ "_Passive");
	}
	else if (ConditionalStatChangeEffect != none)
	{
		ConditionalStatChangeEffect.BuildPersistentEffect(1, true, false, false);
		ConditionalStatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true,,Template.AbilitySourceName);

		PersistentEffect = new class'X2Effect_Persistent';
		PersistentEffect.EffectName = name(DataName $ "_Passive");
	}
	else if (PersistentEffect == none)
	{
		PersistentEffect = new class'X2Effect_Persistent';
	}

	PersistentEffect.BuildPersistentEffect(1, true, false, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(PersistentEffect);

	if (Effect != PersistentEffect && Effect != none)
		Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = bCrossClassEligible;

	return Template;
}

// Helper function for quickly defining an ability that triggers on an event and targets the unit 
// itself. Note that this does not add a passive ability icon, so you should pair it with a
// Passive or PurePassive that defines the icon, or use AddIconPassive. The IconImage argument is
// still used as the icon for effects created by this ability.
static function X2AbilityTemplate SelfTargetTrigger(name DataName, string IconImage, optional bool bCrossClassEligible = false, optional X2Effect Effect = none, optional name EventID = '', optional AbilityEventFilter Filter = eFilter_Unit)
{
	local X2AbilityTemplate						Template;
	local XMBAbilityTrigger_EventListener		EventListener;

	`CREATE_X2ABILITY_TEMPLATE(Template, DataName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = IconImage;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	if (EventID == '')
		EventID = DataName;

	// XMBAbilityTrigger_EventListener doesn't use ListenerData.EventFn
	EventListener = new class'XMBAbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = EventID;
	EventListener.ListenerData.Filter = Filter;
	EventListener.bSelfTarget = true;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	if (Effect != none)
	{
		if (X2Effect_Persistent(Effect) != none)
			X2Effect_Persistent(Effect).SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);

		Template.AddTargetEffect(Effect);
	}

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.bCrossClassEligible = bCrossClassEligible;

	return Template;
}

// Helper function for creating an activated ability that targets the user.
static function X2AbilityTemplate SelfTargetActivated(name DataName, string IconImage, optional bool bCrossClassEligible = false, optional X2Effect Effect = none, optional int ShotHUDPriority = default.AUTO_PRIORITY, optional EActionPointCost Cost = eCost_Single)
{
	local X2AbilityTemplate						Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, DataName);

	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = ShotHUDPriority;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (Cost != eCost_None)
	{
		Template.AbilityCosts.AddItem(ActionPointCost(Cost));
	}

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	if (Effect != none)
	{
		if (X2Effect_Persistent(Effect) != none)
			X2Effect_Persistent(Effect).SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);

		Template.AddTargetEffect(Effect);
	}

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	Template.bCrossClassEligible = bCrossClassEligible;

	return Template;
}

// Helper function for creating a typical weapon attack.
static function X2AbilityTemplate Attack(name DataName, string IconImage, optional bool bCrossClassEligible = false, optional X2Effect Effect = none, optional int ShotHUDPriority = default.AUTO_PRIORITY, optional EActionPointCost Cost = eCost_SingleConsumeAll, optional int iAmmo = 1)
{
	local X2AbilityTemplate                 Template;	
	local X2Condition_Visibility            VisibilityCondition;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, DataName);

	// Icon Properties
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = ShotHUDPriority;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk'; 
	Template.Hostility = eHostility_Offensive;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AddShooterEffectExclusions();

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;

	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Don't allow the ability to be used while the unit is disoriented, burning, unconscious, etc.
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	if (Cost != eCost_None)
	{
		Template.AbilityCosts.AddItem(ActionPointCost(Cost));	
	}

	if (iAmmo > 0)
	{
		AddAmmoCost(Template, iAmmo);
	}

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.bAllowFreeFireWeaponUpgrade = true;

	if (Effect != none)
	{
		if (X2Effect_Persistent(Effect) != none)
			X2Effect_Persistent(Effect).SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);

		Template.AddTargetEffect(Effect);
	}
	else
	{
		//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
		Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
		//  Various Soldier ability specific effects - effects check for the ability before applying	
		Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

		Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	}
	
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.AssociatedPassives.AddItem('HoloTargeting');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.bCrossClassEligible = bCrossClassEligible;

	return Template;	
}

static function X2AbilityTemplate MeleeAttack(name DataName, string IconImage, optional bool bCrossClassEligible = false, optional X2Effect Effect = none, optional int ShotHUDPriority = default.AUTO_PRIORITY, optional EActionPointCost Cost = eCost_SingleConsumeAll)
{
	local X2AbilityTemplate                 Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, DataName);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = IconImage;
	Template.ShotHUDPriority = ShotHUDPriority;

	if (Cost != eCost_None)
	{
		Template.AbilityCosts.AddItem(ActionPointCost(Cost));	
	}

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Don't allow the ability to be used while the unit is disoriented, burning, unconscious, etc.
	Template.AddShooterEffectExclusions();

	if (Effect != none)
	{
		Template.AddTargetEffect(Effect);
	}
	else
	{
		Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	}

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	Template.bCrossClassEligible = bCrossClassEligible;

	return Template;
}

// Helper function for creating an ability that targets a visible enemy and has 100% hit chance.
static function X2AbilityTemplate TargetedDebuff(name DataName, string IconImage, optional bool bCrossClassEligible = false, optional X2Effect Effect = none, optional int ShotHUDPriority = default.AUTO_PRIORITY, optional EActionPointCost Cost = eCost_Single)
{
	local X2AbilityTemplate                 Template;	

	`CREATE_X2ABILITY_TEMPLATE(Template, DataName);

	Template.ShotHUDPriority = ShotHUDPriority;
	Template.IconImage = IconImage;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;

	if (Cost != eCost_None)
	{
		Template.AbilityCosts.AddItem(ActionPointCost(Cost));	
	}

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	// Don't allow the ability to be used while the unit is disoriented, burning, unconscious, etc.
	Template.AddShooterEffectExclusions();

	// 100% chance to hit
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (Effect != none)
	{
		if (X2Effect_Persistent(Effect) != none)
			X2Effect_Persistent(Effect).SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);

		Template.AddTargetEffect(Effect);
	}

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	// Use an animation of pointing at the target, rather than the weapon animation.
	Template.CustomFireAnim = 'HL_SignalPoint';
	
	Template.bCrossClassEligible = bCrossClassEligible;

	return Template;
}

// Helper function for creating an ability that targets an ally (or the user).
static function X2AbilityTemplate TargetedBuff(name DataName, string IconImage, optional bool bCrossClassEligible = false, optional X2Effect Effect = none, optional int ShotHUDPriority = default.AUTO_PRIORITY, optional EActionPointCost Cost = eCost_Single)
{
	local X2AbilityTemplate                 Template;	

	`CREATE_X2ABILITY_TEMPLATE(Template, DataName);

	Template.ShotHUDPriority = ShotHUDPriority;
	Template.IconImage = IconImage;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Defensive;

	if (Cost != eCost_None)
	{
		Template.AbilityCosts.AddItem(ActionPointCost(Cost));	
	}

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityTargetConditions.AddItem(default.LivingFriendlyTargetProperty);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Don't allow the ability to be used while the unit is disoriented, burning, unconscious, etc.
	Template.AddShooterEffectExclusions();

	// 100% chance to hit
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (Effect != none)
	{
		if (X2Effect_Persistent(Effect) != none)
			X2Effect_Persistent(Effect).SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);

		Template.AddTargetEffect(Effect);
	}

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	// Use an animation of pointing at the target, rather than the weapon animation.
	Template.CustomFireAnim = 'HL_SignalPoint';
	
	Template.bCrossClassEligible = bCrossClassEligible;

	return Template;
}

// Helper function for creating an ability that affects all friendly units.
static function X2AbilityTemplate SquadPassive(name DataName, string IconImage, bool bCrossClassEligible, X2Effect_Persistent Effect)
{
	local X2AbilityTemplate	Template, TriggerTemplate;
	local X2Condition_UnitEffectsWithAbilitySource Condition;
	local XMBAbilityTrigger_EventListener EventListener;

	// Create a normal passive, which triggers when the unit enters play. This
	// also provides the icon for the ability.
	Template = Passive(DataName, IconImage, bCrossClassEligible, none);

	Effect.BuildPersistentEffect(1, true, false, false);

	// The passive applies the effect to all friendly units at the start of play.
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';
	Template.AddMultiTargetEffect(Effect);
	 
	Condition = new class'X2Condition_UnitEffectsWithAbilitySource';
	Condition.AddExcludeEffect(Effect.EffectName, 'AA_UnitIsImmune');
	Effect.TargetConditions.AddItem(Condition);

	// Create a triggered ability which will apply the effect to friendly units
	// that are created after play begins.
	TriggerTemplate = TargetedBuff(name(DataName $ "_OnUnitBeginPlay"), IconImage, false, Effect,, eCost_None);

	// The triggered ability shouldn't have a fire visualization added
	TriggerTemplate.bSkipFireAction = true;

	// Remove the default input trigger added by TargetedBuff()
	TriggerTemplate.AbilityTriggers.Length = 0;

	// Don't show the ability as activatable in the HUD
	TriggerTemplate.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	// Set up a trigger that will fire whenever another unit enters the battle
	// XMBAbilityTrigger_EventListener doesn't use ListenerData.EventFn
	EventListener = new class'XMBAbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'OnUnitBeginPlay';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.bSelfTarget = false;
	TriggerTemplate.AbilityTriggers.AddItem(EventListener);

	// Add the triggered ability as a secondary ability
	AddSecondaryAbility(Template, TriggerTemplate);

	return Template;
}

static function AddSecondaryEffect(X2AbilityTemplate Template, X2Effect Effect)
{
	if (X2Effect_Persistent(Effect) != none)
		X2Effect_Persistent(Effect).SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true, , Template.AbilitySourceName);
	if (XMBEffect_ConditionalBonus(Effect) != none)
		XMBEffect_ConditionalBonus(Effect).bHideWhenNotRelevant = true;

	Template.AddTargetEffect(Effect);
}

// Hides the icon of an ability. For use with secondary abilities added in AdditionaAbilities that
// shouldn't get their own icon.
static function HidePerkIcon(X2AbilityTemplate Template)
{
	local X2Effect Effect;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	foreach Template.AbilityTargetEffects(Effect)
	{
		if (X2Effect_Persistent(Effect) != none)
			X2Effect_Persistent(Effect).bDisplayInUI = false;
	}
}

// Helper function for creating an X2AbilityCost_ActionPoints.
static function X2AbilityCost_ActionPoints ActionPointCost(EActionPointCost Cost)
{
	local X2AbilityCost_ActionPoints			AbilityCost;

	AbilityCost = new class'X2AbilityCost_ActionPoints';
	switch (Cost)
	{
	case eCost_Free:				AbilityCost.iNumPoints = 1; AbilityCost.bFreeCost = true; break;
	case eCost_Single:				AbilityCost.iNumPoints = 1; break;
	case eCost_SingleConsumeAll:	AbilityCost.iNumPoints = 1; AbilityCost.bConsumeAllPoints = true; break;
	case eCost_Double:				AbilityCost.iNumPoints = 2; break;
	case eCost_DoubleConsumeAll:	AbilityCost.iNumPoints = 2; AbilityCost.bConsumeAllPoints = true; break;
	case eCost_Weapon:				AbilityCost.iNumPoints = 0; AbilityCost.bAddWeaponTypicalCost = true; break;
	case eCost_WeaponConsumeAll:	AbilityCost.iNumPoints = 0; AbilityCost.bAddWeaponTypicalCost = true; AbilityCost.bConsumeAllPoints = true; break;
	case eCost_Overwatch:			AbilityCost.iNumPoints = 1; AbilityCost.bConsumeAllPoints = true; AbilityCost.bFreeCost = true; break;
	case eCost_None:				AbilityCost.iNumPoints = 0; break;
	}

	return AbilityCost;
}

// Helper function for adding a cooldown to an ability. This takes an internal cooldown duration,
// which is one turn longer than the cooldown displayed in ability help text because it includes
// the turn the ability was applied.
static function AddCooldown(X2AbilityTemplate Template, int iNumTurns)
{
	local X2AbilityCooldown AbilityCooldown;
	AbilityCooldown = new class'X2AbilityCooldown';
	AbilityCooldown.iNumTurns = iNumTurns;
	Template.AbilityCooldown = AbilityCooldown;
}

// Helper function for adding an ammo cost to an ability.
static function AddAmmoCost(X2AbilityTemplate Template, int iAmmo)
{
	local X2AbilityCost_Ammo AmmoCost;
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = iAmmo;
	Template.AbilityCosts.AddItem(AmmoCost);
}

// Helper function for giving an ability a limited number of charges.
static function AddCharges(X2AbilityTemplate Template, int InitialCharges)
{
	local X2AbilityCharges Charges;
	local X2AbilityCost_Charges ChargeCost;

	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = InitialCharges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);
}

// Helper function for making an ability trigger whenever another unit moves in the unit's vision. 
// This is usually used for overwatch-type abilities.
static function AddMovementTrigger(X2AbilityTemplate Template)
{
	local X2AbilityTrigger_Event Trigger;
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
}

// Helper function for making an ability trigger whenever another unit acts in the unit's vision. 
// This is usually used for overwatch-type abilities.
static function AddAttackTrigger(X2AbilityTemplate Template)
{
	local X2AbilityTrigger_Event Trigger;
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
}

// Helper function for preventing an ability from applying to the same target too often. This works
// by creating a dummy persistent effect that does nothing and expires after some number of turns,
// and adding a condition that prevents the ability from affecting units with the dummy persistent
// effect. One common use is to prevent overwatch-type abilities from triggering more than once
// against the same target in a turn.
static function AddPerTargetCooldown(X2AbilityTemplate Template, optional int iTurns = 1, optional name CooldownEffectName = '', optional GameRuleStateChange GameRule = eGameRule_PlayerTurnEnd)
{
	local X2Effect_Persistent PersistentEffect;
	local X2Condition_UnitEffectsWithAbilitySource EffectsCondition;

	if (CooldownEffectName == '')
	{
		CooldownEffectName = name(Template.DataName $ "_CooldownEffect");
	}

	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.EffectName = CooldownEffectName;
	PersistentEffect.DuplicateResponse = eDupe_Refresh;
	PersistentEffect.BuildPersistentEffect(iTurns, false, true, false, GameRule);
	PersistentEffect.bApplyOnHit = true;
	PersistentEffect.bApplyOnMiss = true;
	Template.AddTargetEffect(PersistentEffect);
	Template.AddMultiTargetEffect(PersistentEffect);

	// Create a condition that checks for the presence of a certain effect. There are three
	// similar classes that do this: X2Condition_UnitEffects,
	// X2Condition_UnitEffectsWithAbilitySource, and X2Condition_UnitEffectsWithAbilityTarget.
	// The first one looks for any effect with the right name, the second only for effects
	// with that were applied by the unit using this ability, and the third only for effects
	// that apply to the unit using this ability. Since we want to match the persistent effect
	// we applied as a mark - but not the same effect applied by any other unit - we use
	// X2Condition_UnitEffectsWithAbilitySource.

	EffectsCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	EffectsCondition.AddExcludeEffect(CooldownEffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectsCondition);
	Template.AbilityMultiTargetConditions.AddItem(EffectsCondition);
}

// For abilities with an XMBAbilityTrigger_EventListener, such as abilities created by
// SelfTargetTrigger, this adds an AbilityTargetCondition to the listener. Use this when you want
// to add a restriction based on the ability that caused the trigger to fire, for example with an
// AbilityActivated trigger. If you want to add a restriction on the unit the triggered ability
// will apply to, use X2AbilityTemplate.AbilityTargetConditions instead.
static function AddTriggerTargetCondition(X2AbilityTemplate Template, X2Condition Condition)
{
	local X2AbilityTrigger Trigger;

	foreach Template.AbilityTriggers(Trigger)
	{
		if (XMBAbilityTrigger_EventListener(Trigger) != none)
			XMBAbilityTrigger_EventListener(Trigger).AbilityTargetConditions.AddItem(Condition);
	}
}

// For abilities with an XMBAbilityTrigger_EventListener, such as abilities created by
// SelfTargetTrigger, this adds an AbilityShooterCondition to the listener. In most cases you
// should use X2AbilityTemplate.AbilityShooterConditions instead of this.
static function AddTriggerShooterCondition(X2AbilityTemplate Template, X2Condition Condition)
{
	local X2AbilityTrigger Trigger;

	foreach Template.AbilityTriggers(Trigger)
	{
		if (XMBAbilityTrigger_EventListener(Trigger) != none)
			XMBAbilityTrigger_EventListener(Trigger).AbilityShooterConditions.AddItem(Condition);
	}
}

// Prevent an ability from targetting a unit that already has any of the effects the ability would
// add. You should also set DuplicateResponse to eDupe_Ignore if you use this.
static function PreventStackingEffects(X2AbilityTemplate Template)
{
	local X2Condition_UnitEffectsWithAbilitySource EffectsCondition;
	local X2Effect Effect;

	EffectsCondition = new class'X2Condition_UnitEffectsWithAbilitySource';

	foreach Template.AbilityTargetEffects(Effect)
	{
		if (X2Effect_Persistent(Effect) != none)
			EffectsCondition.AddExcludeEffect(X2Effect_Persistent(Effect).EffectName, 'AA_UnitIsImmune');
	}

	Template.AbilityTargetConditions.AddItem(EffectsCondition);
}

// Adds a secondary ability that provides a passive icon for the ability. For use with triggered
// abilities and other abilities that should have a passive icon but don't have a passive effect
// to use with Passive.
static function AddIconPassive(X2AbilityTemplate Template)
{
	local X2AbilityTemplate IconTemplate;

	IconTemplate = PurePassive(name(Template.DataName $ "_Icon"), Template.IconImage);

	AddSecondaryAbility(Template, IconTemplate);
	
	// Use the long description, rather than the help text
	X2Effect_Persistent(IconTemplate.AbilityTargetEffects[0]).FriendlyDescription = Template.LocLongDescription;
}

// Adds an arbitrary secondary ability to an ability template. This handles copying over the
// ability's localized name and description to the secondary, so you only have to write one entry
// for the ability in XComGame.int.
static function AddSecondaryAbility(X2AbilityTemplate Template, X2AbilityTemplate SecondaryTemplate)
{
	local X2Effect Effect;
	local X2Effect_Persistent PersistentEffect;

	Template.AdditionalAbilities.AddItem(SecondaryTemplate.DataName);

	SecondaryTemplate.LocFriendlyName = Template.LocFriendlyName;
	SecondaryTemplate.LocHelpText = Template.LocHelpText;
	SecondaryTemplate.LocLongDescription = Template.LocLongDescription;
	SecondaryTemplate.LocFlyOverText = Template.LocFlyOverText;

	foreach SecondaryTemplate.AbilityTargetEffects(Effect)
	{
		PersistentEffect = X2EFfect_Persistent(Effect);
		if (PersistentEffect == none)
			continue;

		PersistentEffect.FriendlyName = Template.LocFriendlyName;
		PersistentEffect.FriendlyDescription = Template.LocHelpText;
	}

	foreach SecondaryTemplate.AbilityShooterEffects(Effect)
	{
		PersistentEffect = X2EFfect_Persistent(Effect);
		if (PersistentEffect == none)
			continue;

		PersistentEffect.FriendlyName = Template.LocFriendlyName;
		PersistentEffect.FriendlyDescription = Template.LocHelpText;
	}

	XMBAbility(class'XComEngine'.static.GetClassDefaultObject(default.class)).ExtraTemplates.AddItem(SecondaryTemplate);
}

static function XMBEffect_ConditionalBonus AddBonusPassive(X2AbilityTemplate Template, name DataName = name(Template.DataName $ "_Bonuses"))
{
	local X2AbilityTemplate PassiveTemplate;
	local XMBEffect_ConditionalBonus BonusEffect;
	local XMBCondition_AbilityName Condition;

	BonusEffect = new class'XMBEffect_ConditionalBonus';
	Condition = new class'XMBCondition_AbilityName';

	Condition.IncludeAbilityNames.AddItem(Template.DataName);
	BonusEffect.AbilityTargetConditions.AddItem(Condition);

	PassiveTemplate = Passive(DataName, Template.IconImage, false, BonusEffect);
	AddSecondaryAbility(Template, PassiveTemplate);
	HidePerkIcon(PassiveTemplate);

	return BonusEffect;
}

// Helper function for creating an X2Condition that requires a maximum distance between shooter and target.
simulated static function X2Condition_UnitProperty TargetWithinTiles(int Tiles)
{
	local X2Condition_UnitProperty UnitPropertyCondition;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.RequireWithinRange = true;
	// WithinRange is measured in Unreal units, so we need to convert tiles to units.
	UnitPropertyCondition.WithinRange = `TILESTOUNITS(Tiles);

	// Remove default checks
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeCosmetic = false;
	UnitPropertyCondition.ExcludeInStasis = false;

	return UnitPropertyCondition;
}

// Set this as the VisualizationFn on an X2Effect_Persistent to have it display a flyover over the target when applied.
simulated static function EffectFlyOver_Visualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local EWidgetColor					MessageColor;
	local XComGameState_Unit			SourceUnit;
	local bool							bGoodAbility;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	
	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.SourceObject.ObjectID));

	bGoodAbility = SourceUnit.IsFriendlyToLocalPlayer();
	MessageColor = bGoodAbility ? eColor_Good : eColor_Bad;

	if (EffectApplyResult == 'AA_Success' && XGUnit(ActionMetadata.VisualizeActor).IsAlive())
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', MessageColor, AbilityTemplate.IconImage);
	}
}

// This is an implementation detail. We replace X2DataSet.CreateTemplatesEvent() in order to add 
// extra templates that come from AddSecondaryAbility() calls.
static event array<X2DataTemplate> CreateTemplatesEvent()
{
	local array<X2DataTemplate> BaseTemplates, NewTemplates;
	local X2DataTemplate CurrentBaseTemplate;
	local int Index;

	BaseTemplates = CreateTemplates();
	for (Index = 0; Index < default.ExtraTemplates.Length; ++Index)
		BaseTemplates.AddItem(default.ExtraTemplates[Index]);

	for( Index = 0; Index < BaseTemplates.Length; ++Index )
	{
		CurrentBaseTemplate = BaseTemplates[Index];
		CurrentBaseTemplate.ClassThatCreatedUs = default.Class;

		if( default.bShouldCreateDifficultyVariants )
		{
			CurrentBaseTemplate.bShouldCreateDifficultyVariants = true;
		}

		if( CurrentBaseTemplate.bShouldCreateDifficultyVariants )
		{
			CurrentBaseTemplate.CreateDifficultyVariants(NewTemplates);
		}
		else
		{
			NewTemplates.AddItem(CurrentBaseTemplate);
		}
	}

	return NewTemplates;
}


defaultproperties
{
	Begin Object Class=XMBCondition_CoverType Name=DefaultFullCoverCondition
		AllowedCoverTypes[0] = CT_Standing
	End Object
	FullCoverCondition = DefaultFullCoverCondition

	Begin Object Class=XMBCondition_CoverType Name=DefaultHalfCoverCondition
		AllowedCoverTypes[0] = CT_MidLevel
	End Object
	HalfCoverCondition = DefaultHalfCoverCondition

	Begin Object Class=XMBCondition_CoverType Name=DefaultNoCoverCondition
		AllowedCoverTypes[0] = CT_None
	End Object
	NoCoverCondition = DefaultNoCoverCondition

	Begin Object Class=XMBCondition_CoverType Name=DefaultFlankedCondition
		AllowedCoverTypes[0] = CT_None
		bRequireCanTakeCover = true
	End Object
	FlankedCondition = DefaultFlankedCondition

	Begin Object Class=XMBCondition_HeightAdvantage Name=DefaultHeightAdvantageCondition
		bRequireHeightAdvantage = true
	End Object
	HeightAdvantageCondition = DefaultHeightAdvantageCondition

	Begin Object Class=XMBCondition_HeightAdvantage Name=DefaultHeightDisadvantageCondition
		bRequireHeightDisadvantage = true
	End Object
	HeightDisadvantageCondition = DefaultHeightDisadvantageCondition

	Begin Object Class=XMBCondition_ReactionFire Name=DefaultReactionFireCondition
	End Object
	ReactionFireCondition = DefaultReactionFireCondition

	Begin Object Class=XMBCondition_Dead Name=DefaultDeadCondition
	End Object
	DeadCondition = DefaultDeadCondition

	Begin Object Class=XMBCondition_AbilityHitResult Name=DefaultHitCondition
		bRequireHit = true
	End Object
	HitCondition = DefaultHitCondition

	Begin Object Class=XMBCondition_AbilityHitResult Name=DefaultMissCondition
		bRequireMiss = true
	End Object
	MissCondition = DefaultMissCondition

	Begin Object Class=XMBCondition_AbilityHitResult Name=DefaultCritCondition
		IncludeHitResults[0] = eHit_Crit
	End Object
	CritCondition = DefaultCritCondition

	Begin Object Class=XMBCondition_AbilityHitResult Name=DefaultGrazeCondition
		IncludeHitResults[0] = eHit_Graze
	End Object
	GrazeCondition = DefaultGrazeCondition

	Begin Object Class=XMBCondition_MatchingWeapon Name=DefaultMatchingWeaponCondition
	End Object
	MatchingWeaponCondition = DefaultMatchingWeaponCondition

	Begin Object Class=XMBCondition_AbilityProperty Name=DefaultMeleeCondition
		bRequireMelee = true
	End Object
	MeleeCondition = DefaultMeleeCondition

	Begin Object Class=XMBCondition_AbilityProperty Name=DefaultRangedCondition
		bExcludeMelee = true
	End Object
	RangedCondition = DefaultRangedCondition

	Begin Object Class=X2Condition_UnitProperty Name=DefaultLivingFriendlyTargetProperty
		ExcludeAlive=false
		ExcludeDead=true
		ExcludeFriendlyToSource=false
		ExcludeHostileToSource=true
		RequireSquadmates=true
		FailOnNonUnits=true
	End Object
	LivingFriendlyTargetProperty = DefaultLivingFriendlyTargetProperty

	AUTO_PRIORITY = -1
}