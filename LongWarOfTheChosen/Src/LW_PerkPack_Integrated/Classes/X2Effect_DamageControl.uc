//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_DamageControl
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up armor bonuses for Damage Control effect
//---------------------------------------------------------------------------------------
class X2Effect_DamageControl extends X2Effect_BonusArmor;

var int BonusArmor;
var string Flyover;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return 100;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return BonusArmor;
}

//show a flyover on source
simulated function AddX2ActionsForVisualizationSource(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
    local XComGameState_Unit OldUnitState, NewUnitState;
    local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
    local EWidgetColor Colour;

    if (EffectApplyResult == 'AA_Success')
    {
        OldUnitState = XComGameState_Unit(ActionMetadata.StateObject_OldState);
        NewUnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
        if (OldUnitState != none && NewUnitState != none)
        {
          SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));

            //////////////==ADJUST PARAMS HERE========//////////////////////////////////////
            Colour = eColor_Good; //see UIUtililties_colors.uc ... for useable values
            //////////////==ADJUST PARAMS HERE========//////////////////////////////////////

            SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Flyover, '', Colour);
        }
     }
}
