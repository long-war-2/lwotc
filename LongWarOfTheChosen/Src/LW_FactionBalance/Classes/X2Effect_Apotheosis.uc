//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Apotheosis
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Grants the target god-like stats.
//---------------------------------------------------------------------------------------

class X2Effect_Apotheosis extends X2Effect_ModifyStats config(LW_FactionBalance);

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

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Effect_FocusLevel FocusEffectState;
	local XComGameState_Unit TargetUnit;

	FocusEffectState = XComGameState_Effect_FocusLevel(EffectState);
	TargetUnit = XComGameState_Unit(TargetDamageable);

	if (TargetUnit != none)
	{
		// Double the current damage (will include bonuses from other persistent
		// effects that precede this one)
		return CurrentDamage * (FocusEffectState.FocusLevel - 2) * FocusDamageMultiplier;
	}

	return 0;
}

defaultproperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Apotheosis"
	GameStateEffectClass=class'XComGameState_Effect_FocusLevel';
}
