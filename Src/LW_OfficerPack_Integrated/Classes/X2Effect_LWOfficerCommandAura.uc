//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_LWOfficerCommandAura
//  AUTHOR:  Amineri 
//  PURPOSE: Adds range-based "aura" effect for LW officer
//				Based on base-game Solace ability/effect
//--------------------------------------------------------------------------------------- 
class X2Effect_LWOfficerCommandAura extends X2Effect_Persistent;

var XComGameState_Unit OfficerSource;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	//cache officer source unit for later checks
	OfficerSource = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	local XComGameState_Unit SourceUnit;

	if (EffectGameState != none)
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit == none)
		SourceUnit = OfficerSource;

	if (UnitCannotAcceptAura(SourceUnit) || UnitCannotAcceptAura(TargetUnit) ||
		SourceUnit.GetReference().ObjectID == TargetUnit.GetReference().ObjectID)
		return false;

	if (SourceUnit.ObjectID != TargetUnit.ObjectID)
	{
		//`Log("Checking range from " $ SourceUnit.GetFullName() @ "to " $ TargetUnit.GetFullName());
		//  uses tile range rather than unit range so the visual check can match this logic
		if (!class'Helpers'.static.IsTileInRange(SourceUnit.TileLocation, TargetUnit.TileLocation, class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(SourceUnit), 10))
		{
			//`Log("Not in range");
			return false;
		}

	}
	//`Log("In Range");
	return true;
}

simulated function bool UnitCannotAcceptAura(XComGameState_Unit Unit)
{
	if (Unit == none) return true;
	if (Unit.IsBleedingOut()) return true;
	if (Unit.IsStasisLanced()) return true;
	if (Unit.IsUnconscious()) return true;
	if (Unit.IsBurning()) return true;
	if (Unit.IsConfused()) return true;
	if (Unit.IsDisoriented()) return true;
	if (Unit.IsPoisoned()) return true;
	if (Unit.IsInStasis()) return true;
	if (Unit.IsImpaired()) return true;
	if (Unit.IsPanicked()) return true;
	if (Unit.IsStunned()) return true;
	if (Unit.IsMindControlled()) return true;
	if (Unit.IsDead()) return true;
	return false;
}

defaultproperties
{
	DuplicateResponse=eDupe_Ignore
	bRemoveWhenSourceDies=false;
}