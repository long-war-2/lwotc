class X2Ability_IRI_Rockets extends X2Ability config (Rockets) dependson(X2Condition_RocketArmedCheck);

var localized string LockAndFireLockonName;
var config int	LockAndFireLockon_Action_Points;
var config array<name> DO_NOT_END_TURN_ABILITIES;

var public X2AbilityCost_RocketActionPoints RocketActionCost;

var config int ROCKETLAUNCHER_COOLDOWN;
// use Launched Effects cannot be used because it leads to grenade bounce trajectory

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// LW2 Gauntlet perk compatiblity
	Templates.AddItem(Create_FireRocketLauncherAbility());
	
	Templates.AddItem(Setup_FireRocketAbility('IRI_FireRocket'));
	Templates.AddItem(Setup_FireRocketAbility('IRI_FireRocket_Spark', true));
	Templates.AddItem(Create_IRI_MobilityPenalty());
	Templates.AddItem(Create_IRI_AggregateAmmo());
	Templates.AddItem(Create_IRI_GiveRocket('IRI_GiveRocket'));
	Templates.AddItem(Create_IRI_ArmRocket('IRI_ArmRocket'));
	Templates.AddItem(Create_IRI_DisarmRocket());

	//	For Plasma Ejector Rocket
	Templates.AddItem(EjectPlasma());
	Templates.AddItem(EjectPlasma('IRI_Fire_PlasmaEjector_Spark', true));

	//	For Lockon Rocket
	Templates.AddItem(Create_IRI_FireLockon());
	Templates.AddItem(Create_IRI_LockAndFireLockon());
	Templates.AddItem(Create_IRI_LockAndFireLockon_Holo());
	Templates.AddItem(Create_IRI_LockonHitBonus());

	Templates.AddItem(Create_IRI_FireLockon('IRI_FireLockon_Spark', true));
	Templates.AddItem(Create_IRI_LockAndFireLockon('IRI_LockAndFireLockon_Spark', true));
	Templates.AddItem(Create_IRI_LockAndFireLockon_Holo('IRI_LockAndFireLockon_Holo_Spark', true));

	//	Dummy passives to let the Rocket Targeting Method give range bonuses when firing rockets through higher tier launchers
	//Templates.AddItem(HiddenPurePassive('IRI_RocketLauncher_MG_Passive',,,, false));
	//Templates.AddItem(HiddenPurePassive('IRI_RocketLauncher_BM_Passive',,,, false));

	//	For Napalm Rocket
	Templates.AddItem(Create_FireTrailAbility());

	//	For Sabot Rocket
	Templates.AddItem(Create_IRI_FireSabot());
	Templates.AddItem(Create_IRI_FireSabot('IRI_FireSabot_Spark', true));
	Templates.AddItem(Create_IRI_SabotHitBonus());	

	//Templates.AddItemHeavyOrdnance());
	//Templates.AddItem(Create_IRI_DisplayRocket());
	//Templates.AddItem(Create_IRI_FireRocket2());
	/*Templates.AddItem(Create_IRI_FireLockon());
	Templates.AddItem(Create_IRI_FireJavelin());*/

	//	For Flechette Rocket
	Templates.AddItem(Create_IRI_FlechetteDamageModifier());

	//	Tactical Nuke
	Templates.AddItem(Create_IRI_FireNukeAbility());
	Templates.AddItem(Create_IRI_ArmRocket('IRI_ArmTacticalNuke', true));
	Templates.AddItem(Create_IRI_GiveRocket('IRI_GiveNuke', true));
	Templates.AddItem(Create_IRI_RocketFuse());

	Templates.AddItem(Create_IRI_FireNukeAbility('IRI_FireTacticalNuke_Spark', true));

	return Templates;
}

//	=======================================
//				COMMON
//	=======================================

static function X2AbilityTemplate HiddenPurePassive(name TemplateName, optional string TemplateIconImage="img:///UILibrary_PerkIcons.UIPerk_standard", optional bool bCrossClassEligible=false, optional Name AbilitySourceName='eAbilitySource_Perk', optional bool bDisplayInUI=true)
{
	local X2AbilityTemplate	Template;
	
	Template = PurePassive(TemplateName, TemplateIconImage, bCrossClassEligible, AbilitySourceName, bDisplayInUI);

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	return Template;
}

static function X2AbilityTemplate Setup_FireRocketAbility(name TemplateName, optional bool bSpark)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityTarget_IRI_Rocket		CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	//local X2Condition_UnitInventory         UnitInventoryCondition;
	local X2Condition_AbilitySourceWeapon   GrenadeCondition;
	local X2Condition_RocketArmedCheck		RocketArmedCheck;
	local X2Effect_IRI_PersistentSquadViewer    ViewerEffect;
	local X2AbilityCooldown_RocketLauncher	Cooldown;

	
	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	//	Ability icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');


	Cooldown = new class'X2AbilityCooldown_RocketLauncher';
	Cooldown.iNumTurns = default.ROCKETLAUNCHER_COOLDOWN;
	Cooldown.SharingCooldownsWith.AddItem('IRI_FireRocketLauncher'); //Now shares the cooldown with Bayonet charge
	Cooldown.SharingCooldownsWith.AddItem('IRI_FireRocket'); //Now shares the cooldown with Bayonet charge
	Template.AbilityCooldown = Cooldown;
	
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY - 1;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	Template.bUseAmmoAsChargesForHUD = true;
	Template.DamagePreviewFn = class'X2Ability_Grenades'.static.GrenadeDamagePreview;
	
	//	Ability costs
	Template.AbilityCosts.AddItem(default.RocketActionCost);

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
		
	//	Targeting and Triggering
	Template.TargetingMethod = class'X2TargetingMethod_IRI_RocketLauncher'; //X2TargetingMethod_Grenade

	CursorTarget = new class'X2AbilityTarget_IRI_Rocket';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	//StandardAim.bGuaranteedHit = true;	//	not necessary wtih indirect hit
	StandardAim.bIndirectFire = true;
	Template.AbilityToHitCalc = StandardAim;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	//RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bUseWeaponBlockingCoverFlag = true;
	RadiusMultiTarget.fTargetRadius = - 24.0f * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//	Shooter conditions
	//	This condition will check whether this rocket can be fired from equipped rocket launcher, if any.
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_RocketTechLevel');

	//	This condition will check if this rocket is armed, if it requires arming at all.
	RocketArmedCheck = new class'X2Condition_RocketArmedCheck';
	RocketArmedCheck.bFailByDefault = true;
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_DoesNotRequireArming);
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_ArmedPerm);
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_ArmedTemp);
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_ArmedPermAndTemp);
	Template.AbilityShooterConditions.AddItem(RocketArmedCheck);	

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//	MULTI TARGET CONDITIONS
	GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	GrenadeCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.FailOnNonUnits = false;
    Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	//	Ability effects
	//	This will apply Rocket's multi target effects automatically.
	Template.bUseThrownGrenadeEffects = true;
	//Template.bUseLaunchedGrenadeEffects = true;	//	doesn't work, not sure why, XCGS_Ability::GetSourceAmmo is native.

	//reveal fog of war around the explosion
	ViewerEffect = new class'X2Effect_IRI_PersistentSquadViewer';
	ViewerEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	ViewerEffect.EffectName = 'IRI_Rocket_Reveal_FoW_Effect';
	Template.AddShooterEffect(ViewerEffect);

	//	This will activate helper ability that will disarm the fired rocket and remove the FoW Reveal effect.
	Template.PostActivationEvents.AddItem('IRI_DisarmRocket_PostEvent');

	Template.bRecordValidTiles = true;	//	Not sure what this does

	//	Visualization
	//Template.bHideAmmoWeaponDuringFire = true; // not sure this is necessary

	Template.ActivationSpeech = 'RocketLauncher';
	if (bSpark)
	{
		Template.CinescriptCameraType = "Iridar_Rocket_Spark";
	}
	else Template.CinescriptCameraType = "Iridar_Rocket";

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.Hostility = eHostility_Offensive;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;
}
//	TOP ATTACK - unlimited range, ignores cover, requires clear sky above target and shooter
static function X2AbilityTemplate Create_IRI_FireLockon(optional name TemplateName = 'IRI_FireLockon', optional bool bSpark)
{
	local X2AbilityTemplate             Template;	
	local X2Condition_Visibility		TargetVisibilityCondition;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Knockback			KnockbackEffect;
	local X2Condition_UnitProperty		UnitProperty;
	local X2AbilityTarget_Single        SingleTarget;
	local X2AbilityToHitCalc_StandardAim    StandardAim;

	Template = Setup_FireRocketAbility(TemplateName);

	Template.bDisplayInUITacticalText = true;
	Template.bUseThrownGrenadeEffects = false;	//	doing this to allow for different localization between the three "fire lockon" abilities

	Template.IconImage = "img:///IRI_RocketLaunchers.UI.Fire_Lockon_Top";

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	if (class'X2Rocket_Lockon'.default.CAN_MISS_WITH_HOLOTARGETING)
	{
		StandardAim = new class'X2AbilityToHitCalc_StandardAim';
		StandardAim.bAllowCrit = false;
		//StandardAim.bOnlyMultiHitWithSuccess = true;
		StandardAim.bIgnoreCoverBonus = true;	//	hits the target from the top, so ignores cover
		Template.AbilityToHitCalc = StandardAim;
	}

	//	both the shooter and the target must have clear sky above their heads
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.HasClearanceToMaxZ = true;
	Template.AbilityTargetConditions.AddItem(UnitProperty);
	Template.AbilityShooterConditions.AddItem(UnitProperty);
	
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bActAsSquadsight = true; //LOS + any squadmate can see the target, regardless of if the unit has Squadsight
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_IRI_HoloTarget');	//	only holotargeted enemies
	 
	//	Multi Target Effects
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 1;
	Template.AddMultiTargetEffect(KnockbackEffect);
	
	//	Primary Target Effects
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;	//	does it matter for dodge? nope, can be dodged with this set to true.
	//WeaponDamageEffect.EffectDamageValue = class'X2Rocket_Lockon'.default.ADDITIONAL_DAMAGE_TO_PRIMARY_TARGET;
	WeaponDamageEffect.DamageTag = 'IRI_Lockon_Direct';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	//Template.ActionFireClass = class'X2Action_FireLockon';

	if (bSpark)
	{
		Template.CinescriptCameraType = "Iridar_Rocket_Lockon_Spark";
	}
	else Template.CinescriptCameraType = "GenericAccentCam";

	Template.BuildVisualizationFn = class'X2Rocket_Lockon'.static.Lockon_BuildVisualization;
	SetFireAnim(Template, 'FF_IRI_FireLockon');

	return Template;	
}


static function X2AbilityTemplate Setup_DirectLockonShot(name TemplateName, optional bool bSpark)
{
	local X2AbilityTemplate             Template;	
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Knockback			KnockbackEffect;
	local X2AbilityTarget_Single        SingleTarget;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_Visibility		TargetVisibilityCondition;

	Template = Setup_FireRocketAbility(TemplateName, bSpark);

	Template.bDisplayInUITacticalText = true;
	Template.bUseThrownGrenadeEffects = false;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;

	if (class'X2Rocket_Lockon'.default.CAN_MISS_WITHOUT_HOLOTARGETING)
	{
		StandardAim = new class'X2AbilityToHitCalc_StandardAim';
		StandardAim.bAllowCrit = false;
		StandardAim.bIgnoreCoverBonus = false;
		Template.AbilityToHitCalc = StandardAim;
	}

	Template.TargetingMethod = class'X2TargetingMethod_TopDown';

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bActAsSquadsight = true; //LOS + any squadmate can see the target, regardless of if the unit has Squadsight
	TargetVisibilityCondition.bRequireNotMatchCoverType = true;	//	enemies in high cover cannot be targeted
	TargetVisibilityCondition.TargetCover = CT_Standing;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.DamageTag = 'IRI_Lockon_Direct';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	//	Multi Target Effects
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 1;
	Template.AddMultiTargetEffect(KnockbackEffect);

	SetFireAnim(Template, 'FF_IRI_LockAndFireLockon');

	return Template;	
}

//	DIRECT SHOT
//	A special version of a Fire Lockon ability that can be fired against robotic enemies within direct line of sight
static function X2AbilityTemplate Create_IRI_LockAndFireLockon(optional name TemplateName = 'IRI_LockAndFireLockon', optional bool bSpark)
{
	local X2AbilityTemplate             Template;
	local X2Condition_UnitProperty		UnitProperty;
	local X2AbilityCost_ActionPoints	ActionPoints;
	local X2AbilityCost_Ammo            AmmoCost;

	Template = Setup_DirectLockonShot(TemplateName, bSpark);

	Template.IconImage = "img:///IRI_RocketLaunchers.UI.Fire_Lockon_Horiz_Holo";

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);	//	only enemies in Line of Sight
	
	//	Ability costs
	Template.AbilityCosts.Length = 0;

	ActionPoints = new class'X2AbilityCost_ActionPoints';
	ActionPoints.bConsumeAllPoints = true;
	ActionPoints.DoNotConsumeAllSoldierAbilities = default.DO_NOT_END_TURN_ABILITIES;
	ActionPoints.iNumPoints = default.LockAndFireLockon_Action_Points;
	Template.AbilityCosts.AddItem(ActionPoints);

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	//	allow only robotic enemies
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeRobotic = false;
	UnitProperty.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitProperty);

	return Template;	
}

static function X2AbilityTemplate Create_IRI_LockAndFireLockon_Holo(optional name TemplateName = 'IRI_LockAndFireLockon_Holo', optional bool bSpark)
{
	local X2AbilityTemplate             Template;

	Template = Setup_DirectLockonShot(TemplateName, bSpark);

	Template.IconImage = "img:///IRI_RocketLaunchers.UI.Fire_Lockon_Horiz";

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_IRI_HoloTarget');	//	only holotargeted enemies

	return Template;	
}

static function X2AbilityTemplate Create_IRI_LockonHitBonus()
{
	local X2AbilityTemplate			Template;
	local X2Effect_SabotHitBonus	SabotHitBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_LockonHitBonus');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bUniqueSource = true;
	
	SabotHitBonus = new class'X2Effect_SabotHitBonus';
	SabotHitBonus.BuildPersistentEffect(1, true);
	SabotHitBonus.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	SabotHitBonus.ValidAbilities.AddItem('IRI_FireLockon');
	SabotHitBonus.ValidAbilities.AddItem('IRI_LockAndFireLockon');
	SabotHitBonus.ValidAbilities.AddItem('IRI_LockAndFireLockon_Holo');
	SabotHitBonus.ScalingAimBonus = class'X2Rocket_Lockon'.default.SIZE_SCALING_AIM_BONUS;
	SabotHitBonus.ScalingCritBonus = class'X2Rocket_Lockon'.default.SIZE_SCALING_CRIT_BONUS;
	SabotHitBonus.InverseCritScaling = class'X2Rocket_Lockon'.default.SIZE_SCALING_CRIT_BONUS_IS_INVERTED;
	SabotHitBonus.EffectName = 'IRI_LockonHitBonus_Effect';
	Template.AddTargetEffect(SabotHitBonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate EjectPlasma(optional name TemplateName = 'IRI_Fire_PlasmaEjector', optional bool bSpark)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2Condition_RocketArmedCheck		RocketArmedCheck;
	//local X2AbilityMultiTarget_Line         LineMultiTarget;

	Template = class'X2Ability_HeavyWeapons'.static.PlasmaBlaster(TemplateName);

	//Template.IconImage = "img:///IRI_RocketLaunchers.UI.Fire_Plasma_Ejector";//doesn't work for some reason

	Template.AbilityShooterConditions.AddItem(new class'X2Condition_RocketTechLevel');
	
	RocketArmedCheck = new class'X2Condition_RocketArmedCheck';
	RocketArmedCheck.bFailByDefault = true;
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_DoesNotRequireArming);
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_ArmedPerm);
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_ArmedTemp);
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_ArmedPermAndTemp);
	Template.AbilityShooterConditions.AddItem(RocketArmedCheck);	

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bIndirectFire = true;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;

	//	Ability Costs
	Template.AbilityCosts.Length = 0;
	Template.AbilityCosts.AddItem(default.RocketActionCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	//Template.TargetingMethod = class'X2TargetingMethod_PlasmaEjector';

	/*
	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	LineMultiTarget.TileWidthExtension = 1;
	Template.AbilityMultiTargetStyle = LineMultiTarget;*/

	//X2AbilityToHitCalc_StandardAim(Template.AbilityToHitCalc).bGuaranteedHit = class'X2Rocket_Plasma_Ejector'.default.PLASMA_EJECTOR_ALWAYS_HITS;
	
	Template.bUseThrownGrenadeEffects = true;
	Template.bRecordValidTiles = true;

	Template.AddShooterEffect(new class'X2Effect_DisarmRocket');

	Template.bUseAmmoAsChargesForHUD = true;
	Template.DamagePreviewFn = class'X2Ability_Grenades'.static.GrenadeDamagePreview;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_plasmablaster";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY - 1;

	if (bSpark) Template.CinescriptCameraType = "Iridar_Plasma_Ejector_Spark";
	else Template.CinescriptCameraType = "Iridar_Plasma_Ejector";

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;	
}

static function X2AbilityTemplate Create_IRI_FireSabot(optional name TemplateName = 'IRI_FireSabot', optional bool bSpark)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2Condition_Visibility			TargetVisibilityCondition;
	local X2AbilityTarget_Single			SingleTarget;
	local X2AbilityToHitCalc_RocketLauncher	StandardAim;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Effect_Knockback				KnockbackEffect;
	//local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Effect_Persistent				BleedingEffect;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	//local X2Effect_RemoteStart			RemoteStartEffect;
	local X2Condition_RocketArmedCheck		RocketArmedCheck;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	// Icon Properties
	Template.IconImage = "img:///IRI_RocketLaunchers.UI.Fire_Sabot2";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY - 1;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = true;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	Template.bUseAmmoAsChargesForHUD = true;
	Template.DisplayTargetHitChance = true;

	//	Targeting and Triggering
	Template.TargetingMethod = class'X2TargetingMethod_TopDown';
	//Template.TargetingMethod = class'X2TargetingMethod_PierceBehindTarget';

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	SingleTarget.bAllowDestructibleObjects = true;
	//SingleTarget.bAllowInteractiveObjects = true;
	Template.AbilityTargetStyle = SingleTarget;
	
	/*LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	LineMultiTarget.bSightRangeLimited = false;
	Template.AbilityMultiTargetStyle = LineMultiTarget;*/
	
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.fTargetRadius = 0.5f;	//	half a meter radius
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	StandardAim = new class'X2AbilityToHitCalc_RocketLauncher';
    StandardAim.bAllowCrit = true;
	StandardAim.bHitsAreCrits = false;
	StandardAim.bIgnoreCoverBonus = true;
    Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	//Template.bFriendlyFireWarning = false;

	// Target conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	//TargetVisibilityCondition.bActAsSquadsight = true; //LOS + any squadmate can see the target, regardless of if the unit has Squadsight
	TargetVisibilityCondition.bRequireGameplayVisible = true; //LOS + in range + meets situational conditions in interface method UpdateGameplayVisibility
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

		//	per MrNice's recommendation, adding a multi target condition so that multi target part of the ability is strictly anti-environment
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.FailOnNonUnits = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeAlive = true;
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);
	//Template.AbilityMultiTargetConditions.AddItem(new class'X2Condition_Pierce');
	

	// Shooter conditions
	Template.AddShooterEffectExclusions();
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_RocketTechLevel');
	
	RocketArmedCheck = new class'X2Condition_RocketArmedCheck';
	RocketArmedCheck.bFailByDefault = true;
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_DoesNotRequireArming);
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_ArmedPerm);
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_ArmedTemp);
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_ArmedPermAndTemp);
	Template.AbilityShooterConditions.AddItem(RocketArmedCheck);	

	//	Single Target Effects
	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bAllowFreeKill = false;
	Template.AddTargetEffect(WeaponDamageEffect);

	BleedingEffect = class'X2StatusEffects'.static.CreateBleedingStatusEffect(class'X2Rocket_Sabot'.default.BLEED_DURATION_TURNS, class'X2Rocket_Sabot'.default.BLEED_DAMAGE);
	BleedingEffect.bEffectForcesBleedout = false;
	Template.AddTargetEffect(BleedingEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 3;
	Template.AddTargetEffect(KnockbackEffect);

	Template.AddShooterEffect(new class'X2Effect_DisarmRocket');
	
	//	Multi Target Effects
	//	Environmental damage is applied only if the projectile misses
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EnvironmentalDamageAmount = class'X2Rocket_Sabot'.default.IENVIRONMENTDAMAGE;
	WeaponDamageEffect.bApplyOnMiss = true;
	WeaponDamageEffect.bApplyOnHit = false;
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	/*
	RemoteStartEffect = new class'X2Effect_RemoteStart';
	RemoteStartEffect.UnitDamageMultiplier = 1;
	RemoteStartEffect.DamageRadiusMultiplier = 1;
	Template.AddMultiTargetEffect(RemoteStartEffect);*/

	//Template.AddMultiTargetEffect(new class'X2Effect_ApplyFireToWorld');

	// Ability Costs
	Template.AbilityCosts.AddItem(default.RocketActionCost);

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	//	Visualization	
	if (bSpark) 
	{
		Template.CinescriptCameraType = "Iridar_Rocket_Sabot_Spark";
		Template.BuildVisualizationFn = class'X2Rocket_Sabot'.static.FireSabot_BuildVisualization_Spark;	
	}
	else 
	{
		Template.CinescriptCameraType = "Iridar_Rocket_Sabot";
		Template.BuildVisualizationFn = class'X2Rocket_Sabot'.static.FireSabot_BuildVisualization;	
	}
	Template.ActivationSpeech = 'BulletShred';
	//Template.ActivationSpeech = 'RocketLauncher';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.bFrameEvenWhenUnitIsHidden = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	//Template.DamagePreviewFn = Sabot_DamagePreview;

	return Template;	
}

static function bool Sabot_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	if (AbilityState != none )
	{
		AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	}
	return true;
}

static function X2AbilityTemplate Create_IRI_SabotHitBonus()
{
	local X2AbilityTemplate			Template;
	local X2Effect_SabotHitBonus	SabotHitBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_SabotHitBonus');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bUniqueSource = true;
	
	SabotHitBonus = new class'X2Effect_SabotHitBonus';
	SabotHitBonus.BuildPersistentEffect(1, true);
	SabotHitBonus.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	SabotHitBonus.ValidAbilities.AddItem('IRI_FireSabot');
	SabotHitBonus.ValidAbilities.AddItem('IRI_FireSabot_Spark');
	SabotHitBonus.ScalingAimBonus = class'X2Rocket_Sabot'.default.SIZE_SCALING_AIM_BONUS;
	SabotHitBonus.ScalingCritBonus = class'X2Rocket_Sabot'.default.SIZE_SCALING_CRIT_BONUS;
	SabotHitBonus.InverseCritScaling = class'X2Rocket_Sabot'.default.SIZE_SCALING_CRIT_BONUS_IS_INVERTED;
	SabotHitBonus.EffectName = 'IRI_Sabot_HitBonus_Effect';
	Template.AddTargetEffect(SabotHitBonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate Create_IRI_FlechetteDamageModifier()
{
	local X2AbilityTemplate						Template;
	local X2Effect_AlloySpikesDamageModifier	SabotHitBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_FlechetteDamageModifier');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bUniqueSource = true;
	
	SabotHitBonus = new class'X2Effect_AlloySpikesDamageModifier';
	SabotHitBonus.BuildPersistentEffect(1, true);
	SabotHitBonus.EffectName = 'IRI_lechetteDamageModifier_Effect';
	Template.AddTargetEffect(SabotHitBonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


static function X2AbilityTemplate Create_IRI_MobilityPenalty()
{
	local X2AbilityTemplate						Template;	
	local X2Effect_IRI_RocketMobilityPenalty	MobilityDamageEffect;
	local X2AbilityTrigger_EventListener		Trigger;
	local X2Condition_UnitProperty				TargetProperty;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_RocketMobilityPenalty');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reloadrocket";

	//	don't apply penalty to heavy and SPARK armor, if configured so.
	Template.AbilityShooterConditions.AddItem(new class'X2Condition_HeavyArmor');

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeCosmetic=true;
	TargetProperty.ExcludeInStasis=false;
	TargetProperty.FailOnNonUnits=true; 
	TargetProperty.ExcludeAlive=false;
	TargetProperty.ExcludeDead=true;
	TargetProperty.ExcludeFriendlyToSource=false;
	TargetProperty.ExcludeHostileToSource=true;
	Template.AbilityShooterConditions.AddItem(TargetProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'PlayerTurnBegun';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	MobilityDamageEffect = new class 'X2Effect_IRI_RocketMobilityPenalty';
	MobilityDamageEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	MobilityDamageEffect.SetDisplayInfo(ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	MobilityDamageEffect.DuplicateResponse = eDupe_Ignore;
	MobilityDamageEffect.EffectName = 'IRI_RocketMobilityPenalty_Effect';
	Template.AddShooterEffect(MobilityDamageEffect);

	Template.bDisplayInUITooltip = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITacticalText = false;
	Template.bSilentAbility = true;

	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bUniqueSource = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;	
}

static function X2AbilityTemplate Create_IRI_AggregateAmmo()
{
	local X2AbilityTemplate         Template;

	Template = PurePassive('IRI_AggregateRocketAmmo', "img:///UILibrary_PerkIcons.UIPerk_aceinthehole",,, false);
	
	Template.AddShooterEffect(new class'X2Effect_AggregateAmmo');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	return Template;
}

static function X2AbilityTemplate Create_IRI_ArmRocket(name TemplateName, optional bool bNuke = false)
{
	local X2AbilityTemplate				Template;	
	local X2AbilityCost_Ammo            AmmoCost;
	local X2AbilityCost_ActionPoints	ActionPoints;
	local X2Condition_RocketArmedCheck	RocketArmedCheck;
	local X2Effect_ArmedNuke			ArmedNukeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.IconImage = "img:///IRI_RocketLaunchers.UI.Arm_Rocket";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');

	//	Ability costs
	//	A rocket can't be armed if there's no ammo remaining.
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bUseAmmoAsChargesForHUD = true;

	ActionPoints = new class'X2AbilityCost_ActionPoints';
	ActionPoints.bConsumeAllPoints = false;
	//ActionPoints.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
	//ActionPoints.DoNotConsumeAllSoldierAbilities.AddItem('TotalCombat');
	ActionPoints.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPoints);
	
	//	Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//	This condition will make this ability hidden and unavailable if the source rocket is already armed, or if it doesn't require arming.
	RocketArmedCheck = new class'X2Condition_RocketArmedCheck';
	RocketArmedCheck.bFailByDefault = true;
	RocketArmedCheck.RequiredStatus.AddItem(eRocketArmed_NotArmed);
	Template.AbilityShooterConditions.AddItem(RocketArmedCheck);	

	RocketArmedCheck = new class'X2Condition_RocketArmedCheck';
	RocketArmedCheck.bFailByDefault = true;
	RocketArmedCheck.bCheckForArmedNukes = true;	//	can't Arm any new rockets if the soldier already has a Nuke armed.
	Template.AbilityShooterConditions.AddItem(RocketArmedCheck);	

	//	Effects
	//	Disarm any rocket that's already armed, and arm this one instead.
	Template.AddShooterEffect(new class'X2Effect_ArmRocket');

	//	When Arming a Nuke, apply a persistent effect that will track how long a Tactical Nuke has been armed for.
	if (bNuke)
	{
		ArmedNukeEffect = new class'X2Effect_ArmedNuke';
		ArmedNukeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), "img:///UILibrary_XPACK_Common.UIPerk_warlock_kamikaze", true, , Template.AbilitySourceName);
		ArmedNukeEffect.iNumTurns = class'X2Rocket_Nuke'.default.SELF_DETONATION_TIMER_TURNS;
		Template.AddShooterEffect(ArmedNukeEffect);
	}

	//	Targeting and triggering
	Template.AbilityToHitCalc = default.DeadEye;
	Template.DisplayTargetHitChance = false;

	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bDisplayInUITooltip = false;	
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;
	Template.bDisplayInUITacticalText = false;
	Template.bSilentAbility = true;

	Template.bShowActivation = false;	//	flyover is added in X2Effect_ArmRocket
	Template.bSkipFireAction = false;

	Template.CustomFireAnim = 'HL_ArmRocket';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.AlternateFriendlyNameFn = ArmRocket_AlternateFriendlyName;

	return Template;	
}

//	This is used to give a unique name for "Give Rocket" ability for different rocket types without having to actually use different abilities
static function bool ArmRocket_AlternateFriendlyName(out string AlternateDescription, XComGameState_Ability AbilityState, StateObjectReference TargetRef)
{
	//	super long scary line, but the gist of it is that we're grabbing the rocket template of the weapon this instance of Arm Rocket ability is attached to, and access its localized string
	AlternateDescription = X2RocketTemplate(XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID)).GetMyTemplate()).ArmRocketAbilityName;

	//	I could probably check if X2RocketTemplate == null here, and return "false" in that case, but honestly I don't see reason to bother since Arm Rocket ability will never be attached to non-rockets.
	return true;
}


static function X2AbilityTemplate Create_IRI_FireNukeAbility(optional name TemplateName = 'IRI_FireTacticalNuke', optional bool bSpark)
{
	local X2AbilityTemplate					Template;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	
	Template = Setup_FireRocketAbility(TemplateName, bSpark);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bIgnoreBlockingCover = true;	//	Allow Nuke's damage to go through cover
	RadiusMultiTarget.fTargetRadius = - 24.0f * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_IRI_Nuke';
	Template.DamagePreviewFn = FireNuke_DamagePreview;

	Template.BuildVisualizationFn = class'X2Rocket_Nuke'.static.FireTacticalNuke_BuildVisualization;

	return Template;
}

static function bool FireNuke_DamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	if (class'X2Rocket_Nuke'.default.EXTRA_DAMAGE[0].Tag == 'IRI_Nuke_Primary' && class'X2Rocket_Nuke'.default.EXTRA_DAMAGE[1].Tag == 'IRI_Nuke_Secondary')
	{
		MaxDamagePreview = class'X2Rocket_Nuke'.default.EXTRA_DAMAGE[0];
		SumWeaponDamageValues(MaxDamagePreview, class'X2Rocket_Nuke'.default.BASEDAMAGE);

		MinDamagePreview = class'X2Rocket_Nuke'.default.EXTRA_DAMAGE[1];
		SumWeaponDamageValues(MinDamagePreview, class'X2Rocket_Nuke'.default.BASEDAMAGE);
	}
	else if (AbilityState != none)
	{
		AbilityState.NormalDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	}

	return true;
}

static private function SumWeaponDamageValues(out WeaponDamageValue ValueA, const WeaponDamageValue ValueB)
{
	ValueA.Damage += ValueB.Damage;
	ValueA.Spread += ValueB.Spread;
	if (ValueB.PlusOne > 0) ValueA.Spread++;
	ValueA.Crit += ValueB.Crit;
	ValueA.Rupture += ValueB.Rupture;
	ValueA.Shred += ValueB.Shred;
	ValueA.Pierce = Min(ValueA.Pierce, ValueB.Pierce);
}

//	Automatically detonate Nuke several turns after it's armed
static function X2AbilityTemplate Create_IRI_RocketFuse()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityTrigger_EventListener	TurnEndTrigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_RocketFuse');
	
	//	Targeting and Triggering
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bIndirectFire = true;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;	
	
	Template.AbilityTargetStyle = default.SelfTarget;

	TurnEndTrigger = new class'X2AbilityTrigger_EventListener';
	TurnEndTrigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	TurnEndTrigger.ListenerData.EventID = 'PlayerTurnEnded';
	TurnEndTrigger.ListenerData.Filter = eFilter_Player;
	TurnEndTrigger.ListenerData.EventFn = class'X2Rocket_Nuke'.static.Nuke_SelfDetonation_Listener;
	Template.AbilityTriggers.AddItem(TurnEndTrigger);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bAddPrimaryTargetAsMultiTarget = true;
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bIgnoreBlockingCover = true;	//	Allow Nuke's damage to go through cover
	RadiusMultiTarget.fTargetRadius = - 24.0f * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//	Ability Effects
	Template.bUseThrownGrenadeEffects = true;
	Template.bRecordValidTiles = true;

	//	Disarm the Nuke upon detonation so that only one of them explodes
	Template.AddShooterEffect(new class'X2Effect_DisarmRocket');

	//	Shooter Conditions and Costs
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	//	Other condition checks are performed in the Trigger Event Listener.

	//	Multi Target Conditions
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; //The grenade can affect interactive objects, others
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	//	Icon
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fuse";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	SetHidden(Template);

	//	Visualization
	Template.bShowActivation = true;
	Template.ActivationSpeech = 'Inspire';
	SetFireAnim(Template, 'HL_SelfDetonateNuke');
	Template.bHideWeaponDuringFire = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Rocket_Nuke'.static.Nuke_SelfDetonation_BuildVisualization; 

	Template.Hostility = eHostility_Offensive;
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;	
}


/*
function Nuke_SelfDetonation_MergeViz(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local X2Action							Action;
	local X2Action_PlayAnimation			PlayAnimation;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyOver;

	VisMgr = `XCOMVISUALIZATIONMGR;

	Action = VisMgr.GetNodeOfType(BuildTree, class'X2Action_Fire');
	AbilityContext = XComGameStateContext_Ability(Action.StateChangeContext);
	ActionMetaData = Action.Metadata;

	//	Insert a PlayAnimation action right before the Fire Action
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, true, Action.ParentActions[0]));
	PlayAnimation.Params.AnimName = 'HL_SelfDetonateNuke';
	PlayAnimation.Params.BlendTime = 1.0f;

	Action = VisMgr.GetNodeOfType(BuildTree, class'X2Action_ExitCover');

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, AbilityContext,  false, Action));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'X2Rocket_Nuke'.default.str_NukeDetonation,  'Inspire',  eColor_Bad, "img:///UILibrary_PerkIcons.UIPerk_fuse"); //'ShredStormCannon'

	//	Build Tree is what we get from the ability's BuildVisualization.
	//	VisualizationTree is what this function outputs as a new Visualization Tree.
	VisualizationTree = BuildTree;
}*/

/*
GIVE ROCKET INTERACTIONS WITH ARM ROCKET
Example situations: 
1) 
rocketeer doesn't have any armed rockets.
he receives an armed rocket from another soldier, storing in primary unit value
he tries to arm a rocket himself
he will overwrite the already armed rocket, as he should.

2)
rocketeer holds a rocket that was armed on a previous turn, secondary unit value is gone already.
he receives an armed rocket from another soldier, storing in secondary unit value. he can fire both rockets this turn, if he wants.

if he fires the rocket that was armed on the previous turn, X2Effect_DisarmRocket will move the Unit Value from secondary to primary, 
so the rocket received from another soldier will remain armed permanently.

if he fires the rocket he just received from another soldier, the rocket he already had will remain armed permanently.

3) 
rocketeer armed a rocket this turn, so he already has a secondary unit value.
then he receives another armed rocket from another soldier.
secondary unit value that he already had will be overwritten by X2Effect_GiveRocket, and until the end of turn he will have two armed rockets, same as the previous situation.

4) a soldier arms a rocket and gives it to another soldier. that another soldier uses 1 action to move to the rocketeer, and the second action to give the armed rocket to the rocketeer.
the rocketeer can fire the armed rocket right away.

5) a rocketeer has no rockets.
three different soldiers each arm a rocket and give them to the rocketeer in that order: A, B and C.
Rocket A will be armed permanently.
Rocket B will be armed until the end of turn.
Rocket C will disarm rocket B and will remain armed until the end of turn.

6) The Rocketeer holds a Rocket that was Armed this turn. It will remain Armed if Given away this turn.
Now another soldier Arms a rocket and gives it to the Rocketeer. 
If Rocketeer will Give the rocket that he Armed this turn himself, it will not remain Armed. 
If Rocketeer will Give the rocket that he was Given to him in the Armed state, it will remain Armed.

6) Soldiers cannot Arm any additional rockets while holding an Armed Nuke.
If another soldier Gives them another Armed rocket (not a Nuke), it will remain Armed until the end of turn.
If a soldier holds any Armed rockets, all of them will be disarmed if an Armed Nuke is Given to them.
A soldier can Give a Nuke that was Armed on a previous turn, and it will remain Armed.
*/
static function X2AbilityTemplate Create_IRI_GiveRocket(name TemplateName, optional bool bNuke = false)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Condition_UnitProperty		TargetProperty;
	local X2AbilityCost_Ammo            AmmoCost;
	local X2Effect_IRI_GiveRocket 		ItemEffect;
	local X2Condition_NumberOfRockets	NumberOfRocketsCondition;
	local X2Effect_ArmedNuke			ArmedNukeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	// Boilerplate setup
	Template.IconImage = "img:///IRI_RocketLaunchers.UI.give_rocket";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY - 2;
	Template.Hostility = eHostility_Neutral;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bUseAmmoAsChargesForHUD = true;

	//	When Giving an Armed Nuke, apply a persistent effect that will track how long the Nuke has been Armed for. 
	//	Its duration will be adjusted to be the same as the same effect on the soldier that's giving the Rocket.
	if (bNuke)
	{
		ArmedNukeEffect = new class'X2Effect_ArmedNuke';
		ArmedNukeEffect.bGiveRocket = true;
		ArmedNukeEffect.VisualizationFn = none;
		ArmedNukeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
		Template.AddTargetEffect(ArmedNukeEffect);
	}	

	ItemEffect = new class'X2Effect_IRI_GiveRocket'; // Effect that gives the rocket to another soldier
	ItemEffect.EffectName = 'GiveRocketEffect';
	ItemEffect.AnimationToPlay = 'HL_TakeRocket';
	ItemEffect.BuildPersistentEffect(1, true, false);
	ItemEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(ItemEffect);

	//	Disarm the given rocket
	Template.PostActivationEvents.AddItem('IRI_DisarmRocket_PostEvent');

	// Does not end turn. Costs one action
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Can't use it when you're dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	// Targets organic allies only
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.TreatMindControlledSquadmateAsHostile = true;
	TargetProperty.RequireSquadmates = true;
	//TargetProperty.ExcludeRobotic = true;	//	Removing to allow giving rockets to SPARKs and stuff
	TargetProperty.ExcludeAlien = true;
	TargetProperty.FailOnNonUnits = true;
	TargetProperty.IsImpaired = false;
	TargetProperty.RequireWithinRange = true;
	TargetProperty.WithinRange = 144; //1.5 tiles in Unreal units, allows attacks on the diag
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	NumberOfRocketsCondition = new class'X2Condition_NumberOfRockets';
	NumberOfRocketsCondition.MaxRockets = 2;
	Template.AbilityTargetConditions.AddItem(NumberOfRocketsCondition);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = GiveRocket_BuildVisualization;	
	Template.bSilentAbility = true;
	Template.CustomFireAnim = 'HL_GiveRocket';

	Template.AlternateFriendlyNameFn = GiveRocket_AlternateFriendlyName;
	Template.bDisplayInUITacticalText = false;

	return Template;
}

//	This is used to give a unique name for "Give Rocket" ability for different rocket types without having to actually use different abilities
static function bool GiveRocket_AlternateFriendlyName(out string AlternateDescription, XComGameState_Ability AbilityState, StateObjectReference TargetRef)
{
	local XComGameState_Unit	UnitState;
	local EArmedRocketStatus	RocketStatus;
	local X2RocketTemplate		RocketTemplate;

	//	Grab the Unit State of the soldier that's trying to Give Rocket
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	if (UnitState != none && AbilityState.SourceWeapon.ObjectID != 0)
	{	
		//	Grab the Template for the Rocket the soldier is trying to give.
		RocketTemplate = X2RocketTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());

		//	Check whether the rocket we're giving requires Arming and was Armed this turn.
		RocketStatus = class'X2Condition_RocketArmedCheck'.static.GetRocketArmedStatus(UnitState, AbilityState.SourceWeapon.ObjectID);

		if (RocketStatus > eRocketArmed_ArmedPerm)
		{
			AlternateDescription = RocketTemplate.GiveArmedRocketAbilityName;
		}
		else
		{
			AlternateDescription = RocketTemplate.GiveRocketAbilityName;
		}
		//	Return true to let the game know it should use the alternate localized name.
		return true;
	}
	//	Something went wrong, this Give Rocket ability is not attached to a unit nor a weapon, keep the default localization.
	return false;
}

simulated function GiveRocket_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference          InteractingUnitRef;
	local VisualizationActionMetadata   EmptyTrack;
	local VisualizationActionMetadata   ActionMetadata;
	local X2Action_PlayAnimation		PlayAnimation;
	local X2Action_MoveTurn				MoveTurnAction;
	local X2Action_TimedWait			TimedWait;
	local XComGameStateVisualizationMgr VisMgr;
	local XComGameState_Unit			SourceUnit;
	local X2Action						FoundAction;

	//	Run the Typical Build Viz first. It should set up the Exit Cover -> Fire -> Enter Cover actions for the shooter.
	TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	SourceUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));

	//	Find the Fire Action created by Typical Build Viz.
	//	Fire Action in this context is just used to play the Give Rocket animation.
	FoundAction = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire');

	if (FoundAction != none && SourceUnit != none)
	{
		InteractingUnitRef = Context.InputContext.SourceObject;
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = SourceUnit;
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		//	Attach a Timed Wait Action to the beginning of the visualization tree. It will be used to synchronize the Give Rocket animation in the Fire Action and Take Rocket animation on the target.
		//  This timer will start ticking the moment the visualization for the shooter begins (visually, at the same time as the Exit Cover action).
		TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, Context, false, FoundAction.TreeRoot));
		TimedWait.DelayTimeSec = 2.25f;

		//	Make the Timed Wait Action a parent of the Fire Action. This means there will be AT LEAST 1 second delay between the start of the ability visualization and the Fire Action,
		//	even if the Exit Cover action completes nearly instantly, which happens when there's no cover to exit from, and the "Shooter" is already facing the Target.
		VisMgr.ConnectAction(FoundAction, VisMgr.BuildVisTree,, TimedWait);

		//Configure the visualization track for the target
		//****************************************************************************************

		InteractingUnitRef = Context.InputContext.PrimaryTarget;
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		//	The soldier will not actually exit cover, but this is necessary for Move Turn action to work properly. Note that we parent this action to Vis Tree Root, 
		//	so it will start the moment ability visualization starts, practically at the same time as Exit Cover for the Shooter.
		class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, FoundAction.TreeRoot);

		//	make the target face the location of the Souce Unit
		MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		MoveTurnAction.m_vFacePoint =  `XWORLD.GetPositionFromTileCoordinates(SourceUnit.TileLocation);
		MoveTurnAction.UpdateAimTarget = true;

		PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		PlayAnimation.Params.AnimName = 'HL_TakeRocket';
		PlayAnimation.Params.BlendTime = 0.3f;

		class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

		//	hold the camera on the target soldier for a bit
		TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		TimedWait.DelayTimeSec = 0.5f;

		//	Important! this is where the syncing magic happens. This sets the Timed Wait action as an additional parent to the Play Animation action. 
		//  So both Play Animation on the Target and Fire Animation on the shooter will be child actions for Timed Wait. As long as Exit Cover for the Shooter, and Exit Cover and Move Turn for the Target
		//	take less than 1.5 seconds, the Play Animation and Fire Action should start at exactly the same time, syncing 
		VisMgr.ConnectAction(PlayAnimation, VisMgr.BuildVisTree,, FoundAction);
	}
}

//	Helper ability. Activates after Fire Rocket and Give Rocket to Disarm it on the soldier that Gave / Fired the Rocket. 
//	This specific implementation is only necessary for the Nuke, that uses a separate Persistent Effect to track for how long the Nuke's been Armed.
//	Regular Rocket *could* be Disarmed automatically by Give Rocket Effect itself.
//	Secondary effect of this ability is removing the FoW Reveal Effect that is activated whenever you fire a rocket.
static function X2AbilityTemplate Create_IRI_DisarmRocket()
{
	local X2AbilityTemplate					Template;	
	local X2AbilityTrigger_EventListener	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_DisarmRocket');

	Template.IconImage = "img:///IRI_RocketLaunchers.UI.Arm_Rocket";
	Template.Hostility = eHostility_Neutral;
	SetHidden(Template);

	//	Targeting and triggering
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'IRI_DisarmRocket_PostEvent';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	//	Effects
	//	Disarm Nuke
	Template.AddShooterEffect(new class'X2Effect_DisarmRocket');	
	Template.bSilentAbility = true;

	//	Delay ability activation so that FoW Reveal is removed after the rocket shot goes through.
	//Template.AssociatedPlayTiming = SPT_AfterParallel;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	//Template.MergeVisualizationFn = DisarmRocket_MergeViz;

	return Template;	
}
/*
function DisarmRocket_MergeViz(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local X2Action							Action;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;

	VisMgr = `XCOMVISUALIZATIONMGR;

	Action = VisMgr.GetNodeOfType(BuildTree, class'X2Action_EnterCover');
	AbilityContext = XComGameStateContext_Ability(Action.StateChangeContext);
	ActionMetaData = Action.Metadata;


	//	Build Tree is what we get from the ability's BuildVisualization.
	//	VisualizationTree is what this function outputs as a new Visualization Tree.
	VisualizationTree = BuildTree;
}*/
/*
static function FindLastActionRecursive(const X2Action StartAction, out X2Action EndAction)
{
	local X2Action ChildAction;

	//`LOG("Action layer: " @ iLayer @ ": " @ Action.Class.Name,, 'IRIPISTOLVIZ'); 
	foreach Action.ChildActions(ChildAction)
	{
		PrintActionRecursive(ChildAction, iLayer + 1);
	}
}
*/
static function X2AbilityTemplate Create_FireTrailAbility()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Condition_UnitEffects			EffectCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_Napalm_FireTrail');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_flamethrower";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;
	Template.Hostility = eHostility_Neutral;
	
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddRequireEffect('IRI_Effect_Wildfire', 'AA_MissingRequiredEffect');
	Template.AbilityShooterConditions.AddItem(EffectCondition);
	/*
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddRequireEffect(class'X2StatusEffects'.default.BurningName, 'AA_MissingRequiredEffect');
	Template.AbilityShooterConditions.AddItem(EffectCondition);*/

	//This ability fires as part of game states where the Andromedon robot moves
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'ObjectMoved';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventListener);

	// Targets the Andromedon unit so it can be replaced by the andromedon robot;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius =  1;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AddShooterEffect(new class'X2Effect_FireTrail');

	//Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.bSilentAbility = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.ConcealmentRule = eConceal_Always;
	Template.SuperConcealmentLoss = 0;

	return Template;
}

//	=======================================
//		For using the RL instead of LW2 Gauntlet
//	=======================================
static function X2AbilityTemplate Create_FireRocketLauncherAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_IRI_HasOneAbilityFromList	HasAbilityCondition;
	//local X2Condition_UnitEffects			SuppressedCondition;
	local X2AbilityCooldown_RocketLauncher	Cooldown;

	Template = class'X2Ability_HeavyWeapons'.static.RocketLauncherAbility('IRI_FireRocketLauncher');


	Cooldown = new class'X2AbilityCooldown_RocketLauncher';
	Cooldown.iNumTurns = default.ROCKETLAUNCHER_COOLDOWN;
	Cooldown.SharingCooldownsWith.AddItem('IRI_FireRocketLauncher'); //Now shares the cooldown with Bayonet charge
	Cooldown.SharingCooldownsWith.AddItem('IRI_FireRocket'); //Now shares the cooldown with Bayonet charge
	Template.AbilityCooldown = Cooldown;

	//	Ability icon
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.HideErrors.AddItem('AA_AbilityUnavailable');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY - 1;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	//Template.DamagePreviewFn = class'X2Ability_Grenades'.static.GrenadeDamagePreview;

	//	Targeting and Triggering
	Template.TargetingMethod = class'X2TargetingMethod_IRI_RocketLauncher';

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	//StandardAim.bGuaranteedHit = true;	//	not necessary wtih indirect hit
	StandardAim.bIndirectFire = true;
	Template.AbilityToHitCalc = StandardAim;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bUseWeaponBlockingCoverFlag = true;
	RadiusMultiTarget.fTargetRadius = - 24.0f * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//	Shooter conditions
	//	Can be used only by soldiers that have the Heavy Armaments perk (dummy squaddie perk for technicals)
	HasAbilityCondition = new class'X2Condition_IRI_HasOneAbilityFromList';
	HasAbilityCondition.AbilityNames.AddItem('HeavyArmaments');
	//	ShockAndAwe is included into LW2 Secondary Weapons mod, it grants +1 Rockets (to 1 that's alreeady there by default).
	//	RPGO changes the default number of rockets to 0 and makes ShockAndAwe a starting Rocketeer perk.
	HasAbilityCondition.AbilityNames.AddItem('ShockAndAwe');
	Template.AbilityShooterConditions.AddItem(HasAbilityCondition);

	//	Cannot be used while suppressed
	//SuppressedCondition = new class'X2Condition_UnitEffects';
	//SuppressedCondition.AddExcludeEffect('Suppression', 'AA_UnitIsSuppressed');
	//SuppressedCondition.AddExcludeEffect('LW2WotC_AreaSuppression', 'AA_UnitIsSuppressed');
	//Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	//	Target conditions
	//	Ability doesn't deal damage with this condition
	//GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	//GrenadeCondition.CheckGrenadeFriendlyFire = true;
	//Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);

	//	Visualization
	Template.CinescriptCameraType = "Iridar_Rocket";

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.Hostility = eHostility_Offensive;

	return Template;
}

static function SetFireAnim(out X2AbilityTemplate Template, name Anim)
{
	Template.CustomFireAnim = Anim;
	Template.CustomFireKillAnim = Anim;
	Template.CustomMovingFireAnim = Anim;
	Template.CustomMovingFireKillAnim = Anim;
	Template.CustomMovingTurnLeftFireAnim = Anim;
	Template.CustomMovingTurnLeftFireKillAnim = Anim;
	Template.CustomMovingTurnRightFireAnim = Anim;
	Template.CustomMovingTurnRightFireKillAnim = Anim;
}

static function RemoveVoiceLines(out X2AbilityTemplate Template)
{
	Template.ActivationSpeech = '';
	Template.SourceHitSpeech = '';
	Template.TargetHitSpeech = '';
	Template.SourceMissSpeech = '';
	Template.TargetMissSpeech = '';
	Template.TargetKilledByAlienSpeech = '';
	Template.TargetKilledByXComSpeech = '';
	Template.MultiTargetsKilledByAlienSpeech = '';
	Template.MultiTargetsKilledByXComSpeech = '';
	Template.TargetWingedSpeech = '';
	Template.TargetArmorHitSpeech = '';
	Template.TargetMissedSpeech = '';
}

static function SetHidden(out X2AbilityTemplate Template)
{
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;
}

static function X2AbilityTemplate AddDenseSmoke()
{
	local X2AbilityTemplate						Template;
	local X2Effect_TemporaryItem				TemporaryItemEffect;
	local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DenseSmoke');

	Template.IconImage = "img:///UILibrary_LW_PerkPack.LW_AbilityDenseSmoke";
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

	return Template;

	return Template;
}


defaultproperties
{
	Begin Object Class=X2AbilityCost_RocketActionPoints Name=DefaultRocketActionCost
		bAddWeaponTypicalCost = true
	End Object
	RocketActionCost = DefaultRocketActionCost;
}