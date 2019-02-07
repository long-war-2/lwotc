//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_LeadByExample_old
//  AUTHOR:  Amineri 
//  PURPOSE: Adds range-based "aura" effect for LeadByExample ability
//				Based on base-game Solace ability/effect
//--------------------------------------------------------------------------------------- 
class X2Effect_LeadByExample_old extends X2Effect_ModifyStats;

//original test implementation of LeadByExample which included the aura effects directly

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit;
	local XComGameState_Unit TargetUnit;
	local StatChange LeadByExampleChange;
	local int StatAmount;
	local bool UpdatedAnyStat;

	SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit == none)
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnit != none);

	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit == none)
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	`assert(TargetUnit != none);

	if (IsEffectCurrentlyRelevant(NewEffectState, TargetUnit))
	{
		UpdatedAnyStat = false;
		if (SourceUnit.GetBaseStat(eStat_Will) > TargetUnit.GetBaseStat(eStat_Will))
		{
			StatAmount = (SourceUnit.GetBaseStat(eStat_Will) - TargetUnit.GetBaseStat(eStat_Will) + 1) / 2;
			LeadByExampleChange.StatType = eStat_Will;
			LeadByExampleChange.StatAmount = StatAmount;
			//LeadByExampleChange.ModOp = MODOP_Addition;
			NewEffectState.StatChanges.AddItem(LeadByExampleChange);
			UpdatedAnyStat = true;
		}
		if (SourceUnit.GetBaseStat(eStat_Offense) > TargetUnit.GetBaseStat(eStat_Offense))
		{
			StatAmount = (SourceUnit.GetBaseStat(eStat_Offense) - TargetUnit.GetBaseStat(eStat_Offense) + 1) / 2;
			LeadByExampleChange.StatType = eStat_Offense;
			LeadByExampleChange.StatAmount = StatAmount;
			//LeadByExampleChange.ModOp = MODOP_Addition;
			NewEffectState.StatChanges.AddItem(LeadByExampleChange);
			UpdatedAnyStat = true;
		}
		if (UpdatedAnyStat) 
		{
			super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
		}
	}	

}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	
	if (SourceUnit == none || SourceUnit.IsDead() || TargetUnit == none || TargetUnit.IsDead())
		return false;

	if (SourceUnit.ObjectID != TargetUnit.ObjectID)
	{
		//  jbouscher: uses tile range rather than unit range so the visual check can match this logic
		if (!class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetUnit.TileLocation, class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(SourceUnit)))
			return false;
	}

	return true;
}

function OnUnitChangedTile(const out TTile NewTileLocation, XComGameState_Effect EffectState, XComGameState_Unit TargetUnit)
{
	local XComGameStateHistory History;
	local XComGameState_Unit SourceUnit;
	local XComGameState_Effect OtherEffect;
	local bool bAddTarget;
	local int i;

	History = `XCOMHISTORY;
	if (TargetUnit.ObjectID != EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID)
	{
		SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		if (SourceUnit != none && SourceUnit.IsAlive() && TargetUnit.IsAlive())
		{
			bAddTarget = class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, NewTileLocation, class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(SourceUnit));
			EffectState.UpdatePerkTarget(bAddTarget);
		}
	}
	else
	{
		//  When the source moves, check all other targets and update them
		SourceUnit = TargetUnit;
		for (i = 0; i < EffectState.ApplyEffectParameters.AbilityInputContext.MultiTargets.Length; ++i)
		{
			if (EffectState.ApplyEffectParameters.AbilityInputContext.MultiTargets[i].ObjectID != SourceUnit.ObjectID)
			{
				TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityInputContext.MultiTargets[i].ObjectID));
				OtherEffect = TargetUnit.GetUnitAffectedByEffectState(default.EffectName);
				if (OtherEffect != none)
				{
					bAddTarget = class'Helpers'.static.IsTileInRange(NewTileLocation, TargetUnit.TileLocation, class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(SourceUnit));
					OtherEffect.UpdatePerkTarget(bAddTarget);
				}
			}
		}
	}
}

DefaultProperties
{
	EffectName="LeadByExample_old"
	DuplicateResponse=eDupe_Ignore
}