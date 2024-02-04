//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ApplyDenseSmokeGrenadeToWorld.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This applies a special dense smoke effect to the world, which stacks with the regular smoke effect
//---------------------------------------------------------------------------------------
//POTENTIALLY DEPERECATED. LOOKING AT THIS I GUESS IT MAKES SMOKE GRENADES VISUALIZE DIFFERENTLY? NEVER SAW A DIFFERENCE
class X2Effect_ApplyDenseSmokeGrenadeToWorld extends X2Effect_World config(LW_SoldierSkills); // dependson(Helpers_LW);

var config string SmokeParticleSystemFill_Name;
var config int Duration;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
}

event array<X2Effect> GetTileEnteredEffects()
{
	local array<X2Effect> TileEnteredEffects;
	TileEnteredEffects.AddItem(class'X2Item_DenseSmokeGrenade'.static.DenseSmokeGrenadeEffect());
	return TileEnteredEffects;
}

event array<ParticleSystem> GetParticleSystem_Fill()
{
	local array<ParticleSystem> ParticleSystems;
	ParticleSystems.AddItem(none);
	ParticleSystems.AddItem(ParticleSystem(DynamicLoadObject(SmokeParticleSystemFill_Name, class'ParticleSystem')));
	return ParticleSystems;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, name EffectApplyResult)
{
	local X2Action_UpdateWorldEffects_Smoke AddSmokeAction;
	if( BuildTrack.StateObject_NewState.IsA('XComGameState_WorldEffectTileData') )
	{
		AddSmokeAction = X2Action_UpdateWorldEffects_Smoke(class'X2Action_UpdateWorldEffects_Smoke'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
		AddSmokeAction.bCenterTile = bCenterTile;
		AddSmokeAction.SetParticleSystems(GetParticleSystem_Fill());
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
}

static simulated function bool FillRequiresLOSToTargetLocation( ) { return !class'Helpers_LW'.default.bWorldSmokeGrenadeShouldDisableExtraLOSCheck; }

static simulated function int GetTileDataNumTurns() 
{ 
	return default.Duration; 
}

defaultproperties
{
	bCenterTile = true;
}