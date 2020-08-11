//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_Extended.uc
//  AUTHOR:  xylthixlm
//
//  This class is an extension of X2Effect_Persistent which provides extra functions
//  which can be overridden in derived classes to create effects.
//
//  IMPORTANT NOTE: If you override GetToHitModifiers in a derived class of this, don't
//  forget to call super.GetToHitModifiers().
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
class XMBEffect_Extended extends X2Effect_Persistent implements(XMBEffectInterface);


////////////////////////
// Internal variables //
////////////////////////

var bool HandledOnPostTemplatesCreated;


////////////////////////////
// Overrideable functions //
////////////////////////////

// If true, the unit with this effect is immune to critical hits.
function bool CannotBeCrit(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState) { return false; }

// If true, the unit with this effect doesn't take penalties to hit and crit chance for using 
// squadsight.
function bool IgnoreSquadsightPenalty(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState) { return false; }

// This function can add new hit modifiers after all other hit calculations are done. Importantly,
// it gets access to the complete shot breakdown so far, so it can inspect the chance of a hit, 
// chance of a graze, etc. For example, it could apply a penalty to graze chance based on the total
// hit chance.
//
// If there are multiple effects with GetFinalToHitModifiers on a unit, they all get the same 
// breakdown, so they won't see the effects of other GetFinalToHitModifiers overrides.
function GetFinalToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, ShotBreakdown ShotBreakdown, out array<ShotModifierInfo> ShotModifiers);

function OnPostTemplatesCreated();

////////////////////
// Implementation //
////////////////////

// From XMBEffectInterface
function bool GetTagValue(name Tag, XComGameState_Ability AbilityState, out string TagValue) { return false; }

function bool GetExtValue(LWTuple Data) 
{ 
	switch (Data.Id)
	{
	case 'OnPostTemplatesCreated':
		if (HandledOnPostTemplatesCreated)
			return false;
		OnPostTemplatesCreated();
		HandledOnPostTemplatesCreated = true;
		return true;
	}

	return false; 
}

// From XMBEffectInterface. XMBAbilityToHitCalc_StandardAim uses this to find which modifiers it should apply.
function bool GetExtModifiers(name Type, XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, ShotBreakdown ShotBreakdown, out array<ShotModifierInfo> ShotModifiers)
{
	switch (Type)
	{
	case 'CannotBeCrit':
		return CannotBeCrit(EffectState, Attacker, Target, AbilityState);

	case 'IgnoreSquadsightPenalty':
		return IgnoreSquadsightPenalty(EffectState, Attacker, Target, AbilityState);

	case 'FinalToHitModifiers':
		GetFinalToHitModifiers(EffectState, Attacker, Target, AbilityState, ToHitType, bMelee, bFlanking, bIndirectFire, ShotBreakdown, ShotModifiers);
		return true;
	}
	
	return false;
}

// From X2Effect_Persistent
function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityToHitCalc_StandardAim ToHitCalc, SubToHitCalc;
	local ShotBreakdown Breakdown;
	local ShotModifierInfo Modifier;
	local AvailableTarget kTarget;
	local int idx;

	AbilityTemplate = AbilityState.GetMyTemplate();
	ToHitCalc = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);

	if (ToHitCalc == none)
		return;

	// If XMBAbilityToHitCalc_StandardAim (from XModBase/Classes/) is available, it will handle 
	// everything, so return early.
	if (ToHitCalc.IsA('XMBAbilityToHitCalc_StandardAim'))
		return;

	// We want to make sure that other XMBEffect_Extended's effects are not included in our 
	// calculation. Luckily, X2AbilityToHitCalc.HitModifiers is unused, so we use it as a flag to 
	// indicate we are in a sub-calculation.
	if (ToHitCalc.HitModifiers.Length > 0)
		return;
	ToHitCalc.HitModifiers.Length = 1;

	// We do something very strange and magical here: we do the entire hit calc ahead of time, in
	// order to see what the results would be without our modifiers. Then we use those results to
	// figure out what modifiers we should return to get the correct final result.

	// We need to allocate a new ToHitCalc to avoid clobbering the breakdown of the one being 
	// calculated.
	SubToHitCalc = new ToHitCalc.Class(ToHitCalc);

	kTarget.PrimaryTarget = Target.GetReference();
	SubToHitCalc.GetShotBreakdown(AbilityState, kTarget, Breakdown);

	// The shot breakdown from GetShotBreakdown has graze chance multiplied by hit chance, and other
	// changes we don't want, so recompute the breakdown table based on the raw modifiers.
	for (idx = 0; idx < eHit_MAX; idx++)
		Breakdown.ResultTable[idx] = 0;
	foreach Breakdown.Modifiers(Modifier)
		Breakdown.ResultTable[Modifier.ModType] += Modifier.Value;

	// If we are supposed to be ignoring squadsight modifiers, find the squadsight modifiers and apply
	// equal but opposite modifiers to cancel them.
	if (IgnoreSquadsightPenalty(EffectState, Attacker, Target, AbilityState))
	{
		foreach Breakdown.Modifiers(Modifier)
		{
			// Kind of a hacky way to check, since it depends on localization, but nothing should 
			// localize some other skill to "squadsight".
			if (Modifier.Reason == class'XLocalizedData'.default.SquadsightMod)
			{
				// Cancel out the modifier and adjust the shot breakdown results.
				Modifier.Value *= -1;
				Modifier.Reason = FriendlyName;
				ShotModifiers.AddItem(Modifier);
				Breakdown.ResultTable[Modifier.ModType] += Modifier.Value;
			}
		}
	}

	// Give subclasses a chance to add modifiers based on the adjusted shot breakdown.
	GetFinalToHitModifiers(EffectState, Attacker, Target, AbilityState, ToHitType, bMelee, bFlanking, bIndirectFire, Breakdown, ShotModifiers);

	// We used HitModifiers as a flag earlier, so reset it.
	ToHitCalc.HitModifiers.Length = 0;
}

// From X2Effect_Persistent
function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityToHitCalc_StandardAim ToHitCalc, SubToHitCalc;
	local ShotBreakdown Breakdown;
	local ShotModifierInfo Modifier;
	local AvailableTarget kTarget;
	local int idx;

	AbilityTemplate = AbilityState.GetMyTemplate();
	ToHitCalc = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);

	if (ToHitCalc == none)
		return;

	// If XMBAbilityToHitCalc_StandardAim (from XModBase/Classes/) is available, it will handle 
	// everything, so return early.
	if (ToHitCalc.IsA('XMBAbilityToHitCalc_StandardAim'))
		return;

	// We want to make sure that other XMBEffect_Extended's effects are not included in our 
	// calculation. Luckily, A2AbilityToHitCalc.HitModifiers is unused, so we use it as a flag to 
	// indicate we are in a sub-calculation.
	if (ToHitCalc.HitModifiers.Length > 0)
		return;
	ToHitCalc.HitModifiers.Length = 1;

	// We do something very strange and magical here: we do the entire hit calc ahead of time, in
	// order to see what the results would be without our modifiers. Then we use those results to
	// figure out what modifiers we should return to get the correct final result.

	// We need to allocate a new ToHitCalc to avoid clobbering the breakdown of the one being 
	// calculated.
	SubToHitCalc = new ToHitCalc.Class(ToHitCalc);

	kTarget.PrimaryTarget = Target.GetReference();
	SubToHitCalc.GetShotBreakdown(AbilityState, kTarget, Breakdown);

	// The shot breakdown from GetShotBreakdown has graze chance multiplied by hit chance, and other
	// changes we don't want, so recompute the breakdown table based on the raw modifiers.
	for (idx = 0; idx < eHit_MAX; idx++)
		Breakdown.ResultTable[idx] = 0;
	foreach Breakdown.Modifiers(Modifier)
		Breakdown.ResultTable[Modifier.ModType] += Modifier.Value;

	// If we are supposed to be preventing critical hits, add a modifier to cancel out the entire
	// critical hit chance.
	if (CannotBeCrit(EffectState, Attacker, Target, AbilityState))
	{
		Modifier.ModType = eHit_Crit;
		Modifier.Value = -max(Breakdown.ResultTable[eHit_Crit], 0);
		Modifier.Reason = FriendlyName;
		ShotModifiers.AddItem(Modifier);
	}

	// We used HitModifiers as a flag earlier, so reset it.
	ToHitCalc.HitModifiers.Length = 0;
}