//---------------------------------------------------------------------------------------
//  FILE:    X2LWModTemplate_ReaperAbilities.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing ability templates related to Reaper soldiers.
//---------------------------------------------------------------------------------------
class X2LWModTemplate_ReaperAbilities extends X2LWTemplateModTemplate config(LW_FactionBalance);

var config int SHADOW_DURATION;
var config float SHADOW_DETECTION_RANGE_REDUCTION;

var config int REMOTE_START_CHARGES;
var config int REMOTE_START_DEMOLITIONIST_CHARGES;

static function UpdateAbilities(X2AbilityTemplate Template, int Difficulty)
{
	switch (Template.DataName)
	{
	case 'ShadowPassive':
		RemoveShadowStayConcealedEffect(Template);
		break;
	case 'Shadow':
		MakeShadowTemporary(Template);
		break;
	case 'ThrowClaymore':
	case 'ThrowDistraction':
		PatchClaymoreTargeting(Template);
		break;
	case 'HomingMineDetonation':
		AddDistractionToHomingMine(Template);
		break;
	case 'BloodTrail':
		AddBleedingToBloodTrail(Template);
		break;
	case 'RemoteStart':
		ConvertRemoteStartToCharges(Template);
		break;
	case 'Sting':
		UpdateStingForNewShadow(Template);
		break;
	case 'SilentKiller':
		UpdateSilentKillerForNewShadow(Template);
		break;
	case 'ShadowRising':
		UpdateShadowRisingForNewShadow(Template);
		break;
	}
}

static function RemoveShadowStayConcealedEffect(X2AbilityTemplate Template)
{
	local X2Effect_PersistentStatChange StatChangeEffect;
	local int i;

	for (i = Template.AbilityTargetEffects.Length - 1; i >= 0 ; i--)
	{
		if (Template.AbilityTargetEffects[i].IsA('X2Effect_StayConcealed'))
		{
			Template.AbilityTargetEffects.Remove(i, 1);
			continue;
		}

		// Disable the EffectRemoved function that resets Shadow's cooldown when
		// concealment is lost.
		StatChangeEffect = X2Effect_PersistentStatChange(Template.AbilityTargetEffects[i]);
		if (StatChangeEffect != none)
		{
			StatChangeEffect.EffectRemovedFn = none;
			continue;
		}
	}
}

static function MakeShadowTemporary(X2AbilityTemplate Template)
{
	local X2Effect_PersistentStatChange StealthyEffect;
	local X2Effect_Shadow ShadowEffect;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown Cooldown;
	local int i;

	// Kill the charges and the charge cost
	Template.AbilityCosts.Length = 0;
	Template.AbilityCharges = none;

	// Killing the above results in some collateral damage so we have to re-add the action point costs
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Shadow doesn't have a cooldown by default (it's managed by an EffectRemoved
	// function instead). So add one now.
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = class'X2Ability_ReaperAbilitySet'.default.ShadowCooldown;
	Template.AbilityCooldown = Cooldown;

	// Disable the EffectRemoved function that resets Shadow's cooldown when
	// concealment is lost.
	for (i = 0; i < Template.AbilityTargetEffects.Length; i++)
	{
		ShadowEffect = X2Effect_Shadow(Template.AbilityTargetEffects[i]);
		if (ShadowEffect != none)
		{
			ShadowEffect.EffectRemovedFn = none;
			break;
		}
	}

	StealthyEffect = new class'X2Effect_PersistentStatChange';
	StealthyEffect.EffectName = 'TemporaryShadowConcealment';
	StealthyEffect.BuildPersistentEffect(default.SHADOW_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	// StealthyEffect.SetDisplayInfo (ePerkBuff_Bonus,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	StealthyEffect.AddPersistentStatChange(eStat_DetectionModifier, default.SHADOW_DETECTION_RANGE_REDUCTION);
	StealthyEffect.bRemoveWhenTargetDies = true;
	StealthyEffect.EffectAddedFn = EnterSuperConcealment;
	StealthyEffect.EffectRemovedFn = ShadowExpired;
	Template.AddTargetEffect(StealthyEffect);

	Template.AdditionalAbilities.AddItem('RemoveShadowOnConcealmentLostTrigger');
}

static function EnterSuperConcealment(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Ability ShadowAbility;
	local StateObjectReference ShadowRef;

	UnitState = XComGameState_Unit(kNewTargetState);
	UnitState.bHasSuperConcealment = true;

	// Copied with some modifications from X2Ability_ReaperAbilitySet.ShadowEffectRemoved()
	//
	// Find the Shadow ability on the current unit and reduce its cooldown if the unit has
	// the Shadow Rising ability.
	if (!UnitState.HasSoldierAbility('ShadowRising'))
		return;

	ShadowRef = UnitState.FindAbility('Shadow');
	if (ShadowRef.ObjectID > 0)
	{
		ShadowAbility = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ShadowRef.ObjectID));
		if (ShadowAbility == none)
		{
			ShadowAbility = XComGameState_Ability(NewGameState.ModifyStateObject(class'XComGameState_Ability', ShadowRef.ObjectID));
		}
	}
	else
	{
		`RedScreen("Could not find shadow ability to trigger its cooldown. @jbouscher @gameplay");
		return;
	}

	ShadowAbility.iCooldown -= 1;
}

static function ShadowExpired(
	X2Effect_Persistent PersistentEffect,
	const out EffectAppliedData ApplyEffectParameters,
	XComGameState NewGameState,
	bool bCleansed)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	`XEVENTMGR.TriggerEvent('ShadowExpired', UnitState, UnitState, NewGameState);
	`XEVENTMGR.TriggerEvent('EffectBreakUnitConcealment', UnitState, UnitState, NewGameState);
}

// Use a custom cursor targeting for Claymores so we can add Bombardier
// range bonus if the unit has the ability.
static function PatchClaymoreTargeting(X2AbilityTemplate Template)
{
	local X2AbilityTarget_Cursor ClaymoreTarget;
	local X2AbilityTarget_Cursor_LW NewClaymoreTarget;

	// Copy the essential values from the original targeting object
	ClaymoreTarget = X2AbilityTarget_Cursor(Template.AbilityTargetStyle);
	NewClaymoreTarget = new class'X2AbilityTarget_Cursor_LW';
	NewClaymoreTarget.bRestrictToWeaponRange = ClaymoreTarget.bRestrictToWeaponRange;
	NewClaymoreTarget.FixedAbilityRange = ClaymoreTarget.FixedAbilityRange;

	// Configure the new targeting so it grants the bonus range from
	// the Bombardier ability.
	NewClaymoreTarget.AddAbilityRangeModifier(
		'Bombard_LW',
		`TILESTOMETERS(class'X2Ability_PerkPackAbilitySet'.default.BOMBARD_BONUS_RANGE_TILES));
	Template.AbilityTargetStyle = NewClaymoreTarget;
}

// Allow Distraction to add the disorient effect to homing mines, not just
// Claymores.
static function AddDistractionToHomingMine(X2AbilityTemplate Template)
{
	local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Condition_AbilityProperty DistractionCondition;

	DistractionCondition = new class'X2Condition_AbilityProperty';
	DistractionCondition.OwnerHasSoldierAbilities.AddItem('Distraction_LW');
	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
	DisorientedEffect.TargetConditions.AddItem(DistractionCondition);
	Template.AddMultiTargetEffect(DisorientedEffect);
}

static function AddBleedingToBloodTrail(X2AbilityTemplate Template)
{
	Template.AddTargetEffect(new class'X2Effect_BloodTrailBleeding');
	Template.AdditionalAbilities.AddItem('ApplyBloodTrailBleeding');
}

static function ConvertRemoteStartToCharges(X2AbilityTemplate Template)
{
	local X2AbilityCost_Charges ChargeCost;
	local X2AbilityCharges_BonusCharges Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Charges = new class'X2AbilityCharges_BonusCharges';
	Charges.InitialCharges = default.REMOTE_START_CHARGES;
	Charges.BonusAbility = 'Demolitionist';
	Charges.BonusChargesCount = default.REMOTE_START_DEMOLITIONIST_CHARGES;
	Template.AbilityCharges = Charges;
}

static function UpdateStingForNewShadow(X2AbilityTemplate Template)
{
	local X2AbilityCost_ActionPoints ActionPointCost;

	// Kill the charges and the charge cost
	Template.AbilityCosts.Length = 0;
	Template.AbilityCharges = none;

	// Killing the above results in some collateral damage so we have to re-add the action point costs
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Can be used a maximum once per turn
	Template.AbilityCooldown.iNumTurns = 1;
}

static function UpdateSilentKillerForNewShadow(X2AbilityTemplate Template)
{
	local X2Effect_SilentKiller SilentKillerEffect;
	local int i;

	// Silent Killer won't reduce Shadow's cooldown for now. May revisit this
	// at a later date.
	// Template.AdditionalAbilities.AddItem('SilentKillerCooldownReduction');

	// Disable the EffectRemoved function that resets Shadow's cooldown when
	// concealment is lost.
	for (i = 0; i < Template.AbilityTargetEffects.Length; i++)
	{
		SilentKillerEffect = X2Effect_SilentKiller(Template.AbilityTargetEffects[i]);
		if (SilentKillerEffect != none)
		{
			Template.AbilityTargetEffects[i] = new class'X2Effect_SilentKiller_LW'(SilentKillerEffect);
			break;
		}
	}
}

static function UpdateShadowRisingForNewShadow(X2AbilityTemplate Template)
{
	Template.AddTargetEffect(new class'X2Effect_ShadowRising_LW');
}

defaultproperties
{
	AbilityTemplateModFn=UpdateAbilities
}
