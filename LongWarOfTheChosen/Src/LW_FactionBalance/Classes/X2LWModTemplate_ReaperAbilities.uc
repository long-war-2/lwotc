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

var config bool DISABLE_SHADOW_CHANGES;

var config int BLOOD_TRAIL_ANTIDODGE_BONUS;

var config int PALE_HORSE_BASE_CRIT;
var config int PALE_HORSE_PER_KILL_CRIT;
var config int PALE_HORSE_MAX_CRIT;

var config int STING_RUPTURE;

var config int BANISH_COOLDOWN;
var const name BanishFiredTimes;

var config int DEATH_DEALER_CRIT;

static function UpdateAbilities(X2AbilityTemplate Template, int Difficulty)
{
	switch (Template.DataName)
	{
	case 'ThrowClaymore':
	case 'ThrowDistraction':
		PatchClaymoreTargeting(Template);
		break;
	case 'HomingMineDetonation':
		AddDistractionToHomingMine(Template);
		break;
	case 'BloodTrail':
		ReplaceBloodTrailEffect(Template);
		break;
	case 'RemoteStart':
		ConvertRemoteStartToCharges(Template);
		break;
	case 'HomingMine':
		Template.AdditionalAbilities.AddItem('Shrapnel');
		break;
	case 'Shrapnel':
		// Prevent Homing Mines granting Claymore charges.
		Template.AdditionalAbilities.RemoveItem('ThrowShrapnel');
		break;
	case 'PaleHorse':
		UpdateEffectForPaleHorse(Template);
		break;
	case 'Executioner':
		ReplaceDeathDealerEffect(Template);
		break;
	}

	if (!default.DISABLE_SHADOW_CHANGES)
	{
		switch (Template.DataName)
		{
		case 'ShadowPassive':
			RemoveShadowStayConcealedEffect(Template);
			break;
		case 'Shadow':
			MakeShadowTemporary(Template);
			Template.AdditionalAbilities.AddItem('Infiltration');
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
		case 'SoulReaper':
			UpdateBanish(Template);
			break;
		case 'SoulReaperContinue':
			UpdateBanish2(Template);
			break;
		}
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

	Template.AddTargetEffect(CreateTemporaryShadowEffect());
	Template.AdditionalAbilities.AddItem('RemoveShadowOnConcealmentLostTrigger');
}

static function X2Effect_PersistentStatChange CreateTemporaryShadowEffect()
{
	local X2Effect_PersistentStatChange StealthyEffect;

	StealthyEffect = new class'X2Effect_PersistentStatChange';
	StealthyEffect.EffectName = 'TemporaryShadowConcealment';
	StealthyEffect.BuildPersistentEffect(default.SHADOW_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	// StealthyEffect.SetDisplayInfo (ePerkBuff_Bonus,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	StealthyEffect.AddPersistentStatChange(eStat_DetectionModifier, default.SHADOW_DETECTION_RANGE_REDUCTION);
	StealthyEffect.bRemoveWhenTargetDies = true;
	StealthyEffect.DuplicateResponse = eDupe_Refresh;
	StealthyEffect.EffectAddedFn = EnterSuperConcealment;
	StealthyEffect.EffectRemovedFn = ShadowExpired;

	return StealthyEffect;
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

// Replaces the old Blood Trail effect with a new one that includes
// an anti-dodge bonus.
static function ReplaceBloodTrailEffect(X2AbilityTemplate Template)
{
	local X2Effect_BloodTrail_LW Effect;
	local int i;

	// Remove the previous Blood Trail effect
	for (i = Template.AbilityTargetEffects.Length - 1; i >= 0 ; i--)
	{
		if (Template.AbilityTargetEffects[i].IsA('X2Effect_BloodTrail'))
		{
			Template.AbilityTargetEffects.Remove(i, 1);
			break;
		}
	}

	Effect = new class'X2Effect_BloodTrail_LW';
	Effect.BonusDamage = class'X2Ability_ReaperAbilitySet'.default.BloodTrailDamage;
	Effect.DodgeReductionBonus = default.BLOOD_TRAIL_ANTIDODGE_BONUS;
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);
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

// Add holo + rupture to Sting
static function UpdateStingForNewShadow(X2AbilityTemplate Template)
{
	local X2Effect_Shredder WeaponDamageEffect;
	local X2Effect_HoloTarget HoloEffect;
	local X2AbilityTag AbilityTag;
	local int i;

	HoloEffect = new class'X2Effect_HoloTarget';
	HoloEffect.HitMod = class'X2Ability_GrenadierAbilitySet'.default.HOLOTARGET_BONUS;
	HoloEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	HoloEffect.bRemoveWhenTargetDies = true;
	HoloEffect.bUseSourcePlayerState = true;
	HoloEffect.bApplyOnHit = true;
	HoloEffect.bApplyOnMiss = true;

	AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
	AbilityTag.ParseObj = HoloEffect;

	HoloEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2Ability_GrenadierAbilitySet'.default.HoloTargetEffectName,
			`XEXPAND.ExpandString(class'X2Ability_GrenadierAbilitySet'.default.HoloTargetEffectDesc),
			"img:///UILibrary_PerkIcons.UIPerk_holotargeting", true);

	Template.AddTargetEffect(HoloEffect);

	// Add rupture to the apply weapon damage effect. Be careful! This
	// also has the weapon miss damage effect, which is of type
	// X2Effect_ApplyWeaponDamage, hence we check for the shredder effect.
	for (i = 0; i < Template.AbilityTargetEffects.Length; i++)
	{
		WeaponDamageEffect = X2Effect_Shredder(Template.AbilityTargetEffects[i]);
		if (WeaponDamageEffect != none)
		{
			WeaponDamageEffect.EffectDamageValue.Rupture = default.STING_RUPTURE;
		}
	}
}

static function UpdateSilentKillerForNewShadow(X2AbilityTemplate Template)
{
	local X2Effect_SilentKiller SilentKillerEffect;
	local int i;

	// Silent Killer has a chance to increase the duration of Shadow by one turn
	//Template.AdditionalAbilities.AddItem('SilentKillerDurationExtension');

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

static function UpdateEffectForPaleHorse(X2AbilityTemplate Template)
{
	local X2Effect_PaleHorse_LW NewPaleHorseEffect;
	local int i;

	// Remove the previous Pale Horse effect
	for (i = Template.AbilityTargetEffects.Length - 1; i >= 0 ; i--)
	{
		if (X2Effect_PaleHorse(Template.AbilityTargetEffects[i]) != none)
		{
			Template.AbilityTargetEffects.Remove(i, 1);
			break;
		}
	}

	// Now add the new one
	NewPaleHorseEffect = new class'X2Effect_PaleHorse_LW';
	NewPaleHorseEffect.BuildPersistentEffect(1, true, false, false);
	NewPaleHorseEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true, , Template.AbilitySourceName);
	NewPaleHorseEffect.BaseCritBonus = default.PALE_HORSE_BASE_CRIT;
	NewPaleHorseEffect.CritBoostPerKill = default.PALE_HORSE_PER_KILL_CRIT;
	NewPaleHorseEffect.MaxCritBoost = default.PALE_HORSE_MAX_CRIT;
	Template.AddTargetEffect(NewPaleHorseEffect);
}

static function ReplaceDeathDealerEffect(X2AbilityTemplate Template)
{
	local X2Effect_Executioner ExecutionerEffect;
	local int i;
	local X2Effect_ToHitModifier ToHitModifier;

	ToHitModifier = new class'X2Effect_ToHitModifier';
	ToHitModifier.BuildPersistentEffect(1, true, true, true);
	ToHitModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	ToHitModifier.AddEffectHitModifier(eHit_Crit, default.DEATH_DEALER_CRIT, Template.LocFriendlyName);
	Template.AddTargetEffect(ToHitModifier);

	// Remove the previous Pale Horse effect
	for (i = Template.AbilityTargetEffects.Length - 1; i >= 0 ; i--)
	{
		ExecutionerEffect = X2Effect_Executioner(Template.AbilityTargetEffects[i]);
		if (ExecutionerEffect != none)
		{
			Template.AbilityTargetEffects[i] = new class'X2Effect_DeathDealer_LW'(ExecutionerEffect);
			break;
		}
	}
}

static function UpdateBanish(X2AbilityTemplate Template)
{
	local X2AbilityCost Cost;
	local X2AbilityCooldown Cooldown;


	ChangeBanishHitCalc(Template);


	foreach Template.AbilityCosts(Cost)
	{
		if (Cost.isA('X2AbilityCost_Charges'))
		{
			Template.AbilityCosts.RemoveItem(Cost);
			break;
		}
	}

	Template.AbilityCharges = none;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BANISH_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
}

static function UpdateBanish2(X2AbilityTemplate Template)
{
	local X2Effect_BanishHitMod HitMod;

	ChangeBanishHitCalc(Template);

	HitMod = new class'X2Effect_BanishHitMod';
	HitMod.BuildPersistentEffect (1, true, true);
	Template.AddShooterEffect(HitMod);
}


static function ChangeBanishHitCalc(X2AbilityTemplate Template)
{
	local X2Effect_SetUnitValue BanishCount;

	X2AbilityToHitCalc_StandardAim(Template.AbilityToHitCalc).bAllowCrit = true;

	BanishCount = new class'X2Effect_IncrementUnitValue';
	BanishCount.UnitName = default.BanishFiredTimes;
	BanishCount.NewValueToSet = 1;
	BanishCount.CleanupType = eCleanup_BeginTurn;
	BanishCount.bApplyOnHit = true;
	BanishCount.bApplyOnMiss = true;
	Template.AddShooterEffect(BanishCount);
}
	
defaultproperties
{
	AbilityTemplateModFn=UpdateAbilities
	BanishFiredTimes = "BanishFiredTimes"
}
