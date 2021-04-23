//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Effect_PersistentVoidConduit.uc    
//  AUTHOR:  Joshua Bouscher
//	DATE:    2/1/2017
//  PURPOSE: Persistent effect for the target of Void Conduit,
//			 keeps the unit impaired, restricts action points, etc.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2017 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2Effect_PersistentVoidConduit_LW extends X2Effect_PersistentVoidConduit;

var int NumTicks;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit, SourceUnit;

	TargetUnit = XComGameState_Unit(kNewTargetState);

	TargetUnit.TakeEffectDamage(self, InitialDamage, 0, 0, ApplyEffectParameters, NewGameState);

	//	get the previous version of the source unit to record the correct focus level
	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID, , NewGameState.HistoryIndex - 1));
	`assert(SourceUnit != none);	

	TargetUnit.SetUnitFloatValue(VoidConduitActionsLeft, NumTicks, eCleanup_BeginTactical);
	TargetUnit.SetUnitFloatValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 1);
}