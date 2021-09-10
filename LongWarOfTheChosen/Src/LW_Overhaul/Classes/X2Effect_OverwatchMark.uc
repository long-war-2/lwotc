

//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_OverwatchMark.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: This "marks" the target unit with a unit value containing the source's ID. the idea is that source unit 
//   can only fire overwatch shots at targets containing said ID
//
//---------------------------------------------------------------------------------------
class X2Effect_OverwatchMark extends X2Effect_Persistent;


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnit,TargetUnit;
    local name ValueName;

    
    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    TargetUnit = XComGameState_Unit(kNewTargetState);

    ValueName = name("OverwatchMark" $ SourceUnit.ObjectID);
    
    TargetUnit.SetUnitFloatValue (ValueName, 1.0, eCleanup_BeginTactical);


	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
    local XComGameState_Unit SourceUnit,TargetUnit;
    local name ValueName;

    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    ValueName = name("OverwatchMark" $ SourceUnit.ObjectID);

    TargetUnit.SetUnitFloatValue (ValueName, 0.0, eCleanup_BeginTactical);

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

}