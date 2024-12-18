//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_PerkPackAbilitySet2
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines general use ability templates -- second set to reduce merging issues
//--------------------------------------------------------------------------------------- 

class X2Ability_PerkPackAbilitySet2 extends X2Ability config (LW_SoldierSkills) dependson(X2Effect_TemporaryItem);

var localized string TrojanVirus;
var localized string TrojanVirusTriggered;
var localized string DenseSmokeGrenadeEffectDisplayName;
var localized string DenseSmokeGrenadeEffectDisplayDesc;
var localized string ShellshockEffectName, ShellshockEffectDesc, ShockwaveEffectName, ShockwaveEffectDesc;

var config int NUM_AIRDROP_CHARGES;
var config int SAVIOR_BONUS_HEAL;
var config int REQUIRED_TO_HIT_FOR_OVERWATCH;
var config float BONUS_SLICE_DAMAGE_PER_TILE;
var config int MAX_SLICE_FLECHE_DAMAGE;
var config array<name> REQUIRED_OVERWATCH_TO_HIT_EXCLUDED_ABILITIES;
var config array<name> SNAP_SHOT_ABILITIES;

var config int COLLATERAL_COOLDOWN;
var config int COLLATERAL_AMMO;
var config int COLLATERAL_RADIUS;
var config int COLLATERAL_ENVDMG;


var config int DENSESMOKEGRENADE_HITMOD;
var config array<name> SMOKE_GRENADES_FOR_DENSE_SMOKE;

var config int STING_GRENADE_STUN_CHANCE;
var config int STING_GRENADE_STUN_LEVEL;
var config array<name> FLASHBANGS_FOR_STING_GRENADES;

var config int MWREPAIR_HEAL;
var config int MWREPAIR_COOLDOWN;
var config int HEAVYDUTY_EXTRAHEAL;

var config int ENHANCED_SYSTEMS_BONUS_CHARGES;

var config int NEUTRALIZE_COOLDOWN;
var config int NEUTRALIZE_RADIUS;

var config int TRIANGULATION_HITMOD;

var config int KS_COOLDOWN;

var config int CS_COOLDOWN;

var config int OBLITERATOR_DMG;

var config int REBOOT_HACK;
var config int REBOOT_AIM;
var config int REBOOT_MOB;

var config float LAYERED_MULT;

var config int ADVANCED_LOGIC_HACK_BONUS;

var config array<name> ATTACK_GRENADES;
var config int SHELLSHOCK_AIM_REDUCTION;
var config int SHELLSHOCK_CRIT_CHANCE_REDUCTION;
var config int SHELLSHOCK_TURNS;

var config int SHOCKWAVE_DEF_REDUCTION;
var config int SHOCKWAVE_DODGE_REDUCTION;
var config int SHOCKWAVE_TURNS;

var config int ChainingJolt_Cooldown;

const DAMAGED_COUNT_NAME = 'DamagedCountThisTurn';

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddSnapShot());
	Templates.AddItem(SnapShotOverwatch());
	Templates.AddItem(AddSnapShotAimModifierAbility());
	Templates.AddItem(AddTrojan());
	Templates.AddItem(AddTrojanVirus());
	Templates.AddItem(AddTrojanVirusAPDrain());
	Templates.AddItem(AddFlashbanger());
	Templates.AddItem(AddSmokeGrenade());
	Templates.AddItem(AddSavior());
	Templates.AddItem(AddDenseSmoke());
	Templates.AddItem(AddRapidDeployment());
	Templates.AddItem(AddAirdrop());
	Templates.AddItem(AddSwordSlice_LWAbility());
	Templates.AddItem(AddFleche());
	Templates.AddItem(AddBastion());
	Templates.AddItem(AddBastionPassive());
	Templates.AddItem(AddBastionCleanse());
	Templates.AddItem(AddFullKit());
	Templates.AddItem(AddStingGrenades());
	Templates.AddItem(AddFieldSurgeon());
	Templates.AddItem(AddDamageInstanceTracker());
	Templates.AddItem(CreateDedicatedSuppressionAbility());
	Templates.AddItem(CreateCollateralAbility());
	Templates.AddItem(KineticStrike());
	Templates.AddItem(Reboot());
	Templates.AddItem(RebootTriggered());
	Templates.AddItem(RedunSysTriggered());
	Templates.AddItem(PurePassive('RapidRepair_LW', "img:///UILibrary_MW.UIPerk_rapid_repair"));
	Templates.AddItem(PurePassive('HeavyRepair_LW', "img:///UILibrary_MW.UIPerk_heavyduty"));
	Templates.AddItem(RedundantSystems());
	Templates.AddItem(ConcussiveStrike());
	Templates.AddItem(Obliterator());
	Templates.AddItem(Neutralize());
	Templates.AddItem(RepairMW());
	Templates.AddItem(Triangulation());
	Templates.AddItem(TriangulationTrigger());
	Templates.AddItem(BrawlerProtocol());
	Templates.AddItem(BrawlerTrigger());
	Templates.AddItem(LayeredArmour());
	Templates.AddItem(CreateEnhancedSystemsAbility());
	Templates.AddItem(CreatePostRebootRepair());
	Templates.AddItem(CreateReactionSystemsAbility());
	Templates.AddItem(CreateHackBonusAbility());
	Templates.AddItem(CreateComboHoloAAAbility());
	Templates.AddItem(CreateSpectralStunLancerImpairingEffectAbility());
	Templates.AddItem(PurePassive('Shellshock_LW', "img:///UILibrary_LWOTC.UIPerk_shellshock"));
	Templates.AddItem(PurePassive('Shockwave_LW', "img:///UILibrary_LWOTC.UIPerk_shockwave"));
	Templates.AddItem(ChainingJolt());

	return Templates;
}

// - Generic : Standard Shot -
static function X2AbilityTemplate AddSnapShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local array<name>                       SkipExclusions;
	local X2Effect_Knockback				KnockbackEffect;
	local X2Condition_Visibility            VisibilityCondition;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'SnapShot');

	// Icon Properties
	//Template.bDontDisplayInAbilitySummary = true;
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySnapShot";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('SniperStandardFire');
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	if (!class'X2Ability_PerkPackAbilitySet'.default.NO_STANDARD_ATTACKS_WHEN_ON_FIRE)
	{
		SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	}

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Targeting Details
	// Can only shoot visible enemies
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	// Can't target dead; Can't target friendlies
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	// Can't shoot while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	// Only at single targets that are in range.
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true; // 	

	// Weapon Upgrade Compatibility
	Template.bAllowFreeFireWeaponUpgrade = true;                        // Flag that permits action to become 'free action' via 'Hair Trigger' or similar upgrade / effects

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	//  Various Soldier ability specific effects - effects check for the ability before applying	
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	
	// Damage Effect
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	// Hit Calculation (Different weapons now have different calculations for range)
	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.AssociatedPassives.AddItem('HoloTargeting');

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	//Template.bDisplayInUITooltip = false;
	//Template.bDisplayInUITacticalText = false;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	//Template.OverrideAbilities.AddItem('SniperStandardFire');

	Template.AdditionalAbilities.AddItem('SnapShotAimModifier');
	Template.AdditionalAbilities.AddItem('WeaponHandling_LW');
	//Template.AdditionalAbilities.AddItem('SnapShotOverwatch');

	return Template;	
}

static function X2AbilityTemplate SnapShotOverwatch()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Condition_AbilityProperty       CoveringFireCondition;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Condition_UnitEffects           SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SnapShotOverwatch');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;                  //  ammo is consumed by the shot, not by this, but this should verify ammo is available
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;  // change to 1 for SnapShot
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	
	ReserveActionPointsEffect = new class'X2Effect_ReserveOverwatchPoints';
	Template.AddTargetEffect(ReserveActionPointsEffect);

	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = 'OverwatchShot';
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	CoveringFireCondition = new class'X2Condition_AbilityProperty';
	CoveringFireCondition.OwnerHasSoldierAbilities.AddItem('CoveringFire');
	CoveringFireEffect.TargetConditions.AddItem(CoveringFireCondition);
	Template.AddTargetEffect(CoveringFireEffect);

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddTargetEffect(UnitValueEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('SniperRifleOverwatch');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.Hostility = eHostility_Defensive;

	Template.DefaultKeyBinding = class'UIUtilities_Input'.const.FXS_KEY_Y;
	Template.bNoConfirmationWithHotKey = true;

	//Template.OverrideAbilities.AddItem('');

	return Template;	
}

static function X2AbilityTemplate AddSnapShotAimModifierAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_SnapShotAimModifier			AimModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SnapShotAimModifier');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySnapShot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	AimModifier = new class 'X2Effect_SnapShotAimModifier';
	AimModifier.BuildPersistentEffect (1, true, false);
	AimModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (AimModifier);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this ability places an effect on the unit that can hack, and triggers when the unit successfully hacks another unit
static function X2AbilityTemplate AddTrojan()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Trojan			TrojanEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Trojan');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityTrojan";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	TrojanEffect = new class 'X2Effect_Trojan';
	TrojanEffect.BuildPersistentEffect (1, true, false);
	TrojanEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (TrojanEffect);
	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.AdditionalAbilities.AddItem('TrojanVirus');
	Template.AdditionalAbilities.AddItem('TrojanVirusAPDrain');

	return Template;
}

//this ability is what gets triggered by a successful hack, and places the TrojanVirus effect on the hacked unit
static function X2AbilityTemplate AddTrojanVirus()
{
	local X2AbilityTemplate                 Template;		
	local X2AbilityCost_ActionPoints        ActionPointCost;	
	local X2Condition_UnitProperty          ShooterPropertyCondition;	
	local X2Condition_UnitProperty          TargetUnitPropertyCondition;	
	//local X2Condition_Visibility            TargetVisibilityCondition;
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_Placeholder		UseTrigger;
	local X2Effect_TrojanVirus				TrojanVirusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TrojanVirus');
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	//Can't evaluate stimuli while dead
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    	
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	//No triggering on dead, or friendlies
	TargetUnitPropertyCondition = new class'X2Condition_UnitProperty';	
	TargetUnitPropertyCondition.ExcludeDead = true;                    	
	TargetUnitPropertyCondition.ExcludeFriendlyToSource = false;	
	Template.AbilityTargetConditions.AddItem(TargetUnitPropertyCondition);

	// Note: No visibility requirement (matches intrusion protocol)
	// These must be the same or you can hack a robot and not have trojan apply.

	//Always applied when triggered
	Template.AbilityToHitCalc = default.DeadEye;

	//Single target ability
	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	//Triggered by persistent effect from Trojan
	UseTrigger = new class'X2AbilityTrigger_Placeholder';
	Template.AbilityTriggers.AddItem(UseTrigger);
	
	TrojanVirusEffect = new class 'X2Effect_TrojanVirus';
	TrojanVirusEffect.BuildPersistentEffect (1, true, false /*Remove on Source Death*/,, eGameRule_UnitGroupTurnBegin);
	TrojanVirusEffect.bTickWhenApplied = false;
	//TrojanVirusEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TrojanVirusEffect.EffectRemovedVisualizationFn = TrojanVirusVisualizationRemoved;
	Template.AddTargetEffect (TrojanVirusEffect);

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.Hostility = eHostility_Neutral;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = none; // no visualization on application on purpose -- it would be fighting with the hacking stuff

	return Template;	
}

static function X2AbilityTemplate AddTrojanVirusAPDrain()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;	
	local X2Condition_UnitProperty          ShooterPropertyCondition;	
	local X2Condition_UnitProperty          TargetUnitPropertyCondition;	
	local X2AbilityTarget_Single            SingleTarget;
	local X2AbilityTrigger_Placeholder		UseTrigger;
	local X2Effect_RemoveTurnStartActionPoints RemoveAPEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TrojanVirusAPDrain');
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	//Can't evaluate stimuli while dead
	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;                    	
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	//No triggering on dead, or friendlies
	TargetUnitPropertyCondition = new class'X2Condition_UnitProperty';	
	TargetUnitPropertyCondition.ExcludeDead = true;                    	
	TargetUnitPropertyCondition.ExcludeFriendlyToSource = false;	
	Template.AbilityTargetConditions.AddItem(TargetUnitPropertyCondition);

	//Always applied when triggered
	Template.AbilityToHitCalc = default.DeadEye;

	//Single target ability
	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	//Triggered by persistent effect from TrojanVirus
	UseTrigger = new class'X2AbilityTrigger_Placeholder';
	Template.AbilityTriggers.AddItem(UseTrigger);

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";
	Template.Hostility = eHostility_Neutral;

	RemoveAPEffect = new class'X2Effect_RemoveTurnStartActionPoints';
	RemoveAPEffect.BuildPersistentEffect (1, false, false /*Remove on Source Death*/,, eGameRule_PlayerTurnBegin);
	Template.AddTargetEffect (RemoveAPEffect);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

// plays Trojan Virus flyover and message when the effect is removed (which is when the meaningful effects are triggered)
static function TrojanVirusVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local XGParamTag kTag;
	local X2Action_PlayWorldMessage MessageAction;

	UnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
	if (UnitState == none)
		return;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, default.TrojanVirus, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Haywire, 1.0);

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = UnitState.GetFullName();

	MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	MessageAction.AddWorldMessage(`XEXPAND.ExpandString(default.TrojanVirusTriggered));
}

//this ability grants a free equip of a flashbang grenade
static function X2AbilityTemplate AddFlashbanger()
{
	local X2AbilityTemplate						Template;
	local X2Effect_TemporaryItem				TemporaryItemEffect;
	local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Flashbanger');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_flash";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Trigger.Priority -= 20; // delayed so that Full Kit happen first
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;
	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'FlashbangerEffect';
	TemporaryItemEffect.ItemName = 'FlashbangGrenade';

	//POTENTIALLY DEPRECATED
	TemporaryItemEffect.AlternativeItemNames.AddItem('StingGrenade');

	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('IRI_LaunchOrdnance');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('IRI_BlastOrdnance');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this ability grants a free equip of a smoke grenade, dense smoke grenade, smoke bomb, or dense smoke bomb
static function X2AbilityTemplate AddSmokeGrenade()
{
	local X2AbilityTemplate						Template;
	local X2Effect_TemporaryItem				TemporaryItemEffect;
	local ResearchConditional					Conditional;
	local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SmokeGrenade');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Trigger.Priority -= 20; // delayed so that Full Kit happen first
	Template.AbilityTriggers.AddItem(Trigger);

	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;

	Conditional.ResearchProjectName = 'AdvancedGrenades';
	Conditional.ItemName = 'SmokeGrenadeMk2';

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'SmokeGrenadeEffect';
	TemporaryItemEffect.ItemName = 'SmokeGrenade';
	TemporaryItemEffect.ResearchOptionalItems.AddItem(Conditional);

	//POTENTIALLY DEPERECATED
	TemporaryItemEffect.AlternativeItemNames.AddItem('DenseSmokeGrenade');
	TemporaryItemEffect.AlternativeItemNames.AddItem('DenseSmokeGrenadeMk2');

	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('IRI_LaunchOrdnance');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('IRI_BlastOrdnance');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this ability causes the unit to heal more when using medikits
static function X2AbilityTemplate AddSavior()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Savior						SaviorEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Savior');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilitySavior";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;

	SaviorEffect = new class 'X2Effect_Savior';
	SaviorEffect.BuildPersistentEffect (1, true, false);
	SaviorEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	SaviorEffect.BonusHealAmount = default.SAVIOR_BONUS_HEAL;
	Template.AddTargetEffect(SaviorEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this increases the defense bonus of smoke grenades and smoke bombs used by the unit
// accomplished by swapping out existing smoke grenade/bomb for a dense smoke version
//ALTERATION: Just going to make this a passive and just apply the effect to traditional smoke grenades
//MANY DEPERECATIONS INBOUND LOL
static function X2AbilityTemplate AddDenseSmoke()
{
	local X2AbilityTemplate						Template;
	local X2Effect_TemporaryItem				TemporaryItemEffect;
	local ResearchConditional					Conditional;
	//local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	Template = PurePassive('DenseSmoke', "img:///UILibrary_LW_PerkPack.LW_AbilityDenseSmoke");
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'DenseSmoke');

	//MEGA DELETE. We don't need any of this. Also got rid of a duplicate return.
	/*Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDenseSmoke";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = true;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Trigger.Priority -= 40; // delayed so that any other abilities that add items happen first
	Template.AbilityTriggers.AddItem(Trigger);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'DenseSmokeGrenadeEffect';
	TemporaryItemEffect.ItemName = 'DenseSmokeGrenade';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'SmokeGrenade';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'DenseSmokeBombEffect';
	TemporaryItemEffect.ItemName = 'DenseSmokeGrenadeMk2';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'SmokeGrenadeMk2';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	//TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;*/

	Conditional.ResearchProjectName = 'AdvancedGrenades';
	Conditional.ItemName = 'SmokeGrenadeMk2';

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'DenseSmokeGrenadeEffect';
	TemporaryItemEffect.ItemName = 'SmokeGrenade';
	TemporaryItemEffect.ResearchOptionalItems.AddItem(Conditional);

	//POTENTIALLY DEPERECATED
	TemporaryItemEffect.AlternativeItemNames.AddItem('DenseSmokeGrenade');
	TemporaryItemEffect.AlternativeItemNames.AddItem('DenseSmokeGrenadeMk2');

	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('IRI_LaunchOrdnance');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('IRI_BlastOrdnance');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2Effect DenseSmokeEffect()
{
	local X2Effect_DenseSmokeEffect Effect;
	local X2Condition_AbilityProperty	AbilityCondition;

	Effect = new class'X2Effect_DenseSmokeEffect';
	Effect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, default.DenseSmokeGrenadeEffectDisplayName, default.DenseSmokeGrenadeEffectDisplayDesc, "img:///UILibrary_LW_PerkPack.LW_AbilityDenseSmoke", true,,'eAbilitySource_Perk');
	Effect.Defense = default.DENSESMOKEGRENADE_HITMOD;

	AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('DenseSmoke');
    Effect.TargetConditions.AddItem(AbilityCondition);

	return Effect;
}

//this ability allows the next use (this turn) of smoke grenade or flashbang to be free
static function X2AbilityTemplate AddRapidDeployment()
{
	local X2AbilityTemplate					Template;
	local X2Effect_RapidDeployment			RapidDeploymentEffect;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RapidDeployment');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityRapidDeployment";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STASIS_LANCE_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bIsPassive = true;
	Template.AddShooterEffectExclusions();
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Cooldown = new class'X2AbilityCooldown';
    Cooldown.iNumTurns = class'X2Effect_RapidDeployment'.default.RAPID_DEPLOYMENT_COOLDOWN;
    Template.AbilityCooldown = Cooldown;

	Template.AbilityCosts.AddItem(default.FreeActionCost);
	
	RapidDeploymentEffect = new class 'X2Effect_RapidDeployment';
	RapidDeploymentEffect.BuildPersistentEffect (1, false, true, true, eGameRule_PlayerTurnEnd);
	RapidDeploymentEFfect.EffectName = 'RapidDeploymentEffect';
	RapidDeploymentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (RapidDeploymentEffect);

	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = RapidDeployment_BuildVisualization;
	Template.bShowActivation = false;

	return Template;
}

// plays Rapid Deployment flyover and message when the ability is activated
static function RapidDeployment_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
    local XComGameStateContext_Ability		context;
    local StateObjectReference				InteractingUnitRef;
    local VisualizationActionMetadata		EmptyTrack, BuildTrack; 
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyover; 
	local XComGameState_Ability				Ability;

    History = `XCOMHISTORY;
    context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
    InteractingUnitRef = context.InputContext.SourceObject;
    BuildTrack = EmptyTrack;
    BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
    BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
    BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
    
    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context, false, BuildTrack.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_xcom);
}

//this ability grants a free equip of a either a frag grenade or plasma grenade to the targetted unit
static function X2AbilityTemplate AddAirdrop()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_TemporaryItem			TemporaryItemEffect;
	local ResearchConditional				Conditional;
	local X2Condition_UnitProperty			TargetProperty;
	local X2AbilityCost_Charges             ChargeCost;
	local X2AbilityCharges                  Charges;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Airdrop');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityAirdrop";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.NUM_AIRDROP_CHARGES;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	TargetProperty.RequireSquadmates = true;
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.ExcludeAlien = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	Conditional.ResearchProjectName = 'PlasmaGrenade';
	Conditional.ItemName = 'AlienGrenade';

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'AirdropGrenadeEffect';
	TemporaryItemEffect.ItemName = 'FragGrenade';
	TemporaryItemEffect.ResearchOptionalItems.AddItem(Conditional);
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('IRI_LaunchOrdnance');
	TemporaryItemEffect.ForceCheckAbilities.AddItem('IRI_BlastOrdnance');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(TemporaryItemEffect);

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	
	Template.CustomSelfFireAnim = 'NO_CombatProtocol';
	Template.CinescriptCameraType = "Specialist_CombatProtocol";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}


static function X2AbilityTemplate AddSwordSlice_LWAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SwordSlice_LW');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Ranger_Reaper";
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.bCrossClassEligible = false;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Damage Effect
	//
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	
	// Voice events
	//
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	Template.AdditionalAbilities.AddItem('Fleche');

	return Template;
}

//this passive causes SwordSlice to deal more damage the further the unit moved
static function X2AbilityTemplate AddFleche()
{
	local X2AbilityTemplate						Template;
	local X2Effect_FlecheBonusDamage			FlecheBonusDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Fleche');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFleche";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bHideOnClassUnlock = true;
	Template.bCrossClassEligible = false;
	FlecheBonusDamageEffect = new class 'X2Effect_FlecheBonusDamage';
	FlecheBonusDamageEffect.BonusDmgPerTile = default.BONUS_SLICE_DAMAGE_PER_TILE;
	FlecheBonusDamageEffect.MaxBonusDamage = default.MAX_SLICE_FLECHE_DAMAGE;
	FlecheBonusDamageEffect.AbilityNames.AddItem('SwordSlice');
	FlecheBonusDamageEffect.AbilityNames.AddItem('SwordSlice_LW');
	//FlecheBonusDamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	FlecheBonusDamageEffect.BuildPersistentEffect (1, true, false);
	Template.AddTargetEffect (FlecheBonusDamageEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AddBastion()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Bastion               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Bastion');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBastion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bCrossClassEligible = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'X2Effect_Bastion';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

	Template.AdditionalAbilities.AddItem('BastionCleanse');
	Template.AdditionalAbilities.AddItem('BastionPassive');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.PrerequisiteAbilities.AddItem('Fortress');

	return Template;
}

static function X2AbilityTemplate AddBastionPassive()
{
	return PurePassive('BastionPassive', "img:///UILibrary_LW_PerkPack.LW_AbilityBastion", , 'eAbilitySource_Psionic');
}

final static function EventListenerReturn SolaceBastionCleanseListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_Ability SourceAbility;

	SourceAbility = XComGameState_Ability(CallbackData);
	if (SourceAbility == None)
	{
		return ELR_NoInterrupt;
	}

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Unit', TargetUnit, , , GameState.HistoryIndex)
	{
		SourceAbility.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false);
	}

	return ELR_NoInterrupt;
}

static function X2AbilityTemplate AddBastionCleanse()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityTrigger_EventListener        EventListener;
	local X2Condition_UnitProperty              DistanceCondition;
	local X2Effect_RemoveEffects				FortressRemoveEffect;
	local X2Condition_UnitProperty              FriendCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BastionCleanse');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityBastion";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	EventListener.ListenerData.Filter = eFilter_None;
	EventListener.ListenerData.EventFn = SolaceBastionCleanseListener;  // keep this, since it's generically just calling the associate ability
	Template.AbilityTriggers.AddItem(EventListener);

	//removes any ongoing effects
	FortressRemoveEffect = new class'X2Effect_RemoveEffects';
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.AcidBurningName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.BurningName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2StatusEffects'.default.PoisonedName);
	FortressRemoveEffect.EffectNamesToRemove.AddItem(class'X2Effect_ParthenogenicPoison'.default.EffectName);
	FriendCondition = new class'X2Condition_UnitProperty';
	FriendCondition.ExcludeFriendlyToSource = false;
	FriendCondition.ExcludeHostileToSource = true;
	FortressRemoveEffect.TargetConditions.AddItem(FriendCondition);
	Template.AddTargetEffect(FortressRemoveEffect);

	DistanceCondition = new class'X2Condition_UnitProperty';
	DistanceCondition.RequireWithinRange = true;
	DistanceCondition.WithinRange = Sqrt(class'X2Effect_Bastion'.default.BASTION_DISTANCE_SQ) *  class'XComWorldData'.const.WORLD_StepSize; // same as Solace for now
	DistanceCondition.ExcludeFriendlyToSource = false;
	DistanceCondition.ExcludeHostileToSource = false;
	Template.AbilityTargetConditions.AddItem(DistanceCondition);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

//this ability grants the unit +1 charge for each grenade in a utility slot
static function X2AbilityTemplate AddFullKit()
{
	local X2AbilityTemplate						Template;
	local X2Effect_FullKit					FullKitEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FullKit');
	Template.IconImage = "img:///XPerkIconPack_LW.UIPerk_grenade_plus";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bUniqueSource = true;
	FullKitEffect = new class 'X2Effect_FullKit';
	FullKitEffect.BuildPersistentEffect (1, true, false);
	FullKitEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (FullKitEffect);
	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//this improves the effectiveness of flashbangs by giving them a chance to stun non-robotic units
// accomplished by swapping out existing flashbang items for new sting grenade item
//ALTERATION: Turning this into a pure passive. Effect application will be changed.
static function X2AbilityTemplate AddStingGrenades()
{
	local X2AbilityTemplate						Template;
	//local X2Effect_TemporaryItem				TemporaryItemEffect;
	//local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	Template = PurePassive('StingGrenades', "img:///UILibrary_LW_PerkPack.LW_AbilityStunGrenades");

	/* `CREATE_X2ABILITY_TEMPLATE(Template, 'StingGrenades');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityStunGrenades";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Trigger.Priority -= 40; // delayed so that any other abilities that add items happen first
	Template.AbilityTriggers.AddItem(Trigger);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'StingGrenadeEffect';
	TemporaryItemEffect.ItemName = 'StingGrenade';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'FlashbangGrenade';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'StingGrenadeEffect2';
	TemporaryItemEffect.ItemName = 'StingGrenade';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'HunterFlashbang';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);

	TemporaryItemEffect = new class'X2Effect_TemporaryItem';
	TemporaryItemEffect.EffectName = 'StingGrenadeEffect3';
	TemporaryItemEffect.ItemName = 'StingGrenade';
	TemporaryItemEffect.bReplaceExistingItemOnly = true;
	TemporaryItemEffect.ExistingItemName = 'AdvGrenadierFlashbangGrenade';
	TemporaryItemEffect.ForceCheckAbilities.AddItem('LaunchGrenade');
	TemporaryItemEffect.bIgnoreItemEquipRestrictions = true;
	TemporaryItemEffect.BuildPersistentEffect(1, true, false);
	TemporaryItemEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	TemporaryItemEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(TemporaryItemEffect);


	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;*/

	return Template;
}

//Should have all the basic logic from the sting grenade item.
static function X2Effect StingGrenadeEffect()
{
	local X2Effect_Stunned StunEffect;
	local X2Condition_AbilityProperty	AbilityCondition;
	local X2Condition_UnitProperty UnitCondition;

	StunEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.STING_GRENADE_STUN_LEVEL, default.STING_GRENADE_STUN_CHANCE, false);
	StunEffect.BuildPersistentEffect(1, true, false, false, eGameRule_UnitGroupTurnBegin);
	StunEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.StunnedFriendlyName, class'X2StatusEffects'.default.StunnedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun");
	StunEffect.bRemoveWhenSourceDies = false;
	
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = false;
	UnitCondition.IncludeWeakAgainstTechLikeRobot = false;
	UnitCondition.ExcludeFriendlyToSource = false;

	AbilityCondition = new class'X2Condition_AbilityProperty';
    AbilityCondition.OwnerHasSoldierAbilities.AddItem('StingGrenades');

    StunEffect.TargetConditions.AddItem(AbilityCondition);
	StunEffect.TargetConditions.AddItem(UnitCondition);

	return StunEffect;
}

//this ability allows some healing of wounds (reducing lowest HP) at end of mission, if the field surgeon is alive and well
static function X2AbilityTemplate AddFieldSurgeon()
{
	local X2AbilityTemplate						Template;
	local X2Effect_FieldSurgeon					FieldSurgeonEffect;
	local X2AbilityTrigger_EventListener 		EventListener;	
	local X2Condition_UnitProperty              TargetProperty;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FieldSurgeon');
	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityFieldSurgeon";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.RequireSquadmates = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);	

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'OnUnitBeginPlay';	
	EventListener.ListenerData.EventFn = FieldSurgeonOnUnitBeginPlay;
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.Filter = eFilter_None;	
	Template.AbilityTriggers.AddItem(EventListener);
	
	FieldSurgeonEffect = new class 'X2Effect_FieldSurgeon';
	FieldSurgeonEffect.BuildPersistentEffect (1, true, false);
	FieldSurgeonEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);	
	Template.AddTargetEffect(FieldSurgeonEffect);

	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function EventListenerReturn FieldSurgeonOnUnitBeginPlay(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Ability SourceAbilityState;

	SourceAbilityState = XComGameState_Ability(CallbackData);	
	UnitState = XComGameState_Unit(EventData);

	if (SourceAbilityState != None  && UnitState != none) {	
		SourceAbilityState.AbilityTriggerAgainstSingleTarget(UnitState.GetReference(), false);
	}

	return ELR_NoInterrupt;
}

// Ability that tracks how many times a unit has been damaged each turn
static function X2AbilityTemplate AddDamageInstanceTracker()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	Trigger;	
	local X2Effect_IncrementUnitValue		CounterEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DamageInstanceTracker');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'UnitTakeEffectDamage';
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(Trigger);

	CounterEffect = new class'X2Effect_IncrementUnitValue';
	CounterEffect.UnitName = DAMAGED_COUNT_NAME;
	CounterEffect.NewValueToSet = 1;
	CounterEffect.CleanupType = eCleanup_BeginTurn;
	CounterEffect.bApplyOnHit = true;
	Template.AddShooterEffect(CounterEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// No visualization for this ability

	return Template;
}

static function X2AbilityTemplate CreateDedicatedSuppressionAbility()
{
	local X2AbilityTemplate		Template;

	Template = PurePassive('DedicatedSuppression_LW', "img:///UILibrary_XPerkIconPack.UIPerk_suppression_defense2", , 'eAbilitySource_Perk');

	return Template;
}



// Mechatronic Warfare perks below: Credit to NotSoLoneWolf for permission to include them

static function X2AbilityTemplate CreateCollateralAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityCooldown						Cooldown;
	local X2AbilityTarget_Cursor				CursorTarget;
	local X2AbilityMultiTarget_Radius			RadiusMultiTarget;
	local X2Effect_CollateralDamage				DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Collateral_LW');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_collateral";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bLimitTargetIcons = true;

	Template.AbilityCosts.AddItem(default.WeaponActionTurnEnding);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.COLLATERAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.COLLATERAL_AMMO;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	// Slightly modified from Rocket Launcher template to let it get over blocking cover better
	Template.TargetingMethod = class'X2TargetingMethod_Collateral';
		
	// Give it a radius multi-target
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = `UNITSTOMETERS(default.COLLATERAL_RADIUS);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_CollateralDamage';
	DamageEffect.BONUS_MULT = 0.4;
	DamageEffect.MIN_BONUS = 1;
	DamageEffect.EnvironmentalDamageAmount = default.COLLATERAL_ENVDMG;
	DamageEffect.AllowArmor = true;
	DamageEffect.AddBonus = true;
	Template.AddMultiTargetEffect(DamageEffect);
	
	Template.bOverrideVisualResult = true;
	Template.OverrideVisualResult = eHit_Miss;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Demolition'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Demolition'

	return Template;
}


static function X2AbilityTemplate Reboot()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Sustain              SustainEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Reboot_LW');

	Template.IconImage = "img:///UILibrary_MW.UIPerk_reboot";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	SustainEffect = new class'X2Effect_Sustain';
	SustainEffect.BuildPersistentEffect(1, true, true);
	SustainEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(SustainEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.AdditionalAbilities.AddItem('RebootTriggered_LW');

	return Template;
}

static function X2DataTemplate RebootTriggered()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Stasis                   StasisEffect;
	local X2Effect_PersistentStatChange		HackEffect;
	local X2AbilityTrigger_EventListener    EventTrigger;
	local X2Condition_UnitEffects			UnitEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RebootTriggered_LW');

	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_reboot";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	StasisEffect = new class'X2Effect_Stasis';
	StasisEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	StasisEffect.bUseSourcePlayerState = true;
	StasisEffect.bRemoveWhenTargetDies = true;
	StasisEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	StasisEffect.StunStartAnim = 'HL_StunnedStartA';
	StasisEffect.bSkipFlyover = true;
	Template.AddTargetEffect(StasisEffect);
	
	HackEffect = new class'X2Effect_PersistentStatChange';
	HackEffect.BuildPersistentEffect(1, true, false);
	HackEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, "This unit has been Rebooted from catastrophic damage and is suffering -30 aim, -3 mobility, and -100 hack.", Template.IconImage,,, Template.AbilitySourceName); 
	HackEffect.AddPersistentStatChange(eStat_Hacking, default.REBOOT_HACK);
	HackEffect.AddPersistentStatChange(eStat_Offense, default.REBOOT_AIM);
	HackEffect.AddPersistentStatChange(eStat_Mobility, default.REBOOT_MOB);
	Template.AddTargetEffect(HackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechBonusLabel, eStat_Hacking, default.REBOOT_HACK);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, default.REBOOT_AIM);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.REBOOT_MOB);

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = class'X2Effect_Sustain'.default.SustainEvent;
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventTrigger);

	UnitEffects = new class'X2Condition_UnitEffects';
	UnitEffects.AddExcludeEffect('RedunSysEffect_LW', 'AA_DuplicateEffectIgnored');
	UnitEffects.AddExcludeEffect('RedunSysEffect', 'AA_DuplicateEffectIgnored');
	Template.AbilityShooterConditions.AddItem(UnitEffects);

	Template.PostActivationEvents.AddItem(class'X2Effect_Sustain'.default.SustainTriggeredEvent);
	
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate RedundantSystems()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Persistent           PersistentEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RedundantSystems_LW');

	Template.IconImage = "img:///UILibrary_MW.UIPerk_redundant_systems";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	//  This is a dummy effect so that an icon shows up in the UI.
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
	PersistentEffect.EffectName = 'RedunSysEffect_LW';
	Template.AddTargetEffect(PersistentEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	Template.bCrossClassEligible = false;
	
	Template.AdditionalAbilities.AddItem('RedunSysTriggered_LW');

	return Template;
}

// Identical to the above ability but requires Redundant Systems and doesn't cast debuffs on the SPARK
static function X2DataTemplate RedunSysTriggered()
{
	local X2AbilityTemplate                 Template;
	local X2Effect_Stasis                   StasisEffect;
	local X2AbilityTrigger_EventListener    EventTrigger;
	local X2Condition_UnitEffects			UnitEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RedunSysTriggered_LW');

	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_redundant_systems";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	StasisEffect = new class'X2Effect_Stasis';
	StasisEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	StasisEffect.bUseSourcePlayerState = true;
	StasisEffect.bRemoveWhenTargetDies = true;
	StasisEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
	StasisEffect.StunStartAnim = 'HL_StunnedStartA';
	StasisEffect.bSkipFlyover = true;
	Template.AddTargetEffect(StasisEffect);

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = class'X2Effect_Sustain'.default.SustainEvent;
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventTrigger);

	UnitEffects = new class'X2Condition_UnitEffects';
	UnitEffects.AddRequireEffect('RedunSysEffect_LW', 'AA_DuplicateEffectIgnored');
	Template.AbilityShooterConditions.AddItem(UnitEffects);

	Template.PostActivationEvents.AddItem(class'X2Effect_Sustain'.default.SustainTriggeredEvent);
	
	Template.bSkipFireAction = true;
	Template.FrameAbilityCameraType = eCameraFraming_Never;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}


static function X2AbilityTemplate RepairMW()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCharges_Repair_LW              Charges;
	local X2AbilityCost_Charges                 ChargeCost;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_ApplyRepairHeal_LW			HealEffect;
	local X2Effect_RepairArmor_LW				ArmorEffect;
	local X2Condition_UnitProperty              UnitCondition;
	local X2Effect_RemoveEffectsByDamageType	RemoveEffects;
//	local X2AbilityTrigger_EventListener		EventTrigger;
	local name HealType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RepairMW_LW');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_repair";

	Charges = new class'X2AbilityCharges_Repair_LW';
	Template.AbilityCharges = Charges;
	
	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('RapidRepair_LW');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.MWREPAIR_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	HealEffect = new class'X2Effect_ApplyRepairHeal_LW';
	HealEffect.PerUseHP = default.MWREPAIR_HEAL;
	HealEffect.IncreasedHealAbility = 'HeavyRepair_LW';
	HealEffect.IncreasedPerUseHP = default.HEAVYDUTY_EXTRAHEAL;
	Template.AddTargetEffect(HealEffect);

	ArmorEffect = new class'X2Effect_RepairArmor_LW';
	Template.AddTargetEffect(ArmorEffect);

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}
	Template.AddTargetEffect(RemoveEffects);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeFullHealth = true;
	UnitCondition.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	/*// Added for Post Reboot Repair
	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = 'PostRebootRepair_LW';
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventTrigger);*/

	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_Repair';
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.CinescriptCameraType = "Spark_SendBit";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}


static function X2AbilityTemplate KineticStrike()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_DLC_3StrikeDamage		WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityCooldown_SparkMelee                 Cooldown;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KineticStrike_LW');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;		
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_strike";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.MeleePuckMeshPath = "Materials_DLC3.MovePuck_Strike";

	Cooldown = new class'X2AbilityCooldown_SparkMelee';
	Cooldown.iNumTurns = default.KS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bMoveCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInHitMod = 15;
	StandardMelee.BuiltInCritMod = 15;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_DLC_3StrikeDamage';
	WeaponDamageEffect.EnvironmentalDamageAmount = 0;
	Template.AddTargetEffect(WeaponDamageEffect);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 1;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	Template.CustomFireAnim = 'FF_Melee';
	Template.CustomMovingFireAnim = 'MV_Melee';	

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 8;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddTargetEffect(KnockbackEffect);
	Template.bOverrideMeleeDeath = true;

	//Template.DamagePreviewFn = GetStrikeDamagePreview;

	// Voice events
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Spark_Strike";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Strike'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Strike'

	return Template;
}

function bool GetStrikeDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference BladeMasterRef;
	local XComGameState_Ability BladeMasterAbility;
	//local StateObjectReference AssaultServosRef;
	//local XComGameState_Ability AssaultServosAbility;
	local XComGameStateHistory History;

	AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);

	`LWTrace("MinDamagePreview:" @MinDamagePreview.Damage);
	`LWTrace("MaxDamagePreview:" @MaxDamagePreview.Damage);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	BladeMasterRef = AbilityOwner.FindAbility('Blademaster');
	BladeMasterAbility = XComGameState_Ability(History.GetGameStateForObjectID(BladeMasterRef.ObjectID));

	if(BladeMasterAbility != none)
	{
		MinDamagePreview.Damage += class'X2Ability_RangerAbilitySet'.default.BLADEMASTER_DMG;
		MaxDamagePreview.Damage += class'X2Ability_RangerAbilitySet'.default.BLADEMASTER_DMG;
	}

	`LWTrace("MinDamagePreview after Blademaster check:" @MinDamagePreview.Damage);
	`LWTrace("MaxDamagePreview after Blademaster check:" @MaxDamagePreview.Damage);

	//AssaultServosRef = AbilityOwner.FindAbility('Obliterator_LW');
	//AssaultServosAbility = XComGameState_Ability(History.GetGameStateForObjectID(AssaultServosRef.ObjectID));

	//if(AssaultServosAbility != none)
	//{
	//	MinDamagePreview.Damage += default.OBLITERATOR_DMG;
	//	MaxDamagePreview.Damage += default.OBLITERATOR_DMG;
	//}

	`LWTrace("MinDamagePreview after Assault Servos check:" @MinDamagePreview.Damage);
	`LWTrace("MaxDamagePreview after Assault Servos check:" @MaxDamagePreview.Damage);

	return true;
}

static function X2AbilityTemplate ConcussiveStrike()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_HalfDamage_LW				WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_Stunned					StunnedEffect;
	local X2Condition_UnitProperty			TargetProperty;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ConcussiveStrike_LW');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;		
	Template.IconImage = "img:///UILibrary_MW.UIPerk_concussive";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.MeleePuckMeshPath = "Materials_DLC3.MovePuck_Strike";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.CS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bMoveCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInHitMod = 15;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeRobotic = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_HalfDamage_LW';
	WeaponDamageEffect.EnvironmentalDamageAmount = 0;
	Template.AddTargetEffect(WeaponDamageEffect);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 1;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	Template.CustomFireAnim = 'FF_Melee';
	Template.CustomMovingFireAnim = 'MV_Melee';	

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 8;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddTargetEffect(KnockbackEffect);
	Template.bOverrideMeleeDeath = true;

	//Stunning Effect
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);
	StunnedEffect.MinStatContestResult = 0;
	StunnedEffect.MaxStatContestResult = 0;
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);

	//Template.DamagePreviewFn=GetConcussiveStrikeDamagePreview;

	// Voice events
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Spark_Strike";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Strike'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Strike'

	return Template;
}


function bool GetConcussiveStrikeDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference BladeMasterRef;
	local XComGameState_Ability BladeMasterAbility;
	local StateObjectReference AssaultServosRef;
	local XComGameState_Ability AssaultServosAbility;
	local XComGameStateHistory History;

	AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	`LWTrace("MinDamagePreview:" @MinDamagePreview.Damage);
	`LWTrace("MaxDamagePreview:" @MaxDamagePreview.Damage);

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	BladeMasterRef = AbilityOwner.FindAbility('Blademaster');
	BladeMasterAbility = XComGameState_Ability(History.GetGameStateForObjectID(BladeMasterRef.ObjectID));

	if(BladeMasterAbility != none)
	{
		MinDamagePreview.Damage += class'X2Ability_RangerAbilitySet'.default.BLADEMASTER_DMG;
		MaxDamagePreview.Damage += class'X2Ability_RangerAbilitySet'.default.BLADEMASTER_DMG;
	}
	`LWTrace("MinDamagePreview after Blademaster check:" @MinDamagePreview.Damage);
	`LWTrace("MaxDamagePreview after Blademaster check:" @MaxDamagePreview.Damage);

	AssaultServosRef = AbilityOwner.FindAbility('Obliterator_LW');
	AssaultServosAbility = XComGameState_Ability(History.GetGameStateForObjectID(AssaultServosRef.ObjectID));

	if(AssaultServosAbility != none)
	{
		MinDamagePreview.Damage += default.OBLITERATOR_DMG;
		MaxDamagePreview.Damage += default.OBLITERATOR_DMG;
	}

	`LWTrace("MinDamagePreview after Assault Servos check:" @MinDamagePreview.Damage);
	`LWTrace("MaxDamagePreview after Assault Servos check:" @MaxDamagePreview.Damage);

	return true;
}


static function X2AbilityTemplate Obliterator()
{
	local X2AbilityTemplate						Template;
	local X2Effect_MeleeBonusDamage            DamageEffect;
	local X2Effect_ToHitModifier                HitModEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Obliterator_LW');
	Template.IconImage = "img:///UILibrary_MW.UIPerk_obliterator";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_MeleeBonusDamage';
	DamageEffect.BonusDamageFlat = default.OBLITERATOR_DMG;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.EffectName = 'Obliterator_LW';
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	HitModEffect = new class'X2Effect_ToHitModifier';
	HitModEffect.AddEffectHitModifier(eHit_Success, 10, Template.LocFriendlyName, , true, false, true, true);
	HitModEffect.BuildPersistentEffect(1, true, false, false);
	HitModEffect.EffectName = 'ObliteratorAim_LW';
	Template.AddTargetEffect(HitModEffect);

	Template.AdditionalAbilities.AddItem('WreckingBall');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate Neutralize()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2AbilityCost_ActionPoints 	ActionPointCost;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2AbilityCooldown             Cooldown;
	local X2Effect_DisableWeapon		DisableEffect;
	//local X2Effect_Persistent			DisorientedEffect;
	local X2Effect_PerkAttachForFX      PerkEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Neutralize_LW');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_neutralize";
	
	//Template.AbilityCosts.AddItem(default.FreeActionCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);	
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.NEUTRALIZE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.NEUTRALIZE_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	PerkEffect = new class'X2Effect_PerkAttachForFX';
	PerkEffect.EffectAddedFn = class'X2Ability_SparkAbilitySet'.static.Bombard_EffectAdded;
	Template.AddShooterEffect(PerkEffect);

	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
	
	// target effects
	DisableEffect = new class'X2Effect_DisableWeapon';
	DisableEffect.ApplyChance = 100;
	Template.AddMultiTargetEffect(DisableEffect);

	//DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false);
	//DisorientedEffect.bRemoveWhenSourceDies = true;
	//Template.AddTargetEffect(DisorientedEffect);

	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.SendGremlinToLocation_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SparkAbilitySet'.static.Bombard_BuildVisualization;

	Template.CinescriptCameraType = "Spark_Bombard";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function X2AbilityTemplate Triangulation()
{
	local X2AbilityTemplate			Template;
	local X2Effect_CoveringFire		Effect;
	
	Template = PurePassive('Triangulation_LW', "img:///UILibrary_MW.UIPerk_triangulation", false, 'eAbilitySource_Perk', true);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Effect = new class'X2Effect_CoveringFire';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.AbilityToActivate = 'TriangulationTrigger_LW';
	Effect.GrantActionPoint = 'triangulate';
	Effect.bPreEmptiveFire = false;
	Effect.bDirectAttackOnly = true;
	Effect.bOnlyDuringEnemyTurn = true;
	Effect.bUseMultiTargets = false;
	Effect.MaxPointsPerTurn = 99;
	Effect.EffectName = 'TriangulationWatchEffect';
	Template.AddTargetEffect(Effect);
	
	Template.AdditionalAbilities.AddItem('TriangulationTrigger_LW');

	return Template;
}

static function X2AbilityTemplate TriangulationTrigger()
{
	local X2AbilityTemplate						Template;
	local X2Condition_UnitEffects				Condition;
	local X2Effect_HoloTarget					Effect;
	local X2AbilityCost_ReserveActionPoints		ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TriangulationTrigger_LW');
	Template.IconImage = "img:///UILibrary_MW.UIPerk_triangulation";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.bCrossClassEligible = false;

	ActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('triangulate');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Condition = new class'X2Condition_UnitEffects';
	Condition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
	Template.AbilityShooterConditions.AddItem(Condition);

	// build the aim buff
    Effect = new class'X2Effect_HoloTarget';
	Effect.HitMod = default.TRIANGULATION_HITMOD;
	Effect.EffectName='TriangulateTarget';
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, "Triangulated", "All enemies of this unit gain extra Aim when firing at it.", "img:///UILibrary_MW.UIPerk_triangulation", true);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Template.AddTargetEffect(Effect);
	
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	Template.CustomFireAnim = 'NO_Intimidate';
	Template.bShowActivation = true;
	Template.CinescriptCameraType = "Spark_Intimidate";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}



static function X2AbilityTemplate BrawlerProtocol()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('BrawlerProtocol_LW', "img:///UILibrary_MW.UIPerk_counterstrike", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('BrawlerTrigger_LW');

	return Template;
}

static function X2AbilityTemplate BrawlerTrigger()
{
	local X2AbilityTemplate							Template;
	local X2AbilityToHitCalc_StandardMelee			ToHitCalc;
	local X2AbilityTrigger_Event					Trigger;
	local X2Effect_Persistent						BrawlerTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource	BrawlerTargetCondition;
	local X2AbilityTrigger_EventListener			EventListener;
	local X2Condition_UnitProperty					SourceNotConcealedCondition;
	local X2Condition_Visibility					TargetVisibilityCondition;
	local X2Effect_HalfDamage_LW						DamageEffect;
	local X2Condition_PunchRange_LW					RangeCondition;
	local X2Condition_NotItsOwnTurn					NotItsOwnTurnCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BrawlerTrigger_LW');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_counterstrike";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	ToHitCalc.bReactionFire = true;
	ToHitCalc.BuiltInHitMod = 10;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

	// trigger on movement
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	// trigger on movement in the postbuild
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'PostBuildGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	// trigger on an attack
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	// it may be the case that enemy movement caused a concealment break, which made Brawler applicable - attempt to trigger afterwards
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = Brawler_LWConcealmentListener;
	EventListener.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(EventListener);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for overwatch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	//Ensure the attack only triggers in melee range
	RangeCondition = new class'X2Condition_PunchRange_LW';
	Template.AbilityTargetConditions.AddItem(RangeCondition);

	//Ensure the caster isn't dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();

	// Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	SourceNotConcealedCondition.RequireWithinRange = true;

	// Require that the target is next to the source
	SourceNotConcealedCondition.WithinRange = `TILESTOUNITS(1);
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	Template.bAllowBonusWeaponEffects = true;
	
	DamageEffect = new class'X2Effect_HalfDamage_LW';
	DamageEffect.EnvironmentalDamageAmount = 0;
	Template.AddTargetEffect(DamageEffect);

	//Prevent repeatedly hammering on a unit with Brawler triggers.
	//(This effect does nothing, but enables many-to-many marking of which Brawler attacks have already occurred each turn.)
	BrawlerTargetEffect = new class'X2Effect_Persistent';
	BrawlerTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BrawlerTargetEffect.EffectName = 'BrawlerTarget_LW';
	BrawlerTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(BrawlerTargetEffect);
	
	BrawlerTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BrawlerTargetCondition.AddExcludeEffect('BrawlerTarget_LW', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BrawlerTargetCondition);
	NotItsOwnTurnCondition = new class'X2Condition_NotItsOwnTurn';
	Template.AbilityShooterConditions.AddItem(NotItsOwnTurnCondition);
	

	Template.CustomFireAnim = 'FF_Melee';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Brawler_BuildVisualization;
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NormalChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

//Must be static, because it will be called with a different object (an XComGameState_Ability)
//Used to trigger Brawler when the source's concealment is broken by a unit in melee range (the regular movement triggers get called too soon)
static function EventListenerReturn Brawler_LWConcealmentListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit ConcealmentBrokenUnit;
	local StateObjectReference BrawlerRef;
	local XComGameState_Ability BrawlerState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	ConcealmentBrokenUnit = XComGameState_Unit(EventSource);	
	if (ConcealmentBrokenUnit == None)
		return ELR_NoInterrupt;

	//Do not trigger if the Brawler SPARK himself moved to cause the concealment break - only when an enemy moved and caused it.
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
	if (AbilityContext != None && AbilityContext.InputContext.SourceObject != ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef)
		return ELR_NoInterrupt;

	BrawlerRef = ConcealmentBrokenUnit.FindAbility('BrawlerTrigger_LW');
	if (BrawlerRef.ObjectID == 0)
		return ELR_NoInterrupt;

	BrawlerState = XComGameState_Ability(History.GetGameStateForObjectID(BrawlerRef.ObjectID));
	if (BrawlerState == None)
		return ELR_NoInterrupt;
	
	BrawlerState.AbilityTriggerAgainstSingleTarget(ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef, false);
	return ELR_NoInterrupt;
}

simulated function Brawler_BuildVisualization(XComGameState VisualizeGameState)
{
	// Build the first shot of Brawler's visualization
	TypicalAbility_BuildVisualization(VisualizeGameState);
}


static function X2AbilityTemplate LayeredArmour()
{
	local X2AbilityTemplate						Template;
	local X2Effect_LayeredArmour_LW				ArmourEffect;
	local X2AbilityTrigger_UnitPostBeginPlay	StartTrigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LayeredArmour_LW');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_intimidate";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	StartTrigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	StartTrigger.Priority = 0; // Must start after other damage reduction abilities.
	Template.AbilityTriggers.AddItem(StartTrigger);

	ArmourEffect = new class'X2Effect_LayeredArmour_LW';
	ArmourEffect.MaxDamage = default.LAYERED_MULT;
	ArmourEffect.BuildPersistentEffect(1, true, true, true);
	ArmourEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, , , Template.AbilitySourceName);
	Template.AddTargetEffect(ArmourEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

// Combo perk using some of the above:

static function X2AbilityTemplate CreateEnhancedSystemsAbility()
{
	local X2AbilityTemplate Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EnhancedSystems_LW');

	Template.IconImage = "img:///UILibrary_MW.UIPerk_redundant_systems";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	Template.AdditionalAbilities.AddItem('RapidRepair_LW');
	Template.AdditionalAbilities.AddItem('RedundantSystems_LW');
	//Template.AdditionalAbilities.AddItem('HeavyRepair_LW');
	Template.AdditionalAbilities.AddItem('PostRebootRepair_LW');

	return Template;
}

static function X2AbilityTemplate CreatePostRebootRepair()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_EventListener EventTrigger;
	local X2Effect_ApplyRepairHeal_LW HealEffect;
	local X2Effect_RepairArmor_LW ArmorEffect;
	local X2Effect_RemoveEffectsByDamageType RemoveEffects;
	local Name HealType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PostRebootRepair_LW');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_intrusionprotocol";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	

	EventTrigger = new class'X2AbilityTrigger_EventListener';
	EventTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventTrigger.ListenerData.EventID = class'X2Effect_Sustain'.default.SustainEvent;
	EventTrigger.ListenerData.Filter = eFilter_Unit;
	EventTrigger.ListenerData.Priority = 125;
	EventTrigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventTrigger);

	
	HealEffect = new class'X2Effect_ApplyRepairHeal_LW';
	HealEffect.PerUseHP = default.MWREPAIR_HEAL;
	HealEffect.IncreasedHealAbility = 'HeavyRepair_LW';
	HealEffect.IncreasedPerUseHP = default.HEAVYDUTY_EXTRAHEAL;
	Template.AddTargetEffect(HealEffect);

	ArmorEffect = new class'X2Effect_RepairArmor_LW';
	Template.AddTargetEffect(ArmorEffect);

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}
	Template.AddTargetEffect(RemoveEffects);

	// This only works with LW's version of Repair because an event listener activation is added to it.
	//Template.PostActivationEvents.AddItem('PostRebootRepair_LW');

	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_Repair';
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.CinescriptCameraType = "Spark_SendBit";

	return Template;
}

static function X2AbilityTemplate CreateReactionSystemsAbility()
{
	local X2AbilityTemplate Template;

	Template = PurePassive('ReactionSystems_LW', "img:///UILibrary_DLC3Images.UIPerk_spark_sacrifice", false, 'eAbilitySource_Perk', false);

	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.AdditionalAbilities.AddItem('Sacrifice');
	Template.AdditionalAbilities.AddItem('AbsorptionField');

	return Template;
}

static function X2AbilityTemplate CreateHackBonusAbility()
{
	local X2AbilityTemplate Template;
	local X2Effect_PersistentStatChange HackBonusEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AdvancedLogic_LW');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_intrusionprotocol";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	HackBonusEffect = new class'X2Effect_PersistentStatChange';
	HackBonusEffect.BuildPersistentEffect(1, true, false);
	HackBonusEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	HackBonusEffect.AddPersistentStatChange(eStat_Hacking, default.ADVANCED_LOGIC_HACK_BONUS);

	Template.AddTargetEffect(HackBonusEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreateComboHoloAAAbility()
{
	local X2AbilityTemplate Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HoloAACombo_LW');

	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_adaptiveaim";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.AdditionalAbilities.AddItem('HoloTargeting');
	Template.AdditionalAbilities.AddItem('AdaptiveAim');

	return Template;
}


static function X2DataTemplate CreateSpectralStunLancerImpairingEffectAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityToHitCalc_StatCheck_UnitVsUnit    StatContest;
	local X2AbilityTarget_Single            SingleTarget;
	local X2Effect_Persistent               DisorientedEffect;
	local X2Effect_Stunned				    StunnedEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SpectralStunImpairingAbility');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');      //  ability is activated by another ability that hits

	// Target Conditions
	//
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	// Shooter Conditions
	//
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AddShooterEffectExclusions();

	// This will be a stat contest
	StatContest = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';
	StatContest.AttackerStat = eStat_Strength;
	Template.AbilityToHitCalc = StatContest;

	// On hit effects
	//  Stunned effect for 1 or 2 unblocked hit
	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
	DisorientedEffect.MinStatContestResult = 1;
	DisorientedEffect.MaxStatContestResult = 2;
	DisorientedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(DisorientedEffect);

	//  Stunned effect for 3 or 4 unblocked hit
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false);
	StunnedEffect.MinStatContestResult = 3;
	StunnedEffect.MaxStatContestResult = 0;
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);



	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = StunLancerImpairing_BuildVisualization;

//BEGIN AUTOGENERATED CODE: Template Overrides 'StunImpairingAbility'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'StunImpairingAbility'

	Template.bSkipPerkActivationActions = true;
	Template.bSkipPerkActivationActionsSync = false;
	Template.bSkipFireAction = true;

	return Template;
}

simulated function StunLancerImpairing_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

}

static function ImpairingAbilityEffectTriggeredVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateContext Context;
	local XComGameStateContext_Ability TestAbilityContext;
	local int i, j, ChildIndex;
	local XComGameStateHistory History;
	local bool bAbilityWasSuccess;
	local X2AbilityTemplate AbilityTemplate;
	local X2VisualizerInterface TargetVisualizerInterface;
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_ApplyWeaponDamageToUnit DamageAction;
	local X2Action TempAction;
	local X2Action_MarkerNamed HitReactAction;

	if( (EffectApplyResult != 'AA_Success') || (XComGameState_Unit(ActionMetadata.StateObject_NewState) == none) )
	{
		return;
	}

	Context = VisualizeGameState.GetContext();
	AbilityContext = XComGameStateContext_Ability(Context);

	if( AbilityContext.EventChainStartIndex != 0 )
	{
		History = `XCOMHISTORY;

		// This GameState is part of a chain, which means there may be a stun to the target
		for( i = AbilityContext.EventChainStartIndex; !Context.bLastEventInChain; ++i )
		{
			Context = History.GetGameStateFromHistory(i).GetContext();

			TestAbilityContext = XComGameStateContext_Ability(Context);
			bAbilityWasSuccess = (TestAbilityContext != none) && class'XComGameStateContext_Ability'.static.IsHitResultHit(TestAbilityContext.ResultContext.HitResult);

			if( bAbilityWasSuccess &&
				TestAbilityContext.InputContext.AbilityTemplateName == 'SpectralStunImpairingAbility' &&
				TestAbilityContext.InputContext.SourceObject.ObjectID == AbilityContext.InputContext.SourceObject.ObjectID &&
				TestAbilityContext.InputContext.PrimaryTarget.ObjectID == AbilityContext.InputContext.PrimaryTarget.ObjectID )
			{
				// The Melee Impairing Ability has been found with the same source and target
				// Move that ability's visualization forward to this track
				AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(TestAbilityContext.InputContext.AbilityTemplateName);

				for( j = 0; j < AbilityTemplate.AbilityTargetEffects.Length; ++j )
				{
					AbilityTemplate.AbilityTargetEffects[j].AddX2ActionsForVisualization(TestAbilityContext.AssociatedState, ActionMetadata, TestAbilityContext.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[j]));
				}

				TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
				if (TargetVisualizerInterface != none)
				{
					TargetVisualizerInterface.BuildAbilityEffectsVisualization(Context.AssociatedState, ActionMetadata);
				}

				VisMgr = `XCOMVISUALIZATIONMGR;

				DamageAction = X2Action_ApplyWeaponDamageToUnit(VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', ActionMetadata.VisualizeActor));

				if( DamageAction.ChildActions.Length > 0 )
				{
					HitReactAction = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, true, DamageAction));
					HitReactAction.SetName("ImpairingReact");
					HitReactAction.AddInputEvent('Visualizer_AbilityHit');

					for( ChildIndex = 0; ChildIndex < DamageAction.ChildActions.Length; ++ChildIndex )
					{
						TempAction = DamageAction.ChildActions[ChildIndex];
						VisMgr.DisconnectAction(TempAction);
						VisMgr.ConnectAction(TempAction, VisMgr.BuildVisTree, false, , DamageAction.ParentActions);
					}

					VisMgr.DisconnectAction(DamageAction);
					VisMgr.ConnectAction(DamageAction, VisMgr.BuildVisTree, false, ActionMetadata.LastActionAdded);
				}

				break;
			}
		}
	}
}



// Borrowed from Mitzruti's Perk Pack and tweaked
static function AddEffectsToGrenades()
{
	local X2ItemTemplateManager			ItemManager;
	local array<name>					TemplateNames;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;
	local X2GrenadeTemplate				GrenadeTemplate;
	local name							TemplateName;
	local X2Effect_PersistentStatChange	ShellShockEffect, ShockwaveEffect;
	local X2Condition_AbilityProperty	AbilityCondition;
	local X2Condition_UnitProperty		EnemyCondition;

	EnemyCondition = new class'X2Condition_UnitProperty';
	EnemyCondition.ExcludeFriendlyToSource = true;
	EnemyCondition.ExcludeHostileToSource = false;

	ShellShockEffect = new class'X2Effect_PersistentStatChange';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Shellshock_LW');
	ShellShockEffect.AddPersistentStatChange(eStat_Offense, -default.SHELLSHOCK_AIM_REDUCTION, modop_Addition);
	ShellShockEffect.AddPersistentStatChange(eStat_CritChance, -default.SHELLSHOCK_CRIT_CHANCE_REDUCTION, modop_Addition);
	ShellShockEffect.BuildPersistentEffect(default.SHELLSHOCK_TURNS, false, false, false, eGameRule_PlayerTurnEnd);
	ShellShockEffect.SetDisplayInfo(ePerkBuff_Penalty, default.ShellshockEffectName , default.ShellshockEffectDesc, "img:///UILibrary_LWOTC.UIPerk_shellshock", true);
	ShellShockEffect.TargetConditions.AddItem(AbilityCondition);
	ShellShockEffect.TargetConditions.AddItem(EnemyCondition);
	ShellShockEffect.bDisplayInSpecialDamageMessageUI = true;

	ShockwaveEffect = new class'X2Effect_PersistentStatChange';
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Shockwave_LW');
	ShockwaveEffect.AddPersistentStatChange(eStat_Defense, -default.SHOCKWAVE_DEF_REDUCTION, modop_Addition);
	ShockwaveEffect.AddPersistentStatChange(eStat_Dodge, -default.SHOCKWAVE_DODGE_REDUCTION, modop_Addition);
	ShockwaveEffect.BuildPersistentEffect(default.SHOCKWAVE_TURNS, false, false, false, eGameRule_PlayerTurnEnd);
	ShockwaveEffect.SetDisplayInfo(ePerkBuff_Penalty, default.ShockwaveEffectName, default.ShockwaveEffectDesc, "img:///UILibrary_LWOTC.UIPerk_shockwave", true);
	ShockwaveEffect.TargetConditions.AddItem(AbilityCondition);
	ShockwaveEffect.TargetConditions.AddItem(EnemyCondition);
	ShockwaveEffect.bDisplayInSpecialDamageMessageUI = true;
	

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemManager.GetTemplateNames(TemplateNames);

	// All grenades
	foreach TemplateNames(TemplateName)
	{
		ItemManager.FindDataTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
		// Iterate over all variants
		
		foreach TemplateAllDifficulties(Template)
		{
			GrenadeTemplate = X2GrenadeTemplate(Template);
			if (GrenadeTemplate != none)
			{
				if ( (GrenadeTemplate.BaseDamage.Damage > 0  && (GrenadeTemplate.ThrownGrenadeEffects.Length > 0 || GrenadeTemplate.LaunchedGrenadeEffects.Length > 0)) || default.ATTACK_GRENADES.find(TemplateName) != INDEX_NONE)
				{
					GrenadeTemplate.ThrownGrenadeEffects.AddItem(ShellShockEffect);
					GrenadeTemplate.LaunchedGrenadeEffects.AddItem(ShellShockEffect);
				}
			}
		}
	}
	
	// Damaging Grenades

	ItemManager.GetTemplateNames(TemplateNames);
	foreach TemplateNames(TemplateName)
	{
		ItemManager.FindDataTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
		// Iterate over all variants
		
		foreach TemplateAllDifficulties(Template)
		{
			GrenadeTemplate = X2GrenadeTemplate(Template);
			if (GrenadeTemplate != none)
			{
				if ( (GrenadeTemplate.BaseDamage.Damage > 0  && (GrenadeTemplate.ThrownGrenadeEffects.Length > 0 || GrenadeTemplate.LaunchedGrenadeEffects.Length > 0)))
				{
					GrenadeTemplate.ThrownGrenadeEffects.AddItem(ShockwaveEffect);
					GrenadeTemplate.LaunchedGrenadeEffects.AddItem(ShockwaveEffect);
				}
			}
		}
	}

}


static function X2AbilityTemplate ChainingJolt()
{
	local X2AbilityTemplate                     Template;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2Effect_ApplyWeaponDamage            RobotDamage;
	local X2AbilityCooldown         Cooldown;
	local X2Condition_Visibility                VisCondition;
	local X2Condition_AbilityProperty			ShockTherapyCondition;
	local X2Effect_Persistent					DisorientedEffect;
	local X2Effect_Stunned						StunnedEffect;
	local X2Effect_SetUnitValue					UnitValueEffect;
	local X2Condition_UnitValue					UnitValueCondition;
	local X2Effect_DisableWeapon				DisableEffect;
	local X2Condition_AbilityProperty			AbilityCondition;
	local X2Condition_UnitProperty RobotProperty;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChainingJolt_LW');

	Template.IconImage = "img:///UILibrary_LWOTC.Ability_ChainingJolt";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	//Template.bFeatureInCharacterUnlock = true;

	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_Volt';

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.ChainingJolt_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityMultiTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisCondition);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	
	RobotDamage = new class'X2Effect_ApplyWeaponDamage';
	RobotDamage.bIgnoreBaseDamage = true;
	RobotDamage.DamageTag = 'CombatProtocol_Robotic';
	RobotProperty = new class'X2Condition_UnitProperty';
	RobotProperty.ExcludeOrganic = true;
	RobotDamage.TargetConditions.AddItem(RobotProperty);
	Template.AddTargetEffect(RobotDamage);
	Template.AddMultiTargetEffect(RobotDamage);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('GrimySabotage');
	DisableEffect = new class'X2Effect_DisableWeapon';
	DisableEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(DisableEffect);
	Template.AddMultiTargetEffect(DisableEffect);

	ShockTherapyCondition = new class'X2Condition_AbilityProperty';
	ShockTherapyCondition.OwnerHasSoldierAbilities.AddItem('MZShockTherapy');

	// Stun effect
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.ApplyChance = 50;
	Template.AddTargetEffect(UnitValueEffect);
	Template.AddMultiTargetEffect(UnitValueEffect);

	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 1);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100, false);
	StunnedEffect.bRemoveWhenSourceDies = false;
	StunnedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	StunnedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(StunnedEffect);
	Template.AddMultiTargetEffect(StunnedEffect);

	// Disorient effect
	UnitValueCondition = new class'X2Condition_UnitValue';
	UnitValueCondition.AddCheckValue('MZShockTherapyStunResult', 0);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
	DisorientedEffect.bRemoveWhenSourceDies = false;
	DisorientedEffect.TargetConditions.AddItem(ShockTherapyCondition);
	DisorientedEffect.TargetConditions.AddItem(UnitValueCondition);
	Template.AddTargetEffect(DisorientedEffect);
	Template.AddMultiTargetEffect(DisorientedEffect);
	
	// remove the result value, so other Shock Therapy abilities will roll correctly.
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.NewValueToSet = 0;
	UnitValueEffect.UnitName = 'MZShockTherapyStunResult';
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	Template.AddTargetEffect(UnitValueEffect);

	Template.TargetingMethod = class'X2TargetingMethod_Volt';

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = ChainingJolt_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	//Template.CinescriptCameraType = "Specialist_CombatProtocol";
	Template.AdditionalAbilities.AddItem('ChainingJoltFocus');
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.OverrideAbilities.AddItem('CombatProtocol');

	//Template.ActivationSpeech = 'AbilCombatProtocol';

	return Template;
}

simulated function ChainingJolt_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability  Context;
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameState_Item			GremlinItem;
	local XComGameState_Unit			GremlinUnitState;
	local StateObjectReference          InteractingUnitRef;
	local VisualizationActionMetadata   EmptyTrack;
	local VisualizationActionMetadata   ActionMetadata;
	local X2Action_CameraLookAt			CameraAction;
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local Actor							TargetVisualizer;
	local XComGameState_Unit			AttachedUnitState;
	local XComGameState_Unit			TargetUnitState;
	local array<PathPoint>				Path;
	local TTile                         TargetTile;
	local TTile							StartTile;
	local PathingInputData              PathData;
	local PathingResultData				ResultData;
	local X2Action_CameraLookAt			TargetCameraAction;
	local X2Action_AbilityPerkStart		PerkStartAction;
	local int							i, j;
	local X2VisualizerInterface			TargetVisualizerInterface;
	local X2Action_WaitForAbilityEffect DelayAction;
	local int							EffectIndex;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

	TargetUnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));

	GremlinItem = XComGameState_Item(History.GetGameStateForObjectID(Context.InputContext.ItemObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	GremlinUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.CosmeticUnitRef.ObjectID));
	AttachedUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.AttachedUnitRef.ObjectID));

	if (GremlinUnitState == none)
	{
		`RedScreen("Attempting GremlinSingleTarget_BuildVisualization with a GremlinUnitState of none");
		return;
	}

	//Configure the visualization track for the shooter
	//****************************************************************************************

	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.SourceObject;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	CameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	CameraAction.LookAtActor = ActionMetadata.VisualizeActor;
	CameraAction.BlockUntilActorOnScreen = true;

	class'X2Action_IntrusionProtocolSoldier'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	if (AbilityTemplate.ActivationSpeech != '')
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "", AbilityTemplate.ActivationSpeech, eColor_Good);
	}

	// make sure he waits for the gremlin to come back, so that the cinescript camera doesn't pop until then
	X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded)).SetCustomTimeOutSeconds(30);

	//Configure the visualization track for the gremlin
	//****************************************************************************************

	InteractingUnitRef = GremlinUnitState.GetReference();

	ActionMetadata = EmptyTrack;
	History.GetCurrentAndPreviousGameStatesForObjectID(GremlinUnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
	ActionMetadata.VisualizeActor = GremlinUnitState.GetVisualizer();
	TargetVisualizer = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	if (AttachedUnitState.TileLocation != TargetUnitState.TileLocation)
	{
		// Given the target location, we want to generate the movement data.  

		//Handle tall units.
		TargetTile = TargetUnitState.GetDesiredTileForAttachedCosmeticUnit();
		StartTile = AttachedUnitState.GetDesiredTileForAttachedCosmeticUnit();

		class'X2PathSolver'.static.BuildPath(GremlinUnitState, StartTile, TargetTile, PathData.MovementTiles);
		class'X2PathSolver'.static.GetPathPointsFromPath(GremlinUnitState, PathData.MovementTiles, Path);
		class'XComPath'.static.PerformStringPulling(XGUnitNativeBase(ActionMetadata.VisualizeActor), Path);

		PathData.MovingUnitRef = GremlinUnitState.GetReference();
		PathData.MovementData = Path;
		Context.InputContext.MovementPaths.AddItem(PathData);

		class'X2TacticalVisibilityHelpers'.static.FillPathTileData(PathData.MovingUnitRef.ObjectID, PathData.MovementTiles, ResultData.PathTileData);
		Context.ResultContext.PathResults.AddItem(ResultData);

		class'X2VisualizerHelpers'.static.ParsePath(Context, ActionMetadata);

		if (TargetVisualizer != none)
		{
			TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
			TargetCameraAction.LookAtActor = TargetVisualizer;
			TargetCameraAction.BlockUntilActorOnScreen = true;
			TargetCameraAction.LookAtDuration = 10.0f;		// longer than we need - camera will be removed by tag below
			TargetCameraAction.CameraTag = 'TargetFocusCamera';
			TargetCameraAction.bRemoveTaggedCamera = false;
		}
	}

	PerkStartAction = X2Action_AbilityPerkStart(class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PerkStartAction.NotifyTargetTracks = true;

	class'MZ_Action_ChainJolt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context);

	//****************************************************************************************

	//Configure the visualization track for the target(s)
	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.PrimaryTarget;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = TargetVisualizer;

	DelayAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context));
	DelayAction.ChangeTimeoutLength(class'X2Ability_SpecialistAbilitySet'.default.GREMLIN_ARRIVAL_TIMEOUT);       //  give the gremlin plenty of time to show up

	for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]));
	}

	TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
	if (TargetVisualizerInterface != none)
	{
		//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
		TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	for (i = 0; i < Context.InputContext.MultiTargets.Length; ++i)
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context);
	
		for (j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j)
		{
			Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}
	
		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if (TargetVisualizerInterface != none)
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}

	if (TargetCameraAction != none)
	{
		TargetCameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		TargetCameraAction.CameraTag = 'TargetFocusCamera';
		TargetCameraAction.bRemoveTaggedCamera = true;
	}
}