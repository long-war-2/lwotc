//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_VoidConduitPatch
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Fixes a bug with Void Conduit where targeted units aren't immobilized
//           for as long as they are supposed to be.
//--------------------------------------------------------------------------------------- 

class X2Effect_VoidConduitPatch extends X2Effect_Persistent;

var localized string ActionsLeftFlyoverText;

// This replicates the implementation in `X2Effect_PersistentVoidConduit`, but that
// function never gets called because the effect is removed on player turn begun,
// whereas `ModifyTurnStartActionPoints()` is called on *unit group turn begun*.
//
// This effect must tick on unit group turn begun to actually fix Void Conduit.
function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local UnitValue ActionsValue;
	local int Limit;

	UnitState.GetUnitValue(class'X2Effect_PersistentVoidConduit'.default.StolenActionsThisTick, ActionsValue);
	Limit = ActionsValue.fValue;

	if (Limit > ActionPoints.Length)
	{
		ActionPoints.Length = 0;
	}
	else
	{
		ActionPoints.Remove(0, Limit);
	}
}

// This is the same implementation as in `X2Effect_PersistentVoidConduit` to ensure this
// effect is removed on the same turn as that one. It does this by returning `true` once
// there are not Void Conduit actions left, which results in `InternalTickEffect()` cleaning
// up this persistent effect.
function bool TickVoidConduit(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit TargetUnit;
	local UnitValue ConduitValue;

	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit == none)
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	`assert(TargetUnit != none);

	TargetUnit.GetUnitValue(class'X2Effect_PersistentVoidConduit'.default.VoidConduitActionsLeft, ConduitValue);
	return ConduitValue.fValue <= 0;
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local XComGameState_Unit UnitState;
	local XGParamTag ParamTag;
	local string FlyoverText;

	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, RemovedEffect);

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ParamTag.IntValue0 = UnitState.NumAllActionPoints();
	FlyoverText = `XEXPAND.ExpandString(ActionsLeftFlyoverText);

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(none, FlyoverText, '', eColor_Bad);
}

defaultProperties
{
	EffectTickedFn = TickVoidConduit
}
