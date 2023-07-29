//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SmokeFlankingCritProtection
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Negates the crit bonus from flanks when a unit is in smoke
//---------------------------------------------------------------------------------------
class X2Effect_SmokeFlankingCritProtection extends X2Effect_Persistent;

// Set these on effect creation using the following:
//	SmokeAntiCritEffect.bSmokeStopsFlanks = class'Helpers_LW'.default.bSmokeStopsFlanksActive;
//	SmokeAntiCritEffect.bImrovedDefensiveSmoke = class'Helpers_LW'.default.bImprovedSmokeDefenseActive;


var bool bSmokeStopsFlanks;
var bool bImprovedDefensiveSmoke;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotMod;

	// If the Reliable Smoke or Improved Smoke Defense mods are enabled,
	// let them handle flanking crit protection, otherwise we'll end up
	// doubling the effect.
	if (bSmokeStopsFlanks || bImprovedDefensiveSmoke)
		return;

	// If the target is affected by smoke and is flanked, then add a
	// negative crit chance to negate the flanking bonus.
	if (bFlanking && Target.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name))
	{
		ShotMod.ModType = eHit_Crit;
		ShotMod.Reason = FriendlyName;
		ShotMod.Value = -Attacker.GetCurrentStat(eStat_FlankingCritChance);

		ShotModifiers.AddItem(ShotMod);
	}
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	return TargetUnit.IsInWorldEffectTile(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Class.Name);
}
