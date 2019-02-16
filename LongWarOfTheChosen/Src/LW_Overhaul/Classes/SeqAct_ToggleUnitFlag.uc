//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ToggleUnitFlag.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Toggles a unit flag for a particular unit.
//---------------------------------------------------------------------------------------

class SeqAct_ToggleUnitFlag extends SequenceAction
    implements(X2KismetSeqOpVisualizer);

var private XComGameState_Unit Unit;
var private bool bEnable;

function ModifyKismetGameState(out XComGameState GameState) {}
event Activated() {}

function BuildVisualization(XComGameState GameState)
{
    local VisualizationActionMetadata ActionMetadata;
    local X2Action_ToggleUnitFlag ToggleUnitFlagAction;

    ActionMetadata.StateObject_OldState = Unit;
    ActionMetadata.StateObject_NewState = Unit;
    ToggleUnitFlagAction = X2Action_ToggleUnitFlag(class'X2Action_ToggleUnitFlag'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext(), false, ActionMetadata.LastActionAdded));
    ToggleUnitFlagAction.SetEnableFlag(bEnable);
}

defaultproperties
{
    ObjName="Toggle Unit Flag"

    bConvertedForReplaySystem=true
    bCanBeUsedForGameplaySequence=true

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=Unit,bWriteable=TRUE)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Enable Flag",PropertyName=bEnable,bWriteable=TRUE)
}
 