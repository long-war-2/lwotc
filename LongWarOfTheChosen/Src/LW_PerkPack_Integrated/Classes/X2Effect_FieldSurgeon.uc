///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_FieldSurgeon
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for FieldSurgeon ability -- this allows healing of lowest hp at end of mission
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_FieldSurgeon extends X2Effect_Persistent config(LW_SoldierSkills);

//`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config array<int> FIELD_SURGEON_CHANCE_FOR_NUM_EFFECTS;
var name FieldSurgeonAppliedUnitValue;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	// Remove the default UnitRemovedFromPlay registered by XComGameState_Effect. This is necessary so we can
	// suppress the usual behavior of the effects being removed when a unit evacs. We can't process field surgeon
	// at that time because we could evac a wounded unit and then have the surgeon get killed on a later turn. We
	// need to wait until the mission ends and then process FS.
	`XEVENTMGR.UnRegisterFromEvent(EffectObj, 'UnitRemovedFromPlay');
}

function ApplyFieldSurgeon(XComGameState_Effect EffectState, XComGameState_Unit OrigUnitState, XComGameState NewGameState)
{
	local XComGameState_Unit		SourceUnitState, UnitState;
	local int						NumEffects;
	local UnitValue					AppliedFSValue;
	local bool						bApplyFieldSurgeon;

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(OrigUnitState.ObjectID));
	if (UnitState == none)
	{
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', OrigUnitState.ObjectID));
		NewGameState.AddStateObject(UnitState);
	}

	SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`PPTRACE("Field Surgeon: TargetUnit=" $ UnitState.GetFullName() $ ", SourceUnit=" $ SourceUnitState.GetFullName());

	if(!FieldSurgeonEffectIsValidForSource(SourceUnitState)) { return; }

	`PPTRACE("Field Surgeon: Source Unit Valid.");

	if(UnitState == none) { return; }
	if(UnitState.IsDead()) { return; }
	if(UnitState.IsBleedingOut()) { return; }
	if(!CanBeHealed(UnitState)) { return; }

	`PPTRACE("Field Surgeon: Target Unit Can Be Healed.");

	bApplyFieldSurgeon = false;
	NumEffects = 0;
	if(UnitState.GetUnitValue(default.FieldSurgeonAppliedUnitValue, AppliedFSValue))
	{
		`PPTRACE("Field Surgeon: FSValue Found, Value=" $ int(AppliedFSValue.fValue));
		NumEffects = int(AppliedFSValue.fValue);
		if(NumEffects >= default.FIELD_SURGEON_CHANCE_FOR_NUM_EFFECTS.Length)
			NumEffects = default.FIELD_SURGEON_CHANCE_FOR_NUM_EFFECTS.Length-1;
	}
	`PPTRACE("Field Surgeon: NumEffects=" $ NumEffects $ ", Chance=" $ default.FIELD_SURGEON_CHANCE_FOR_NUM_EFFECTS[NumEffects]);
	if(`SYNC_RAND(100) < default.FIELD_SURGEON_CHANCE_FOR_NUM_EFFECTS[NumEffects])
		bApplyFieldSurgeon = true;

	`PPTRACE("Field Surgeon: ApplyFieldSurgeon=" $ bApplyFieldSurgeon);

	if(bApplyFieldSurgeon)
	{
		`PPTRACE("Field Surgeon : Pre update LowestHP=" $ UnitState.LowestHP);
		UnitState.LowestHP += 1;
		`PPTRACE("Field Surgeon : Post update LowestHP=" $ UnitState.LowestHP);

		// Armor HP may have already been removed, apparently healing the unit since we have not yet
		// executed EndTacticalHealthMod. We may only appear injured here for large injuries (or little
		// armor HP). Current HP is used in the EndTacticalHealthMod adjustment, so we should increase it
		// if it's less than the max, but don't exceed the max HP.
		if (UnitState.GetCurrentStat(eStat_HP) < UnitState.GetMaxStat(eStat_HP))
			UnitState.ModifyCurrentStat(eStat_HP, 1);
		UnitState.SetUnitFloatValue(default.FieldSurgeonAppliedUnitValue, AppliedFSValue.fValue + 1, eCleanup_BeginTactical);
	}
}

function bool CanBeHealed(XComGameState_Unit UnitState)
{
	// Note: Only test lowest/highest HP here: CurrentHP cannot be trusted in UnitEndedTacticalPlay because
	// armor HP may have already been removed, but we have not yet invoked the EndTacticalHealthMod adjustment.
	 return (UnitState.LowestHP < UnitState.HighestHP && UnitState.LowestHP > 0);
}

function bool FieldSurgeonEffectIsValidForSource(XComGameState_Unit SourceUnit)
{
	if(SourceUnit == none) { return false; }
	if(SourceUnit.IsDead()) { return false; }
	if(SourceUnit.IsBleedingOut()) { return false; }
	if(SourceUnit.bCaptured) { return false; }
	if(SourceUnit.LowestHP == 0) { return false; }
	if(SourceUnit.IsUnconscious()) { return false; }
	return true;
}

DefaultProperties
{
	EffectName="FieldSurgeon"
	DuplicateResponse=eDupe_Allow
	FieldSurgeonAppliedUnitValue="FieldSurgeonHealed"
}
