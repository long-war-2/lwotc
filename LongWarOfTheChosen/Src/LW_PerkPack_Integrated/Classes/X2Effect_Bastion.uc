///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Bastion
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements AoE Damage immunities for Bastion, based on Solace ability
//---------------------------------------------------------------------------------------
class X2Effect_Bastion extends X2Effect_Persistent config(LW_SoldierSkills);

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config float BASTION_DISTANCE_SQ;

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	
	if (SourceUnit == none || SourceUnit.IsDead() || TargetUnit == none || TargetUnit.IsDead())
		return false;

	if (SourceUnit.ObjectID != TargetUnit.ObjectID)
	{
		`PPTRACE("Bastion: Distance =" @ SourceUnit.TileDistanceBetween(TargetUnit));
		//  jbouscher: uses tile range rather than unit range so the visual check can match this logic
		if (!class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetUnit.TileLocation, default.BASTION_DISTANCE_SQ))
			return false;
	}

	return true;
}

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	local XComGameState_Unit TargetUnit;

	if(class'X2Effect_Fortress'.default.DamageImmunities.Find(DamageType) != INDEX_NONE)
	{
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		return IsEffectCurrentlyRelevant(EffectState, TargetUnit);
	}
	return false;
}

//keeping same XComPerkContent Particle FX for now
function OnUnitChangedTile(const out TTile NewTileLocation, XComGameState_Effect EffectState, XComGameState_Unit TargetUnit)
{
	local XComWorldData WorldData;
	local XComGameStateHistory History;
	local XComGameState_Unit SourceUnit, CurrentTargetUnit;
	local XGUnit SourceXGUnit;
	local XComGameState_Effect OtherEffect;
	local bool bAddTarget;
	local int i;
	local bool bHazard;
	local XComUnitPawnNativeBase SourcePawn;
	local array<XComPerkContentInst> Perks;
	local array<XGUnit> Targets;
	local array<vector> Locations;
	local PerkActivationData PerkActivationData;

	//first handle the passive little effects, like Solace, that trigger when unit enters/leaves range

	History = `XCOMHISTORY;
	if (TargetUnit.ObjectID != EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID)
	{
		SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		if (SourceUnit != none && SourceUnit.IsAlive() && TargetUnit.IsAlive())
		{
			bAddTarget = class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, NewTileLocation, default.BASTION_DISTANCE_SQ);
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
				CurrentTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityInputContext.MultiTargets[i].ObjectID));
				OtherEffect = CurrentTargetUnit.GetUnitAffectedByEffectState(default.EffectName);
				if (OtherEffect != none)
				{
					bAddTarget = class'Helpers'.static.IsTileInRange(NewTileLocation, CurrentTargetUnit.TileLocation, default.BASTION_DISTANCE_SQ);
					OtherEffect.UpdatePerkTarget(bAddTarget);
				}
			}
		}
	}

	//update FX for unit entering a hazard tile
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if(class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, NewTileLocation, default.BASTION_DISTANCE_SQ))
	{
		WorldData = `XWORLD;
		//  assumes DamageImmunities includes Fire, Acid, and Poison
		bHazard = WorldData.TileContainsAcid(NewTileLocation) || WorldData.TileContainsFire(NewTileLocation) || WorldData.TileContainsPoison(NewTileLocation);

		SourceXGUnit = XGUnit( History.GetVisualizer( EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID ) );

		if (SourceXGUnit != none)
		{
			SourcePawn = SourceXGUnit.GetPawn( );

			class'XComPerkContent'.static.GetAssociatedPerkInstances( Perks, SourcePawn, EffectState.ApplyEffectParameters.AbilityInputContext.AbilityTemplateName );
			
			for (i = 0; i < Perks.Length; ++i)
			{
				if (bHazard && Perks[ i ].IsInState('Idle'))
				{
					Targets.Length = 0;
					Locations.Length = 0;
					PerkActivationData.TargetUnits = Targets;
					PerkActivationData.TargetLocations = Locations;
					// WOTC TODO: Not sure if the change here will work. There's a distinct difference in arguments
					//Perks[ i ].OnPerkActivation(SourceXGUnit, Targets, Locations, false);
					Perks[ i ].OnPerkActivation(PerkActivationData);
				}
				else if (!bHazard && Perks[ i ].IsInState('ActionActive'))
				{
					Perks[ i ].OnPerkDeactivation( );
				}
			}
		}
	}
}

DefaultProperties
{
	EffectName="Bastion"
	DuplicateResponse=eDupe_Ignore
}