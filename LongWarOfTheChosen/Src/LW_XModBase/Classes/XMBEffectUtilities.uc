//---------------------------------------------------------------------------------------
//  FILE:    XMBEffectUtilities.uc
//  AUTHOR:  xylthixlm
//
//  Utility functions used by various XModBase effects. You shouldn't need to use these
//  unless you are writing your own XMB-style effect.
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  None.
//---------------------------------------------------------------------------------------
class XMBEffectUtilities extends object;

// Returns true if this is an on-post-begin-play trigger on the second or later part of a multi-
// part mission. Used to avoid giving duplicates of effects that naturally persist through a
// multi-part mission, such as additional ability charges.
static function bool SkipForDirectMissionTransfer(const out EffectAppliedData ApplyEffectParameters)
{
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local int Priority;

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (!BattleData.DirectTransferInfo.IsDirectMissionTransfer)
		return false;

	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (!AbilityState.IsAbilityTriggeredOnUnitPostBeginTacticalPlay(Priority))
		return false;

	return true;
}

// Checks a list of target conditions for an ability.
function static name CheckTargetConditions(out array<X2Condition> AbilityTargetConditions, XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState)
{
	local X2Condition kCondition;
	local XComGameState_Item SourceWeapon;
	local StateObjectReference ItemRef;
	local name AvailableCode;
		
	foreach AbilityTargetConditions(kCondition)
	{
		if (kCondition.IsA('XMBCondition_MatchingWeapon'))
		{
			SourceWeapon = AbilityState.GetSourceWeapon();
			if (SourceWeapon == none || EffectState == none)
				return 'AA_WeaponIncompatible';

			ItemRef = EffectState.ApplyEffectParameters.ItemStateObjectRef;
			if (SourceWeapon.ObjectID != ItemRef.ObjectID && SourceWeapon.LoadedAmmo.ObjectID != ItemRef.ObjectID)
				return 'AA_WeaponIncompatible';
		}

		AvailableCode = kCondition.AbilityMeetsCondition(AbilityState, Target);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;

		AvailableCode = kCondition.MeetsCondition(Target);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
		
		AvailableCode = kCondition.MeetsConditionWithSource(Target, Attacker);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	}

	return 'AA_Success';
}

// Checks a list of shooter conditions for an ability.
function static name CheckShooterConditions(out array<X2Condition> AbilityShooterConditions, XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState)
{
	local X2Condition kCondition;
	local name AvailableCode;
		
	foreach AbilityShooterConditions(kCondition)
	{
		AvailableCode = kCondition.MeetsCondition(Attacker);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	}

	return 'AA_Success';
}
