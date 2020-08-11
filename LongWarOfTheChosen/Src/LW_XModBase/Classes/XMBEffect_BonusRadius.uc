//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_BonusRadius.uc
//  AUTHOR:  xylthixlm
//
//  A persistent effect which increases the radius of grenades used by the unit. It can
//  also change the radius of any other ability with multitarget type
//  X2AbilityMultiTarget_Radius.
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  DangerZone
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  Core
//---------------------------------------------------------------------------------------
class XMBEffect_BonusRadius extends X2Effect_Persistent implements(XMBEffectInterface);


//////////////////////
// Bonus properties //
//////////////////////

var float fBonusRadius;					// Amount to increase the radius, in meters. One tile equals 1.5 meters.


//////////////////////////
// Condition properties //
//////////////////////////

var array<name> IncludeItemNames;		// Ammo types (grenades) which the bonus will apply to. If empty, it applies to everything.
var array<name> IncludeAbilityNames;


////////////////////////////
// Overrideable functions //
////////////////////////////

// Note that the Ability passed in is the ability that the radius is being modified on, and NOT the ability that created this effect.
simulated function float GetRadiusModifier(const XComGameState_Ability Ability, const XComGameState_Unit SourceUnit, float fBaseRadius)
{
	local XComGameState_Item ItemState;

	if (IncludeAbilityNames.Length > 0 && IncludeAbilityNames.Find(Ability.GetMyTemplateName()) == INDEX_NONE)
		return 0;

	if (IncludeItemNames.Length > 0)
	{
		ItemState = Ability.GetSourceAmmo();
		if (ItemState == none)
			ItemState = Ability.GetSourceWeapon();

		if (ItemState == none)
			return 0;

		if (IncludeItemNames.Find(ItemState.GetMyTemplateName()) == INDEX_NONE)
			return 0;
	}

	return fBonusRadius;
}


////////////////////
// Implementation //
////////////////////

// From XMBEffectInterface
function bool GetTagValue(name Tag, XComGameState_Ability AbilityState, out string TagValue) { return false; }
function bool GetExtModifiers(name Type, XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, optional ShotBreakdown ShotBreakdown, optional out array<ShotModifierInfo> ShotModifiers) { return false; }

// From XMBEffectInterface
function bool GetExtValue(LWTuple Tuple)
{
	local XComGameState_Unit Attacker;
	local XComGameState_Ability AbilityState;
	local LWTValue Value;
	local float fBaseValue;

	if (Tuple.id != 'BonusRadius')
		return false;

	Attacker = XComGameState_Unit(Tuple.Data[1].o);
	AbilityState = XComGameState_Ability(Tuple.Data[2].o);
	fBaseValue = Tuple.Data[3].f;

	Value.f = GetRadiusModifier(AbilityState, Attacker, fBaseValue);
	Value.kind = LWTVFloat;

	Tuple.Data.Length = 0;
	Tuple.Data.AddItem(Value);

	return true;
}

defaultproperties
{
	IncludeAbilityNames[0] = "ThrowGrenade"
	IncludeAbilityNames[1] = "LaunchGrenade"
}