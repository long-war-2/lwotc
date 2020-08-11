//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_ConditionalBonus.uc
//  AUTHOR:  xylthixlm
//
//  This class provides an easy way of creating passive effects that give bonuses based
//  on some condition. Build up the modifiers you want to add using AddToHitModifier
//  and related functions, and set the conditions for them by adding an X2Condition to
//  SelfConditions or OtherConditions. This class takes care of validating the
//  conditions and applying the modifiers. You can also define different modifiers
//  based on the tech tier of the weapon or other item used. Ability tags are
//  automatically defined for each modifier.
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  AbsolutelyCritical
//  AgainstTheOdds
//  DamnGoodGround
//  Magnum
//  MovingTarget
//  PowerShot
//  Precision
//  Saboteur
//  SurvivalInstinct
//  TacticalSense
//  Weaponmaster
//  ZeroIn
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  Core
//  XMBEffect_Extended.uc
//  XMBEffectUtilities.uc
//---------------------------------------------------------------------------------------

class XMBEffect_ConditionalBonus extends XMBEffect_Extended;


/////////////////////
// Data structures //
/////////////////////

struct ExtShotModifierInfo
{
	var ShotModifierInfo ModInfo;
	var name WeaponTech;
	var name Type;
	var bool bPercent;
};


//////////////////////
// Bonus properties //
//////////////////////

var array<ExtShotModifierInfo> Modifiers;			// Modifiers to attacks made by (or at) the unit with the effect

var bool bIgnoreSquadsightPenalty;					// Negates squadsight penalties. Requires XMBEffect_Extended.

var XMBValue ScaleValue;
var float ScaleBase;
var float ScaleMultiplier;
var float ScaleMax;


//////////////////////////
// Condition properties //
//////////////////////////

var array<X2Condition> AbilityTargetConditions;				// Conditions on the target of the ability being modified.
var array<X2Condition> AbilityShooterConditions;			// Conditions on the shooter of the ability being modified.
var array<X2Condition> AbilityTargetConditionsAsTarget;		// Conditions on the target of the ability being modified, for ToHitAsTarget.
var array<X2Condition> AbilityShooterConditionsAsTarget;	// Conditions on the shooter of the ability being modified, for ToHitAsTarget.

var bool bHideWhenNotRelevant;								// If true, the ability doesn't appear in the UI when its
															// conditions are not met.


/////////////
// Setters //
/////////////

// Adds a modifier to the hit chance of attacks made by the unit with the effect.
function AddToHitModifier(int Value, optional EAbilityHitResult ModType = eHit_Success, optional name WeaponTech = '')
{
	local ExtShotModifierInfo ExtModInfo;

	ExtModInfo.ModInfo.ModType = ModType;
	ExtModInfo.ModInfo.Reason = FriendlyName;
	ExtModInfo.ModInfo.Value = Value;
	ExtModInfo.WeaponTech = WeaponTech;
	ExtModInfo.Type = 'ToHit';
	Modifiers.AddItem(ExtModInfo);
}	

// Adds a modifier to the hit chance of attacks made against (not by) the unit with the effect.
function AddToHitAsTargetModifier(int Value, optional EAbilityHitResult ModType = eHit_Success, optional name WeaponTech = '')
{
	local ExtShotModifierInfo ExtModInfo;

	ExtModInfo.ModInfo.ModType = ModType;
	ExtModInfo.ModInfo.Reason = FriendlyName;
	ExtModInfo.ModInfo.Value = Value;
	ExtModInfo.WeaponTech = WeaponTech;
	ExtModInfo.Type = 'ToHitAsTarget';
	Modifiers.AddItem(ExtModInfo);
}	

// Adds a modifier to the damage of attacks made by the unit with the effect.
function AddDamageModifier(int Value, optional EAbilityHitResult ModType = eHit_Success, optional name WeaponTech = '')
{
	local ExtShotModifierInfo ExtModInfo;

	ExtModInfo.ModInfo.ModType = ModType;
	ExtModInfo.ModInfo.Reason = FriendlyName;
	ExtModInfo.ModInfo.Value = Value;
	ExtModInfo.WeaponTech = WeaponTech;
	ExtModInfo.Type = 'Damage';
	Modifiers.AddItem(ExtModInfo);
}	

// Adds a modifier to the damage of attacks made by the unit with the effect.
function AddPercentDamageModifier(int Value, optional EAbilityHitResult ModType = eHit_Success, optional name WeaponTech = '')
{
	local ExtShotModifierInfo ExtModInfo;

	ExtModInfo.ModInfo.ModType = ModType;
	ExtModInfo.ModInfo.Reason = FriendlyName;
	ExtModInfo.ModInfo.Value = Value;
	ExtModInfo.WeaponTech = WeaponTech;
	ExtModInfo.Type = 'Damage';
	ExtModInfo.bPercent = true;
	Modifiers.AddItem(ExtModInfo);
}	

// Adds a modifier to the armor shredding amount of attacks made by the unit with the effect.
function AddShredModifier(int Value, optional EAbilityHitResult ModType = eHit_Success, optional name WeaponTech = '')
{
	local ExtShotModifierInfo ExtModInfo;

	ExtModInfo.ModInfo.ModType = ModType;
	ExtModInfo.ModInfo.Reason = FriendlyName;
	ExtModInfo.ModInfo.Value = Value;
	ExtModInfo.WeaponTech = WeaponTech;
	ExtModInfo.Type = 'Shred';
	Modifiers.AddItem(ExtModInfo);
}	

// Adds a modifier to the armor piercing amount of attacks made by the unit with the effect.
function AddArmorPiercingModifier(int Value, optional EAbilityHitResult ModType = eHit_Success, optional name WeaponTech = '')
{
	local ExtShotModifierInfo ExtModInfo;

	ExtModInfo.ModInfo.ModType = ModType;
	ExtModInfo.ModInfo.Reason = FriendlyName;
	ExtModInfo.ModInfo.Value = Value;
	ExtModInfo.WeaponTech = WeaponTech;
	ExtModInfo.Type = 'ArmorPiercing';
	Modifiers.AddItem(ExtModInfo);
}	


////////////////////
// Implementation //
////////////////////

function private float GetScaleByValue(XComGameState_Effect EffectState, XComGameState_Unit UnitState, XComGameState_Unit TargetState, XComGameState_Ability AbilityState)
{
	local float Scale, Value;

	if (ScaleValue == none)
		return 1.0;

	Value = ScaleValue.GetValue(EffectState, UnitState, TargetState, AbilityState);
	Scale = FClamp(ScaleBase + ScaleMultiplier * Value, 0, ScaleMax);

	return Scale;
}

function protected name ValidateAttack(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, bool bAsTarget = false)
{
	local name AvailableCode;

	if (!bAsTarget)
	{
		AvailableCode = class'XMBEffectUtilities'.static.CheckTargetConditions(AbilityTargetConditions, EffectState, Attacker, Target, AbilityState);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
		
		AvailableCode = class'XMBEffectUtilities'.static.CheckShooterConditions(AbilityShooterConditions, EffectState, Attacker, Target, AbilityState);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	}
	else
	{
		AvailableCode = class'XMBEffectUtilities'.static.CheckTargetConditions(AbilityTargetConditionsAsTarget, EffectState, Attacker, Target, AbilityState);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
		
		AvailableCode = class'XMBEffectUtilities'.static.CheckShooterConditions(AbilityShooterConditionsAsTarget, EffectState, Attacker, Target, AbilityState);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	}

		
	return 'AA_Success';
}

// Checks that the weapon used by the attack is the right tech tier for a modifier
static function name ValidateWeapon(ExtShotModifierInfo ExtModInfo, XComGameState_Item SourceWeapon)
{
	local X2WeaponTemplate WeaponTemplate;

	if (ExtModInfo.WeaponTech != '')
	{
		if (SourceWeapon == none)
			return 'AA_WeaponIncompatible';

		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		if (WeaponTemplate == none || WeaponTemplate.WeaponTech != ExtModInfo.WeaponTech)
			return 'AA_WeaponIncompatible';
	}

	return 'AA_Success';
}

// From X2Effect_Persistent. Returns a damage modifier for an attack by the unit with the effect.
function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local ExtShotModifierInfo ExtModInfo;
	local int BonusDamage;

	if (ValidateAttack(EffectState, Attacker, XComGameState_Unit(TargetDamageable), AbilityState) != 'AA_Success')
		return 0;

	foreach Modifiers(ExtModInfo)
	{
		if (ExtModInfo.Type != 'Damage')
			continue;

		if (ValidateWeapon(ExtModInfo, AbilityState.GetSourceWeapon()) != 'AA_Success')
			continue;

		if ((ExtModInfo.ModInfo.ModType == eHit_Success && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult)) ||
			ExtModInfo.ModInfo.ModType == AppliedData.AbilityResultContext.HitResult)
		{
			if (ExtModInfo.bPercent)
				BonusDamage += ExtModInfo.ModInfo.Value * CurrentDamage / 100;
			else
				BonusDamage += ExtModInfo.ModInfo.Value;
		}
	}

	return int(BonusDamage * GetScaleByValue(EffectState, Attacker, XComGameState_Unit(TargetDamageable), AbilityState));
}

// From X2Effect_Persistent. Returns an armor shred modifier for an attack by the unit with the effect.
function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local ExtShotModifierInfo ExtModInfo;
	local int BonusShred;

	if (ValidateAttack(EffectState, Attacker, XComGameState_Unit(TargetDamageable), AbilityState) != 'AA_Success')
		return 0;

	foreach Modifiers(ExtModInfo)
	{
		if (ExtModInfo.Type != 'Shred')
			continue;

		if (ValidateWeapon(ExtModInfo, AbilityState.GetSourceWeapon()) != 'AA_Success')
			continue;

		if ((ExtModInfo.ModInfo.ModType == eHit_Success && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult)) ||
			ExtModInfo.ModInfo.ModType == AppliedData.AbilityResultContext.HitResult)
		{
			BonusShred += ExtModInfo.ModInfo.Value;
		}
	}

	return int(BonusShred * GetScaleByValue(EffectState, Attacker, XComGameState_Unit(TargetDamageable), AbilityState));
}

// From X2Effect_Persistent. Returns an armor piercing modifier for an attack by the unit with the effect.
function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local ExtShotModifierInfo ExtModInfo;
	local int BonusArmorPiercing;

	if (ValidateAttack(EffectState, Attacker, XComGameState_Unit(TargetDamageable), AbilityState) != 'AA_Success')
		return 0;

	foreach Modifiers(ExtModInfo)
	{
		if (ExtModInfo.Type != 'ArmorPiercing')
			continue;

		if (ValidateWeapon(ExtModInfo, AbilityState.GetSourceWeapon()) != 'AA_Success')
			continue;

		if ((ExtModInfo.ModInfo.ModType == eHit_Success && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult)) ||
			ExtModInfo.ModInfo.ModType == AppliedData.AbilityResultContext.HitResult)
		{
			BonusArmorPiercing += ExtModInfo.ModInfo.Value;
		}
	}

	return int(BonusArmorPiercing * GetScaleByValue(EffectState, Attacker, XComGameState_Unit(TargetDamageable), AbilityState));
}

// From X2Effect_Persistent. Returns to hit modifiers for an attack by the unit with the effect.
function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ExtShotModifierInfo ExtModInfo;

	if (ValidateAttack(EffectState, Attacker, Target, AbilityState) == 'AA_Success')
	{	
		foreach Modifiers(ExtModInfo)
		{
			if (ExtModInfo.Type != 'ToHit')
				continue;

			if (ValidateWeapon(ExtModInfo, AbilityState.GetSourceWeapon()) != 'AA_Success')
				continue;

			ExtModInfo.ModInfo.Reason = FriendlyName;
			ExtModInfo.ModInfo.Value = int(ExtModInfo.ModInfo.Value * GetScaleByValue(EffectState, Attacker, Target, AbilityState));
			ShotModifiers.AddItem(ExtModInfo.ModInfo);
		}
	}
	
	super.GetToHitModifiers(EffectState, Attacker, Target, AbilityState, ToHitType, bMelee, bFlanking, bIndirectFire, ShotModifiers);	
}

// From X2Effect_Persistent. Returns to hit modifiers for an attack against (not by) the unit with the effect.
function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ExtShotModifierInfo ExtModInfo;

	if (ValidateAttack(EffectState, Attacker, Target, AbilityState, true) == 'AA_Success')
	{
		foreach Modifiers(ExtModInfo)
		{
			if (ExtModInfo.Type != 'ToHitAsTarget')
				continue;

			if (ValidateWeapon(ExtModInfo, AbilityState.GetSourceWeapon()) != 'AA_Success')
				continue;

			ExtModInfo.ModInfo.Reason = FriendlyName;
			ExtModInfo.ModInfo.Value = int(ExtModInfo.ModInfo.Value * GetScaleByValue(EffectState, Target, none, AbilityState));
			ShotModifiers.AddItem(ExtModInfo.ModInfo);
		}	
	}
	
	super.GetToHitAsTargetModifiers(EffectState, Attacker, Target, AbilityState, ToHitType, bMelee, bFlanking, bIndirectFire, ShotModifiers);	
}

// From XMBEffect_Extended. Returns true if squadsight penalties should be ignored for this attack.
function bool IgnoreSquadsightPenalty(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState) 
{
	if (!bIgnoreSquadsightPenalty)
		return false;

	if (ValidateAttack(EffectState, Attacker, Target, AbilityState) != 'AA_Success')
		return false;

	return true;
}

function static bool AllConditionsAreUnitConditions(array<X2Condition> Conditions)
{
	local X2Condition Condition;

	foreach Conditions(Condition)
	{
		if (class'XMBConfig'.default.UnitConditions.Find(Condition.class.name) == INDEX_NONE && 
			class'XMBConfig'.default.ExtraUnitConditions.Find(Condition.class.name) == INDEX_NONE)
		{
			return false;
		}
	}

	return true;
}

function private bool IsEffectRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit, bool bCheckVisibleUnits = true)
{
	local name AvailableCode;
	local float Scale;
	local ExtShotModifierInfo ExtModInfo;
	local bool bHasAsShooterEffects, bHasAsTargetEffects;
	local array<StateObjectReference> VisibleUnits;
	local StateObjectReference UnitRef;
	local XComGameState_Unit OtherUnit;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	Scale = GetScaleByValue(EffectGameState, TargetUnit, none, none);
	if (Scale == 0.0)
		return false;

	foreach Modifiers(ExtModInfo)
	{
		if (ExtModInfo.Type == 'ToHitAsTarget')
			bHasAsTargetEffects = true;
		else
			bHasAsShooterEffects = true;
	}

	if (bCheckVisibleUnits)
	{
		class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyUnitsForUnit(TargetUnit.ObjectID, VisibleUnits);
		foreach VisibleUnits(UnitRef)
		{
			OtherUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
			if (OtherUnit != none)
			{
				if (bHasAsShooterEffects)
				{
					AvailableCode = ValidateAttack(EffectGameState, TargetUnit, OtherUnit, none);
					if (AvailableCode == 'AA_Success')
						return true;
				}

				if (bHasAsTargetEffects)
				{
					AvailableCode = ValidateAttack(EffectGameState, OtherUnit, TargetUnit, none, true);
					if (AvailableCode == 'AA_Success')
						return true;
				}
			}
		}
	}

	if (VisibleUnits.Length == 0)
	{
		if (bHasAsShooterEffects && AbilityTargetConditions.Length == 0)
		{
			AvailableCode = class'XMBEffectUtilities'.static.CheckShooterConditions(AbilityShooterConditions, EffectGameState, TargetUnit, none, none);
			if (AvailableCode == 'AA_Success')
				return true;
		}

		if (bHasAsTargetEffects && AbilityShooterConditionsAsTarget.Length == 0 && AllConditionsAreUnitConditions(AbilityTargetConditionsAsTarget))
		{
			AvailableCode = class'XMBEffectUtilities'.static.CheckTargetConditions(AbilityTargetConditionsAsTarget, EffectGameState, none, TargetUnit, none);
			if (AvailableCode == 'AA_Success')
				return true;
		}
	}

	return false;
}

// From X2Effect_Persistent.
function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	if (!bHideWhenNotRelevant)
		return true;

	return IsEffectRelevant(EffectGameState, TargetUnit);
}

// From X2Effect_Persistent
function ModifyUISummaryUnitStats(XComGameState_Effect EffectState, XComGameState_Unit UnitState, const ECharStatType Stat, out int StatValue)
{
	local name Tag;
	local EAbilityHitResult HitResult;
	local ExtShotModifierInfo ExtModInfo;
	local float ResultMultiplier;

	ResultMultiplier = 1;

	switch (stat)
	{
		case eStat_Offense:		Tag = 'ToHit';			HitResult = eHit_Success;							break;
		case eStat_Defense:		Tag = 'ToHitAsTarget';	HitResult = eHit_Success;	ResultMultiplier *= -1;	break;
		case eStat_Dodge:		Tag = 'ToHitAsTarget';	HitResult = eHit_Graze;								break;
		case eStat_CritChance:	Tag = 'ToHit';			HitResult = eHit_Crit;								break;

		default: return;
	}

	if (!IsEffectRelevant(EffectState, UnitState, false))
		return;

	ResultMultiplier *= GetScaleByValue(EffectState, UnitState, none, none);

	foreach Modifiers(ExtModInfo)
	{
		if (ExtModInfo.Type != Tag)
			continue;

		if (ExtModInfo.ModInfo.ModType != HitResult)
			continue;

		if (ExtModInfo.WeaponTech != '')
			continue;

		StatValue += int(ExtModInfo.ModInfo.Value * ResultMultiplier);
	}
}

// From XMBEffectInterface. Checks whether this effect handles a particular ability tag, such as
// "<Ability:ToHit/>", and gets the value of the tag if it's handled. This function knows which
// modifiers are actually applied by this effect, and will only handle those. A complete list of 
// the modifiers which might be handled is in the cases of the switch statement.
//
// For tech-dependent tags, in tactical play the tag displays the actual value based on the unit's
// equipment. In the Armory it displays all the possible values separated by slashes, such as
// "2/3/4".
function bool GetTagValue(name Tag, XComGameState_Ability AbilityState, out string TagValue)
{
	local float Result;
	local array<float> TechResults;
	local XComGameState_Item ItemState;
	local ExtShotModifierInfo ExtModInfo;
	local int ValidModifiers, ValidTechModifiers;
	local EAbilityHitResult HitResult;
	local float ResultMultiplier;
	local XComGameState_Unit UnitState;
	local X2AbilityTag AbilityTag;
	local int idx;

	ResultMultiplier = 1;

	if (left(Tag, 3) ~= "Max")
	{
		Tag = name(mid(Tag, 3));
		ResultMultiplier *= ScaleMax;
	}
	else if (left(Tag, 3) ~= "Cur")
	{
		Tag = name(mid(Tag, 3));
		if (AbilityState != none)
		{
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
		}
		if (UnitState == none)
		{
			AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
			UnitState = XComGameState_Unit(AbilityTag.StrategyParseObj);
		}
		if (UnitState != none)
		{
			ResultMultiplier *= GetScaleByValue(none, UnitState, none, none);
		}
	}

	// These are all the combinations of modifier type and hit result that make sense.
	switch (Tag)
	{
	case 'ToHit':					Tag = 'ToHit';			HitResult = eHit_Success;							break;
	case 'ToHitAsTarget':			Tag = 'ToHitAsTarget';	HitResult = eHit_Success;							break;
	case 'Defense':					Tag = 'ToHitAsTarget';	HitResult = eHit_Success;	ResultMultiplier *= -1;	break;
	case 'Damage':					Tag = 'Damage';			HitResult = eHit_Success;							break;
	case 'Shred':					Tag = 'Shred';			HitResult = eHit_Success;							break;
	case 'ArmorPiercing':			Tag = 'ArmorPiercing';	HitResult = eHit_Success;							break;
	case 'Crit':					Tag = 'ToHit';			HitResult = eHit_Crit;								break;
	case 'CritDefense':				Tag = 'ToHitAsTarget';	HitResult = eHit_Crit;		ResultMultiplier *= -1;	break;
	case 'CritDamage':				Tag = 'Damage';			HitResult = eHit_Crit;								break;
	case 'CritShred':				Tag = 'Shred';			HitResult = eHit_Crit;								break;
	case 'CritArmorPiercing':		Tag = 'ArmorPiercing';	HitResult = eHit_Crit;								break;
	case 'Graze':					Tag = 'ToHit';			HitResult = eHit_Graze;								break;
	case 'Dodge':					Tag = 'ToHitAsTarget';	HitResult = eHit_Graze;								break;
	case 'GrazeDamage':				Tag = 'Damage';			HitResult = eHit_Graze;								break;
	case 'GrazeShred':				Tag = 'Shred';			HitResult = eHit_Graze;								break;
	case 'GrazeArmorPiercing':		Tag = 'ArmorPiercing';	HitResult = eHit_Graze;								break;
	case 'MissDamage':				Tag = 'Damage';			HitResult = eHit_Miss;								break;
	case 'MissShred':				Tag = 'Shred';			HitResult = eHit_Miss;								break;
	case 'MissArmorPiercing':		Tag = 'ArmorPiercing';	HitResult = eHit_Miss;								break;

	default:
		return false;
	}

	// If there are no modifiers of the right type, don't handle this ability tag.
	if (Modifiers.Find('Type', Tag) == INDEX_NONE)
		return false;

	if (AbilityState != none)
	{
		ItemState = AbilityState.GetSourceWeapon();
	}

	// Collect all the modifiers which apply.
	foreach Modifiers(ExtModInfo)
	{
		if (ExtModInfo.Type != Tag)
			continue;

		if (ExtModInfo.ModInfo.ModType != HitResult)
			continue;

		idx = class'X2ItemTemplateManager'.default.WeaponTechCategories.Find(ExtModInfo.WeaponTech);
		if (idx != INDEX_NONE)
		{
			// Track the results for each tech category
			TechResults.AddItem(ExtModInfo.ModInfo.Value);
			ValidTechModifiers++;
		}

		// Validate the weapon being used against the required tech level of the modifier
		if (ValidateWeapon(ExtModInfo, ItemState) != 'AA_Success')
			continue;

		// This modifier applies. Add it to the result, and track the number of valid modifiers.
		Result += ExtModInfo.ModInfo.Value;
		ValidModifiers++;
	}

	// If there are no valid modifiers, but there would have been if there had been a weapon of
	// the right tech, output the modifier for each tech level.
	if (ValidModifiers == 0 && ValidTechModifiers > 0)
	{
		TagValue = "";
		for (idx = 0; idx < TechResults.Length; idx++)
		{
			if (idx > 0) TagValue $= "/";
			TagValue $= string(int(TechResults[idx] * ResultMultiplier));
		}
		return true;
	}

	// Still no valid modifiers? Then this isn't a tag we handle.
	if (ValidModifiers == 0)
		return false;

	// Save the result. The ResultMultipler is to handle Defense, which is internally respresented
	// as a negative modifier to eHit_Success.
	TagValue = string(int(Result * ResultMultiplier));
	return true;
}

defaultproperties
{
	ScaleMultiplier = 1.0
	ScaleMax = 1000
}