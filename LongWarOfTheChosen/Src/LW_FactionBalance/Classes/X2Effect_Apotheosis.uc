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

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Effect_FocusLevel FocusEffectState;
	local XComGameState_Unit TargetUnit;
	local int ModifiedDamage;

	FocusEffectState = XComGameState_Effect_FocusLevel(EffectState);
	TargetUnit = XComGameState_Unit(TargetDamageable);

	if (TargetUnit != none)
	{
		ModifiedDamage = CurrentDamage;

		// Factor in Reaper if its effect comes after Apotheosis. It's a hack.
		if (IsReaperAfterApotheosis(Attacker) && AbilityState.GetMyTemplate().IsMelee())
		{
			ModifiedDamage = ModifyDamageForReaper(Attacker, ModifiedDamage);
		}

		// Double the current damage (will include bonuses from other persistent
		// effects that precede this one)
		return ModifiedDamage * (FocusEffectState.FocusLevel - 2) * FocusDamageMultiplier;
	}

	return 0;
}

function bool IsReaperAfterApotheosis(XComGameState_Unit Attacker)
{
	local name CurrEffectName;
	local bool FoundApotheosis, FoundReaper;

	foreach Attacker.AffectedByEffectNames(CurrEffectName)
	{
		if (CurrEffectName == 'Reaper')
		{
			FoundReaper = true;
			break;
		}
		else if (CurrEffectName == EffectName)
		{
			FoundApotheosis = true;
		}
	}

	// Since we broke out of the loop upon finding Reaper in the
	// array, we know Reaper comes after Apotheosis if it hasn't been
	// found yet.
	return FoundReaper && FoundApotheosis;
}

// Mostly copied from `X2Effect_Reaper.GetAttackingDamageModifier()`
function int ModifyDamageForReaper(XComGameState_Unit Attacker,const int CurrentDamage)
{
	local UnitValue UnitVal;
	local int ReaperDamageReduction;

	Attacker.GetUnitValue(class'X2Effect_Reaper'.default.ReaperKillName, UnitVal);
	ReaperDamageReduction = UnitVal.fValue * class'X2Effect_Reaper'.default.DMG_REDUCTION;
	if (ReaperDamageReduction >= CurrentDamage)
		ReaperDamageReduction = CurrentDamage - 1;

	return CurrentDamage - ReaperDamageReduction;
}

defaultproperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Apotheosis"
	GameStateEffectClass=class'XComGameState_Effect_FocusLevel';
}
