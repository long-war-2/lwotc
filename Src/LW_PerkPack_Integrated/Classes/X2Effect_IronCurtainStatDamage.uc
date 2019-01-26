//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_IronCurtainStatDamage
//  AUTHOR:  John Lumpkin (Pavonis Interactive) / Beaglerush
//  PURPOSE: Triggers Flyover
//--------------------------------------------------------------------------------------

class X2Effect_IronCurtainStatDamage extends X2Effect;

var localized string str_IronCurtainEffect;

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult)
{
    local X2Action_PlaySoundAndFlyOver SoundAndFlyover;

    if(EffectApplyResult != 'AA_Success')
    {
        return;
    }
    SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
    SoundAndFlyover.SetSoundAndFlyOverParameters(none, str_IronCurtainEffect, 'None', ecolor_Bad);
}
