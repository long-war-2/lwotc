//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_LWAdditionalSmokeEffect.uc
//  AUTHOR:  Merist
//  PURPOSE: Pseudo-interface for effects that should apply to units in the area of the smoke grenades.
//           Expects effect-specific X2Effect_LWApplyAdditionalSmokeEffectToWorld classes to be present.
//---------------------------------------------------------------------------------------
class X2Effect_LWAdditionalSmokeEffect extends X2Effect_Persistent config(LW_SoldierSkills) abstract;

var protectedwrite name RelevantAbilityName;
var class<X2Effect_LWApplyAdditionalSmokeEffectToWorld> WorldEffectClass;

var localized string strEffectBonusName;
var localized string strEffectBonusDesc;

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return TargetUnit.IsInWorldEffectTile(default.WorldEffectClass.Name);
}

static function SmokeGrenadeVisualizationTickedOrRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local X2Action_UpdateUI UpdateUIAction;

    UpdateUIAction = X2Action_UpdateUI(class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
    UpdateUIAction.SpecificID = ActionMetadata.StateObject_NewState.ObjectID;
    UpdateUIAction.UpdateType = EUIUT_UnitFlag_Buffs;
}

defaultproperties
{
    DuplicateResponse = eDupe_Refresh
    // EffectTickedVisualizationFn = SmokeGrenadeVisualizationTickedOrRemoved;
    // EffectRemovedVisualizationFn = SmokeGrenadeVisualizationTickedOrRemoved;

    WorldEffectClass = class'X2Effect_LWApplyAdditionalSmokeEffectToWorld'
}