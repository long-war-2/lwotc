

//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_OverwatchMark.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: This "marks" the target unit with a unit value containing the source's ID. the idea is that source unit 
//   can only fire overwatch shots at targets containing said ID
//
//---------------------------------------------------------------------------------------
class X2Effect_OverwatchMark extends X2Effect;


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit SourceUnit,TargetUnit;
    local name ValueName;
    SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    ValueName = name("OverwatchMark" $ SourceUnit.ObjectID);
    TargetUnit.SetUnitFloatValue (ValueName, 1.0, eCleanup_EndTurn);


	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}