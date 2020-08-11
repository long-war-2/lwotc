//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_PermanentStatChange.uc
//  AUTHOR:  xylthixlm
//
//  An effect which permanently changes a unit's base stats.
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  ReverseEngineering
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
class XMBEffect_PermanentStatChange extends X2Effect implements(XMBEffectInterface);

var array<StatChange> StatChanges;

simulated function AddStatChange(ECharStatType StatType, float StatAmount, optional ECharStatModApplicationRule ApplicationRule = ECSMAR_Additive )
{
	local StatChange NewChange;
	
	NewChange.StatType = StatType;
	NewChange.StatAmount = StatAmount;
	NewChange.ApplicationRule = ApplicationRule;

	StatChanges.AddItem(NewChange);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit NewUnit;
	local StatChange Change;
	
	NewUnit = XComGameState_Unit(kNewTargetState);
	if (NewUnit == none)
		return;

	foreach StatChanges(Change)
	{
		NewUnit.SetBaseMaxStat(Change.StatType, NewUnit.GetBaseStat(Change.StatType) + Change.StatAmount, Change.ApplicationRule);
	}
}

// From XMBEffectInterface
function bool GetExtModifiers(name Type, XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, optional ShotBreakdown ShotBreakdown, optional out array<ShotModifierInfo> ShotModifiers) { return false; }
function bool GetExtValue(LWTuple Tuple) { return false; }

// From XMBEffectInterface
function bool GetTagValue(name Tag, XComGameState_Ability AbilityState, out string TagValue)
{
	local int stat, idx;

	stat = class'XMBConfig'.default.m_aCharStatTags.Find(Tag);
	if (stat != INDEX_NONE)
	{
		idx = StatChanges.Find('StatType', ECharStatType(stat));
		if (idx != INDEX_NONE)
		{
			TagValue = string(int(StatChanges[idx].StatAmount));
			return true;
		}
	}

	return false;
}
