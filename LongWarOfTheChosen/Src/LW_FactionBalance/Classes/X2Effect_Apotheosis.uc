//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Apotheosis
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Grants the target god-like stats.
//---------------------------------------------------------------------------------------

class X2Effect_Apotheosis extends X2Effect_ModifyStats;

var float FocusDamageMultiplier;
var array<FocusLevelModifiers> arrFocusModifiers;

simulated protected function OnEffectAdded(
	const out EffectAppliedData ApplyEffectParameters,
	XComGameState_BaseObject kNewTargetState,
	XComGameState NewGameState,
	XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_FocusLevel FocusEffectState;
	local XComGameState_Unit UnitState;

	FocusEffectState = XComGameState_Effect_FocusLevel(NewEffectState);
	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		FocusEffectState.SetFocusLevel(
			UnitState.GetTemplarFocusLevel(),
			arrFocusModifiers[UnitState.GetTemplarFocusLevel()].StatChanges,
			UnitState,
			NewGameState);
	}

	if (FocusEffectState.StatChanges.Length > 0)
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

function float GetPostDefaultAttackingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit SourceUnit,
	Damageable Target,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData ApplyEffectParameters,
	float WeaponDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{
	local XComGameState_Effect_FocusLevel FocusEffectState;
	local XComGameState_Unit TargetUnit;

	FocusEffectState = XComGameState_Effect_FocusLevel(EffectState);
	TargetUnit = XComGameState_Unit(Target);

	if (TargetUnit != none)
	{
		// Double the current damage (will include bonuses from other persistent
		// effects that precede this one)
		return WeaponDamage * (FocusEffectState.FocusLevel - 2) * FocusDamageMultiplier;
	}

	return 0.0;
}

defaultproperties
{
	DuplicateResponse = eDupe_Allow
	EffectName = "Apotheosis"
	GameStateEffectClass=class'XComGameState_Effect_FocusLevel';
}
