//---------------------------------------------------------------------------------------
//  FILE:    XMBValue_Visibility.uc
//  AUTHOR:  xylthixlm
//
//  An XMBValue that counts the number of other units a unit can see.
//
//  USAGE
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  AgainstTheOdds
//	TacticalSense
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  XMBValue.uc
//---------------------------------------------------------------------------------------
class XMBValue_Visibility extends XMBValue;

var bool bCountEnemies, bCountAllies, bCountNeutrals;
var bool bSquadsight;

var array<X2Condition> RequiredConditions;		// A filter for which units will be counted. By
												// default, counts living visible units. Other
												// possible filters are defined in 
												// X2TacticalVisibilityHelpers.uc.
			

simulated function int CountVisibleUnitsForUnit(XComGameState_Unit SourceState, int HistoryIndex = -1)
{
	local X2GameRulesetVisibilityManager VisibilityMgr;	
	local array<StateObjectReference> VisibleUnits;
	local StateObjectReference UnitRef;
	local int Count;

	VisibilityMgr = `TACTICALRULES.VisibilityMgr;

	//Set default conditions (visible units need to be alive and game play visible) if no conditions were specified
	if( RequiredConditions.Length == 0 )
	{
		RequiredConditions = class'X2TacticalVisibilityHelpers'.default.LivingGameplayVisibleFilter;
	}

	if (bSquadsight)
		class'X2TacticalVisibilityHelpers'.static.GetAllVisibleObjectsForPlayer(SourceState.ControllingPlayer.ObjectID, VisibleUnits, RequiredConditions, HistoryIndex);
	else
		VisibilityMgr.GetAllVisibleToSource(SourceState.ObjectID, VisibleUnits, class'XComGameState_Unit', HistoryIndex, RequiredConditions);

	foreach VisibleUnits(UnitRef)
	{
		if (SourceState.TargetIsEnemy(UnitRef.ObjectID, HistoryIndex))
		{
			if (bCountEnemies) Count++;
		}
		else if (SourceState.TargetIsAlly(UnitRef.ObjectID, HistoryIndex))
		{
			if (bCountAllies) Count++;
		}
		else
		{
			if (bCountNeutrals) Count++;
		}
	}

	return Count;
}

function float GetValue(XComGameState_Effect EffectState, XComGameState_Unit UnitState, XComGameState_Unit TargetState, XComGameState_Ability AbilityState)
{
	return CountVisibleUnitsForUnit(UnitState);
}