//---------------------------------------------------------------------------------------
//  FILE:    X2LWModTemplate_TemplarAbilities.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing ability templates related to Templar soldiers.
//---------------------------------------------------------------------------------------
class X2LWModTemplate_TemplarAbilities extends X2LWTemplateModTemplate config(LW_FactionBalance);

var config int FOCUS4MOBILITY;
var config int FOCUS4DODGE;
var config int FOCUS4RENDDAMAGE;

var config int STUNSTRIKE_STUN_DURATION;
var config int STUNSTRIKE_STUN_CHANCE;
var config int VOLT_TILE_RADIUS;
var config int VOLT_DANGER_ZONE_BONUS_RADIUS;

static function UpdateAbilities(X2AbilityTemplate Template, int Difficulty)
{
	switch (Template.DataName)
	{
	case 'Rend':
	case 'ArcWave':
	case 'TemplarBladestormAttack':
		// Allow Rend to miss and graze.
		X2AbilityToHitCalc_StandardMelee(Template.AbilityToHitCalc).bGuaranteedHit = false;
		break;
	case 'Volt':
		ModifyVoltTargeting(Template);
		AddTerrorToVolt(Template);
		break;
	case 'Deflect':
		ModifyDeflectEffect(Template);
		break;
	case 'Parry':
		ModifyParryEffect(Template);
		break;
	case 'StunStrike':
		ModifyStunStrikeToStun(Template);
		break;
	case 'Pillar':
		AllowPillarOnMomentum(Template);
		break;
	case 'Exchange':
		// Not yet working properly: unable to target enemy units
		// MergeInvertWithExchange(Template);
		break;
	case 'TemplarFocus':
		SupportSupremeFocusInTemplarFocus(Template);
		break;
	case 'VoidConduit':
		FixVoidConduit(Template);
		break;
	}
}

// Use Area Suppression targeting for Volt so that it can target more than
// one unit even with just 1 focus.
static function ModifyVoltTargeting(X2AbilityTemplate Template)
{
	local X2Condition_UnitProperty ShooterCondition;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local AbilityGrantedBonusRadius DangerZoneBonus;

	ShooterCondition = new class'X2Condition_UnitProperty';
	ShooterCondition.ExcludeConcealed = true;
	Template.AbilityShooterConditions.AddItem(ShooterCondition);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = false;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(default.VOLT_TILE_RADIUS) + 0.01;

	DangerZoneBonus.RequiredAbility = 'VoltDangerZone';
	DangerZoneBonus.fBonusRadius = `TILESTOMETERS(default.VOLT_DANGER_ZONE_BONUS_RADIUS) + 0.01;
	RadiusMultiTarget.AbilityBonusRadii.AddItem(DangerZoneBonus);

	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_AreaSuppression';
}

static function AddTerrorToVolt(X2AbilityTemplate Template)
{
	Template.AdditionalAbilities.AddItem(class'X2Ability_TemplarAbilitySet_LW'.default.PanicImpairingAbilityName);
	Template.AddMultiTargetEffect(CreateTerrorPanicEffect());
}

static function X2Effect_ImmediateMultiTargetAbilityActivation CreateTerrorPanicEffect()
{
	local X2Effect_ImmediateMultiTargetAbilityActivation	PanicEffect;
	local X2Condition_AbilityProperty						TerrorCondition;
	local X2Condition_UnitProperty							UnitCondition;

	PanicEffect = new class 'X2Effect_ImmediateMultiTargetAbilityActivation';

	PanicEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	PanicEffect.EffectName = 'ImmediateDisorientOrPanic';
	PanicEffect.AbilityName = class'X2Ability_TemplarAbilitySet_LW'.default.PanicImpairingAbilityName;
	PanicEffect.bRemoveWhenTargetDies = true;

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = false;
	UnitCondition.ExcludeRobotic = true;
	UnitCondition.ExcludeAlive = false;
	UnitCondition.ExcludeDead = true;
	UnitCondition.FailOnNonUnits = true;
	UnitCondition.ExcludeFriendlyToSource = true;

	TerrorCondition = new class'X2Condition_AbilityProperty';
	TerrorCondition.OwnerHasSoldierAbilities.AddItem('TemplarTerror');

	PanicEffect.TargetConditions.AddItem(UnitCondition);
	PanicEffect.TargetConditions.AddItem(TerrorCondition);

	return PanicEffect;
}

// Allows Pillar to be used instead of the Momentum move
static function AllowPillarOnMomentum(X2AbilityTemplate Template)
{
	local X2AbilityCost_ActionPoints ActionPointCost;
	local int i;

	for (i = 0; i < Template.AbilityCosts.Length; i++)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);
		if (ActionPointCost != none)
		{
			ActionPointCost.AllowedTypes.AddItem('Momentum');
		}
	}
}

// Change Exchange targeting so that it also works as Invert
static function MergeInvertWithExchange(X2AbilityTemplate Template)
{
	local X2Condition_UnitProperty UnitCondition;
	local int i;

	Template.Hostility = eHostility_Offensive;
	for (i = 0; i < Template.AbilityTargetConditions.Length; i++)
	{
		UnitCondition = X2Condition_UnitProperty(Template.AbilityTargetConditions[i]);
		if (UnitCondition != none)
		{
			UnitCondition.ExcludeCivilian = true;
			UnitCondition.ExcludeHostileToSource = false;
			UnitCondition.ExcludeLargeUnits = true;
			UnitCondition.ExcludeTurret = true;
			UnitCondition.RequireSquadmates = false;
		}
	}

	// Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
}

// Changes StunStrike to stun target units rather than disorient them (the
// disorient chance is simply set to 0 in the config).
static function ModifyStunStrikeToStun(X2AbilityTemplate Template)
{
	local X2Effect_Stunned				StunnedEffect;

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.STUNSTRIKE_STUN_DURATION, default.STUNSTRIKE_STUN_CHANCE, false);
	Template.AddTargetEffect(StunnedEffect);
}

// New Deflect and Parry from AngelRane
static function ModifyDeflectEffect(X2AbilityTemplate Template)
{
	local X2AbilityTemplate		DeflectTemplate;
	local X2Effect_Persistent   Effect;

	DeflectTemplate = Template;
	DeflectTemplate.AbilityTargetEffects.Length = 0;

	Effect = new class'X2Effect_DeflectNew';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, DeflectTemplate.LocFriendlyName, DeflectTemplate.GetMyHelpText(), DeflectTemplate.IconImage, true, , DeflectTemplate.AbilitySourceName);
	DeflectTemplate.AddTargetEffect(Effect);
}

static function ModifyParryEffect(X2AbilityTemplate Template)
{
	local X2AbilityTemplate		ParryTemplate;
	local X2Effect_Persistent   PersistentEffect;

	ParryTemplate = Template;
	ParryTemplate.AbilityTargetEffects.Length = 0;

	PersistentEffect = new class'X2Effect_ParryNew';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, ParryTemplate.LocFriendlyName, ParryTemplate.GetMyHelpText(), ParryTemplate.IconImage, true, , ParryTemplate.AbilitySourceName);
	ParryTemplate.AddTargetEffect(PersistentEffect);
}

static function SupportSupremeFocusInTemplarFocus(X2AbilityTemplate Template)
{
	local X2Effect_TemplarFocus	FocusEffect;
	local array<StatChange>		StatChanges;
	local StatChange			NewStatChange;
	local int					i;

	for (i = 0; i < Template.AbilityTargetEffects.Length; i++)
	{
		FocusEffect = X2Effect_TemplarFocus(Template.AbilityTargetEffects[i]);
		if (FocusEffect != none) break;
	}

	// Can't find the focus effect to modify
	if (FocusEffect == none) return;

	//	Supreme Focus support
	NewStatChange.StatType = eStat_Mobility;
	NewStatChange.StatAmount = default.FOCUS4MOBILITY;
	StatChanges.AddItem(NewStatChange);
	NewStatChange.StatType = eStat_Dodge;
	NewStatChange.StatAmount = default.FOCUS4DODGE;
	StatChanges.AddItem(NewStatChange);
	FocusEffect.AddNextFocusLevel(StatChanges, 0, default.FOCUS4RENDDAMAGE);
}

// Void Conduit is broken because it needs to tick at the beginning of the
// AI player's turn to do the per-action damage, the heal and to calculate
// the number of actions to remove from the target unit. But it *also* needs
// to tick at the beginning of the unit group turn, because that's the only
// time the effect can modify the target unit's starting number of actions.
//
// This fix adds another effect that does the work on unit group turn begin,
// using the values calculated by the existing persistent Void Conduit effect.
static function FixVoidConduit(X2AbilityTemplate Template)
{
	local X2Effect_VoidConduitPatch PatchEffect;

	PatchEffect = new class'X2Effect_VoidConduitPatch';
	PatchEffect.BuildPersistentEffect(1, true, true, false, eGameRule_UnitGroupTurnBegin);
	PatchEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(PatchEffect);
}

defaultproperties
{
	AbilityTemplateModFn=UpdateAbilities
}
