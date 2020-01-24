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
	case 'TemplarFocus':
		SupportSupremeFocusInTemplarFocus(Template);
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
	RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(default.VOLT_TILE_RADIUS);

	DangerZoneBonus.RequiredAbility = 'VoltDangerZone';
	DangerZoneBonus.fBonusRadius = default.VOLT_DANGER_ZONE_BONUS_RADIUS;
	RadiusMultiTarget.AbilityBonusRadii.AddItem(DangerZoneBonus);

	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_AreaSuppression';
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

defaultproperties
{
	AbilityTemplateModFn=UpdateAbilities
}
