//---------------------------------------------------------------------------------------
//  FILE:    XMBEffect_RevealUnit.uc
//  AUTHOR:  xylthixlm (modified by Peter Ledbrook)
//  PURPOSE: Displays units in visual range but out of line of sight as if they
//           have Target Definition on them. The Target Definition outline
//           disappears when the unit is in line of sight or the effect is
//           removed from the unit.
//
// Original behavior:
//  Causes a unit to be visible on the map, and plays a flyover over any revealed
//  enemy units when applied. Does not grant squadsight targeting over the revealed
//  units. Optionally this can also unmask hidden Faceless and Chryssalids. If a
//  revealed unit is in the fog of war it may be difficult to actually see.
//
//  USAGE
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  None.
//---------------------------------------------------------------------------------------
class XMBEffect_RevealUnit extends X2Effect_Persistent;


///////////////////////
// Effect properties //
///////////////////////

var float LookAtDuration;					// The duration the camera will look at the flyover.
var bool bRevealConcealed;					// If true, reveal hidden Faceless and burrowed Chryssalids.


////////////////////
// Implementation //
////////////////////

function EffectAddedCallback(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local X2EventManager EventMan;
	local XComGameState_Unit UnitState;

	if (!bRevealConcealed)
		return;

	EventMan = `XEVENTMGR;
	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		if (UnitState.AffectedByEffectNames.Find(class'X2AbilityTemplateManager'.default.BurrowedName) != INDEX_NONE)
		{
			UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.UnburrowActionPoint);
		}
		EventMan.TriggerEvent(class'X2Effect_ScanningProtocol'.default.ScanningProtocolTriggeredEventName, kNewTargetState, kNewTargetState, NewGameState);
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_TargetDefinition OutlineAction;
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (EffectApplyResult == 'AA_Success' && UnitState != none)
	{
		OutlineAction = X2Action_TargetDefinition(class'X2Action_TargetDefinition'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		OutlineAction.bEnableOutline = true;
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local X2Action_TargetDefinition OutlineAction;

	if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		OutlineAction = X2Action_TargetDefinition(class'X2Action_TargetDefinition'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		OutlineAction.bEnableOutline = false;
	}
}

simulated function AddX2ActionsForVisualization_Sync( XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local X2Action_TargetDefinition OutlineAction;

	if (XComGameState_Unit(ActionMetadata.StateObject_NewState) != none)
	{
		OutlineAction = X2Action_TargetDefinition(class'X2Action_TargetDefinition'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		OutlineAction.bEnableOutline = true;
	}
}

DefaultProperties
{
	EffectName="Tracking"
	DuplicateResponse=eDupe_Ignore
	EffectAddedFn=EffectAddedCallback
	LookAtDuration=1.0f
	bRevealConcealed=false
}
