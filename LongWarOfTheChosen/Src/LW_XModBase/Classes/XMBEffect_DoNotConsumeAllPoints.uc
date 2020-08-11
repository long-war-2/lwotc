//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_DoNotConsumeAllPoints.uc
//  AUTHOR:  xylthixlm
//
//  A persistent effect which causes a specific ability or abilities to not end the
//  turn when used as a first action.
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  BulletSwarm
//  SmokeAndMirrors
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
class XMBEffect_DoNotConsumeAllPoints extends X2Effect_Persistent implements(XMBEffectInterface);

//////////////////////
// Bonus properties //
//////////////////////

var array<name> AbilityNames;		// The abilities which will not end the turn as first action

//////////////////////////
// Condition properties //
//////////////////////////

var array<X2Condition> AbilityTargetConditions;		// Conditions on the target of the ability.
var array<X2Condition> AbilityShooterConditions;	// Conditions on the shooter of the ability.

////////////////////
// Implementation //
////////////////////

function private name ValidateAttack(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState)
{
	local name AvailableCode;

	if (AbilityNames.Length > 0 && AbilityNames.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE)
		return 'AA_InvalidAbilityName';

	AvailableCode = class'XMBEffectUtilities'.static.CheckTargetConditions(AbilityTargetConditions, EffectState, Attacker, Target, AbilityState);
	if (AvailableCode != 'AA_Success')
		return AvailableCode;
		
	AvailableCode = class'XMBEffectUtilities'.static.CheckShooterConditions(AbilityShooterConditions, EffectState, Attacker, Target, AbilityState);
	if (AvailableCode != 'AA_Success')
		return AvailableCode;
		
	return 'AA_Success';
}

////////////////////////
// XMBEffectInterface //
////////////////////////

function bool GetTagValue(name Tag, XComGameState_Ability AbilityState, out string TagValue);
function bool GetExtModifiers(name Type, XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, optional ShotBreakdown ShotBreakdown, optional out array<ShotModifierInfo> ShotModifiers);

function bool GetExtValue(LWTuple Data)
{
	local XComGameState_Unit SourceUnit;
	local XComGameState_Ability AbilityState;
	local XComGameState_Effect EffectState;
	local name ValidationResult;

	if (Data.Id == 'GetConsumeAllPoints')
	{
		SourceUnit = XComGameState_Unit(Data.Data[0].o);
		AbilityState = XComGameState_Ability(Data.Data[1].o);
		EffectState = XComGameState_Effect(Data.Data[2].o);

		ValidationResult = ValidateAttack(EffectState, SourceUnit, none, AbilityState);
		if (ValidationResult == 'AA_Success')
		{
			Data.Data[3].i = int(false);
			return true;
		}
	}

	return false;
}

