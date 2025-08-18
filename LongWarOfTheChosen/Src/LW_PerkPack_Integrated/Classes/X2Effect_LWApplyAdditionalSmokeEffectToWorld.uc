//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_LWApplyAdditionalSmokeEffectToWorld.uc
//  AUTHOR:  Merist
//  PURPOSE: A mirror of the smoke world effect. Has no visualization or particales.
//           Used to add and validate additional effects on movement.
//---------------------------------------------------------------------------------------
class X2Effect_LWApplyAdditionalSmokeEffectToWorld extends X2Effect_World abstract;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
}

event array<ParticleSystem> GetParticleSystem_Fill()
{
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
}

static simulated function bool FillRequiresLOSToTargetLocation( )
{
    return !class'CHHelpers'.default.DisableExtraLOSCheckForSmoke; 
}

static simulated function int GetTileDataNumTurns() 
{ 
    return class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration;
}

defaultproperties
{
    bCenterTile = true;
}