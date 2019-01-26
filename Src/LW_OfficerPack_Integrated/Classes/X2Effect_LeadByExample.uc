//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_LeadByExample
//  AUTHOR:  Amineri 
//  PURPOSE: Grants bonus stats based on relative difference between source and target
//--------------------------------------------------------------------------------------- 
class X2Effect_LeadByExample extends X2Effect_ModifyStats;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit;
	local XComGameState_Unit TargetUnit;
	//local StatChange LeadByExampleChange;
	//local int StatAmount;
	local bool UpdatedOffense, UpdatedWill, UpdatedHacking;

	SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit == none)
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnit != none);

	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit == none)
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	`assert(TargetUnit != none);

	if (!IsEffectCurrentlyRelevant(NewEffectState, TargetUnit))
	{
		NewEffectState.RemoveEffect(NewGameState, NewGameState, false, true);
		return;
	}

	UpdatedWill = UpdateStat(NewEffectState, eStat_Will, SourceUnit, TargetUnit);
	UpdatedOffense = UpdateStat(NewEffectState, eStat_Offense, SourceUnit, TargetUnit);
	UpdatedHacking = UpdateStat(NewEffectState, eStat_Hacking, SourceUnit, TargetUnit);

	if (UpdatedWill || UpdatedOffense || UpdatedHacking)
	{
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	}
}

simulated function bool UpdateStat(out XComGameState_Effect NewEffectState, ECharStatType StatType, XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit)
{
	local StatChange LeadByExampleChange;
	local int StatAmount;
	if (SourceUnit.GetBaseStat(StatType) > TargetUnit.GetBaseStat(StatType))
	{
		StatAmount = (SourceUnit.GetBaseStat(StatType) - TargetUnit.GetBaseStat(StatType) + 1) / 2;
		LeadByExampleChange.StatType = StatType;
		LeadByExampleChange.StatAmount = StatAmount;
		NewEffectState.StatChanges.AddItem(LeadByExampleChange);
		return true;
	}
	return false;
}

simulated function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
	// expand on this if ever allow multiple officers
	return true;
	//return IsEffectCurrentlyRelevant(ExistingEffect, XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ExistingEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID)));
}

simulated simulated function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	
	if (SourceUnit == none || SourceUnit.IsDead() || TargetUnit == none || TargetUnit.IsDead())
		return false;

	if (SourceUnit.ObjectID != TargetUnit.ObjectID)
	{
		//  jbouscher: uses tile range rather than unit range so the visual check can match this logic
		if (!class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetUnit.TileLocation, class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(SourceUnit), 10))
			return false;
	}

	return true;
}

DefaultProperties
{
	EffectName=LeadByExample
	DuplicateResponse=eDupe_Refresh 
	bRemoveWhenSourceDies=true;
}